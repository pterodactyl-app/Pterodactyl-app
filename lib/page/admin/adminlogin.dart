import 'package:flutter/material.dart';
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

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _apiadminController = TextEditingController();
  final _urladminController = TextEditingController();

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
                  'ADMIN LOGIN',
                  style: Theme.of(context).textTheme.headline,
                ),
              ],
            ),
            SizedBox(height: 80.0),
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
            AccentColorOverride(
              color: Color(0xFFC5032B),
              child: TextField(
                controller: _urladminController,
                decoration: InputDecoration(
                  labelText: DemoLocalizations.of(context).trans('url_login'),
                ),
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
                    _navigator();
                  },
                ),
              ],
            ),
            new FlatButton(
              child: new Text(DemoLocalizations.of(context).trans('NoAdminAccount')),
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
      sharedPreferences.setString("apiAdminKey", _apiadminController.text);
      sharedPreferences.setString("panelAdminUrl", _urladminController.text);
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
          _apiadminController.text = sharedPreferences.getString("apiAdminKey");
          _urladminController.text =
              sharedPreferences.getString("panelAdminUrl");
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

  _navigator() {
    if (_apiadminController.text.length != 0 ||
        _urladminController.text.length != 0) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/adminhome', (Route<dynamic> route) => false);
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
