import 'package:flutter/material.dart';
import '../Widgets/circleIcon.dart';

class Categories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 80,
      width: MediaQuery.of(context).size.width,
      child: ListView(

        scrollDirection: Axis.horizontal,
        children: [
          CircleIcon(
            icon: Icon(
              Icons.computer,
              color: Colors.grey[200],
              size: 28,
            ),
            color: Colors.green[400],
          ),
          CircleIcon(
            icon: Icon(
              Icons.mobile_screen_share,
              color: Colors.grey[200],
              size: 28,
            ),
            color: Colors.purple[500],
          ),
          CircleIcon(
            icon: Icon(
              Icons.book,
              color: Colors.grey[200],
              size: 28,
            ),
            color: Colors.yellow[800],
          ),
          CircleIcon(
            icon: Icon(
              Icons.book,
              color: Colors.grey[200],
              size: 28,
            ),
            color: Colors.red[800],
          ),
          CircleIcon(
            icon: Icon(
              Icons.book,
              color: Colors.grey[200],
              size: 28,
            ),
            color: Colors.blue[800],
          ),
          CircleIcon(
            icon: Icon(
              Icons.book,
              color: Colors.grey[200],
              size: 28,
            ),
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
