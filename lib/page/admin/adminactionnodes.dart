import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import '../auth/shared_preferences_helper.dart';
import 'package:http/http.dart' as http;
import '../../globals.dart' as globals;
import 'dart:async';
import 'dart:convert';
import 'adminnodes.dart';
import 'adminallocations.dart';
import 'admincreateallocation.dart';
import '../../main.dart';

class Allocation {
  final String adminids, adminname, adminnodeip;
  const Allocation({
    this.adminids,
    this.adminname,
    this.adminnodeip,
  });
}

class Admin {
  final String adminid, adminname;
  const Admin({
    this.adminid,
    this.adminname,
  });
}

class AdminActionNodesPage extends StatefulWidget {
  AdminActionNodesPage({Key key, this.server}) : super(key: key);
  final Nodes server;

  @override
  _AdminActionNodesPageState createState() => _AdminActionNodesPageState();
}

class _AdminActionNodesPageState extends State<AdminActionNodesPage> {
  Map data;
  int totalAllocations = 0;

  Future getAllocations() async {
    String _apiadmin = await SharedPreferencesHelper.getString("apiAdminKey");
    String _urladmin = await SharedPreferencesHelper.getString("panelAdminUrl");
    String _adminhttps = await SharedPreferencesHelper.getString("adminhttps");
    http.Response response = await http.get(
      "$_adminhttps$_urladmin/api/application/nodes/${widget.server.adminids}/allocations",
      headers: {
        "Accept": "Application/vnd.pterodactyl.v1+json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $_apiadmin"
      },
    );
    data = json.decode(response.body);
    setState(() {
      totalAllocations = data["meta"]["pagination"]["total"];
    });
  }

  @override
  void initState() {
    super.initState();
    getAllocations();
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
          title: Text('${widget.server.adminname}',
              style: TextStyle(
                  color: globals.isDarkTheme ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w700)),
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
                          Text(
                              DemoLocalizations.of(context)
                                  .trans('admin_nodestotalallocations'),
                              style: TextStyle(color: Colors.redAccent)),
                          Text('$totalAllocations',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 34.0))
                        ],
                      ),
                      Material(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(24.0),
                          child: Center(
                              child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Icon(Icons.public,
                                color: Colors.white, size: 30.0),
                          )))
                    ]),
              ),
              onTap: () {
                var route = new MaterialPageRoute(
                  builder: (BuildContext context) => new AdminAllocationsPage(
                      server: Admin(
                          adminid: widget.server.adminids,
                          adminname: widget.server.adminname)),
                );
                Navigator.of(context).push(route);
              },
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
                          Text(
                              DemoLocalizations.of(context)
                                  .trans('admin_actionnodes_create_allocation'),
                              style: TextStyle(
                                  color: globals.isDarkTheme
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18.0))
                        ],
                      ),
                      Material(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(24.0),
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(Icons.public,
                                color: Colors.white, size: 30.0),
                          )))
                    ]),
              ),
              onTap: () {
                var route = new MaterialPageRoute(
                  builder: (BuildContext context) =>
                      new AdminCreateAllocationPage(
                          server: Allocation(
                        adminids: widget.server.adminids,
                        adminname: widget.server.adminname,
                        adminnodeip: widget.server.adminnodeip,
                      )),
                );
                Navigator.of(context).push(route);
              },
            ),
          ],
          staggeredTiles: [
            StaggeredTile.extent(2, 110.0),
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
