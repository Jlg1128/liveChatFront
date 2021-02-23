import 'package:flutter/material.dart';

class Triganle extends StatelessWidget {
  //  Triganle({Key key}) : super(key: key);
  String direction = 'left';
  double width = 8;
  Color color = Colors.green;
  Triganle(String direction, double width, Color color) {
    this.direction = direction;
    this.width = width;
    this.color = color;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 0,
      decoration: new BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: this.direction == 'top' ? this.color : Colors.transparent,
              width: this.width,
              style: BorderStyle.solid),
          top: BorderSide(
              color:
                  this.direction == 'bottom' ? this.color : Colors.transparent,
              width: this.width,
              style: BorderStyle.solid),
          right: BorderSide(
              color: this.direction == 'left' ? this.color : Colors.transparent,
              width: this.width,
              style: BorderStyle.solid),
          left: BorderSide(
              color:
                  this.direction == 'right' ? this.color : Colors.transparent,
              width: this.width,
              style: BorderStyle.solid),
        ),
      ),
    );
  }
}
