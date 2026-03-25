import 'package:src/shared/custom_components.dart';
import 'package:src/shared/custom_style.dart';
import 'package:flutter/material.dart';
import 'package:src/blocs/validators.dart';
import 'package:src/shared/responsive_shell.dart';


class Vendor extends StatefulWidget {
  static const routeName = '/vendor';
  @override
  VendorState createState() => VendorState();
}

class VendorState extends State<Vendor> {
  int _currentIndex = 2; // Vendor is the 3rd item in SCM nav

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
        if (_navItems[index].route != '/vendor') {
          Navigator.pushReplacementNamed(context, _navItems[index].route);
        }
      },
      items: _navItems,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text("Vendor Management"),
          actions: [
            IconButton(icon: const Icon(Icons.history_rounded), onPressed: () {}),
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
              _buildVendorForm(),
              const SizedBox(height: 48),
              _buildRecentVendorsListing(),
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
        Text("Supply Chain Partners", style: cHeaderText.copyWith(fontSize: 24)),
        const SizedBox(height: 4),
        Text("Register and manage authorized medical suppliers", style: cBodyText),
      ],
    );
  }

  Widget _buildVendorForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("General Information", style: cHeaderText.copyWith(fontSize: 18)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Vendor Name",
                      prefixIcon: Icon(Icons.business_rounded),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: "Vendor Type"),
                    items: ['Warehouse', 'Manufacturer', 'Dealer', 'Vendor', 'Direct Purchase', 'Factory']
                        .map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                    onChanged: (v) {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextFormField(
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "Address & Contact Details",
                prefixIcon: Icon(Icons.location_on_rounded),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 200,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("REGISTER VENDOR"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentVendorsListing() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Active Contracts", style: cHeaderText.copyWith(fontSize: 18)),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final names = ["MedTech Solutions", "Global Pharma Inc", "Direct Surgical"];
            final types = ["Manufacturer", "Direct Purchase", "Dealer"];
            return Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.withOpacity(0.1)),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: cSecondaryAzure,
                  child: Icon(Icons.store_rounded, color: cPrimaryBlue, size: 20),
                ),
                title: Text(names[index], style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(types[index]),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {},
              ),
            );
          },
        ),
      ],
    );
  }
}
