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
import 'package:pterodactyl_app/page/client/home.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pterodactyl_app/page/admin/adminhome.dart';

class Splash extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<Splash> {

  Future checkSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String company = prefs.get('company') != null
        ? prefs.getString('company')
        : null;

    if(prefs.containsKey('seen_admin') && prefs.getBool('seen_admin')) {
      checkAuthentication(isAdmin: true, prefs: prefs);
      return;
    }

    checkAuthentication(prefs: prefs, isCompany: company);

  }

  Future checkAuthentication({isAdmin = false, SharedPreferences prefs, isCompany}) async {

    isAuthenticated(isAdmin: isAdmin).then((bool) => {
      prefs.setBool('seen_' + (isAdmin ? 'admin' : 'client'), true).then((bool) => {
        if(isCompany == null) {
          Navigator.of(context).pushReplacement(
              new MaterialPageRoute(builder: (context) =>
              isAdmin ? new AdminHomePage() : new MyHomePage())
          )
        } else {
          Navigator.of(context).pushReplacementNamed(
              isAdmin
                  ? '/' + isCompany + '/admin/home'
                  : '/' + isCompany + '/home')
        }
      })
    });
  }

  Future<bool> isAuthenticated({isAdmin = false}) async {
    String _api, _https, _url, _route;
    if (isAdmin) {
      // Set authentication check route
      _route = "/application/servers";
      _api = await SharedPreferencesHelper.getString("apiAdminKey");
      _https = await SharedPreferencesHelper.getString("adminhttps");
      _url = await SharedPreferencesHelper.getString("panelAdminUrl");

    } else {
      // Set authentication check route
      _route = "/client";
      _api = await SharedPreferencesHelper.getString("apiKey");
      _https = await SharedPreferencesHelper.getString("https");
      _url = await SharedPreferencesHelper.getString("panelUrl");
    }

    // Host cannot be empty, otherwise an exception will occur.
    if(_https.isEmpty) {
      await Navigator.of(context).pushNamedAndRemoveUntil(
          '/' + (isAdmin ? 'admin' : '') + 'login', (
          Route<dynamic> route) => false);
      return false;
    }

    http.Response response = await http.get(
      "$_https$_url/api$_route",
      headers: {
        "Accept": "Application/vnd.pterodactyl.v1+json",
        "Authorization": "Bearer $_api"
      },
    );

    if (response.statusCode == 401) {
      // Todo fix Navigation context for logging out if key isn't available
      SharedPreferencesHelper.remove('apiKey');
      SharedPreferencesHelper.remove('apiAdminKey');
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/' + (isAdmin ? 'admin' : '') + 'login', (
          Route<dynamic> route) => false);
    }

  return true;

  }

  Future<bool> isCompanyLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('company');
  }

  @override
  void initState() {
    super.initState();    
//    if(await isCompanyLogin()) {
//
//      return;
//    }
    checkSeen();
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
