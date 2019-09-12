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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pterodactyl_app/main.dart';
import 'package:pterodactyl_app/models/server.dart';
import 'package:pterodactyl_app/models/globals.dart' as globals;
import '../actionserver.dart';

import 'dart:io';

import 'package:pterodactyl_app/page/auth/check_update.dart';



class ZoomScaffold extends StatefulWidget {
  final Widget menuScreen;
  final Layout contentScreen;

  ZoomScaffold({
    this.menuScreen,
    this.contentScreen,
  });

  @override
  _ZoomScaffoldState createState() => new _ZoomScaffoldState();
}

class _ZoomScaffoldState extends State<ZoomScaffold>
    with TickerProviderStateMixin {
  MenuController menuController;
  Curve scaleDownCurve = new Interval(0.0, 0.3, curve: Curves.easeOut);
  Curve scaleUpCurve = new Interval(0.0, 1.0, curve: Curves.easeOut);
  Curve slideOutCurve = new Interval(0.0, 1.0, curve: Curves.easeOut);
  Curve slideInCurve = new Interval(0.0, 1.0, curve: Curves.easeOut);


  Map data;
  List userData;
  int userTotalServers = 0;
  String name, email;

  final _searchForm = TextEditingController();
  dynamic appBarTitle;
  Icon icon = Icon(Icons.search);

  Future getData({String search: ''}) async {
    String _api = await SharedPreferencesHelper.getString("apiKey");
    String _url = await SharedPreferencesHelper.getString("panelUrl");
    String _https = await SharedPreferencesHelper.getString("https");
    http.Response response = await http.get(
      "$_https$_url/api/client",
      headers: {
        "Accept": "Application/vnd.pterodactyl.v1+json",
        "Authorization": "Bearer $_api"
      },
    );
    data = await json.decode(response.body);

      name = await SharedPreferencesHelper.getString('first_name')
          + ' ' +await SharedPreferencesHelper.getString('last_name');
      email = await SharedPreferencesHelper.getString('email');
    setState(() {
      userData = [];
      if (search.isNotEmpty) {
        data['data'].forEach((v) {
          if (v['attributes']['name'].toString().contains(search)) {
            userData.add(v);
          }
        });
      } else {
        userData = data["data"];
      }
    });
  }


  @override
  void initState() {
    try {
      versionCheck(context);
    } catch (e) {
      print(e);
    }
    super.initState();
    menuController = new MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));
    getData();
  }

  @override
  void dispose() {
    menuController.dispose();
    super.dispose();
  }

  createContentDisplay() {
    return zoomAndSlideContent(new Container(
      child: new Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: globals.useDarkTheme ? null : Colors.transparent,
        leading: IconButton(
            color: globals.useDarkTheme ? Colors.white : Colors.black,
            onPressed: () => menuController.toggle(),
            icon: Icon(Icons.menu),
          ),
        title: (this.appBarTitle != null
            ? this.appBarTitle
            : new Text(DemoLocalizations.of(context).trans('server_list'))),
        actions: <Widget>[
          new IconButton(
              icon: this.icon,
              onPressed: () {
                setState(() {
                  if (this.icon.icon == Icons.search) {
                    this.icon = Icon(Icons.close);
                    appBarTitle = new TextField(
                      controller: _searchForm,
                      onChanged: (s) {
                        getData(search: s);
                      },
                      style: new TextStyle(
                          color: globals.useDarkTheme
                              ? Colors.white
                              : Colors.black),
                      decoration: new InputDecoration(
                          prefixIcon: Icon(Icons.search,
                              color: globals.useDarkTheme
                                  ? Colors.white
                                  : Colors.black),
                          hintText: DemoLocalizations.of(context).trans('search'),
                          hintStyle: new TextStyle(
                              color: globals.useDarkTheme
                                  ? Colors.white
                                  : Colors.black)),
                    );
                  } else {
                    getData();
                    this.icon = Icon(Icons.search);
                    appBarTitle = new Text(
                        DemoLocalizations.of(context).trans('server_list'));
                  }
                });
              })
        ],
      ),
      body: ListView.builder(
        itemCount: userData == null ? 0 : userData.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
              child: Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Stack(
              children: <Widget>[
                /// Item card
                Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                      width: 400,
                      height: 250,
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 24.0),
                            child: Material(
                              elevation: 5.0,
                              borderRadius: BorderRadius.circular(24.0),
                              shadowColor: globals.useDarkTheme
                                  ? Colors.blueGrey
                                  : Color(0x802196F3),
                              child: InkWell(
                                onTap: () {
                                  var route = new MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        new ActionServerPage(
                                            server: Server(
                                                id: userData[index]
                                                        ["attributes"]
                                                    ["identifier"],
                                                name: userData[index]
                                                    ["attributes"]["name"])),
                                  );
                                  Navigator.of(context).push(route);
                                },
                                child: Container(
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        /// Title and rating
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                                '${userData[index]["attributes"]["description"]}',
                                                style: TextStyle(
                                                    color: Colors.blueAccent)),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                    '${userData[index]["attributes"]["name"]}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 24.0)),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 4.0),
                                                child: Material(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  color: Color(0Xffe6f6ec),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child:
                                                        Row(children: <Widget>[
                                                      Icon((FontAwesomeIcons.microchip),
                                                          color: Color(
                                                              0Xff10C254)),
                                                      Text('   CPU 100%',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: Color(
                                                                  0Xff10C254))),
                                                    ]),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 4.0),
                                                child: Material(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  color: Color(0Xffe6f6ec),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Row(
                                                        children: <Widget>[
                                                          Icon((FontAwesomeIcons.memory),
                                                              color: Color(
                                                                  0Xff10C254)),
                                                          Text(
                                                              '   ' +
                                                                  DemoLocalizations.of(
                                                                          context)
                                                                      .trans(
                                                                          'total_ram') +
                                                                  " ${userData[index]['attributes']['limits']['memory'] == 0 ? '∞' : '${userData[index]['attributes']['limits']['memory']} MB'}",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: Color(
                                                                      0Xff10C254))),
                                                        ]),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 4.0),
                                              child: Material(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                color: Color(0Xffe6f6ec),
                                                child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Row(children: <Widget>[
                                                    Icon((FontAwesomeIcons.hdd),
                                                        color:
                                                            Color(0Xff10C254)),
                                                    Text(
                                                        '   ' +
                                                            DemoLocalizations
                                                                    .of(context)
                                                                .trans(
                                                                    'total_disk') +
                                                            " ${userData[index]['attributes']['limits']['disk'] == 0 ? '∞' : '${userData[index]['attributes']['limits']['disk']} MB'}",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: Color(
                                                                0Xff10C254))),
                                                  ]),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        new Container(
                                          alignment: Alignment.bottomRight,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            child: Material(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              color: Color(0Xffe6f6ec),
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text('STATE (on, off)',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color:
                                                            Color(0Xff10C254))),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      )),
                ),
              ],
            ),
          ));
        },
      ),
    ),
    ));
  }

  zoomAndSlideContent(Widget content) {
    var slidePercent, scalePercent;
    switch (menuController.state) {
      case MenuState.closed:
        slidePercent = 0.0;
        scalePercent = 0.0;
        break;
      case MenuState.open:
        slidePercent = 1.0;
        scalePercent = 1.0;
        break;
      case MenuState.opening:
        slidePercent = slideOutCurve.transform(menuController.percentOpen);
        scalePercent = scaleDownCurve.transform(menuController.percentOpen);
        break;
      case MenuState.closing:
        slidePercent = slideInCurve.transform(menuController.percentOpen);
        scalePercent = scaleUpCurve.transform(menuController.percentOpen);
        break;
    }

    final slideAmount = 275.0 * slidePercent;
    final contentScale = 1.0 - (0.2 * scalePercent);
    final cornerRadius = 16.0 * menuController.percentOpen;

    return new Transform(
      transform: new Matrix4.translationValues(slideAmount, 0.0, 0.0)
        ..scale(contentScale, contentScale),
      alignment: Alignment.centerLeft,
      child: new Container(
        decoration: new BoxDecoration(
          boxShadow: [
            new BoxShadow(
              color: Colors.black12,
              offset: const Offset(0.0, 5.0),
              blurRadius: 15.0,
              spreadRadius: 10.0,
            ),
          ],
        ),
        child: new ClipRRect(
            borderRadius: new BorderRadius.circular(cornerRadius),
            child: content),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: Scaffold(
            body: widget.menuScreen,
          ),
        ),
        createContentDisplay()
      ],
    );
  }
}

