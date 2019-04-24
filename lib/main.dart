import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class User {
  final String api, url, id;
  const User({
     this.api,
     this.url,
     this.id,
  });
}


class Home extends StatefulWidget {

@override
_HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
//TextEditingController is controller for editable text fields.
//It's role is to update itself and notify listeners whenever it's associated
//textfield changes.
var _apiController = new TextEditingController();
var _urlController = new TextEditingController();

@override
Widget build(BuildContext context) {
return new Scaffold(
resizeToAvoidBottomPadding: false,
appBar: new AppBar(
title: new Text('Pterodactly Panel Login'),
),
body: new Container(
child: new Center(
child: Column(
children: <Widget>[
Padding(
child: new Text(
'Type and Pass Data',
style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),
textAlign: TextAlign.center,
),
padding: EdgeInsets.only(bottom: 20.0),
),
TextFormField(
decoration: InputDecoration(labelText: 'api'),
controller: _apiController,
),

TextFormField(
controller: _urlController,
decoration: InputDecoration(labelText: 'url'),
),

new RaisedButton(

onPressed: () {
// A MaterialPageRoute is a  modal route that replaces the entire screen
// with a platform-adaptive transition.
var route = new MaterialPageRoute(
builder: (BuildContext context) =>
new SecondPage(
value: User(
api: _apiController.text,
url: _urlController.text
)
),
);
Navigator.of(context).push(route);
},

child: new Text('Click to login'),
),

],
),
),
),
);
}
}


class SecondPage extends StatefulWidget {


final User value;
SecondPage({Key key, this.value}) : super(key: key);
@override
_SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  
  Map data;
  List userData;

  Future getData() async {
    http.Response response = await http.get("https://${widget.value.url}/api/application/servers",
    headers: {"Accept": "Application/vnd.pterodactyl.v1+json", "Authorization": "Bearer ${widget.value.api}"},
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
return new Scaffold(
appBar: new AppBar(
  title: new Text('Server List')
  ),
      body: ListView.builder(
          itemCount: userData == null ? 0 : userData.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(          
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(                
                  children: <Widget>[                    
                    new Padding(
                      padding: new EdgeInsets.all(7.0),
                      child: new Icon(Icons.device_hub),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("${userData[index]["attributes"]["name"]} - ${userData[index]["attributes"]["description"]}",
                      style: TextStyle(
                        fontSize: 15.0,
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



//dont touch this//
class MyApp extends StatelessWidget {
Widget build(BuildContext context) {
return new MaterialApp(
debugShowCheckedModeBanner: false,
home: new Scaffold(
body: new Home(),
),
);
}
}
void main() => runApp(new MyApp());
//-------------//
