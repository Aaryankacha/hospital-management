import 'dart:async';
import 'package:src/blocs/auth/auth.bloc.dart';
import 'package:src/shared/custom_components.dart';
import 'package:src/shared/custom_style.dart';
import 'package:src/models/datamodel.dart';
import 'package:src/blocs/validators.dart';
import 'package:flutter/material.dart';

class AdminEdit extends StatefulWidget {
  static const routeName = '/adminedit';
  @override
  AdminEditState createState() => AdminEditState();
}

class AdminEditState extends State<AdminEdit> {
  bool spinnerVisible = false;
  bool messageVisible = false;
  bool isAdmin = false;
  String messageTxt = "";
  String messageType = "";
  String dropDownRoleValue = 'none';
  final _formKey = GlobalKey<FormState>();
  SettingsDataModel formData = SettingsDataModel();
  bool _btnEnabled = false;
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    AuthBloc authBloc = AuthBloc();
    WidgetsBinding.instance.addPostFrameCallback((_) => this.getData(authBloc));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _authorController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  toggleSpinner() {
    setState(() => spinnerVisible = !spinnerVisible);
  }

  showMessage(bool msgVisible, msgType, message) {
    messageVisible = msgVisible;
    setState(() {
      messageType = msgType == "error"
          ? cMessageType.error.toString()
          : cMessageType.success.toString();
      messageTxt = message;
    });
  }

  getData(AuthBloc authBloc) async {
    final ScreenArguments args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    toggleSpinner();
    if (authBloc.isSignedIn()) {
      await authBloc
          .getDocData("users", args.patientID)
          .then((res) => setState(
              () => updateFormData(SettingsDataModel.fromJson(res.data()))))
          .catchError((error) =>
              showMessage(true, "error", "User information is not available."));
    } else {
      showMessage(true, "error", "An un-known error has occurred.");
    }
    toggleSpinner();
  }

  updateFormData(data) {
    formData = data;
    isAdmin = true;
    _nameController.text = formData.name ?? '';
    _emailController.text = formData.email ?? '';
    _authorController.text = formData.author ?? '';
    _roleController.text = formData.role ?? 'patient';
    
    // Ensure the role is one of the allowed dropdown values to prevent crash
    const allowedRoles = ['admin', 'doctor', 'nurse', 'scm', 'patient'];
    if (allowedRoles.contains(formData.role?.toLowerCase())) {
      dropDownRoleValue = formData.role!.toLowerCase();
    } else {
      dropDownRoleValue = 'patient'; // Default fallback
    }
    return false;
  }

  Future setData(AuthBloc authBloc) async {
    toggleSpinner();
    messageVisible = true;
    await authBloc
        .updData(formData)
        .then((res) => {showMessage(true, "success", "User profile updated.")})
        .catchError((error) => {showMessage(true, "error", error.toString())});
    toggleSpinner();
  }

  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = AuthBloc();
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Edit Professional Profile"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: authBloc.isSignedIn() ? _buildForm(authBloc) : _buildLoginPrompt(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginPrompt() {
    return Column(
      children: [
        const Icon(Icons.lock_outline_rounded, size: 64, color: Colors.grey),
        const SizedBox(height: 24),
        Text("Authentication Required", style: cHeaderText),
        const SizedBox(height: 32),
        ElevatedButton(
          child: const Text('Go to Login'),
          onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
        )
      ],
    );
  }

  Widget _buildForm(AuthBloc authBloc) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: () => setState(() => _btnEnabled = _formKey.currentState!.validate()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildHeader(),
          const SizedBox(height: 32),
          
          Text("Personal Information", style: cHeaderText.copyWith(fontSize: 18)),
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              prefixIcon: Icon(Icons.person_outline),
              hintText: 'Enter complete name',
            ),
            onChanged: (value) => formData.name = value,
            validator: evalName,
          ),
          const SizedBox(height: 24),
          
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Official Email',
              prefixIcon: Icon(Icons.email_outlined),
              hintText: 'name@hospital.com',
            ),
            onChanged: (value) => formData.email = value,
            validator: evalEmail,
          ),
          const SizedBox(height: 32),
          
          Text("Access Control", style: cHeaderText.copyWith(fontSize: 18)),
          const SizedBox(height: 16),
          
          DropdownButtonFormField<String>(
            value: dropDownRoleValue,
            decoration: const InputDecoration(
              labelText: 'System Role',
              prefixIcon: Icon(Icons.verified_user_outlined),
            ),
            onChanged: (String? newValue) {
              formData.role = newValue;
              setState(() => dropDownRoleValue = newValue ?? dropDownRoleValue);
            },
            items: <String>['admin', 'doctor', 'nurse', 'scm', 'patient']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value.toUpperCase(), style: const TextStyle(letterSpacing: 1.1)),
              );
            }).toList(),
          ),
          const SizedBox(height: 48),
          
          CustomSpinner(toggleSpinner: spinnerVisible),
          CustomMessage(
            toggleMessage: messageVisible,
            toggleMessageType: messageType,
            toggleMessageTxt: messageTxt
          ),
          
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _btnEnabled ? () => setData(authBloc) : null,
              child: const Text('SAVE CHANGES', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to Dashboard'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundColor: cSecondaryAzure,
          child: Text(formData.name?[0] ?? '?', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: cPrimaryBlue)),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("User Profile", style: cHeaderText.copyWith(fontSize: 20)),
            Text("Role: ${formData.role?.toUpperCase() ?? 'NONE'}", style: cBodyText.copyWith(color: cPrimaryBlue, fontWeight: FontWeight.bold)),
          ],
        )
      ],
    );
  }
}
