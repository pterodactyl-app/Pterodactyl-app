import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'page/auth/sponsorlist.dart';
import 'package:url_launcher/url_launcher.dart';

class SponsorPage extends StatefulWidget {
  @override
  _SponsorPageState createState() => new _SponsorPageState();
}

class _SponsorPageState extends State<SponsorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        backgroundColor: globals.isDarkTheme ? null : Colors.transparent,
        leading: IconButton(
          color: globals.isDarkTheme ? Colors.white : Colors.black,
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back,
              color: globals.isDarkTheme ? Colors.white : Colors.black),
        ),
        title: Text('Sponsor List',
            style: TextStyle(
                color: globals.isDarkTheme ? Colors.white : Colors.black,
                fontWeight: FontWeight.w700)),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: SponsorList.dummyData.length,
          itemBuilder: (context, index) {
            SponsorList _model = SponsorList.dummyData[index];
            return GestureDetector(
              child: Column(
                children: <Widget>[
                  Divider(
                    height: 12.0,
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 24.0,
                      backgroundImage: NetworkImage(_model.avatarUrl),
                    ),
                    title: Row(
                      children: <Widget>[
                        Text(_model.name),
                        SizedBox(
                          width: 16.0,
                        ),
                        Text(
                          _model.donation,
                          style: TextStyle(fontSize: 12.0),
                        ),
                      ],
                    ),
                    subtitle: Text(_model.message),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 14.0,
                    ),
                  ),
                ],
              ),
              onTap: () {
                launch(_model.link);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          launch('https://www.paypal.me/RDTalstra');
        },
        icon: Icon(Icons.add),
        label: Text('Donate'),
      ),
    );
  }
}
