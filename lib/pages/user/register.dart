import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../service/userService.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var _userName = new TextEditingController();
  var _password = new TextEditingController();
  var _email = new TextEditingController();
  var _phoneNumber = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("注册"),
      ),
      body: Center(
        child: Container(
          width: 300.0,
          height: 500.0,
          // color: Colors./green,
          child: Column(
            children: <Widget>[
              TextField(
                controller: this._userName,
                decoration: InputDecoration(
                    labelText: "用户名", border: OutlineInputBorder()),
              ),
              SizedBox(height: 20),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                    labelText: "密码", border: OutlineInputBorder()),
                controller: this._password,
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                    labelText: "邮箱", border: OutlineInputBorder()),
                controller: this._email,
              ),
              // TextField(
              //   obscureText: true,
              //   decoration: InputDecoration(
              //       labelText: "邮箱", border: OutlineInputBorder()),
              //   controller: this._email,
              // ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    register(
                      this._userName.text,
                      this._password.text,
                      this._email.text,
                    ).then((Response response) {
                      if (response.data != null) {
                        if (response.data['success'] == true) {
                          print(response);
                          Fluttertoast.showToast(msg: "注册成功，即将跳转到登录页面");
                          Timer(Duration(seconds: 2), () {
                            Navigator.pushReplacementNamed(context, "/login");
                          });
                        } else if (response.data['msg'] != null) {
                          Fluttertoast.showToast(msg: response.data['msg']);
                        }
                      }
                    });
                    print(
                        "用户名：${this._userName.text} , 密码： ${this._password.text},邮箱： ${this._email.text}");
                  },
                  child: Text(
                    "注册",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue)),
                ),
              ),
              SizedBox(height: 20),

              Container(
                width: double.infinity,
                child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "返回",
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
