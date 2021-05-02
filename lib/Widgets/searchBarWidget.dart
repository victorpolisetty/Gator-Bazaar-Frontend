import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left:25, right: 25, top: 10),
      padding: EdgeInsets.only(left: 15, right: 10, top: 5, bottom: 5),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            spreadRadius: -4,
            blurRadius: 13,
            offset: Offset(2, 6),
            color: Colors.grey[500])
      ],
          borderRadius: BorderRadius.circular(15)),
      child: TextField(
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Search something",
            icon: Icon(Icons.search)),
      ),
    );
  }
}
