import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import '../../globals.dart' as globals;
import '../../main.dart';
import 'adminusers.dart';

class AdminUserInfoPage extends StatefulWidget {
  AdminUserInfoPage({Key key, this.server}) : super(key: key);
  final Admin server;

  @override
  _AdminUserInfoPageState createState() => _AdminUserInfoPageState();
}

class _AdminUserInfoPageState extends State<AdminUserInfoPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: globals.isDarkTheme ? null : Colors.transparent,
          leading: IconButton(
            color: globals.isDarkTheme ? Colors.white : Colors.black,
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back,
              color: globals.isDarkTheme ? Colors.white : Colors.black,
            ),
          ),
          title: Text('${widget.server.username}',
              style: TextStyle(
                  color: globals.isDarkTheme ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w700)),
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
                          Text('${widget.server.firstname} ${widget.server.lastname}',
                              style: TextStyle(
                                  color: globals.isDarkTheme
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18.0))
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
                          Text('${widget.server.email}',
                              style: TextStyle(
                                  color: globals.isDarkTheme
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18.0))
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
                          Text('uuid: ${widget.server.uuid}',
                              style: TextStyle(
                                  color: globals.isDarkTheme
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15.0))
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
                          Text('ID: ${widget.server.adminid.toString()}',
                              style: TextStyle(
                                  color: globals.isDarkTheme
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18.0))
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
                          Text('Language: ${widget.server.language}',
                              style: TextStyle(
                                  color: globals.isDarkTheme
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18.0))
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
                          Text('Root Admin: ${widget.server.rootadmin}',
                              style: TextStyle(
                                  color: globals.isDarkTheme
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18.0))
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
                          Text('2FA: ${widget.server.fa}',
                              style: TextStyle(
                                  color: globals.isDarkTheme
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18.0))
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
                          Text('Created at: ${widget.server.createdat}',
                              style: TextStyle(
                                  color: globals.isDarkTheme
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18.0))
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
                          Text('Updated at: ${widget.server.updatedat}',
                              style: TextStyle(
                                  color: globals.isDarkTheme
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18.0))
                        ],
                      )
                    ]),
              ),
              //onTap: () {},
            ),
          ],
          staggeredTiles: [
            StaggeredTile.extent(2, 110.0),
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
        shadowColor: globals.isDarkTheme ? Colors.grey[700] : Color(0x802196F3),
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
