import 'dart:async';
import 'package:src/blocs/auth/auth.bloc.dart';
import 'package:src/shared/custom_components.dart';
import 'package:src/shared/custom_style.dart';
import 'package:src/models/datamodel.dart';
import 'package:src/blocs/validators.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:src/shared/responsive_shell.dart';

class Messages extends StatefulWidget {
  static const routeName = '/messages';
  @override
  MessagesState createState() => MessagesState();
}

class MessagesState extends State<Messages> {
  bool spinnerVisible = false;
  bool messageVisible = false;
  String messageTxt = "";
  String messageType = "";
  final _formKey = GlobalKey<FormState>();
  MessagesDataModel formData = MessagesDataModel();
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
      formData.messagesDate = DateTime.now().toString();
      await authBloc.setMessagesData(formData);
      _showMessage("Secure clinical message sent to patient portal.", "success");
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
          title: const Text("Clinical Messaging"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            TextButton.icon(
              onPressed: () => setState(() => displayPage = "DataEntry"),
              icon: const Icon(Icons.send_rounded),
              label: const Text("NEW MESSAGE"),
              style: TextButton.styleFrom(foregroundColor: displayPage == "DataEntry" ? cPrimaryBlue : Colors.grey),
            ),
            TextButton.icon(
              onPressed: () => setState(() => displayPage = "History"),
              icon: const Icon(Icons.history_rounded),
              label: const Text("OUTBOX"),
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
                    Text("Secure Communication to Patient", style: cHeaderText.copyWith(fontSize: 18)),
                    const SizedBox(height: 24),
                    TextFormField(
                      decoration: const InputDecoration(labelText: "Sender (Provider/Dept)", prefixIcon: Icon(Icons.support_agent_rounded)),
                      onChanged: (v) => formData.from = v,
                      validator: evalName,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      maxLines: 6,
                      decoration: const InputDecoration(labelText: "Clinical Message Content", alignLabelWithHint: true, prefixIcon: Icon(Icons.chat_bubble_outline_rounded)),
                      onChanged: (v) => formData.message = v,
                      validator: evalName,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: "Priority Level", prefixIcon: Icon(Icons.priority_high_rounded)),
                      items: ['Normal', 'Urgent', 'Emergency'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                      onChanged: (v) => formData.status = v,
                      validator: (v) => v == null ? 'Please select a priority' : null,
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
                          : const Icon(Icons.send_rounded),
                        label: const Text("SEND SECURE MESSAGE"),
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
              const Text("Sending encrypted clinical correspondence"),
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
      stream: authBloc.person.doc(formData.patientId).collection("Messages").orderBy('messageDate', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No message history with this patient."));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final data = doc.data() as Map<String, dynamic>;
            final date = _getFormattedDate(data['messageDate']);
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(backgroundColor: Colors.deepPurple.shade50, child: const Icon(Icons.message_rounded, color: Colors.deepPurple, size: 20)),
                title: Text("From: ${data['from']}"),
                subtitle: Text("Date: $date\nPriority: ${data['status']}"),
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
        title: const Text("Delete Message?"),
        content: const Text("This will permanently remove the message record."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
          TextButton(
            onPressed: () {
              authBloc.person.doc(formData.patientId).collection("Messages").doc(docId).delete();
              Navigator.pop(context);
            },
            child: const Text("DELETE", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
