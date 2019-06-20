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
import 'package:pterodactyl_app/page/company/deploys/client/home/circular_image.dart';
import 'package:pterodactyl_app/page/company/deploys/client/settings.dart';
import 'package:flutter/material.dart';
import 'package:pterodactyl_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:simple_gravatar/simple_gravatar.dart';

class MenuScreen extends StatelessWidget {
/*
  final gravatar = Gravatar('hello@example.com');
  final String imageUrl = gravatar.imageUrl(
    size: 100,
    defaultImage: GravatarImage.retro,
    rating: GravatarRating.pg,
    fileExtension: true,
  );
*/

  final String imageUrl =
      "https://s3-eu-west-1.amazonaws.com/tpd/logos/5aa8567e43efc80001d1319e/0x0.png";

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
                  NetworkImage(imageUrl),
                ),
              ),
              Text(
                'clientname',
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
          ListTile(
            onTap: () {
              launch(
                  'https://deploys.io/tickets/new?utm_source=ruben-app&utm_medium=app&utm_campaign=sidebar&utm_term=ticket&utm_content=sidebar');
            },
            leading: Icon(
              Icons.question_answer,
              color: Colors.white,
              size: 20,
            ),
            title: Text('Open Support Ticket',
                style: TextStyle(fontSize: 14, color: Colors.white)),
          ),
          ListTile(
            onTap: () {
              launch(
                  'https://deploys.io/client/?utm_source=ruben-app&utm_medium=app&utm_campaign=sidebar&utm_term=client&utm_content=sidebar');
            },
            leading: Icon(
              Icons.open_in_new,
              color: Colors.white,
              size: 20,
            ),
            title: Text('Client',
                style: TextStyle(fontSize: 14, color: Colors.white)),
          ),
          ListTile(
            onTap: () {
              launch(
                  'https://panel.deploys.io/?utm_source=ruben-app&utm_medium=app&utm_campaign=sidebar&utm_term=panel&utm_content=sidebar');
            },
            leading: Icon(
              Icons.open_in_new,
              color: Colors.white,
              size: 20,
            ),
            title: Text('Panel',
                style: TextStyle(fontSize: 14, color: Colors.white)),
          ),
          ListTile(
            onTap: () {
              launch(
                  'https://panel.deploys.io/?utm_source=ruben-app&utm_medium=app&utm_campaign=sidebar&utm_term=cpanel&utm_content=sidebar');
            },
            leading: Icon(
              Icons.open_in_new,
              color: Colors.white,
              size: 20,
            ),
            title: Text('cPanel',
                style: TextStyle(fontSize: 14, color: Colors.white)),
          ),
          ListTile(
            onTap: () {
              launch(
                  'https://panel.deploys.io/?utm_source=ruben-app&utm_medium=app&utm_campaign=sidebar&utm_term=website&utm_content=sidebar');
            },
            leading: Icon(
              Icons.open_in_new,
              color: Colors.white,
              size: 20,
            ),
            title: Text('Website',
                style: TextStyle(fontSize: 14, color: Colors.white)),
          ),
          Spacer(),
          ListTile(
            onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => DeploysSettingsList())),
            leading: Icon(
              Icons.settings,
              color: Colors.white,
              size: 20,
            ),
            title: Text('Settings',
                style: TextStyle(fontSize: 14, color: Colors.white)),
          ),
          ListTile(
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('company');
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/selecthost', (Route<dynamic> route) => false);
            },
            leading: Icon(
              Icons.lock_open,
              color: Colors.white,
              size: 20,
            ),
            title: Text(DemoLocalizations.of(context).trans('logout'),
                style: TextStyle(fontSize: 14, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
