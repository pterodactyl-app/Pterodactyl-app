/*
* Copyright 2018 Ruben Talstra and Yvan Watchman
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
class PartnerList {
  final String name;
  final String url;
  final String logo.dark;
  final String logo.light;
  final String colors.primary;
  final String colors.secondary;

  PartnerList(
      {this.name, this.url, this.logo.dark, this.logo.light, this.colors.primary, this.colors.secondary});

  static final List<PartnerList> partnerList = [
    PartnerList(
      name: "",
      url: "",
      logo: {
          dark: "",
          light: ""
        },
      colors: {
        primary: "",
        secondary: ""
      },
    ),
  ];
}