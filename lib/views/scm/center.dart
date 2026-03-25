import 'package:src/shared/custom_components.dart';
import 'package:src/shared/custom_style.dart';
import 'package:flutter/material.dart';
import 'package:src/shared/responsive_shell.dart';


class Centre extends StatefulWidget {
  static const routeName = '/centre';
  @override
  CentreState createState() => CentreState();
}

class CentreState extends State<Centre> {
  int _currentIndex = 4; // Center is the 5th item in SCM nav

  final List<NavigationItem> _navItems = [
    NavigationItem(label: "PO", icon: Icons.receipt_long_outlined, selectedIcon: Icons.receipt_long, route: '/purchase'),
    NavigationItem(label: "MSR", icon: Icons.outbox_outlined, selectedIcon: Icons.outbox, route: '/msr'),
    NavigationItem(label: "Vendor", icon: Icons.business_outlined, selectedIcon: Icons.business, route: '/vendor'),
    NavigationItem(label: "Storage", icon: Icons.warehouse_outlined, selectedIcon: Icons.warehouse, route: '/warehouse'),
    NavigationItem(label: "Center", icon: Icons.hub_outlined, selectedIcon: Icons.hub, route: '/centre'),
    NavigationItem(label: "Items", icon: Icons.medication_outlined, selectedIcon: Icons.medication, route: '/item'),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveShell(
      currentIndex: _currentIndex,
      onIndexChanged: (index) {
        if (_navItems[index].route != '/centre') {
          Navigator.pushReplacementNamed(context, _navItems[index].route);
        }
      },
      items: _navItems,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text("Distribution Centers"),
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              _buildCenterForm(),
              const SizedBox(height: 48),
              _buildCenterListing(),
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
        Text("Network Hubs", style: cHeaderText.copyWith(fontSize: 24)),
        const SizedBox(height: 4),
        Text("Coordinate distribution across hospital units and satellite clinics", style: cBodyText),
      ],
    );
  }

  Widget _buildCenterForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hub Registration", style: cHeaderText.copyWith(fontSize: 18)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Center Name",
                      prefixIcon: Icon(Icons.hub_rounded),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: "Hub Responsibility"),
                    items: ['Regional Dist', 'On-site Dispensing', 'Surgical Supply', 'Emergency Support']
                        .map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                    onChanged: (v) {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Manager / Point of Contact",
                prefixIcon: Icon(Icons.person_pin_rounded),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 200,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("CONFIRM HUB"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterListing() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Active Distribution Network", style: cHeaderText.copyWith(fontSize: 18)),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final hubs = ["Eastern Satellite Hub", "ER Immediate Pool", "OPD Supply Point"];
            return Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey.withOpacity(0.1)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: cSecondaryAzure,
                  child: const Icon(Icons.gps_fixed_rounded, color: cPrimaryBlue, size: 20),
                ),
                title: Text(hubs[index], style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text("Active Sessions: 12"),
                trailing: const Icon(Icons.keyboard_arrow_right_rounded),
              ),
            );
          },
        ),
      ],
    );
  }
}
