import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../pages/categoryItemPage.dart';
import '../../../size_config.dart';

class Categories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> categories1 = [
      {"icon": "assets/icons/clothes.svg", "text": "Clothes", "pressNumber" : 1},
      {"icon": "assets/icons/formaldress.svg", "text": "Formal Dresses", "pressNumber" : 2},
      {"icon": "assets/icons/studentticket.svg", "text": "Student Tickets", "pressNumber" : 3},
      {"icon": "assets/icons/furniture.svg", "text": "Furniture", "pressNumber" : 4},
    ];
    List<Map<String, dynamic>> categories2 = [

    ];
    return Padding(
      padding: EdgeInsets.all(getProportionateScreenWidth(10)),
      child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              categories1.length,
                  (index) => CategoryCard(
                  icon: categories1[index]["icon"],
                  text: categories1[index]["text"],
                  pressNumber: categories1[index]["pressNumber"]
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
    required this.pressNumber
  }) : super(key: key);

  final String? icon, text;
  final int? pressNumber;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:() => Navigator.of(context).push(new MaterialPageRoute(
        // builder: (context) => CategoryItemPage(1))),
          builder: (context) => CategoryItemPage(pressNumber!, text!))),
      child: SizedBox(
        width: getProportionateScreenWidth(55),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(getProportionateScreenWidth(15)),
              height: getProportionateScreenWidth(55),
              width: getProportionateScreenWidth(55),
              decoration: BoxDecoration(
                color: Color(0xFFFFECDF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(icon!,fit: BoxFit.scaleDown, color: Colors.orange, height: 5, width: 5,),
            ),
            SizedBox(height: 5),
            Text(text!, textAlign: TextAlign.center, style: TextStyle(fontSize: 12),)
          ],
        ),
      ),
    );
  }
}
