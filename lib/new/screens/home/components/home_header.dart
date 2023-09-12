import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

import '../../../../pages/favoritePage.dart';
import '../../../../pages/sellerProfilePageNew.dart';
import 'icon_btn_with_counter.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black, // Set the background color to black
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.01.h), // 5% of screen width, 1% of screen height
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => favoritePageTab()),
                );
              },
              child: Image.asset(
                'assets/icons/heart.png', // Path to your PNG image file
                width: 32,  // Adjust the width as needed
                height: 32, // Adjust the height as needed
              ),
            ),
              Spacer(),
              Center(
                child: Image.asset(
                  "assets/gb_placeholder.jpg", // Update with the path to your PNG image
                  width: 200, // Set the width to your desired size
                  height: 100, // Set the height to your desired size
                  // You can also adjust other properties like alignment and fit as needed
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SellerProfilePageNew()),
                  );
                },
                child: SvgPicture.asset(
                  'assets/icons/person.svg', // Path to your PNG image file
                  width: 32,  // Adjust the width as needed
                  height: 32, // Adjust the height as needed
                ),
              ),
              // IconBtnWithCounter(
              //   svgSrc: "assets/icons/person.svg",
              //   numOfitem: 0,
              //   press: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => SellerProfilePageNew(),
              //       ),
              //     );
              //   },
              // ),
            ],
          ),
        ],
      ),
    );
  }
}