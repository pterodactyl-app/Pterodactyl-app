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
  String name;
  String url;
  Map<String, String> logo;
  Map<String, String> color;



  PartnerList({String name, String url, Map<String, String> logo, Map<String, String> color}) {
    this.name = name;
    this.url = url;
    this.logo = logo;
    this.color = color;
  }

  // Idk what the fuck is happening here
  static final List<PartnerList> partnerList = [
    PartnerList(
      name: "Deploys.io",
      url: "https://deploys.io/",
      logo: {
          "dark": "https://deploys.io/img/deploys.io/logo/text/light.png",
          "light": "https://deploys.io/img/deploys.io/logo/text/dark.png"
        },
      color: {
        "primary": "#5e72e4 #825ee4 (Gradient)",
        "secondary": "#172b4d"
      },
    ),
    PartnerList(
      name: "CodersLight LLC",
      url: "https://coderslight.com/",
      logo: {
          "dark": "https://avatars2.githubusercontent.com/u/35084758?s=280&v=4",
          "light": "https://cdn.discordapp.com/attachments/575721214643798036/589462220119736340/CodersLightDiscordLogo-transparent.png"
        },
      color: {
        "primary": "",
        "secondary": ""
      },
    ),
    PartnerList(
      name: "AccurateNode",
      url: "https://accuratenode.com/",
      logo: {
          "dark": "https://accuratenode.com/assets/img/icon.png",
          "light": "https://cdn.discordapp.com/attachments/579475423977668638/590143718703759360/logo_big.png"
        },
      color: {
        "primary": "",
        "secondary": ""
      },
    ),
    PartnerList(
      name: "MiniCenter",
      url: "https://minicenter.net/",
      logo: {
          "dark": "https://cdn.discordapp.com/attachments/487345256065662978/535521341340909588/image0.png",
          "light": "https://cdn.discordapp.com/attachments/487345256065662978/535521341340909588/image0.png"
        },
      color: {
        "primary": "",
        "secondary": ""
      },
    ),
    PartnerList(
      name: "PlanetNode",
      url: "https://planetnode.net/",
      logo: {
          "dark": "https://planetnode.net/templates/planetnode/img/header/logo.png",
          "light": "https://planetnode.net/templates/planetnode/img/header/logo-b.png"
        },
      color: {
        "primary": "",
        "secondary": ""
      },
    ),
    PartnerList(
      name: "ReviveNode Hosting",
      url: "https://revivenode.com/",
      logo: {
          "dark": "https://cdn.discordapp.com/attachments/582365380798971934/589519836997222420/RLogo.png",
          "light": "https://cdn.discordapp.com/attachments/582365380798971934/589519836997222420/RLogo.png"
        },
      color: {
        "primary": "",
        "secondary": ""
      },
    ),
    PartnerList(
      name: "RoyaleHosting",
      url: "http://royalehosting.nl/",
      logo: {
          "dark": "",
          "light": ""
        },
      color: {
        "primary": "",
        "secondary": ""
      },
    ),
    PartnerList(
      name: "",
      url: "",
      logo: {
          "dark": "",
          "light": ""
        },
      color: {
        "primary": "",
        "secondary": ""
      },
    ),
  ];
}