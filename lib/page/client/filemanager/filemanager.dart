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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pterodactyl_app/page/client/filemanager/widgets/CustomTooltip.dart';
import 'package:pterodactyl_app/page/client/filemanager/widgets/ErrorSnackbar.dart';
import 'package:pterodactyl_app/page/client/filemanager/widgets/ReusableDialog.dart';
import 'package:pterodactyl_app/models/server.dart';
import 'package:pterodactyl_app/page/client/filemanager/fileactions.dart';
import 'package:pterodactyl_app/page/client/filemanager/fileviewer.dart';
import 'package:pterodactyl_app/page/client/filemanager/texteditor.dart';
import 'package:pterodactyl_app/page/client/filemanager/widgets/CreateDialog.dart';
import 'package:pterodactyl_app/globals.dart' as globals;

///[FileManager] with the help of [FileViewer] and  [TextEditor] is responsible for letting the users view an image, edit, save and delete a file.
///It takes a [Server] as a parameter, it is needed for the [FileManager] to work on that [Server].
class FileManager extends StatefulWidget {
  final Server server;

  const FileManager({
    @required this.server,
  });

  @override
  _FileManagerState createState() => _FileManagerState();
}

class _FileManagerState extends State<FileManager> {
  ///for showing messages using a SnackBar at the bottom of the screen
  final fileManagerScaffoldKey = GlobalKey<ScaffoldState>();

  ///[FileActions] contains all the backend functions.
  FileActions fileActions;
  final downloadedDirectories = Map<String, Directory>();

  final directoryTree = List<String>();

  ///it gets updated whenever the user navigate back or forth in the directory tree using filemanager. initialized to the root directory.
  String currentDirectory = "/";

  ///more like "is file on this index of this directory being processed?" by checking whether the currentDirectory (as a key of this map) contains that particular index of that particular FileListTile;
  final isFileProcessing = Map<String, List<int>>();

  bool isCreatingNewFile = false;

