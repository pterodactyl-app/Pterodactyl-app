import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:dynamic_theme/dynamic_theme.dart';
import './shared_preferences_helper.dart';
import 'main.dart';

class SettingsList extends StatefulWidget {
  @override
  SettingsListPageState createState() => new SettingsListPageState();
}

class SettingsListPageState extends State<SettingsList> {
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
                color: globals.isDarkTheme ? Colors.white : Colors.black,
              ),
              title: Text(
                'Enable notifications',
              ),
              subtitle: Text(
                'Get notifications in the Main Menu',
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
                color: globals.isDarkTheme ? Colors.white : Colors.black,
              ),
              title: Text(
                'Stay Logged In',
              ),
              subtitle: Text(
                'Logout from the Main Menu',
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
                Icons.sd_storage,
                color: globals.isDarkTheme ? Colors.white : Color(0xFF00567E),
              ),
              title: Text(
                DemoLocalizations.of(context).trans('night_mode'),
              ),
              subtitle: Text(
                'Black and Grey Theme',
              ),
              trailing: Switch(
                onChanged: handelTheme,
                value: globals.isDarkTheme,
              ),
            ),
            Divider(
              height: 20.0,
            ),
            ListTile(
              leading: Icon(
                Icons.color_lens,
                color: globals.isDarkTheme ? Colors.white : Colors.black,
              ),
              title: Text(
                DemoLocalizations.of(context).trans('settings_data'),
              ),
              subtitle: Text(
                'Delete data from APP',
              ),
              //trailing: Switch(
              //onChanged: handelTheme,
              //value: globals.isDarkTheme,
              //),
            ),
          ],
        ),
      )),
    );
  }
}
