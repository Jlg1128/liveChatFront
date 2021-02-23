import 'package:app/myClasses/User.dart';
import 'package:dio/dio.dart';

import './myDio.dart';

Map<String, String> friendsApi = {
  "getAllFriends": "/user/getFriendsList",
  "addFriend": "/user/addFriends",
  "deleteFriend": "/user/deleteFriends",
};

Future<List<User>> getFriendList(int uid) async {
  List<User> friendsList = [];
  final response =
      await getMyDio().get(friendsApi['getAllFriends'], queryParameters: {
    "uid": uid,
  });
  final List<dynamic> body = response.data['data'];
  if (response.data['data'] == null) {
    return null;
  }
  for (var data in body) {
    friendsList.add(User.fromJson(data));
  }
  return friendsList;
}

Future<Response> addFriend(int uid, int targetId) {
  return getMyDio()
      .post(friendsApi['addFriend'], data: {"uid": uid, "targetId": targetId});
}

Future<Response> deleteFriend(int uid, int targetId) {
  return getMyDio().post(friendsApi['deleteFriend'],
      data: {"uid": uid, "targetId": targetId});
}
