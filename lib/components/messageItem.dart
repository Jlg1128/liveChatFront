import 'package:flutter/material.dart';

class MessageItem extends StatelessWidget {
  String targetAvatar = '';
  String targetNickName = '';
  String targetLastSay = '';
  String targetId = '';
  int unReadMessageLength = 0;
  Function onAvatarTap = () {};
  Function onContentTap = () {};
  MessageItem(
    String targetAvatar,
    String targetNickName,
    String targetLastSay,
    String targetId,
    int unReadMessageLength,
    Function onAvatarTap,
    Function onContentTap,
  ) {
    this.targetAvatar = targetAvatar;
    this.targetNickName = targetNickName;
    this.targetLastSay = targetLastSay;
    this.unReadMessageLength = unReadMessageLength;
    this.targetId = targetId;
    this.onAvatarTap = onAvatarTap;
    this.onContentTap = onContentTap;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Container(
            width: 50.0,
            height: 50.0,
            child: InkWell(
              child: Image.network(
                this.targetAvatar,
              ),
              onTap: () {
                this.onAvatarTap();
              },
            ),
          ),
          Expanded(
              child: InkWell(
                  onTap: () {
                    // navat
                    this.onContentTap();
                  },
                  child: Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 50.0,
                        // color: Colors.yellow,
                        margin: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              this.targetNickName,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 3.0,
                            ),
                            Text(this.targetLastSay),
                          ],
                        ),
                      ),
                      this.unReadMessageLength > 0
                          ? Container(
                              margin: EdgeInsets.only(right: 20.0),
                              width: 20.0,
                              height: 20.0,
                              decoration: new BoxDecoration(
                                // border: new Border.all(
                                //     color: Colors.red, width: 0.5), // 边色与边宽度
                                color: Colors.red, // 底色
                                borderRadius:
                                    new BorderRadius.circular((20.0)), // 圆角度
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  this.unReadMessageLength.toString(),
                                  style: TextStyle(
                                      fontSize: 10.0, color: Colors.white),
                                ),
                              ))
                          : Container(
                              child: null,
                            ),
                    ],
                  )))
        ],
      ),
    ));
  }
}
