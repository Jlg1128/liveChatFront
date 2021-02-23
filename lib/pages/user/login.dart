import 'package:app/service/userService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../service/myDio.dart';
import '../../utils/shared_preferences_util.dart';

SharedPreferences preferences;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var _userName = new TextEditingController();
  var _password = new TextEditingController();
  bool loginError = false;
  String errorText = "";
  void setUserInfo(Map userInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("phoneNumber", userInfo['phoneNumber']);
    prefs.setString("avatar", userInfo['avatar']);
    prefs.setString("nickName", userInfo['nickName']);
    prefs.setString("signature", userInfo['signature']);
    prefs.setString("email", userInfo['email']);
    prefs.setString("uid", userInfo['uid']);
  }

  void clearLoginErrorStatus() {
    if (this.loginError == true)
      setState(() {
        this.loginError = false;
        this.errorText = '';
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("用户登录"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Container(
          width: 300.0,
          height: 300.0,
          // color: Colors./green,
          child: Column(
            children: <Widget>[
              TextField(
                cursorColor: Colors.blue,
                controller: this._userName,
                decoration: InputDecoration(
                  labelText: "用户名",
                  border: OutlineInputBorder(),
                  hoverColor: Colors.blue,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                onChanged: (value) {
                  if (this.loginError == true) {
                    clearLoginErrorStatus();
                  }
                },
              ),
              SizedBox(height: 20),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "密码",
                  border: OutlineInputBorder(),
                  focusColor: Colors.blue,
                ),
                controller: this._password,
                onChanged: (value) {
                  if (this.loginError == true) {
                    clearLoginErrorStatus();
                  }
                },
              ),
              SizedBox(height: 10),
              if (this.loginError == true && this.errorText != "")
                Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      this.errorText,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                child: TextButton(
                  onPressed: () async {
                    login(this._userName.text, this._password.text)
                        .then((value) {
                      if (value.data != null &&
                          value.data['success'] == false &&
                          value.data['msg'] != null) {
                        setState(() {
                          this.loginError = true;
                          this.errorText = value.data['msg'];
                        });
                      } else {
                        setState(() {
                          this.loginError = false;
                          this.errorText = "";
                        });
                        this.setUserInfo(value.data['data']);
                        Navigator.pushReplacementNamed(context, "/");
                      }
                    });
                  },
                  child: Text(
                    "登录",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue)),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                width: double.infinity,
                child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/register");
                      },
                      child: Text(
                        "没有账号？去注册",
                        style: TextStyle(color: Colors.blue),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
