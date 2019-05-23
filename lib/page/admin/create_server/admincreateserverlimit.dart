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
        backgroundColor: globals.isDarkTheme ? null : Colors.transparent,
        leading: IconButton(
          color: globals.isDarkTheme ? Colors.white : Colors.black,
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back,
              color: globals.isDarkTheme ? Colors.white : Colors.black),
        ),
        title: Text('add server limits 4/8',
            style: TextStyle(
                color: globals.isDarkTheme ? Colors.white : Colors.black,
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
                  labelText: "memory limit",
                ),
              ),
            ),
            SizedBox(height: 12.0),
            AccentColorOverride(
              color: Color(0xFFC5032B),
              child: TextField(
                controller: _swapController,
                decoration: InputDecoration(
                  labelText: "swap",
                ),
              ),
            ),
            SizedBox(height: 12.0),
            AccentColorOverride(
              color: Color(0xFFC5032B),
              child: TextField(
                controller: _diskController,
                decoration: InputDecoration(
                  labelText: "disk limit",
                ),
              ),
            ),
            SizedBox(height: 12.0),
            AccentColorOverride(
              color: Color(0xFFC5032B),
              child: TextField(
                controller: _ioController,
                decoration: InputDecoration(
                  labelText: "io",
                ),
              ),
            ),
            SizedBox(height: 12.0),
            AccentColorOverride(
              color: Color(0xFFC5032B),
              child: TextField(
                controller: _cpuController,
                decoration: InputDecoration(
                  labelText: "cpu limit",
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
                  child: Text('Next'),
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
