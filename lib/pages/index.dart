import 'package:flutter/material.dart';
import './messageList/messageList.dart';
import '../pages/user/login.dart';
import './friends/friends.dart';
import './setting/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyIndex extends StatefulWidget {
  // MyIndex({Key key}) : super(key: key);
  int currentIndex = 0;
  MyIndex(int currentIndex) {
    this.currentIndex = currentIndex;
  }
  @override
  _IndexState createState() => _IndexState(currentIndex);
}

class _IndexState extends State<MyIndex> {
  int currentIndex = 1;
  _IndexState(int currentIndex) {
    this.currentIndex = currentIndex;
  }
  List<Widget> tapItemList = [
    MessageList(),
    Friends(),
    Settings(),
  ];
  Future<String> getFirstPagePath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get("uid") == null) {
      Navigator.of(context).push(this._createRoute());
    }

    return prefs.get("uid") == null ? "/login" : "/";
  }

  Route _createRoute() {
    print("cao");
    return PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) => Login(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 1.0);
          var end = Offset(0.0, 0.0);
          var tween = Tween(begin: begin, end: end);
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getFirstPagePath();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "消息",
            textAlign: TextAlign.left,
          ),
        ),
        body: this.tapItemList[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: this.currentIndex,
          onTap: (tapIndex) {
            setState(() {
              this.currentIndex = tapIndex;
            });
          },
          items: [
            BottomNavigationBarItem(
              title: Text("聊天"),
              icon: Icon(Icons.chat),
            ),
            BottomNavigationBarItem(
              title: Text("好友"),
              icon: Icon(Icons.people),
            ),
            BottomNavigationBarItem(
                title: Text("我的"),
                icon: Icon(
                  Icons.settings,
                ))
          ],
        ),
      ),
    );
  }
}
