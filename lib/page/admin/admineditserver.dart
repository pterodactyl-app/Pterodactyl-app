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
  _AdminEditServerPageState createState() => _AdminEditServerPageState();
}

class _AdminEditServerPageState extends State<AdminEditServerPage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _cpuController = TextEditingController();
  final _diskController = TextEditingController();
  final _memoryController = TextEditingController();
  final _startupcommandController = TextEditingController();

  Future editServer() async {
    //use for edit server info//
    String _name = await SharedPreferencesHelper.getString("name");
    String _description = await SharedPreferencesHelper.getString("description");
    String _cpu = await SharedPreferencesHelper.getString("cpu");
    String _disk = await SharedPreferencesHelper.getString("disk");
    String _memory = await SharedPreferencesHelper.getString("memory");
    String _startupcommand = await SharedPreferencesHelper.getString("startupcommand");
    //login//
    String _apiadmin = await SharedPreferencesHelper.getString("apiAdminKey");
    String _urladmin = await SharedPreferencesHelper.getString("panelAdminUrl");
    String _adminhttps = await SharedPreferencesHelper.getString("adminhttps");
    var url =
        '$_adminhttps$_urladmin/api/application/servers/${widget.server.adminid}/details';

    Map data = {
      "name": _name,
      "description": _description,
      "memory": _memory,
      "disk": _disk,
      "cpu": _cpu,
      "STARTUP": _startupcommand,
      "user": "${widget.server.adminuser}"
    };
    //encode Map to JSON
    var body = json.encode(data);

    var response = await http.patch(url,
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
            'Edit server information',
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
              color: Color(0xFFC5032B),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: widget.server.adminname,
                ),
              ),
            ),
            SizedBox(height: 12.0),
            AccentColorOverride(
              color: Color(0xFFC5032B),
              child: TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: widget.server.admindescription
                ),
              ),
            ),
            SizedBox(height: 12.0),
            AccentColorOverride(
              color: Color(0xFFC5032B),
              child: TextField(
                controller: _memoryController,
                decoration: InputDecoration(
                  labelText: widget.server.adminmemory,
                ),
              ),
            ),
            SizedBox(height: 12.0),
            AccentColorOverride(
              color: Color(0xFFC5032B),
              child: TextField(
                controller: _diskController,
                decoration: InputDecoration(
                  labelText: widget.server.admindisk,
                ),
              ),
            ),
            SizedBox(height: 12.0),
            AccentColorOverride(
              color: Color(0xFFC5032B),
              child: TextField(
                controller: _cpuController,
                decoration: InputDecoration(
                  labelText: widget.server.admincpu
                ),
              ),
            ),
            SizedBox(height: 12.0),
            AccentColorOverride(
              color: Color(0xFFC5032B),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _startupcommandController,
                decoration: InputDecoration(
                  labelText: widget.server.adminstartupcommand,
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
                    _nameController.clear();
                    _descriptionController.clear();
                    _cpuController.clear();
                    _diskController.clear();
                    _memoryController.clear();
                    _startupcommandController.clear();
                  },
                ),
                RaisedButton(
                  child: Text('Edit Server'),
                  elevation: 8.0,
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  ),
                  onPressed: () async {
                    await SharedPreferencesHelper.setString("name", _nameController.text);
                    await SharedPreferencesHelper.setString("description", _descriptionController.text);
                    await SharedPreferencesHelper.setString("cpu", _cpuController.text);
                    await SharedPreferencesHelper.setString("disk", _diskController.text);
                    await SharedPreferencesHelper.setString("memory", _memoryController.text);
                    await SharedPreferencesHelper.setString("startupcommand", _startupcommandController.text);
                    editServer();
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
