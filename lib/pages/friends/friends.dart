import 'dart:collection';

import 'package:app/myClasses/User.dart';
import 'package:dio/dio.dart';
import '../../components/friends/friendItem.dart';
import 'package:flutter/material.dart';
import '../../service/friends.dart';
import '../../utils/shared_preferences_util.dart';

class Friends extends StatefulWidget {
  Friends({Key key}) : super(key: key);

  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  int uid = -1;
  List<User> friendsList = [];

  Widget renderAddFriend() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, "/addFriends", arguments: () {
          this.getFriendListFirst(this.uid);
        });
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40.0,
            height: 40.0,
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(right: 15.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8), color: Colors.orange),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  "images/addfriends2.png",
                )),
          ),
          Text(
            "添加新的朋友",
            style: TextStyle(fontSize: 20.0),
          )
        ],
      ),
    );
  }

  renderFriendsList(List<User> friendsList) {
    return ListView.builder(
      itemBuilder: (_, index) {
        return FriendItem(
            friend: friendsList[index],
            ifAdd: false,
            cb: () {
              this.getFriendListFirst(this.uid);
            });
      },
      itemCount: friendsList.length,
    );
  }

  void getFriendListFirst(int uid) {
    getFriendList(uid).then((List<User> friendsList) {
      setState(() {
        this.friendsList = friendsList;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getFriendList()
    SharedPreferencesUtil.getData<String>("uid").then((value) {
      setState(() {
        this.uid = int.parse(value);
      });
      this.getFriendListFirst(this.uid);
    });
    // User user = User(
    //     avatar:
    //         "https://pic1.zhimg.com/80/v2-91582aebd85e13b1f0fd3711cecbb830_1440w.jpg",
    //     nickName: "yj",
    //     email: "yj.163.com",
    //     uid: 888,
    //     phoneNumber: "13858008854",
    //     signature: "天气不错");
    // this.friendsList = [user];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 10.0),
      child: ListView(
        children: [
          this.renderAddFriend(),
          this.friendsList == null
              ? Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.3),
                  child: Text(
                    "您暂无好友",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
                  ))
              : this.friendsList.isNotEmpty
                  ? Container(
                      constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.85),
                      child: renderFriendsList(this.friendsList),
                    )
                  : Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.3),
                      child: Text(
                        "加载中",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w400),
                      ),
                    )
        ],
      ),
    );
  }
}
