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
import 'dart:io';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:pterodactyl_app/globals.dart' as globals;
import 'package:pterodactyl_app/page/auth/shared_preferences_helper.dart';
import 'dart:async';
import 'dart:convert';
import 'package:pterodactyl_app/main.dart';
import 'console.dart';
import 'servers.dart';
import 'utilization.dart';

class Send {
  final String id, name;
  const Send({
    this.id,
    this.name,
  });
}

class Stats {
  final String id;
  const Stats({
    this.id,
  });
}

class ActionServerPage extends StatefulWidget {
  ActionServerPage({Key key, this.server}) : super(key: key);
  final User server;

  @override
  _ActionServerPageState createState() => _ActionServerPageState();
}

class _ActionServerPageState extends State<ActionServerPage> {
  Map data;
  bool dialVisible = true;

  BuildContext context;

  Future postStart() async {
    String _api = await SharedPreferencesHelper.getString("apiKey");
    String _url = await SharedPreferencesHelper.getString("panelUrl");
    String _https = await SharedPreferencesHelper.getString("https");
    var url = '$_https$_url/api/client/servers/${widget.server.id}/power';

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
    String _api = await SharedPreferencesHelper.getString("apiKey");
    String _url = await SharedPreferencesHelper.getString("panelUrl");
    String _https = await SharedPreferencesHelper.getString("https");
    var url = '$_https$_url/api/client/servers/${widget.server.id}/power';

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
    String _api = await SharedPreferencesHelper.getString("apiKey");
    String _url = await SharedPreferencesHelper.getString("panelUrl");
    String _https = await SharedPreferencesHelper.getString("https");
    var url = '$_https$_url/api/client/servers/${widget.server.id}/power';

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
    String _api = await SharedPreferencesHelper.getString("apiKey");
    String _url = await SharedPreferencesHelper.getString("panelUrl");
    String _https = await SharedPreferencesHelper.getString("https");
    var url = '$_https$_url/api/client/servers/${widget.server.id}/power';

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

  void setDialVisible(bool value) {
    setState(() {
      dialVisible = value;
    });
  }

  SpeedDial buildSpeedDial() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      visible: dialVisible,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          child: Icon((FontAwesomeIcons.play), color: Colors.white),
          backgroundColor: Colors.green,
          onTap: () {
            postStart();
          },
          label: DemoLocalizations.of(context).trans('action_start'),
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.greenAccent,
        ),
        SpeedDialChild(
          child: Icon((FontAwesomeIcons.stop), color: Colors.white),
          backgroundColor: Colors.deepOrange,
          onTap: () {
            _stop();
          },
          label: DemoLocalizations.of(context).trans('action_stop'),
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.deepOrangeAccent,
        ),
        SpeedDialChild(
          child: Icon((FontAwesomeIcons.redo), color: Colors.white),
          backgroundColor: Colors.blue,
          onTap: () {
            _restart();
          },
          label: DemoLocalizations.of(context).trans('action_restart'),
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.blueAccent,
        ),
        SpeedDialChild(
          child: Icon((FontAwesomeIcons.skull), color: Colors.white),
          backgroundColor: Colors.deepOrange,
          onTap: () {
            _kill();
          },
          label: DemoLocalizations.of(context).trans('action_kill'),
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.deepOrangeAccent,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
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
                        child:
                            Icon(Icons.code, color: Colors.white, size: 30.0),
                      )))
                ]),
          ),
          onTap: () {
            var route = new MaterialPageRoute(
              builder: (BuildContext context) => new SendPage(
                  server: Send(id: widget.server.id, name: widget.server.name)),
            );
            Navigator.of(context).push(route);
          },
        ),
      ],
      staggeredTiles: [
        StaggeredTile.extent(1, 161.0),
        StaggeredTile.extent(1, 161.0),
        StaggeredTile.extent(2, 110.0),
      ],
    ),
        floatingActionButton: buildSpeedDial(),
        bottomNavigationBar: TitledBottomNavigationBar(
            initialIndex: 0,
            currentIndex: 0, // Use this to update the Bar giving a position
            onTap: _navigate,
            items: [
              TitledNavigationBarItem(
                  title:
                      DemoLocalizations.of(context).trans('utilization_stats'),
                  icon: FontAwesomeIcons.chartBar),
              TitledNavigationBarItem(
                  title: DemoLocalizations.of(context).trans('console'),
                  icon: FontAwesomeIcons.terminal),
            ]));
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

  Future _navigate(int index) async {
    if(index == 1) {
      Navigator.of(this.context).pushAndRemoveUntil(
          new MaterialPageRoute(builder: (BuildContext context) =>
          new SendPage(
              server: Send(id: widget.server.id, name: widget.server.name))
          ), (Route<dynamic> route) => false);
    }
  }

  _restart() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = DemoLocalizations.of(context).trans('action_restart');
        String message = "Are you sure you want to restart your server?";
        String btnLabelNo = DemoLocalizations.of(context).trans('no');
        String btnLabelYes = DemoLocalizations.of(context).trans('yes');
        return Platform.isIOS
            ? new CupertinoAlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  FlatButton(
                    child: Text(btnLabelNo),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    child: Text(btnLabelYes),
                    onPressed: () {
                      postRestart();
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
            : new AlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  FlatButton(
                    child: Text(btnLabelNo),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    child: Text(btnLabelYes),
                    onPressed: () {
                      postRestart();
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
      },
    );
  }

  _stop() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = DemoLocalizations.of(context).trans('action_stop');
        String message = "are you sure you want to stop this server.";
        String btnLabelNo = DemoLocalizations.of(context).trans('no');
        String btnLabelYes = DemoLocalizations.of(context).trans('yes');
        return Platform.isIOS
            ? new CupertinoAlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  FlatButton(
                    child: Text(btnLabelNo),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    child: Text(btnLabelYes),
                    onPressed: () {
                      postStop();
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
            : new AlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  FlatButton(
                    child: Text(btnLabelNo),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    child: Text(btnLabelYes),
                    onPressed: () {
                      postStop();
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
      },
    );
  }

  _kill() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = DemoLocalizations.of(context).trans('action_kill');
        String message =
            "Are you sure you want to kill your server, nothing will be saved.";
        String btnLabelNo = DemoLocalizations.of(context).trans('no');
        String btnLabelYes = DemoLocalizations.of(context).trans('yes');
        return Platform.isIOS
            ? new CupertinoAlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  FlatButton(
                    child: Text(btnLabelNo),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    child: Text(btnLabelYes),
                    onPressed: () {
                      postKill();
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
            : new AlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  FlatButton(
                    child: Text(btnLabelNo),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    child: Text(btnLabelYes),
                    onPressed: () {
                      postKill();
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
      },
    );
  }

  _filelist() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = DemoLocalizations.of(context).trans('action_file');
        String message = DemoLocalizations.of(context).trans('added_soon');
        String btnLabelYes = DemoLocalizations.of(context).trans('yes');
        return Platform.isIOS
            ? new CupertinoAlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  FlatButton(
                    child: Text(btnLabelYes),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
            : new AlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  FlatButton(
                    child: Text(btnLabelYes),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
      },
    );
  }
}
