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
        backgroundColor: globals.useDarkTheme ? null : Colors.transparent,
        leading: IconButton(
          color: globals.useDarkTheme ? Colors.white : Colors.black,
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back,
              color: globals.useDarkTheme ? Colors.white : Colors.black),
        ),
        title: Text('Console Logs',
            style: TextStyle(
                color: globals.useDarkTheme ? Colors.white : Colors.black,
                fontWeight: FontWeight.w700)),
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