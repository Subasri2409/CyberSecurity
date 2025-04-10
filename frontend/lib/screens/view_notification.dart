import 'package:flutter/material.dart';

class ViewNotifications extends StatelessWidget {
  // **STATIC LIST OF NOTIFICATIONS**
  final List<Map<String, String>> notifications = [
    {
      "message": "Your incident report has been received.",
      "notification_type": "Update",
      "sent_at": "2024-05-12"
    },
    {
      "message": "Suspicious activity detected on your account!",
      "notification_type": "Alert",
      "sent_at": "2024-05-10"
    },
    {
      "message": "Reminder: Change your password regularly for security.",
      "notification_type": "Reminder",
      "sent_at": "2024-05-08"
    },
    {
      "message": "A new scam alert has been issued in your area.",
      "notification_type": "Alert",
      "sent_at": "2024-05-06"
    },
    {
      "message": "New security tips available in your dashboard.",
      "notification_type": "Update",
      "sent_at": "2024-05-04"
    }
  ];

  ViewNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Notifications"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: Icon(
                _getNotificationIcon(notification['notification_type']!),
                color: _getNotificationColor(notification['notification_type']!),
                size: 28,
              ),
              title: Text(
                notification['message']!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "Type: ${notification['notification_type']!}",
                style: TextStyle(color: Colors.grey[600]),
              ),
              trailing: Text(
                notification['sent_at']!,
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
              onTap: () => _showNotificationDetails(context, notification),
            ),
          );
        },
      ),
    );
  }

  // FUNCTION TO SHOW FULL NOTIFICATION DETAILS IN A DIALOG
  void _showNotificationDetails(BuildContext context, Map<String, String> notification) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(notification['notification_type']!),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(notification['message']!, style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Text("Sent On: ${notification['sent_at']!}", style: TextStyle(color: Colors.grey)),
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

  // FUNCTION TO GET NOTIFICATION ICON
  IconData _getNotificationIcon(String type) {
    switch (type.toLowerCase()) {
      case "alert":
        return Icons.warning;
      case "update":
        return Icons.notifications;
      case "reminder":
        return Icons.alarm;
      default:
        return Icons.info;
    }
  }

  // FUNCTION TO GET NOTIFICATION COLOR
  Color _getNotificationColor(String type) {
    switch (type.toLowerCase()) {
      case "alert":
        return Colors.red;
      case "update":
        return Colors.blue;
      case "reminder":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
