import 'package:flutter/material.dart';
import 'package:student_shopping_v1/new/components/coustom_bottom_nav_bar.dart';
import 'package:student_shopping_v1/new/enums.dart';

import 'components/body.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
