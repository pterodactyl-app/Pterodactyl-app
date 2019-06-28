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
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';

import 'fileactions.dart';
import 'filemanager.dart';
import 'texteditor.dart';

///FileViewer is used by FileManager to show files before editing.
class FileViewer extends StatefulWidget {
  final FileData file;
  const FileViewer({
    @required this.file,
  });

  @override
  _FileViewerState createState() => _FileViewerState();
}

class _FileViewerState extends State<FileViewer> {
  final fileActions = FileActions();
  final fileViewerScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: fileViewerScaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.file.name,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          Tooltip(
              message: "Delete this file",
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              showDuration: Duration(milliseconds: 1000),
              child: IconButton(
                icon: Icon(
                  Icons.delete,
                ),
                onPressed: _delete,
              )),
          if (widget.file.type == FileType.Text)
            Tooltip(
              message: "Edit this file",
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              showDuration: Duration(milliseconds: 1000),
              child: IconButton(
                icon: Icon(
                  Icons.edit,
                ),
                onPressed: _edit,
              ),
            ),
        ],
      ),
      body: widget.file.type == FileType.Image ? _showImage() : _showText(),
    );
  }

  Widget _showImage() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
      ),
      child: PhotoView(
        backgroundDecoration: BoxDecoration(color: Colors.grey),
        maxScale: 2.00,
        // MediaQuery.of(context).size.longestSide,
        minScale: 0.3,
        imageProvider: AssetImage(
          widget.file
              .url, //Using asset image since we are getting the sample image thats alreay located on the device.
        ),

        // NetworkImage(
        //   widget.file.url, //we may need this in real world version of this app
        // ),

        enableRotation: false,
      ),
    );
  }

  Widget _showText() {
    return FutureBuilder(
        future: rootBundle.loadString(widget.file.url),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Loading file"),
                ],
              ),
            );
          if (snapshot.hasData)
            return Container(
              height: double.infinity,
              width: double.infinity,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        snapshot.data +
                            "\n\n\n\n\n\n\n\n\n\n", //"\n" are here to give a little padding at the bottom
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
        });
  }

  void _delete() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Are you sure?"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  child: Text(
                    "Do you really want to delete this ${widget.file.type == FileType.Folder ? "folder" : "file"}: ${widget.file.name}",
                  ),
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("NO"),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: Text("Yes, delete it."),
                onPressed: () {
                  Navigator.of(context)
                    ..pop()
                    ..pop(
                        true); //popping this page with true means the previous page will process functions to delete it. MUST use only when needed.
                },
              )
            ],
          );
        });
  }

  void _edit() {
    var route = MaterialPageRoute(
        builder: (BuildContext context) => TextEditorPage(
              file: widget.file,
            ));
    Navigator.of(context).push(route);
  }
}
