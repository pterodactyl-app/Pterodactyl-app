/*
* Copyright 2018-2019 Ruben Talstra and Yvan Watchman
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
import '../../auth/shared_preferences_helper.dart';
import 'package:http/http.dart' as http;
import 'package:pterodactyl_app/models/globals.dart' as globals;
import 'dart:async';
import 'dart:convert';
import '../../../main.dart';
import 'admincreateserverallocations.dart';

class AdminCreateServerSendPage extends StatefulWidget {
  AdminCreateServerSendPage({Key key, this.server}) : super(key: key);
  final Allocations server;

  @override
  _AdminCreateServerSendPageState createState() =>
      new _AdminCreateServerSendPageState();
}

class _AdminCreateServerSendPageState extends State<AdminCreateServerSendPage> {
  Map data;

  final _databasesController = TextEditingController();

  Future postSend() async {
    //-----login----//
    String _apiadmin = await SharedPreferencesHelper.getString("apiAdminKey");
    String _urladmin = await SharedPreferencesHelper.getString("panelAdminUrl");
    String _adminhttps = await SharedPreferencesHelper.getString("adminhttps");
    var url = '$_adminhttps$_urladmin/api/application/servers';

    Map data = {
      "name": widget.server.servername,
      "user": widget.server.userid,
      "nest": widget.server.nestid,
      "egg": widget.server.eggid,
      "docker_image": widget.server.dockerimage,
      "startup": widget.server.startup,
      "limits": {
        "memory": widget.server.limitmemory,
        "swap": widget.server.limitswap,
        "disk": widget.server.disklimit,
        "io": widget.server.iolimit,
        "cpu": widget.server.cpulimit
      },
      "feature_limits": {
        "databases": _databasesController.text,
        "allocations": widget.server.allocationsid
      },
      "deploy": {
        "locations": [widget.server.locationsid],
        "dedicated_ip": false,
        "port_range": [widget.server.port]
      },
      "start_on_completion": true
    };
    //encode Map to JSON
    var body = json.encode(data);

    var response = await http.post(url,
        headers: {
          "Accept": "Application/vnd.pterodactyl.v1+json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $_apiadmin"
        },
        body: body);
    print("${response.statusCode}");
    print("${response.body}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: globals.useDarkTheme ? null : Colors.transparent,
        leading: IconButton(
          color: globals.useDarkTheme ? Colors.white : Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back,
              color: globals.useDarkTheme ? Colors.white : Colors.black),
        ),
        title: Text(DemoLocalizations.of(context).trans('admin_create_server_8_8'),
            style: TextStyle(
                color: globals.useDarkTheme ? Colors.white : Colors.black,
                fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 20.0),
            AccentColorOverride(
              color: Colors.red,
              child: TextField(
                controller: _databasesController,
                decoration: InputDecoration(
                  labelText: DemoLocalizations.of(context).trans('admin_create_server_database_limit'),
                ),
              ),
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text(DemoLocalizations.of(context).trans('clear')),
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  ),
                  onPressed: () {
                    _databasesController.clear();
                  },
                ),
                RaisedButton(
                  child: Text(DemoLocalizations.of(context).trans('admin_create_server')),
                  elevation: 8.0,
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  ),
                  onPressed: () {
                    postSend();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AccentColorOverride extends StatelessWidget {
  const AccentColorOverride({Key key, this.color, this.child})
      : super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      child: child,
      data: Theme.of(context).copyWith(
        accentColor: color,
        brightness: Brightness.dark,
      ),
    );
  }
}
