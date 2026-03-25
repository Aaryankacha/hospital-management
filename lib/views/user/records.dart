import 'dart:async';
import 'package:src/blocs/auth/auth.bloc.dart';
import 'package:src/shared/custom_components.dart';
import 'package:src/shared/custom_style.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:src/shared/responsive_shell.dart';


class Records extends StatefulWidget {
  static const routeName = '/records';
  @override
  RecordsState createState() => RecordsState();
}

class RecordsState extends State<Records> {
  FirebaseAuth auth = FirebaseAuth.instance;
  AuthBloc authBloc = AuthBloc();
  String displayPage = "Vaccine";

  List<NavigationItem> _navItems = [];
  String userRole = 'patient';

  @override
  void initState() {
    super.initState();
    _fetchRole();
  }

  void _fetchRole() async {
    final res = await authBloc.getData();
    final data = res?.data() as Map<String, dynamic>?;
    if (data != null) {
      setState(() {
        userRole = data['role'] ?? 'patient';
        _navItems = getNavigationItems(userRole);
      });
    }
  }

  @override
  void dispose() {
    authBloc.dispose();
    super.dispose();
  }

  Stream<QuerySnapshot> _getDataStream(String filter) {
    final uid = auth.currentUser!.uid;
    switch (filter) {
      case "Vaccine": return authBloc.person.doc(uid).collection("Vaccine").snapshots();
      case "OPD": return authBloc.person.doc(uid).collection("OPD").snapshots();
      case "Rx": return authBloc.person.doc(uid).collection("Rx").snapshots();
      case "Lab": return authBloc.person.doc(uid).collection("Lab").snapshots();
      case "Messages": return authBloc.person.doc(uid).collection("Messages").snapshots();
      case "Person": return authBloc.person.where("author", isEqualTo: uid).snapshots();
      default: return authBloc.person.doc(uid).collection("Vaccine").snapshots();
    }
  }

  String _getFormattedDate(dynamic date) {
    if (date == null) return "N/A";
    if (date is Timestamp) return date.toDate().toString().split(' ')[0];
    if (date is String) return date.split(' ')[0];
    return date.toString();
  }

  @override
  Widget build(BuildContext context) {
    final currentNavItems = _navItems.isNotEmpty ? _navItems : getNavigationItems(userRole);
    int safeIndex = 2; // Records
    
    return ResponsiveShell(
      currentIndex: safeIndex,
      onIndexChanged: (index) {
        if (currentNavItems[index].route != '/records') {
          Navigator.pushReplacementNamed(context, currentNavItems[index].route);
        }
      },
      items: currentNavItems,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text("Medical History"),
          actions: [
            IconButton(icon: const Icon(Icons.picture_as_pdf_rounded), onPressed: () {}),
            const SizedBox(width: 8),
          ],
        ),

        body: Column(
          children: [
            _buildCategorySelector(),
            Expanded(
              child: _buildRecordsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    final categories = [
      {'id': 'Vaccine', 'label': 'Vaccines', 'icon': Icons.healing_rounded},
      {'id': 'OPD', 'label': 'OPD', 'icon': Icons.medical_services_rounded},
      {'id': 'Rx', 'label': 'Pharmacy', 'icon': Icons.medication_rounded},
      {'id': 'Lab', 'label': 'Lab Results', 'icon': Icons.biotech_rounded},
      {'id': 'Person', 'label': 'Timeline', 'icon': Icons.history_rounded},
    ];

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = displayPage == cat['id'];
          return ChoiceChip(
            label: Text(cat['label'] as String),
            avatar: Icon(cat['icon'] as IconData, size: 16, color: isSelected ? Colors.white : cPrimaryBlue),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) setState(() => displayPage = cat['id'] as String);
            },
          );
        },
      ),
    );
  }

  Widget _buildRecordsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _getDataStream(displayPage),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index].data() as Map<String, dynamic>;
            return _buildRecordCard(doc, index);
          },
        );
      },
    );
  }

  Widget _buildRecordCard(Map<String, dynamic> data, int index) {
    String title = "";
    String date = "";
    String subtitle = "";
    IconData icon = Icons.article_rounded;
    Color color = cPrimaryBlue;

    if (displayPage == "Vaccine") {
      title = "Vaccination Dose";
      date = data['appointmentDate'] ?? "N/A";
      subtitle = "Next Dose: ${data['newAppointmentDate'] ?? 'Not scheduled'}";
      icon = Icons.vaccines_rounded;
      color = Colors.teal;
    } else if (displayPage == "OPD") {
      title = "Outpatient Visit";
      date = _getFormattedDate(data['opdDate']);
      subtitle = "${data['diagnosis'] ?? 'Checkup'}\nRx: ${data['rx'] ?? 'None'}";
      icon = Icons.medical_services_outlined;
      color = Colors.blue;
    } else if (displayPage == "Rx") {
      title = "Prescription Refill";
      date = _getFormattedDate(data['rxDate']);
      subtitle = "Source: ${data['from'] ?? 'Hospital'}\nStatus: ${data['status'] ?? 'Active'}";
      icon = Icons.medication_liquid_rounded;
      color = Colors.orange;
    } else if (displayPage == "Lab") {
      title = "Laboratory Report";
      date = _getFormattedDate(data['labDate']);
      subtitle = "Test: ${data['lab'] ?? 'Diagnostic'}\nResult: ${data['results'] ?? 'Pending'}";
      icon = Icons.biotech_rounded;
      color = Colors.purple;
    } else {
      title = "Personal Update";
      date = data['dob'] ?? "N/A";
      subtitle = "Profile change or administrative update";
      icon = Icons.person_search_rounded;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTimelineNode(color, index == 0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0, left: 16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                            child: Text(date, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                          Icon(icon, color: color.withOpacity(0.3)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text(subtitle, style: cBodyText.copyWith(height: 1.4)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.visibility_outlined, size: 16),
                            label: const Text("View Details"),
                          ),
                          const Spacer(),
                          IconButton(icon: const Icon(Icons.more_vert_rounded), onPressed: () {}),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineNode(Color color, bool isFirst) {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        Expanded(
          child: Container(
            width: 2,
            color: Colors.grey[300],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_rounded, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 24),
          Text("No Records Found", style: cHeaderText.copyWith(color: Colors.grey[400])),
          const SizedBox(height: 8),
          Text("Your medical history for this category is empty", style: cBodyText),
        ],
      ),
    );
  }
}
