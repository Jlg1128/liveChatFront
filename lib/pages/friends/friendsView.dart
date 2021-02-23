import 'dart:async';

import 'package:app/myClasses/User.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../utils/shared_preferences_util.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../service/friends.dart';

class FriendsView extends StatefulWidget {
  User user;
  // 是否是添加状态
  bool ifAdd;
  FriendsView(User user, bool ifAdd) {
    this.user = user;
    this.ifAdd = ifAdd;
  }
  @override
  _FriendsViewState createState() => _FriendsViewState(this.user, this.ifAdd);
}

class _FriendsViewState extends State<FriendsView> {
  User user;
  // 是否是添加状态
  bool ifAdd;
  int uid;
  User me = null;

  // Map me = {
  //   "uid": -1,
  //   "phoneNumber": "",
  //   "avatar": "",
  //   "nickName": "",
  //   "signature": "",
  //   "email": "",
  // };

  Map targetUser = {
    'targetNickName': '',
    'targetAvatar': '',
    'targetId': '',
  };
  _FriendsViewState(User user, bool ifAdd) {
    this.user = user;
    this.targetUser = {
      'targetNickName': user.nickName,
      'targetAvatar': user.avatar,
      'targetId': user.uid,
    };
    this.ifAdd = ifAdd;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPreferencesUtil.getUid().then((int uid) {
      print("获取的用户id${uid}");
      setState(() {
        this.uid = uid;
      });
    });
    SharedPreferencesUtil.getUser().then((User user) {
      this.me = user;
    });
  }

  Widget buildAddButton() {
    return Container(
      margin: EdgeInsets.only(top: 100.0),
      width: MediaQuery.of(context).size.width * 0.8,
      child: RaisedButton(
          color: Colors.blue,
          onPressed: () {
            // quitService(this.userInfo['uid']);
            addFriend(this.uid, this.user.uid).then((Response response) {
              print(response.data);
              if (response.data['success'] == true) {
                Fluttertoast.showToast(
                    msg: "添加成功",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0);
                Future.delayed(Duration(milliseconds: 1200), () {
                  Navigator.pop(context, true);
                });
              } else {
                Fluttertoast.showToast(
                    msg: response.data['msg'],
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
            });
            // this.quitDialog();
          },
          child: Text(
            "添加对方为好友",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w400),
          )),
    );
  }

  Widget buildSendMessage() {
    return Container(
      margin: EdgeInsets.only(top: 100.0),
      width: MediaQuery.of(context).size.width * 0.8,
      child: RaisedButton(
          color: Colors.blue,
          onPressed: () {
            Navigator.pushNamed(context, '/chat', arguments: {
              "me": {
                "uid": this.me.uid,
                "phoneNumber": this.me.phoneNumber,
                "avatar": this.me.avatar,
                "nickName": this.me.nickName,
                "signature": this.me.signature,
                "email": this.me.email,
              },
              "target": {
                "targetNickName": this.user.nickName,
                "targetAvatar": this.user.avatar,
                'targetId': this.user.uid,
              }
            });
          },
          child: Text(
            "发送消息",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w400),
          )),
    );
  }

  Widget buildDeleteButton() {
    return Container(
      margin: EdgeInsets.only(top: 100.0),
      width: MediaQuery.of(context).size.width * 0.8,
      color: Colors.red,
      child: RaisedButton(
          color: Colors.red,
          onPressed: () {
            // quitService(this.userInfo['uid']);
            deleteFriend(this.uid, this.user.uid).then((Response response) {
              print(response.data);
              if (response.data['success'] == true) {
                Fluttertoast.showToast(
                    msg: "删除成功",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0);
                Navigator.of(context).pop(true);
              } else {
                Fluttertoast.showToast(
                    msg: response.data['msg'],
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
            });
            // this.quitDialog();
          },
          child: Text(
            "删除",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w400),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Container(
          child: Column(
        children: [
          Card(
              child: Column(
            children: [
              ListTile(
                leading: Container(
                  width: 60.0,
                  height: 60.0,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundImage: this.user.avatar == ""
                        ? null
                        : NetworkImage(this.user.avatar),
                  ),
                ),
                title: this.user.nickName == ""
                    ? Text("无")
                    : Text(this.user.nickName),
                subtitle:
                    this.user.email == "" ? Text("无") : Text(this.user.email),
              ),
            ],
          )),
          if (this.ifAdd == true) this.buildAddButton(),
          this.buildSendMessage(),
          if (this.ifAdd == false) this.buildDeleteButton()
        ],
      )),
    );
  }
}
