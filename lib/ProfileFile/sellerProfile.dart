import 'package:flutter/material.dart';

class sellerProfileVariables extends StatefulWidget {
  @override
  _sellerProfileVariablesState createState() => _sellerProfileVariablesState();
}

class _sellerProfileVariablesState extends State<sellerProfileVariables> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.0,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return Row(
              children: <Widget>[],
            );
          }),
    );
  }
}

class seller extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2.0, 2.0, 6.0, 5.0),
      child: Container(
        width: 90.0,
        child: ListTile(
          title: Text("1"),
          subtitle: Container(
              alignment: Alignment.topCenter,
              child: Text(
                "Followers",
                style: TextStyle(
                  fontSize: 10.0,
                ),
              )),
        ),
      ),
    );
  }
}
