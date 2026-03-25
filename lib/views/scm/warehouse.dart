import 'package:src/shared/custom_components.dart';
import 'package:src/shared/custom_style.dart';
import 'package:flutter/material.dart';
import 'package:src/shared/responsive_shell.dart';


class Warehouse extends StatefulWidget {
  static const routeName = '/warehouse';
  @override
  WarehouseState createState() => WarehouseState();
}

class WarehouseState extends State<Warehouse> {
  int _currentIndex = 3; // Storage is the 4th item in SCM nav

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
        if (_navItems[index].route != '/warehouse') {
          Navigator.pushReplacementNamed(context, _navItems[index].route);
        }
      },
      items: _navItems,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text("Warehouse Management"),
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              _buildWarehouseForm(),
              const SizedBox(height: 48),
              _buildStorageListing(),
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
        Text("Central Storage Facilities", style: cHeaderText.copyWith(fontSize: 24)),
        const SizedBox(height: 4),
        Text("Manage hospital warehouses and storage logistics", style: cBodyText),
      ],
    );
  }

  Widget _buildWarehouseForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Facility Details", style: cHeaderText.copyWith(fontSize: 18)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Warehouse Name",
                      prefixIcon: Icon(Icons.warehouse_rounded),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: "Facility Category"),
                    items: ['Cold Storage', 'Pharmacy WH', 'General Supplies', 'Surgical WH']
                        .map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                    onChanged: (v) {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Physical Location / Address",
                prefixIcon: Icon(Icons.location_city_rounded),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 200,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("REGISTER FACILITY"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStorageListing() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Active Warehouses", style: cHeaderText.copyWith(fontSize: 18)),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 3,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            final names = ["Main Medical WH", "North Cold Storage", "Surgical Hub", "Sterile Unit"];
            final capacities = ["85% Full", "40% Full", "92% Full", "15% Full"];
            return Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey.withOpacity(0.1)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(Icons.warehouse_rounded, color: cPrimaryBlue.withOpacity(0.7)),
                title: Text(names[index], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: Text("Utilization: ${capacities[index]}", style: const TextStyle(fontSize: 12)),
              ),
            );
          },
        ),
      ],
    );
  }
}
