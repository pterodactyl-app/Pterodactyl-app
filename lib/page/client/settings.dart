import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../globals.dart' as globals;
import 'package:flutter/services.dart';
import 'package:get_version/get_version.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import '../auth/shared_preferences_helper.dart';
import '../../main.dart';
import '../../sponsor.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsList extends StatefulWidget {
  @override
  SettingsListPageState createState() => new SettingsListPageState();
}

class SettingsListPageState extends State<SettingsList> {
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

  void handelTheme(bool value) {
    setState(() {
      globals.isDarkTheme = value;
      globals.isDarkTheme = globals.isDarkTheme;
      if (globals.isDarkTheme) {
        DynamicTheme.of(context).setBrightness(Brightness.dark);
      } else {
        DynamicTheme.of(context).setBrightness(Brightness.light);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        backgroundColor: globals.isDarkTheme ? null : Colors.transparent,
        leading: IconButton(
          color: globals.isDarkTheme ? Colors.white : Colors.black,
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back,
              color: globals.isDarkTheme ? Colors.white : Colors.black),
        ),
        title: Text(DemoLocalizations.of(context).trans('settings'),
            style: TextStyle(
                color: globals.isDarkTheme ? Colors.white : Colors.black,
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
              //value: globals.isDarkTheme,
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
                onChanged: handelTheme,
                value: globals.isDarkTheme,
              ),
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
                prefs.remove('seen');
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login', (Route<dynamic> route) => false);
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
                SharedPreferencesHelper.remove("panelUrl");
                SharedPreferencesHelper.remove("apiKey");
                SharedPreferencesHelper.remove("https");
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('seen');
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
