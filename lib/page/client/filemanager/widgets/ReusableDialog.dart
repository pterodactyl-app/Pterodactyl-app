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

void showReusableDialog(BuildContext context, String title, String description, {String button1Text, Function button1Function, String button2Text, Function button2Function}){
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              title,
              ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Flexible(
                    child: Text(
                      description,
                    ),
                ),
              ],
            ),
            actions: <Widget>[
              if(button1Function != null) FlatButton(
                child: Text(button1Text ?? "NO"),
                onPressed: () {
                  Navigator.of(context).pop();
                  button1Function();
                }
              ),
              FlatButton(
                  child: Text(button2Text ?? "OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    if(button2Function != null) button2Function();
                  })
            ],
          );
        });
  }