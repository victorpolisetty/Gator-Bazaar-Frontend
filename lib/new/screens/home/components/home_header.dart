import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_shopping_v1/pages/filterPage.dart';
// import 'package:shop_app/screens/cart/cart_screen.dart';

import '../../../../pages/favoritePage.dart';
import '../../../../pages/sellerProfilePage.dart';
import '../../../../pages/sellerProfilePageNew.dart';
import '../../../size_config.dart';
import 'icon_btn_with_counter.dart';
import 'search_field.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, // Align items to the start/left
        children: [
          Text(
            "Gator Bazaar",
            style: TextStyle(
              color: Colors.black, // Set text color to black
              fontSize: 35, // You can adjust the size as needed
              fontWeight: FontWeight.bold, // You can adjust the style as needed
            ),
          ),
          Spacer(), // This will push your buttons to the right
          IconBtnWithCounter(
            svgSrc: "assets/icons/heart.svg",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => favoritePageTab()),
              );
            },
          ),
          IconBtnWithCounter(
            svgSrc: "assets/icons/person.svg",
            numOfitem: 0,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SellerProfilePageNew()
                   // assuming this is a widget that wraps the StreamBuilder
                ),
              );
            },
          ),
          // StreamBuilder<User?>(
          //     stream: FirebaseAuth.instance.authStateChanges(),
          //     builder: (context, snapshot) {
          //       return sellerProfilePage();
          //     }
          // ),
        ],
      ),
    );

  }
  alertDialog(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text("No Notifications!"),
      content: Text("Check back later :)"),
      actions: [
        CupertinoDialogAction(onPressed: () {
          Navigator.pop(context);
        },child: Text("Ok",style: TextStyle(fontWeight: FontWeight.bold))),

      ],
    );
  }
}
