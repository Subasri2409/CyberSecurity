import 'package:flutter/material.dart';

class ManageReports extends StatefulWidget {
  const ManageReports({super.key});

  @override
  _ManageReportsState createState() => _ManageReportsState();
}

class _ManageReportsState extends State<ManageReports> {
  // Dummy list of cybercrime reports (Admin View)
  List<Map<String, String>> reports = [
    {
      "title": "Suspicious Login Attempt",
      "message": "Multiple failed login attempts detected on the user's account.",
      "severity": "High",
      "status": "Pending",
      "reported_by": "Alice Johnson",
      "timestamp": "2024-05-10 10:30 AM"
    },
    {
      "title": "Fake Social Media Profile",
      "message": "User reported a fake social media account impersonating them.",
      "severity": "Medium",
      "status": "Under Review",
      "reported_by": "John Doe",
      "timestamp": "2024-05-09 09:15 PM"
    },
    {
      "title": "Phishing Email",
      "message": "Received an email pretending to be from a bank, asking for credentials.",
      "severity": "High",
      "status": "Resolved",
      "reported_by": "Emma Thomas",
      "timestamp": "2024-05-08 02:45 PM"
    },
    {
      "title": "Ransomware Alert",
      "message": "Company's system was locked by ransomware, demanding payment.",
      "severity": "Critical",
      "status": "Under Review",
      "reported_by": "Henry King",
      "timestamp": "2024-05-07 06:20 AM"
    },
    {
      "title": "Online Harassment",
      "message": "User reported being harassed through social media.",
      "severity": "Medium",
      "status": "Pending",
      "reported_by": "Olivia Taylor",
      "timestamp": "2024-05-06 12:10 PM"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Reports"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: reports.length,
          itemBuilder: (context, index) {
            final report = reports[index];

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
                  backgroundColor: _getSeverityColor(report["severity"]!),
                  child: Icon(
                    _getSeverityIcon(report["severity"]!),
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                title: Text(
                  report["title"]!,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(report["message"]!, style: TextStyle(color: Colors.grey[700])),
                    SizedBox(height: 5),
                    Text("📝 Reported by: ${report["reported_by"]}", style: TextStyle(fontSize: 14)),
                    Text("📅 ${report["timestamp"]}", style: TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
                trailing: DropdownButton<String>(
                  value: report["status"],
                  icon: Icon(Icons.arrow_drop_down),
                  onChanged: (newStatus) {
                    setState(() {
                      reports[index]["status"] = newStatus!;
                    });
                  },
                  items: ["Pending", "Under Review", "Resolved"]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: _getStatusColor(value))),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Function to get severity color
  Color _getSeverityColor(String severity) {
    switch (severity) {
      case "Low":
        return Colors.green;
      case "Medium":
        return Colors.orange;
      case "High":
        return Colors.red;
      case "Critical":
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  // Function to get status color
  Color _getStatusColor(String status) {
    switch (status) {
      case "Pending":
        return Colors.orange;
      case "Under Review":
        return Colors.blue;
      case "Resolved":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // Function to get severity icons
  IconData _getSeverityIcon(String severity) {
    switch (severity) {
      case "Low":
        return Icons.check_circle;
      case "Medium":
        return Icons.warning;
      case "High":
        return Icons.error;
      case "Critical":
        return Icons.dangerous;
      default:
        return Icons.report;
    }
  }
}
