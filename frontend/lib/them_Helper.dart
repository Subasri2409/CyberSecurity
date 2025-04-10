import 'package:shared_preferences/shared_preferences.dart';

class ThemeHelper {
  static const String _themeKey = "isDarkMode";

  // Get saved theme preference
  static Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false; // Default is light mode
  }

  // Save theme preference
  static Future<void> setTheme(bool isDarkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDarkMode);
  }
}
