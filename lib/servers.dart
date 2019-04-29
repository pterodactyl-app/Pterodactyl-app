import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'main.dart';

class ServerListPage extends StatefulWidget
{

ServerListPage({@required this.api, this.url});
final api, url;

  @override
  _ServerListPageState createState() => _ServerListPageState();
}

class _ServerListPageState extends State<ServerListPage>
{



  Map data;
  List userData;

  Future getData() async {
    http.Response response = await http.get("https://${widget.url}/api/application/servers",
    headers: {"Accept": "Application/vnd.pterodactyl.v1+json", "Authorization": "Bearer ${widget.api}"},
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
  Widget build(BuildContext context)
  {          
    return Scaffold
    (
      appBar: AppBar
      (
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton
        (
          color: Colors.black,
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text(DemoLocalizations.of(context).trans('server_list'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
        // actions: <Widget>
        // [
        //   Container
        //   (
        //     margin: EdgeInsets.only(right: 8.0),
        //     child: Row
        //     (
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       children: <Widget>
        //       [
        //         Text('beclothed.com', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14.0)),
        //         Icon(Icons.arrow_drop_down, color: Colors.black54)
        //       ],
        //     ),
        //   )
        // ],
      ),
      body: ListView.builder(
          itemCount: userData == null ? 0 : userData.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(          
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(                
                  children: <Widget>[
                  Container
                  (
                    margin: EdgeInsets.only(top: 16.0),
                    child: Material
                    (
                      elevation: 14.0,
                      borderRadius: BorderRadius.circular(12.0),
                      shadowColor: Color(0x802196F3),
                      color: Colors.white,
                      child: InkWell
                      (
                        //onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ItemReviewsPage())),
                        child: Padding
                        (
                          padding: EdgeInsets.all(30.0),
                          child: Column
                          (
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>
                            [
                              /// Title and rating
                              Column
                              (
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>
                                [
                                  Text('${userData[index]["attributes"]["description"]}', style: TextStyle(color: Colors.blueAccent)),
                                  Row
                                  (
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>
                                    [
                                      Text('${userData[index]["attributes"]["name"]}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18.0)),                                     
                                    ],
                                  ),
                                ],
                              ),
                              /// Infos
                              Row
                              (
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>
                                [
                                  Text(DemoLocalizations.of(context).trans('total_disk'), style: TextStyle()),

                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                                    child: Material
                                    (
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: Colors.green,
                                      child: Padding
                                      (
                                        padding: EdgeInsets.all(4.0),
                                        child: Text('${userData[index]["attributes"]["limits"]["disk"]} MB', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
                                      ),
                                    ),
                                  ),
                                  Text(DemoLocalizations.of(context).trans('total_ram'), style: TextStyle()),

                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                                    child: Material
                                    (
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: Colors.green,
                                      child: Padding
                                      (
                                        padding: EdgeInsets.all(4.0),
                                        child: Text('${userData[index]["attributes"]["limits"]["memory"]} MB', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
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
                  ],
                ),
              ),
            onTap: () {
              Navigator.push( context,
  MaterialPageRoute(
    builder: (context) => SecondPage(url: widget.url,api: widget.api,id: userData[index]["attributes"]["identifier"],name: userData[index]["attributes"]["name"])
  )
);
      },         
            );
          },
      ),
    );
  }
}


class SecondPage extends StatelessWidget {
  
    
SecondPage({@required this.id, this.name, this.api, this.url});
final id, name, api, url;


@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton
        (
          color: Colors.black,
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text('$name', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
        // actions: <Widget>
        // [
        //   Container
        //   (
        //     margin: EdgeInsets.only(right: 8.0),
        //     child: Row
        //     (
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       children: <Widget>
        //       [
        //         Text('beclothed.com', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14.0)),
        //         Icon(Icons.arrow_drop_down, color: Colors.black54)
        //       ],
        //     ),
        //   )
        // ],
      ),
      body: Center(
        child: new Text("$id, $api, $url", style: new TextStyle(fontSize: 35.0)),
      ),
    );
  }
}
