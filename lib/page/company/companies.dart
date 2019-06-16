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
import 'package:pterodactyl_app/about.dart';

// CodersLight
import 'package:pterodactyl_app/page/company/coderslight/client/home.dart';
import 'package:pterodactyl_app/page/company/coderslight/client/login.dart';
import 'package:pterodactyl_app/page/company/coderslight/client/servers.dart';
import 'package:pterodactyl_app/page/company/coderslight/client/settings.dart';

// Deploys
import 'package:pterodactyl_app/page/company/deploys/client/home.dart';
import 'package:pterodactyl_app/page/company/deploys/client/login.dart';
import 'package:pterodactyl_app/page/company/deploys/client/servers.dart';
import 'package:pterodactyl_app/page/company/deploys/client/settings.dart';

/// Dart has no functionality to dynamically create class instances
/// Till then, we'll have to manually add every route.
Map companyRoutes() {
  Map c = <String, Map>{};
  c['coderslight'] = <String, WidgetBuilder>{
    '/coderslight/home': (BuildContext context) => new MyCodersLightHomePage(),
    '/coderslight/login': (BuildContext context) => new LoginCodersLightPage(),
    '/coderslight/servers': (BuildContext context) => new CodersLightServerListPage(),
    '/coderslight/about': (BuildContext context) => new AboutPage(),
    '/coderslight/settings': (BuildContext context) => new CodersLightSettingsList(),
  };
  c['deploys'] = <String, WidgetBuilder>{
    '/deploys/home': (BuildContext context) => new MyDeploysHomePage(),
    '/deploys/login': (BuildContext context) => new LoginDeploysPage(),
    '/deploys/servers': (BuildContext context) => new DeploysServerListPage(),
    '/deploys/about': (BuildContext context) => new AboutPage(),
    '/deploys/settings': (BuildContext context) => new DeploysSettingsList(),
  };
  c['minicenter'] = <String, WidgetBuilder>{
    '/minicenter/home': (BuildContext context) => new MyDeploysHomePage(),
    '/minicenter/login': (BuildContext context) => new LoginDeploysPage(),
    '/minicenter/servers': (BuildContext context) => new DeploysServerListPage(),
    '/minicenter/about': (BuildContext context) => new AboutPage(),
    '/minicenter/settings': (BuildContext context) => new DeploysSettingsList(),
  };
  c['planetnode'] = <String, WidgetBuilder>{
    '/planetnode/home': (BuildContext context) => new MyDeploysHomePage(),
    '/planetnode/login': (BuildContext context) => new LoginDeploysPage(),
    '/planetnode/servers': (BuildContext context) => new DeploysServerListPage(),
    '/planetnode/about': (BuildContext context) => new AboutPage(),
    '/planetnode/settings': (BuildContext context) => new DeploysSettingsList(),
  };
  c['revivenode'] = <String, WidgetBuilder>{
    '/revivenode/home': (BuildContext context) => new MyDeploysHomePage(),
    '/revivenode/login': (BuildContext context) => new LoginDeploysPage(),
    '/revivenode/servers': (BuildContext context) => new DeploysServerListPage(),
    '/revivenode/about': (BuildContext context) => new AboutPage(),
    '/revivenode/settings': (BuildContext context) => new DeploysSettingsList(),
  };
  return c;
}

//'/coderslight/home': (BuildContext context) => new MyCodersLightHomePage(),
//'/minicenter/home': (BuildContext context) => new MyMiniCenterHomePage(),
//'/planetnode/home': (BuildContext context) => new MyPlanetNodeHomePage(),
//'/revivenode/home': (BuildContext context) => new MyReviveNodeHomePage(),

List<String> companies() {
  List<String> companies = [];
  companies.addAll(
      ['deploys', 'coderslight', 'minicenter', 'planetnode', 'revivenode']);
  return companies;
}
