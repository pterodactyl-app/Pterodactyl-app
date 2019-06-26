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
import 'package:pterodactyl_app/models/settings.dart';
import 'package:simple_gravatar/simple_gravatar.dart';
import 'package:pterodactyl_app/page/client/settings/circular_image.dart';
import 'package:division/division.dart';

class SettingsList extends StatefulWidget {
  SettingsList({Key key,  this.settings}) : super(key: key);
  final SettingsInfo settings;

  @override
  SettingsListPageState createState() => new SettingsListPageState(this.settings);
}

class SettingsListPageState extends State<SettingsList> {
  static String _projectVersion = '';

  SettingsListPageState(this.settings);

  SettingsInfo settings;

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
            UserCard(this.settings),
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

  UserCard(this.settings);

  SettingsInfo settings;

  String getGravatarUrl() {
    Gravatar gravatar = new Gravatar(this.settings.email);
    return gravatar.imageUrl(
      size: 64,
      defaultImage: GravatarImage.retro,
      rating: GravatarRating.pg,
      fileExtension: true,
    );
  }

  Widget _buildUserRow() {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: CircularImage(
            NetworkImage(getGravatarUrl()),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              settings.name,
              style: nameTextStyle,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              settings.email,
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
          _buildUserStatsItem(this.settings.servers, 'Owns'),
          _buildUserStatsItem(this.settings.subServer, 'Sub-user'),
          _buildUserStatsItem(this.settings.schedules, 'Schedules'),
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
  // ignore: avoid_init_to_null
  Widget _buildActionsItem(String title, IconData icon, {Function onTap: null}) {
    return Division(
      gesture: onTap != null ? GestureClass().onTap(onTap) : null,
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
        _buildActionsItem('Sponsors', FontAwesomeIcons.handHoldingUsd, onTap: () =>
            Navigator.of(context).push(
                new MaterialPageRoute(
                    builder: (BuildContext context) => new SponsorPage()
                )
            )),
        _buildActionsItem('Partners', FontAwesomeIcons.handshake, 
/*
        onTap: () =>
            Navigator.of(context).push(
                new MaterialPageRoute(
                    builder: (BuildContext context) => new PartnerPage()
                )
            )
*/
            ),
        _buildActionsItem('Website', FontAwesomeIcons.link, onTap: () =>
            launch('https://pterodactyl-app.com/')),
        _buildActionsItem(DemoLocalizations.of(context).trans('license'), FontAwesomeIcons.certificate, onTap: () =>
            launch('https://github.com/rubentalstra/Pterodactyl-app/blob/master/LICENSE')),
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
      TextStyle(color: globals.useDarkTheme ? Colors.white : Colors.black.withOpacity(0.8), fontSize: 12);
}

class Settings extends StatelessWidget {


  void handleTheme(bool value, BuildContext context) async {
// save new value
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool('Value', value);
    globals.useDarkTheme = value;
    if (value == true) {
      DynamicTheme.of(context).setBrightness(Brightness.dark);
    } else {
      DynamicTheme.of(context).setBrightness(Brightness.light);
    }
  }
  
  Widget _buildSettingsItem(IconData icon, String iconBgColor, String title, String description, {Function onTap: null}) {
// ignore: avoid_init_to_null
    return Division(
        style: settingsItemStyle,
        child: InkWell(
        onTap: onTap,
        child: Row(
          children: <Widget>[
            Division(
              style: StyleClass()
                .backgroundColor(iconBgColor)
                .add(settingsItemIconStyle),
              child: Icon(
                icon,
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
                  title,
                  style: itemTitleTextStyle,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  description,
                  style: itemDescriptionTextStyle,
                ),
              ],
            )
          ],
        )));
  }






  @override
  Widget build(BuildContext context) {
    return Division(
      style: settingsStyle,
      child: Column(
        children: <Widget>[
          _buildSettingsItem(FontAwesomeIcons.bell, '#5FD0D3', DemoLocalizations.of(context).trans('notifications'),
              DemoLocalizations.of(context).trans('notifications_sub'), 
            onTap: () {
              
            }),
          _buildSettingsItem(FontAwesomeIcons.adjust, '#BFACAA', DemoLocalizations.of(context).trans('dark_mode'),
              DemoLocalizations.of(context).trans('dark_mode_sub'), onTap: () {
              handleTheme(!globals.useDarkTheme, context);
            }),


          _buildSettingsItem(
              FontAwesomeIcons.signOutAlt, '#F468B7', DemoLocalizations.of(context).trans('logout'), DemoLocalizations.of(context).trans('logout_sub'), onTap: () async {
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
              },),
          _buildSettingsItem(
              FontAwesomeIcons.trashAlt, '#FEC85C', DemoLocalizations.of(context).trans('delete_data'), DemoLocalizations.of(context).trans('delete_data_sub'), onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login', (Route<dynamic> route) => false);
              }),
          _buildSettingsItem(
              FontAwesomeIcons.mobile,
              '#5FD0D3',
              DemoLocalizations.of(context).trans('app_version'),
              SettingsListPageState._projectVersion,
              onTap: () {}),

        ],
      ),
    );

    
  }

  final StyleClass settingsStyle = StyleClass();




  final StyleClass settingsItemStyle = StyleClass()
    .alignChild('center')
    .height(70)
    .margin(vertical: 10)
    .borderRadius(all: 15)
    .backgroundColor(globals.useDarkTheme ? Colors.black26 : Colors.white)
    .ripple(true)
    .animate(300, Curves.easeOut);

  final StyleClass settingsItemIconStyle = StyleClass()
    .margin(left: 15)
    .padding(all: 12)
    .borderRadius(all: 30);

  final TextStyle itemTitleTextStyle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 16);

  final TextStyle itemDescriptionTextStyle = TextStyle(
      color: globals.useDarkTheme ? Colors.white30 : Colors.black26, fontWeight: FontWeight.bold, fontSize: 12);


      
}
