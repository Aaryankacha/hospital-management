import 'package:src/shared/custom_components.dart';
import 'package:src/shared/custom_style.dart';
import 'package:flutter/material.dart';
import 'package:src/shared/responsive_shell.dart';


class Item extends StatefulWidget {
  static const routeName = '/item';
  @override
  ItemState createState() => ItemState();
}

class ItemState extends State<Item> {
  int _currentIndex = 5; // Items is the 6th item in SCM nav

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
        if (_navItems[index].route != '/item') {
          Navigator.pushReplacementNamed(context, _navItems[index].route);
        }
      },
      items: _navItems,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text("Medical Item Catalog"),
          actions: [
            IconButton(icon: const Icon(Icons.search_rounded), onPressed: () {}),
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
              _buildItemForm(),
              const SizedBox(height: 48),
              _buildCatalogListing(),
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
        Text("SKU Registry", style: cHeaderText.copyWith(fontSize: 24)),
        const SizedBox(height: 4),
        Text("Manage medical inventory, consumables, and pharmaceutical items", style: cBodyText),
      ],
    );
  }

  Widget _buildItemForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Item Specifications", style: cHeaderText.copyWith(fontSize: 18)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Item Name / Description",
                      prefixIcon: Icon(Icons.medication_rounded),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "UOM (Unit)",
                      hintText: "Box, Vial, etc.",
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: "Inventory Class"),
                    items: ['Pharmaceuticals', 'Consumables', 'Equipment', 'Surgical Instruments']
                        .map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                    onChanged: (v) {},
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Base Unit Price",
                      prefixIcon: Icon(Icons.attach_money_rounded),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 200,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_box_rounded),
                label: const Text("ADD TO CATALOG"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCatalogListing() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Recently Added Items", style: cHeaderText.copyWith(fontSize: 18)),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final items = ["Paracetamol 500mg", "Surgical Gloves (M)", "Adhesive Bandages"];
            final skus = ["MED-102", "SUR-441", "CON-882"];
            return Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey.withOpacity(0.1)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: cSecondaryAzure, borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.inventory_2_outlined, color: cPrimaryBlue, size: 20),
                ),
                title: Text(items[index], style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("SKU: ${skus[index]}"),
                trailing: Text("\$${(index + 1) * 12.50}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
              ),
            );
          },
        ),
      ],
    );
  }
}
