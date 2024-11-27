import 'package:rive/rive.dart';

class RiveAsset {
  final String artboard, stateMachineName, title, src;
  late SMIBool? input;

  RiveAsset(this.src,
  {required this.artboard,
  required this.stateMachineName,
  required this.title,
  this.input});

  set setInput(SMIBool status){
    input = status;
  }
}

List<RiveAsset> bottomNavs = [
  RiveAsset("lib/RiveAssets/icons.riv", artboard: "CHAT", stateMachineName: "CHAT_Interactivity", title: "Chat"),
  RiveAsset("lib/RiveAssets/icons.riv", artboard: "SEARCH", stateMachineName: "SEARCH_Interactivity", title: "Search"),
  RiveAsset("lib/RiveAssets/icons.riv", artboard: "TIMER", stateMachineName: "TIMER_Interactivity", title: "Chat"),
  RiveAsset("lib/RiveAssets/icons.riv", artboard: "BELL", stateMachineName: "BELL_Interactivity", title: "Notifications"),
  RiveAsset("lib/RiveAssets/icons.riv", artboard: "USER", stateMachineName: "USER_Interactivity", title: "Profile"),
];

List<RiveAsset> sideMenus = [
  RiveAsset("lib/RiveAssets/icons.riv", artboard: "HOME", stateMachineName: "HOME_interactivity", title: "HOME"),
  RiveAsset("lib/RiveAssets/icons.riv", artboard: "USER", stateMachineName: "USER_Interactivity", title: "VOTERS"),
  RiveAsset("lib/RiveAssets/icons.riv", artboard: "LIKE/STAR", stateMachineName: "STAR_Interactivity", title: "CANDIDATES"),
  RiveAsset("lib/RiveAssets/icons.riv", artboard: "LIKE/STAR", stateMachineName: "STAR_Interactivity", title: "APPLICATION"),
  RiveAsset("lib/RiveAssets/icons.riv", artboard: "TIMER", stateMachineName: "TIMER_Interactivity", title: "SCHEDULE"),
];

