import 'dart:async';
import 'package:src/blocs/auth/auth.bloc.dart';
import 'package:src/shared/custom_components.dart';
import 'package:src/shared/custom_style.dart';
import 'package:src/models/datamodel.dart';
import 'package:src/blocs/validators.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  static const routeName = '/signup';
  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  bool spinnerVisible = false;
  bool messageVisible = false;
  String messageTxt = "";
  String messageType = "";
  final _formKey = GlobalKey<FormState>();
  final model = LoginDataModel();
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _selectedRole = 'patient';
  final List<String> _roles = ['patient', 'doctor', 'nurse', 'scm', 'admin'];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _fetchData(AuthBloc authBloc) async {
    setState(() => spinnerVisible = true);
    var userAuth = await authBloc.signUpWithEmail(model, role: _selectedRole);
    if (userAuth == "") {
      _showMessage("Account created successfully. You can now login.", "success");
    } else {
      _showMessage(
          (userAuth == 'email-already-in-use')
              ? "This email is already registered."
              : ((userAuth == 'weak-password')
                  ? "Password is too weak."
                  : "An unknown error has occurred."), "error");
    }
    setState(() => spinnerVisible = false);
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
    AuthBloc authBloc = AuthBloc();
    return Scaffold(
      backgroundColor: cSecondaryAzure,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: cPrimaryBlue),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: authBloc.isSignedIn() ? _buildAlreadySignedInView() : _buildSignUpForm(authBloc),
    );
  }

  Widget _buildSignUpForm(AuthBloc authBloc) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const Icon(Icons.person_add_rounded, color: cPrimaryBlue, size: 64),
            const SizedBox(height: 16),
            Text("Create Account", style: cHeaderText.copyWith(fontSize: 28)),
            const Text("Join our secure medical network", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 48),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        onChanged: (v) => model.email = v,
                        validator: evalEmail,
                        decoration: const InputDecoration(
                          labelText: "Email ID",
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        onChanged: (v) => model.password = v,
                        validator: evalPassword,
                        decoration: const InputDecoration(
                          labelText: "Password",
                          prefixIcon: Icon(Icons.lock_person_outlined),
                        ),
                      ),
                      const SizedBox(height: 24),
                      DropdownButtonFormField<String>(
                        value: _selectedRole,
                        decoration: const InputDecoration(
                          labelText: "Register As",
                          prefixIcon: Icon(Icons.badge_outlined),
                        ),
                        items: _roles.map((r) => DropdownMenuItem(
                          value: r,
                          child: Text(r.toUpperCase()),
                        )).toList(),
                        onChanged: (v) => setState(() => _selectedRole = v!),
                      ),
                      const SizedBox(height: 32),
                      if (messageVisible) ...[
                        CustomMessage(toggleMessage: true, toggleMessageType: messageType, toggleMessageTxt: messageTxt),
                        const SizedBox(height: 20),
                      ],
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: spinnerVisible ? null : () => _fetchData(authBloc),
                          child: spinnerVisible 
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Text("REGISTER ACCOUNT"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  child: const Text("Sign In", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlreadySignedInView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.verified_user_rounded, color: Colors.green, size: 60),
          const SizedBox(height: 24),
          const Text("You already have an active profile"),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/settings'),
            child: const Text("GO TO PROFILE"),
          ),
        ],
      ),
    );
  }
}
