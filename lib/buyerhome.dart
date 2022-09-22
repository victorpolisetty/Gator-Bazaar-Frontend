import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:student_shopping_v1/Widgets/homePageTab.dart';
import 'package:student_shopping_v1/applicationState.dart';
import 'package:student_shopping_v1/messaging/Pages/NewChatPage.dart';
import 'package:student_shopping_v1/messaging/Screens/MessagingScreen.dart';
import 'package:student_shopping_v1/pages/favoritePage.dart';
import 'package:student_shopping_v1/pages/sellerProfilePage.dart';
import 'pages/userProfilePage.dart';
import 'pages/addListingPage.dart';
import 'package:http/http.dart' as http;


class BuyerHomePage extends StatefulWidget {
  String title;
  BuyerHomePage(this.title);
  @override
  _HomePageState createState() => _HomePageState();
}

int? currDbId = -1;

Future<void> saveTokenToDatabase(String token) async {
  // Assume user is logged in for this example
  String? firebaseId = FirebaseAuth.instance.currentUser?.uid;

  Future<void> updatedUserDeviceToken()  async {
    var url = Uri.parse('http://studentshopspringbackend-env.eba-b2yvpimm.us-east-1.elasticbeanstalk.com/profiles/$currDbId/deviceToken/$token');
    final http.Response response =  await http.put(url
        , headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        }
      // , body: tmpObj
    );

    //  .then((response) {
    if (response.statusCode == 200) {
      print("Updated user device token to : " + token);
      print(response.statusCode);
    } else {
      print(response.statusCode);
    }
    //  });
  }

  await updatedUserDeviceToken();

  // await FirebaseFirestore.instance
  //     .collection('users')
  //     .doc(userId)
  //     .update({
  //   'tokens': FieldValue.arrayUnion([token]),
  // });
}

Future<int?> getUserDbIdRealFunc() async {
  // Assume user is logged in for this example
  String? firebaseId = FirebaseAuth.instance.currentUser?.uid;

  Future<void> updatedUserDbId()  async {
    Map<String, dynamic> data;
    var url = Uri.parse('http://studentshopspringbackend-env.eba-b2yvpimm.us-east-1.elasticbeanstalk.com/profiles/$firebaseId'); // TODO -  call the recentItem service when it is built
    http.Response response = await http.get(
        url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      // data.map<Item>((json) => Item.fromJson(json)).toList();
      data = jsonDecode(response.body);
      currDbId = data['id'];
      // recipientProfileName = data['name'];
      print(response.statusCode);
    } else {
      print(response.statusCode);
    }
    //  });
  }

  await updatedUserDbId();

  // await FirebaseFirestore.instance
  //     .collection('users')
  //     .doc(userId)
  //     .update({
  //   'tokens': FieldValue.arrayUnion([token]),
  // });
}

class _HomePageState extends State<BuyerHomePage> {
  int _currentIndex = 0;


  Future<void> setupToken(int? currDbId) async {
    // Get the token each time the application loads
    String? token = await FirebaseMessaging.instance.getToken();

    // Save the initial token to the database
    await saveTokenToDatabase(token!);

    // Any time the token refreshes, store this in the database too.
    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
  }

  Future<int?> getUserDbId() async {
    return await getUserDbIdRealFunc();
  }


  @override
  void initState(){
    getUserDbId().then((value) => setupToken(currDbId));
    super.initState();
  }

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
