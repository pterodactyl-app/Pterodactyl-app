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
import 'package:pterodactyl_app/widgets/tooltip/tooltip.dart' as tooltip;

Widget customTooltip({String message, Widget child}){
  return tooltip.Tooltip(
    message: message,
    child: child,
    showDuration: Duration(milliseconds: 1000),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(1),
      border: Border.all(
        width: 1,
        color: Colors.black,
      ),
      borderRadius: BorderRadius.circular(3),
    ),
  );
}