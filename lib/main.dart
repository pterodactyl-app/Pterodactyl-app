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
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'globals.dart' as globals;
import 'dart:async';
import 'dart:convert';
import 'page/auth/auth.dart';

import 'page/client/login.dart';
import 'page/client/home.dart';
import 'page/client/servers.dart';

import 'page/client/settings.dart';
import 'about.dart';

import 'page/admin/adminlogin.dart';
import 'page/admin/adminhome.dart';
//import 'page/admin/adminservers.dart';
//import 'page/admin/adminnodes.dart';
//import 'page/admin/adminallocations.dart';
//import 'page/admin/adminactionserver.dart';
//import 'page/admin/adminactionnodes.dart';

class DemoLocalizations {
  DemoLocalizations(this.locale);

  final Locale locale;

  static DemoLocalizations of(BuildContext context) {
    return Localizations.of<DemoLocalizations>(context, DemoLocalizations);
  }

  Map<String, String> _sentences;

  Future<bool> load() async {
    String data = await rootBundle.loadString(
        'assets/lang/${this.locale.languageCode}_${this.locale.countryCode}.json');
    Map<String, dynamic> _result = json.decode(data);

    this._sentences = new Map();
    _result.forEach((String key, dynamic value) {
      this._sentences[key] = value.toString();
    });

    return true;
  }

  String trans(String key) {
    return this._sentences[key];
  }
}

class DemoLocalizationsDelegate
    extends LocalizationsDelegate<DemoLocalizations> {
  const DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => [
        'en',
        'fr',
        'de',
        'nl',
        'dk',
        'no',
        'pl',
        'it',
        'se',
        'zh',
        'si',
        'es',
        'id'
      ].contains(locale.languageCode);

  @override
  Future<DemoLocalizations> load(Locale locale) async {
// flutter 0.11 localeResolutionCallback fix, change it if fixed
    if (locale == null || isSupported(locale) == false) {
      debugPrint('*app_locale_delegate* fallback to locale ');

      locale = Locale('en', 'US'); // fallback to default language
    }

    DemoLocalizations localizations = new DemoLocalizations(locale);
    await localizations.load();

    print("Load ${locale.languageCode}_${locale.countryCode}");

    return localizations;
  }

  @override
  bool shouldReload(DemoLocalizationsDelegate old) => false;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => ThemeData(
              primarySwatch: Colors.blue,
              primaryColorBrightness:
                  globals.useDarkTheme ? Brightness.dark : Brightness.light,
              brightness: brightness,
            ),
        themedWidgetBuilder: (context, theme) {
          return new MaterialApp(
            navigatorKey: key,
            supportedLocales: [
              const Locale('en', 'US'),
              const Locale('en', 'UK'),
              const Locale('fr', 'FR'),
              const Locale('de', 'DE'),
              const Locale('dk', 'DK'),
              const Locale('no', 'NO'),
              const Locale('nl', 'NL'),
              const Locale('se', 'SE'),
              const Locale('it', 'IT'),
              const Locale('pl', 'PL'),
              const Locale.fromSubtags(
                  languageCode: 'zh',
                  scriptCode: 'Hans',
                  countryCode: 'CN'), // 'zh_Hans_CN'
              const Locale.fromSubtags(
                  languageCode: 'zh',
                  scriptCode: 'Hant',
                  countryCode: 'TW'), // 'zh_Hant_TW'
              const Locale('si', 'SI'),
              const Locale('es', 'ES'),
              const Locale('id', 'ID'),
              const Locale('he', 'IL'),
            ],
            localizationsDelegates: [
              const DemoLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate
            ],
            localeResolutionCallback:
                (Locale locale, Iterable<Locale> supportedLocales) {
              for (Locale supportedLocale in supportedLocales) {
                if (!Platform.isIOS) {
                  if (supportedLocale.languageCode == locale.languageCode ||
                      supportedLocale.countryCode == locale.countryCode) {
                    return supportedLocale;
                  }
                }
              }

              return supportedLocales.first;
            },
            title: 'PTERODACTYL APP',
            debugShowCheckedModeBanner: false,
            theme: theme,
            home: new Splash(),
            routes: <String, WidgetBuilder>{
              '/home': (BuildContext context) => new MyHomePage(),
              '/login': (BuildContext context) => new LoginPage(),
              '/servers': (BuildContext context) => new ServerListPage(),
              '/about': (BuildContext context) => new AboutPage(),
              '/settings': (BuildContext context) => new SettingsList(),
              '/adminhome': (BuildContext context) => new AdminHomePage(),
              '/adminlogin': (BuildContext context) => new AdminLoginPage(),
            },
          );
        });
  }
}

Future main() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  globals.useDarkTheme = (prefs.getBool('Value') ?? false);
  runApp(new MyApp());
}
