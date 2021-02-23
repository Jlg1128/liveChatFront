import 'package:app/myClasses/User.dart';
import 'package:flutter/material.dart';
import '../../service/userService.dart';
import '../../components/friends/friendItem.dart';

class AddFriends extends StatefulWidget {
  Function cb;
  AddFriends({
    Key key,
    this.cb,
  }) : super(key: key);

  @override
  _AddFriendsState createState() => _AddFriendsState(cb: this.cb);
}

class _AddFriendsState extends State<AddFriends> {
  User searchUser = null;
  bool noUser = false;
  Function cb;
  _AddFriendsState({this.cb});
  var _targetIdOrNickNameController = new TextEditingController();
  Widget buildSearchResult() {
    if (this.searchUser != null) {
      return Container(
        padding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 0),
        child: FriendItem(
            friend: this.searchUser,
            ifAdd: true,
            cb: () {
              this.cb();
            }),
      );
    } else if (this.searchUser == null && this.noUser == true) {
      return Container(
        padding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 0),
        alignment: Alignment.center,
        child: Text("未找到对应用户"),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("添加好友"),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 10.0),
        child: ListView(children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: TextField(
                    controller: this._targetIdOrNickNameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      labelText: "uid/用户名",
                      border: UnderlineInputBorder(),
                      focusColor: Colors.blue,
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      String idOrNickName =
                          this._targetIdOrNickNameController.text;
                      setState(() {
                        if (RegExp(r"[0-9]+$").hasMatch(idOrNickName) == true) {
                          getUserByUserId(int.parse(idOrNickName))
                              .then((User user) {
                            if (user != null) {
                              setState(() {
                                this.searchUser = user;
                                this.noUser = false;
                              });
                            } else {
                              setState(() {
                                this.searchUser = null;
                                this.noUser = true;
                              });
                            }
                          });
                        } else {
                          getUserByNickName(idOrNickName).then((User user) {
                            if (user != null) {
                              setState(() {
                                this.searchUser = user;
                                this.noUser = false;
                              });
                            } else {
                              setState(() {
                                this.searchUser = null;
                                this.noUser = true;
                              });
                            }
                          });
                        }
                      });
                    },
                    child: Text("搜索")),
              ],
            ),
          ),
          this.buildSearchResult(),
        ]),
      ),
    );
  }
}
