import 'package:flutter/material.dart';
import 'package:student_shopping/Widgets/appbar.dart';
import 'package:student_shopping/myBody.dart';

class newHomePage extends StatefulWidget {
  @override
  _newHomePageState createState() => _newHomePageState();
}

class _newHomePageState extends State<newHomePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          MyAppBar(),
          MyBody(),
          // _children[_currentIndex]
        ],
      ),
    );
  }
}
