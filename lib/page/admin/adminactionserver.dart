import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../../globals.dart' as globals;
import '../auth/shared_preferences_helper.dart';
import 'dart:async';
import '../../main.dart';
import 'adminservers.dart';
import 'admineditserver.dart';
import 'adminserverinfo.dart';

class EditServer {
  final String adminid, adminuser, adminname, admindescription, adminmemory, admindisk, admincpu, adminstartupcommand;
  const EditServer({
    this.adminid,
    this.adminuser,
    this.adminname,
    this.admindescription,
    this.adminmemory,
    this.admindisk,
    this.admincpu,
    this.adminstartupcommand,
  });
}
class ViewServer {
  final String adminid;
  const ViewServer({this.adminid});
}

class AdminActionServerPage extends StatefulWidget {
  AdminActionServerPage({Key key, this.server}) : super(key: key);
  final Admin server;

  @override
  _AdminActionServerPageState createState() => _AdminActionServerPageState();
}

class _AdminActionServerPageState extends State<AdminActionServerPage> {
  Map data;

  Future postRebuild() async {
    String _apiadmin = await SharedPreferencesHelper.getString("apiAdminKey");
    String _urladmin = await SharedPreferencesHelper.getString("panelAdminUrl");
    String _adminhttps = await SharedPreferencesHelper.getString("adminhttps");
    var url =
        '$_adminhttps$_urladmin/api/application/servers/${widget.server.adminid}/rebuild';

    var response = await http.post(
      url,
      headers: {
        "Accept": "Application/vnd.pterodactyl.v1+json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $_apiadmin"
      },
    );
    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }

  Future postReinstall() async {
    String _apiadmin = await SharedPreferencesHelper.getString("apiAdminKey");
    String _urladmin = await SharedPreferencesHelper.getString("panelAdminUrl");
    String _adminhttps = await SharedPreferencesHelper.getString("adminhttps");
    var url =
        '$_adminhttps$_urladmin/api/application/servers/${widget.server.adminid}/reinstall';

    var response = await http.post(
      url,
      headers: {
        "Accept": "Application/vnd.pterodactyl.v1+json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $_apiadmin"
      },
    );
    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }

  Future postSuspend() async {
    String _apiadmin = await SharedPreferencesHelper.getString("apiAdminKey");
    String _urladmin = await SharedPreferencesHelper.getString("panelAdminUrl");
    String _adminhttps = await SharedPreferencesHelper.getString("adminhttps");
    var url =
        '$_adminhttps$_urladmin/api/application/servers/${widget.server.adminid}/suspend';

    var response = await http.post(
      url,
      headers: {
        "Accept": "Application/vnd.pterodactyl.v1+json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $_apiadmin"
      },
    );
    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }

