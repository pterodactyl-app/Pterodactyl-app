/*
* Copyright 2018-2019 HoneyBadger9
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

import 'package:flutter/material.dart' show AlertDialog, AlwaysScrollableScrollPhysics, AppBar, AsyncSnapshot, BoxDecoration, BuildContext, Center, CircularProgressIndicator, Colors, Column, Container, CrossAxisAlignment, EdgeInsets, FlatButton, Flexible, FutureBuilder, GlobalKey, Icon, IconButton, Icons, InputBorder, InputDecoration, MainAxisSize, Navigator, PageStorageKey, Row, Scaffold, ScaffoldState, Scrollbar, SingleChildScrollView, SizedBox, SnackBar, State, StatefulWidget, Text, TextEditingController, TextField, TextInputType, TextStyle, Widget, WillPopScope, required, showDialog;
import 'package:pterodactyl_app/widgets/tooltip/tooltip.dart';
import 'package:flutter/services.dart';

import 'fileactions.dart';
import 'filemanager.dart';

class TextEditorPage extends StatefulWidget {
  final FileData file;

  const TextEditorPage({
    @required this.file,
  });

  @override
  _TextEditorPageState createState() => _TextEditorPageState();
}

class _TextEditorPageState extends State<TextEditorPage> {
  ///This is either the original version of the file or the last updated modified version of the file.
  String _stableFile;

  ///It is used when the current file is edited but not updated.
  bool _uncommitedChanges = false;

  ///It is used when the current file is being updated.
  bool _isUpdating = false;

  TextEditingController textEditorController;
  final textEditorScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    textEditorController = TextEditingController();
    textEditorController.addListener(textEditorListener());
  }

  textEditorListener() {
    setState(
        () => _uncommitedChanges = textEditorController.text != _stableFile);
  }

  FileActions fileActions = FileActions();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return _uncommitedChanges
            ? showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Are you sure?"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            "Discard changes and exit.",
                          ),
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("NO"),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      FlatButton(
                        child: Text("Yes"),
                        onPressed: () => Navigator.of(context)..pop()..pop(),
                      )
                    ],
                  );
                })
            : true;
      },
      child: Scaffold(
        key: textEditorScaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Tooltip(
            message: widget.file.name,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            showDuration: Duration(milliseconds: 1000),
            child: Text(
              "Editor",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          actions: <Widget>[
            if (_uncommitedChanges)
              _isUpdating
                  ? IconButton(
                      onPressed: () {},
                      icon: Tooltip(
                        message: "Saving and updating file",
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        showDuration: Duration(milliseconds: 1000),
                        child: SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator()),
                      ))
                  : Tooltip(
                      message: "Save and update file",
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      showDuration: Duration(milliseconds: 1000),
                      child: IconButton(
                        icon: Icon(Icons.save),
                        onPressed: () =>
                            _updateChanges(textEditorController.text),
                      ),
                    ),
          ],
        ),
        body: FutureBuilder(
          future: _stableFile == null
              ? rootBundle
                  .loadString(widget.file.url)
                  .then((data) => _stableFile = data)
                  .then((data) => textEditorController.text = data)
              : null,
          // fileActions.getFile(widget.file.url).then((data) => _stableFile = data).then((data) => textEditorController.text = data)
          // : null,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (_stableFile == null) {
              return Center(
                  child: Column(
                children: [
                  CircularProgressIndicator(),
                  Text("Loading file"),
                ],
              ));
            }

            return Container(
              padding: EdgeInsets.all(10),
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Scrollbar(
                  //TODO: see if directly adding scrollbar to textfield works.
                  child: SingleChildScrollView(
                    key: PageStorageKey("lol"),
                    child: TextField(
                      // expands: true,
                      scrollPhysics: AlwaysScrollableScrollPhysics(),
                      autocorrect: false,
                      maxLines: 20,
                      scrollPadding: EdgeInsets.all(20),
                      // minLines: null,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      controller: textEditorController,
                      autofocus: true,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        resizeToAvoidBottomPadding: true,
      ),
    );
  }

  ///Updates the changes (currently faked and doesnt update the asset file just updates the editor)
  Future<void> _updateChanges(String value) async {
    setState(() => _isUpdating = true);

    fileActions.updateFile(widget.file, value).then((e) {
      if (e != null) {
        _stableFile = value;
        textEditorController.text = value;
        _uncommitedChanges = _stableFile != textEditorController.text;
      }

      setState(() => _isUpdating = false);

      textEditorScaffoldKey.currentState.showSnackBar(SnackBar(
        content: Row(
          children: [
            Icon(e != null ? Icons.cloud_done : Icons.error),
            SizedBox(
              width: 10,
            ),
            Text(e != null
                ? "File updated!"
                : "An error occured, please try again later."),
          ],
        ),
        duration: Duration(seconds: 1),
      ));
    });
  }
}
