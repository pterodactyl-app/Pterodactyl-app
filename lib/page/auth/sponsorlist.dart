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
class SponsorList {
  final String avatarUrl;
  final String name;
  final String donation;
  final String message;
  final String link;

  SponsorList(
      {this.avatarUrl, this.name, this.donation, this.message, this.link});

  static final List<SponsorList> sponsorList = [
    SponsorList(
      avatarUrl:
          "https://s3-eu-west-1.amazonaws.com/tpd/logos/5c033220e32b98000128f214/0x0.png",
      name: "Thunderbolt Hosting",
      donation: "Apple License",
      message: "https://thunderbolt-hosting.com/",
      link: "https://thunderbolt-hosting.com/",
    ),
    SponsorList(
      avatarUrl: "https://i.coderslight.com/CodersLight_Logo.png",
      name: "CodersLight LLC",
      donation: "\$25.00 CAD",
      message: "https://coderslight.com/",
      link: "https://coderslight.com/",
    ),
    SponsorList(
      avatarUrl:
          "https://raw.githubusercontent.com/rubentalstra/Pterodactyl-app/master/assets/images/minicenter_logo.png",
      name: "MiniCenter",
      donation: "\$21.53 CAD",
      message: "https://www.minicenter.net/",
      link: "https://www.minicenter.net/",
    ),
    SponsorList(
      avatarUrl:
          "https://pbs.twimg.com/profile_images/1010254773826793472/vjxA9idJ_400x400.jpg",
      name: "Deploys.io",
      donation: "Website and WebHost",
      message: "https://deploys.io/",
      link:
          "https://deploys.io/share/104?utm_source=ruben-app&utm_medium=sponsors&utm_campaign=list",
    ),
    SponsorList(
      avatarUrl: "https://avatars0.githubusercontent.com/u/50382144?s=460&v=4",
      name: "Jordy",
      donation: "Android License",
      message: "",
      link: "",
    ),
    SponsorList(
      avatarUrl:
          "",
      name: "MyServerPlanet",
      donation: "\$15.00 CAD",
      message: "MyServerPlanet started in 2014 set out to sell affordable reseller hosting with WHMCS included - MyServerPlanet sells WHMCS resellers for £12.50/month.",
      link: "https://myserverplanet.com/",
    ),  
    SponsorList(
      avatarUrl:
          "",
      name: "Gabriel",
      donation: "\$10.00 USD",
      message: "",
      link: "",
    ),    
    SponsorList(
      avatarUrl: "https://cdn.discordapp.com/attachments/581892189341089822/581897822589157377/SBL2kBlack_ThatDarkGreenShit-DarkBlue_grad.png",
      name: "Sam Walsh",
      donation: "€8,00 EURO",
      message: "<3",
      link: "https://samjw.xyz",
    ),
    SponsorList(
      avatarUrl: "",
      name: "FalixNodes (ItzAwesome)",
      donation: "£3.00 GBP",
      message: "Monthly Supporter <3",
      link: "https://falixnodes.host/",
    ),
    SponsorList(
      avatarUrl:
          "https://pbs.twimg.com/profile_images/1104864471581949952/q4wO6V9c_400x400.jpg",
      name: "Skoali",
      donation: "€5,00 EURO",
      message: "https://skoali.fr/",
      link: "https://skoali.fr/",
    ),
    SponsorList(
      avatarUrl:
          "https://raw.githubusercontent.com/rubentalstra/Pterodactyl-app/master/assets/images/discord2.png",
      name: "AccurateNode",
      donation: "€5,00 EURO",
      message: "https://accuratenode.com/",
      link: "https://accuratenode.com/",
    ),
  ];
}
