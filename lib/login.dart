import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './shared_preferences_helper.dart';
import 'package:pterodactyl_app/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

class User {
  final String api, url;
  const User({
    this.api,
    this.url,
  });
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _apiController = TextEditingController();
  final _urlController = TextEditingController();

  bool checkValue = false;

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
                  'PTERODACTYL APP',
                  style: Theme.of(context).textTheme.headline,
                ),
              ],
            ),
            SizedBox(height: 80.0),
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
            AccentColorOverride(
              color: Color(0xFFC5032B),
              child: TextField(
                controller: _urlController,
                decoration: InputDecoration(
                  labelText: DemoLocalizations.of(context).trans('url_login'),
                ),
              ),
            ),
            new CheckboxListTile(
            value: checkValue,
            onChanged: _onChanged,
            title: new Text("Remember me"),
            controlAffinity: ListTileControlAffinity.leading,
          ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text(
                    DemoLocalizations.of(context).trans('clear_login'),
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
                    DemoLocalizations.of(context).trans('next_login'),
                  ),
                  elevation: 8.0,
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  ),
                  onPressed: () async {
                    await SharedPreferencesHelper.setApiUrlString(
                        "apiKey", _apiController.text);
                    await SharedPreferencesHelper.setApiUrlString(
                        "panelUrl", _urlController.text);
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
      sharedPreferences.setString("apiKey", _apiController.text);
      sharedPreferences.setString("panelUrl", _urlController.text);
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

  _navigator() {
    if (_apiController.text.length != 0 || _urlController.text.length != 0) {
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(
              builder: (BuildContext context) => new MyHomePage()),
          (Route<dynamic> route) => false);
    } else {
      showDialog(
          context: context,
          barrierDismissible: false,
          child: new CupertinoAlertDialog(
            content: new Text(
              "username or password \ncan't be empty",
              style: new TextStyle(fontSize: 16.0),
            ),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: new Text("OK"))
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
