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
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pterodactyl_app/globals.dart' as globals;
import 'package:pterodactyl_app/models/stats.dart';
import 'package:pterodactyl_app/page/auth/shared_preferences_helper.dart';

import 'dart:async';
import 'dart:convert';
import 'actionserver.dart';
import 'package:pterodactyl_app/main.dart';

class StatePage extends StatefulWidget {
  StatePage({Key key, this.server}) : super(key: key);
  final Stats server;

  @override
  _StatePageState createState() => _StatePageState();
}

class _StatePageState extends State<StatePage> {
  Map data;
  String _stats;
  int _memorycurrent;
  int _memorylimit;
  List<double> _cpu = [0.0].toList();
  double _currentCpu;
  int _limitCpu;
  int _diskcurrent;
  int _disklimit;
  Timer timer;

  Future getData() async {
    String _api = await SharedPreferencesHelper.getString("apiKey");
    String _url = await SharedPreferencesHelper.getString("panelUrl");
    String _https = await SharedPreferencesHelper.getString("https");

    http.Response response = await http.get(
      "$_https$_url/api/client/servers/${widget.server.id}/utilization",
      headers: {
        "Accept": "Application/vnd.pterodactyl.v1+json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $_api"
      },
    );

    List<double> parseCpu(cpu) {
      List<double> result = [];
      cpu.forEach((f) => result.add(f.toDouble()));
      return result;
    }

    data = json.decode(response.body);

    setState(() {
      _stats = data["attributes"]["state"];
      _memorycurrent = data["attributes"]["memory"]["current"];
      _memorylimit = data["attributes"]["memory"]["limit"];
      _cpu = parseCpu(data["attributes"]["cpu"]["cores"]);
      _currentCpu = data["attributes"]["cpu"]["current"].toDouble();
      _limitCpu = data["attributes"]["cpu"]["limit"];
      _diskcurrent = data["attributes"]["disk"]["current"];
      _disklimit = data["attributes"]["disk"]["limit"];
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) => getData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: globals.useDarkTheme ? null : Colors.transparent,
          leading: IconButton(
            color: globals.useDarkTheme ? Colors.white : Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
              timer.cancel();
            },
            icon: Icon(
              Icons.arrow_back,
              color: globals.useDarkTheme ? Colors.white : Colors.black,
            ),
          ),
          title: Text(DemoLocalizations.of(context).trans('utilization_stats'),
              style: TextStyle(fontWeight: FontWeight.w700)),
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
                          Text("Status:",
                              style: TextStyle(color: Colors.blueAccent)),
                          Text(
                              "$_stats" == "on"
                                  ? DemoLocalizations.of(context)
                                      .trans('utilization_stats_online')
                                  : "$_stats" == "off"
                                      ? DemoLocalizations.of(context)
                                          .trans('utilization_stats_offline')
                                      : "$_stats" == "starting"
                                          ? DemoLocalizations.of(context).trans(
                                              'utilization_stats_starting')
                                          : "$_stats" == "stopping"
                                              ? DemoLocalizations.of(context)
                                                  .trans(
                                                      'utilization_stats_stopping')
                                              : DemoLocalizations.of(context)
                                                  .trans(
                                                      'utilization_stats_Loading'),
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 20.0))
                        ],
                      ),
                      Material(
                          color: "$_stats" == "on"
                              ? Colors.green
                              : "$_stats" == "off"
                                  ? Colors.red
                                  : "$_stats" == "starting"
                                      ? Colors.blue
                                      : "$_stats" == "stopping"
                                          ? Colors.red
                                          : Colors.amber,
                          shape: CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(
                                "$_stats" == "on"
                                    ? Icons.play_arrow
                                    : "$_stats" == "off"
                                        ? Icons.stop
                                        : "$_stats" == "starting"
                                            ? Icons.loop
                                            : "$_stats" == "stopping"
                                                ? Icons.pause
                                                : Icons.data_usage,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  DemoLocalizations.of(context)
                                      .trans('utilization_performance_cpu'),
                                  style: TextStyle(color: Colors.blueAccent)),
                              Text(
                                  DemoLocalizations.of(context)
                                      .trans('utilization_cpu'),
                                  style: TextStyle(
                                      color: globals.useDarkTheme
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20.0)),
                            ],
                          ),
                          Text(
                              "$_stats" == "on"
                                  ? _limitCpu.toString() != null
                                      ? "$_currentCpu % / ∞ %"
                                      : "$_currentCpu % / ${_limitCpu.toString()} %"
                                  : "$_stats" == "off"
                                      ? DemoLocalizations.of(context)
                                          .trans('utilization_stats_offline')
                                      : DemoLocalizations.of(context)
                                          .trans('utilization_stats_Loading'),
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0)),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 4.0)),
                      Sparkline(
                        data: _cpu.isNotEmpty ? _cpu : [0.0],
                        lineWidth: 5.0,
                        lineGradient: new LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.green[800], Colors.green[200]],
                        ),
                      )
                    ],
                  )),
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
                                  .trans('utilization_memory'),
                              style: TextStyle(color: Colors.blueAccent)),
                          Text(
                              "$_stats" == "on"
                                  ? "$_memorycurrent MB / $_memorylimit MB"
                                  : "$_stats" == "off"
                                      ? DemoLocalizations.of(context)
                                          .trans('utilization_stats_offline')
                                      : "$_stats" == "starting"
                                          ? DemoLocalizations.of(context).trans(
                                              'utilization_stats_starting')
                                          : "$_stats" == "stopping"
                                              ? DemoLocalizations.of(context)
                                                  .trans(
                                                      'utilization_stats_stopping')
                                              : DemoLocalizations.of(context)
                                                  .trans(
                                                      'utilization_stats_Loading'),
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 20.0))
                        ],
                      ),
                      Material(
                          color: "$_stats" == "on"
                              ? Colors.green
                              : "$_stats" == "off"
                                  ? Colors.red
                                  : "$_stats" == "starting"
                                      ? Colors.blue
                                      : "$_stats" == "stopping"
                                          ? Colors.red
                                          : Colors.amber,
                          shape: CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(
                                "$_stats" == "on"
                                    ? FontAwesomeIcons.memory
                                    : "$_stats" == "off"
                                        ? FontAwesomeIcons.memory
                                        : "$_stats" == "starting"
                                            ? FontAwesomeIcons.memory
                                            : "$_stats" == "stopping"
                                                ? FontAwesomeIcons.memory
                                                : Icons.data_usage,
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
                              DemoLocalizations.of(context)
                                  .trans('utilization_disk'),
                              style: TextStyle(color: Colors.blueAccent)),
                          Text(
                              "$_stats" == "on"
                                  ? "$_diskcurrent MB / $_disklimit MB"
                                  : "$_stats" == "off"
                                      ? DemoLocalizations.of(context)
                                          .trans('utilization_stats_offline')
                                      : "$_stats" == "starting"
                                          ? DemoLocalizations.of(context).trans(
                                              'utilization_stats_starting')
                                          : "$_stats" == "stopping"
                                              ? DemoLocalizations.of(context)
                                                  .trans(
                                                      'utilization_stats_stopping')
                                              : DemoLocalizations.of(context)
                                                  .trans(
                                                      'utilization_stats_Loading'),
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 20.0))
                        ],
                      ),
                      Material(
                          color: "$_stats" == "on"
                              ? Colors.green
                              : "$_stats" == "off"
                                  ? Colors.red
                                  : "$_stats" == "starting"
                                      ? Colors.blue
                                      : "$_stats" == "stopping"
                                          ? Colors.red
                                          : Colors.amber,
                          shape: CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(
                                "$_stats" == "on"
                                    ? FontAwesomeIcons.hdd
                                    : "$_stats" == "off"
                                        ? FontAwesomeIcons.hdd
                                        : "$_stats" == "starting"
                                            ? FontAwesomeIcons.hdd
                                            : "$_stats" == "stopping"
                                                ? FontAwesomeIcons.hdd
                                                : Icons.data_usage,
                                color: Colors.white,
                                size: 30.0),
                          )),
                    ]),
              ),
              //onTap: () {},
            ),
          ],
          staggeredTiles: [
            StaggeredTile.extent(2, 110.0),
            StaggeredTile.extent(2, 220.0),
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
