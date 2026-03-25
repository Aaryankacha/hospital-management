import 'package:src/blocs/auth/auth.bloc.dart';
import 'package:src/shared/custom_components.dart';
import 'package:src/shared/custom_style.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:src/models/datamodel.dart';
import 'package:src/blocs/validators.dart';
import 'package:src/shared/responsive_shell.dart';


class Admin extends StatefulWidget {
  static const routeName = '/admin';
  @override
  AdminState createState() => AdminState();
}

class AdminState extends State<Admin> {
  int _currentIndex = 0;
  bool spinnerVisible = false;

  List<NavigationItem> _navItems = [];
  String userRole = 'admin'; // Default

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is int) {
      if (_currentIndex != args) {
        setState(() => _currentIndex = args);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    AuthBloc authBloc = AuthBloc();
    _fetchRole(authBloc);
  }

  void _fetchRole(AuthBloc authBloc) async {
    final res = await authBloc.getData();
    final data = res?.data() as Map<String, dynamic>?;
    if (data != null) {
      setState(() {
        userRole = data['role'] ?? 'admin'; // Keep original default 'admin'
        _navItems = getNavigationItems(userRole);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = AuthBloc();
    
    // Fallback nav items if not yet loaded
    final currentNavItems = _navItems.isNotEmpty ? _navItems : getNavigationItems(userRole);
    if (_currentIndex >= currentNavItems.length) _currentIndex = 0;
    
    return ResponsiveShell(
      currentIndex: _currentIndex,
      onIndexChanged: (index) {
        if (currentNavItems[index].route != '/admin') {
           Navigator.pushNamed(context, currentNavItems[index].route);
        } else {
          setState(() => _currentIndex = index);
        }
      },
      items: currentNavItems,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text(_currentIndex == 0 ? "${userRole.toUpperCase()} Dashboard" : "User Management"),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none_rounded),
              onPressed: () {},
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: _currentIndex == 0 ? _buildDashboard(context) : UserManagementView(),

      ),
    );
  }

  Widget _buildDashboard(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Healthcare Overview",
            style: cHeaderText.copyWith(fontSize: 24),
          ),
          const SizedBox(height: 8),
          Text(
            "Manage clinic operations and medical infrastructure",
            style: cBodyText,
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              if (userRole == 'admin' || userRole == 'doctor' || userRole == 'nurse')
                SizedBox(width: 170, child: _buildStatCard("Appointments", Icons.calendar_today, "12 Today", Colors.blue)),
              if (userRole == 'admin' || userRole == 'doctor')
                SizedBox(width: 170, child: _buildStatCard("Patient Records", Icons.folder_shared, "1.2k Total", Colors.green)),
              if (userRole == 'admin' || userRole == 'scm')
                SizedBox(width: 170, child: _buildStatCard("Pharmacy Stk", Icons.medication, "Low Warning", Colors.orange)),
              
              if (userRole == 'admin' || userRole == 'doctor')
                SizedBox(width: 170, child: _buildQuickAction(context, "Clinical Reports", Icons.bar_chart, '/reports')),
              if (userRole == 'admin')
                SizedBox(width: 170, child: _buildQuickAction(context, "User Management", Icons.people_alt_rounded, '/admin')),
              if (userRole == 'admin' || userRole == 'scm')
                SizedBox(width: 170, child: _buildQuickAction(context, "Supply Chain", Icons.inventory_2, '/purchase')),
              if (userRole == 'admin' || userRole == 'doctor' || userRole == 'nurse')
                SizedBox(width: 170, child: _buildQuickAction(context, "Staff Messages", Icons.chat_bubble_outline, '/messages')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, IconData icon, String subtitle, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 16),
            Text(title, style: cNavText.copyWith(color: Colors.black87)),
            const SizedBox(height: 4),
            Text(subtitle, style: cBodyText.copyWith(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, String title, IconData icon, String route) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      borderRadius: BorderRadius.circular(16),
      child: Card(
        color: cPrimaryBlue,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 32),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: cHeaderWhiteText.copyWith(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserManagementView extends StatefulWidget {
  @override
  _UserManagementViewState createState() => _UserManagementViewState();
}

class _UserManagementViewState extends State<UserManagementView> {
  final AuthBloc authBloc = AuthBloc();
  final CollectionReference users = FirebaseFirestore.instance.collection('users');
  bool srchVisible = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final SettingsDataModel formData = SettingsDataModel();

  void toggleSearch() {
    setState(() => srchVisible = !srchVisible);
  }

  void _showAddUserDialog() {
    String? newRole = 'patient';
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Add New User Profile"),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("This creates a system profile. The user must sign up with this email to access it.", 
                             style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: "Full Name", prefixIcon: Icon(Icons.person_outline)),
                    validator: evalName,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: emailCtrl,
                    decoration: const InputDecoration(labelText: "Email ID", prefixIcon: Icon(Icons.alternate_email)),
                    validator: evalEmail,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: phoneCtrl,
                    decoration: const InputDecoration(labelText: "Phone Number", prefixIcon: Icon(Icons.phone_outlined)),
                    validator: evalPhone,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: newRole,
                    decoration: const InputDecoration(labelText: 'System Role', prefixIcon: Icon(Icons.verified_user_outlined)),
                    onChanged: (v) => setDialogState(() => newRole = v),
                    items: <String>['admin', 'doctor', 'nurse', 'scm', 'patient']
                        .map((v) => DropdownMenuItem(value: v, child: Text(v.toUpperCase()))).toList(),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final email = emailCtrl.text.trim();
                  await users.doc(email).set({
                    'name': nameCtrl.text.trim(),
                    'email': email,
                    'phone': phoneCtrl.text.trim(),
                    'role': newRole,
                    'status': 'pending_verification',
                    'author': email, // Use email as temporary ID
                    'createdAt': FieldValue.serverTimestamp(),
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User profile created! They can now sign up.")));
                }
              },
              child: const Text("CREATE"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text("Manage Users", style: cHeaderText),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.person_add_rounded, color: cPrimaryBlue),
                onPressed: _showAddUserDialog,
              ),
              IconButton(
                icon: Icon(srchVisible ? Icons.close : Icons.search, color: cPrimaryBlue),
                onPressed: toggleSearch,
              ),
            ],
          ),
        ),
        if (srchVisible) _buildSearchForm(),
        Expanded(child: _buildUserList()),
      ],
    );
  }

  Widget _buildSearchForm() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Search Name", prefixIcon: Icon(Icons.person)),
              onChanged: (v) => formData.name = v,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Search Email", prefixIcon: Icon(Icons.email)),
              onChanged: (v) => formData.email = v,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: authBloc.users.limit(20).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final data = doc.data() as Map<String, dynamic>;
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: cSecondaryAzure,
                  child: Text(data['name']?[0] ?? '?', style: const TextStyle(color: cPrimaryBlue)),
                ),
                title: Text(data['name'] ?? 'No Name', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(data['role'] ?? 'No Role'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.admin_panel_settings_outlined, color: Colors.blue),
                      onPressed: () => Navigator.pushNamed(context, '/adminedit', arguments: ScreenArguments(data['author'] ?? '')),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Delete User?"),
                            content: const Text("Are you sure you want to remove this user profile? This action cannot be undone."),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
                              TextButton(
                                onPressed: () {
                                  authBloc.users.doc(doc.id).delete();
                                  Navigator.pop(context);
                                },
                                child: const Text("DELETE", style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
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
}
