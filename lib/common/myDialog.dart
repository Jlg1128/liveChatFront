import 'dart:async';

import 'package:flutter/material.dart';

class MyDialog extends Dialog {
  String title = '';
  String content = '';
  Function onClose = () {};
  MyDialog(String title, String content, Function onClose) {
    this.title = title;
    this.content = content;
    this.onClose = onClose;
  }
  showTimer(context) {
    var timer;
    timer = Timer.periodic(Duration(milliseconds: 3000), (timer) {
      Navigator.pop(context);
      timer.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Container(
            width: 200.0,
            height: 200.0,
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text("${this.title}"),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          child: Icon(Icons.close),
                          onTap: () {
                            if (this.onClose is Function) {
                              this.onClose();
                            } else {
                              Navigator.pop(context);
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Divider(),
                Container(
                  child: Text('${this.content}'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
