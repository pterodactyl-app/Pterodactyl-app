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
import 'package:pterodactyl_app/page/company/deploys/client/home.dart';

Map companyRoutes() {
  Map c = <String, Map>{};
  companies().forEach((f) => {
        c[f] = <String, WidgetBuilder>{
          '/' + f + '/home': (BuildContext context) => new MyDeploysHomePage() // Todo: https://stackoverflow.com/a/14705238
        }
      });
  return c;
}

List<String> companies() {
  List<String> companies = [];
  companies.add('deploys');
  return companies;
}
