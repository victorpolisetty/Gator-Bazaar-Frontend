import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:student_shopping_v1/messaging/Pages/NewChatPage.dart';
import 'package:student_shopping_v1/models/recentItemModel.dart';
import 'package:student_shopping_v1/pages/favoritePage.dart';
import 'package:student_shopping_v1/pages/sellerProfilePage.dart';
import 'HomePageContent.dart';
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
    var url = Uri.parse('http://Gatorbazaarbackendtested2-env.eba-g27rcqgs.us-east-1.elasticbeanstalk.com/profiles/$currDbId/deviceToken/$token');
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
    var url = Uri.parse('http://Gatorbazaarbackendtested2-env.eba-g27rcqgs.us-east-1.elasticbeanstalk.com/profiles/$firebaseId'); // TODO -  call the recentItem service when it is built
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
  return null;

  // await FirebaseFirestore.instance
  //     .collection('users')
  //     .doc(userId)
  //     .update({
  //   'tokens': FieldValue.arrayUnion([token]),
  // });
}

class _HomePageState extends State<BuyerHomePage> with SingleTickerProviderStateMixin {

  int _currentIndex = 0;
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

  late TabController _controller;

  @override
  void initState(){
    getUserDbId().then((value) => setupToken(currDbId));
    _controller = TabController(length: 5, vsync: this);
    _controller.addListener(_handleSelected);
    super.initState();
  }

  static bool shouldReload = false;

  final List<Widget> tabs = [
    HomePageBody(),
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
      bottomNavigationBar: TabBar(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
        isScrollable: false,
        indicatorColor: Colors.black,
        controller: _controller,
        tabs: [
              Tab(icon: Icon(Icons.home), child: Text("Home", textAlign: TextAlign.center,style: TextStyle(fontSize: 10),)),
              Tab(icon: Icon(Icons.favorite,), child: Text("Favorites", textAlign: TextAlign.center,style: TextStyle(fontSize: 10)),),
              Tab(icon: Icon(Icons.add,), child: Text("Add Item", textAlign: TextAlign.center,style: TextStyle(fontSize: 10)),),
              Tab(icon: Icon(Icons.message,), child: Text("Messaging", textAlign: TextAlign.center,style: TextStyle(fontSize: 10)),),
              Tab(icon: Icon(Icons.person), child: Text("Profile", textAlign: TextAlign.center,style: TextStyle(fontSize: 10))),
        ],
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[200],
      body: IndexedStack(
        index: _selectedPage,
        children: [
          HomePageBody(),
          favoritePageTab(),
          AddListing(),
          ChatPage(),
          StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                return sellerProfilePage();
              }
          ),
        ],
      ),
      // body:
      //     tabs[_currentIndex],
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _currentIndex,
      //   items: [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      //     BottomNavigationBarItem(icon: Icon(Icons.favorite,), label: "My Favorites",),
      //     BottomNavigationBarItem(icon: Icon(Icons.add,), label: "Add Listing",),
      //     BottomNavigationBarItem(icon: Icon(Icons.message,), label: "Conversations",),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: "My Profile"),
      //   ],
      //   onTap: (index){
      //     setState(() {
      //       _currentIndex = index;
      //       Provider.of<RecentItemModel>(context, listen: false).shouldReload = false;
      //     });
      //   },
      //   unselectedItemColor: Colors.grey,
      //   selectedItemColor: Colors.black,),
    );
  }
  void _handleSelected () async {
    int index = _controller.index;// get index from controller (I am not sure about exact parameter name for selected index) ;
    setState((){
      _selectedPage = index;
    });
  }
}
