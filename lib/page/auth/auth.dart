/*
* Copyright 2018 Ruben Talstra and Yvan Watchman
*
* Licensed under the GNU General Public License v3.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*    https://www.gnu.org/licenses/gpl-3.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
import 'dart:async';
import 'package:pterodactyl_app/page/auth/shared_preferences_helper.dart';
import 'package:pterodactyl_app/page/client/login.dart';
import 'package:pterodactyl_app/page/client/home.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pterodactyl_app/page/admin/adminhome.dart';
import 'package:pterodactyl_app/page/admin/adminlogin.dart';

class Splash extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<Splash> {

  BuildContext context;

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var bool2 = prefs.getBool('seen');
    bool _seen = (bool2 ?? false);
    if (_seen) {
      if (await isAuthenticated()) {
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => new MyHomePage()));
      }
    } else {
      prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new LoginPage()));
    }
  }

  Future admincheckFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seenadmin = (prefs.getBool('seenadmin') ?? false);

    if (_seenadmin && await isAuthenticated(isAdmin: true)) {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new AdminHomePage()));
    } else {
      prefs.setBool('seenadmin', true);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new AdminLoginPage()));
    }
  }

  Future<bool> isAuthenticated({isAdmin = false}) async {
    if (isAdmin) {
      String _apiadmin = await SharedPreferencesHelper.getString("apiAdminKey");
      String _adminhttps =
          await SharedPreferencesHelper.getString("adminhttps");
      String _urladmin =
          await SharedPreferencesHelper.getString("panelAdminUrl");

      if(_urladmin.isEmpty) {
        SharedPreferencesHelper.remove('apiAdminKey');
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/adminlogin', (Route<dynamic> route) => false);
        return false;
      }

      http.Response response = await http.get(
        "$_adminhttps$_urladmin/api/application/servers",
        headers: {
          "Accept": "Application/vnd.pterodactyl.v1+json",
          "Authorization": "Bearer $_apiadmin"
        },
      );

      if (response.statusCode == 401) {
        // Todo fix Navigation context for logging out if key isn't available
        SharedPreferencesHelper.remove('apiAdminKey');
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/adminlogin', (Route<dynamic> route) => false);
        return false;
      } else {
        return true;
      }
    } else {
      String _apikey = await SharedPreferencesHelper.getString("apiKey");
      String _https = await SharedPreferencesHelper.getString("https");
      String _url = await SharedPreferencesHelper.getString("panelUrl");

      if(_url.isEmpty) {
        SharedPreferencesHelper.remove('apiKey');
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/login', (Route<dynamic> route) => false);
        return false;
      }

      http.Response response = await http.get(
        "$_https$_url/api/client",
        headers: {
          "Accept": "Application/vnd.pterodactyl.v1+json",
          "Authorization": "Bearer $_apikey"
        },
      );

      print(response.statusCode);

      if (response.statusCode == 401) {
        // Todo fix Navigation context for logging out if key isn't available
        SharedPreferencesHelper.remove('apiKey');
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
        return false;
      } else {
        return true;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkFirstSeen();
    admincheckFirstSeen();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return new Scaffold(
      body: new Center(
        child: new Text('Loading...'),
      ),
    );
  }
}
