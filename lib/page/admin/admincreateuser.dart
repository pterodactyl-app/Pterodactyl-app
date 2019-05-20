import 'package:flutter/material.dart';
import '../auth/shared_preferences_helper.dart';
import 'package:http/http.dart' as http;
import '../../globals.dart' as globals;
import 'dart:async';
import 'dart:convert';
import '../../main.dart';

class AdminCreateUserPage extends StatefulWidget {
  AdminCreateUserPage({Key key}) : super(key: key);

  @override
  _AdminCreateUserPageState createState() => _AdminCreateUserPageState();
}

class _AdminCreateUserPageState extends State<AdminCreateUserPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future postSend() async {
    //-----create---//
    String _usermane = await SharedPreferencesHelper.getString("username");
    String _email = await SharedPreferencesHelper.getString("email");
    String _firstname = await SharedPreferencesHelper.getString("first_name");
    String _lastname = await SharedPreferencesHelper.getString("last_name");
    String _password = await SharedPreferencesHelper.getString("password");
    //-----login----//
    String _apiadmin = await SharedPreferencesHelper.getString("apiAdminKey");
    String _urladmin = await SharedPreferencesHelper.getString("panelAdminUrl");
    String _adminhttps = await SharedPreferencesHelper.getString("adminhttps");
    var url = '$_adminhttps$_urladmin/api/application/users';

    Map data = {
      "username": "$_usermane",
      "email": "$_email",
      "first_name": "$_firstname",
      "last_name": "$_lastname",
      "password": "$_password"
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
        backgroundColor: globals.isDarkTheme ? null : Colors.transparent,
        leading: IconButton(
          color: globals.isDarkTheme ? Colors.white : Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
            SharedPreferencesHelper.remove("username");
            SharedPreferencesHelper.remove("email");
            SharedPreferencesHelper.remove("first_name");
            SharedPreferencesHelper.remove("last_name");
            SharedPreferencesHelper.remove("password");
          },
          icon: Icon(Icons.arrow_back,
              color: globals.isDarkTheme ? Colors.white : Colors.black),
        ),
        title: Text(
            DemoLocalizations.of(context).trans('admin_create_user_title'),
            style: TextStyle(
                color: globals.isDarkTheme ? Colors.white : Colors.black,
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
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: ('username'),
                ),
              ),
            ),
            SizedBox(height: 12.0),
            AccentColorOverride(
              color: Colors.red,
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: ('email'),
                ),
              ),
            ),
            SizedBox(height: 12.0),
            AccentColorOverride(
              color: Colors.red,
              child: TextField(
                controller: _firstnameController,
                decoration: InputDecoration(
                  labelText: ('first name'),
                ),
              ),
            ),
            SizedBox(height: 12.0),
            AccentColorOverride(
              color: Colors.red,
              child: TextField(
                controller: _lastnameController,
                decoration: InputDecoration(
                  labelText: ('last name'),
                ),
              ),
            ),
            SizedBox(height: 12.0),
            AccentColorOverride(
              color: Colors.red,
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: ('password'),
                ),
              ),
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text('Clear'),
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  ),
                  onPressed: () {
                    _usernameController.clear();
                    _emailController.clear();
                    _firstnameController.clear();
                    _lastnameController.clear();
                    _passwordController.clear();
                    SharedPreferencesHelper.remove("username");
                    SharedPreferencesHelper.remove("email");
                    SharedPreferencesHelper.remove("first_name");
                    SharedPreferencesHelper.remove("last_name");
                    SharedPreferencesHelper.remove("password");
                  },
                ),
                RaisedButton(
                  child: Text(DemoLocalizations.of(context)
                      .trans('admin_create_user_create_a_user')),
                  elevation: 8.0,
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  ),
                  onPressed: () async {
                    await SharedPreferencesHelper.setString(
                        "username", _usernameController.text);
                    await SharedPreferencesHelper.setString(
                        "email", _emailController.text);
                    await SharedPreferencesHelper.setString(
                        "first_name", _firstnameController.text);
                    await SharedPreferencesHelper.setString(
                        "last_name", _lastnameController.text);
                    await SharedPreferencesHelper.setString(
                        "password", _passwordController.text);
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
