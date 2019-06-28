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

showComingSoonDialog(BuildContext context){
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            children: <Widget>[
              Flexible(
                child: Text(
                  "COMING SOON",
                  ),
              )
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      }
      
    );
  }