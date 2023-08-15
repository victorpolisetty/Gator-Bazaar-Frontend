import 'dart:convert';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:student_shopping_v1/messaging/Pages/NewChatPage.dart';
import 'package:student_shopping_v1/pages/manageGroupsPage.dart';
import 'HomePageContent.dart';
import 'models/chatMessageModel.dart';
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
  Future<void> updatedUserDeviceToken() async {
    var url = Uri.parse(
        'http://Gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/profiles/$currDbId/deviceToken/$token');
    final http.Response response = await http.put(url, headers: {
      "Accept": "application/json",
      "Content-Type": "application/json"
    });

    if (response.statusCode == 200) {
      print("Updated user device token to : " + token);
    } else {
      print(response.statusCode);
    }
  }

  await updatedUserDeviceToken();
}

Future<int?> getUserDbIdRealFunc() async {
  String? firebaseId = FirebaseAuth.instance.currentUser?.uid;

  Future<void> updatedUserDbId() async {
    Map<String, dynamic> data;
    var url = Uri.parse(
        'http://Gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/profiles/$firebaseId'); // TODO -  call the recentItem service when it is built
    http.Response response =
        await http.get(url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      currDbId = data['id'];

    } else {
      print(response.statusCode);
    }
  }

  await updatedUserDbId();
  return null;
}

class _HomePageState extends State<BuyerHomePage>
    with SingleTickerProviderStateMixin {
  int _selectedPage = 0;

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
  void initState() {
    getUserDbId().then((value) => setupToken(currDbId));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: false,
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15,
          vertical: 20),
          child: GNav(
            backgroundColor: Colors.white,
            color: Colors.black,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.black,
            padding: EdgeInsets.all(16),
            gap: 8,
            onTabChange: (index){
              _handleSelected(index);
            },
            tabs: [
                  GButton(
                      icon:
                        Icons.home,
                      text:
                          "Home"),
              GButton(
                  icon:
                  Icons.add,
                  text:
                  "Add"),
              GButton(
                  icon:
                  Icons.message,
                  text:
                  "Messaging"),
              GButton(
                  icon:
                  Icons.group,
                  text:
                  "Groups"),
            ],


          ),
        ),
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedPage,
          children: [
            HomePageBody(),
            AddListing(),
            ChatPage(),
            manageGroupsPage()
          ],
        ),
      ),
    );
  }

  void _handleSelected(int givenIndex) async {
    int index = givenIndex;
    if (_selectedPage == 3) {
      Provider.of<ChatMessageModel>(context, listen: false)
          .getChatHomeHelper()
          .then((value) => setState(() {
                _selectedPage = index;
              }));
    } else {
      setState(() {
        _selectedPage = index;
      });
    }
  }
}
