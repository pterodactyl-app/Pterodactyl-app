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
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/cupertino.dart';
import '../auth/shared_preferences_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';

class Admin {
  final String adminapi, adminurl;
  const Admin({
    this.adminapi,
    this.adminurl,
  });
}

class AdminLoginPage extends StatefulWidget {
  @override
  _AdminLoginPageState createState() => new _AdminLoginPageState();
}

String dropdownValue = 'https://';

bool checkValue = false;

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _apiadminController = TextEditingController();
  final _urladminController = TextEditingController();

  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    getCredential();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 80.0),
            Column(
              children: <Widget>[
                Image.asset('assets/images/pterodactyl_icon.png', width: 100),
                SizedBox(height: 8.0),
                Text(
                  DemoLocalizations.of(context).trans('admin_login'),
                  style: Theme.of(context).textTheme.headline,
                ),
              ],
            ),
            SizedBox(height: 50.0),
            AccentColorOverride(
              color: Color(0xFF442B2D),
              child: TextField(
                controller: _apiadminController,
                decoration: InputDecoration(
                  labelText:
                      DemoLocalizations.of(context).trans('api_key_login'),
                ),
              ),
            ),
            SizedBox(height: 12.0),
            SizedBox(
              height: 60.0,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  DropdownButton<String>(
                    value: dropdownValue,
                    isDense: true,
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                    },
                    items: <String>['https://', 'http://']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle(fontSize: 18.0)),
                      );
                    }).toList(),
                  ),
                  AccentColorOverride(
                      color: Color(0xFFC5032B),
                      child: new Flexible(
                        child: TextField(
                          controller: _urladminController,
                          decoration: InputDecoration(
                            labelText: DemoLocalizations.of(context)
                                .trans('url_login'),
                          ),
                        ),
                      )),
                ],
              ),
            ),
            new CheckboxListTile(
              value: checkValue,
              onChanged: _onChanged,
              title:
                  new Text(DemoLocalizations.of(context).trans('remember_me')),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text(
                    DemoLocalizations.of(context).trans('clear'),
                  ),
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  ),
                  onPressed: () {
                    _apiadminController.clear();
                    _urladminController.clear();
                  },
                ),
                RaisedButton(
                  child: Text(
                    DemoLocalizations.of(context).trans('next'),
                  ),
                  elevation: 8.0,
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  ),
                  onPressed: () async {
                    await SharedPreferencesHelper.setString(
                        "apiAdminKey", _apiadminController.text);
                    await SharedPreferencesHelper.setString(
                        "panelAdminUrl", _urladminController.text);
                    await SharedPreferencesHelper.setString(
                        "adminhttps", dropdownValue);
                    _navigator();
                  },
                ),
              ],
            ),
            SizedBox(height: 50.0),
            new FlatButton(
              child: new Text(
                  DemoLocalizations.of(context).trans('admin_noadminaccount')),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login', (Route<dynamic> route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }

  _onChanged(bool value) async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      checkValue = value;
      sharedPreferences.setBool("check", checkValue);
      sharedPreferences.setString("adminhttps", dropdownValue);
      sharedPreferences.setString("apiAdminKey", _apiadminController.text);
      sharedPreferences.setString("panelAdminUrl", _urladminController.text);
      getCredential();
    });
  }

  getCredential() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      checkValue = sharedPreferences.getBool("check");
      if (checkValue != null) {
        if (checkValue) {
          _apiadminController.text = sharedPreferences.getString("apiAdminKey");
          _urladminController.text =
              sharedPreferences.getString("panelAdminUrl");
          dropdownValue = sharedPreferences.getString("adminhttps");
        } else {
          _apiadminController.clear();
          _urladminController.clear();
          sharedPreferences.clear();
        }
      } else {
        checkValue = false;
      }
    });
  }

  Future<void> _navigator() async {
    if (_apiadminController.text.length != 0 ||
        _urladminController.text.length != 0) {
      if (_urladminController.text.isEmpty) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/adminlogin', (Route<dynamic> route) => false);
        return;
      }

      http.Response response = await http.get(
        "$dropdownValue${_urladminController.text}/api/application/servers",
        headers: {
          "Accept": "Application/vnd.pterodactyl.v1+json",
          "Authorization": "Bearer ${_apiadminController.text}"
        },
      );
      print(response.statusCode);

      if (response.statusCode == 400) {
        showDialog(
            context: context,
            barrierDismissible: false,
            child: new CupertinoAlertDialog(
              content: new Text(
                DemoLocalizations.of(context).trans('login_error_400'),
                style: new TextStyle(fontSize: 16.0),
              ),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: new Text(
                      DemoLocalizations.of(context).trans('login_error_ok'),
                      style: TextStyle(color: Colors.black)),
                )
              ],
            ));
      }
      if (response.statusCode == 401) {
        showDialog(
            context: context,
            barrierDismissible: false,
            child: new CupertinoAlertDialog(
              content: new Text(
                DemoLocalizations.of(context).trans('login_error_401'),
                style: new TextStyle(fontSize: 16.0),
              ),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: new Text(
                      DemoLocalizations.of(context).trans('login_error_ok'),
                      style: TextStyle(color: Colors.black)),
                )
              ],
            ));
      }
      if (response.statusCode == 403) {
        showDialog(
            context: context,
            barrierDismissible: false,
            child: new CupertinoAlertDialog(
              content: new Text(
                DemoLocalizations.of(context).trans('login_error_403'),
                style: new TextStyle(fontSize: 16.0),
              ),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: new Text(
                      DemoLocalizations.of(context).trans('login_error_ok'),
                      style: TextStyle(color: Colors.black)),
                )
              ],
            ));
      }
      if (response.statusCode == 404) {
        showDialog(
            context: context,
            barrierDismissible: false,
            child: new CupertinoAlertDialog(
              content: new Text(
                DemoLocalizations.of(context).trans('login_error_404'),
                style: new TextStyle(fontSize: 16.0),
              ),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: new Text(
                      DemoLocalizations.of(context).trans('login_error_ok'),
                      style: TextStyle(color: Colors.black)),
                )
              ],
            ));
      }
      if (response.statusCode == 200) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/adminhome', (Route<dynamic> route) => false);
      } else {
        showDialog(
            context: context,
            barrierDismissible: false,
            child: new CupertinoAlertDialog(
              content: new Text(
                DemoLocalizations.of(context).trans('login_error_support'),
                style: new TextStyle(fontSize: 16.0),
              ),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: new Text(
                      DemoLocalizations.of(context).trans('login_error_ok'),
                      style: TextStyle(color: Colors.black)),
                )
              ],
            ));
      }
    } else {
      showDialog(
          context: context,
          barrierDismissible: false,
          child: new CupertinoAlertDialog(
            content: new Text(
              DemoLocalizations.of(context).trans('login_error'),
              style: new TextStyle(fontSize: 16.0),
            ),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: new Text(
                    DemoLocalizations.of(context).trans('login_error_ok'),
                    style: TextStyle(color: Colors.black)),
              )
            ],
          ));
    }
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
