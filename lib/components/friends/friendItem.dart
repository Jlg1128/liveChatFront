import 'package:app/myClasses/User.dart';
import 'package:flutter/material.dart';

class FriendItem extends StatefulWidget {
  User friend;
  User me;
  bool ifAdd;
  Function cb;
  FriendItem({this.friend, this.ifAdd, this.cb});

  @override
  _FriendItemState createState() =>
      _FriendItemState(friend: this.friend, ifAdd: this.ifAdd, cb: this.cb);
}

class _FriendItemState extends State<FriendItem> {
  User friend;
  bool ifAdd;
  bool justRerender;
  Function cb;

  _FriendItemState({this.friend, this.ifAdd, this.cb});
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          if (ifAdd == true) {
            Navigator.pushReplacementNamed(context, "/friendsView", arguments: {
              "targetUser": friend,
              "ifAdd": this.ifAdd,
            }).then((ifModified) {
              if (ifModified == true) {
                this.cb();
              }
            });
          } else {
            Navigator.pushNamed(context, "/friendsView", arguments: {
              "targetUser": friend,
              "ifAdd": this.ifAdd,
            }).then((ifModified) {
              if (ifModified == true) {
                this.cb();
              }
            });
          }
        },
        child: Container(
          width: 40.0,
          height: 40.0,
          margin: EdgeInsets.only(top: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(right: 15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      friend.avatar,
                      width: 40.0,
                      height: 40.0,
                    )),
              ),
              Text(
                friend.nickName,
                style: TextStyle(fontSize: 20.0),
              )
            ],
          ),
        ));
  }
}
