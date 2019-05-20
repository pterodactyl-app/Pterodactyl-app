import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SharedPreferencesHelper {
  static Future<bool> setString(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(key, value);
  }

  static Future<String> getString(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(key) ?? '';
  }

  static Future<bool> isAuthenticated([isAdmin=false]) async {
    if(isAdmin) {
      String _apiadmin = await SharedPreferencesHelper.getString("apiAdminKey");
      String _adminhttps = await SharedPreferencesHelper.getString(
          "adminhttps");
      String _urladmin = await SharedPreferencesHelper.getString(
          "panelAdminUrl");

      print("$_adminhttps$_urladmin/api/application/servers");
      http.Response response = await http.get(
        "$_adminhttps$_urladmin/api/application/servers",
        headers: {
          "Accept": "Application/vnd.pterodactyl.v1+json",
          "Authorization": "Bearer $_apiadmin"
        },
      ).catchError((val) {
        remove('apiAdminKey');
      });
    } else {
      String _apikey = await SharedPreferencesHelper.getString("apiKey");
      String _adminhttps = await SharedPreferencesHelper.getString(
          "https");
      String _urladmin = await SharedPreferencesHelper.getString(
          "panelUrl");

      print("$_adminhttps$_urladmin/api/application/servers");
      http.Response response = await http.get(
        "$_adminhttps$_urladmin/api/client",
        headers: {
          "Accept": "Application/vnd.pterodactyl.v1+json",
          "Authorization": "Bearer $_apikey"
        },
      ).catchError((val) {
        remove('apiKey');
      });
    }
  }

  static remove(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove(key);
  }
}
