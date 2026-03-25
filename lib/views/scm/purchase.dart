import 'package:src/shared/custom_components.dart';
import 'package:src/shared/custom_style.dart';
import 'package:flutter/material.dart';
import 'package:src/shared/responsive_shell.dart';


class Purchase extends StatefulWidget {
  static const routeName = '/purchase';
  @override
  PurchaseState createState() => PurchaseState();
}

class PurchaseState extends State<Purchase> {
  int _currentIndex = 0; // PO is the 1st item in SCM nav

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
        if (_navItems[index].route != '/purchase') {
          Navigator.pushReplacementNamed(context, _navItems[index].route);
        }
      },
      items: _navItems,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text("Purchase Orders"),
          actions: [
            IconButton(icon: const Icon(Icons.add_shopping_cart_rounded), onPressed: () {}),
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
              _buildPOForm(),
              const SizedBox(height: 48),
              _buildRecentPOListing(),
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
        Text("Procurement Management", style: cHeaderText.copyWith(fontSize: 24)),
        const SizedBox(height: 4),
        Text("Generate and track official purchase orders for medical supplies", style: cBodyText),
      ],
    );
  }

  Widget _buildPOForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order Details", style: cHeaderText.copyWith(fontSize: 18)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "PO Number",
                      prefixIcon: Icon(Icons.tag_rounded),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: "Vendor"),
                    items: ['ABC Corp.', 'XYZ Inc', 'Delta Corp.', 'Alpha LLC']
                        .map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                    onChanged: (v) {},
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
                      labelText: "Item Description / ID",
                      prefixIcon: Icon(Icons.inventory_2_outlined),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Quantity",
                      prefixIcon: Icon(Icons.calculate_outlined),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Total Amt",
                      prefixIcon: Icon(Icons.payments_outlined),
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
                icon: const Icon(Icons.send_rounded),
                label: const Text("GENERATE PO"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentPOListing() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Latest Purchase Orders", style: cHeaderText.copyWith(fontSize: 18)),
            TextButton(onPressed: () {}, child: const Text("View All")),
          ],
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final ids = ["PO-2024-001", "PO-2024-002", "PO-2024-003"];
            final vendors = ["MedTech Solutions", "Global Pharma Inc", "Direct Surgical"];
            final status = ["Approved", "Pending", "Shipped"];
            final colors = [Colors.green, Colors.orange, Colors.blue];
            
            return Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.withOpacity(0.1)),
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: cSecondaryAzure, borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.receipt_long_rounded, color: cPrimaryBlue, size: 20),
                ),
                title: Text(ids[index], style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(vendors[index]),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors[index].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status[index],
                    style: TextStyle(color: colors[index], fontSize: 12, fontWeight: FontWeight.bold),
                  ),
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
