import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  // Settings({Key key}) : super(key: key);

  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Settings> {
  Map userInfo = {
    "uid": "",
    "avatar": "",
    "nickName": "",
    "signature": "",
    "email": ""
  };

  @override
  void initState() {
    this.setUserInfo();
  }

  void quit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.pushReplacementNamed(context, "/login");
  }

  void quitDialog() async {
    var result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("退出"),
            content: Text(
              "确定退出吗",
              textAlign: TextAlign.center,
            ),
            actions: [
              RaisedButton(
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("取消")),
              RaisedButton(
                  color: Colors.blue,
                  onPressed: () {
                    this.quit();
                  },
                  child: Text("确定")),
            ],
          );
        });
    print(result);
  }

  void setUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String avatar = prefs.getString("avatar") == null
        ? "https://pic1.zhimg.com/80/v2-6afa72220d29f045c15217aa6b275808_1440w.jpg"
        : prefs.getString("avatar");
    String uid = prefs.getString("uid");
    String nickName = prefs.getString("nickName");
    String signature = prefs.getString("signature") == ""
        ? "暂无个性签名"
        : prefs.getString("signature");
    String email = prefs.getString("email");
    setState(() {
      this.userInfo = {
        "uid": uid,
        "avatar": avatar,
        "nickName": nickName,
        "signature": signature,
        "email": email
      };
    });
  }

  Widget renderUserInfo() {
    print(this.userInfo['avatar']);
    return this.userInfo['uid'] == null
        ? Container(
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, "/login");
              },
              child: Text(
                "您还未登录，请先登录",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          )
        : Card(
            child: Column(
            children: [
              ListTile(
                leading: Container(
                  width: 60.0,
                  height: 60.0,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundImage: this.userInfo['avatar'] == ""
                        ? null
                        : NetworkImage(this.userInfo['avatar']),
                  ),
                ),
                title: this.userInfo['nickName'] == ""
                    ? Text("无")
                    : Text(this.userInfo['nickName']),
                subtitle: this.userInfo['email'] == ""
                    ? Text("无")
                    : Text(this.userInfo['email']),
              ),
            ],
          ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        this.renderUserInfo(),
        if (this.userInfo['uid'] != null)
          Container(
            margin: EdgeInsets.only(top: 100.0),
            width: MediaQuery.of(context).size.width * 0.8,
            child: RaisedButton(
                color: Colors.blue,
                onPressed: () {
                  // quitService(this.userInfo['uid']);
                  this.quitDialog();
                },
                child: Text(
                  "退出",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w400),
                )),
          )
      ],
    );
  }
}
