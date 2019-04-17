import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Map data;
  List userData;

  Future getData() async {
    http.Response response = await http.get("https://YOUR_PANEL_URL/api/application/servers",
    headers: {"Accept": "Application/vnd.pterodactyl.v1+json", "Authorization": "Bearer Admin/CLIENT_API_CODE"},
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
        title: Text("Pterodactly Panel"),
        backgroundColor: Colors.lightBlue,
      ),
      body: ListView.builder(
          itemCount: userData == null ? 0 : userData.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                   // CircleAvatar(
                      //backgroundImage: NetworkImage(userData[index]["avatar"]),
                    //),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("${userData[index]["attributes"]["name"]} - ${userData[index]["attributes"]["description"]}",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                      ),),
                    )             
                  ],
                ),
              ),
            );
          },
      ),
    );
  }
}

