import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../auth/shared_preferences_helper.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:http/http.dart' as http;
import '../../globals.dart' as globals;
import 'dart:async';
import 'dart:convert';
import 'adminservers.dart';
import 'adminsettings.dart';
import 'adminnodes.dart';
import 'adminusers.dart';
import '../../main.dart';

class AdminHomePage extends StatefulWidget {
  AdminHomePage({Key key}) : super(key: key);

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Map data;
  int userTotalServers = 0;
  int totalNodes = 0;
  int totalUsers = 0;

  Future getData() async {
    String _apiadmin = await SharedPreferencesHelper.getString("apiAdminKey");
    String _urladmin = await SharedPreferencesHelper.getString("panelAdminUrl");
    http.Response response = await http.get(
      "$_urladmin/api/application/servers",
      headers: {
        "Accept": "Application/vnd.pterodactyl.v1+json",
        "Authorization": "Bearer $_apiadmin"
      },
    );
    data = json.decode(response.body);
    setState(() {
      userTotalServers = data["meta"]["pagination"]["total"];
    });
  }

  Future getNodesData() async {
    String _apiadmin = await SharedPreferencesHelper.getString("apiAdminKey");
    String _urladmin = await SharedPreferencesHelper.getString("panelAdminUrl");
    http.Response response = await http.get(
      "$_urladmin/api/application/nodes",
      headers: {
        "Accept": "Application/vnd.pterodactyl.v1+json",
        "Authorization": "Bearer $_apiadmin"
      },
    );
    data = json.decode(response.body);
    setState(() {
      totalNodes = data["meta"]["pagination"]["total"];
    });
  }

  Future getUsers() async {
    String _apiadmin = await SharedPreferencesHelper.getString("apiAdminKey");
    String _urladmin = await SharedPreferencesHelper.getString("panelAdminUrl");
    http.Response response = await http.get(
      "$_urladmin/api/application/users",
      headers: {
        "Accept": "Application/vnd.pterodactyl.v1+json",
        "Authorization": "Bearer $_apiadmin"
      },
    );
    data = json.decode(response.body);
    setState(() {
      totalUsers = data["meta"]["pagination"]["total"];
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    getNodesData();
    getUsers();    
    firebaseCloudMessaging_Listeners();
}
void firebaseCloudMessaging_Listeners() {
  if (Platform.isIOS) iOS_Permission();

  _firebaseMessaging.getToken().then((token){
    print(token);
  });

  _firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      print('on message $message');
    },
    onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
    },
    onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
    },
  );
}

void iOS_Permission() {
  _firebaseMessaging.requestNotificationPermissions(
      IosNotificationSettings(sound: true, badge: true, alert: true)
  );
  _firebaseMessaging.onIosSettingsRegistered
      .listen((IosNotificationSettings settings)
  {
    print("Settings registered: $settings");
  });    
  }

  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => ThemeData(
              primarySwatch: Colors.blue,
              primaryColorBrightness:
                  globals.isDarkTheme ? Brightness.dark : Brightness.light,
              brightness: brightness,
            ),
        themedWidgetBuilder: (context, theme) {
          return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                elevation: 2.0,
                backgroundColor:
                    globals.isDarkTheme ? Colors.transparent : Colors.white,
                title: Text(DemoLocalizations.of(context).trans('Admin_HomePanel'),
                    style: TextStyle(
                        color: globals.isDarkTheme ? null : Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 30.0)),
                //actions: <Widget>[
                //Container(
                //margin: EdgeInsets.only(right: 8.0),
                //child: Row(
                //mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.center,
                //children: <Widget>[
                //Text(DemoLocalizations.of(context).trans('logout'),
                //style: TextStyle(
                //color:
                //globals.isDarkTheme ? Colors.white : Colors.blue,
                //fontWeight: FontWeight.w700,
                //fontSize: 14.0)),
                //Icon(
                //Icons.subdirectory_arrow_left,
                //color: globals.isDarkTheme ? Colors.white : Colors.black,
                //)
                //],
                //),
                //)
                //],
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
                                        .trans('total_servers'),
                                    style: TextStyle(color: Colors.blueAccent)),
                                Text('$userTotalServers',
                                    style: TextStyle(
                                        color: globals.isDarkTheme
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 34.0))
                              ],
                            ),
                            Material(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(24.0),
                                child: Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Icon(Icons.dns,
                                      color: Colors.white, size: 30.0),
                                )))
                          ]),
                    ),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => AdminServerListPage())),
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
                                Text(DemoLocalizations.of(context).trans('Admin_HomeTotalNodes'),
                                    style: TextStyle(color: Colors.redAccent)),
                                Text('$totalNodes',
                                    style: TextStyle(
                                        color: globals.isDarkTheme
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 34.0))
                              ],
                            ),
                            Material(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(24.0),
                                child: Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Icon(Icons.public,
                                      color: Colors.white, size: 30.0),
                                )))
                          ]),
                    ),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => AdminNodesListPage())),
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
                                Text(DemoLocalizations.of(context).trans('Admin_HomeTotalUsers'),
                                    style: TextStyle(color: Colors.redAccent)),
                                Text('$totalUsers',
                                    style: TextStyle(
                                        color: globals.isDarkTheme
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 34.0))
                              ],
                            ),
                            Material(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(24.0),
                                child: Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Icon(Icons.person,
                                      color: Colors.white, size: 30.0),
                                )))
                          ]),
                    ),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => AdminUsersListPage())),
                  ),
                  _buildTile(
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Material(
                                color: Colors.teal,
                                shape: CircleBorder(),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Icon(Icons.settings_applications,
                                      color: Colors.white, size: 30.0),
                                )),
                            Padding(padding: EdgeInsets.only(bottom: 16.0)),
                            Text(
                                DemoLocalizations.of(context).trans('settings'),
                                style: TextStyle(
                                    color: globals.isDarkTheme
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24.0)),
                            Text(
                                DemoLocalizations.of(context)
                                    .trans('settings_sub'),
                                style: TextStyle(
                                  color: globals.isDarkTheme
                                      ? Colors.white70
                                      : Colors.black45,
                                )),
                          ]),
                    ),
                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => AdminSettingsList())),
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
                                  padding: EdgeInsets.all(16.0),
                                  child: Icon(Icons.notifications,
                                      color: Colors.white, size: 30.0),
                                )),
                            Padding(padding: EdgeInsets.only(bottom: 16.0)),
                            Text(DemoLocalizations.of(context).trans('alerts'),
                                style: TextStyle(
                                    color: globals.isDarkTheme
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24.0)),
                            Text(
                                DemoLocalizations.of(context)
                                    .trans('alerts_sub'),
                                style: TextStyle(
                                  color: globals.isDarkTheme
                                      ? Colors.white70
                                      : Colors.black45,
                                )),
                          ]),
                    ),
                    //onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ShopItemsPage())),
                    onTap: () {
                      print('Not set yet');
                    },
                  ),
                ],
                staggeredTiles: [
                  StaggeredTile.extent(2, 110.0),
                  StaggeredTile.extent(2, 110.0),
                  StaggeredTile.extent(2, 110.0),
                  StaggeredTile.extent(1, 180.0),
                  StaggeredTile.extent(1, 180.0),
                ],
              ));
        });
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
