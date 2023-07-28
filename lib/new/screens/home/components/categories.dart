import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

import '../../../../pages/categoryItemPage.dart';
import '../../../size_config.dart';

class Categories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> categories1 = [
      {"icon": "assets/icons/clothes.svg", "text": "Clothes", "pressNumber": 1},
      {"icon": "assets/icons/formaldress.svg", "text": "Formal Dresses", "pressNumber": 2},
      {"icon": "assets/icons/studentticket.svg", "text": "Student Tickets", "pressNumber": 3},
      {"icon": "assets/icons/furniture.svg", "text": "Furniture", "pressNumber": 4},
    ];
    return Padding(
      padding: EdgeInsets.all(1.5.w), // 1.5% of screen width
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          categories1.length,
              (index) => CategoryCard(
            icon: categories1[index]["icon"],
            text: categories1[index]["text"],
            pressNumber: categories1[index]["pressNumber"],
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.icon,
    required this.text,
    required this.pressNumber,
  }) : super(key: key);

  final String? icon, text;
  final int? pressNumber;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        new MaterialPageRoute(
          builder: (context) => CategoryItemPage(pressNumber!, text!),
        ),
      ),
      child: SizedBox(
        width: 15.w, // 15% of screen width
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(5.w), // 5% of screen width
              height: 15.w, // 15% of screen width
              width: 15.w, // 15% of screen width
              decoration: BoxDecoration(
                color: Color(0xFFFFECDF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(
                icon!,
                fit: BoxFit.scaleDown,
                color: Colors.orange,
                height: 2.5.h, // 2.5% of screen height
                width: 2.5.h, // 2.5% of screen height
              ),
            ),
            SizedBox(height: 1.h), // 1% of screen height
            Text(
              text!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.sp), // 12 scaled points
            ),
          ],
        ),
      ),
    );
  }
}
