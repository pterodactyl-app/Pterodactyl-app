import 'package:flutter/material.dart';
import '../auth/shared_preferences_helper.dart';
import 'package:http/http.dart' as http;
import '../../globals.dart' as globals;
import 'dart:async';
import 'dart:convert';
import '../../main.dart';

class ConsoleLogs extends StatefulWidget {
  @override
  _ConsoleLogsState createState() => new _ConsoleLogsState();
}

class _ConsoleLogsState extends State<ConsoleLogs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: globals.isDarkTheme ? null : Colors.transparent,
        leading: IconButton(
          color: globals.isDarkTheme ? Colors.white : Colors.black,
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back,
              color: globals.isDarkTheme ? Colors.white : Colors.black),
        ),
        title: Text('Console Logs',
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
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
              Column(
                children: <Widget>[
                  _buildListRow(),
                ],
              )
            ]),
          )
        ],
      ),
    );
  }

    Widget _buildListRow() {
    return Column(
      children: <Widget>[
        ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          itemBuilder: (context, logs) {
            return Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text('Nested list item $logs'),
            );
          },
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
        )
      ],
    );
  }
}