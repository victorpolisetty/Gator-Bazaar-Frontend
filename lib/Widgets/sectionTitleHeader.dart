import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final title;

  const SectionTitle({this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, top: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(fontSize: 24,fontWeight: FontWeight.w600)),
          Text("See All")
        ],
      ),
    );
  }
}
