import 'package:flutter/material.dart';

class MyAppBar extends StatefulWidget {
  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: InkWell(
        child: Container(
          // margin: EdgeInsets.only(right: 10),
          // child: Icon(
          //   Icons.search,
          //   color: Colors.grey[800],
          //   size: 27,
          // ),
        ),
      ),
      iconTheme: new IconThemeData(color: Colors.grey[800], size: 27),
      backgroundColor: Colors.grey[300],
      elevation: .1,
      title: Center(
        child: Text(
          'Gator Bazaar',
          style: TextStyle(color: Colors.black),
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 10),
          child: Icon(
            Icons.notifications,
            color: Colors.grey[800],
            size: 27,
          ),
        ),
      ],
    );
  }
}
