import 'package:flutter/material.dart';
import 'package:student_shopping/home.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

//final FirebaseAuth _auth = FirebaseAuth.instance;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage( 'Student Shopping'),
    );
  }
}
