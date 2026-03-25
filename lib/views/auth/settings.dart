import 'dart:async';
import 'package:src/blocs/auth/auth.bloc.dart';
import 'package:src/shared/custom_components.dart';
import 'package:src/shared/custom_style.dart';
import 'package:src/models/datamodel.dart';
import 'package:src/blocs/validators.dart';
import 'package:flutter/material.dart';
import 'package:src/shared/responsive_shell.dart';


class Settings extends StatefulWidget {
  static const routeName = '/settings';
  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  bool spinnerVisible = false;
  bool messageVisible = false;
  bool isAdmin = false;
  String messageTxt = "";
  String messageType = "";
  final _formKey = GlobalKey<FormState>();
  SettingsDataModel formData = SettingsDataModel();
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    AuthBloc authBloc = AuthBloc();
    _getData(authBloc);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _getData(AuthBloc authBloc) async {
    setState(() => spinnerVisible = true);
    try {
      if (authBloc.isSignedIn()) {
        final res = await authBloc.getData();
        final data = res?.data() as Map<String, dynamic>?;
        if (data != null) {
          setState(() {
            formData = SettingsDataModel.fromJson(data);
            isAdmin = formData.role == "admin";
            _nameController.text = formData.name ?? '';
            _emailController.text = formData.email ?? '';
            _phoneController.text = formData.phone ?? '';
          });
        }
      }
    } catch (e) {
      // Handle error
    } finally {
      setState(() => spinnerVisible = false);
    }
  }

  Future _saveData() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => spinnerVisible = true);
    AuthBloc authBloc = AuthBloc();
    try {
      await authBloc.setData(formData);
      setState(() {
        messageVisible = true;
        messageType = "success";
        messageTxt = "Settings saved successfully.";
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
    // Determine nav items based on role
    final List<NavigationItem> navItems = getNavigationItems(formData.role ?? 'patient');

    return ResponsiveShell(
      currentIndex: -1, // Settings doesn't have a direct nav item usually
      onIndexChanged: (index) {
        Navigator.pushReplacementNamed(context, navItems[index].route);
      },
      items: navItems,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text("Account Settings"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacementNamed(context, isAdmin ? '/admin' : '/appointment');
              }
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              _buildSettingsForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: cSecondaryAzure,
                child: Text(formData.name?[0] ?? '?', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: cPrimaryBlue)),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: cPrimaryBlue, shape: BoxShape.circle),
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(formData.name ?? "User", style: cHeaderText.copyWith(fontSize: 22)),
          Text(formData.role?.toUpperCase() ?? "USER ACCESS", style: TextStyle(color: cPrimaryBlue, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildSettingsForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Basic Information", style: cHeaderText.copyWith(fontSize: 18)),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                onChanged: (v) => formData.name = v,
                decoration: const InputDecoration(labelText: "Display Name", prefixIcon: Icon(Icons.person_outline_rounded)),
                validator: evalName,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                onChanged: (v) => formData.email = v,
                decoration: const InputDecoration(labelText: "Email Address", prefixIcon: Icon(Icons.email_outlined)),
                validator: evalEmail,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                onChanged: (v) => formData.phone = v,
                decoration: const InputDecoration(labelText: "Phone Number", prefixIcon: Icon(Icons.phone_outlined)),
                validator: evalPhone,
              ),
              const SizedBox(height: 32),
              if (messageVisible) ...[
                CustomMessage(toggleMessage: true, toggleMessageType: messageType, toggleMessageTxt: messageTxt),
                const SizedBox(height: 20),
              ],
              SizedBox(
                width: 180,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: spinnerVisible ? null : _saveData,
                  icon: const Icon(Icons.check_circle_outline_rounded),
                  label: const Text("SAVE CHANGES"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
