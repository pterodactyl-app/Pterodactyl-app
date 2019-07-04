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
import 'admincreateservernest.dart';

class Create {
  final String userid, servername;
  const Create({this.userid, this.servername});
}

class AdminCreateServerPage extends StatefulWidget {
  @override
  _AdminCreateServerPageState createState() =>
      new _AdminCreateServerPageState();
}

class _AdminCreateServerPageState extends State<AdminCreateServerPage> {
  Map data;
  int userID;

  final _servernameController = TextEditingController();
  final _emailController = TextEditingController();

  Future getData() async {
    String _apiadmin = await SharedPreferencesHelper.getString("apiAdminKey");
    String _urladmin = await SharedPreferencesHelper.getString("panelAdminUrl");
    String _adminhttps = await SharedPreferencesHelper.getString("adminhttps");
    http.Response response = await http.get(
      "$_adminhttps$_urladmin/api/application/users?search=${_emailController.text}",
      headers: {
        "Accept": "Application/vnd.pterodactyl.v1+json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $_apiadmin"
      },
    );
    data = json.decode(response.body);
    setState(() {
      userID = data["data"]["attributes"]["id"];
    });
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
            SharedPreferencesHelper.remove("username");
            SharedPreferencesHelper.remove("email");
            SharedPreferencesHelper.remove("first_name");
            SharedPreferencesHelper.remove("last_name");
            SharedPreferencesHelper.remove("password");
          },
          icon: Icon(Icons.arrow_back,
              color: globals.useDarkTheme ? Colors.white : Colors.black),
        ),
        title: Text(DemoLocalizations.of(context).trans('admin_create_server_1_8'),
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
                controller: _servernameController,
                decoration: InputDecoration(
                  labelText: DemoLocalizations.of(context).trans('admin_create_server_server_name'),
                ),
              ),
            ),
            SizedBox(height: 12.0),
            AccentColorOverride(
              color: Colors.red,
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: DemoLocalizations.of(context).trans('admin_create_server_email'),
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
                    _servernameController.clear();
                    _emailController.clear();
                  },
                ),
                RaisedButton(
                  child: Text(DemoLocalizations.of(context).trans('next')),
                  elevation: 8.0,
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  ),
                  onPressed: () async {
                    getData();
                    var route = new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new AdminCreateServerNestPage(
                                server: Create(
                                    userid: "$userID",
                                    servername: _servernameController.text)));
                    Navigator.of(context).push(route);
                    print(userID);
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
