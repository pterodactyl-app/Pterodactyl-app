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
import 'package:pterodactyl_app/models/server.dart';
import 'package:pterodactyl_app/page/client/filemanager/fileactions.dart';
import 'package:pterodactyl_app/page/client/filemanager/fileviewer.dart';
import 'package:pterodactyl_app/page/client/filemanager/texteditor.dart';

///[FileManager] with the help of [FileViewer] and  [TextEditor] is responsible for letting the users view an image, edit, save and delete a file. it takes a [Server] as a parameter, currently this server is used only for setting the AppBar tooltip text. but the plan is to extend it and get files located on that server for the [FileManager] to work.
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

  ///[FileActions] will contain all the backend functions to get a file, update a file or delete a file from the server.
  final fileActions = FileActions();

  ///All the files that are downloaded from the server will stay here.
  ///It will act as a cache memory when the user returns to previous directory or stores the next downloaded directory when the user selects a new directory that is not yet present in here.
  final files = Map<String, Map>();

  ///A directory, according to my idea: an api address like "api.example.com/example/example" where a JSON file is located.
  ///
  ///This JSON file will contain a key "directories" that will have a list of JSON object that will contain 2 key-value pairs : (a)"address" : other such address that direct to another such JSON file and (b) "name" name of that JSON file (Folder name shown to the users).
  ///
  ///This JSON file will also contain another key "files" that will have a list of a JSON object that will also contain 2 key-value pairs" (a)"address" : address of that file and (b) "name" : name of the file (with extension);
  ///
  ///directoryTree contains the urls of all the folders opened, empty if current directory is the root.
  final directoryTree = List<String>();
  final directoryNames = Map<String, String>();

  ///This is the initial directory that gives the intial JSON file to start off.
  String rootDirectory =
      SampleAddresses.root; //we are replacing with sampleData here.
  ///This is the current directory (adddress of the current JSON file). it updates whenever the user navigate back or forth in the directory tree.  initialized to root. make sense.
  String currentDirectory = SampleAddresses.root;

  ///more like "is file on this index being processed?" by checking whether the currentDirectory (as a key of this map) contains that particular index of that particulatr FileListTile;
  final isFileProcessing = Map<String, List<int>>();

  String directoriesVsFiles(int directoriesLength, int filesLength, int index) {
    if (index > directoriesLength - 1) {
      return "files";
    } else
      return "directories";
  }

  FileType _checkFileType(String name) {
    return fileActions.checkType(name); //Check
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: fileManagerScaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Tooltip(
          message: "${widget.server.name}",
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          showDuration: Duration(milliseconds: 1000),
          child: Text(
            "File Manager",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            title: RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: "./",
                    style: TextStyle(color: Colors.black, fontSize: 18)),
                for (var directory in directoryNames.keys)
                  TextSpan(
                    text: directoryNames[directory] + "/",
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  )
              ]),
            ),
          ),
          if (currentDirectory != rootDirectory)
            Tooltip(
                message: "Go back to previous folder",
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                showDuration: Duration(milliseconds: 1000),
                child: ListTile(
                  title: Row(
                      // crossAxisAlignment: CrossAxisAlignment.baseline,
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
                            style: TextStyle(
                                textBaseline: TextBaseline.alphabetic),
                          ),
                        ),
                      ]),
                  onTap: _navigateBack,
                )),
          Expanded(
            child: FutureBuilder(
              future: files.containsKey(currentDirectory)
                  ? null
                  : fileActions.getFile(currentDirectory).then(
                      (data) => setState(() => files[currentDirectory] = data)),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (files.containsKey(currentDirectory)) {
                  if (files[currentDirectory]["directories"].isEmpty &&
                      files[currentDirectory]["files"].isEmpty) {
                    return Center(
                      child: Text("[EMPTY]"),
                    );
                  } else {
                    return ListView.builder(
                      padding: EdgeInsets.all(0.0),
                      itemCount: files[currentDirectory]["directories"].length +
                          files[currentDirectory]["files"].length,
                      itemBuilder: (BuildContext context, int index) {
                        String whichOne = directoriesVsFiles(
                            files[currentDirectory]["directories"].length,
                            files[currentDirectory]["files"].length,
                            index);
                        return makeFileListTile(
                            FileData(
                              name: files[currentDirectory][whichOne][index]
                                  ["name"],
                              type: whichOne == "directories"
                                  ? FileType.Folder
                                  : _checkFileType(files[currentDirectory]
                                      [whichOne][index]["name"]), //TODO
                              url: files[currentDirectory][whichOne][index]
                                  ["address"],
                              path: directoryTree,
                            ),
                            index);
                      },
                    );
                  }
                }

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
            ),
          )
        ],
      ),
    );
  }

  void _navigateBack() {
    setState(() {
      directoryNames.remove(currentDirectory);
      currentDirectory = directoryTree.last;
      directoryTree.remove(directoryTree.last);
    });
  }

  IconData dataTypeIcon(FileType type) {
    switch (type) {
      case FileType.Folder:
        return Icons.folder;
      case FileType.Text:
        return Icons.description;
      case FileType.Image:
        return Icons.image;
      case FileType.Other:
        return Icons.insert_drive_file;

      default:
        return Icons.insert_drive_file;
    }
  }

  Widget makeFileListTile(FileData data, int index) {
    return ListTile(
      leading: Icon(dataTypeIcon(data.type)),
      title: Text(data.name),
      trailing: isFileProcessing[currentDirectory] != null &&
              isFileProcessing[currentDirectory].contains(index)
          ? SizedBox(
              child: CircularProgressIndicator(),
              height: 20,
              width: 20,
            )
          : SizedBox(
              height: 30,
              width: 30,
            ),
      onTap: data.type == FileType.Other
          ? () {}
          : () async {
              if (data.type == FileType.Folder) {
                setState(() {
                  directoryTree.add(currentDirectory);
                  directoryNames[data.url] = data.name;
                  currentDirectory = data.url;
                });
                return;
              }
              var route = MaterialPageRoute<bool>(
                  builder: (BuildContext context) => FileViewer(
                        file: data,
                      ));
              bool result = await Navigator.of(context).push(route);
              if (result == true) _deleteFile(data, currentDirectory, index);
            },
      onLongPress: data.type == FileType.Other
          ? () {}
          : () {
              makeAndShowBottomSheet(data, index);
            },
    );
  }

  makeAndShowBottomSheet(FileData file, int index) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(dataTypeIcon(file.type)),
                title: Text("View"),
                onTap: () {
                  Navigator.of(context).pop();
                  var route = MaterialPageRoute(
                      builder: (BuildContext context) => FileViewer(
                            file: file,
                          ));
                  Navigator.of(context).push(route).then((delete) {
                    if (delete == true)
                      _deleteFile(file, currentDirectory, index);
                  });
                },
              ),
              if (file.type == FileType.Text)
                ListTile(
                  leading: Icon(Icons.edit),
                  title: Text("Edit"),
                  onTap: () {
                    Navigator.of(context).pop();
                    var route = MaterialPageRoute(
                        builder: (BuildContext context) => TextEditorPage(
                              file: file,
                            ));
                    Navigator.of(context).push(route);
                  },
                ),
              ListTile(
                  leading: Icon(Icons.delete),
                  title: Text("Delete"),
                  onTap: () {
                    Navigator.of(context).pop();
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
                                    "Do you want to delete this ${file.type == FileType.Folder ? "folder" : "file"}: ${file.name}",
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
                                  child: Text("Yes, delete it."),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _deleteFile(file, currentDirectory, index);
                                  })
                            ],
                          );
                        });
                  })
            ],
          );
        });
  }

