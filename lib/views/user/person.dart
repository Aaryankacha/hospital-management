import 'dart:async';
import 'package:src/blocs/auth/auth.bloc.dart';
import 'package:src/shared/custom_components.dart';
import 'package:src/shared/custom_style.dart';
import 'package:src/models/datamodel.dart';
import 'package:src/blocs/validators.dart';
import 'package:flutter/material.dart';
import 'package:src/shared/responsive_shell.dart';


class Person extends StatefulWidget {
  static const routeName = '/person';
  @override
  PersonState createState() => PersonState();
}

class PersonState extends State<Person> {
  bool spinnerVisible = false;
  bool messageVisible = false;
  String messageTxt = "";
  String messageType = "";
  final _formKey = GlobalKey<FormState>();
  PersonDataModel formData = PersonDataModel();
  
  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _medicalHistoryController = TextEditingController();
  final TextEditingController _raceController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _zipcodeController = TextEditingController();
  final TextEditingController _citiesController = TextEditingController();
  final TextEditingController _siblingsController = TextEditingController();
  final TextEditingController _familyController = TextEditingController();
  final TextEditingController _socialController = TextEditingController();
  final TextEditingController _researchController = TextEditingController();

  String idTypeValue = 'DrivingLicense';
  String sirTypeValue = 'SIR_Type';
  String warriorTypeValue = 'CORONA_Warrior';
  String genderTypeValue = 'Others';

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
    _nameController.dispose();
    _idController.dispose();
    _occupationController.dispose();
    _dobController.dispose();
    _medicalHistoryController.dispose();
    _raceController.dispose();
    _addressController.dispose();
    _zipcodeController.dispose();
    _citiesController.dispose();
    _siblingsController.dispose();
    _familyController.dispose();
    _socialController.dispose();
    _researchController.dispose();
    super.dispose();
  }

  void _getData(AuthBloc authBloc) async {
    setState(() => spinnerVisible = true);
    try {
      if (authBloc.isSignedIn()) {
        final res = await authBloc.getUserData("person");
        final data = res?.data() as Map<String, dynamic>?;
        if (data != null) {
          setState(() {
            formData = PersonDataModel.fromJson(data);
            userRole = data['role'] ?? 'patient';
            _navItems = getNavigationItems(userRole);
            _updateControllers();
          });
        }
      }
    } catch (e) {
      _showMessage("Could not load profile data.", "error");
    } finally {
      setState(() => spinnerVisible = false);
    }
  }

  void _updateControllers() {
    _nameController.text = formData.name ?? '';
    _idController.text = formData.id ?? '';
    _occupationController.text = formData.occupation ?? '';
    _dobController.text = formData.dob ?? '';
    _medicalHistoryController.text = formData.medicalHistory ?? '';
    _raceController.text = formData.race ?? '';
    _addressController.text = formData.address ?? '';
    _zipcodeController.text = formData.zipcode ?? '';
    _citiesController.text = formData.citiesTravelled ?? '';
    _siblingsController.text = formData.siblings ?? '';
    _familyController.text = formData.familyMembers ?? '';
    _socialController.text = formData.socialActiveness ?? '';
    _researchController.text = formData.declineParticipation ?? '';
    
    if (formData.idType != null) idTypeValue = formData.idType!;
    if (formData.sir != null) sirTypeValue = formData.sir!;
    if (formData.warrior != null) warriorTypeValue = formData.warrior!;
    if (formData.gender != null) genderTypeValue = formData.gender!;
  }

  Future _saveData() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => spinnerVisible = true);
    AuthBloc authBloc = AuthBloc();
    try {
      await authBloc.setUserData('person', formData);
      _showMessage("Profile updated successfully.", "success");
    } catch (e) {
      _showMessage(e.toString(), "error");
    } finally {
      setState(() => spinnerVisible = false);
    }
  }

  void _showMessage(String msg, String type) {
    setState(() {
      messageVisible = true;
      messageTxt = msg;
      messageType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentNavItems = _navItems.isNotEmpty ? _navItems : getNavigationItems(userRole);
    int safeIndex = 1; // Health/Profile
    
    return ResponsiveShell(
      currentIndex: safeIndex,
      onIndexChanged: (index) {
        if (currentNavItems[index].route != '/person') {
          Navigator.pushReplacementNamed(context, currentNavItems[index].route);
        }
      },
      items: currentNavItems,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text("My Health Profile"),
          actions: [
            IconButton(icon: const Icon(Icons.share_rounded), onPressed: () {}),
            const SizedBox(width: 8),
          ],
        ),

        body: spinnerVisible 
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopProfileCard(),
                    const SizedBox(height: 32),
                    _buildSectionHeader("Identity & Demographic"),
                    _buildIdentitySection(),
                    const SizedBox(height: 32),
                    _buildSectionHeader("Medical Background"),
                    _buildMedicalSection(),
                    const SizedBox(height: 32),
                    _buildSectionHeader("Social & Travel History"),
                    _buildSocialSection(),
                    const SizedBox(height: 40),
                    CustomMessage(
                      toggleMessage: messageVisible,
                      toggleMessageType: messageType,
                      toggleMessageTxt: messageTxt,
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: SizedBox(
                        width: 250,
                        height: 54,
                        child: ElevatedButton.icon(
                          onPressed: _saveData,
                          icon: const Icon(Icons.save_rounded),
                          label: const Text("SAVE HEALTH PROFILE", style: TextStyle(letterSpacing: 1.1)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 16),
      child: Text(title, style: cHeaderText.copyWith(fontSize: 18, color: cPrimaryBlue)),
    );
  }

  Widget _buildTopProfileCard() {
    return Card(
      elevation: 0,
      color: cPrimaryBlue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(32),
        width: double.infinity,
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.person_rounded, color: Colors.white, size: 40),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(formData.name ?? "New Patient", style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text("Complete your profile to assist in medical diagnosis", style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIdentitySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              onChanged: (v) => formData.name = v,
              decoration: const InputDecoration(labelText: "Full Name", prefixIcon: Icon(Icons.badge_outlined)),
              validator: evalName,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: idTypeValue,
                    decoration: const InputDecoration(labelText: "ID Component"),
                    items: ['DrivingLicense', 'AadharCard', 'PAN', 'SSN', 'StudentID', 'BirthCard']
                        .map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                    onChanged: (v) => setState(() { idTypeValue = v!; formData.idType = v; }),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _idController,
                    onChanged: (v) => formData.id = v,
                    decoration: const InputDecoration(labelText: "Document Number"),
                    validator: evalName,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _dobController,
                    onChanged: (v) => formData.dob = v,
                    decoration: const InputDecoration(labelText: "Date of Birth", prefixIcon: Icon(Icons.calendar_month_outlined)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: genderTypeValue,
                    decoration: const InputDecoration(labelText: "Gender"),
                    items: ['Male', 'Female', 'Others', 'Decline to answer']
                        .map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                    onChanged: (v) => setState(() { genderTypeValue = v!; formData.gender = v; }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _occupationController,
              onChanged: (v) => formData.occupation = v,
              decoration: const InputDecoration(labelText: "Current Occupation", prefixIcon: Icon(Icons.work_outline_rounded)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicalSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextFormField(
              controller: _medicalHistoryController,
              maxLines: 2,
              onChanged: (v) => formData.medicalHistory = v,
              decoration: const InputDecoration(labelText: "Past Medical History", prefixIcon: Icon(Icons.history_edu_rounded)),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: sirTypeValue,
                    decoration: const InputDecoration(labelText: "Infection Status (SIR)"),
                    items: ['Suspected', 'Infected', 'Recovered', 'NONE']
                        .map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                    onChanged: (v) => setState(() { sirTypeValue = v!; formData.sir = v; }),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: warriorTypeValue,
                    decoration: const InputDecoration(labelText: "Profile Tag / Group"),
                    items: ['Healthcare worker', 'FrontLine worker', 'Senior', 'General Citizen']
                        .map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                    onChanged: (v) => setState(() { warriorTypeValue = v!; formData.warrior = v; }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _raceController,
              onChanged: (v) => formData.race = v,
              decoration: const InputDecoration(labelText: "Nationality / Ethnicity", prefixIcon: Icon(Icons.public_rounded)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextFormField(
              controller: _addressController,
              onChanged: (v) => formData.address = v,
              decoration: const InputDecoration(labelText: "Residential Address", prefixIcon: Icon(Icons.home_outlined)),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _zipcodeController,
                    onChanged: (v) => formData.zipcode = v,
                    decoration: const InputDecoration(labelText: "Zip Code"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _citiesController,
                    onChanged: (v) => formData.citiesTravelled = v,
                    decoration: const InputDecoration(labelText: "Recent Travel (4wks)"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _familyController,
                    onChanged: (v) => formData.familyMembers = v,
                    decoration: const InputDecoration(labelText: "Household Size", prefixIcon: Icon(Icons.groups_outlined)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _socialController,
                    onChanged: (v) => formData.socialActiveness = v,
                    decoration: const InputDecoration(labelText: "Social Density"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _researchController,
              onChanged: (v) => formData.declineParticipation = v,
              decoration: const InputDecoration(
                labelText: "Research Participation Preference",
                prefixIcon: Icon(Icons.psychology_outlined),
                hintText: "Participate / Decline",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
