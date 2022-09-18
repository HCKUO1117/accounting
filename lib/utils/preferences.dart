import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static SharedPreferences? preferences;

  static Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
  }

  static Future<void> setString(String key, String value) async {
    await preferences?.setString(key, value);
  }

  static String getString(String key, String defaultValue) {
    return preferences?.getString(key) ?? defaultValue;
  }

  static Future<void> setBool(String key, bool value) async {
    await preferences?.setBool(key, value);
  }

  static bool getBool(String key, bool defaultValue) {
    return preferences?.getBool(key) ?? defaultValue;
  }
}
