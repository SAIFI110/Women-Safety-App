import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreference {
  static SharedPreferences? preferences;

  static Future init() async {
    preferences = await SharedPreferences.getInstance();
  }

  // Save Role
  static Future setRole(String role) async {
    await preferences?.setString("role", role);
  }

  // Get Role
  static String? getRole() {
    return preferences?.getString("role");
  }

  // Save UID
  static Future setUid(String uid) async {
    await preferences?.setString("uid", uid);
  }

  // Get UID
  static String? getUid() {
    return preferences?.getString("uid");
  }

  // Save Login Status
  static Future setLogin(bool value) async {
    await preferences?.setBool("isLoggedIn", value);
  }

  // Get Login Status
  static bool getLogin() {
    return preferences?.getBool("isLoggedIn") ?? false;
  }

  // Logout / Clear Data
  static Future clearData() async {
    await preferences?.clear();
  }
}