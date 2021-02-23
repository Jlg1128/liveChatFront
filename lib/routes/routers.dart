import 'package:flutter/material.dart';
import '../pages/user/login.dart';
import '../pages/setting/setting.dart';
import '../pages/messageList/messageList.dart';
import '../pages/user/register.dart';
import '../pages/friends/friends.dart';
import '../pages/friends/friendsView.dart';
import '../pages/friends/addFriends.dart';
import '../pages/messageList/chat.dart';
import '../pages/index.dart';

final routes = {
  '/': (context) => MyIndex(1),
  '/messageList': (context) => MessageList(),
  '/friends': (context) => Friends(),
  '/friendsView': (context, {arguments}) =>
      FriendsView(arguments['targetUser'], arguments['ifAdd']),
  '/addFriends': (context, {arguments}) => AddFriends(
        cb: arguments,
      ),
  '/settings': (context) => Settings(),
  '/login': (context) => Login(),
  '/register': (context) => Register(),
  '/chat': (context, {arguments}) => ChatPage(
        users: arguments,
      ),
  // '/chat': (context) => ChatPage(),
};

Function PageBuild(name) {
  return routes[name];
}

// class s
Function onGenerateRoute() {
  return (RouteSettings settings) {
    print(settings.arguments);
    String pathName = settings.name;
    if (settings.arguments != null) {
      return MaterialPageRoute(
          builder: (context) =>
              PageBuild(pathName)(context, arguments: settings.arguments));
    } else {
      return MaterialPageRoute(
          builder: (context) => PageBuild(pathName)(context));
    }
  };
}
