import 'package:flutter/material.dart';

class CircleIcon extends StatelessWidget {
  final Color color;
  final Widget icon;

  const CircleIcon(this.color, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      margin: EdgeInsets.only(left: 17),
      decoration: BoxDecoration(color: color,borderRadius: BorderRadius.circular(50)),
      child:
          icon,

    );
  }
}
