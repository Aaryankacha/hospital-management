import 'dart:async';
import 'package:src/blocs/auth/auth.bloc.dart';
import 'package:src/shared/custom_components.dart';
import 'package:src/shared/custom_style.dart';
import 'package:src/models/datamodel.dart';
import 'package:src/blocs/validators.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:src/shared/responsive_shell.dart';

class OPD extends StatefulWidget {
  static const routeName = '/opd';
  @override
  OPDState createState() => OPDState();
}

class OPDState extends State<OPD> {
  bool spinnerVisible = false;
  bool messageVisible = false;
  String messageTxt = "";
  String messageType = "";
  final _formKey = GlobalKey<FormState>();
  OPDDataModel formData = OPDDataModel();
  String displayPage = "DataEntry";
  AuthBloc authBloc = AuthBloc();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _setPatientID());
  }

  @override
  void dispose() {
    authBloc.dispose();
    super.dispose();
  }

  void _setPatientID() {
    final ScreenArguments args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    setState(() {
      formData.patientId = args.patientID;
    });
  }

  Future _saveData() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => spinnerVisible = true);
    try {
      formData.opdDate = DateTime.now().toString();
      await authBloc.setOPDData(formData);
      _showMessage("OPD clinical record saved successfully.", "success");
    } catch (e) {
      _showMessage(e.toString(), "error");
    } finally {
      setState(() => spinnerVisible = false);
    }
  }

  String _getFormattedDate(dynamic date) {
    if (date == null) return "N/A";
    if (date is Timestamp) return date.toDate().toString().split(' ')[0];
    if (date is String) return date.split(' ')[0];
    return date.toString();
  }

  void _showMessage(String msg, String type) {
    setState(() {
      messageVisible = true;
      messageType = type;
      messageTxt = msg;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveShell(
      currentIndex: 0,
      onIndexChanged: (index) {
        if (index == 0) Navigator.pushReplacementNamed(context, '/admin');
        if (index == 1) Navigator.pushReplacementNamed(context, '/appointments');
        if (index == 2) Navigator.pushReplacementNamed(context, '/purchase');
        if (index == 3) Navigator.pushReplacementNamed(context, '/reports');
      },
      items: [
        NavigationItem(label: "Dash", icon: Icons.dashboard_outlined, selectedIcon: Icons.dashboard, route: '/admin'),
        NavigationItem(label: "Appts", icon: Icons.calendar_today_outlined, selectedIcon: Icons.calendar_today, route: '/appointments'),
        NavigationItem(label: "SCM", icon: Icons.inventory_2_outlined, selectedIcon: Icons.inventory_2, route: '/purchase'),
        NavigationItem(label: "Reports", icon: Icons.analytics_outlined, selectedIcon: Icons.analytics, route: '/reports'),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text("OPD Clinical Entry"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            TextButton.icon(
              onPressed: () => setState(() => displayPage = "DataEntry"),
              icon: const Icon(Icons.add_circle_outline_rounded),
              label: const Text("NEW ENTRY"),
              style: TextButton.styleFrom(foregroundColor: displayPage == "DataEntry" ? cPrimaryBlue : Colors.grey),
            ),
            TextButton.icon(
              onPressed: () => setState(() => displayPage = "History"),
              icon: const Icon(Icons.history_rounded),
              label: const Text("HISTORY"),
              style: TextButton.styleFrom(foregroundColor: displayPage == "History" ? cPrimaryBlue : Colors.grey),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: displayPage == "DataEntry" ? _buildDataEntry() : _buildHistory(),
      ),
    );
  }

  Widget _buildDataEntry() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPatientHeader(),
          const SizedBox(height: 32),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Clinical Diagnosis & Treatment", style: cHeaderText.copyWith(fontSize: 18)),
                    const SizedBox(height: 24),
                    TextFormField(
                      maxLines: 2,
                      decoration: const InputDecoration(labelText: "Symptoms", alignLabelWithHint: true, prefixIcon: Icon(Icons.sick_outlined)),
                      onChanged: (v) => formData.symptoms = v,
                      validator: evalName,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      maxLines: 2,
                      decoration: const InputDecoration(labelText: "Diagnosis", alignLabelWithHint: true, prefixIcon: Icon(Icons.search_rounded)),
                      onChanged: (v) => formData.diagnosis = v,
                      validator: evalName,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(labelText: "Prescription", prefixIcon: Icon(Icons.medication_rounded)),
                            onChanged: (v) => formData.rx = v,
                            validator: evalName,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(labelText: "Lab Tests", prefixIcon: Icon(Icons.science_rounded)),
                            onChanged: (v) => formData.lab = v,
                            validator: evalName,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      maxLines: 2,
                      decoration: const InputDecoration(labelText: "Treatment Plan", alignLabelWithHint: true, prefixIcon: Icon(Icons.healing_rounded)),
                      onChanged: (v) => formData.treatment = v,
                      validator: evalName,
                    ),
                    const SizedBox(height: 40),
                    if (messageVisible) ...[
                      CustomMessage(toggleMessage: true, toggleMessageType: messageType, toggleMessageTxt: messageTxt),
                      const SizedBox(height: 20),
                    ],
                    SizedBox(
                      width: 250,
                      height: 54,
                      child: ElevatedButton.icon(
                        onPressed: spinnerVisible ? null : _saveData,
                        icon: spinnerVisible 
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.save_rounded),
                        label: const Text("SUBMIT OPD RECORD"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: cSecondaryAzure, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: cPrimaryBlue, child: const Icon(Icons.person_rounded, color: Colors.white)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Patient ID: ${formData.patientId ?? 'Loading...'}", style: const TextStyle(fontWeight: FontWeight.bold, color: cPrimaryBlue)),
              const Text("Recording OPD diagnosis and prescription"),
            ],
          ),
          const Spacer(),
          OutlinedButton.icon(
            onPressed: () => Navigator.pushReplacementNamed(context, '/appointments'),
            icon: const Icon(Icons.arrow_back, size: 16),
            label: const Text("CANCEL"),
          ),
        ],
      ),
    );
  }

  Widget _buildHistory() {
    return StreamBuilder<QuerySnapshot>(
      stream: authBloc.person.doc(formData.patientId).collection("OPD").orderBy('opdDate', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No past OPD records for this patient."));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final data = doc.data() as Map<String, dynamic>;
            final date = _getFormattedDate(data['opdDate']);
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(backgroundColor: Colors.blue.shade50, child: Text("${index + 1}", style: const TextStyle(color: cPrimaryBlue, fontWeight: FontWeight.bold))),
                title: Text("Date: $date"),
                subtitle: Text("Diagnosis: ${data['diagnosis']}\nSymptoms: ${data['symptoms']}"),
                isThreeLine: true,
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                  onPressed: () => _confirmDelete(doc.id),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _confirmDelete(String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Record?"),
        content: const Text("Are you sure you want to remove this OPD entry?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
          TextButton(
            onPressed: () {
              authBloc.person.doc(formData.patientId).collection("OPD").doc(docId).delete();
              Navigator.pop(context);
            },
            child: const Text("DELETE", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
