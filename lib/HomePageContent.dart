import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_shopping_v1/Categories/categories.dart';
import 'pages/recentItems.dart';
import 'Widgets/searchBarWidget.dart';
import 'Widgets/sectionTitleHeader.dart';

class HomePageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
          children: [
            // SearchBarWidget(),
            SectionTitle(title: "Categories"),
            Categories(),
            SectionTitle(title: "Recent Listings"),
            RecentItems(),
        ],
      );

  }
}
