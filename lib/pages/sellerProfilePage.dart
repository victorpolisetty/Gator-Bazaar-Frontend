import 'package:flutter/material.dart';
import 'package:student_shopping_v1/pages/sellerProfilePageBody.dart';
import '../Widgets/appbar.dart';
import 'package:student_shopping_v1/HomePageContent.dart';

class sellerProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Column(
      children: [
        SellerProfilePageBody(),
      ],
    );
  }
}