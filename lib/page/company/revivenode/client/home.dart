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
import 'package:flutter/material.dart';
import 'package:pterodactyl_app/page/auth/shared_preferences_helper.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:pterodactyl_app/globals.dart' as globals;
import 'dart:async';
import 'dart:convert';
import 'servers.dart';
import 'settings.dart';
import 'package:pterodactyl_app/main.dart';

class MyReviveNodeHomePage extends StatefulWidget {
  MyReviveNodeHomePage({Key key}) : super(key: key);

  @override
  _MyReviveNodeHomePageState createState() => _MyReviveNodeHomePageState();
}

class _MyReviveNodeHomePageState extends State<MyReviveNodeHomePage> {
  Map data;
  int userTotalServers = 0;

  Future getDataHome() async {
    String _api = await SharedPreferencesHelper.getString("api_revicenode_Key");

    try {
      http.Response response = await http.get(
        "https://panel.revivenode.com/api/client",
        headers: {
          "Accept": "Application/vnd.pterodactyl.v1+json",
          "Authorization": "Bearer $_api"
        },
      );

      data = await json.decode(response.body);
      setState(() {
        userTotalServers = data["meta"]["pagination"]["total"];
      });
    } on SocketException catch (e) {
      print('Error occured: ' + e.message);
      print('End debug');
    }
  }

  @override
  void initState() {
    super.initState();

    getDataHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 2.0,
          backgroundColor: globals.useDarkTheme ? null : Colors.white,
          title: Text('Deploys.io Panel',
              style: TextStyle(
                  color: globals.useDarkTheme ? null : Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 30.0)),
          //actions: <Widget>[
          //Container(
          //margin: EdgeInsets.only(right: 8.0),
          //child: Row(
          //mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          //children: <Widget>[
          //Text(DemoLocalizations.of(context).trans('logout'),
          //style: TextStyle(
          //color:
          //globals.isDarkTheme ? Colors.white : Colors.blue,
          //fontWeight: FontWeight.w700,
          //fontSize: 14.0)),
          //Icon(
          //Icons.subdirectory_arrow_left,
          //color: globals.isDarkTheme ? Colors.white : Colors.black,
          //)
          //],
          //),
          //)
          //],
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              DemoLocalizations.of(context)
                                  .trans('total_servers'),
                              style: TextStyle(color: Colors.blueAccent)),
                          Text('$userTotalServers',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 34.0))
                        ],
                      ),
                      Material(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(24.0),
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(Icons.dns,
                                color: Colors.white, size: 30.0),
                          )))
                    ]),
              ),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => ReviveNodeServerListPage())),
            ),
            _buildTile(
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Material(
                          color: Colors.teal,
                          shape: CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(Icons.settings_applications,
                                color: Colors.white, size: 30.0),
                          )),
                      Padding(padding: EdgeInsets.only(bottom: 10.0)),
                      Text(DemoLocalizations.of(context).trans('settings'),
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 24.0)),
                      Text(DemoLocalizations.of(context).trans('settings_sub'),
                          style: TextStyle(
                            color: globals.useDarkTheme
                                ? Colors.white70
                                : Colors.black45,
                          )),
                    ]),
              ),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => ReviveNodeSettingsList())),
            ),
            _buildTile(
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Material(
                          color: Colors.amber,
                          shape: CircleBorder(),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Icon(Icons.notifications,
                                color: Colors.white, size: 30.0),
                          )),
                      Padding(padding: EdgeInsets.only(bottom: 10.0)),
                      Text(DemoLocalizations.of(context).trans('alerts'),
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 24.0)),
                      Text(DemoLocalizations.of(context).trans('alerts_sub'),
                          style: TextStyle(
                            color: globals.useDarkTheme
                                ? Colors.white70
                                : Colors.black45,
                          )),
                    ]),
              ),
              //onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ShopItemsPage())),
              onTap: () {
                print('Not set yet');
              },
            ),
          ],
          staggeredTiles: [
            StaggeredTile.extent(2, 114.0),
            StaggeredTile.extent(1, 187.0),
            StaggeredTile.extent(1, 187.0),
            StaggeredTile.extent(2, 120.0),
          ],
        ));
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
