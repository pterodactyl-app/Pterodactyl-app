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
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:pterodactyl_app/globals.dart' as globals;
import 'package:pterodactyl_app/models/Server.dart';
import 'package:pterodactyl_app/models/Stats.dart';
import 'package:pterodactyl_app/page/auth/shared_preferences_helper.dart';
import 'dart:async';
import 'dart:convert';
import 'package:pterodactyl_app/main.dart';
import 'package:pterodactyl_app/page/company/accuratenode/client/console.dart';
import 'package:pterodactyl_app/page/company/accuratenode/client/utilization.dart';

class ActionServerPage extends StatefulWidget {
  ActionServerPage({Key key, this.server}) : super(key: key);
  final Server server;

  @override
  _ActionServerPageState createState() => _ActionServerPageState();
}

class _ActionServerPageState extends State<ActionServerPage> {
  Map data;

  Future postStart() async {
    String _api = await SharedPreferencesHelper.getString("api_accuratenode_Key");
    var url =
        'https://panel.accuratenode.com/api/client/servers/${widget.server.id}/power';

    Map data = {'signal': 'start'};
    //encode Map to JSON
    var body = json.encode(data);

    var response = await http.post(url,
        headers: {
          "Accept": "Application/vnd.pterodactyl.v1+json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $_api"
        },
        body: body);
    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }

  Future postStop() async {
    String _api = await SharedPreferencesHelper.getString("api_accuratenode_Key");
    var url =
        'https://panel.accuratenode.com/api/client/servers/${widget.server.id}/power';

    Map data = {'signal': 'stop'};
    //encode Map to JSON
    var body = json.encode(data);

    var response = await http.post(url,
        headers: {
          "Accept": "Application/vnd.pterodactyl.v1+json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $_api"
        },
        body: body);
    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }

  Future postRestart() async {
    String _api = await SharedPreferencesHelper.getString("api_accuratenode_Key");
    var url =
        'https://panel.accuratenode.com/api/client/servers/${widget.server.id}/power';

    Map data = {'signal': 'restart'};
    //encode Map to JSON
    var body = json.encode(data);

    var response = await http.post(url,
        headers: {
          "Accept": "Application/vnd.pterodactyl.v1+json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $_api"
        },
        body: body);
    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }

  Future postKill() async {
    String _api = await SharedPreferencesHelper.getString("api_accuratenode_Key");
    var url =
        'https://panel.accuratenode.com/api/client/servers/${widget.server.id}/power';

    Map data = {'signal': 'kill'};
    //encode Map to JSON
    var body = json.encode(data);

    var response = await http.post(url,
        headers: {
          "Accept": "Application/vnd.pterodactyl.v1+json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $_api"
        },
        body: body);
    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: globals.useDarkTheme ? null : Colors.transparent,
          leading: IconButton(
            color: globals.useDarkTheme ? Colors.white : Colors.black,
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back,
              color: globals.useDarkTheme ? Colors.white : Colors.black,
            ),
          ),
          title: Text('${widget.server.name}',
              style: TextStyle(
                  color: globals.useDarkTheme ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w700)),
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
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Material(
                          color: Colors.green,
                          shape: CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(Icons.play_arrow,
                                color: Colors.white, size: 30.0),
                          )),
                      Padding(padding: EdgeInsets.only(bottom: 12.0)),
                      Text(DemoLocalizations.of(context).trans('action_start'),
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 23.0)),
                    ]),
              ),
              onTap: () {
                postStart();
              },
            ),
            _buildTile(
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Material(
                          color: Colors.red,
                          shape: CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(Icons.stop,
                                color: Colors.white, size: 30.0),
                          )),
                      Padding(padding: EdgeInsets.only(bottom: 12.0)),
                      Text(DemoLocalizations.of(context).trans('action_stop'),
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 23.0)),
                    ]),
              ),
              onTap: () {
                postStop();
              },
            ),
            _buildTile(
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Material(
                          color: Colors.blue,
                          shape: CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(Icons.refresh,
                                color: Colors.white, size: 30.0),
                          )),
                      Padding(padding: EdgeInsets.only(bottom: 12.0)),
                      Text(
                          DemoLocalizations.of(context).trans('action_restart'),
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 23.0)),
                    ]),
              ),
              onTap: () {
                postRestart();
              },
            ),
            _buildTile(
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Material(
                          color: Colors.red,
                          shape: CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(Icons.offline_bolt,
                                color: Colors.white, size: 30.0),
                          )),
                      Padding(padding: EdgeInsets.only(bottom: 12.0)),
                      Text(DemoLocalizations.of(context).trans('action_kill'),
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 23.0)),
                    ]),
              ),
              onTap: () {
                postKill();
              },
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
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(Icons.show_chart,
                                color: Colors.white, size: 30.0),
                          )),
                      Padding(padding: EdgeInsets.only(bottom: 12.0)),
                      Text(DemoLocalizations.of(context).trans('action_stats'),
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 23.0)),
                    ]),
              ),
              onTap: () {
                var route = new MaterialPageRoute(
                  builder: (BuildContext context) =>
                      new StatePage(server: Stats(id: widget.server.id)),
                );
                Navigator.of(context).push(route);
              },
            ),
            _buildTile(
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Material(
                          color: Colors.green,
                          shape: CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(Icons.folder_open,
                                color: Colors.white, size: 30.0),
                          )),
                      Padding(padding: EdgeInsets.only(bottom: 12.0)),
                      Text(DemoLocalizations.of(context).trans('action_file'),
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 23.0)),
                    ]),
              ),
              onTap: () {
                _filelist();
              },
            ),
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
                          Text(DemoLocalizations.of(context).trans('console'),
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 20.0))
                        ],
                      ),
                      Material(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(24.0),
                          child: Center(
                              child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Icon(Icons.code,
                                color: Colors.white, size: 30.0),
                          )))
                    ]),
              ),
              onTap: () {
                var route = new MaterialPageRoute(
                  builder: (BuildContext context) => new SendPage(
                      server:
                          Server(id: widget.server.id, name: widget.server.name)),
                );
                Navigator.of(context).push(route);
              },
            ),
          ],
          staggeredTiles: [
            StaggeredTile.extent(1, 161.0),
            StaggeredTile.extent(1, 161.0),
            StaggeredTile.extent(1, 161.0),
            StaggeredTile.extent(1, 161.0),
            StaggeredTile.extent(1, 161.0),
            StaggeredTile.extent(1, 161.0),
            StaggeredTile.extent(2, 110.0),
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

  _filelist() {
    showDialog(
        context: context,
        barrierDismissible: false,
        child: new CupertinoAlertDialog(
          content: new Text(
            DemoLocalizations.of(context).trans('added_soon'),
            style: new TextStyle(fontSize: 16.0),
          ),
          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: new Text(DemoLocalizations.of(context).trans('yes'),
                  style: TextStyle(color: Colors.black)),
            )
          ],
        ));
  }
}
