import 'package:flutter/material.dart';
import 'package:student_shopping_v1/FavoriteItem/favoriteItem.dart';

class favoritePageTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black54,
              ),
            ),
            automaticallyImplyLeading: false,
            elevation: .1,
              title: Text(
                'Favorites',
                style: TextStyle(color: Colors.black),
              ),

            actions: [
              Container(
                margin: EdgeInsets.only(right: 10),
              ),
            ],
          ),
          body: FavoriteItem()

      ),
    );
  }
}