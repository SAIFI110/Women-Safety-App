import 'package:shared_preferences/shared_preferences.dart';

class MySharedPrefrence {
  static SharedPreferences? _preferences;

  static const String keyUserType = 'usertype';
  static const String keyEmail = 'email';
  static const String keyUid = 'uid';

  /// INIT (call once in main)
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  /// SAVE USER TYPE (child / parent)
  static Future<void> saveUserType(String userType) async {
    await _preferences?.setString(keyUserType, userType);
  }

  /// GET USER TYPE
  static String? getUserType() {
    return _preferences?.getString(keyUserType);
  }

  /// SAVE EMAIL
  static Future<void> saveEmail(String email) async {
    await _preferences?.setString(keyEmail, email);
  }

  /// GET EMAIL
  static String? getEmail() {
    return _preferences?.getString(keyEmail);
  }

  /// SAVE UID
  static Future<void> saveUid(String uid) async {
    await _preferences?.setString(keyUid, uid);
  }

  /// GET UID
  static String? getUid() {
    return _preferences?.getString(keyUid);
  }

  /// CLEAR ALL (LOGOUT)
  static Future<void> clearAll() async {
    await _preferences?.clear();
  }
}