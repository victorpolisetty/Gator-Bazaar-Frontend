import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:student_shopping_v1/new/screens/home/components/section_title.dart'; // Import the sizer package

class SpecialOffers extends StatelessWidget {
  const SpecialOffers({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w), // Use sizer to set horizontal padding
          child: SectionTitle(
            title: "Special for you",
            press: () {},
          ),
        ),
        SizedBox(height: 2.h), // Use sizer to set vertical spacing
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SpecialOfferCard(
                image: "assets/images/Image Banner 2.png",
                category: "Smartphone",
                numOfBrands: 18,
                press: () {},
              ),
              SpecialOfferCard(
                image: "assets/images/Image Banner 3.png",
                category: "Fashion",
                numOfBrands: 24,
                press: () {},
              ),
              SizedBox(width: 2.w), // Use sizer to set horizontal spacing
            ],
          ),
        ),
      ],
    );
  }
}

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({
    Key? key,
    required this.category,
    required this.image,
    required this.numOfBrands,
    required this.press,
  }) : super(key: key);

  final String category, image;
  final int numOfBrands;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 2.w), // Use sizer to set left padding
      child: GestureDetector(
        onTap: press,
        child: SizedBox(
          width: 35.w, // Use sizer to set width
          height: 12.h, // Use sizer to set height
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3.h), // Use sizer to set borderRadius
            child: Stack(
              children: [
                Image.asset(
                  image,
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF343434).withOpacity(0.4),
                        Color(0xFF343434).withOpacity(0.15),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.w, // Use sizer to set horizontal padding
                    vertical: 2.h, // Use sizer to set vertical padding
                  ),
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: "$category\n",
                          style: TextStyle(
                            fontSize: 5.sp, // Use sizer to set font size
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: "$numOfBrands Brands", style: TextStyle(fontSize: 4.sp)) // Use sizer to set font size
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
