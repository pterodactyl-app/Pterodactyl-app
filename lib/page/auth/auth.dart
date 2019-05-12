import 'dart:async';
import 'package:pterodactyl_app/page/client/login.dart';
import 'package:pterodactyl_app/page/client/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pterodactyl_app/page/admin/adminhome.dart';
import 'package:pterodactyl_app/page/admin/adminlogin.dart';

class Splash extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<Splash> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var bool2 = prefs.getBool('seen');
    bool _seen = (bool2 ?? false);

    if (_seen) {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new MyHomePage()));
    } else {
      prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new LoginPage()));
    }
  }

  Future admincheckFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seenadmin = (prefs.getBool('seenadmin') ?? false);

    if (_seenadmin) {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new AdminHomePage()));
    } else {
      prefs.setBool('seenadmin', true);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new AdminLoginPage()));
    }
  }

  @override
  void initState() {
    super.initState();
    checkFirstSeen();
    admincheckFirstSeen();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Text('Loading...'),
      ),
    );
  }
}


