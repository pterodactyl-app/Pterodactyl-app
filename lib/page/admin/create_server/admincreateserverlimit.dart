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
import 'package:flutter/material.dart';
import '../../../globals.dart' as globals;
import '../../../main.dart';
import 'admincreateserveregg.dart';
import 'admincreateserverlocations.dart';

class Limit {
  final String nestid,
      userid,
      eggid,
      dockerimage,
      startup,
      limitmemory,
      limitswap,
      disklimit,
      iolimit,
      cpulimit,
      servername;
  const Limit(
      {this.nestid,
      this.userid,
      this.eggid,
      this.dockerimage,
      this.startup,
      this.limitmemory,
      this.limitswap,
      this.disklimit,
      this.iolimit,
      this.cpulimit,
      this.servername});
}

class AdminCreateServerLimitPage extends StatefulWidget {
  AdminCreateServerLimitPage({Key key, this.server}) : super(key: key);
  final Egg server;

  @override
  _AdminCreateServerLimitPageState createState() =>
      _AdminCreateServerLimitPageState();
}

class _AdminCreateServerLimitPageState
    extends State<AdminCreateServerLimitPage> {
  final _memoryController = TextEditingController();
  final _swapController = TextEditingController();
  final _diskController = TextEditingController();
  final _ioController = TextEditingController();
  final _cpuController = TextEditingController();

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
        title: Text(DemoLocalizations.of(context).trans('admin_create_server_4_8'),
            style: TextStyle(
                color: globals.useDarkTheme ? Colors.white : Colors.black,
                fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 20.0),
            AccentColorOverride(
              color: Color(0xFFC5032B),
              child: TextField(
                controller: _memoryController,
                decoration: InputDecoration(
                  labelText: DemoLocalizations.of(context).trans('memory_limit'),
                ),
              ),
            ),
            SizedBox(height: 12.0),
            AccentColorOverride(
              color: Color(0xFFC5032B),
              child: TextField(
                controller: _swapController,
                decoration: InputDecoration(
                  labelText: DemoLocalizations.of(context).trans('swap_limit'),
                ),
              ),
            ),
            SizedBox(height: 12.0),
            AccentColorOverride(
              color: Color(0xFFC5032B),
              child: TextField(
                controller: _diskController,
                decoration: InputDecoration(
                  labelText: DemoLocalizations.of(context).trans('disk_limit'),
                ),
              ),
            ),
            SizedBox(height: 12.0),
            AccentColorOverride(
              color: Color(0xFFC5032B),
              child: TextField(
                controller: _ioController,
                decoration: InputDecoration(
                  labelText: DemoLocalizations.of(context).trans('io_limit'),
                ),
              ),
            ),
            SizedBox(height: 12.0),
            AccentColorOverride(
              color: Color(0xFFC5032B),
              child: TextField(
                controller: _cpuController,
                decoration: InputDecoration(
                  labelText: DemoLocalizations.of(context).trans('cpu_limit'),
                ),
              ),
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text(DemoLocalizations.of(context).trans('clear')),
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  ),
                  onPressed: () {
                    _memoryController.clear();
                    _swapController.clear();
                    _diskController.clear();
                    _ioController.clear();
                    _cpuController.clear();
                  },
                ),
                RaisedButton(
                  child: Text(DemoLocalizations.of(context).trans('next')),
                  elevation: 8.0,
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  ),
                  onPressed: () {
                    var route = new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          new AdminCreateServerLocationsPage(
                              server: Limit(
                            limitmemory: _memoryController.text,
                            limitswap: _swapController.text,
                            disklimit: _diskController.text,
                            iolimit: _ioController.text,
                            cpulimit: _cpuController.text,
                            userid: widget.server.userid,
                            nestid: widget.server.nestid,
                            eggid: widget.server.eggid,
                            dockerimage: widget.server.dockerimage,
                            startup: widget.server.startup,
                            servername: widget.server.servername,
                          )),
                    );
                    Navigator.of(context).push(route);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AccentColorOverride extends StatelessWidget {
  const AccentColorOverride({Key key, this.color, this.child})
      : super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      child: child,
      data: Theme.of(context).copyWith(
        accentColor: color,
        brightness: Brightness.dark,
      ),
    );
  }
}
