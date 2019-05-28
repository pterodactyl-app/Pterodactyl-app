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

const String URI = "";

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
    initSocket();
  }

  initSocket() async {
    setState(() => isProbablyConnected = true);
    socket = await manager.createInstance(
        //Socket IO server URI
        URI,
        //Query params - can be used for authentication
        query: {
          "auth": "--SOME AUTH STRING---",
          "info": "new connection from adhara-socketio",
          "timestamp": DateTime.now().toString()
        },
        //Enable or disable platform channel logging
        enableLogging: false);
    socket.onConnect((data) {
      pprint("connected...");
      pprint(data);
      sendMessage();
    });
    socket.onConnectError(pprint);
    socket.onConnectTimeout(pprint);
    socket.onError(pprint);
    socket.onDisconnect(pprint);
    socket.on("news", (data) {
      pprint("news");
      pprint(data);
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
      body: Container(
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: Center(
              child: ListView(
                children: toPrint.map((String _) => Text(_ ?? "")).toList(),
              ),
            )),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
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
                 Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: RaisedButton(
                      child: Text("Connect"),
                      onPressed: isProbablyConnected?null:initSocket,
                    ),
                  ),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: RaisedButton(
                      child: Text(
                          DemoLocalizations.of(context).trans('send_command')),
                      //onPressed: isProbablyConnected?sendMessage:null,
                      onPressed: () async {
                        await SharedPreferencesHelper.setString(
                            "send", _sendController.text);
                        postSend();
                      },
                    )),
              ],
            ),
            SizedBox(
              height: 12.0,
            )
          ],
        ),
      ),
    );
  }
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
