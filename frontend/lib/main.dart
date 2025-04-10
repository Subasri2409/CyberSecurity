import 'package:flutter/material.dart';
import './screens/login_screen.dart';
import './screens/register_screen.dart';
import './screens/admin_dashboard.dart';
import './screens/user_dashboard.dart';
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: "/login",
    routes: {
      "/login": (context) => LoginScreen(),
      "/register": (context) => RegisterScreen(),
      "/api/admin": (context) => AdminDashboard(),
      "/user": (context) => UserDashboard(),
    },
  ));
}
