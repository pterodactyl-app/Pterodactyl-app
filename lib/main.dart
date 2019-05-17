import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
import 'page/admin/adminsettings.dart';
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
    String data = await rootBundle
        .loadString('assets/lang/${this.locale.languageCode}.json');
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
        'zh'
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

    print("Load ${locale.languageCode}");

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
                  globals.isDarkTheme ? Brightness.dark : Brightness.light,
              brightness: brightness,
            ),
        themedWidgetBuilder: (context, theme) {
          return new MaterialApp(
            supportedLocales: [
              const Locale('en', 'US'),
              const Locale('fr', 'FR'),
              const Locale('de', 'DE'),
              const Locale('dk', 'DK'),
              const Locale('no', 'NO'),
              const Locale('nl', 'NL'),
              const Locale('se', 'SE'),
              const Locale('it', 'IT'),
              const Locale('pl', 'PL'),
              const Locale('zh', 'CN'), // 'zh_CN'
            ],
            localizationsDelegates: [
              const DemoLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate
            ],
            localeResolutionCallback:
                (Locale locale, Iterable<Locale> supportedLocales) {
              for (Locale supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale.languageCode ||
                    supportedLocale.countryCode == locale.countryCode) {
                  return supportedLocale;
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
              '/adminsettings': (BuildContext context) => new AdminSettingsList(),
              
            },
          );
        });
  }
}

void main() {
  runApp(new MyApp());
}
