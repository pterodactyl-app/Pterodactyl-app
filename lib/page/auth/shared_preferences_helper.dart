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
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {

  static Future<bool> setString(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(key, value);
  }

  static Future<String> getString(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(key) ?? '';
  }

  static remove(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove(key);
  }
}
