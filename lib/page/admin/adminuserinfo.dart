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
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../auth/shared_preferences_helper.dart';
import '../../globals.dart' as globals;
import '../../main.dart';
import 'dart:async';
import 'dart:convert';
import 'adminusers.dart';

class AdminUserInfoPage extends StatefulWidget {
  AdminUserInfoPage({Key key, this.server}) : super(key: key);
  final Admin server;

  @override
  _AdminUserInfoPageState createState() => _AdminUserInfoPageState();
}

class _AdminUserInfoPageState extends State<AdminUserInfoPage> {
  Map data;
  String firstname;
  String lastname;
  String language;
  bool rootadmin;
  bool fa;
  String email;
  String uuid;
  String externalid;
  String createdat;
  String updatedat;

  Future getData() async {
    String _apiadmin = await SharedPreferencesHelper.getString("apiAdminKey");
    String _urladmin = await SharedPreferencesHelper.getString("panelAdminUrl");
    String _adminhttps = await SharedPreferencesHelper.getString("adminhttps");
    http.Response response = await http.get(
      "$_adminhttps$_urladmin/api/application/users/${widget.server.adminid}",
      headers: {
        "Accept": "Application/vnd.pterodactyl.v1+json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $_apiadmin"
      },
    );
    data = json.decode(response.body);
    setState(() {
      firstname = data["attributes"]["first_name"];
      lastname = data["attributes"]["last_name"];
      language = data["attributes"]["language"];
      rootadmin = data["attributes"]["root_admin"];
      fa = data["attributes"]["2fa"];
      email = data["attributes"]["email"];
      uuid = data["attributes"]["uuid"];
      externalid = data["attributes"]["external_id"];
      createdat = data["attributes"]["created_at"];
      updatedat = data["attributes"]["updated_at"];
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
            icon: Icon(
              Icons.arrow_back,
              color: globals.useDarkTheme ? Colors.white : Colors.black,
            ),
          ),
          title: Text('${widget.server.username}',
              style: TextStyle(
                  color: globals.useDarkTheme ? Colors.white : Colors.black,
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
                          Text(DemoLocalizations.of(context).trans('firstname'),
                              style: TextStyle(color: Colors.blueAccent)),
                          Text('$firstname',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 20.0))
                        ],
                      )
                    ]),
              ),
              //onTap: () {},
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
                          Text(DemoLocalizations.of(context).trans('lastname'),
                              style: TextStyle(color: Colors.blueAccent)),
                          Text('$lastname',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 20.0))
                        ],
                      )
                    ]),
              ),
              //onTap: () {},
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
                          Text(DemoLocalizations.of(context).trans('email'),
                              style: TextStyle(color: Colors.blueAccent)),
                          Text('$email',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 20.0))
                        ],
                      )
                    ]),
              ),
              //onTap: () {},
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
                          Text(DemoLocalizations.of(context).trans('uuid'),
                              style: TextStyle(color: Colors.blueAccent)),
                          Text('$uuid',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 16.0))
                        ],
                      )
                    ]),
              ),
              //onTap: () {},
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
                          Text(DemoLocalizations.of(context).trans('id'),
                              style: TextStyle(color: Colors.blueAccent)),
                          Text('${widget.server.adminid.toString()}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 20.0))
                        ],
                      )
                    ]),
              ),
              //onTap: () {},
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
                          Text(DemoLocalizations.of(context).trans('language'),
                              style: TextStyle(color: Colors.blueAccent)),
                          Text('$language',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 20.0))
                        ],
                      )
                    ]),
              ),
              //onTap: () {},
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
                          Text(DemoLocalizations.of(context).trans('rootadmin'),
                              style: TextStyle(color: Colors.blueAccent)),
                          Text(
                              "$rootadmin" == "true"
                                  ? DemoLocalizations.of(context).trans('yes')
                                  : DemoLocalizations.of(context).trans('no'),
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 20.0))
                        ],
                      )
                    ]),
              ),
              //onTap: () {},
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
                          Text(DemoLocalizations.of(context).trans('2fa'),
                              style: TextStyle(color: Colors.blueAccent)),
                          Text(
                              "$fa" == "true"
                                  ? DemoLocalizations.of(context).trans('yes')
                                  : DemoLocalizations.of(context).trans('no'),
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 20.0))
                        ],
                      ),
                      Material(
                          color: "$fa" == "true" ? Colors.green : Colors.red,
                          shape: CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(
                                "$fa" == "true" ? Icons.lock : Icons.lock_open,
                                color: Colors.white,
                                size: 30.0),
                          )),
                    ]),
              ),
              //onTap: () {},
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
                              DemoLocalizations.of(context).trans('created_at'),
                              style: TextStyle(color: Colors.blueAccent)),
                          Text('$createdat',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 20.0))
                        ],
                      )
                    ]),
              ),
              //onTap: () {},
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
                              DemoLocalizations.of(context).trans('updated_at'),
                              style: TextStyle(color: Colors.blueAccent)),
                          Text('$updatedat',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 20.0))
                        ],
                      )
                    ]),
              ),
              //onTap: () {},
            ),
          ],
          staggeredTiles: [
            StaggeredTile.extent(1, 110.0),
            StaggeredTile.extent(1, 110.0),
            StaggeredTile.extent(2, 110.0),
            StaggeredTile.extent(2, 110.0),
            StaggeredTile.extent(1, 110.0),
            StaggeredTile.extent(1, 110.0),
            StaggeredTile.extent(1, 110.0),
            StaggeredTile.extent(1, 110.0),
            StaggeredTile.extent(2, 110.0),
            StaggeredTile.extent(2, 110.0),
          ],
        ));
  }

  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: globals.useDarkTheme ? Colors.blueGrey : Color(0x802196F3),
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
