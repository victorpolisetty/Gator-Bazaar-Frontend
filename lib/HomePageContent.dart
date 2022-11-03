import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_shopping_v1/Categories/categories.dart';
import 'Widgets/appbar.dart';
import 'pages/recentItems.dart';
import 'Widgets/sectionTitleHeader.dart';

class HomePageBody extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Column(
          children: [
            // SearchBarWidget(),
            MyAppBar(),
            SectionTitle(title: "Categories"),
            CategoryPage(),
            SectionTitle(title: "Recent Listings"),
            RecentItems(),
        ],
      );

  }
}
