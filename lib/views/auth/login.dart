import 'dart:async';
import 'package:src/blocs/auth/auth.bloc.dart';
import 'package:src/shared/custom_components.dart';
import 'package:src/shared/custom_style.dart';
import 'package:src/models/datamodel.dart';
import 'package:src/blocs/validators.dart';
import 'package:src/shared/mock_data_seeder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LogIn extends StatefulWidget {
  static const routeName = '/login';
  @override
  LogInState createState() => LogInState();
}

class LogInState extends State<LogIn> {
  bool spinnerVisible = false;
  bool messageVisible = false;
  String messageTxt = "";
  String messageType = "";
  final _formKey = GlobalKey<FormState>();
  final model = LoginDataModel();
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _fetchData(AuthBloc authBloc, String loginType) async {
    setState(() => spinnerVisible = true);
    var userAuth;
    if (loginType == "Google") {
      userAuth = await authBloc.signInWithGoogle();
    } else {
      userAuth = await authBloc.signInWithEmail(model);
    }

    if (userAuth == "") {
      _showMessage("Login Successful", "success");
    } else {
      _showMessage(
          (userAuth == 'user-not-found')
              ? "No user found for that email."
              : ((userAuth == 'wrong-password')
                  ? "Wrong password provided for that user."
                  : "An unknown error has occurred."), "error");
    }
    setState(() => spinnerVisible = false);
  }

  void _logout(AuthBloc authBloc) async {
    setState(() {
      model.password = "";
      _passwordController.clear();
      spinnerVisible = true;
    });
    try {
      await authBloc.logout();
      _showMessage("Successfully logged out.", "success");
    } catch (e) {
      _showMessage(e.toString(), "error");
    } finally {
      setState(() => spinnerVisible = false);
    }
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
      body: authBloc.isSignedIn() ? _buildSignedInView(authBloc) : _buildLoginForm(authBloc),
    );
  }

  Widget _buildLoginForm(AuthBloc authBloc) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.local_hospital_rounded, color: cPrimaryBlue, size: 64),
            const SizedBox(height: 16),
            Text("HMS Pro", style: cHeaderText.copyWith(fontSize: 32, letterSpacing: -1)),
            Text("Unified Medical Management", style: cBodyText),
            const SizedBox(height: 48),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text("Welcome Back", style: cHeaderText.copyWith(fontSize: 20)),
                      const SizedBox(height: 8),
                      const Text("Please enter your credentials to continue", style: TextStyle(color: Colors.grey, fontSize: 13)),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: _emailController,
                        onChanged: (v) => model.email = v,
                        validator: evalEmail,
                        decoration: const InputDecoration(
                          labelText: "Email ID",
                          prefixIcon: Icon(Icons.alternate_email_rounded),
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
                          prefixIcon: Icon(Icons.lock_outline_rounded),
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
                        child: ElevatedButton(
                          onPressed: spinnerVisible ? null : () => _fetchData(authBloc, "email"),
                          child: spinnerVisible 
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Text("SIGN IN"),
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextButton.icon(
                        onPressed: () => _fetchData(authBloc, "Google"),
                        icon: const Icon(Icons.g_mobiledata_rounded, size: 32),
                        label: const Text("Sign in with Google"),
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
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/signup'),
                  child: const Text("Create Account", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignedInView(AuthBloc authBloc) {
    return FutureBuilder<DocumentSnapshot?>(
      future: authBloc.getData(),
      builder: (context, snapshot) {
        String role = 'patient';
        if (snapshot.hasData && snapshot.data!.exists) {
          role = (snapshot.data!.data() as Map<String, dynamic>)['role'] ?? 'patient';
        }

        return Center(
          child: Card(
            margin: const EdgeInsets.all(24),
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle_rounded, color: Colors.green, size: 60),
                  const SizedBox(height: 24),
                  const Text("Welcome to HMS Pro", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text("Logged in as: ${role.toUpperCase()}", style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        switch (role) {
                          case 'admin':
                          case 'doctor':
                            Navigator.pushReplacementNamed(context, '/admin');
                            break;
                          case 'nurse':
                            Navigator.pushReplacementNamed(context, '/admin', arguments: 2); // Vaccine/Records tab
                            break;
                          case 'scm':
                            Navigator.pushReplacementNamed(context, '/purchase');
                            break;
                          default:
                            Navigator.pushReplacementNamed(context, '/appointment');
                        }
                      },
                      icon: const Icon(Icons.dashboard_customize_rounded),
                      label: const Text("GO TO DASHBOARD"),
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () => _logout(authBloc),
                    style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 54)),
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text("LOGOUT"),
                  ),
                  _buildTestingTools(authBloc),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTestingTools(AuthBloc authBloc) {
    return Column(
      children: [
        const SizedBox(height: 48),
        const Divider(),
        const SizedBox(height: 24),
        const Text("Testing & QA Tools", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange.shade50,
            foregroundColor: Colors.orange.shade900,
            elevation: 0,
            minimumSize: const Size(double.infinity, 54),
          ),
          onPressed: () async {
            setState(() => spinnerVisible = true);
            await MockDataSeeder.seed();
            setState(() => spinnerVisible = false);
            _showMessage("Mock DB Populated! You are now Admin. Please logout and login again.", "success");
          },
          icon: const Icon(Icons.storage_rounded),
          label: const Text("SEED MOCK DATA (DEV ONLY)"),
        ),
      ],
    );
  }
}