  Future postUnsuspend() async {
    String _apiadmin = await SharedPreferencesHelper.getString("apiAdminKey");
    String _urladmin = await SharedPreferencesHelper.getString("panelAdminUrl");
    String _adminhttps = await SharedPreferencesHelper.getString("adminhttps");
    var url =
        '$_adminhttps$_urladmin/api/application/servers/${widget.server.adminid}/unsuspend';

    var response = await http.post(
      url,
      headers: {
        "Accept": "Application/vnd.pterodactyl.v1+json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $_apiadmin"
      },
    );
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
            onPressed: () {
              Navigator.of(context).pop();
              SharedPreferencesHelper.remove("NodeAdminIP");
            },
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
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Material(
                          color: Colors.green,
                          shape: CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(Icons.restore_page,
                                color: Colors.white, size: 30.0),
                          )),
                      Padding(padding: EdgeInsets.only(bottom: 12.0)),
                      Text(
                          DemoLocalizations.of(context)
                              .trans('admin_actionserver_rebuild_server'),
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 18.0)),
                    ]),
              ),
              onTap: () {
                _rebuild();
              },
            ),
            _buildTile(
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Material(
                          color: Colors.red,
                          shape: CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(Icons.report_problem,
                                color: Colors.white, size: 30.0),
                          )),
                      Padding(padding: EdgeInsets.only(bottom: 12.0)),
                      Text(
                          DemoLocalizations.of(context)
                              .trans('admin_actionserver_reinstall_server'),
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 18.0)),
                    ]),
              ),
              onTap: () {
                _reinstall();
              },
            ),
            _buildTile(
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Material(
                          color: Colors.amber,
                          shape: CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(Icons.report,
                                color: Colors.white, size: 30.0),
                          )),
                      Padding(padding: EdgeInsets.only(bottom: 12.0)),
                      Text(
                          DemoLocalizations.of(context)
                              .trans('admin_actionserver_suspend_server'),
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 18.0)),
                    ]),
              ),
              onTap: () {
                _suspend();
              },
            ),
            _buildTile(
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Material(
                          color: Colors.green,
                          shape: CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(Icons.report_off,
                                color: Colors.white, size: 30.0),
                          )),
                      Padding(padding: EdgeInsets.only(bottom: 12.0)),
                      Text(
                          DemoLocalizations.of(context)
                              .trans('admin_actionserver_unsuspend_server'),
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 17.0)),
                    ]),
              ),
              onTap: () {
                _unsuspend();
              },
            ),
            _buildTile(
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Material(
                          color: Colors.blue,
                          shape: CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(Icons.pageview,
                                color: Colors.white, size: 30.0),
                          )),
                      Padding(padding: EdgeInsets.only(bottom: 12.0)),
                      Text(
                          DemoLocalizations.of(context)
                              .trans('admin_actionserver_view_server_info'),
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 18.0)),
                    ]),
              ),
              onTap: () {
                var route = new MaterialPageRoute(
                  builder: (BuildContext context) => new AdminServerInfoPage(
                      server: ViewServer(adminid: widget.server.adminid)),
                );
                Navigator.of(context).push(route);
              },
            ),
            _buildTile(
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Material(
                          color: Colors.blue,
                          shape: CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(Icons.edit,
                                color: Colors.white, size: 30.0),
                          )),
                      Padding(padding: EdgeInsets.only(bottom: 12.0)),
                      Text(
                          DemoLocalizations.of(context)
                              .trans('admin_actionserver_edit_server_info'),
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 18.0)),
                    ]),
              ),
              onTap: () {
                var route = new MaterialPageRoute(
                  builder: (BuildContext context) => new AdminEditServerPage(
                      server: EditServer(
                      adminid: widget.server.adminid,
                      adminuser: widget.server.adminuser,
                      adminname: widget.server.adminname,
                      admindescription: widget.server.admindescription,
                      admincpu: widget.server.admincpu,
                      admindisk: widget.server.admindisk,
                      adminmemory: widget.server.adminmemory,
                      adminstartupcommand: widget.server.adminstartupcommand
                      )),
                );
                Navigator.of(context).push(route);
              },
            ),
          ],
          staggeredTiles: [
            StaggeredTile.extent(1, 170.0),
            StaggeredTile.extent(1, 170.0),
            StaggeredTile.extent(1, 170.0),
            StaggeredTile.extent(1, 170.0),
            StaggeredTile.extent(1, 170.0),
            StaggeredTile.extent(1, 170.0),
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

  _rebuild() {
    showDialog(
        context: context,
        barrierDismissible: false,
        child: new CupertinoAlertDialog(
          content: new Text(
            DemoLocalizations.of(context)
                .trans('admin_alert_rebuild_server_info'),
            style: new TextStyle(fontSize: 16.0),
          ),
          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: new Text(DemoLocalizations.of(context).trans('no'),
                  style: TextStyle(color: Colors.black)),
            ),
            new FlatButton(
              onPressed: () {
                postRebuild();
                Navigator.pop(context);
              },
              child: new Text(DemoLocalizations.of(context).trans('yes'),
                  style: TextStyle(color: Colors.black)),
            )
          ],
        ));
  }

  _reinstall() {
    showDialog(
        context: context,
        barrierDismissible: false,
        child: new CupertinoAlertDialog(
          content: new Text(
            DemoLocalizations.of(context)
                .trans('admin_alert_reinstall_server_info'),
            style: new TextStyle(fontSize: 16.0),
          ),
          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: new Text(DemoLocalizations.of(context).trans('no'),
                  style: TextStyle(color: Colors.black)),
            ),
            new FlatButton(
              onPressed: () {
                postReinstall();
                Navigator.pop(context);
              },
              child: new Text(DemoLocalizations.of(context).trans('yes'),
                  style: TextStyle(color: Colors.black)),
            )
          ],
        ));
  }

  _suspend() {
    showDialog(
        context: context,
        barrierDismissible: false,
        child: new CupertinoAlertDialog(
          content: new Text(
            DemoLocalizations.of(context)
                .trans('admin_alert_suspend_server_info'),
            style: new TextStyle(fontSize: 16.0),
          ),
          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: new Text(DemoLocalizations.of(context).trans('no'),
                  style: TextStyle(color: Colors.black)),
            ),
            new FlatButton(
              onPressed: () {
                postSuspend();
                Navigator.pop(context);
              },
              child: new Text(DemoLocalizations.of(context).trans('yes'),
                  style: TextStyle(color: Colors.black)),
            )
          ],
        ));
  }

  _unsuspend() {
    showDialog(
        context: context,
        barrierDismissible: false,
        child: new CupertinoAlertDialog(
          content: new Text(
            DemoLocalizations.of(context)
                .trans('admin_alert_unsuspend_server_info'),
            style: new TextStyle(fontSize: 16.0),
          ),
          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: new Text(DemoLocalizations.of(context).trans('no'),
                  style: TextStyle(color: Colors.black)),
            ),
            new FlatButton(
              onPressed: () {
                postUnsuspend();
                Navigator.pop(context);
              },
              child: new Text(DemoLocalizations.of(context).trans('yes'),
                  style: TextStyle(color: Colors.black)),
            )
          ],
        ));
  }
}
