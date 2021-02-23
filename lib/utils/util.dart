import 'package:shared_preferences/shared_preferences.dart';

bool ifImg(msg) {
  const jpdReg = r"\.(jpg|png|gif)";
  RegExp(jpdReg).hasMatch(msg);
}

List<Map> mapToList(Map map) {
  List<Map> list = [];
  map.forEach((key, value) {
    list.add({key: value});
  });
  return list;
}

Future<String> getUid() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.get("uid");
}

Future<Map> getUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int uid = int.parse(prefs.getString("uid"));
  String phoneNumber = prefs.getString("phoneNumber");
  String avatar = prefs.getString("avatar");
  String nickName = prefs.getString("nickName");
  String signature = prefs.getString("signature");
  String email = prefs.getString("email");
  Map user = {
    "uid": uid,
    "phoneNumber": phoneNumber,
    "avatar": avatar,
    "nickName": nickName,
    "signature": signature,
    "email": email,
  };
  return user;
}
