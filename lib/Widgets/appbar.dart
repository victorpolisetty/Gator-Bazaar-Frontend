import 'package:flutter/material.dart';
import 'package:student_shopping/ProfileFile/sellerShop.dart';

class MyAppBar extends StatefulWidget {
  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: new IconThemeData(color: Colors.grey[800], size: 27),
      backgroundColor: Colors.grey[200],
      elevation: .1,
      title: Center(
        child: Text(
          'Victors Homepage',
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
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => sellerShop()),
            );
          },
          child: Container(
            margin: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.shopping_cart,
              color: Colors.grey[800],
              size: 27,
            ),
          ),
        ),
      ],
    );
  }
}
