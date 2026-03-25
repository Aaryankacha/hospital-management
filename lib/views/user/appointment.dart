import 'dart:async';
import 'package:src/blocs/auth/auth.bloc.dart';
import 'package:src/shared/custom_components.dart';
import 'package:src/shared/custom_style.dart';
import 'package:src/models/datamodel.dart';
import 'package:src/blocs/validators.dart';
import 'package:flutter/material.dart';
import 'package:src/shared/responsive_shell.dart';


class Appointment extends StatefulWidget {
  static const routeName = '/appointment';
  @override
  AppointmentState createState() => AppointmentState();
}

class AppointmentState extends State<Appointment> {
  bool spinnerVisible = false;
  bool messageVisible = false;
  String messageTxt = "";
  String messageType = "";
  final _formKey = GlobalKey<FormState>();
  AppointmentDataModel formData = AppointmentDataModel();
  
  final TextEditingController _appointmentDate = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _comments = TextEditingController();

  List<NavigationItem> _navItems = [];
  String userRole = 'patient';

  @override
  void initState() {
    super.initState();
    AuthBloc authBloc = AuthBloc();
    _getData(authBloc);
  }

  @override
  void dispose() {
    _appointmentDate.dispose();
    _name.dispose();
    _phone.dispose();
    _comments.dispose();
    super.dispose();
  }

  void _getData(AuthBloc authBloc) async {
    setState(() => spinnerVisible = true);
    try {
      if (authBloc.isSignedIn()) {
        final res = await authBloc.getUserData("appointments");
        final data = res?.data() as Map<String, dynamic>?;
        if (data != null) {
          setState(() {
            formData = AppointmentDataModel.fromJson(data);
            userRole = data['role'] ?? 'patient';
            _navItems = getNavigationItems(userRole);
            _updateControllers();
          });
        }
      }
    } catch (e) {
      // It's okay if no appointment exists yet
    } finally {
      setState(() => spinnerVisible = false);
    }
  }

  void _updateControllers() {
    if (formData.appointmentDate != null) _appointmentDate.text = formData.appointmentDate!;
    if (formData.name != null) _name.text = formData.name!;
    if (formData.phone != null) _phone.text = formData.phone!;
    if (formData.comments != null) _comments.text = formData.comments!;
  }

  Future _saveData() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => spinnerVisible = true);
    AuthBloc authBloc = AuthBloc();
    formData.status = "New";
    try {
      await authBloc.setUserData('appointments', formData);
      setState(() {
        messageVisible = true;
        messageType = "success";
        messageTxt = "Appointment request submitted successfully.";
      });
    } catch (e) {
      setState(() {
        messageVisible = true;
        messageType = "error";
        messageTxt = e.toString();
      });
    } finally {
      setState(() => spinnerVisible = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentNavItems = _navItems.isNotEmpty ? _navItems : getNavigationItems(userRole);
    int safeIndex = 0; // Appts
    
    return ResponsiveShell(
      currentIndex: safeIndex,
      onIndexChanged: (index) {
        if (currentNavItems[index].route != '/appointment') {
          Navigator.pushReplacementNamed(context, currentNavItems[index].route);
        }
      },
      items: currentNavItems,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text("Book Appointment"),
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              _buildBookingForm(),
              const SizedBox(height: 48),
              _buildUpcomingSummary(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Schedule a Visit", style: cHeaderText.copyWith(fontSize: 24)),
        const SizedBox(height: 4),
        Text("Request a consultation with our specialized medical staff", style: cBodyText),
      ],
    );
  }

  Widget _buildBookingForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Appointment Details", style: cHeaderText.copyWith(fontSize: 18)),
              const SizedBox(height: 24),
              TextFormField(
                controller: _appointmentDate,
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 1)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: const TimeOfDay(hour: 9, minute: 0),
                    );
                    if (time != null) {
                      final dt = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                      _appointmentDate.text = dt.toString().substring(0, 16);
                      formData.appointmentDate = dt.toString().substring(0, 16);
                    }
                  }
                },
                decoration: const InputDecoration(
                  labelText: "Date & Time",
                  prefixIcon: Icon(Icons.event_available_rounded),
                  hintText: "Select your preferred slot",
                ),
                validator: evalName,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _name,
                onChanged: (v) => formData.name = v,
                decoration: const InputDecoration(
                  labelText: "Patient Name",
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
                validator: evalName,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                onChanged: (v) => formData.phone = v,
                decoration: const InputDecoration(
                  labelText: "Contact Phone",
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                validator: evalPhone,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _comments,
                maxLines: 3,
                onChanged: (v) => formData.comments = v,
                decoration: const InputDecoration(
                  labelText: "Reason for Visit / Symptoms",
                  prefixIcon: Icon(Icons.notes_rounded),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 32),
              if (messageVisible) ...[
                CustomMessage(toggleMessage: true, toggleMessageType: messageType, toggleMessageTxt: messageTxt),
                const SizedBox(height: 20),
              ],
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: spinnerVisible ? null : _saveData,
                  icon: spinnerVisible 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.check_circle_outline_rounded),
                  label: const Text("CONFIRM BOOKING REQUEST"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Your Active Requests", style: cHeaderText.copyWith(fontSize: 18)),
        const SizedBox(height: 16),
        if (formData.appointmentDate != null)
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: cSecondaryAzure,
                child: const Icon(Icons.access_time_filled_rounded, color: cPrimaryBlue, size: 20),
              ),
              title: Text(formData.appointmentDate!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("Status: ${formData.status ?? 'Pending'}"),
              trailing: Chip(
                label: const Text("DETAILS", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                backgroundColor: cSecondaryAzure,
                labelStyle: const TextStyle(color: cPrimaryBlue),
              ),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(24),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withOpacity(0.1)),
            ),
            child: const Text("No upcoming appointments scheduled.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
          ),
      ],
    );
  }
}
