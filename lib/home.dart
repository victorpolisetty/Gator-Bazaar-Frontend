import 'package:flutter/material.dart';
import 'package:student_shopping/Widgets/newHomePage.dart';
import 'package:student_shopping/pages/favoritePage.dart';
import 'ProfileFile/sellerShop.dart';
//import 'package:firebase_auth/firebase_auth.dart';


class HomePage extends StatefulWidget {
  String title;
  HomePage(this.title );
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

 // final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
 // UserCredential user;

  int _currentIndex = 0;
  final List<Widget> tabs = [
    newHomePage(),
    favoritePage(),
    sellerShop(),
  ];
  @override
  Widget build(BuildContext context) {
   // Firebase.initializeApp();
    return Scaffold(
      backgroundColor: Colors.grey[200],

      appBar: AppBar(
          title: Text(widget.title),
        actions: <Widget>[
          Builder(builder: (BuildContext context) {
            return FlatButton(
              child: const Text('Sign out'),
              textColor: Theme.of(context).buttonColor,
              onPressed: () async {
                /* final User user = await firebaseAuth.currentUser;
                if (user == null) {
                  Scaffold.of(context).showSnackBar(const SnackBar(
                    content: Text('No one has signed in.'),
                  ));
                  return;
                } */
               // signOut();
              },
            );
          })
        ],
      ),


      body:
          tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),

          BottomNavigationBarItem(icon: Icon(Icons.favorite,), label: "My Favorites",),

          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.black,),
    );
  }
}
