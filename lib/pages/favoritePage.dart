import 'package:flutter/material.dart';
import 'package:student_shopping_v1/FavoriteItem/favoriteItem.dart';

class favoritePageTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          iconTheme: new IconThemeData(color: Colors.grey[800], size: 27),
          // backgroundColor: Colors.grey[300],
          elevation: .1,
          title: Center(
            child: Text(
              'My Favorites',
              style: TextStyle(color: Colors.black),
            ),
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 10),
            ),
          ],
        ),
        body: FavoriteItem()
    );
  }
}