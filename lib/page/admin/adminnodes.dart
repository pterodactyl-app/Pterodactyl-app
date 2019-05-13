import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../auth/shared_preferences_helper.dart';
import '../../globals.dart' as globals;
import 'dart:async';
import 'dart:convert';
import '../../main.dart';
import 'adminactionnodes.dart';

class Nodes {
  final String adminids, adminname, adminip;
  const Nodes({
    this.adminids,
    this.adminname,
    this.adminip
  });
}

class AdminNodesListPage extends StatefulWidget {
  AdminNodesListPage({Key key}) : super(key: key);

  @override
  _AdminNodesListPageState createState() => _AdminNodesListPageState();
}

class _AdminNodesListPageState extends State<AdminNodesListPage> {
  Map data;
  List userData;

  Future getData() async {
    String _apiadmin = await SharedPreferencesHelper.getString("apiAdminKey");
    String _urladmin = await SharedPreferencesHelper.getString("panelAdminUrl");
    http.Response response = await http.get(
      "$_urladmin/api/application/nodes",
      headers: {
        "Accept": "Application/vnd.pterodactyl.v1+json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $_apiadmin"
      },
    );
    data = json.decode(response.body);
    setState(() {
      userData = data["data"];
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
          icon: Icon(Icons.arrow_back,
              color: globals.isDarkTheme ? Colors.white : Colors.black),
        ),
        title: Text('Nodes',
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
      body: ListView.builder(
        itemCount: userData == null ? 0 : userData.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 16.0),
                    child: Material(
                      elevation: 14.0,
                      borderRadius: BorderRadius.circular(12.0),
                      shadowColor: globals.isDarkTheme
                          ? Colors.grey[700]
                          : Color(0x802196F3),
                      color:
                          globals.isDarkTheme ? Colors.grey[850] : Colors.white,
                      child: InkWell(
                        onTap: () async {
                          await SharedPreferencesHelper.setString(
                        "NodeAdminIP", userData[index]["attributes"]["ip"]);
                          var route = new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new AdminActionNodesPage(
                                    server: Nodes(
                                        adminids: userData[index]["attributes"]["id"].toString(),
                                        adminname: userData[index]["attributes"]["name"],                                   )),
                          );
                          Navigator.of(context).push(route);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(30.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              /// Title and rating
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                      '${userData[index]["attributes"]["description"]} ${userData[index]["attributes"]["id"]}',
                                      style:
                                          TextStyle(color: Colors.blueAccent)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                          '${userData[index]["attributes"]["name"]}',
                                          style: TextStyle(
                                              color: globals.isDarkTheme
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18.0)),
                                    ],
                                  ),
                                ],
                              ),

                              /// Infos
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                      DemoLocalizations.of(context)
                                          .trans('total_ram'),
                                      style: TextStyle(
                                        color: globals.isDarkTheme
                                            ? Colors.white
                                            : Colors.black,
                                      )),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 4.0),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: Colors.green,
                                      child: Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Text(
                                            '${userData[index]["attributes"]["memory"]} MB',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white)),
                                      ),
                                    ),
                                  ),
                                  Text(
                                      DemoLocalizations.of(context)
                                          .trans('total_disk'),
                                      style: TextStyle(
                                        color: globals.isDarkTheme
                                            ? Colors.white
                                            : Colors.black,
                                      )),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 4.0),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: Colors.green,
                                      child: Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Text(
                                            '${userData[index]["attributes"]["disk"]} MB',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),                  
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
