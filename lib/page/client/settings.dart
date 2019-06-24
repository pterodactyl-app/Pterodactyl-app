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
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_version/get_version.dart';
import 'package:pterodactyl_app/globals.dart' as globals;
import 'package:pterodactyl_app/main.dart';
import 'package:pterodactyl_app/sponsor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:simple_gravatar/simple_gravatar.dart';
import 'package:pterodactyl_app/page/client/settings/circular_image.dart';
import 'package:division/division.dart';

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
      child: Division(
        child: Column(
          children: <Widget>[
            UserCard(),
            ActionsRow(),
            Settings(),
          ],
        ),
      ),
    )
    );
  }
}



class UserCard extends StatelessWidget {

/*
  final gravatar = Gravatar('hello@example.com');
  final String imageUrl = gravatar.imageUrl(
    size: 100,
    defaultImage: GravatarImage.retro,
    rating: GravatarRating.pg,
    fileExtension: true,
  );
*/

final String imageUrl =
      "https://s3-eu-west-1.amazonaws.com/tpd/logos/5aa8567e43efc80001d1319e/0x0.png";


  Widget _buildUserRow() {
    return Row(
      children: <Widget>[
        Padding(
                padding: const EdgeInsets.only(right: 16),
                child: CircularImage(
                  NetworkImage(imageUrl),
                ),
              ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '\$name',
              style: nameTextStyle,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Creative builder',
              style: nameDescriptionTextStyle,
            )
          ],
        )
      ],
    );
  }

  Widget _buildUserStats() {
    return Division(
      style: userStatsStyle,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildUserStatsItem(10, 'Owns'),
          _buildUserStatsItem(2, 'Sub-user'),
          _buildUserStatsItem(4, 'schedules'),
        ],
      ),
    );
  }

  Widget _buildUserStatsItem(int value, String text) {
    return Column(
      children: <Widget>[
        Text(
          value.toString(),
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          text,
          style: nameDescriptionTextStyle,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Division(
      style: userCardStyle,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[_buildUserRow(), _buildUserStats()],
      ),
    );
  }

  //Styling

  final StyleClass userCardStyle = StyleClass()
    .height(175)
    .padding(horizontal: 20.0, vertical: 10)
    .align('center')
    .backgroundColor('#3977FF')
    .borderRadius(all: 20.0)
    .elevation(10, color: '#3977FF');

  final StyleClass userImageStyle = StyleClass()
    .height(50)
    .width(50)
    .margin(right: 10.0)
    .borderRadius(all: 30)
    .backgroundColor('ffffff');

  final StyleClass userStatsStyle = StyleClass().margin(vertical: 10.0);

  final TextStyle nameTextStyle = TextStyle(
      color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w600);

  final TextStyle nameDescriptionTextStyle =
      TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12.0);
}

class ActionsRow extends StatelessWidget {
  Widget _buildActionsItem(String title, IconData icon) {
    return Division(
      style: actionsItemStyle,
      child: Column(
        children: <Widget>[
          Division(
            style: actionsItemIconStyle,
            child: Icon(
              icon,
              size: 20,
              color: Color(0xFF42526F),
            ),
          ),
          Text(
            title,
            style: actionsItemTextStyle,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _buildActionsItem('Sponsors', FontAwesomeIcons.handHoldingUsd),
        _buildActionsItem('Partners', FontAwesomeIcons.handshake),
        _buildActionsItem('Website', FontAwesomeIcons.link),
        _buildActionsItem(DemoLocalizations.of(context).trans('license'), FontAwesomeIcons.certificate),
      ],
    );
  }

  final StyleClass actionsItemIconStyle = StyleClass()
    .alignChild('center')
    .width(50)
    .height(50)
    .margin(bottom: 5)
    .borderRadius(all: 30)
    .backgroundColor('#F6F5F8');

  final StyleClass actionsItemStyle = StyleClass().margin(vertical: 20.0);

  final TextStyle actionsItemTextStyle =
      TextStyle(color: Colors.black.withOpacity(0.8), fontSize: 12);
}

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Division(
      style: settingsStyle,
      child: Column(
        children: <Widget>[
          SettingsItem(Icons.notifications, '#5FD0D3', DemoLocalizations.of(context).trans('notifications'),
              DemoLocalizations.of(context).trans('notifications_sub')),
          SettingsItem(Icons.question_answer, '#BFACAA', DemoLocalizations.of(context).trans('dark_mode'),
              DemoLocalizations.of(context).trans('dark_mode_sub')),


          SettingsItem(
              Icons.lock, '#F468B7', DemoLocalizations.of(context).trans('logout'), DemoLocalizations.of(context).trans('logout_sub')),
          SettingsItem(
              Icons.menu, '#FEC85C', DemoLocalizations.of(context).trans('delete_data'), DemoLocalizations.of(context).trans('delete_data_sub')),

        ],
      ),
    );
  }

  final StyleClass settingsStyle = StyleClass();
}

class SettingsItem extends StatefulWidget {
  final IconData icon;
  final String iconBgColor;
  final String title;
  final String description;

  SettingsItem(this.icon, this.iconBgColor, this.title, this.description);

  @override
  _SettingsItemState createState() => _SettingsItemState();
}

class _SettingsItemState extends State<SettingsItem> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return Division(
        style: settingsItemStyle
          .elevation(pressed ? 0 : 50, color: Colors.grey)
          .scale(pressed ? 0.95 : 1.0),
        gesture: GestureClass()
          .onTapDown((details) => setState(() => pressed = true))
          .onTapUp((details) => setState(() => pressed = false))
          .onTapCancel(() => setState(() => pressed = false)),
        child: Row(
          children: <Widget>[
            Division(
              style: StyleClass()
                .backgroundColor(widget.iconBgColor)
                .add(settingsItemIconStyle),
              child: Icon(
                widget.icon,
                color: Colors.white,
                size: 20,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.title,
                  style: itemTitleTextStyle,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  widget.description,
                  style: itemDescriptionTextStyle,
                ),
              ],
            )
          ],
        ));
  }

  final StyleClass settingsItemStyle = StyleClass()
    .alignChild('center')
    .height(70)
    .margin(vertical: 10)
    .borderRadius(all: 15)
    .backgroundColor('#ffffff')
    .ripple(true)
    .animate(300, Curves.easeOut);

  final StyleClass settingsItemIconStyle = StyleClass()
    .margin(left: 15)
    .padding(all: 12)
    .borderRadius(all: 30);

  final TextStyle itemTitleTextStyle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 16);

  final TextStyle itemDescriptionTextStyle = TextStyle(
      color: Colors.black26, fontWeight: FontWeight.bold, fontSize: 12);
}




/*
SingleChildScrollView(
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
                prefs.remove('seen');
                prefs.remove('first_name');
                prefs.remove('last_name');
                prefs.remove('email');
                if (prefs.containsKey('apiUser') &&
                    await prefs.get('apiUser') != null) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login_user', (Route<dynamic> route) => false);
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login', (Route<dynamic> route) => false);
                }
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
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login', (Route<dynamic> route) => false);
              },
            ),
          ],
        ),
      )),
*/