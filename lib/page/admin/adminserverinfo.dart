import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../auth/shared_preferences_helper.dart';
import '../../globals.dart' as globals;
import '../../main.dart';
import 'dart:async';
import 'dart:convert';
import 'adminactionserver.dart';

class AdminServerInfoPage extends StatefulWidget {
  AdminServerInfoPage({Key key, this.server}) : super(key: key);
  final ViewServer server;

  @override
  _AdminServerInfoPageState createState() => _AdminServerInfoPageState();
}

class _AdminServerInfoPageState extends State<AdminServerInfoPage> {
  Map data;
  String identifier;
  String name;
  String description;
  bool suspended;
  int memory;
  int disk;
  int cpu;
  bool installed;
  String startupCommand;

  Future getData() async {
    String _apiadmin = await SharedPreferencesHelper.getString("apiAdminKey");
    String _urladmin = await SharedPreferencesHelper.getString("panelAdminUrl");
    String _adminhttps = await SharedPreferencesHelper.getString("adminhttps");
    http.Response response = await http.get(
      "$_adminhttps$_urladmin/api/application/servers/${widget.server.adminid}",
      headers: {
        "Accept": "Application/vnd.pterodactyl.v1+json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $_apiadmin"
      },
    );
    data = json.decode(response.body);
    setState(() {
      identifier = data["attributes"]["identifier"];
      name = data["attributes"]["name"];
      description = data["attributes"]["description"];
      suspended = data["attributes"]["suspended"];
      memory = data["attributes"]["limits"]["memory"];
      disk = data["attributes"]["limits"]["disk"];
      cpu = data["attributes"]["limits"]["cpu"];
      installed = data["attributes"]["container"]["installed"];
      startupCommand = data["attributes"]["container"]["startup_command"];
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
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
            icon: Icon(
              Icons.arrow_back,
              color: globals.isDarkTheme ? Colors.white : Colors.black,
            ),
          ),
          title: Text(DemoLocalizations.of(context).trans('admin_view_server'),
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
        body: StaggeredGridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          children: <Widget>[
            _buildTile(
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(DemoLocalizations.of(context).trans('admin_view_server_identifier'),
                              style: TextStyle(color: Colors.blueAccent)),
                          Text('$identifier',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 20.0))
                        ],
                      )
                    ]),
              ),
              //onTap: () {},
            ),
            _buildTile(
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(DemoLocalizations.of(context).trans('admin_view_server_installed'),
                              style: TextStyle(color: Colors.blueAccent)),
                          Text(installed != "true" ? DemoLocalizations.of(context).trans('yes') : DemoLocalizations.of(context).trans('no'),
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 20.0))
                        ],
                      )
                    ]),
              ),
              //onTap: () {},
            ),
            _buildTile(
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(DemoLocalizations.of(context).trans('admin_view_server_name'),
                              style: TextStyle(color: Colors.blueAccent)),
                          Text('$name',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 20.0))
                        ],
                      )
                    ]),
              ),
              //onTap: () {},
            ),
            _buildTile(
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(DemoLocalizations.of(context).trans('admin_view_server_description'),
                              style: TextStyle(color: Colors.blueAccent)),
                          Text('$description',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 20.0))
                        ],
                      )
                    ]),
              ),
              //onTap: () {},
            ),
            _buildTile(
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(DemoLocalizations.of(context).trans('admin_view_server_suspended'),
                              style: TextStyle(color: Colors.blueAccent)),
                          Text("$suspended" == "true" ? DemoLocalizations.of(context).trans('yes') : DemoLocalizations.of(context).trans('no'),
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 20.0))
                        ],
                      )
                    ]),
              ),
              //onTap: () {},
            ),
            _buildTile(
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(DemoLocalizations.of(context).trans('utilization_memory'),
                              style: TextStyle(color: Colors.blueAccent)),
                          Text('${memory.toString()} MB',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 20.0))
                        ],
                      )
                    ]),
              ),
              //onTap: () {},.toString()
            ),
            _buildTile(
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(DemoLocalizations.of(context).trans('utilization_disk'),
                              style: TextStyle(color: Colors.blueAccent)),
                          Text('${disk.toString()} MB',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 20.0))
                        ],
                      )
                    ]),
              ),
              //onTap: () {},
            ),
            _buildTile(
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(DemoLocalizations.of(context).trans('utilization_cpu'),
                              style: TextStyle(color: Colors.blueAccent)),
                          Text(cpu.toString() != 0 ? "∞" : "${cpu.toString()}%",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 20.0))
                        ],
                      )
                    ]),
              ),
              //onTap: () {},
            ),
            _buildTile(
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(DemoLocalizations.of(context).trans('admin_view_server_startup_command'),
                              style: TextStyle(color: Colors.blueAccent)),
                          Text(startupCommand,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 10.5))
                        ],
                      )
                    ]),
              ),
              //onTap: () {},
            ),
          ],
          staggeredTiles: [
            StaggeredTile.extent(1, 110.0),
            StaggeredTile.extent(1, 110.0),
            StaggeredTile.extent(2, 110.0),
            StaggeredTile.extent(2, 110.0),
            StaggeredTile.extent(1, 110.0),
            StaggeredTile.extent(1, 110.0),
            StaggeredTile.extent(1, 110.0),
            StaggeredTile.extent(1, 110.0),
            StaggeredTile.extent(2, 110.0),
          ],
        ));
  }

  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: globals.isDarkTheme ? Colors.grey[700] : Color(0x802196F3),
        child: InkWell(
            // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null
                ? () => onTap()
                : () {
                    print('Not set yet');
                  },
            child: child));
  }
}
