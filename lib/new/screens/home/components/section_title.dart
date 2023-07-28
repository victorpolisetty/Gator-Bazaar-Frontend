import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart'; // Import the sizer package

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    Key? key,
    required this.title,
    required this.press,
  }) : super(key: key);

  final String title;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp, // Use sizer to set the font size
            color: Colors.black,
          ),
        ),
        // GestureDetector(
        //   onTap: press,
        //   child: Text(
        //     "See More",
        //     style: TextStyle(color: Color(0xFFBBBBBB)),
        //   ),
        // ),
      ],
    );
  }
}
