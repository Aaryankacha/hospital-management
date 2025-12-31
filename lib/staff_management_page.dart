import 'package:flutter/material.dart';

class StaffManagementPage extends StatelessWidget {
  final List<Map<String, String>> staffList = [
    {
      "name": "Dr. Amit Sharma",
      "role": "Doctor",
      "department": "Cardiology",
      "status": "Active",
    },
    {
      "name": "Nina Patel",
      "role": "Nurse",
      "department": "Emergency",
      "status": "Active",
    },
    {
      "name": "Rahul Mehta",
      "role": "Receptionist",
      "department": "Front Desk",
      "status": "Inactive",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Staff Management")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add staff screen (future)
        },
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: staffList.length,
        itemBuilder: (context, index) {
          final staff = staffList[index];

          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(child: Icon(Icons.person)),
              title: Text(staff["name"]!),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Role: ${staff["role"]}"),
                  Text("Department: ${staff["department"]}"),
                ],
              ),
              trailing: Chip(
                label: Text(staff["status"]!),
                backgroundColor: staff["status"] == "Active"
                    ? Colors.green.shade100
                    : Colors.red.shade100,
              ),
              onTap: () {
                _showStaffActions(context);
              },
            ),
          );
        },
      ),
    );
  }

  void _showStaffActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.edit),
              title: Text("Edit Staff"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.block),
              title: Text("Disable Account"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text("Remove Staff"),
              onTap: () {},
            ),
          ],
        );
      },
    );
  }
}
