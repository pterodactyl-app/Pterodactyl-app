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
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:pterodactyl_app/page/auth/shared_preferences_helper.dart';
import 'package:pterodactyl_app/main.dart';
import 'package:pterodactyl_app/globals.dart' as globals;
import 'package:pterodactyl_app/page/company/deploys/client/actionserver.dart';
import 'package:pterodactyl_app/page/company/deploys/client/home/menu_page.dart';
import 'package:pterodactyl_app/page/company/deploys/client/home/zoom_scaffold.dart';



class MyDeploysHomePage extends StatefulWidget {
  MyDeploysHomePage({Key key}) : super(key: key);

  @override
  _MyDeploysHomePageState createState() => _MyDeploysHomePageState();
}

class _MyDeploysHomePageState extends State<MyDeploysHomePage> {


  @override
  Widget build(BuildContext context) {
    return new ZoomScaffold(
      menuScreen: MenuScreen(),             
    );
  }
}
