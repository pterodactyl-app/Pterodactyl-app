/*
* Copyright 2018-2019 Ruben Talstra and Yvan Watchman
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
import 'package:pterodactyl_app/models/settings.dart';
import 'package:pterodactyl_app/page/client/home/circular_image.dart';
import 'package:pterodactyl_app/page/client/settings.dart';
import 'package:flutter/material.dart';
import 'package:pterodactyl_app/models/settings.dart';
import 'package:pterodactyl_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:simple_gravatar/simple_gravatar.dart';
import 'package:pterodactyl_app/page/auth/shared_preferences_helper.dart';


class MenuScreen extends StatelessWidget {


  String getGravatarUrl() {
    Gravatar gravatar = new Gravatar('rubentalstra1211@outlook.com');
    return gravatar.imageUrl(
      size: 64,
      defaultImage: GravatarImage.retro,
      rating: GravatarRating.pg,
      fileExtension: true,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment(0.8, 0.0), // 10% of the width, so there are ten blinds.
      colors: [const Color(0xFF5E72E4), const Color(0xFF825EE4)], // whitish to gray
    ),
  ),
      padding: EdgeInsets.only(
          top: 62,
          left: 32,
          bottom: 8,
          right: MediaQuery.of(context).size.width / 2.9),
      
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: CircularImage(
            NetworkImage(getGravatarUrl()),
          ),
              ),
              Text(
                'name',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              )
            ],
          ),
          Spacer(),
          ListTile(
            onTap: () {},
            leading: Icon(
              Icons.home,
              color: Colors.white,
              size: 20,
            ),
            title: Text('Home',
                style: TextStyle(fontSize: 14, color: Colors.white)),
          ),

          Spacer(),
          ListTile(
            onTap: () {
                var route = new MaterialPageRoute(
                  builder: (BuildContext context) => new SettingsList(
                      settings: SettingsInfo(
                          servers: 1,
                          subServer: 4,
                          schedules: 2,
                          name: 'name',
                          email: 'rubentalstra1211@outlook.com')),
                );
                Navigator.of(context).push(route);
              },
            leading: Icon(
              Icons.settings,
              color: Colors.white,
              size: 20,
            ),
            title: Text('Settings',
                style: TextStyle(fontSize: 14, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
