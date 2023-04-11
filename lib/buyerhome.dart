import 'dart:convert';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:student_shopping_v1/messaging/Pages/NewChatPage.dart';
import 'package:student_shopping_v1/pages/favoritePage.dart';
import 'package:student_shopping_v1/pages/sellerProfilePage.dart';
import 'package:student_shopping_v1/pages/sellerProfilePageBody.dart';
import 'package:student_shopping_v1/pages/sellerProfilePageNew.dart';
import 'HomePageContent.dart';
import 'models/chatMessageModel.dart';
import 'new/size_config.dart';
import 'pages/addListingPage.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';


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

  Future<void> updatedUserDeviceToken() async {
    var url = Uri.parse(
        'http://Gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/profiles/$currDbId/deviceToken/$token');
    final http.Response response = await http.put(url, headers: {
      "Accept": "application/json",
      "Content-Type": "application/json"
    });

    if (response.statusCode == 200) {
      print("Updated user device token to : " + token);
      print(response.statusCode);
    } else {
      print(response.statusCode);
    }
  }

  await updatedUserDeviceToken();
}

Future<int?> getUserDbIdRealFunc() async {
  // Assume user is logged in for this example
  String? firebaseId = FirebaseAuth.instance.currentUser?.uid;

  Future<void> updatedUserDbId() async {
    Map<String, dynamic> data;
    var url = Uri.parse(
        'http://Gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/profiles/$firebaseId'); // TODO -  call the recentItem service when it is built
    http.Response response =
        await http.get(url, headers: {"Accept": "application/json"});
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
  return null;

  // await FirebaseFirestore.instance
  //     .collection('users')
  //     .doc(userId)
  //     .update({
  //   'tokens': FieldValue.arrayUnion([token]),
  // });
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

  // late TabController _controller;

  @override
  void initState() {
    getUserDbId().then((value) => setupToken(currDbId));
    print("HERE");
    // _controller = TabController(length: 5, vsync: this);
    // _controller.addListener(_handleSelected);
    super.initState();
  }

  // static bool shouldReload = false;

  // final List<Widget> tabs = [
  //   HomePageBody(),
  //   favoritePageTab(),
  //   AddListing(),
  //   ChatPage(),
  //   StreamBuilder<User?>(
  //       stream: FirebaseAuth.instance.authStateChanges(),
  //       builder: (context, snapshot) {
  //         return sellerProfilePage();
  //       }),
  // ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              print(index);
              _handleSelected(index);
            },
            tabs: [
                  GButton(
                      icon:
                        Icons.home,
                      text:
                          "Home"),
              // GButton(
              //     icon:
              //     Icons.favorite,
              //     text:
              //     "Favorites"),
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
                  Icons.person,
                  text:
                  "Profile"),
            ],


          ),
        ),
      ),
      // bottomNavigationBar: TabBar(
      //   padding: EdgeInsets.symmetric(vertical: 14),
      //   labelColor: Colors.black,
      //   indicatorColor: Colors.black,
      //   unselectedLabelColor: Color(0xFF000000),
      //   labelPadding: EdgeInsets.only(
      //     left: getProportionateScreenWidth(10),
      //   ),
      //   controller: _controller,
      //   tabs: [
      //     Tab(
      //         icon: Icon(
      //           Icons.home,
      //           size: getProportionateScreenWidth(20),
      //         ),
      //         child: Text(
      //           "Home",
      //           textAlign: TextAlign.center,
      //           style: TextStyle(
      //               fontSize: getProportionateScreenWidth(10)),
      //         )),
      //     Tab(
      //       icon: Icon(
      //         Icons.favorite,
      //         size: getProportionateScreenWidth(20),
      //       ),
      //       child: Text("Favorites",
      //           textAlign: TextAlign.center,
      //           style: TextStyle(
      //               fontSize: getProportionateScreenWidth(10))),
      //     ),
      //     Tab(
      //       icon: Icon(
      //         Icons.add,
      //         size: getProportionateScreenWidth(20),
      //       ),
      //       child: Text("Add Item",
      //           textAlign: TextAlign.center,
      //           style: TextStyle(
      //               fontSize: getProportionateScreenWidth(10))),
      //     ),
      //     Tab(
      //       icon: Icon(
      //         Icons.message,
      //         size: getProportionateScreenWidth(20),
      //       ),
      //       child: Text("Messaging",
      //           textAlign: TextAlign.center,
      //           style: TextStyle(
      //               fontSize: getProportionateScreenWidth(10))),
      //     ),
      //     Tab(
      //         icon: Icon(
      //           Icons.person,
      //           size: getProportionateScreenWidth(20),
      //         ),
      //         child: Text("Profile",
      //             textAlign: TextAlign.center,
      //             style: TextStyle(
      //                 fontSize: getProportionateScreenWidth(10)))),
      //   ],
      // ),

      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: IndexedStack(
          index: _selectedPage,
          children: [
            HomePageBody(),
            // favoritePageTab(),
            AddListing(),
            ChatPage(),
            StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  return SellerProfilePageNew();
                }),
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
    // get index from controller (I am not sure about exact parameter name for selected index) ;
  }
}
