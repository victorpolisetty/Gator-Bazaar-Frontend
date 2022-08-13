import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_shopping_v1/Widgets/homePageTab.dart';
import 'package:student_shopping_v1/applicationState.dart';
import 'package:student_shopping_v1/messaging/Pages/NewChatPage.dart';
import 'package:student_shopping_v1/messaging/Screens/MessagingScreen.dart';
import 'package:student_shopping_v1/pages/favoritePage.dart';
import 'package:student_shopping_v1/pages/sellerProfilePage.dart';
import 'pages/userProfilePage.dart';
import 'pages/addListingPage.dart';

class BuyerHomePage extends StatefulWidget {
  String title;
  BuyerHomePage(this.title);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<BuyerHomePage> {
  int _currentIndex = 0;

  final List<Widget> tabs = [
    homePageTab(),
    favoritePageTab(),
    AddListing(),
    ChatPage(),
    StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        return sellerProfilePage();
      }
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body:
          tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite,), label: "My Favorites",),
          BottomNavigationBarItem(icon: Icon(Icons.add,), label: "Add Listing",),
          BottomNavigationBarItem(icon: Icon(Icons.message,), label: "Messaging",),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
        },
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.black,),
    );
  }
}
