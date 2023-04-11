import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:student_shopping_v1/new/screens/home/home_screen.dart';
// import 'package:student_shopping_v1/new/screens/profile/profile_screen.dart';

import '../../HomePageContent.dart';
import '../../messaging/Pages/NewChatPage.dart';
import '../../models/chatMessageModel.dart';
import '../../pages/addListingPage.dart';
import '../../pages/favoritePage.dart';
import '../../pages/sellerProfilePage.dart';
import '../constants.dart';
import '../enums.dart';
import 'package:provider/provider.dart';


class CustomBottomNavBar extends StatefulWidget {
  CustomBottomNavBar({
    Key? key,
    required this.selectedMenu,
  }) : super(key: key);

  final MenuState selectedMenu;


  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> with SingleTickerProviderStateMixin {
  int _selectedPage = 0;

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

  late TabController _controller;
  @override
  void initState(){
    _controller = TabController(length: 5, vsync: this);
    _controller.addListener(_handleSelected);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color inActiveIconColor = Color(0xFF000000);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/Shop Icon.svg",
                  color: MenuState.home == widget.selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, HomeScreen.routeName),
              ),
              IconButton(
                icon: SvgPicture.asset("assets/icons/Heart Icon.svg"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => favoritePageTab()),
                  );
                },
              ),
              IconButton(
                icon: SvgPicture.asset("assets/icons/Chat bubble Icon.svg"),
                onPressed: () {},
              ),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/User Icon.svg",
                  color: MenuState.profile == widget.selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                //TODO: put this back
                onPressed: (){},
                // onPressed: () =>
                //     Navigator.pushNamed(context, ProfileScreen.routeName),
              ),
            ],
          )),
    );
  }
  void _handleSelected () async {
    int index = _controller.index;
    if (_selectedPage == 3) {
      Provider.of<ChatMessageModel>(context, listen: false).getChatHomeHelper().then((value) =>     setState((){
        _selectedPage = index;
      }));
    } else {
      setState((){
        _selectedPage = index;
      });
    }
    // get index from controller (I am not sure about exact parameter name for selected index) ;
  }
}

