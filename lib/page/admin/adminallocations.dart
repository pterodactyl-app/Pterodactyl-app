import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../auth/shared_preferences_helper.dart';
import '../../globals.dart' as globals;
import 'dart:async';
import 'dart:convert';
import '../../main.dart';
import 'adminactionnodes.dart';

class AdminAllocationsPage extends StatefulWidget {
  AdminAllocationsPage({Key key, this.server}) : super(key: key);
  final Admin server;

  @override
  _AdminAllocationsPageState createState() => _AdminAllocationsPageState();
}

class _AdminAllocationsPageState extends State<AdminAllocationsPage> {
  Map data;
  List userData;

  Future getData() async {
    String _apiadmin = await SharedPreferencesHelper.getString("apiAdminKey");
    String _urladmin = await SharedPreferencesHelper.getString("panelAdminUrl");
    http.Response response = await http.get(
      "$_urladmin/api/application/nodes/${widget.server.adminid}/allocations",
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
        title: Text(DemoLocalizations.of(context).trans('Admin_allocations_List'),
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
                                      '${userData[index]["attributes"]["alias"]}',
                                      style:
                                          TextStyle(color: Colors.blueAccent)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                          'IP: ${userData[index]['attributes']['ip']}',
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
                                  Text(DemoLocalizations.of(context).trans('Admin_allocations_ID'),
                                      style: TextStyle(
                                        color: globals.isDarkTheme
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 18.0,
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
                                            '${userData[index]["attributes"]["id"]}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white)),
                                      ),
                                    ),
                                  ),
                                  Text(DemoLocalizations.of(context).trans('Admin_allocations_Assigned'),
                                      style: TextStyle(
                                        color: globals.isDarkTheme
                                            ? Colors.white
                                            : Colors.black,
                                            fontSize: 18.0,
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
                                            '${userData[index]["attributes"]["assigned"]}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white)),
                                      ),
                                    ),
                                  ),
                                  Text(DemoLocalizations.of(context).trans('Admin_allocations_Port'),
                                      style: TextStyle(
                                        color: globals.isDarkTheme
                                            ? Colors.white
                                            : Colors.black,
                                            fontSize: 18.0,
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
                                            '${userData[index]["attributes"]["port"]}',
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
