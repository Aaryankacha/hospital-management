import 'package:src/blocs/auth/auth.bloc.dart';
import 'package:src/shared/custom_components.dart';
import 'package:src/shared/custom_style.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:src/models/datamodel.dart';
import 'package:src/blocs/validators.dart';
import 'package:src/shared/responsive_shell.dart';

class Appointments extends StatefulWidget {
  static const routeName = '/appointments';
  @override
  AppointmentsState createState() => AppointmentsState();
}

class AppointmentsState extends State<Appointments> {
  bool spinnerVisible = false;
  bool srchVisible = false;
  String dropDownValue = 'New';
  final _formKey = GlobalKey<FormState>();
  AppointmentDataModel formData = AppointmentDataModel();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  AuthBloc authBloc = AuthBloc();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    authBloc.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() => srchVisible = !srchVisible);
  }

  void _clearSearch() {
    setState(() {
      _nameController.clear();
      _phoneController.clear();
      formData.name = null;
      formData.phone = null;
      formData.status = 'New';
      dropDownValue = 'New';
    });
  }

  Stream<QuerySnapshot> _getData() {
    Query qry = authBloc.appointments;
    if (formData.name != null && formData.name!.isNotEmpty) {
      qry = qry.where('name', isEqualTo: formData.name);
    }
    if (formData.phone != null && formData.phone!.isNotEmpty) {
      qry = qry.where('phone', isEqualTo: formData.phone);
    }
    qry = qry.where('status', isEqualTo: dropDownValue);
    return qry.limit(20).snapshots();
  }

  Future<void> _completeAppointment(String docId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Complete Appointment?"),
        content: const Text("This will mark the patient's visit as finished and move it to history."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("CANCEL")),
          TextButton(
            onPressed: () => Navigator.pop(context, true), 
            child: const Text("CONFIRM"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => spinnerVisible = true);
      try {
        await FirebaseFirestore.instance.collection('appointments').doc(docId).update({"status": "Complete"});
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      } finally {
        setState(() => spinnerVisible = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveShell(
      currentIndex: 1, // Appts
      onIndexChanged: (index) {
        if (index == 0) Navigator.pushReplacementNamed(context, '/admin');
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
          title: const Text("Patient Queue"),
          actions: [
            IconButton(
              icon: Icon(srchVisible ? Icons.close_rounded : Icons.search_rounded),
              onPressed: _toggleSearch,
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Column(
          children: [
            if (srchVisible) _buildSearchPanel(),
            Expanded(child: _buildAppointmentsList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchPanel() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: "Patient Name", prefixIcon: Icon(Icons.person_search_rounded)),
                    onChanged: (v) => formData.name = v,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: "Phone Number", prefixIcon: Icon(Icons.phone_android_rounded)),
                    onChanged: (v) => formData.phone = v,
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: dropDownValue,
                      onChanged: (v) => setState(() => dropDownValue = v!),
                      items: ['New', 'Complete'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: _clearSearch, child: const Text("CLEAR FILTERS")),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => setState(() {}),
                  icon: const Icon(Icons.filter_list_rounded, size: 18),
                  label: const Text("APPLY FILTERS"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_busy_rounded, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text("No matching appointments found", style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final data = doc.data() as Map<String, dynamic>;
            final patientId = data['author'];

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data['name'] ?? 'Unknown Patient', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                              const SizedBox(height: 4),
                              Wrap(
                                spacing: 16,
                                runSpacing: 4,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.phone_enabled_rounded, size: 14, color: Colors.grey[600]),
                                      const SizedBox(width: 4),
                                      Text(data['phone'] ?? 'No phone', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.access_time_rounded, size: 14, color: Colors.grey[600]),
                                      const SizedBox(width: 4),
                                      Text(data['appointmentDate']?.toString() ?? '', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        _buildStatusBadge(data['status'] ?? 'New'),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider()),
                    if (data['comments'] != null && data['comments'].isNotEmpty) ...[
                      Text("Reason for visit:", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[700])),
                      const SizedBox(height: 4),
                      Text(data['comments'], style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic)),
                      const SizedBox(height: 16),
                    ],
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildActionChip(context, Icons.medical_services_rounded, "VACCINE", '/vaccine', patientId),
                        _buildActionChip(context, Icons.medical_services_rounded, "OPD/IPD", '/opd', patientId),
                        _buildActionChip(context, Icons.science_rounded, "LAB", '/lab', patientId),
                        _buildActionChip(context, Icons.medication_rounded, "Rx", '/rx', patientId),
                        _buildActionChip(context, Icons.message_rounded, "MSG", '/messages', patientId),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (data['status'] != 'Complete') 
                          ElevatedButton.icon(
                            onPressed: () => _completeAppointment(doc.id),
                            icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
                            label: const Text("MARK COMPLETE"),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green[50], foregroundColor: Colors.green[800], elevation: 0),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatusBadge(String status) {
    bool isComplete = status == 'Complete';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isComplete ? Colors.green[50] : Colors.blue[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: isComplete ? Colors.green[800] : Colors.blue[800], fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildActionChip(BuildContext context, IconData icon, String label, String route, String? patientId) {
    return InkWell(
      onTap: () => Navigator.pushReplacementNamed(context, route, arguments: ScreenArguments(patientId ?? '')),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: cPrimaryBlue),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: cPrimaryBlue)),
          ],
        ),
      ),
    );
  }
}
