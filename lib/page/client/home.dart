import 'package:flutter/material.dart';
import '../auth/shared_preferences_helper.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import '../../globals.dart' as globals;
import 'dart:async';
import 'dart:convert';
import 'servers.dart';
import 'settings.dart';
import '../../main.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map data;
  int userTotalServers = 0;
  
  Future getData() async {
    String _api = await SharedPreferencesHelper.getString("apiKey");
    String _url = await SharedPreferencesHelper.getString("panelUrl");
    http.Response response = await http.get(
      "$_url/api/client",
      headers: {
        "Accept": "Application/vnd.pterodactyl.v1+json",
        "Authorization": "Bearer $_api"
      },
    );
    data = json.decode(response.body);
    setState(() {
      userTotalServers = data["meta"]["pagination"]["total"];
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
          automaticallyImplyLeading: false,
          elevation: 2.0,
          backgroundColor: globals.isDarkTheme ? null : Colors.white,
          title: Text(DemoLocalizations.of(context).trans('dashboard'),
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
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => ServerListPage())),
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
                      Padding(padding: EdgeInsets.only(bottom: 12.0)),
                      Text(DemoLocalizations.of(context).trans('settings'),
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 24.0)),
                      Text(DemoLocalizations.of(context).trans('settings_sub'),
                          style: TextStyle(
                            color: globals.isDarkTheme
                                ? Colors.white70
                                : Colors.black45,
                          )),
                    ]),
              ),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => SettingsList())),
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
                      Padding(padding: EdgeInsets.only(bottom: 12.0)),
                      Text(DemoLocalizations.of(context).trans('alerts'),
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 24.0)),
                      Text(DemoLocalizations.of(context).trans('alerts_sub'),
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
                                  .trans('coming_soon'),
                              style: TextStyle(color: Colors.redAccent)),
                          Text(
                              DemoLocalizations.of(context)
                                  .trans('coming_soon_sub'),
                              style: TextStyle(
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
                            child: Icon(Icons.build,
                                color: Colors.white, size: 30.0),
                          )))
                    ]),
              ),
              //onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ShopItemsPage())),
            ),
          ],
          staggeredTiles: [
            StaggeredTile.extent(2, 110.0),
            StaggeredTile.extent(1, 180.0),
            StaggeredTile.extent(1, 180.0),
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
