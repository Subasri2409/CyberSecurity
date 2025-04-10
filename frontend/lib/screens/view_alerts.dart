import 'package:flutter/material.dart';

class ViewAlerts extends StatelessWidget {
  // **STATIC LIST OF SCAM ALERTS**
  final List<Map<String, String>> alerts = [
    {
      "title": "Bank Phishing Scam",
      "message": "Scammers are sending fake emails pretending to be your bank.",
      "severity": "high",
      "date": "2024-05-12"
    },
    {
      "title": "Fake Job Offers",
      "message": "Beware of job offers asking for money upfront.",
      "severity": "medium",
      "date": "2024-05-10"
    },
    {
      "title": "Social Media Scam",
      "message": "Accounts are being hacked through fake friend requests.",
      "severity": "low",
      "date": "2024-05-08"
    },
    {
      "title": "Lottery Scam",
      "message": "Users are receiving fake lottery winning emails asking for fees.",
      "severity": "high",
      "date": "2024-05-06"
    },
    {
      "title": "Online Shopping Fraud",
      "message": "Beware of fake e-commerce websites offering huge discounts.",
      "severity": "medium",
      "date": "2024-05-04"
    }
  ];

  ViewAlerts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scam Awareness Alerts"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: ListView.builder(
        itemCount: alerts.length,
        itemBuilder: (context, index) {
          final alert = alerts[index];

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: Icon(
                _getSeverityIcon(alert['severity']!),
                color: _getSeverityColor(alert['severity']!),
                size: 30,
              ),
              title: Text(
                alert['title']!,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Text(
                alert['message']!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[700]),
              ),
              trailing: Chip(
                label: Text(
                  alert['severity']!.toUpperCase(),
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: _getSeverityColor(alert['severity']!),
              ),
              onTap: () => _showAlertDetails(context, alert),
            ),
          );
        },
      ),
    );
  }

  // FUNCTION TO SHOW FULL DETAILS IN A DIALOG
  void _showAlertDetails(BuildContext context, Map<String, String> alert) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(alert['title']!),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Severity: ${alert['severity']!.toUpperCase()}",
                  style: TextStyle(fontWeight: FontWeight.bold, color: _getSeverityColor(alert['severity']!))),
              SizedBox(height: 10),
              Text(alert['message']!, style: TextStyle(fontSize: 16)),
              SizedBox(height: 15),
              Text("Reported On: ${alert['date']!}", style: TextStyle(color: Colors.grey)),
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

  // FUNCTION TO GET SEVERITY COLOR
  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case "high":
        return Colors.red;
      case "medium":
        return Colors.orange;
      case "low":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // FUNCTION TO GET SEVERITY ICON
  IconData _getSeverityIcon(String severity) {
    switch (severity.toLowerCase()) {
      case "high":
        return Icons.warning;
      case "medium":
        return Icons.report_problem;
      case "low":
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }
}
