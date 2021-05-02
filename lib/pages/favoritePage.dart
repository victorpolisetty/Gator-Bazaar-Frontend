import 'package:flutter/material.dart';

class favoritePage extends StatefulWidget {
  @override
  _favoritePageState createState() => _favoritePageState();
}

class _favoritePageState extends State<favoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red[600],
        title: Text("Favorites"),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {}),
        ],
      ),
    );
  }
}