//This function need [fileActions.deleteFile] to work. The FileData of the file is passed on to that function, FYI FileData contains a variable ["path"]. path is just a a list of strings that contain urls of all the past directories that lead to the folder of this file, and filedata also contains its own URL, maybe you can manipulate/delete the file directly with this URL ? so we can get rid of paths.

  _deleteFile(FileData file, String directory, int index) async {
    isFileProcessing[directory] = List<int>();
    setState(() => isFileProcessing[directory].add(index));
    await fileActions.deleteFile(file).then((e) {
      if (e != null) {
        _onFileDelete(directory, index);
      }
      if (e == null) {
        setState(() => isFileProcessing[directory].remove(index));
      }

      fileManagerScaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: e != null
              ? Row(
                  children: <Widget>[
                    Icon(Icons.delete),
                    SizedBox(
                      width: 10,
                    ),
                    Text("File deleted!")
                  ],
                )
              : Row(
                  children: <Widget>[
                    Icon(Icons.error),
                    SizedBox(
                      width: 10,
                    ),
                    Text("An error occured, Please try again later.")
                  ],
                ),
          duration: Duration(seconds: 1),
        ),
      );
    });
  }

//This is an extra step for updating the UI upon a file deletion, i have commented it for now because we are just testing it.
  _onFileDelete(directory, index) {
    //   String whichOne = directoriesVsFiles(
    //       files[directory]["directories"].length,
    //       files[directory]["files"].length,
    //       index);
    //
    isFileProcessing[directory].remove(index);
    // files[directory][whichOne].removeAt(index);
    //
    setState(() {});
  }
}

class FileData {
  final FileType type;
  final String name;
  final String url;
  final List<String> path;
  FileData({
    @required this.type,
    @required this.name,
    this.url,
    this.path,
  });
}

enum FileType {
  Text,
  Image,
  Folder,
  Other,
}
