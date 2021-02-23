import 'package:app/myClasses/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  static saveData<T>(String key, T value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    switch (T) {
      case String:
        await prefs.setString(key, value as String);
        break;
      case int:
        await prefs.setInt(key, value as int);
        break;
      case bool:
        await prefs.setBool(key, value as bool);
        break;
      case double:
        await prefs.setDouble(key, value as double);
        break;
    }
  }

  static Future<int> getUid<T>() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return int.parse(prefs.getString("uid"));
  }

  static Future<User> getUser<T>() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String avatar = prefs.getString("avatar");
    int uid = int.parse(prefs.getString("uid"));
    String nickName = prefs.getString("nickName");
    String signature = prefs.getString("signature") == ""
        ? "暂无个性签名"
        : prefs.getString("signature");
    String email = prefs.getString("email");
    String phoneNumber = prefs.getString("phoneNumber");

    User user = User(
        avatar: avatar,
        uid: uid,
        nickName: nickName,
        signature: signature,
        email: email,
        phoneNumber: phoneNumber);
    return user;
  }

  /// 读取数据
  static Future<T> getData<T>(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    T res;
    switch (T) {
      case String:
        res = prefs.getString(key) as T;
        break;
      case int:
        res = prefs.getInt(key) as T;
        break;
      case bool:
        res = prefs.getBool(key) as T;
        break;
      case double:
        res = prefs.getDouble(key) as T;
        break;
    }
    return res;
  }
}
