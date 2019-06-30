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
import 'package:photo_view/photo_view.dart';

import 'fileactions.dart';
import 'filemanager.dart';
import 'texteditor.dart';

///FileViewer is used by FileManager to show files before editing.
class FileViewer extends StatefulWidget {
  final FileData fileData;
  final FileActions fileActions;
  const FileViewer({
    @required this.fileData,
    @required this.fileActions,
  });

  @override
  _FileViewerState createState() => _FileViewerState();
}

class _FileViewerState extends State<FileViewer> {
  final fileViewerScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: fileViewerScaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.fileData.name,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          CustomTooltip(
            message: "Delete this file",
            child: IconButton(
              icon: Icon(
                Icons.delete,
              ),
              onPressed: _delete,
            ),
          ),
          if (widget.fileData.type == FileType.Text)
            CustomTooltip(
              message: "Edit this file",
              child: IconButton(
                icon: Icon(
                  Icons.edit,
                ),
                onPressed: _edit,
              ),
            ),
        ],
      ),
      body: widget.fileData.type == FileType.Image ? _showImage() : _showText(),
    );
  }

  void _delete() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => ReusableDialog(
              "Are you sure?",
              "Do you really want to delete this ${widget.fileData.type == FileType.Folder ? "folder" : "file"}: ${widget.fileData.name}",
              button1Text: "NO",
              button1Function: () {},
              button2Text: "Yes, delete it.",
              button2Function: () => Navigator.of(context).pop(true),
              //popping this page with true means the previous page will process functions to delete it. MUST use only when needed.
            ));
  }

  Widget _showImage() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
      ),
      child: PhotoView(
        backgroundDecoration: BoxDecoration(color: Colors.grey),
        maxScale: 2.00,
        minScale: 0.3,
        imageProvider: NetworkImage(
            widget.fileActions
                .getCompletetApiAddress(widget.fileData.directory),
            headers: {
              "Authorization": "Bearer ${widget.fileActions.getApiKey()}",
            }),
        enableRotation: false,
      ),
    );
  }

  Widget _showText() {
    return FutureBuilder(
        future: widget.fileActions.getFile(widget.fileData),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
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
          } else {
            return _textContainer(snapshot.data);
          }
        });
  }

  Widget _textContainer(String text) {
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
                text +
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
  }

  void _edit() {
    var route = MaterialPageRoute(
        builder: (BuildContext context) => TextEditorPage(
              fileData: widget.fileData,
              fileActions: widget.fileActions,
            ));
    Navigator.of(context).push(route);
  }
}
