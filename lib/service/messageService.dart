import 'package:dio/dio.dart';
import './myDio.dart';

Future<Response> updateRead(targetId, sendId) async {
  print("连接消息sendId${sendId}");
  print("连接消息targetId${targetId}");
  Response response;
  try {
    response = await getMyDio().post("/chat/messageRead",
        data: {"targetId": targetId, "sendId": sendId});
  } catch (e) {
    print("更新失败");
    print(e);
  }
  print("更新成功");
  return response;
}

Future<Response> getMessageList(targetId, sendId) async {
  Response response;
  try {
    response = await getMyDio().get("/chat/getCurrentMsg",
        queryParameters: {"targetId": targetId, "sendId": sendId});
  } catch (e) {
    print("更新失败");
    print(e);
  }
  print("更新成功");
  return response;
}
