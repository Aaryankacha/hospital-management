import 'dart:async';
import 'package:flutter/material.dart';
import 'package:src/blocs/auth/auth.bloc.dart';
import 'package:src/shared/custom_style.dart';
import 'package:src/shared/custom_components.dart';
import 'package:src/utils/platform_view_helper.dart';
import 'package:src/shared/responsive_shell.dart';
import 'package:src/shared/emergency_button.dart';

class LoomDocs extends StatefulWidget {
  static const routeName = '/loomdocs';
  @override
  LoomDocsState createState() => LoomDocsState();
}

class LoomDocsState extends State<LoomDocs> {
  bool spinnerVisible = false;
  late String _url;
  AuthBloc authBloc = AuthBloc();

  final List<NavigationItem> _navItems = [
    NavigationItem(label: "Appts", icon: Icons.calendar_today_outlined, selectedIcon: Icons.calendar_today, route: '/appointment'),
    NavigationItem(label: "Profile", icon: Icons.person_outline, selectedIcon: Icons.person, route: '/person'),
    NavigationItem(label: "Records", icon: Icons.receipt_long_outlined, selectedIcon: Icons.receipt_long, route: '/records'),
    NavigationItem(label: "Loom", icon: Icons.video_call_outlined, selectedIcon: Icons.video_call, route: '/loom'),
  ];

  @override
  void initState() {
    super.initState();
    // this is accessing Angular app
    _url = "http://localhost:4200/messages/2de930ded8084a45bb2542c21ebb162d";
    registerWebView('hello-world-html', _url);
  }

  @override
  void dispose() {
    authBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveShell(
      currentIndex: 3, // Loom
      onIndexChanged: (index) {
        if (_navItems[index].route != '/loomdocs') {
          Navigator.pushReplacementNamed(context, _navItems[index].route);
        }
      },
      items: _navItems,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text("Patient Communications"),
        ),
        floatingActionButton: EmergencyButton(onPressed: () {}),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              _buildMessageCard(),
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
        Text("Message History", style: cHeaderText.copyWith(fontSize: 24)),
        const SizedBox(height: 4),
        Text("View and reply to clinical messages from your healthcare team", style: cBodyText),
      ],
    );
  }

  Widget _buildMessageCard() {
    return Card(
      elevation: 4,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: cPrimaryBlue.withOpacity(0.05),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: cPrimaryBlue,
                  child: const Icon(Icons.medical_information_rounded, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    "Clinical Update: Amit Shukla",
                    style: TextStyle(fontWeight: FontWeight.bold, color: cPrimaryBlue),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/loom'),
                  icon: const Icon(Icons.video_call_rounded, size: 18),
                  label: const Text("REPLY VIA VIDEO", style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                ),
              ],
            ),
          ),
          Container(
            height: 600,
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            child: const HtmlElementView(viewType: 'hello-world-html'),
          ),
        ],
      ),
    );
  }
}
