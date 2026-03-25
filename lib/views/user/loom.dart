import 'dart:async';
import 'package:flutter/material.dart';
import 'package:src/blocs/auth/auth.bloc.dart';
import 'package:src/shared/custom_style.dart';
import 'package:src/shared/custom_components.dart';
import 'package:src/utils/platform_view_helper.dart';
import 'package:src/shared/responsive_shell.dart';
import 'package:src/shared/emergency_button.dart';

class Loom extends StatefulWidget {
  static const routeName = '/loom';
  @override
  LoomState createState() => LoomState();
}

class LoomState extends State<Loom> {
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
    _url = "http://localhost:4200/record/" + authBloc.getUID();
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
        if (_navItems[index].route != '/loom') {
          Navigator.pushReplacementNamed(context, _navItems[index].route);
        }
      },
      items: _navItems,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text("Telemedicine Portal"),
        ),
        floatingActionButton: EmergencyButton(onPressed: () {}),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              _buildVideoCard(),
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
        Text("Consultation Recording", style: cHeaderText.copyWith(fontSize: 24)),
        const SizedBox(height: 4),
        Text("Record and send video updates to your medical providers", style: cBodyText),
      ],
    );
  }

  Widget _buildVideoCard() {
    return Card(
      elevation: 4,
      shadowColor: cPrimaryBlue.withOpacity(0.1),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: const BoxDecoration(
              color: cPrimaryBlue,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            ),
            child: Row(
              children: const [
                Icon(Icons.videocam_rounded, color: Colors.white, size: 20),
                SizedBox(width: 12),
                Text("Video Interface", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Spacer(),
                Icon(Icons.circle, color: Colors.red, size: 10),
                SizedBox(width: 8),
                Text("READY", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Container(
            height: 500,
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            child: const HtmlElementView(viewType: 'hello-world-html'),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Instructions", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("Ensure your camera is active and well-lit.", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.send_rounded),
                  label: const Text("SEND UPDATE"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
