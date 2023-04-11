import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_shopping_v1/Categories/categories.dart';
import 'Categories1.dart';
import 'Widgets/appbar.dart';
import 'new/screens/home/components/categories.dart';
import 'new/screens/home/components/discount_banner1.dart';
import 'new/screens/home/components/home_header.dart';
import 'new/screens/home/components/popular_product.dart';
import 'new/size_config.dart';
import 'pages/recentItems.dart';
import 'Widgets/sectionTitleHeader.dart';

class HomePageBody extends StatefulWidget {
  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  @override
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),
            HomeHeader(),
            SizedBox(height: getProportionateScreenWidth(10)),
            DiscountBanner(),
            Categories(),
            Categories1(),
            // SpecialOffers(),
            // SizedBox(height: getProportionateScreenWidth(10)),
            PopularProducts(),
            SizedBox(height: getProportionateScreenWidth(30)),
          ],
        ),
      ),
    );

  }
}
