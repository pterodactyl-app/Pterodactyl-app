import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'servers.dart';
import 'settings.dart';
import 'login.dart';
import 'main.dart';

class MyHomePage extends StatefulWidget {

final User value;
MyHomePage({Key key, this.value}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Map data;
  int userTotalServers;

  Future getData() async {
    http.Response response = await http.get("https://${widget.value.url}/api/client",
    headers: {"Accept": "Application/vnd.pterodactyl.v1+json", "Authorization": "Bearer ${widget.value.api}"},
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


  final List<List<double>> charts =
  [
    [0.0, 0.3, 0.7, 0.6, 0.55, 0.8, 1.2, 1.3, 1.35, 0.9, 1.5, 1.7, 1.8, 1.7, 1.2, 0.8, 1.9, 2.0, 2.2, 1.9, 2.2, 2.1, 2.0, 2.3, 2.4, 2.45, 2.6, 3.6, 2.6, 2.7, 2.9, 2.8, 3.4],
    [0.0, 0.3, 0.7, 0.6, 0.55, 0.8, 1.2, 1.3, 1.35, 0.9, 1.5, 1.7, 1.8, 1.7, 1.2, 0.8, 1.9, 2.0, 2.2, 1.9, 2.2, 2.1, 2.0, 2.3, 2.4, 2.45, 2.6, 3.6, 2.6, 2.7, 2.9, 2.8, 3.4, 0.0, 0.3, 0.7, 0.6, 0.55, 0.8, 1.2, 1.3, 1.35, 0.9, 1.5, 1.7, 1.8, 1.7, 1.2, 0.8, 1.9, 2.0, 2.2, 1.9, 2.2, 2.1, 2.0, 2.3, 2.4, 2.45, 2.6, 3.6, 2.6, 2.7, 2.9, 2.8, 3.4,],
    [0.0, 0.3, 0.7, 0.6, 0.55, 0.8, 1.2, 1.3, 1.35, 0.9, 1.5, 1.7, 1.8, 1.7, 1.2, 0.8, 1.9, 2.0, 2.2, 1.9, 2.2, 2.1, 2.0, 2.3, 2.4, 2.45, 2.6, 3.6, 2.6, 2.7, 2.9, 2.8, 3.4, 0.0, 0.3, 0.7, 0.6, 0.55, 0.8, 1.2, 1.3, 1.35, 0.9, 1.5, 1.7, 1.8, 1.7, 1.2, 0.8, 1.9, 2.0, 2.2, 1.9, 2.2, 2.1, 2.0, 2.3, 2.4, 2.45, 2.6, 3.6, 2.6, 2.7, 2.9, 2.8, 3.4, 0.0, 0.3, 0.7, 0.6, 0.55, 0.8, 1.2, 1.3, 1.35, 0.9, 1.5, 1.7, 1.8, 1.7, 1.2, 0.8, 1.9, 2.0, 2.2, 1.9, 2.2, 2.1, 2.0, 2.3, 2.4, 2.45, 2.6, 3.6, 2.6, 2.7, 2.9, 2.8, 3.4]
  ];

  static final List<String> chartDropdownItems = [ 'Last 7 days', 'Last month', 'Last year' ];
  String actualDropdown = chartDropdownItems[0];
  int actualChart = 0;

  @override
  Widget build(BuildContext context)
  {
        return Scaffold
        (
          appBar: AppBar
          (
            elevation: 2.0,
            backgroundColor: Colors.white,
            title: Text(DemoLocalizations.of(context).trans('dashboard'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 30.0)),
            actions: <Widget>
            [
              Container
              (
                margin: EdgeInsets.only(right: 8.0),
                child: Row
                (
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>
                  [
                    Text(DemoLocalizations.of(context).trans('logout'), style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w700, fontSize: 14.0)),
                    Icon(Icons.subdirectory_arrow_left, color: Colors.black54)
                  ],
                ),
              )
            ],
          ),
          body: StaggeredGridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            children: <Widget>[
              _buildTile(
                Padding
                (
                  padding: const EdgeInsets.all(24.0),
                  child: Row
                  (
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>
                    [
                      Column
                      (
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>
                        [
                          Text(DemoLocalizations.of(context).trans('total_servers'), style: TextStyle(color: Colors.blueAccent)),
                          Text('$userTotalServers', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 34.0))
                    ],
                  ),
                  Material
                  (
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(24.0),
                    child: Center
                    (
                      child: Padding
                      (
                        padding: const EdgeInsets.all(16.0),
                        child: Icon(Icons.timeline, color: Colors.white, size: 30.0),
                      )
                    )
                  )
                ]
              ),
            ),
            onTap: () {
              Navigator.push( context,
  MaterialPageRoute(
    builder: (context) => ServerListPage(url: widget.value.url,api: widget.value.api)
  )
);
      },
          ),
          _buildTile(
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column
              (
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>
                [
                  Material
                  (
                    color: Colors.teal,
                    shape: CircleBorder(),
                    child: Padding
                    (
                      padding: const EdgeInsets.all(16.0),
                      child: Icon(Icons.settings_applications, color: Colors.white, size: 30.0),
                    )
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 16.0)),
                  Text(DemoLocalizations.of(context).trans('settings'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 24.0)),
                  Text(DemoLocalizations.of(context).trans('settings_sub'), style: TextStyle(color: Colors.black45)),
                ]
              ),
            ),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => SettingsList())),
          ),
          _buildTile(
            Padding
            (
              padding: const EdgeInsets.all(24.0),
              child: Column
              (
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>
                [
                  Material
                  (
                    color: Colors.amber,
                    shape: CircleBorder(),
                    child: Padding
                    (
                      padding: EdgeInsets.all(16.0),
                      child: Icon(Icons.notifications, color: Colors.white, size: 30.0),
                    )
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 16.0)),
                  Text(DemoLocalizations.of(context).trans('alerts'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 24.0)),
                  Text(DemoLocalizations.of(context).trans('alerts_sub'), style: TextStyle(color: Colors.black45)),
                ]
              ),
            ),
            //onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ShopItemsPage())),
            onTap: () {
              print('Not set yet');
            },
          ),
          _buildTile(
            Padding
            (
              padding: const EdgeInsets.all(24.0),
              child: Row
              (
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>
                [
                  Column
                  (
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>
                    [
                      Text(DemoLocalizations.of(context).trans('comming_soon'), style: TextStyle(color: Colors.redAccent)),
                      Text(DemoLocalizations.of(context).trans('comming_soon_sub'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 34.0))
                    ],
                  ),
                  Material
                  (
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(24.0),
                    child: Center
                    (
                      child: Padding
                      (
                        padding: EdgeInsets.all(16.0),
                        child: Icon(Icons.build, color: Colors.white, size: 30.0),
                      )
                    )
                  )
                ]
              ),
            ),
            //onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ShopItemsPage())),
          )
        ],
        staggeredTiles: [
          StaggeredTile.extent(2, 110.0),
          StaggeredTile.extent(1, 180.0),
          StaggeredTile.extent(1, 180.0),
          StaggeredTile.extent(2, 110.0),
        ],
      )
        
    );
  }

  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
      elevation: 14.0,
      borderRadius: BorderRadius.circular(12.0),
      shadowColor: Color(0x802196F3),
      child: InkWell
      (
        // Do onTap() if it isn't null, otherwise do print()
        onTap: onTap != null ? () => onTap() : () { print('Not set yet'); },
        child: child
      )
    );
  }
}
