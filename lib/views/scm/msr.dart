import 'package:src/shared/custom_components.dart';
import 'package:src/shared/custom_style.dart';
import 'package:flutter/material.dart';
import 'package:src/shared/responsive_shell.dart';


class MSR extends StatefulWidget {
  static const routeName = '/msr';
  @override
  MSRState createState() => MSRState();
}

class MSRState extends State<MSR> {
  int _currentIndex = 1; // MSR is the 2nd item in SCM nav

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
        if (_navItems[index].route != '/msr') {
          Navigator.pushReplacementNamed(context, _navItems[index].route);
        }
      },
      items: _navItems,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text("Material Requests"),
          actions: [
            IconButton(icon: const Icon(Icons.playlist_add_rounded), onPressed: () {}),
            const SizedBox(width: 8),
          ],
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              _buildMSRForm(),
              const SizedBox(height: 48),
              _buildActiveRequestsListing(),
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
        Text("Internal Stock Requisitions", style: cHeaderText.copyWith(fontSize: 24)),
        const SizedBox(height: 4),
        Text("Request medical material and equipment from hospital warehouses", style: cBodyText),
      ],
    );
  }

  Widget _buildMSRForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Requisition Details", style: cHeaderText.copyWith(fontSize: 18)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Target Center",
                      prefixIcon: Icon(Icons.room_preferences_rounded),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Source Warehouse",
                      prefixIcon: Icon(Icons.warehouse_rounded),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Item Category / ID",
                      prefixIcon: Icon(Icons.category_outlined),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Required Qty",
                      prefixIcon: Icon(Icons.format_list_numbered_rounded),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 220,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.assignment_turned_in_rounded),
                label: const Text("SUBMIT REQUEST"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveRequestsListing() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Pending Requisitions", style: cHeaderText.copyWith(fontSize: 18)),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 2,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final centers = ["Emergency Ward", "Main Pharmacy"];
            final priorities = ["Urgent", "Routine"];
            final colors = [Colors.redAccent, Colors.blue];
            
            return Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.withOpacity(0.1)),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: cSecondaryAzure,
                  child: const Icon(Icons.outbox_rounded, color: cPrimaryBlue, size: 20),
                ),
                title: Text(centers[index], style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text("ID: MSR-24-X102"),
                trailing: Chip(
                  label: Text(priorities[index], style: const TextStyle(color: Colors.white, fontSize: 10)),
                  backgroundColor: colors[index],
                ),
                onTap: () {},
              )
            );
          },
        ),
      ],
    );
  }
}
