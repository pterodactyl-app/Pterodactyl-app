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

import 'filemanager.dart';

///All backend logic of filemanager is processed in this class (currently faked);;
class FileActions {
  Future<Map> getFile(String fileDirectory) async {
    return await Future.delayed(Duration(seconds: 3))
        .then((data) => sampleData[fileDirectory]);
  }

  deleteFile(FileData file) async {
    return await Future.delayed(Duration(seconds: 2))
        .then((_) => null); //null = not successfull
  }

  updateFile(FileData file, String newFile) async {
    return await Future.delayed(Duration(seconds: 2)).then((_) => "success!");
  }

  FileType checkType(String name) {
    String _extension = _ext(name);

    //you can add more extension names here to support them too in the text editor.
    switch (_extension) {
      case "txt":
      case "text":
      case "html":
      case "py":
      case "cpp":
      case "c":
      case "css":
      case "java":
      case "js":
      case "json":
        return FileType.Text;
      case "gif":
      case "jpeg":
      case "png":
      case "jpg":
        return FileType.Image;

      default:
        return FileType.Other;
    }
  }

  static String _ext(String path) {
    int index = path.lastIndexOf('.');
    if (index < 0 || index + 1 >= path.length) return path;
    return path.substring(index + 1).toLowerCase();
  }
}

//ALL sample data>>>>>>>
Map sampleData = {
  SampleAddresses.root: {
    "directories": [
      {"address": SampleAddresses.newFolder, "name": "New folder"}
    ],
    "files": []
  },
  SampleAddresses.newFolder: {
    "directories": [],
    "files": [
      {
        "address": SampleAddresses.textFile,
        "name": "Text File.txt",
      },
      {
        "address": SampleAddresses.image,
        "name": "Image.Jpeg",
      }
    ]
  },
};

class SampleAddresses {
  static const String root = "api.example.com/root";
  static const String newFolder = "api.example.com/root/newFolder";

  //asset address as a sample address, in the real world version of this app, these will also be web addresses
  static const String textFile = "assets/sampleData/textFile.txt";
  static const String image = "assets/sampleData/image.jpeg";
}
