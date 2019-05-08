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
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => LicencePage()));
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

class LicencePage extends StatelessWidget {
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
        title: Text(DemoLocalizations.of(context).trans('license'),
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
      body: Center(
        child: new ListView(
          children: <Widget>[
            new Text("GNU GENERAL PUBLIC LICENSE", textAlign: TextAlign.center),
            new Text("Version 3, 29 June 2007", textAlign: TextAlign.center),
            new Text("", textAlign: TextAlign.center),
            new Text(
                "Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>",
                textAlign: TextAlign.center),
            new Text(
                "Everyone is permitted to copy and distribute verbatim copies",
                textAlign: TextAlign.center),
            new Text(
                "of this license document, but changing it is not allowed.",
                textAlign: TextAlign.center),
            new Text("", textAlign: TextAlign.center),
            new Text("Preamble", textAlign: TextAlign.center),
            new Text("", textAlign: TextAlign.center),
            new Text(
                "The GNU General Public License is a free, copyleft license for software and other kinds of works.",
                textAlign: TextAlign.center),
            new Text("", textAlign: TextAlign.center),
            new Text(
                "The licenses for most software and other practical works are designed to take away your freedom to share and change the works.  By contrast, the GNU General Public License is intended to guarantee your freedom to share and change all versions of a program--to make sure it remains free software for all its users.  We, the Free Software Foundation, use the GNU General Public License for most of our software; it applies also to any other work released this way by its authors.  You can apply it to your programs, too.",
                textAlign: TextAlign.center),
            new Text("", textAlign: TextAlign.center),
            new Text(
                "When we speak of free software, we are referring to freedom, not price.  Our General Public Licenses are designed to make sure that you have the freedom to distribute copies of free software (and charge for them if you wish), that you receive source code or can get it if you want it, that you can change the software or use pieces of it in new free programs, and that you know you can do these things.",
                textAlign: TextAlign.center),
            new Text("", textAlign: TextAlign.center),
            new Text(
                "To protect your rights, we need to prevent others from denying you these rights or asking you to surrender the rights.  Therefore, you have certain responsibilities if you distribute copies of the software, or if you modify it: responsibilities to respect the freedom of others.",
                textAlign: TextAlign.center),
            new Text("", textAlign: TextAlign.center),
            new Text(
                "For example, if you distribute copies of such a program, whether gratis or for a fee, you must pass on to the recipients the same freedoms that you received.  You must make sure that they, too, receive or can get the source code.  And you must show them these terms so they know their rights.",
                textAlign: TextAlign.center),
            new Text("", textAlign: TextAlign.center),
            new Text(
                "Developers that use the GNU GPL protect your rights with two steps: (1) assert copyright on the software, and (2) offer you this License giving you legal permission to copy, distribute and/or modify it.",
                textAlign: TextAlign.center),
            new Text("", textAlign: TextAlign.center),
            new Text(
                "For the developers and authors protection, the GPL clearly explains that there is no warranty for this free software.  For both users and authors sake, the GPL requires that modified versions be marked as changed, so that their problems will not be attributed erroneously to authors of previous versions.",
                textAlign: TextAlign.center),
            new Text("", textAlign: TextAlign.center),
            new Text("", textAlign: TextAlign.center),
            new Text("", textAlign: TextAlign.center),
            new Text("", textAlign: TextAlign.center),
            new Text("", textAlign: TextAlign.center),
            new Text("", textAlign: TextAlign.center),
            new Text("", textAlign: TextAlign.center),
            new Text("", textAlign: TextAlign.center),
            new Text("", textAlign: TextAlign.center),
            new Text("", textAlign: TextAlign.center),
            new Text("", textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
