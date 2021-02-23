import 'dart:async';

import 'package:app/components/chat/chatSys.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../utils/imagePickUtil.dart';
import 'package:app/service/socketIo.dart';
import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../components/triangle.dart';
import '../../components/chat/chatItem.dart';
// import '../../common/global.dart';
import './chatMessageData.dart';
import '../../utils/util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../pages/messageList/messageList.dart';
import 'package:app/components/chat/chatSys.dart';
import '../../utils/util.dart';
import '../../service/messageService.dart';

class ChatPage extends StatefulWidget {
  Map users = {"target": {}, "me": {}};
  ChatPage({users}) {
    print("ChatPage信息");
    print(users);
    this.users = users;
  }

  @override
  _ChatPageState createState() => _ChatPageState(users: this.users);
}

enum SendStatus { TEXT, EMOTION, MORE, VIDEO, PICTURE }

class _ChatPageState extends State<ChatPage> with RouteAware {
  ScrollController scrollController = ScrollController();
  SendStatus sendStatus = SendStatus.TEXT;
  String sendMsg = '';
  List chatMessageList = [];
  EventBus eventBus = EventBus();
  SocketUtil socketUtil = null;
  Map targetUser = {
    'targetNickName': '',
    'targetAvatar': '',
    'targetId': '',
  };
  int uid = -1;
  int targetId = -2;
  Map me = {
    "uid": -1,
    "phoneNumber": "",
    "avatar": "",
    "nickName": "",
    "signature": "",
    "email": "",
  };

  String chatId = '';

  _ChatPageState({users}) {
    Map me = users['me'];
    Map targetUser = users['target'];
    int targetId = targetUser['targetId'];
    int uid = me['uid'];
    this.uid = uid;
    this.targetId = targetId;
    getUser().then((me) {
      setState(() {
        this.me = me;
      });
    });
    this.targetUser = targetUser;
    // this.chatId = targetId > uid
    //     ? this.uid.toString() + this.targetId.toString()
    //     : this.targetId.toString() + this.uid.toString();
    this.chatId = uid.toString() + "-" + targetId.toString();

    this._userName.text = '';
    socketUtil = SocketUtil(this.chatId);
    Future.delayed(Duration(seconds: 1), () {
      socketUtil.socketEmitString("setUid", this.chatId);
      socketUtil.registerEvent(this.chatId, (val) {
        if (val != null && val is List && val.length > 0) {
          print('👹socketIo返回值');
          print(val);
          setState(() {
            this.chatMessageList = val;
          });
        }
      });
    });
  }