  final _createTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fileActions = FileActions(widget.server);
    () async {
      await fileActions.initialize();
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: fileManagerScaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: globals.useDarkTheme ? null : Colors.transparent,
        leading: IconButton(
          color: globals.useDarkTheme ? Colors.white : Colors.black,
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/home', (Route<dynamic> route) => false);
          },
          icon: Icon(Icons.arrow_back,
              color: globals.useDarkTheme ? Colors.white : Colors.black),
        ),
        title: Text('File Manager',
            style: TextStyle(
                color: globals.useDarkTheme ? Colors.white : Colors.black,
                fontWeight: FontWeight.w700)),
        actions: <Widget>[
          isCreatingNewFile
              ? IconButton(
                  onPressed: () {},
                  icon: SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator()),
                )
              : CustomTooltip(
                  message: "Create",
                  child: _makePopupMenu(),
                )
        ],
      ),
      body: Column(
        children: <Widget>[
          _makeDirectoryPathText(),
          if (currentDirectory != "/") _makeBackListTile(),
          Expanded(
            child: _makeFileListTiles(),
          ),
        ],
      ),
    );
  }

  Widget _makePopupMenu() {
    return PopupMenuButton<String>(
      child: Icon(Icons.add),
      onSelected: _popupMenuAction,
      itemBuilder: (BuildContext context) {
        return FileManagerPopupMenu.choices.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Row(
              children: <Widget>[
                Icon(choice == FileManagerPopupMenu.NewFolder
                    ? Icons.create_new_folder
                    : Icons.note_add),
                SizedBox(width: 8),
                Text(choice),
              ],
            ),
          );
        }).toList();
      },
    );
  }

  Widget _makeDirectoryPathText() {
    return ListTile(
      title: RichText(
        text: TextSpan(children: [
          TextSpan(
              text: (directoryTree.isNotEmpty ? ("../" + directoryTree.last).replaceAll("//", "/") : "../"), style: TextStyle(color: Colors.black, fontSize: 15)),
        ]),
      ),
    );
  }

  Widget _makeBackListTile() {
    return CustomTooltip(
        message: "Go back to previous folder",
        child: ListTile(
          title: Row(
              children: [
                RotatedBox(
                    quarterTurns: 1,
                    child: Icon(
                      Icons.subdirectory_arrow_left,
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "back",
                    style: TextStyle(textBaseline: TextBaseline.alphabetic),
                  ),
                ),
              ]),
          onTap: _navigateBack,
        ));
  }

  Widget _makeFileListTiles() {
    return FutureBuilder(
      future: downloadedDirectories.containsKey(currentDirectory)
          ? null
          : fileActions.getDirectory(currentDirectory).then((data) =>
              setState(() => downloadedDirectories[currentDirectory] = data)),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (downloadedDirectories.containsKey(currentDirectory)) {
          if (downloadedDirectories[currentDirectory].folders.isEmpty &&
              downloadedDirectories[currentDirectory].files.isEmpty) {
            return Center(
              child: Text("[EMPTY]"),
            );
          } else {
            return ListView.builder(
              padding: EdgeInsets.all(0.0),
              itemCount:
                  downloadedDirectories[currentDirectory].folders.length +
                      downloadedDirectories[currentDirectory].files.length,
              itemBuilder: (BuildContext context, int index) {
                return makeFileListTile(
                    index <=
                            (downloadedDirectories[currentDirectory]
                                    .folders
                                    .length -
                                1)
                        ? downloadedDirectories[currentDirectory].folders[index]
                        : downloadedDirectories[currentDirectory].files[index -
                            downloadedDirectories[currentDirectory]
                                .folders
                                .length],
                    index);
              },
            );
          }
        } else

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(
                height: 10,
              ),
              Text("Loading files")
            ],
          ),
        );
      },
    );
  }

  void _popupMenuAction(String choice) {
    if (choice == FileManagerPopupMenu.NewFolder)
      _createNewFolder(currentDirectory);
    else if (choice == FileManagerPopupMenu.NewFile)
      _createNewFile(currentDirectory);
  }

  void _createNewFolder(String directory) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return CreateDialog(
            controller: _createTextController,
            title: "Create new folder",
            onSubmitted: () async {
              setState(() => isCreatingNewFile = true);

              bool result = await fileActions.createDirectory(FileData(
                  name: _createTextController.text, directory: directory));

              if (result == true) {
                downloadedDirectories[directory].folders.add(FileData(
                      directory: directory,
                      name: _createTextController.text,
                      date: ((DateTime.now().millisecondsSinceEpoch) ~/ 1000),
                      type: FileType.Folder,
                    ));
              } else {
                fileManagerScaffoldKey.currentState
                    .showSnackBar(ErrorSnackbar());
              }

              _createTextController.text = "";
              setState(() => isCreatingNewFile = false);
            },
          );
        });
  }

  void _createNewFile(String directory) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return CreateDialog(
            controller: _createTextController,
            title: "Create new file",
            onSubmitted: () async {
              setState(() => isCreatingNewFile = true);
              bool result = await fileActions.writeFile(
                  FileData(
                      name: _createTextController.text, directory: directory),
                  "");
              if (result == true) {
                FileData fileData = FileData(
                  directory: directory,
                  name: _createTextController.text,
                  date: (DateTime.now().millisecondsSinceEpoch ~/ 1000),
                  type: FileType.Text,
                );
                downloadedDirectories[directory].files.add(fileData);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => TextEditorPage(
                          fileActions: fileActions,
                          fileData: fileData,
                        )));
              } else {
                fileManagerScaffoldKey.currentState
                    .showSnackBar(ErrorSnackbar());
              }

              _createTextController.text = "";
              setState(() => isCreatingNewFile = false);
            },
          );
        });
  }

  void _navigateBack() {
    setState(() {
      currentDirectory = directoryTree.last;
      directoryTree.remove(directoryTree.last);
    });
  }

  IconData dataTypeIcon(FileType type) {
    switch (type) {
      case FileType.Folder:
        return FontAwesomeIcons.folder;
      case FileType.Text:
        return FontAwesomeIcons.file;
      case FileType.Image:
        return FontAwesomeIcons.fileImage;
      case FileType.Archive:
        return FontAwesomeIcons.archive;
      case FileType.Java:
        return FontAwesomeIcons.java;
      case FileType.Python:
        return FontAwesomeIcons.python;
      case FileType.HTML:
        return FontAwesomeIcons.html5;
      case FileType.JavaScript:
        return FontAwesomeIcons.jsSquare;
      case FileType.Other:
        return FontAwesomeIcons.file;

      default:
        return FontAwesomeIcons.file;
    }
  }

  Widget makeFileListTile(FileData fileData, int index) {
    return ListTile(
      leading: Icon(dataTypeIcon(fileData.type)),
      title: Text(fileData.name),
      trailing: _showProgressIndicator(index),
      onTap: () => _handleFileListTileOnTap(fileData, index),
      onLongPress: () {
        if (fileData.type != FileType.Other)
          _makeAndShowBottomSheet(context, fileData, index);
      },
    );
  }

  Widget _showProgressIndicator(int index) {
    return isFileProcessing[currentDirectory] != null &&
            isFileProcessing[currentDirectory].contains(index)
        ? SizedBox(
            child: CircularProgressIndicator(),
            height: 20,
            width: 20,
          )
        : SizedBox(
            height: 30,
            width: 30,
          );
  }

  void _handleFileListTileOnTap(FileData fileData, int index) async {
    switch (fileData.type) {
      case FileType.Archive:
      case FileType.Java:
      case FileType.Python:
      case FileType.HTML:
      case FileType.JavaScript:
      case FileType.Other:
        return;
      case FileType.Folder:
        setState(() {
          directoryTree.add(currentDirectory);
          currentDirectory = fileData.directory + fileData.name;
        });
        return;
      case FileType.Text:
      case FileType.Image:
        Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (BuildContext context) => FileViewer(
                      fileData: fileData,
                      fileActions: fileActions,
                    )))
            .then((delete) => delete == true
                ? _deleteFile(fileData, currentDirectory, index)
                : () {});
    }
  }

  _makeAndShowBottomSheet(BuildContext context, FileData fileData, int index) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              bottomSheetListTile(context, dataTypeIcon(fileData.type), "View",
                  onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (BuildContext context) => FileViewer(
                              fileData: fileData,
                              fileActions: fileActions,
                            )))
                    .then((delete) {
                  if (delete == true) {
                    _deleteFile(fileData, currentDirectory, index);
                  }
                });
              }),
              if (fileData.type == FileType.Text)
                bottomSheetListTile(context, Icons.edit, "Edit", onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => TextEditorPage(
                            fileData: fileData,
                            fileActions: fileActions,
                          )));
                }),
              bottomSheetListTile(context, Icons.delete, "Delete", onTap: () {
                showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) => ReusableDialog(
                          "Are you sure?",
                          "Do you really want to delete this ${fileData.type == FileType.Folder ? "folder" : "file"}: ${fileData.name}",
                          button1Text: "NO",
                          button1Function: () {},
                          button2Text: "Yes, delete it.",
                          button2Function: () =>
                              _deleteFile(fileData, currentDirectory, index),
                        ));
              }),
            ],
          );
        });
  }

  Widget bottomSheetListTile(BuildContext context, IconData icon, String title,
      {Function onTap}) {
    return ListTile(
      leading: Icon(
        icon,
      ),
      title: Text(
        title,
      ),
      onTap: () {
        Navigator.of(context).pop();
        onTap();
      },
    );
  }

  _deleteFile(FileData fileData, String directory, int index) async {
    isFileProcessing[directory] = List<int>();
    setState(() => isFileProcessing[directory].add(index));
    await fileActions.deleteFile(fileData).then((result) {
      if (result == true) {
        _onFileDelete(directory, index);
        fileManagerScaffoldKey.currentState.showSnackBar(SnackBar(
          content: Row(
            children: <Widget>[
              Icon(
                Icons.delete,
              ),
              SizedBox(width: 10),
              Text(
                "File deleted",
              ),
            ],
          ),
          duration: Duration(seconds: 1),
        ));
      } else {
        setState(() => isFileProcessing[directory].remove(index));
        fileManagerScaffoldKey.currentState.showSnackBar(
          ErrorSnackbar(),
        );
      }
    });
  }

  _onFileDelete(String directory, int index) {
    if (index <= downloadedDirectories[directory].folders.length - 1) {
      downloadedDirectories[directory].folders.removeAt(index);
    } else {
      downloadedDirectories[directory]
          .files
          .removeAt(index - downloadedDirectories[directory].folders.length);
    }
    setState(() => isFileProcessing[directory].remove(index));
  }
}

class FileData {
  final FileType type;
  final String name;
  final String directory;
  final int date;
  final String mime;
  final String size;
  final String extension;
  FileData({
    @required this.name,
    @required this.directory,
    this.type,
    this.date,
    this.mime,
    this.size,
    this.extension,
  });
}

class FileManagerPopupMenu {
  static const String NewFolder = "New folder";
  static const String NewFile = "New file";

  static const List<String> choices = [
    NewFolder,
    NewFile,
  ];
}

enum FileType {
  Text,
  Image,
  Folder,
  Archive,
  Java,
  Python,
  HTML,
  JavaScript,
  Other,
}
