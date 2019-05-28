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
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/cupertino.dart';
import '../auth/shared_preferences_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import '../../globals.dart' as globals;

class User {
  final String api, url;
  const User({
    this.api,
    this.url,
  });
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

String dropdownValue = 'https://';

bool checkValue = false;

class _LoginPageState extends State<LoginPage> {
  final _apiController = TextEditingController();
  final _urlController = TextEditingController();

  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    getCredential();
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
            //Navigator.of(context).pushNamedAndRemoveUntil(
            //'/selecthost', (Route<dynamic> route) => false);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 40.0),
            Column(
              children: <Widget>[
                Image.asset('assets/images/pterodactyl_icon.png', width: 100),
                SizedBox(height: 8.0),
                Text(
                  'CLIENT LOGIN',
                  style: Theme.of(context).textTheme.headline,
                ),
              ],
            ),
            SizedBox(height: 50.0),
            AccentColorOverride(
              color: Color(0xFF442B2D),
              child: TextField(
                controller: _apiController,
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
                          controller: _urlController,
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
                    _apiController.clear();
                    _urlController.clear();
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
                        "apiKey", _apiController.text);
                    await SharedPreferencesHelper.setString(
                        "panelUrl", _urlController.text);
                    await SharedPreferencesHelper.setString(
                        "https", dropdownValue);
                    _navigator();
                  },
                ),
              ],
            ),
            SizedBox(height: 50.0),
            new FlatButton(
              child: new Text(
                  DemoLocalizations.of(context).trans('login_admin_account')),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/adminlogin', (Route<dynamic> route) => false);
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
      sharedPreferences.setString("apiKey", _apiController.text);
      sharedPreferences.setString("panelUrl", _urlController.text);
      sharedPreferences.setString("https", dropdownValue);
      sharedPreferences.commit();
      getCredential();
    });
  }

  getCredential() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      checkValue = sharedPreferences.getBool("check");
      if (checkValue != null) {
        if (checkValue) {
          _apiController.text = sharedPreferences.getString("apiKey");
          _urlController.text = sharedPreferences.getString("panelUrl");
          dropdownValue = sharedPreferences.getString("https");
        } else {
          _apiController.clear();
          _urlController.clear();
          sharedPreferences.clear();
        }
      } else {
        checkValue = false;
      }
    });
  }

  Future<bool> _navigator() async {
    if (_apiController.text.length != 0 || _urlController.text.length != 0) {
      if (_urlController.text.isEmpty) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
        return false;
      }

      http.Response response = await http.get(
        "$dropdownValue${_urlController.text}/api/client",
        headers: {
          "Accept": "Application/vnd.pterodactyl.v1+json",
          "Authorization": "Bearer ${_apiController.text}"
        },
      );
      print(response.statusCode);

      if (response.statusCode == 400) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            String title = "400";
            String message =
                DemoLocalizations.of(context).trans('login_error_400');
            String btnLabel =
                DemoLocalizations.of(context).trans('login_error_ok');
            return Platform.isIOS
                ? new CupertinoAlertDialog(
                    title: Text(title),
                    content: Text(message),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(btnLabel),
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
                        child: Text(btnLabel),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
          },
        );
      }
      if (response.statusCode == 401) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            String title = "401";
            String message =
                DemoLocalizations.of(context).trans('login_error_401');
            String btnLabel =
                DemoLocalizations.of(context).trans('login_error_ok');
            return Platform.isIOS
                ? new CupertinoAlertDialog(
                    title: Text(title),
                    content: Text(message),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(btnLabel),
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
                        child: Text(btnLabel),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
          },
        );
      }
      if (response.statusCode == 403) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            String title = "403";
            String message =
                DemoLocalizations.of(context).trans('login_error_403');
            String btnLabel =
                DemoLocalizations.of(context).trans('login_error_ok');
            return Platform.isIOS
                ? new CupertinoAlertDialog(
                    title: Text(title),
                    content: Text(message),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(btnLabel),
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
                        child: Text(btnLabel),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
          },
        );
      }
      if (response.statusCode == 404) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            String title = "404";
            String message =
                DemoLocalizations.of(context).trans('login_error_404');
            String btnLabel =
                DemoLocalizations.of(context).trans('login_error_ok');
            return Platform.isIOS
                ? new CupertinoAlertDialog(
                    title: Text(title),
                    content: Text(message),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(btnLabel),
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
                        child: Text(btnLabel),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
          },
        );
      }
      if (response.statusCode == 200) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
      } else {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            String title = "Need Support";
            String message =
                DemoLocalizations.of(context).trans('login_error_support');
            String btnLabel =
                DemoLocalizations.of(context).trans('login_error_ok');
            return Platform.isIOS
                ? new CupertinoAlertDialog(
                    title: Text(title),
                    content: Text(message),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(btnLabel),
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
                        child: Text(btnLabel),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          String title = "Login Error";
          String message = DemoLocalizations.of(context).trans('login_error');
          String btnLabel =
              DemoLocalizations.of(context).trans('login_error_ok');
          return Platform.isIOS
              ? new CupertinoAlertDialog(
                  title: Text(title),
                  content: Text(message),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(btnLabel),
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
                      child: Text(btnLabel),
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