  FocusNode _focusNode = FocusNode();
  var _userName = new TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateRead(this.uid, this.targetId);
    getMessageList(this.targetId, this.uid).then((response) {
      setState(() {
        this.chatMessageList = response.data['data'];
      });
    });
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        print("聚焦了");
      } else {
        print("失去焦点");
        // this._userName.text = '请输入';
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    this.socketUtil.unSubcribeEvent(this.chatId);
    this.socketUtil.disconnect();
  }

  void saveUserChat(String msg) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.chatId, msg);
  }

  sendMessages(sendBody) async {
    Response response;
    socketUtil.socketEmitMap(this.chatId, sendBody);
    saveUserChat(this.sendMsg);
  }

  buildMessageView(chatMessageList, targetAvatar) {
    this.jumpToBottom(chatMessageList);
    return ListView.builder(
      controller: this.scrollController,
      // reverse: true,
      itemBuilder: (_, index) {
        return ChatItem(this.chatMessageList[index], targetAvatar, this.uid,
            this.me['avatar']);
      },
      itemCount: chatMessageList.length,
    );
  }

  void jumpToBottom(chatMessageList) {
    if (chatMessageList.length > 1) {
      Timer(
          Duration(milliseconds: 500),
          () => scrollController
              .jumpTo(scrollController.position.maxScrollExtent));
    }
  }

  Object createMsg(msg) {
    print(this.targetId);
    print('avatar${this.targetUser['targetNickName']}');
    print('avatar${this.me['nickName']}');
    print(this.me['avatar']);
    print({
      "targetId": this.targetId,
      'sendId': this.uid,
      'msg': msg,
      "chatId": this.chatId,
      'targetAvatar': this.targetUser['targetAvatar'],
      'targetNickName': this.targetUser['targetNickName'],
      'sendAvatar': this.me['avatar'],
      'sendNickName': this.me['nickName']
    });
    return {
      "targetId": this.targetId,
      'sendId': this.uid,
      'msg': msg,
      "chatId": this.chatId,
      'targetAvatar': this.targetUser['targetAvatar'],
      'targetNickName': this.targetUser['targetNickName'],
      'sendAvatar': this.me['avatar'],
      'sendNickName': this.me['nickName']
    };
  }

  List<Map> sortMessageList(chatMessageList) {
    chatMessageList.sort((left, right) => int.parse(left['createTime'])
        .compareTo(int.parse(right['createTime'])));
    return chatMessageList;
  }

  Widget myAddIcon() {
    return InkWell(
      child: Container(
        color: Colors.white,
        alignment: Alignment.center,
        height: 38.0,
        width: 38.0,
        child: CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: this.sendMsg == ""
              ? AssetImage("images/add.png")
              : AssetImage("images/send.png"),
          radius: 60,
        ),
      ),
      onTap: () {
        if (this.sendMsg == "") {
          setState(() {
            this.sendStatus = SendStatus.MORE;
          });
        } else {
          // 创建msg对象
          print(this.sendMsg);
          setState(() {
            this.sendMessages(this.createMsg(
              this.sendMsg,
            ));
            this.sendMsg = "";
            this._userName.text = "";
            print("this.sendMsg${this.sendMsg}");
          });
        }
      },
    );
  }

  Widget mySmileIcon() {
    return InkWell(
      child: Container(
        alignment: Alignment.center,
        height: 38.0,
        width: 38.0,
        child: CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: AssetImage("images/smile.png"),
          radius: 60,
        ),
      ),
      onTap: () {
        setState(() {
          // this.sendStatus = SendStatus.MORE;
        });
      },
    );
  }

  Widget mySpeakIcon() {
    return InkWell(
      child: Container(
        alignment: Alignment.center,
        height: 42.0,
        width: 42.0,
        child: CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: AssetImage("images/speak.png"),
          radius: 60,
        ),
      ),
      onTap: () {
        print("说话");
        setState(() {
          // this.sendStatus = SendStatus.MORE;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, "不知道");
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(this.targetUser['targetNickName']),
          ),
          body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () async {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Stack(
              children: [
                Container(
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.85),
                    child:
                        //  ListView(
                        //   // 列表从底部开始
                        //   // reverse: true,
                        //   controller: this.scrollController,
                        //   children: [ChatSys(this.sortMessageList(chatMessageList))],
                        // ),
                        this.buildMessageView(this.chatMessageList,
                            this.targetUser['targetAvatar'])),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      // color: Colors,
                      padding: EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
                      child: Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          this.mySpeakIcon(),
                          Container(
                            color: Colors.white,
                            height: 50.0,
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: TextField(
                              controller: this._userName,
                              onChanged: (value) {
                                setState(() {
                                  this.sendMsg = value;
                                });
                              },
                              focusNode: this._focusNode,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                fillColor: Colors.yellow,
                              ),
                            ),
                          ),
                          this.mySmileIcon(),
                          this.myAddIcon(),
                        ],
                      ),
                    ),
                    if (this.sendStatus == SendStatus.MORE)
                      Container(
                        // alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    color:
                                        Color.fromRGBO(122, 122, 122, 0.4)))),
                        height: 200.0,
                        // color: Colors.blue,
                        padding: EdgeInsets.fromLTRB(12.0, 12.0, 0, 12.0),
                        child: Flex(
                          direction: Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              child: Container(
                                margin: EdgeInsets.only(right: 12.0),
                                width: 80.0,
                                height: 80.0,
                                child: Image.asset(
                                  "images/picture.png",
                                ),
                              ),
                              onTap: () {
                                ImagePickerUtil().getImageFromGallery();
                                print("上传图片");
                              },
                            )
                          ],
                        ),
                      )
                  ],
                )
              ],
            ),
          )),
    );
  }
}
