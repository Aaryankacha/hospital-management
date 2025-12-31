import 'package:flutter/material.dart';
import 'staff_management_page.dart';
import 'patient_records_page.dart';

class AdminDashboard extends StatelessWidget {
  // Primary Medical Blue Colors
  final Color primaryBlue = const Color(0xFF0D47A1);
  final Color accentBlue = const Color(0xFF1976D2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Custom Styled Header
          _buildHeader(context),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Hospital Overview",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Stat Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1.3,
                    children: [
                      _buildStatCard(
                        "Doctors",
                        "12",
                        Icons.medical_services_rounded,
                        [Color(0xFF1565C0), Color(0xFF1E88E5)],
                      ),
                      _buildStatCard(
                        "Nurses",
                        "24",
                        Icons.local_hospital_rounded,
                        [Color(0xFF0288D1), Color(0xFF03A9F4)],
                      ),
                      _buildStatCard("Patients", "120", Icons.people_rounded, [
                        Color(0xFF2E7D32),
                        Color(0xFF43A047),
                      ]),
                      _buildStatCard("Depts", "6", Icons.apartment_rounded, [
                        Color(0xFF7B1FA2),
                        Color(0xFF9C27B0),
                      ]),
                    ],
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "Admin Controls",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Menu Section
                  _buildMenuTile(
                    context,
                    Icons.badge_outlined,
                    "Manage Staff",
                    "Doctors, Nurses & Staff",
                  ),
                  _buildMenuTile(
                    context,
                    Icons.assignment_outlined,
                    "Patient Records",
                    "Medical History & Info",
                  ),
                  _buildMenuTile(
                    context,
                    Icons.account_tree_outlined,
                    "Manage Departments",
                    "Operational Wings",
                  ),
                  _buildMenuTile(
                    context,
                    Icons.verified_user_outlined,
                    "Roles & Permissions",
                    "Security Settings",
                  ),
                  _buildMenuTile(
                    context,
                    Icons.analytics_outlined,
                    "System Logs",
                    "Activity Tracking",
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 24, right: 24, bottom: 30),
      decoration: BoxDecoration(
        color: primaryBlue,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Welcome back,",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  Text(
                    "Chief Admin",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(
                  Icons.logout_rounded,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    List<Color> colors,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colors[0].withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        leading: CircleAvatar(
          backgroundColor: primaryBlue.withOpacity(0.1),
          child: Icon(icon, color: primaryBlue),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14,
          color: Colors.grey,
        ),
        onTap: () {
          if (title == "Manage Staff") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => StaffManagementPage()),
            );
          } else if (title == "Patient Records") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PatientRecordsPage()),
            );
          }
        },
      ),
    );
  }
}
