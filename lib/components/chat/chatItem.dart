import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../triangle.dart';
// import '../../assets/';

class ChatItem extends StatefulWidget {
  Map chatMessage = {
    'createTime': "",
    'msg': '',
    "sendId": '',
    "ifread": 0,
    "targetAvatar": "",
    "targetNickName": "",
    'targetId': '',
    "sendAvatar": '',
    "sendNickName": '',
    "targetIfread": 0,
    "chatId": '',
    "modifyTime": '',
    'type': '',
  };
  int uid = -1;
  String avatar = "";
  String targetAvatar = '';
  ChatItem(chatMessage, targetAvatar, uid, avatar) {
    this.chatMessage = chatMessage;
    this.targetAvatar = targetAvatar;
    this.uid = uid;
    this.avatar = avatar;
  }

  @override
  _ChatItemState createState() => _ChatItemState(
      this.chatMessage, this.targetAvatar, this.uid, this.avatar);
}

class _ChatItemState extends State<ChatItem> {
  bool isShow = false;
  bool isFail = false;
  int uid = -1;
  String avatar = "";
  String targetAvatar = '';
  Map chatMessage = {
    'createTime': "",
    'msg': '',
    "sendId": '',
    "ifread": 0,
    "targetAvatar": "",
    "targetNickName": "",
    'targetId': '',
    "sendAvatar": '',
    "sendNickName": '',
    "targetIfread": 0,
    "chatId": '',
    "modifyTime": '',
    'type': '',
  };
  _ChatItemState(chatMessage, targetAvatar, uid, avatar) {
    this.chatMessage = chatMessage;
    this.targetAvatar = targetAvatar;
    this.uid = uid;
    this.avatar = avatar;
  }
  @override
  Widget build(BuildContext context) {
    String direction =
        this.chatMessage['targetId'] == this.uid ? "left" : "right";
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: direction == 'left'
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.end,
              children: this.getChildren(direction, context),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> getChildren(direction, context) {
    // print(MediaQuery.of(context).size.width * 0.5);
    String type = this.chatMessage['type'];
    if (direction == 'left') {
      return [
        Image.network(
          this.targetAvatar,
          height: 35.0,
          width: 35.0,
        ),
        if (type == 'text')
          Transform.translate(
            offset: Offset(15.0, 18.0),
            child: Triganle('right', 9.0, Colors.green),
          ),
        Flexible(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.6,
            ),
            color: type == 'text' ? Colors.green : Colors.white,
            child: Padding(
              padding: type == 'text'
                  ? EdgeInsets.all(7.0)
                  : EdgeInsets.fromLTRB(10.0, 7.0, 0, 0),
              child: getMessageContent(type, context),
            ),
          ),
        )
      ];
    } else {
      return [
        Flexible(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.68,
            ),
            color: type == 'text' ? Colors.green : Colors.white,
            child: Padding(
              padding: type == 'text'
                  ? EdgeInsets.all(7.0)
                  : EdgeInsets.fromLTRB(0, 0, 10.0, 7.0),
              child: this.getMessageContent(type, context),
            ),
          ),
        ),
        if (type == 'text')
          Transform.translate(
            offset: Offset(-15.0, 18.0),
            child: Triganle('left', 9.0, Colors.green),
          ),
        if (this.avatar != "")
          Image.network(
            // 我的头像
            this.avatar,
            height: 35.0,
            width: 35.0,
          ),
      ];
    }
  }

  ImageProvider __addImageLoadListener(String url) {
    Image image = Image.network(
      url,
    );
    image.image
        .resolve(ImageConfiguration.empty)
        .addListener(ImageStreamListener((info, synchronousCall) {
          this.isShow = true;
        }, onChunk: (event) {}, onError: (_, err) {}));
    return image.image;
  }

  Widget getMessageContent(type, context) {
    // const jpdReg = r"/\.(jpg|png|gif)$/";
    // print(RegExp(jpdReg).hasMatch(msg));
    String ContentVal = this.chatMessage['msg'];
    switch (type) {
      case "text":
        return Text(
          ContentVal,
          // maxLines: 10,
        );
      case "image":
        print("图片");
        return Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8),
            child: FadeInImage(
              image: this.__addImageLoadListener(this.chatMessage['msg']),
              // TODO 未加载出来前的占位图
              placeholder: AssetImage("images/loadding.gif"),
              fit: BoxFit.fill,
              imageErrorBuilder: (context, error, stackTrace) {
                return Image.asset("images/error.png");
              },
            ));
      case "video":
        return Image.network(
          ContentVal,
          fit: BoxFit.contain,
          width: 70.0,
          height: 50.0,
        );
      default:
        return Text(
          ContentVal,
        );
    }
  }
}
