import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../auth/shared_preferences_helper.dart';
import '../../globals.dart' as globals;
import 'dart:async';
import 'dart:convert';
import '../../main.dart';
import 'adminuserinfo.dart';
import 'admincreateuser.dart';

class Admin {
  final String adminid, username;
  const Admin({this.adminid, this.username});
}

class AdminUsersListPage extends StatefulWidget {
  AdminUsersListPage({Key key}) : super(key: key);

  @override
  _AdminUsersListPageState createState() => _AdminUsersListPageState();
}

class _AdminUsersListPageState extends State<AdminUsersListPage> {
  Map data;
  List userData;

  Future getData() async {
    String _apiadmin = await SharedPreferencesHelper.getString("apiAdminKey");
    String _urladmin = await SharedPreferencesHelper.getString("panelAdminUrl");
    String _adminhttps = await SharedPreferencesHelper.getString("adminhttps");
    http.Response response = await http.get(
      "$_adminhttps$_urladmin/api/application/users",
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
        title: Text(DemoLocalizations.of(context).trans('admin_user_list_list'),
            style: TextStyle(
                color: globals.isDarkTheme ? Colors.white : Colors.black,
                fontWeight: FontWeight.w700)),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconButton(icon: Icon(Icons.search), onPressed: () {})
              ],
            ),
          )
        ],
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
                        onTap: () {
                          var route = new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new AdminUserInfoPage(
                                    server: Admin(
                                        adminid: userData[index]["attributes"]
                                                ["id"]
                                            .toString(),
                                        username: userData[index]["attributes"]
                                            ["username"])),
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
                                      '${userData[index]["attributes"]["first_name"]} ${userData[index]["attributes"]["last_name"]}',
                                      style: TextStyle(
                                          color: globals.isDarkTheme
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18.0)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                          '${userData[index]["attributes"]["email"]}',
                                          style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14.0)),
                                    ],
                                  ),
                                ],
                              ),

                              /// Infos
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text('Superuser',
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
                                      color:
                                          "${userData[index]["attributes"]["root_admin"]}" ==
                                                  "true"
                                              ? Colors.green
                                              : Colors.blue,
                                      child: Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Text(
                                            '${userData[index]["attributes"]["root_admin"]}' ==
                                                    "true"
                                                ? DemoLocalizations.of(context)
                                                    .trans('yes')
                                                : DemoLocalizations.of(context)
                                                    .trans('no'),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white)),
                                      ),
                                    ),
                                  ),
                                  Text('2FA',
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
                                      color:
                                          "${userData[index]["attributes"]["2fa"]}" ==
                                                  "true"
                                              ? Colors.green
                                              : Colors.red,
                                      child: Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Text(
                                            '${userData[index]["attributes"]["2fa"]}' ==
                                                    "true"
                                                ? DemoLocalizations.of(context)
                                                    .trans('yes')
                                                : DemoLocalizations.of(context)
                                                    .trans('no'),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => AdminCreateUserPage()));
        },
        icon: Icon(Icons.add),
        label:
            Text(DemoLocalizations.of(context).trans('admin_user_list_user')),
      ),
    );
  }
}
