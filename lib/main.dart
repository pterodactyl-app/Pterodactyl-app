import 'dart:async';
import 'dart:convert' show jsonDecode;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp (new MaterialApp(
  home: new HomePage(),
));

class HomePage extends StatefulWidget{
  @override
  HomePageState createState()=> new HomePageState();

}

class HomePageState extends State<HomePage> {
  final String url = "https://mijn.xenocontrol.nl/api/application/servers";
  List data;

  @override
  void initState(){
    super.initState();
    this.getJsonData();
  }

  Future<String> getJsonData() async{
    var response = await http.get(
      //Encode the url
      Uri.encodeFull(url),
      //only accept json response
      headers: {"Accept": "Application/vnd.pterodactyl.v1+json","Authorization": "Bearer HMP9cfikXllaSBtxTAIAN24VbUhSJG8CBqtq87Lp5mFUSw3v"}
    );

    print(response.body);

    setState(() {
     var convertDataToJson = jsonDecode(response.body);
     data = convertDataToJson['data'];
    });

    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Ptero Panel"),  
      ),
      body: new ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index){
          return new Container(
            child: new Center(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  new Card(
                    child: new Container(
                      child: new Text(data[index]['name']),
                      padding: const EdgeInsets.all(20.0)),
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