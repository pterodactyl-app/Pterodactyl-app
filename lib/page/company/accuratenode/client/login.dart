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
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:pterodactyl_app/page/auth/shared_preferences_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pterodactyl_app/main.dart';
import 'package:pterodactyl_app/models/globals.dart' as globals;

class LoginAccurateNodePage extends StatefulWidget {
  @override
  _LoginAccurateNodePageState createState() => new _LoginAccurateNodePageState();
}

bool checkValue = false;

class _LoginAccurateNodePageState extends State<LoginAccurateNodePage> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();

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
            Navigator.of(context).pushNamedAndRemoveUntil(
            '/selecthost', (Route<dynamic> route) => false);
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
                Image.network(
                  globals.useDarkTheme
                      ? 'https://accuratenode.com/assets/img/icon.png'
                      : 'https://cdn.discordapp.com/attachments/579475423977668638/590143718703759360/logo_big.png',
                  width: 100,
                ),
                SizedBox(height: 8.0),
              ],
            ),
            SizedBox(height: 20.0),
            AccentColorOverride(
              color: Color(0xFFC5032B),
              child: TextField(
                controller: _userController,
                decoration: InputDecoration(
                  labelText:
                  DemoLocalizations.of(context).trans('api_user_name'),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            AccentColorOverride(
              color: Color(0xFFC5032B),
              child: TextField(
                controller: _passController,
                decoration: InputDecoration(
                  labelText:
                      DemoLocalizations.of(context).trans('api_user_pass'),
                ),
                obscureText: true,
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
                    _userController.clear();
                    _passController.clear();
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
                    String token = await _getApiToken(_userController.text, _passController.text);
                    await SharedPreferencesHelper.setString(
                        "api_accuratenode_Key", token);
                    _navigator();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showNotAuthorizedDialog() {
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

  void showNotSupportedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = DemoLocalizations.of(context)
            .trans('login_username_api_not_supported');
        String message = DemoLocalizations.of(context)
            .trans('login_username_api_not_supported_error');
        String btnLabel = DemoLocalizations.of(context).trans('login_error_ok');
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
  void showNoKeyDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = DemoLocalizations.of(context)
            .trans('login_username_api_no_api_key');
        String message = DemoLocalizations.of(context)
            .trans('login_username_api_no_api_key_error');
        String btnLabel = DemoLocalizations.of(context).trans('login_error_ok');
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

  Future<String> _getApiToken(String username, String password) async {
    if(username.isNotEmpty && password.isNotEmpty) {
      await SharedPreferencesHelper.setString('apiUser_accuratenode', username);
      http.Response response = await http.post(
        "https://panel.accuratenode.com/api/app/user/auth/token",
        headers: {
          "Accept": "Application/vnd.pterodactyl.v1+json",
        },
        body: {
          "user": username,
          "password": password
        }
      );

      int status = response.statusCode;

      if (response.statusCode == 200) {
        dynamic data = json.decode(response.body);
        if(data['data'].isNotEmpty) {
          return data['data'][0]['token'] != null ? data['data'][0]['token'].toString() : '';
        } else {
          showNoKeyDialog();
        }
      } else if(status >= 400 && status <= 403) {
        showNotAuthorizedDialog();
      } else {
        showNotSupportedDialog();
      }
    }
    return '';
  }

  _onChanged(bool value) async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      checkValue = value;
      sharedPreferences.setBool("check", checkValue);
      sharedPreferences.setString("apiPass_accuratenode", _passController.text);
      getCredential();
    });
  }

  getCredential() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      checkValue = sharedPreferences.getBool("check");
      if (checkValue != null) {
        if (checkValue) {
          _userController.text = sharedPreferences.getString("apiUser_accuratenode");
          _passController.text = sharedPreferences.getString("apiPass_accuratenode");
        } else {
          _userController.clear();
          _passController.clear();
          sharedPreferences.clear();
        }
      } else {
        checkValue = false;
      }
    });
  }

  Future<void> _navigator() async {
    if (_userController.text.length != 0 || _passController.text.length != 0) {
      if (_passController.text.isEmpty) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('accuratenode/login', (Route<dynamic> route) => false);
        return false;
      }

      String _token = await SharedPreferencesHelper.getString('api_accuratenode_Key');

      if (_token.isEmpty) {
        return false;
      }

      http.Response response = await http.get(
        "https://panel.accuratenode.com/api/client",
        headers: {
          "Accept": "Application/vnd.pterodactyl.v1+json",
          "Authorization": "Bearer $_token"
        },
      );

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
        return false;
      }
      if (response.statusCode == 401) {
        showNotAuthorizedDialog();
        return false;
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
        return false;
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
            .pushNamedAndRemoveUntil('accuratenode/home', (Route<dynamic> route) => false);
      } else {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            String title = DemoLocalizations.of(context)
            .trans('login_username_api_not_supported');
        String message = DemoLocalizations.of(context)
            .trans('login_username_api_not_supported_error');
        String btnLabel = DemoLocalizations.of(context).trans('login_error_ok');
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
      showNotSupportedDialog();
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