class ZoomScaffoldMenuController extends StatefulWidget {
  final ZoomScaffoldBuilder builder;

  ZoomScaffoldMenuController({
    this.builder,
  });

  @override
  ZoomScaffoldMenuControllerState createState() {
    return new ZoomScaffoldMenuControllerState();
  }
}

class ZoomScaffoldMenuControllerState
    extends State<ZoomScaffoldMenuController> {
  MenuController menuController;

  @override
  void initState() {
    super.initState();

    menuController = getMenuController(context);
    menuController.addListener(_onMenuControllerChange);
  }

  @override
  void dispose() {
    menuController.removeListener(_onMenuControllerChange);
    super.dispose();
  }

  getMenuController(BuildContext context) {
    final scaffoldState =
        context.ancestorStateOfType(new TypeMatcher<_ZoomScaffoldState>())
            as _ZoomScaffoldState;
    return scaffoldState.menuController;
  }

  _onMenuControllerChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, getMenuController(context));
  }
}

typedef Widget ZoomScaffoldBuilder(
    BuildContext context, MenuController menuController);

class Layout {
  final WidgetBuilder contentBuilder;

  Layout({
    this.contentBuilder,
  });
}

class MenuController extends ChangeNotifier {
  final TickerProvider vsync;
  final AnimationController _animationController;
  MenuState state = MenuState.closed;

  MenuController({
    this.vsync,
  }) : _animationController = new AnimationController(vsync: vsync) {
    _animationController
      ..duration = const Duration(milliseconds: 250)
      ..addListener(() {
        notifyListeners();
      })
      ..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.forward:
            state = MenuState.opening;
            break;
          case AnimationStatus.reverse:
            state = MenuState.closing;
            break;
          case AnimationStatus.completed:
            state = MenuState.open;
            break;
          case AnimationStatus.dismissed:
            state = MenuState.closed;
            break;
        }
        notifyListeners();
      });
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  get percentOpen {
    return _animationController.value;
  }

  open() {
    _animationController.forward();
  }

  close() {
    _animationController.reverse();
  }

  toggle() {
    if (state == MenuState.open) {
      close();
    } else if (state == MenuState.closed) {
      open();
    }
  }
}

enum MenuState {
  closed,
  opening,
  open,
  closing,
}
