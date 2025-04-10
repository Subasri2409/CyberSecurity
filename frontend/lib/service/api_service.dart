import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "http://localhost:5000"; // Change to your backend URL
  static const String authUrl = "$baseUrl/api/auth";
  static const String adminUrl = "$baseUrl/api/admin";

  // Save token & role in shared preferences
  static Future<void> saveToken(String token, String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token);
    prefs.setString("role", role);
  }

  // Get saved token
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  // User Registration
  static Future<Map<String, dynamic>> registerUser(
      String name, String email, String phone, String gender, String password) async {
    final response = await http.post(
      Uri.parse("$authUrl/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "phone_number": phone,
        "gender": gender,
        "password": password,
        "role": "user" // Default role
      }),
    );

    return jsonDecode(response.body);
  }

  // User Login
  static Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse("$authUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await saveToken(data["token"], data["role"]); // Save token & role
      return {"success": true, "role": data["role"]};
    } else {
      return {"success": false, "message": jsonDecode(response.body)["message"]};
    }
  }

  // Logout (Clear token)
  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
    prefs.remove("role");
  }

  // Fetch all users (Admin only)
  static Future<List<dynamic>> fetchUsers() async {
  String? token = await getToken();
  print("🔑 Token Sent: $token"); // Debugging: Print token

  final response = await http.get(
    Uri.parse("$adminUrl/users"),
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
  );

  print("📡 API Response Status: ${response.statusCode}");
  print("📡 API Response Body: ${response.body}");

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    print("❌ Error Fetching Users: ${response.body}");
    return [];
  }
}

  // Delete a user (Admin only)
  static Future<bool> deleteUser(String userId) async {
    String? token = await getToken();
    final response = await http.delete(
      Uri.parse("$adminUrl/users/$userId"),
      headers: {"Authorization": "Bearer $token"},
    );

    return response.statusCode == 200;
  }

  // Fetch all incidents (Admin only)
  static Future<List<dynamic>> fetchIncidents() async {
    String? token = await getToken();
    final response = await http.get(
      Uri.parse("$adminUrl/incidents"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return [];
    }
  }

  // Update incident status (Admin only)
  static Future<bool> updateIncidentStatus(String incidentId, String status) async {
    String? token = await getToken();
    final response = await http.put(
      Uri.parse("$adminUrl/incidents/$incidentId"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"status": status}),
    );

    return response.statusCode == 200;
  }

  // Report an incident
static Future<bool> reportIncident(String type, String description) async {
  String? token = await getToken();
  final response = await http.post(
    Uri.parse("$baseUrl/api/incidents/report"),
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "incident_type": type,
      "description": description,
    }),
  );

  return response.statusCode == 201;
}

// Fetch user's incidents
static Future<List<dynamic>> fetchUserIncidents() async {
  String? token = await getToken();
  final response = await http.get(
    Uri.parse("$baseUrl/api/incidents/my-incidents"),
    headers: {"Authorization": "Bearer $token"},
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return [];
  }
}

// Fetch scam alerts
static Future<List<dynamic>> fetchScamAlerts() async {
  String? token = await getToken();
  final response = await http.get(
    Uri.parse("$baseUrl/api/scam-alerts/alerts"),
    headers: {"Authorization": "Bearer $token"},
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return [];
  }
}

// Fetch notifications
static Future<List<dynamic>> fetchNotifications() async {
  String? token = await getToken();
  final response = await http.get(
    Uri.parse("$baseUrl/api/notifications"),
    headers: {"Authorization": "Bearer $token"},
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return [];
  }
}


}
