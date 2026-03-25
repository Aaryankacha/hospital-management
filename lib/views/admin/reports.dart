import 'package:src/shared/custom_components.dart';
import 'package:src/shared/custom_style.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shimmer/shimmer.dart';
import 'package:google_fonts/google_fonts.dart';

class Reports extends StatefulWidget {
  static const routeName = '/reports';
  @override
  ReportsState createState() => ReportsState();
}

class ReportsState extends State<Reports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Clinical Analytics"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Operational Insights",
              style: cHeaderText.copyWith(fontSize: 28),
            ),
            const SizedBox(height: 8),
            Text(
              "Real-time monitoring of hospital resources and patient flow",
              style: cBodyText,
            ),
            const SizedBox(height: 32),
            
            _buildSectionHeader("Clinical Overview", Icons.analytics_rounded),
            const SizedBox(height: 16),
            _buildReportGrid([
              _buildReportCard("Active Patients", "users", filter: {'role': 'patient'}, icon: Icons.people_rounded, color: Colors.blue),
              _buildReportCard("Appts Scheduled", "appointments", icon: Icons.event_available_rounded, color: Colors.green),
              _buildReportCard("Medical Files", "person", icon: Icons.folder_shared_rounded, color: Colors.indigo),
            ]),

            const SizedBox(height: 48),
            _buildSectionHeader("Supply Chain Logistics", Icons.local_shipping_rounded),
            const SizedBox(height: 16),
            _buildReportGrid([
              _buildReportCard("Registered Vendors", "scm_vendors", icon: Icons.business_rounded, color: Colors.teal),
              _buildReportCard("Open POs", "scm_purchase_orders", icon: Icons.receipt_long_rounded, color: Colors.deepOrange),
              _buildReportCard("Active MSRs", "scm_msrs", icon: Icons.assignment_rounded, color: Colors.cyan),
              _buildReportCard("Warehouses", "scm_warehouses", icon: Icons.warehouse_rounded, color: Colors.brown),
              _buildReportCard("Centers", "scm_centers", icon: Icons.room_preferences_rounded, color: Colors.blueGrey),
              _buildReportCard("Inventory Units", "scm_items", icon: Icons.inventory_rounded, color: Colors.purple),
            ]),
            
            const SizedBox(height: 48),
            _buildInfoBanner(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: cPrimaryBlue, size: 24),
        const SizedBox(width: 12),
        Text(
          title,
          style: cHeaderText.copyWith(fontSize: 20, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildReportGrid(List<Widget> cards) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.count(
          crossAxisCount: constraints.maxWidth > 900 ? 3 : (constraints.maxWidth > 600 ? 2 : 1),
          childAspectRatio: 1.5,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: cards,
        );
      },
    );
  }

  Widget _buildReportCard(String title, String collection, {IconData? icon, Color color = cPrimaryBlue, Map<String, dynamic>? filter}) {
    Query query = FirebaseFirestore.instance.collection(collection);
    if (filter != null) {
      filter.forEach((key, value) => query = query.where(key, isEqualTo: value));
    }

    return Card(
      child: StreamBuilder<QuerySnapshot>(
        stream: query.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerCard();
          }

          int count = snapshot.hasData ? snapshot.data!.docs.length : 0;
          
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: cBodyText.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    Icon(icon, color: color.withOpacity(0.7), size: 24),
                  ],
                ),
                Text(
                  "$count",
                  style: GoogleFonts.inter(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.grey[50]!,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(height: 16, width: 100, color: Colors.white),
            Container(height: 32, width: 60, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cSecondaryAzure,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cPrimaryBlue.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: cPrimaryBlue, size: 32),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Data Synchronization",
                  style: cHeaderText.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  "All metrics are updated in real-time from the hospital's cloud infrastructure.",
                  style: cBodyText,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
