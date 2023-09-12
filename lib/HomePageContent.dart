import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:student_shopping_v1/pages/favoritePage.dart';
import 'package:student_shopping_v1/pages/sellerProfilePageNew.dart';
import 'new/screens/home/components/categories.dart';
import 'new/screens/home/components/discount_banner1.dart';
import 'new/screens/home/components/home_header.dart';
import 'new/screens/home/components/popular_product.dart';

class HomePageBody extends StatefulWidget {
  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Gator Bazaar",
            style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.person_outline, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SellerProfilePageNew()),
                );
              },
            ),
          ],
          leading:
          IconButton(
            icon: Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => favoritePageTab()),
              );
              },
          ),
        ),
        body: Container(
          color: Color(0xFF333333),
          child: CustomScrollView(
            slivers: [
              // SliverPadding(
              //   padding: EdgeInsets.only(top: 0.2.h),
              //   sliver: SliverToBoxAdapter(child: HomeHeader()),
              // ),
              SliverToBoxAdapter(child: DiscountBanner()),
              SliverPadding(
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                sliver: SliverToBoxAdapter(child: Categories()),
              ),
              // SliverToBoxAdapter(child: Categories1()),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align children to the left
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Featured Products",
                        style: TextStyle(
                          color: Colors.white, // Change this to your desired font color
                          fontSize: 16.0, // Adjust the font size as needed
                          fontWeight: FontWeight.bold, // Adjust the font weight as needed
                        ),
                      ),
                    ),
                    // Add any additional content here if needed
                  ],
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                sliver: PopularProducts(),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 30.sp)),
            ],
          ),
        ),
      ),
    );
  }
}