class SponsorList {
  final String avatarUrl;
  final String name;
  final String datetime;
  final String message;
  final String link;

  SponsorList(
      {this.avatarUrl, this.name, this.datetime, this.message, this.link});

  static final List<SponsorList> dummyData = [
    SponsorList(
      avatarUrl:
          "https://s3-eu-west-1.amazonaws.com/tpd/logos/5c033220e32b98000128f214/0x0.png",
      name: "Thunderbolt Hosting",
      datetime: "Apple License",
      message: "https://thunderbolt-hosting.com/",
      link: "https://thunderbolt-hosting.com/",
    ),
    SponsorList(
      avatarUrl: "https://i.coderslight.com/CodersLight_Logo.png",
      name: "CodersLight LLC",
      datetime: "\$ 25.00 CAD",
      message: "https://coderslight.com/",
      link: "https://coderslight.com/",
    ),
    SponsorList(
      avatarUrl:
          "https://raw.githubusercontent.com/rubentalstra/Pterodactyl-app/master/assets/images/minicenter_logo.png",
      name: "MiniCenter",
      datetime: "\$ 21.53 CAD",
      message: "https://www.minicenter.net/",
      link: "https://www.minicenter.net/",
    ),
    SponsorList(
      avatarUrl:
          "https://pbs.twimg.com/profile_images/1010254773826793472/vjxA9idJ_400x400.jpg",
      name: "deploys.io",
      datetime: "Website and WebHost",
      message: "https://deploys.io/",
      link:
          "https://deploys.io/share/104?utm_source=ruben-app&utm_medium=sponsors&utm_campaign=list",
    ),
    SponsorList(
      avatarUrl: "https://avatars0.githubusercontent.com/u/50382144?s=460&v=4",
      name: "Jordy",
      datetime: "Android License",
      message: "",
      link: "",
    ),
    SponsorList(
      avatarUrl:
          "https://pbs.twimg.com/profile_images/1104864471581949952/q4wO6V9c_400x400.jpg",
      name: "Skoali",
      datetime: "€ 5,00 EURO",
      message: "https://skoali.fr/",
      link: "https://skoali.fr/",
    ),
    SponsorList(
      avatarUrl:
          "https://raw.githubusercontent.com/rubentalstra/Pterodactyl-app/master/assets/images/discord2.png",
      name: "AccurateNode",
      datetime: "€ 5,00 EURO",
      message: "https://accuratenode.com/",
      link: "https://accuratenode.com/",
    ),
  ];
}
