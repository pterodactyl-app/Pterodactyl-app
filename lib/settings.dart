import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:flutter/services.dart';
import 'package:get_version/get_version.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import './shared_preferences_helper.dart';
import 'package:pterodactyl_app/login.dart';
import 'main.dart';

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
        // actions: <Widget>
        // [
        //   Container
        //   (
        //     margin: EdgeInsets.only(right: 8.0),
        //     child: Row
        //     (
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       children: <Widget>
        //       [
        //         Text('beclothed.com', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14.0)),
        //         Icon(Icons.arrow_drop_down, color: Colors.black54)
        //       ],
        //     ),
        //   )
        // ],
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
                Icons.account_box,
              ),
              title: Text(
                DemoLocalizations.of(context).trans('stay_logged_in'),
              ),
              subtitle: Text(
                DemoLocalizations.of(context).trans('stay_logged_in_sub'),
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
              //onTap: () {
              //Navigator.of(context)
              //.push(MaterialPageRoute(builder: (_) => LicencePage()));
              //},
            ),
            Divider(
              height: 20.0,
            ),
            new ListTile(
              leading: new Icon(Icons.info),
              title: Text(DemoLocalizations.of(context).trans('app_version')),
              subtitle: new Text(_projectVersion),
            ),
            Divider(
              height: 20.0,
            ),
            new ListTile(
              leading: Icon(Icons.subdirectory_arrow_left),
              title: Text(DemoLocalizations.of(context).trans('logout')),
              subtitle:
                  new Text(DemoLocalizations.of(context).trans('logout_sub')),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new LoginPage()),
                    (Route<dynamic> route) => false);
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
              onTap: () {
                SharedPreferencesHelper.remove("panelUrl");
                SharedPreferencesHelper.remove("apiKey");
                Navigator.of(context).pushAndRemoveUntil(
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new LoginPage()),
                    (Route<dynamic> route) => false);
              },
            ),
          ],
        ),
      )),
    );
  }
}
