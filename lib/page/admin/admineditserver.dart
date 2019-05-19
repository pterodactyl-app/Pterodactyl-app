import 'package:flutter/material.dart';
import '../auth/shared_preferences_helper.dart';
import 'package:http/http.dart' as http;
import '../../globals.dart' as globals;
import 'dart:async';
import 'dart:convert';
import '../../main.dart';
import 'adminactionserver.dart';

class AdminEditServerPage extends StatefulWidget {
  AdminEditServerPage({Key key, this.server}) : super(key: key);
  final EditServer server;

  @override
  _AdminEditServerPageState createState() =>
      _AdminEditServerPageState();
}

class _AdminEditServerPageState extends State<AdminEditServerPage> {
  final _aliasController = TextEditingController();
  final _portsController = TextEditingController();

  Future postSend() async {
    String _alias = await SharedPreferencesHelper.getString("alias");
    String _ports = await SharedPreferencesHelper.getString("ports");
    String _apiadmin = await SharedPreferencesHelper.getString("apiAdminKey");
    String _urladmin = await SharedPreferencesHelper.getString("panelAdminUrl");
    String _adminhttps = await SharedPreferencesHelper.getString("adminhttps");
    var url = '$_adminhttps$_urladmin/api/application/servers/${widget.server.adminid}/details';

    Map data = {
      "name": "",
      "description": "",
      "memory": "",
      "disk": "",
      "cpu": "",
      "STARTUP": "",
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
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: globals.isDarkTheme ? null : Colors.transparent,
        leading: IconButton(
          color: globals.isDarkTheme ? Colors.white : Colors.black,
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back,
              color: globals.isDarkTheme ? Colors.white : Colors.black),
        ),
        title: Text(
            DemoLocalizations.of(context)
                .trans('admin_allocationscreate_assign'),
            style: TextStyle(
                color: globals.isDarkTheme ? Colors.white : Colors.black,
                fontWeight: FontWeight.w700)),
        // actions: <Widget>
        // [
        //   Container
        //   (
        //     margin: EdgeInsets.only(right: 8.0),
        //     child: Row
        //     (
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       children: <Widget>
        //       [
        //         Text('beclothed.com', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14.0)),
        //         Icon(Icons.arrow_drop_down, color: Colors.black54)
        //       ],
        //     ),
        //   )
        // ],
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 80.0),
            AccentColorOverride(
              color: Color(0xFFC5032B),
              child: TextField(
                controller: _aliasController,
                decoration: InputDecoration(
                  labelText: DemoLocalizations.of(context)
                      .trans('admin_allocationscreate_ip'),
                ),
              ),
            ),
            SizedBox(height: 12.0),
            AccentColorOverride(
              color: Color(0xFFC5032B),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _portsController,
                decoration: InputDecoration(
                  labelText: DemoLocalizations.of(context)
                      .trans('admin_allocationscreate_port'),
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
                    _aliasController.clear();
                    _portsController.clear();
                  },
                ),
                RaisedButton(
                  child: Text('Submit'),
                  elevation: 8.0,
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  ),
                  onPressed: () async {
                    await SharedPreferencesHelper.setString(
                        "ports", _portsController.text);
                    await SharedPreferencesHelper.setString(
                        "alias", _aliasController.text);
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
