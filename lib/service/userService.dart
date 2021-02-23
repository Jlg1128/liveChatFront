import 'package:app/config.dart';
import 'package:app/myClasses/User.dart';
import 'package:dio/dio.dart';
import './myDio.dart';

Map<String, String> userApiMap = {
  "login": "/user/login",
  "register": "/user/register",
  "updateAvatar": "/user/updateAvatar",
  "getUserByNickName": "/user/getUserByNickName",
  "getUserByUserId": "/user/getUserByUserId",
  "quit": "/user/quit",
};

Future<Response> login(
  String nickName,
  String password,
) {
  return getMyDio().post(userApiMap['login'], data: {
    "nickName": nickName,
    "password": password,
  });
}

Future<Response> register(String nickName, String password, String email) {
  return getMyDio().post(userApiMap['register'], data: {
    "nickName": nickName,
    "password": password,
    "email": email,
    "avatar": defaultAvatar
    // "phoneNumber": phoneNumber
  });
}

Future<Response> quitService(String uid) {
  return getMyDio().post(userApiMap['quit'], data: {
    "uid": uid,
  });
}

Future<Response> updateAvatar(
  int uid,
  String avatar,
) {
  return getMyDio()
      .post(userApiMap['updateAvatar'], data: {"uid": uid, "avatar": avatar});
}

Future<User> getUserByNickName(
  String nickName,
) async {
  final response =
      await getMyDio().get(userApiMap['getUserByNickName'], queryParameters: {
    "nickName": nickName,
  });
  if (response.data['data'] != null) {
    return User.fromJson(response.data['data']);
  }
  return null;
}

Future<User> getUserByUserId(
  int uid,
) async {
  final response =
      await getMyDio().get(userApiMap['getUserByUserId'], queryParameters: {
    "uid": uid,
  });
  if (response.data['data'] != null) {
    return User.fromJson(response.data['data']);
  }
  return null;
}
