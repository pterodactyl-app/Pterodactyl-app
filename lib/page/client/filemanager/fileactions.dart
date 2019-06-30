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

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pterodactyl_app/models/server.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'filemanager.dart';

///All backend logic of filemanager is processed in this class (currently faked);;
class FileActions {

  final Server server;
  FileActions(this.server);

  String _apiKey;
  String _panelUrl;
  String _https;

  String _baseUrl;

  ///Must call this function once on the instance of this class before using anything in this class
  Future<void> initialize() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _apiKey = prefs.getString("apiKey");
    _panelUrl = prefs.getString("panelUrl");
    _https = prefs.getString("https");

    _baseUrl = (_https + _panelUrl + "/api/app/user/files/${server.id}/");
    return;
  }

  String getApiKey()=> _apiKey;
  ///for images
  String getCompleteApiAddress(String directory) => _baseUrl + FileHttpHelper.file + directory;

  Future<Directory> getDirectory(String directory) async{
    
      final folders = List<FileData>();
      final files = List<FileData>();

    try {
      http.Response response = await http.get(
        _baseUrl + FileHttpHelper.directory + directory,
        headers: {
          "Accept" : "application/json",
          "Authorization" : "Bearer $_apiKey",
        }
        );
      var data = await json.decode(response.body);
      for(var object in data["contents"]["folders"]){
        folders.add(
          FileData(
            name: object["entry"],
            type: FileType.Folder,
            date: object["date"],
            mime: object["mime"],
            size: object["size"],
            directory: object["directory"],
            )
          );
      }
      for(var object in data["contents"]["files"]){
        files.add(
          FileData(
            name: object["entry"],
            type: checkType(object["extension"]),
            date: object["date"],
            directory: object["entry"],
            extension: object["extension"],
            mime: object["mime"],
            size: object["size"],
          )
        );
      }
      return Directory(
        folders: folders,
        files: files,
      );
    } on SocketException catch (e) {
      print('Error occured: ' + e.message);
      print(_panelUrl);
      print(_https);
      print('End debug');
      return null;
    }
  }

  Future<dynamic> getFile(FileData fileData) async {

    try {
      http.Response response = await http.get(
        _baseUrl + FileHttpHelper.file + "${fileData.directory +"/"+ fileData.name}" ,
        headers: {
          "Authorization" : "Bearer $_apiKey",
        }
        );
      return response.body.toString();

    } on SocketException catch (e) {
      print('Error occured: ' + e.message);
      print(_panelUrl);
      print(_https);
      print('End debug');
      return null;
    }
  }

  Future<bool> deleteFile(FileData fileData) async {
    
    try {
      await http.delete(
        _baseUrl + FileHttpHelper.delete + "${fileData.directory +"/"+ fileData.name}" ,
        headers: {
          "Authorization" : "Bearer $_apiKey",
        }
        );
      return true;

    } on SocketException catch (e) {
      print('Error occured: ' + e.message);
      print(_panelUrl);
      print(_https);
      print('End debug');
      return false;
    }
  }

  Future<bool> writeFile(FileData fileData, String data) async {
        
    try {
      await http.post(
        _baseUrl + FileHttpHelper.writeFile + "${fileData.directory +"/"+ fileData.name}" ,
        headers: {
          "Authorization" : "Bearer $_apiKey",
        },
        body: data,
        );
      return true;

    } on SocketException catch (e) {
      print('Error occured: ' + e.message);
      print(_panelUrl);
      print(_https);
      print('End debug');
      return false;
    }

  }

  Future<bool> createDirectory(FileData fileData) async{
        
    try {
      await http.post(
        _baseUrl + FileHttpHelper.createDirectory + "?name=${fileData.name}&directory=${fileData.directory}" ,
        headers: {
          "Authorization" : "Bearer $_apiKey",
        },
        );
      return true;

    } on SocketException catch (e) {
      print('Error occured: ' + e.message);
      print(_panelUrl);
      print(_https);
      print('End debug');
      return false;
    }
  }

  FileType checkType(String extension) {
    // String extension = _getExtension(name);

    //you can add more extension names here to support them too in the text editor.
    switch (extension) {
      case "txt":
      case "text":
      case "cpp":
      case "c":
      case "css":
      case "json":
        return FileType.Text;
      case "ico":
      case "gif":
      case "jpeg":
      case "png":
      case "jpg":
      case "webp":
        return FileType.Image;
      case "zip":
      case "rar":
      case "gzip":
      case "tar":
      case "7z":
        return FileType.Archive;
      case "html":
        return FileType.HTML;
      case "py":
        return FileType.Python;
      case "js":
        return FileType.JavaScript;
      case "java":
        return FileType.Java;

      default:
        return FileType.Other;
    }
  }

  // static String _getExtension(String fullName) {
  //   int index = fullName.lastIndexOf('.');
  //   if (index < 0 || index + 1 >= fullName.length) return fullName;
  //   return fullName.substring(index + 1).toLowerCase();
  // }

}

class Directory {

  @required final List folders;
  @required final List files;
  Directory({this.folders, this.files});

}

class FileHttpHelper{
  ///add before the path of the file that you want to fetch, use with [GET].
  static const String file = "content?file=";
  ///add before the the path of file/folder that you want to delete, use with [DELETE].
  static const String delete = "delete?file=";
  ///add before the path of directory that you want to fetch. use with [GET].
  static const String directory = "list?directory=";
  ///add before the path of the file that you want to update or create, [content in body] required. use with [POST].
  static const String writeFile = "write?file=";
  ///add this after the base url, add [name] and [path] parameters after this, use with [POST];
  static const String createDirectory = "new-folder";
}

