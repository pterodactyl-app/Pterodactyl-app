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
import '../auth/shared_preferences_helper.dart';
import 'package:http/http.dart' as http;
import '../../globals.dart' as globals;
import 'dart:async';
import 'dart:convert';
import '../../main.dart';
import 'actionserver.dart';

String socketUrl;
List<String> logRows = new List<String>();

class SendPage extends StatefulWidget {
  SendPage({Key key, this.server}) : super(key: key);
  final Send server;

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
//      sendMessage();
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
      data.toString().split('/\n/\g').forEach((data) => {logRows.add(data)});
    });

    socket.on('console', (data) {
      pprint('console');
      if (data['line'] != null) {
        setState(() {
          data['line']
              .toString()
              .split('\\n\\g')
              .forEach((data) => {
                logRows.add(data)
              });
        });
      }
    });
    socket.connect();
  }

  disconnect() async {
    await manager.clearInstance(socket);
    setState(() => isProbablyConnected = false);
  }

  sendMessage() {
    if (socket != null) {
      pprint("sending message...");
      socket.emit("message", [
        "Hello world!",
        1908,
        {
          "wonder": "Woman",
          "comics": ["DC", "Marvel"]
        },
        {"test": "=!./"},
        [
          "I'm glad",
          2019,
          {
            "come back": "Tony",
            "adhara means": ["base", "foundation"]
          },
          {"test": "=!./"},
        ]
      ]);
      pprint("Message emitted...");
    }
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
          onPressed: () => Navigator.of(context).pop(),
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
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          children: <Widget>[
            SizedBox(height: 10.0),
            SingleChildScrollView(
                child: new Wrap(
                  direction: Axis.vertical,
                  children: <Widget>[
                    getTextWidgets()
                  ],
                )
            ),
            SizedBox(height: 10.0),
            AccentColorOverride(
              color: Colors.red,
              child: TextField(
                controller: _sendController,
                decoration: InputDecoration(
                  labelText: (DemoLocalizations.of(context)
                      .trans('type_command_here')),
                ),
              ),
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text(DemoLocalizations.of(context).trans('clear')),
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  ),
                  onPressed: () {
                    _sendController.clear();
                  },
                ),
                RaisedButton(
                  child:
                      Text(DemoLocalizations.of(context).trans('send_command')),
                  elevation: 8.0,
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  ),
                  onPressed: () async {
                    await SharedPreferencesHelper.setString(
                        "send", _sendController.text);
                    postSend();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget getTextWidgets() {
  if (logRows != null) {
    return new Row(children: logRows.map((item) => new Text(item)).toList());
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
