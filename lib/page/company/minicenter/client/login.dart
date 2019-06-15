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
import 'package:http/http.dart' as http;
import 'dart:async';
import '../../../../globals.dart' as globals;
import 'package:flutter/cupertino.dart';
import '../../../auth/shared_preferences_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../main.dart';
import '../../../auth/selecthost.dart';
import '../../../../globals.dart' as globals;

class User {
  final String api, url;
  const User({
    this.api,
    this.url,
  });
}

class LoginMiniCenterPage extends StatefulWidget {
  @override
  _LoginMiniCenterPageState createState() => new _LoginMiniCenterPageState();
}

bool checkValue = false;

class _LoginMiniCenterPageState extends State<LoginMiniCenterPage> {
  final _apiController = TextEditingController();

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
          onPressed: ()  {
            Navigator.of(context).pushNamedAndRemoveUntil(
                    '/selecthost', (Route<dynamic> route) => false);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('MiniCenter Client Login',
            style: TextStyle(
                color: globals.useDarkTheme ? null : Colors.black,
                fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 80.0),
            Column(
              children: <Widget>[
                Image.network(
                    globals.useDarkTheme
                        ? 'https://deploys.io/img/deploys.io/logo/text/light.png'
                        : 'https://deploys.io/img/deploys.io/logo/text/dark.png',
                    width: 100),
                SizedBox(height: 8.0),
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
                        "api_minicenter_Key", _apiController.text);
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

  _onChanged(bool value) async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      checkValue = value;
      sharedPreferences.setBool("check", checkValue);
      sharedPreferences.setString("api_minicenter_Key", _apiController.text);
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
          _apiController.text = sharedPreferences.getString("api_minicenter_Key");
        } else {
          _apiController.clear();
          sharedPreferences.clear();
        }
      } else {
        checkValue = false;
      }
    });
  }

  Future<bool> _navigator() async {
    if (_apiController.text.length != 0) {
      if (_apiController.text.isEmpty) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/selecthost', (Route<dynamic> route) => false);
        return false;
      }

      http.Response response = await http.get(
        "https://--------/api/client",
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
            '/home_minicenter', (Route<dynamic> route) => false);
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
