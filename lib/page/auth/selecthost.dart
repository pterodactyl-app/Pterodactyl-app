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

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pterodactyl_app/globals.dart' as globals;
import 'package:pterodactyl_app/page/client/login.dart';
import 'package:pterodactyl_app/page/client/login_with_username.dart';
import 'package:pterodactyl_app/page/company/accuratenode/client/login.dart';
import 'package:pterodactyl_app/page/company/coderslight/client/login.dart';
import 'package:pterodactyl_app/page/company/deploys/client/login.dart';
import 'package:pterodactyl_app/page/company/minicenter/client/login.dart';
import 'package:pterodactyl_app/page/company/planetnode/client/login.dart';
import 'package:pterodactyl_app/page/company/revivenode/client/login.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SelectHostPage extends StatefulWidget {
  SelectHostPage({Key key}) : super(key: key);

  @override
  _SelectHostPageState createState() => _SelectHostPageState();
}

class _SelectHostPageState extends State<SelectHostPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 2.0,
          backgroundColor: globals.useDarkTheme ? null : Colors.white,
          title: Text('Host Login',
              style: TextStyle(
                  color: globals.useDarkTheme ? null : Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 30.0
              )
          ),
          actions: <Widget>[
            new IconButton(icon: Icon(Icons.invert_colors), onPressed: () {
              handelTheme(!globals.useDarkTheme);
            })
          ],
        ),
        body: StaggeredGridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          children: <Widget>[
            _buildTile(
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Image.network(
                                globals.useDarkTheme
                                    ? 'https://deploys.io/img/deploys.io/logo/text/light.png'
                                    : 'https://deploys.io/img/deploys.io/logo/text/dark.png',
                                width: 100),
                          ],
                        ),
                      ]),
                ), onTap: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setString('company', 'deploys');
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => LoginDeploysPage()));
            }),
            _buildTile(
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Image.network(
                                globals.useDarkTheme
                                    ? 'https://planetnode.net/templates/planetnode/img/header/logo.png'
                                    : 'https://planetnode.net/templates/planetnode/img/header/logo-b.png',
                              width: 100,
                              height: 60,
                            ),
                          ],
                        ),
                      ]),
                ), onTap: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setString('company', 'planetnode');
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => LoginPlanetNodePage()));
            }),
            _buildTile(
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Image.network(
                                globals.useDarkTheme
                                    ? 'https://avatars2.githubusercontent.com/u/35084758?s=280&v=4'
                                    : 'https://pbs.twimg.com/profile_images/1041472632984616961/uIjCN238.jpg',
                              width: 100,
                              height: 60,
                            ),
                          ],
                        ),
                      ]),
                ), onTap: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setString('company', 'coderslight');
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => LoginCodersLightPage()));
            }),
            _buildTile(
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Image.network(
                                globals.useDarkTheme
                                    ? 'https://accuratenode.com/assets/img/icon.png'
                                    : 'https://accuratenode.com/assets/img/icon.png',
                              width: 100,
                              height: 60,

                            ),
                          ],
                        ),
                      ]),
                ), onTap: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setString('company', 'accuratenode');
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => LoginAccurateNodePage()));
            }),            
            _buildTile(
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Image.network(
                                globals.useDarkTheme
                                    ? 'https://cdn.discordapp.com/attachments/582365380798971934/589519836997222420/RLogo.png'
                                    : 'https://cdn.discordapp.com/attachments/582365380798971934/589519836997222420/RLogo.png',
                              width: 100,
                              height: 60,
                            ),
                          ],
                        ),
                      ]),
                ), onTap: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setString('company', 'revivenode');
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => LoginReviveNodePage()));
            }),             
            _buildTile(
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('MiniCenter',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 23.0
                                )
                            ),
                          ],
                        ),
                      ]),
                ), onTap: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setString('company', 'minicenter');
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => LoginMiniCenterPage()));
            }),                                     
            _buildTile(
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Other',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 23.0
                                )
                            ),
                          ],
                        ),
                      ]),
                ), onTap: () async {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => LoginPage()));
            }),
            _buildTile(
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Other',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 23.0
                                )
                            ),
                            Text('w/ username',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 23.0
                                )
                            ),
                          ],
                        ),
                      ]),
                ), onTap: () async {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => LoginWithUsernamePage()));
            }),
          ],
          staggeredTiles: [
            StaggeredTile.extent(1, 110.0),
            StaggeredTile.extent(1, 110.0),
            StaggeredTile.extent(1, 110.0),
            StaggeredTile.extent(1, 110.0),
            StaggeredTile.extent(1, 110.0),
            StaggeredTile.extent(1, 110.0),
            StaggeredTile.extent(1, 110.0),
            StaggeredTile.extent(1, 110.0),
          ],
        ));
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

  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: globals.useDarkTheme ? Colors.blueGrey : Color(0x802196F3),
        child: InkWell(
            // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null
                ? () => onTap()
                : () {
                    print('Not set yet');
                  },
            child: child));
  }
}

Future<Map> _updatePartners() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
}
