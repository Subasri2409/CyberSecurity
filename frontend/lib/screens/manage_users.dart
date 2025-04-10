import 'package:flutter/material.dart';

class ManageUsers extends StatefulWidget {
  const ManageUsers({super.key});

  @override
  _ManageUsersState createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  // Dummy list of 20 users
  List<Map<String, String>> users = [
    {
      "name": "Alice Johnson",
      "email": "alice@example.com",
      "phone": "9876543210",
      "role": "Admin",
      "status": "Active",
      "registered_on": "2024-01-10"
    },
    {
      "name": "Bob Smith",
      "email": "bob@example.com",
      "phone": "8765432109",
      "role": "User",
      "status": "Active",
      "registered_on": "2024-02-15"
    },
    {
      "name": "Charlie Brown",
      "email": "charlie@example.com",
      "phone": "7654321098",
      "role": "Authority",
      "status": "Inactive",
      "registered_on": "2024-03-20"
    },
    {
      "name": "David Wilson",
      "email": "david@example.com",
      "phone": "6543210987",
      "role": "User",
      "status": "Active",
      "registered_on": "2024-04-05"
    },
    {
      "name": "Emma Thomas",
      "email": "emma@example.com",
      "phone": "5432109876",
      "role": "Admin",
      "status": "Suspended",
      "registered_on": "2024-05-12"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Users"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                leading: CircleAvatar(
                  radius: 30,
                  backgroundColor: _getRoleColor(user["role"]!),
                  child: Icon(
                    _getRoleIcon(user["role"]!),
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                title: Text(
                  user["name"]!,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("📧 ${user["email"]}"),
                    Text("📞 ${user["phone"]}"),
                    Text("🗓 Registered: ${user["registered_on"]}"),
                  ],
                ),
                trailing: Column(
                  children: [
                    DropdownButton<String>(
                      value: user["role"],
                      icon: Icon(Icons.arrow_drop_down),
                      onChanged: (newRole) {
                        setState(() {
                          users[index]["role"] = newRole!;
                        });
                      },
                      items: ["Admin", "User", "Authority"]
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: TextStyle(color: _getRoleColor(value))),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 5),
                    Chip(
                      label: Text(
                        user["status"]!,
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: _getStatusColor(user["status"]!),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Function to get role color
  Color _getRoleColor(String role) {
    switch (role) {
      case "Admin":
        return Colors.red;
      case "User":
        return Colors.green;
      case "Authority":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  // Function to get role icons
  IconData _getRoleIcon(String role) {
    switch (role) {
      case "Admin":
        return Icons.admin_panel_settings;
      case "User":
        return Icons.person;
      case "Authority":
        return Icons.security;
      default:
        return Icons.help_outline;
    }
  }

  // Function to get status color
  Color _getStatusColor(String status) {
    switch (status) {
      case "Active":
        return Colors.green;
      case "Inactive":
        return Colors.orange;
      case "Suspended":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
