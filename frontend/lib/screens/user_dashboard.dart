import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'report_incidents.dart';
import 'view_incidents.dart';
import 'view_alerts.dart';
import 'view_notification.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  late Future<String> userName;

  @override
  void initState() {
    super.initState();
    userName = fetchUserName();
  }

  // FUNCTION TO FETCH USER NAME FROM BACKEND
  Future<String> fetchUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token"); // Retrieve auth token

    if (token == null) {
      return "Guest User"; // Default if token is missing
    }

    final response = await http.get(
      Uri.parse('http://localhost:5000/api/user/profile'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token" // Send token for authentication
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['name']; // Assuming API response contains "name"
    } else {
      return "User Not Found";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Dashboard"),
        backgroundColor: Colors.green[700],
        elevation: 5,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[700]!, Colors.green[200]!],
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.account_circle, size: 80, color: Colors.green[800]),
                ),
                SizedBox(height: 15),

                // DYNAMICALLY DISPLAY USER NAME FROM DATABASE
                FutureBuilder<String>(
                  future: userName,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Show loading indicator
                    } else if (snapshot.hasError) {
                      return Text(
                        "Error loading user data",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      );
                    } else {
                      return Text(
                        "Welcome",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                      );
                    }
                  },
                ),

                SizedBox(height: 5),
                Text(
                  "Here you can report incidents, view scam alerts, and check your notifications.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                SizedBox(height: 20),

                // Report an Incident
                _buildDashboardButton(
                  context,
                  "Report an Incident",
                  Icons.report_problem,
                  Colors.red,
                  ReportIncident(),
                ),

                // View My Incidents
                _buildDashboardButton(
                  context,
                  "View My Incidents",
                  Icons.remove_red_eye,
                  Colors.blue,
                  ViewIncidents(),
                ),

                // Scam Awareness Alerts
                _buildDashboardButton(
                  context,
                  "Scam Awareness Alerts",
                  Icons.warning_amber_rounded,
                  Colors.orange,
                  ViewAlerts(),
                ),

                // View Notifications
                _buildDashboardButton(
                  context,
                  "View Notifications",
                  Icons.notifications_active,
                  Colors.purple,
                  ViewNotifications(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardButton(BuildContext context, String title, IconData icon, Color color, Widget screen) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          leading: Icon(icon, color: color, size: 30),
          title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
          },
        ),
      ),
    );
  }
}
