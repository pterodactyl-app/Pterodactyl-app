import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {

  static Future<bool> setApiUrlString(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(key, value);
  }

  static Future<String> getApiUrlString(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(key) ?? '';
  }
}