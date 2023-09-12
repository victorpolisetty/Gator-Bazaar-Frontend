import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:student_shopping_v1/pages/categoryItemPage.dart';


class DiscountBanner extends StatelessWidget {
  const DiscountBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        new MaterialPageRoute(
          builder: (context) => CategoryItemPage(3, "Tickets"),
        ),
      ),
      child: Container(
        width: 100.w, // Set the width to match the parent width
        height: 25.h, // Set the height as needed
        child: FittedBox(
          fit: BoxFit.fitWidth,
          clipBehavior: Clip.hardEdge,
          child: Image.asset(
            "assets/images/ticket_banner.png",
          ),
        ),
      ),
    );
  }
}
