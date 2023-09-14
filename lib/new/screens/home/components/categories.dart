import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

import '../../../../pages/categoryItemPage.dart';
import '../../../size_config.dart';

class Categories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> categories1 = [
      {"icon": "assets/icons/clothes.png", "text": "Clothes", "pressNumber": 1},
      {"icon": "assets/icons/formal.png", "text": "Formal", "pressNumber": 2},
      {"icon": "assets/icons/ticket.png", "text": "Tickets", "pressNumber": 3},
      {"icon": "assets/icons/furniture.png", "text": "Furniture", "pressNumber": 4},
      {"icon": "assets/icons/sublease.png", "text": "Subleases", "pressNumber": 5},
      {"icon": "assets/icons/electronics.png", "text": "Electronics", "pressNumber": 6},
      {"icon": "assets/icons/open-book.png", "text": "Books", "pressNumber": 7},
      {"icon": "assets/all_items.png", "text": "Misc.", "pressNumber": 8},
      {"icon": "assets/icons/free.png", "text": "Free", "pressNumber": 9},
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.all(1.5.w), // Padding for the entire row
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            categories1.length,
                (index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0), // Adjust the horizontal padding as needed
              child: CategoryCard(
                icon: categories1[index]["icon"],
                text: categories1[index]["text"],
                pressNumber: categories1[index]["pressNumber"],
              ),
            ),
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
    final double maxFontSize = calculateMaxFontSize(context);

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        new MaterialPageRoute(
          builder: (context) => CategoryItemPage(pressNumber!, text!),
        ),
      ),
      child: SizedBox(
        width: 13.5.w, // 15% of screen width
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(1.5.w), // ICON SIZE
              height: 15.w, // 15% of screen width
              width: 19.w, // 15% of screen width
              child: Image.asset(
                icon!, // Use the PNG icon path
                fit: BoxFit.scaleDown,
                color: Colors.white,
                height: 2.5.h, // 2.5% of screen height
                width: 2.5.h, // 2.5% of screen height
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: Text(
                text!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  // fontSize: maxFontSize, // Use the calculated max font size
                  fontSize: 10,
                  color: Colors.white, // Set the text color to white
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double calculateMaxFontSize(BuildContext context) {
    // The desired font size that you want for the non-overflowing text
    const desiredFontSize = 12.0;

    final constraints = BoxConstraints(
      maxWidth: 15.w, // 15% of screen width
      maxHeight: 15.w, // 15% of screen width
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: text!,
        style: TextStyle(fontSize: desiredFontSize),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
      maxLines: 1,
    );

    textPainter.layout(maxWidth: constraints.maxWidth);

    // Calculate the font scale factor required to fit the text within the constraints
    final fontScaleFactor = textPainter.width / textPainter.size.width;

    // Calculate the maximum font size that fits the available space
    final maxFontSize = desiredFontSize / fontScaleFactor;

    return maxFontSize;
  }
}