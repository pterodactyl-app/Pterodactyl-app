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
import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pterodactyl_app/models/stats.dart';
import 'package:pterodactyl_app/models/server.dart';
import 'package:pterodactyl_app/page/auth/shared_preferences_helper.dart';
import 'package:http/http.dart' as http;
import 'package:pterodactyl_app/globals.dart' as globals;
import 'dart:async';
import 'dart:convert';
import 'package:pterodactyl_app/main.dart';
import 'package:pterodactyl_app/page/client/actionserver.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:responsive_container/responsive_container.dart';
import 'actionserver.dart';
import 'utilization.dart';

String socketUrl;
List<String> logRows = new List<String>();

class SendPage extends StatefulWidget {
  SendPage({Key key, this.server}) : super(key: key);
  final Server server;

  @override
  _SendPageState createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  List<String> toPrint = ["trying to conenct"];
  SocketIOManager manager;
  SocketIO socket;
  bool isProbablyConnected = false;

  final _sendController = TextEditingController();

  Future postSend() async {
    String _send = await SharedPreferencesHelper.getString("send");
    String _api = await SharedPreferencesHelper.getString("apiKey");
    String _url = await SharedPreferencesHelper.getString("panelUrl");
    String _https = await SharedPreferencesHelper.getString("https");
    var url = '$_https$_url/api/client/servers/${widget.server.id}/command';

    Map data = {'command': '$_send'};
    //encode Map to JSON
    var body = json.encode(data);

    var response = await http.post(url,
        headers: {
          "Accept": "Application/vnd.pterodactyl.v1+json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $_api"
        },
        body: body);
    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }

  @override
  void initState() {
    super.initState();
    manager = SocketIOManager();
    getServerInfo().then(initSocket);
  }

  getServerInfo() async {
    String _api = await SharedPreferencesHelper.getString("apiKey");
    String _url = await SharedPreferencesHelper.getString("panelUrl");
    String _https = await SharedPreferencesHelper.getString("https");

    var url = '$_https$_url/api/app/user/console/${widget.server.id}';

    var response = await http.get(url, headers: {
      "Accept": "Application/vnd.pterodactyl.v1+json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $_api"
    });

    return response;
  }

  initSocket(socketData) async {
    Map data = json.decode(socketData.body);

    if (!data.containsKey('attributes')) {
      return;
    }

    data = data['attributes'];
    print(data['identifier']);
    socketUrl = "https://" + data['node'] + "/v1/ws/" + data['identifier'];

    setState(() => isProbablyConnected = true);
    socket = await manager.createInstance(
        //Socket IO server URI
        socketUrl,
        //Query params - can be used for authentication
        query: {
          "token": data['daemon_key'],
        },
        //Enable or disable platform channel logging
        enableLogging: false);
    socket.onConnect((data) {
      pprint("connected...");
      pprint(data);
    });
    socket.onConnectError(pprint);
    socket.onConnectTimeout(pprint);
    socket.onError(pprint);
    socket.onDisconnect(pprint);
    socket.on('initial status', (data) {
      if (data['status'] == 1 || data['status'] == 2) {
        socket.emit('send server log', null);
      }
    });
    socket.on('status', (data) {});
    socket.on('server log', (data) {
      data.toString().split('/\n/\g').forEach((data) => logRows.add(data));
    });

    socket.on('console', (data) {
      pprint('console');
      if (data['line'] != null) {
        setState(() {
          data['line'].toString().split('\\n\\g').forEach((data) => {
                if (data.length > 52)
                  {
                    logRows.add(data.substring(0, 51)),
                    logRows.add(data.substring(52))
                  }
                else
                  {logRows.add(data)}
              });
        });
      }
    });
    socket.connect();
  }

  disconnect() async {
    await manager.clearInstance(socket);
    setState(() => {isProbablyConnected = false, logRows.clear()});
  }

  pprint(data) {
    setState(() {
      if (data is Map) {
        data = json.encode(data);
      }
      print(data);
      toPrint.add(data);
    });
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
              disconnect();
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back,
                color: globals.useDarkTheme ? Colors.white : Colors.black),
          ),
          title: Text(DemoLocalizations.of(context).trans('console'),
              style: TextStyle(
                  color: globals.useDarkTheme ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w700)),
        ),
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              SizedBox(height: 10.0),
          ResponsiveContainer(
            heightPercent: 76.0, //value percent of screen total height
            widthPercent: 100.0,  //value percent of screen total width
            child:
            Container(
                height: 700,
                color: Colors.black,
                child: SingleChildScrollView(
                    child: new Wrap(
                  direction: Axis.vertical,
                  children: <Widget>[getTextWidgets()],
                )),
              ),
        ),
              SizedBox(height: 1.0),
              TextField(
                onSubmitted: (text) async {
                  await SharedPreferencesHelper.setString(
                      "send", _sendController.text);
                  postSend();
                  _sendController.clear();
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border:InputBorder.none,
                  filled:true,
                  fillColor: Colors.black,
                  hintStyle: TextStyle(color: Colors.white),
                  prefixStyle: TextStyle(color: Colors.white),
                  hintText: DemoLocalizations.of(context)
                      .trans('type_command_here'),
                  prefixText:'container:~/\$ ',
                ),
                controller: _sendController,
              ),
            ],
          ),
        ),
        bottomNavigationBar: TitledBottomNavigationBar(
            initialIndex: 0,
            currentIndex: 2, // Use this to update the Bar giving a position
            onTap: _navigate,
            items: [
              TitledNavigationBarItem(
                  backgroundColor: globals.useDarkTheme ? Colors.black87 : null,
                  title: "Info", icon: FontAwesomeIcons.info),
              TitledNavigationBarItem(
                  backgroundColor: globals.useDarkTheme ? Colors.black87 : null,
                  title:
                      DemoLocalizations.of(context).trans('utilization_stats'),
                  icon: FontAwesomeIcons.chartBar),
              TitledNavigationBarItem(
                  backgroundColor: globals.useDarkTheme ? Colors.black87 : null,
                  title: DemoLocalizations.of(context).trans('console'),
                  icon: FontAwesomeIcons.terminal),
            ]));
  }


  Future _navigate(int index) async {
    if(index == 0) {
      Navigator.of(this.context).pushAndRemoveUntil(
          new MaterialPageRoute(builder: (BuildContext context) =>
          new ActionServerPage(
              server: Server(id: widget.server.id, name: widget.server.name))
          ), (Route<dynamic> route) => false);
    }
    if(index == 1) {
      Navigator.of(this.context).pushAndRemoveUntil(
          new MaterialPageRoute(builder: (BuildContext context) =>
          new StatePage(
              server: Stats(id: widget.server.id))
          ), (Route<dynamic> route) => false);
    }
  }
}

Widget getTextWidgets() {
  if (logRows != null) {
    return new Row(
        children: logRows
            .map((item) => new Text(
                  item,
                  style: TextStyle(color: Colors.white),
                ))
            .toList());
  }
  return new Row(children: []);
}

class AccentColorOverride extends StatelessWidget {
  const AccentColorOverride({Key key, this.color, this.child})
      : super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      child: child,
      data: Theme.of(context).copyWith(
        accentColor: color,
        brightness: Brightness.dark,
      ),
    );
  }
}
