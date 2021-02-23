import 'package:app/service/socketIo.dart';
import 'package:flutter/material.dart';
import '../../components/messageItem.dart';
import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import '../../utils/util.dart';
import '../../service/messageService.dart';

class MessageList extends StatefulWidget {
  MessageList({Key key}) : super(key: key);

  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> with RouteAware {
  RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
  int uid = -0;
  Map me = {
    "uid": -1,
    "phoneNumber": "",
    "avatar": "",
    "nickName": "",
    "signature": "",
    "email": "",
  };
  EventBus eventBus = EventBus();
  SocketUtil socketUtil = null;
  List chatInfo = [];
  @override
  void initState() {
    getUid().then((uid) {
      setState(() {
        this.uid = int.parse(uid);
        this._getChatPersonList(this.uid);
        socketUtil = SocketUtil(this.uid.toString());
        Future.delayed(Duration(seconds: 1), () {
          print('🐶');
          print(this.uid.toString());
          socketUtil.socketEmitString(
              "setMessageListChange", this.uid.toString());
          socketUtil.registerEvent(this.uid.toString(), (val) {
            if (val != null && val is List && val.length > 0) {
              print('👹socketIo返回值');
              print(val);
              this._getChatPersonList(this.uid);
            }
            if (val == true) {
              print(val);
              this._getChatPersonList(this.uid);
            }
            print('💔');
            print(val);
          });
        });
      });
    });
    getUser().then((me) {
      setState(() {
        this.me = me;
      });
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPush() {
    final route = ModalRoute.of(context).settings.name;
    print('A-didPush route: $route');
  }

  @override
  void didPopNext() {
    final route = ModalRoute.of(context).settings.name;
    print('🐽A-didPopNext route: $route');
  }

  @override
  void didPushNext() {
    final route = ModalRoute.of(context).settings.name;
    print('A-didPushNext route: $route');
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    // var bool = ModalRoute.of(context).isCurrent;
  }

  @override
  void didPop() {
    final route = ModalRoute.of(context).settings.name;
    print('A-didPop route: $route');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    routeObserver.unsubscribe(this);
  }

  @override
  Widget build(BuildContext context) {
    print('我加载了。。。');
    return this.uid == -1 || this.chatInfo.length <= 0
        ? Container(
            alignment: Alignment.center,
            child: Text(
              "未接收到消息",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
            ))
        : Container(
            child: ListView(children: this._getListItems()),
          );
  }

  Function handleAvatarTap(uid, targetId, avatar, targetName, chatId) {
    void handle() {
      Navigator.pushNamed(context, '/chat', arguments: {
        "me": this.me,
        "target": {
          "targetNickName": targetName,
          "targetAvatar": avatar,
          'targetId': targetId,
          "chatId": chatId,
        }
      }).then((value) => this._getChatPersonList(this.uid));
    }

    return handle;
  }

  Function handleChatContentTap(uid, targetId, avatar, targetName, chatId) {
    void handle() {
      Navigator.pushNamed(context, '/chat', arguments: {
        "me": this.me,
        "target": {
          "targetNickName": targetName,
          "targetAvatar": avatar,
          'targetId': targetId,
          "chatId": chatId,
        }
      }).then((value) => this._getChatPersonList(this.uid));
    }

    return handle;
  }

  _getChatPersonList(int uid) async {
    print("fuck");
    try {
      Response response = await Dio()
          .get("http://localhost:8100/api/chat/getChatList", queryParameters: {
        "uid": uid,
      });
      setState(() {
        this.chatInfo = response.data['data'];
        print("聊天列表信息");
        print(chatInfo);
      });
    } catch (e) {
      print(e);
    }
  }

  List<Widget> _getListItems() {
    List<Widget> ListItems = [];
    for (var chatInfo in this.chatInfo) {
      bool ifReverse = chatInfo['targetId'] == this.uid ? true : false;
      String targetAvatar = chatInfo[ifReverse ? 'sendAvatar' : 'targetAvatar'];
      String targetNickName =
          chatInfo[ifReverse ? 'sendNickName' : 'targetNickName'];
      int targetId = chatInfo[ifReverse ? 'sendId' : 'targetId'];
      String chatId = chatInfo['chatId'];
      ListItems.add(MessageItem(
        targetAvatar,
        targetNickName,
        chatInfo['msg'],
        targetId.toString(),
        chatInfo['unreadMsgLength'],
        handleAvatarTap(uid, targetId, targetAvatar, targetNickName, chatId),
        handleChatContentTap(
            uid, targetId, targetAvatar, targetNickName, chatId),
      ));
    }
    return ListItems;
  }
}
