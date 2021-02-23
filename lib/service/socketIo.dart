import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../common/global.dart';

String socketAddress = "http://127.0.0.1:8098";

class SocketUtil {
  IO.Socket mysocket;
  String chatId = '';
  SocketUtil(String chatId) {
    void listenWebSocket() {
      print("连接中");
      // 构建请求头，可以放一些cookie等信息，这里加上了origin，因为服务端有origin校验
      Map<String, dynamic> headers = new Map();
      headers['origin'] = 'http://127.0.0.1:8098';
      // 建立websocket链接
      // 链接的书写规范，schame://host:port/namespace, 这里socket_io_client在处理链接时候会把path和后面的query参数都作为namespace来处理，所以如果我们的namespace是/的话，就直接使用http://host/
      this.mysocket = IO.io(socketAddress, <String, dynamic>{
        // 请求的path
        // 构造的header放这里
        'extraHeaders': headers,
        // 查询参数，扔这里
        // 说明需要升级成websocket链接
        'transports': ['websocket'],
        // 断开强制生成新连接
        'force new connection': true
      });
      this.mysocket.on('connect', (_) {
        // this.mysocket.id = 'socketId1cbb86da-c2bf-4a7a-9e96-cf21959bb41e';
        if (socketMap[chatId] == null) {
          socketMap.addAll({chatId: this.mysocket});
        }
        print("成功连接");
      });
      this.mysocket.on('connecting', (_) {
        print("连接中");
        print(this.mysocket);
        // this.mysocket.id = 'socketId1cbb86da-c2bf-4a7a-9e96-cf21959bb41e';
        // print("socketId:${this.mysocket.id}");
        print("成功连接");
      });
      // 链接建立失败时调用
      this.mysocket.on('error', (data) {
        print('error');
        print(data);
      });
      // 链接出错时调用
      this.mysocket.on("connect_error", (data) => print('connect_error: '));
      // 链接断开时调用
      this.mysocket.on('disconnect', (_) => print('disconnect======'));
      // 链接关闭时调用
      this.mysocket.on('close', (_) => print('close===='));
    }

    listenWebSocket();
  }

  void socketEmitMap(String eventName, Map msg) {
    print('eventName${eventName}');
    print(msg);
    this.mysocket.emit(eventName, msg);
  }

  void socketEmitString(String eventName, String msg) {
    print('eventName${eventName}');
    Future.delayed(Duration(seconds: 1), () {
      this.mysocket.emit(eventName, msg.toString());
    });
  }

  void registerEvent(String eventName, Function cb) {
    print("注册事件名称" + eventName);
    this.mysocket.on(eventName, (data) => cb(data));
    // this.mysocket.
  }

  String closeSocket() {
    this.mysocket.disconnect();
    return "成功";
  }

  void unSubcribeEvent(String eventName) {
    this.mysocket.off(eventName);
  }

  void disconnect() {
    this.mysocket.disconnect();
  }

  void reconnect() {
    if (this.mysocket.disconnected && socketMap[this.chatId] != null) {
      socketMap[this.chatId].connect();
    }
  }
}
