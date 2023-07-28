import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:student_shopping_v1/pages/filterPage.dart';

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
      padding: EdgeInsets.symmetric(horizontal: 5.w), // 5% of screen width
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Gator Bazaar",
            style: TextStyle(
              color: Colors.black,
              fontSize: 30.sp, // 20 scaled points
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          IconBtnWithCounter(
            svgSrc: "assets/icons/heart.svg",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => favoritePageTab()),
              );
            },
          ),
          Spacer(),
          IconBtnWithCounter(
            svgSrc: "assets/icons/person.svg",
            numOfitem: 0,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SellerProfilePageNew(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
