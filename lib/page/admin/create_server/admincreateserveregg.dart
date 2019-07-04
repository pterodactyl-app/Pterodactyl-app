/*
* Copyright 2018-2019 Ruben Talstra and Yvan Watchman
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
import '../../auth/shared_preferences_helper.dart';
import 'package:pterodactyl_app/models/globals.dart' as globals;
import 'dart:async';
import 'dart:convert';
import '../../../main.dart';
import 'admincreateservernest.dart';
import 'admincreateserverlimit.dart';

class Egg {
  final String nestid, userid, eggid, dockerimage, servername, startup;
  const Egg(
      {this.nestid,
      this.userid,
      this.eggid,
      this.dockerimage,
      this.startup,
      this.servername});
}

class AdminCreateServerEggsPage extends StatefulWidget {
  AdminCreateServerEggsPage({Key key, this.server}) : super(key: key);
  final Nest server;

  @override
  _AdminCreateServerEggsPageState createState() =>
      _AdminCreateServerEggsPageState();
}

class _AdminCreateServerEggsPageState extends State<AdminCreateServerEggsPage> {
  Map data;
  List userData;

  Future getData() async {
    String _apiadmin = await SharedPreferencesHelper.getString("apiAdminKey");
    String _urladmin = await SharedPreferencesHelper.getString("panelAdminUrl");
    String _adminhttps = await SharedPreferencesHelper.getString("adminhttps");
    http.Response response = await http.get(
      "$_adminhttps$_urladmin/api/application/nests",
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
        backgroundColor: globals.useDarkTheme ? null : Colors.transparent,
        leading: IconButton(
          color: globals.useDarkTheme ? Colors.white : Colors.black,
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back,
              color: globals.useDarkTheme ? Colors.white : Colors.black),
        ),
        title: Text(DemoLocalizations.of(context).trans('admin_create_server_3_8'),
            style: TextStyle(
                color: globals.useDarkTheme ? Colors.white : Colors.black,
                fontWeight: FontWeight.w700)),
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
                          /// Item description inside a material
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
                                        new AdminCreateServerLimitPage(
                                            server: Egg(
                                          eggid: userData[index]["attributes"]
                                                  ["id"]
                                              .toString(),
                                          dockerimage: userData[index]
                                              ["attributes"]["docker_image"],
                                          startup: userData[index]["attributes"]
                                              ["startup"],
                                          userid: widget.server.userid,
                                          nestid: widget.server.nestid,
                                          servername: widget.server.servername,
                                        )),
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
                                                '${userData[index]["attributes"]["description"]}}',
                                                style: TextStyle(
                                                    color: Colors.blueAccent)),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                    '${userData[index]["attributes"]["author"]}',
                                                    style: TextStyle(
                                                        color:
                                                            globals.useDarkTheme
                                                                ? Colors.white
                                                                : Colors.black,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 20.0)),
                                              ],
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
