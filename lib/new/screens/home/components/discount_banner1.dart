import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DiscountBanner extends StatelessWidget {
  const DiscountBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w, // 100% of screen width
      margin: EdgeInsets.all(5.w), // 5% of screen width
      padding: EdgeInsets.symmetric(
        horizontal: 5.w, // 5% of screen width
        vertical: 3.75.h, // 3.75% of screen height
      ),
      decoration: BoxDecoration(
        color: Color(0xFF4A3298),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text.rich(
        TextSpan(
          style: TextStyle(color: Colors.white),
          children: [
            TextSpan(text: "University of Florida\n"),
            TextSpan(
              text: "Go Gators🐊🐊🐊",
              style: TextStyle(
                fontSize: 24.sp, // 24 scaled points
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
