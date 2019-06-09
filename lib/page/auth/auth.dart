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
import 'package:pterodactyl_app/page/auth/check_update.dart';
import 'package:pterodactyl_app/page/auth/shared_preferences_helper.dart';
import 'package:pterodactyl_app/page/client/home.dart';
import 'package:pterodactyl_app/page/client/login.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pterodactyl_app/page/admin/adminhome.dart';
import 'package:pterodactyl_app/page/admin/adminlogin.dart';
import 'package:pterodactyl_app/page/company/deploys/client/home.dart';
import 'package:pterodactyl_app/page/company/deploys/client/login.dart';
import 'package:pterodactyl_app/page/auth/selecthost.dart';

class Splash extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<Splash> {

  Future checkSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    checkAuthentication(prefs: prefs);

//    if(prefs.containsKey('seen_admin') && prefs.getBool('seen_admin')) {
//      return checkAuthentication();
//    }
//
//    if (prefs.containsKey('seen_client') && prefs.getBool('seen_client')) {
//      return;
//    }

  }

  Future checkAuthentication({isAdmin = false, SharedPreferences prefs}) async {

    isAuthenticated(isAdmin: isAdmin).then((bool) => {
      prefs.setBool('seen_' + (isAdmin ? 'admin' : 'client'), true).then((bool) => {
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => isAdmin ? new AdminHomePage() : new MyHomePage())
        )
      })
    });
  }

  Future<bool> isAuthenticated({isAdmin = false}) async {
    if (isAdmin) {
      String _apiadmin = await SharedPreferencesHelper.getString("apiAdminKey");
      String _adminhttps =
          await SharedPreferencesHelper.getString("adminhttps");
      String _urladmin =
          await SharedPreferencesHelper.getString("panelAdminUrl");

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

      http.Response response = await http.get(
        "$_https$_url/api/client",
        headers: {
          "Accept": "Application/vnd.pterodactyl.v1+json",
          "Authorization": "Bearer $_apikey"
        },
      );

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
    checkSeen();
//    checkFirstSeen();
//    admincheckFirstSeen();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Text('Loading...'),
      ),
    );
  }
}
