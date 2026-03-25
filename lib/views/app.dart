// 
import 'package:src/views/aboutus.dart';
// import 'package:src/views/mdnews.dart';
// import 'package:src/views/businessnews.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:src/shared/custom_style.dart';
import 'package:src/views/auth/settings.dart';
import 'package:src/views/auth/signup.dart';
import 'package:src/views/auth/login.dart';
import 'package:src/views/admin/reports.dart';
import 'package:src/views/admin/patient.dart';
import 'package:src/views/admin/appointments.dart';
import 'package:src/views/admin/vaccine.dart';
import 'package:src/views/admin/opd.dart';
import 'package:src/views/admin/messages.dart';
import 'package:src/views/admin/rx.dart';
import 'package:src/views/admin/lab.dart';
import 'package:src/views/admin/admin.dart';
import 'package:src/views/admin/adminedit.dart';
import 'package:src/views/user/person.dart';
import 'package:src/views/user/records.dart';
import 'package:src/views/user/appointment.dart';
import 'package:src/views/user/loom.dart';
import 'package:src/views/user/loomdocs.dart';
import 'package:src/views/scm/purchase.dart';
import 'package:src/views/scm/msr.dart';
import 'package:src/views/scm/center.dart';
import 'package:src/views/scm/vendor.dart';
import 'package:src/views/scm/warehouse.dart';
import 'package:src/views/scm/item.dart';

//import 'package:gallery/l10n/gallery_localizations.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: cAppTitle,
      theme: cThemeData,
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      routes: {
        AboutUs.routeName: (context) => AboutUs(),
        LogIn.routeName: (context) => LogIn(),
        Settings.routeName: (context) => Settings(),
        SignUp.routeName: (context) => SignUp(),
        Reports.routeName: (context) => Reports(),
        Patient.routeName: (context) => Patient(),
        Person.routeName: (context) => Person(),
        Records.routeName: (context) => Records(),
        Appointment.routeName: (context) => Appointment(),
        // Loom.routeName: (context) => Loom(),
        LoomDocs.routeName: (context) => LoomDocs(),
        Appointments.routeName: (context) => Appointments(),
        Vaccine.routeName: (context) => Vaccine(),
        OPD.routeName: (context) => OPD(),
        Lab.routeName: (context) => Lab(),
        Rx.routeName: (context) => Rx(),
        Messages.routeName: (context) => Messages(),
        Purchase.routeName: (context) => Purchase(),
        MSR.routeName: (context) => MSR(),
        Centre.routeName: (context) => Centre(),
        Vendor.routeName: (context) => Vendor(),
        Warehouse.routeName: (context) => Warehouse(),
        Item.routeName: (context) => Item(),
        Admin.routeName: (context) => Admin(),
        AdminEdit.routeName: (context) => AdminEdit(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cSecondaryAzure,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: const BoxDecoration(
              color: cPrimaryBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    "Welcome to",
                    style: cHeaderWhiteText.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    cAppTitle,
                    style: cHeaderWhiteText.copyWith(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 80),
                  Card(
                    elevation: 8,
                    shadowColor: cPrimaryBlue.withOpacity(0.2),
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.local_hospital_rounded,
                            size: 80,
                            color: cPrimaryBlue,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            "Secure Hospital Management",
                            textAlign: TextAlign.center,
                            style: cHeaderText.copyWith(fontSize: 24),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Access patient records, supply chain, and clinical analytics from a single unified dashboard.",
                            textAlign: TextAlign.center,
                            style: cBodyText.copyWith(fontSize: 16),
                          ),
                          const SizedBox(height: 40),
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () => Navigator.pushNamed(context, '/login'),
                              child: const Text(
                                "ENTER DASHBOARD",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () => Navigator.pushNamed(context, '/aboutus'),
                            child: Text(
                              "LEARN MORE ABOUT HMS PRO",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "© 2026 HMS Pro - Professional Medical Systems",
                style: cBodyText.copyWith(fontSize: 12, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
