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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../globals.dart' as globals;
import 'package:flutter/services.dart';
import 'package:get_version/get_version.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import '../auth/shared_preferences_helper.dart';
import '../../main.dart';
import '../../sponsor.dart';

class AdminSettingsList extends StatefulWidget {
  @override
  AdminSettingsListPageState createState() => new AdminSettingsListPageState();
}

class AdminSettingsListPageState extends State<AdminSettingsList> {
  String _projectVersion = '';

  @override
  initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    String projectVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      projectVersion = await GetVersion.projectVersion;
    } on PlatformException {
      projectVersion = 'Failed to get project version.';
    }

    if (!mounted) return;

    setState(() {
      _projectVersion = projectVersion;
    });
  }

  void handelTheme(bool value) async {
// save new value
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool('Value', value);
    setState(() {
      globals.useDarkTheme = value;
      print(globals.useDarkTheme);
    });
    if (value == true) {
      DynamicTheme.of(context).setBrightness(Brightness.dark);
    } else {
      DynamicTheme.of(context).setBrightness(Brightness.light);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        backgroundColor: globals.useDarkTheme ? null : Colors.transparent,
        leading: IconButton(
          color: globals.useDarkTheme ? Colors.white : Colors.black,
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back,
              color: globals.useDarkTheme ? Colors.white : Colors.black),
        ),
        title: Text(DemoLocalizations.of(context).trans('settings'),
            style: TextStyle(
                color: globals.useDarkTheme ? Colors.white : Colors.black,
                fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
          child: SafeArea(
        child: ListBody(
          children: <Widget>[
            Container(
              height: 10.0,
            ),
            ListTile(
              leading: Icon(
                Icons.notifications,
              ),
              title: Text(
                DemoLocalizations.of(context).trans('notifications'),
              ),
              subtitle: Text(
                DemoLocalizations.of(context).trans('notifications_sub'),
              ),
              //trailing: Switch(
              //onChanged: handelTheme,
              //value: globals.useDarkTheme,
              //),
            ),
            Divider(
              height: 20.0,
            ),
            ListTile(
              leading: Icon(
                Icons.color_lens,
              ),
              title: Text(
                DemoLocalizations.of(context).trans('dark_mode'),
              ),
              subtitle: Text(
                DemoLocalizations.of(context).trans('dark_mode_sub'),
              ),
              trailing: Switch(
                  value: globals.useDarkTheme,
                  onChanged: (bool switchValue) {
                    handelTheme(switchValue);
                  }),
            ),
            Divider(
              height: 20.0,
            ),
            new ListTile(
              leading: Icon(Icons.insert_drive_file),
              title: Text(DemoLocalizations.of(context).trans('license')),
              subtitle:
                  new Text(DemoLocalizations.of(context).trans('license_sub')),
              onTap: () {
                launch(
                    'https://github.com/rubentalstra/Pterodactyl-app/blob/master/LICENSE');
              },
            ),
            Divider(
              height: 20.0,
            ),
            new ListTile(
              leading: Icon(Icons.euro_symbol),
              title: Text('Sponsors'),
              subtitle: new Text('Everyone who sponsored this project'),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => SponsorPage()));
              },
            ),
            Divider(
              height: 20.0,
            ),
            new ListTile(
              leading: new Icon(Icons.info),
              title: Text(DemoLocalizations.of(context).trans('app_version')),
              subtitle: new Text(_projectVersion),
              //onTap: () {
              //Navigator.of(context)
              //.push(MaterialPageRoute(builder: (_) => LicencePage()));
              //},
            ),
            Divider(
              height: 20.0,
            ),
            new ListTile(
              leading: Icon(Icons.subdirectory_arrow_left),
              title: Text(DemoLocalizations.of(context).trans('logout')),
              subtitle:
                  new Text(DemoLocalizations.of(context).trans('logout_sub')),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('seenadmin');
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/adminlogin', (Route<dynamic> route) => false);
              },
            ),
            Divider(
              height: 20.0,
            ),
            new ListTile(
              leading: Icon(Icons.delete_forever, color: Colors.red),
              title: Text(DemoLocalizations.of(context).trans('delete_data')),
              subtitle: new Text(
                  DemoLocalizations.of(context).trans('delete_data_sub')),
              onTap: () async {
                SharedPreferencesHelper.remove("panelAdminUrl");
                SharedPreferencesHelper.remove("apiAdminKey");
                SharedPreferencesHelper.remove("adminhttps");
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('seenadmin');
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login', (Route<dynamic> route) => false);
              },
            ),
          ],
        ),
      )),
    );
  }
}
