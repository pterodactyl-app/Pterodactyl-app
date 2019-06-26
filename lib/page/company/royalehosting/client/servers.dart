/*
* Copyright 2018 Ruben Talstra and Yvan Watchman
*
* Licensed under the GNU General Public License v3.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*    https://www.gnu.org/licenses/gpl-3.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pterodactyl_app/models/server.dart';
import 'package:pterodactyl_app/page/auth/shared_preferences_helper.dart';
import 'package:pterodactyl_app/globals.dart' as globals;
import 'dart:async';
import 'dart:convert';
import 'package:pterodactyl_app/main.dart';
import 'package:pterodactyl_app/page/company/coderslight/client/actionserver.dart';

class RoyaleHostingServerListPage extends StatefulWidget {
  RoyaleHostingServerListPage({Key key}) : super(key: key);

  @override
  _RoyaleHostingServerListPageState createState() => _RoyaleHostingServerListPageState();
}

class _RoyaleHostingServerListPageState extends State<RoyaleHostingServerListPage> {
  Map data;
  List userData;

  final _searchForm = TextEditingController();
  dynamic appBarTitle;
  Icon icon = Icon(Icons.search);

  Future getData({String search: ''}) async {
    String _api = await SharedPreferencesHelper.getString("api_royalehosting_Key");
    http.Response response = await http.get(
      "https://pterodactyl.rhmc.nl/api/client",
      headers: {
        "Accept": "Application/vnd.pterodactyl.v1+json",
        "Authorization": "Bearer $_api"
      },
    );
    data = json.decode(response.body);
    setState(() {
      userData = [];
      if(search.isNotEmpty) {
        data['data'].forEach((v) {
          if(v['attributes']['name'].toString().contains(search)) {
            userData.add(v);
          }
        });
      } else {
        userData = data["data"];
      }
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
        backgroundColor: globals.useDarkTheme ? null : Colors.transparent,
        leading: IconButton(
          color: globals.useDarkTheme ? Colors.white : Colors.black,
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back),
        ),
        title: (this.appBarTitle != null ? this.appBarTitle : new Text(DemoLocalizations.of(context).trans('server_list'))),
        actions: <Widget>[
          new IconButton(icon: this.icon, onPressed: () {
            setState(() {
              if (this.icon.icon == Icons.search) {
                this.icon = Icon(Icons.close);
                appBarTitle = new TextField(
                  controller: _searchForm,
                  onChanged: (s) {
                    getData(search: s);
                  },
                  style: new TextStyle(color: globals.useDarkTheme ? Colors.white : Colors.black),
                  decoration: new InputDecoration(
                      prefixIcon: Icon(Icons.search, color: globals.useDarkTheme ? Colors.white : Colors.black),
                      hintText: "Search...",
                      hintStyle: new TextStyle(color: globals.useDarkTheme ? Colors.white : Colors.black)
                  ),
                );
              } else {
                getData();
                this.icon = Icon(Icons.search);
                appBarTitle = new Text(DemoLocalizations
                    .of(context)
                    .trans('server_list'));
              }
            });
          })

        ],
      ),
      body: ListView.builder(
        itemCount: userData == null ? 0 : userData.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
              child: Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Stack(
              children: <Widget>[
                /// Item card
                Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox.fromSize(
                      size: Size.fromHeight(140.0),
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 24.0),
                            child: Material(
                              elevation: 14.0,
                              borderRadius: BorderRadius.circular(12.0),
                              shadowColor: globals.useDarkTheme
                                  ? Colors.blueGrey
                                  : Color(0x802196F3),
                              child: InkWell(
                                onTap: () {
                                  var route = new MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        new ActionServerPage(
                                            server: Server(
                                                id: userData[index]
                                                        ["attributes"]
                                                    ["identifier"],
                                                name: userData[index]
                                                    ["attributes"]["name"])),
                                  );
                                  Navigator.of(context).push(route);
                                },
                                child: Container(
                                  child: Padding(
                                    padding: EdgeInsets.all(24.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        /// Title and rating
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                                '${userData[index]["attributes"]["description"]}',
                                                style: TextStyle(
                                                    color: Colors.blueAccent)),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                    '${userData[index]["attributes"]["name"]}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 18.0)),
                                              ],
                                            ),
                                          ],
                                        ),

                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                                DemoLocalizations.of(context)
                                                    .trans('total_ram'),
                                                style: TextStyle(
                                                  color: globals.useDarkTheme
                                                      ? Colors.white
                                                      : Colors.black,
                                                )),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 4.0),
                                              child: Material(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                color: Colors.green,
                                                child: Padding(
                                                  padding: EdgeInsets.all(4.0),
                                                  child: Text(
                                                      '${userData[index]["attributes"]["limits"]["memory"]} MB',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.white)),
                                                ),
                                              ),
                                            ),
                                            Text(
                                                DemoLocalizations.of(context)
                                                    .trans('total_disk'),
                                                style: TextStyle(
                                                  color: globals.useDarkTheme
                                                      ? Colors.white
                                                      : Colors.black,
                                                )),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 4.0),
                                              child: Material(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                color: Colors.green,
                                                child: Padding(
                                                  padding: EdgeInsets.all(4.0),
                                                  child: Text(
                                                      '${userData[index]["attributes"]["limits"]["disk"]} MB',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
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
                          )
                        ],
                      )),
                ),
              ],
            ),
          ));
        },
      ),
    );
  }
}
