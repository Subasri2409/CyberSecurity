import 'package:flutter/material.dart';

class ViewIncidents extends StatelessWidget {
  // **STATIC LIST OF INCIDENTS**
  final List<Map<String, String>> incidents = [
    {
      "incident_type": "Phishing Attack",
      "description": "Received a fake email pretending to be from the bank asking for login credentials.",
      "status": "Pending",
      "reported_at": "2024-05-10"
    },
    {
      "incident_type": "Ransomware Attack",
      "description": "A company's data was encrypted, and the attacker demanded a ransom payment.",
      "status": "Under Review",
      "reported_at": "2024-05-08"
    },
    {
      "incident_type": "Identity Theft",
      "description": "Personal information was stolen and used for fraudulent activities.",
      "status": "Resolved",
      "reported_at": "2024-05-06"
    },
    {
      "incident_type": "Social Engineering",
      "description": "An employee was tricked into sharing sensitive company data.",
      "status": "Pending",
      "reported_at": "2024-05-04"
    },
    {
      "incident_type": "Online Shopping Fraud",
      "description": "Scammers sent fake products after receiving payments online.",
      "status": "Resolved",
      "reported_at": "2024-05-02"
    }
  ];

  ViewIncidents({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Reported Incidents"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: incidents.length,
        itemBuilder: (context, index) {
          final incident = incidents[index];

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: Icon(
                _getIncidentIcon(incident['incident_type']!),
                color: _getStatusColor(incident['status']!),
                size: 30,
              ),
              title: Text(
                incident['incident_type']!,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Text(
                "Status: ${incident['status']!}",
                style: TextStyle(color: Colors.grey[700]),
              ),
              trailing: Text(
                incident['reported_at']!,
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () => _showIncidentDetails(context, incident),
            ),
          );
        },
      ),
    );
  }

  // FUNCTION TO SHOW FULL DETAILS IN A DIALOG
  void _showIncidentDetails(BuildContext context, Map<String, String> incident) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(incident['incident_type']!),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Status: ${incident['status']!}",
                  style: TextStyle(fontWeight: FontWeight.bold, color: _getStatusColor(incident['status']!))),
              SizedBox(height: 10),
              Text(incident['description']!, style: TextStyle(fontSize: 16)),
              SizedBox(height: 15),
              Text("Reported On: ${incident['reported_at']!}", style: TextStyle(color: Colors.grey)),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Close"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  // FUNCTION TO GET STATUS COLOR
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return Colors.orange;
      case "under review":
        return Colors.blue;
      case "resolved":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // FUNCTION TO GET INCIDENT ICONS
  IconData _getIncidentIcon(String incidentType) {
    switch (incidentType.toLowerCase()) {
      case "phishing attack":
        return Icons.email;
      case "ransomware attack":
        return Icons.lock;
      case "identity theft":
        return Icons.person;
      case "social engineering":
        return Icons.group;
      case "online shopping fraud":
        return Icons.shopping_cart;
      default:
        return Icons.warning;
    }
  }
}
