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

import 'package:flutter/material.dart';
import 'package:pterodactyl_app/page/client/filemanager/widgets/CustomTooltip.dart';
import 'package:pterodactyl_app/page/client/filemanager/widgets/ReusableDialog.dart';
import 'package:flutter/services.dart';

import 'fileactions.dart';
import 'filemanager.dart';

class TextEditorPage extends StatefulWidget {
  final FileData fileData;

  const TextEditorPage({
    @required this.fileData,
  });

  @override
  _TextEditorPageState createState() => _TextEditorPageState();
}

class _TextEditorPageState extends State<TextEditorPage> {
  ///This is either the original version of the file text or the last updated modified version of the file.
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
        _uncommitedChanges
            ? showReusableDialog(
              context,
              "Are you sure?",
              "Discard changes and exit.",
              button1Text: "NO",
              button1Function: (){},
              button2Text: "Yes, discard changes.",
              button2Function: () => Navigator.of(context).pop(),
              )
            : Navigator.of(context).pop();
      },
      child: Scaffold(
        key: textEditorScaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: customTooltip(
            message: widget.fileData.name,
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
                      icon: customTooltip(
                        message: "Saving and updating file",
                        child: SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator()),
                      ))
                  : customTooltip(
                      message: "Save and update file",
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
                  .loadString(widget.fileData.url)
                  .then((data) => _stableFile = data)
                  .then((data) => textEditorController.text = data)
              : null,
          // fileActions.getFile(widget.fileData.url).then((data) => _stableFile = data).then((data) => textEditorController.text = data)
          // : null,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (_stableFile == null) {
              return Center(
                  child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10,),
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
                child: _makeTextEditor(),
                ),
              
            );
          },
        ),
        resizeToAvoidBottomPadding: true,
      ),
    );
  }

  Widget _makeTextEditor(){
    return Scrollbar(
                    key: PageStorageKey("lol"),
                    child: TextField(
                      scrollPhysics: AlwaysScrollableScrollPhysics(),
                      autocorrect: false,
                      maxLines: 20,
                      scrollPadding: EdgeInsets.all(20),
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
                  );

  }

  ///Updates the changes (currently faked and doesnt update the asset file just updates the editor)
  Future<void> _updateChanges(String value) async {
    setState(() => _isUpdating = true);

    fileActions.updateFile(widget.fileData, value).then((result) {
      if (result == true) {
        _stableFile = value;
        textEditorController.text = value;
        _uncommitedChanges = _stableFile != textEditorController.text;
      }

      setState(() => _isUpdating = false);

      textEditorScaffoldKey.currentState.showSnackBar(SnackBar(
        content: Row(
          children: [
            Icon(result == true ? Icons.cloud_done : Icons.error),
            SizedBox(width: 10),
            Text(result == true
                ? "File updated!"
                : "An error occured, please try again later."),
          ],
        ),
        duration: Duration(seconds: 1),
      ));
    });
  }
}
