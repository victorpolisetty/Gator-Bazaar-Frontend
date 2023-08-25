import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../pages/categoryItemPage.dart';
import 'new/size_config.dart';
import 'package:sizer/sizer.dart';

class Categories1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> categories1 = [
      {"icon": "assets/icons/subleases.svg", "text": "Subleases", "pressNumber": 5},
      {"icon": "assets/icons/electronics.svg", "text": "Electronics", "pressNumber": 6},
      {"icon": "assets/icons/misc.svg", "text": "Misc.", "pressNumber": 8},
      {"icon": "assets/icons/free.svg", "text": "Free", "pressNumber": 9},
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
    final double maxFontSize = calculateMaxFontSize(context);

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
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: Text(
                text!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: maxFontSize), // Use the calculated max font size
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