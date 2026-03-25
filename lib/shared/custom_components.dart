import 'package:flutter/material.dart';
import 'package:src/shared/custom_style.dart';
import 'package:src/shared/responsive_shell.dart';

List<NavigationItem> getNavigationItems(String role) {
  switch (role.toLowerCase()) {
    case 'admin':
      return [
        NavigationItem(label: "Dash", icon: Icons.dashboard_outlined, selectedIcon: Icons.dashboard, route: '/admin'),
        NavigationItem(label: "Users", icon: Icons.people_outline, selectedIcon: Icons.people, route: '/admin'),
        NavigationItem(label: "Appts", icon: Icons.calendar_today_outlined, selectedIcon: Icons.calendar_today, route: '/appointments'),
        NavigationItem(label: "SCM", icon: Icons.inventory_2_outlined, selectedIcon: Icons.inventory_2, route: '/purchase'),
        NavigationItem(label: "Reports", icon: Icons.analytics_outlined, selectedIcon: Icons.analytics, route: '/reports'),
      ];
    case 'doctor':
      return [
        NavigationItem(label: "Clinic", icon: Icons.medical_services_outlined, selectedIcon: Icons.medical_services, route: '/admin'),
        NavigationItem(label: "Appts", icon: Icons.event_note_outlined, selectedIcon: Icons.event_note, route: '/appointments'),
        NavigationItem(label: "Reports", icon: Icons.analytics_outlined, selectedIcon: Icons.analytics, route: '/reports'),
        NavigationItem(label: "Profile", icon: Icons.account_circle_outlined, selectedIcon: Icons.account_circle, route: '/settings'),
      ];
    case 'nurse':
      return [
        NavigationItem(label: "Support", icon: Icons.healing_outlined, selectedIcon: Icons.healing, route: '/admin'),
        NavigationItem(label: "Vaccine", icon: Icons.vaccines_outlined, selectedIcon: Icons.vaccines, route: '/vaccine'),
        NavigationItem(label: "Appts", icon: Icons.calendar_today_outlined, selectedIcon: Icons.calendar_today, route: '/appointments'),
        NavigationItem(label: "Msgs", icon: Icons.chat_bubble_outline, selectedIcon: Icons.chat_bubble, route: '/messages'),
      ];
    case 'scm':
      return [
        NavigationItem(label: "PO", icon: Icons.receipt_long_outlined, selectedIcon: Icons.receipt_long, route: '/purchase'),
        NavigationItem(label: "MSR", icon: Icons.outbox_outlined, selectedIcon: Icons.outbox, route: '/msr'),
        NavigationItem(label: "Logistics", icon: Icons.warehouse_outlined, selectedIcon: Icons.warehouse, route: '/warehouse'),
        NavigationItem(label: "Items", icon: Icons.medication_outlined, selectedIcon: Icons.medication, route: '/item'),
      ];
    case 'patient':
    default:
      return [
        NavigationItem(label: "Appts", icon: Icons.calendar_today_outlined, selectedIcon: Icons.calendar_today, route: '/appointment'),
        NavigationItem(label: "Health", icon: Icons.person_outline, selectedIcon: Icons.person, route: '/person'),
        NavigationItem(label: "Records", icon: Icons.receipt_long_outlined, selectedIcon: Icons.receipt_long, route: '/records'),
      ];
  }
}

class CustomAdminNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildNavCard(context, "Appts", Icons.calendar_today_rounded, Colors.deepPurple, '/appointments'),
          _buildNavCard(context, "SCM", Icons.inventory_2_rounded, Colors.deepOrange, '/purchase'),
          _buildNavCard(context, "Reports", Icons.analytics_rounded, Colors.blue, '/reports'),
          _buildNavCard(context, "Logout", Icons.logout_rounded, Colors.grey, '/login'),
        ],
      ),
    );
  }

  Widget _buildNavCard(BuildContext context, String label, IconData icon, Color color, String route) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: InkWell(
        onTap: () => Navigator.pushReplacementNamed(context, route),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 100,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.1)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(label, style: cBodyText.copyWith(color: color, fontWeight: FontWeight.w600, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomGuestNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildNavCard(context, "Appts", Icons.calendar_today_rounded, Colors.teal, '/appointment'),
          _buildNavCard(context, "Profile", Icons.person_rounded, Colors.pink, '/person'),
          _buildNavCard(context, "Records", Icons.receipt_long_rounded, Colors.orange, '/records'),
          _buildNavCard(context, "Loom", Icons.video_call_rounded, Colors.greenAccent, '/loom'),
          _buildNavCard(context, "Logout", Icons.logout_rounded, Colors.blue, '/login'),
        ],
      ),
    );
  }

  Widget _buildNavCard(BuildContext context, String label, IconData icon, Color color, String route) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: InkWell(
        onTap: () => Navigator.pushReplacementNamed(context, route),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 90,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.1)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 6),
              Text(label, style: cBodyText.copyWith(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomSCMNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildNavCard(context, "PO", Icons.receipt_long_rounded, Colors.blue, '/purchase'),
          _buildNavCard(context, "MSR", Icons.outbox_rounded, Colors.orange, '/msr'),
          _buildNavCard(context, "Vendor", Icons.business_rounded, Colors.teal, '/vendor'),
          _buildNavCard(context, "Storage", Icons.warehouse_rounded, Colors.brown, '/warehouse'),
          _buildNavCard(context, "Center", Icons.hub_rounded, Colors.indigo, '/centre'),
          _buildNavCard(context, "Items", Icons.medication_rounded, Colors.purple, '/item'),
        ],
      ),
    );
  }

  Widget _buildNavCard(BuildContext context, String label, IconData icon, Color color, String route) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: InkWell(
        onTap: () => Navigator.pushReplacementNamed(context, route),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 90,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.1)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 6),
              Text(label, style: cBodyText.copyWith(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomAdminDrawer extends StatelessWidget {
  const CustomAdminDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text(cAppTitle),
            accountEmail: const Text(cEmailID),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.admin_panel_settings, color: cPrimaryBlue, size: 40),
            ),
            decoration: const BoxDecoration(color: cPrimaryBlue),
          ),
          _buildDrawerItem(context, "Dashboard", Icons.dashboard_rounded, '/admin'),
          _buildDrawerItem(context, "User Management", Icons.people_alt_rounded, '/admin'),
          _buildDrawerItem(context, "Appointments", Icons.calendar_today_rounded, '/appointments'),
          _buildDrawerItem(context, "Supply Chain", Icons.inventory_2_rounded, '/purchase'),
          _buildDrawerItem(context, "Reports", Icons.analytics_rounded, '/reports'),
          const Divider(),
          _buildDrawerItem(context, "Sign Out", Icons.logout_rounded, '/login'),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, String title, IconData icon, String route) {
    return ListTile(
      leading: Icon(icon, color: cPrimaryBlue),
      title: Text(title, style: cNavText),
      onTap: () => Navigator.pushReplacementNamed(context, route),
    );
  }
}

class CustomGuestDrawer extends StatelessWidget {
  const CustomGuestDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text(cAppTitle),
            accountEmail: const Text("patient@hms.pro"),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: cPrimaryBlue, size: 40),
            ),
            decoration: const BoxDecoration(color: cPrimaryBlue),
          ),
          _buildDrawerItem(context, "My Health Data", Icons.person_rounded, '/person'),
          _buildDrawerItem(context, "Appointments", Icons.calendar_today_rounded, '/appointment'),
          _buildDrawerItem(context, "Medical Records", Icons.receipt_long_rounded, '/records'),
          _buildDrawerItem(context, "Tele-Health (Loom)", Icons.video_call_rounded, '/loom'),
          const Divider(),
          _buildDrawerItem(context, "Sign Out", Icons.logout_rounded, '/login'),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, String title, IconData icon, String route) {
    return ListTile(
      leading: Icon(icon, color: cPrimaryBlue),
      title: Text(title, style: cNavText),
      onTap: () => Navigator.pushReplacementNamed(context, route),
    );
  }
}

class CustomSpinner extends StatelessWidget {
  final bool toggleSpinner;
  const CustomSpinner({Key? key, required this.toggleSpinner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return toggleSpinner ? const Center(child: CircularProgressIndicator()) : const SizedBox.shrink();
  }
}

class CustomMessage extends StatelessWidget {
  final bool toggleMessage;
  final String toggleMessageType;
  final String toggleMessageTxt;

  const CustomMessage({
    Key? key,
    required this.toggleMessage,
    required this.toggleMessageType,
    required this.toggleMessageTxt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!toggleMessage) return const SizedBox.shrink();
    
    final isError = toggleMessageType.contains("error");
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: isError ? Colors.red.shade50 : Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isError ? Colors.red.shade200 : Colors.green.shade200),
      ),
      child: Row(
        children: [
          Icon(isError ? Icons.error_outline : Icons.check_circle_outline, 
               color: isError ? Colors.red : Colors.green),
          const SizedBox(width: 12),
          Expanded(child: Text(toggleMessageTxt, style: TextStyle(color: isError ? Colors.red.shade900 : Colors.green.shade900))),
        ],
      ),
    );
  }
}
