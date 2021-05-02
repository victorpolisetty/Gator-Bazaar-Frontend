import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_shopping/Categories/categories.dart';
import 'ProductFile/products.dart';
import 'Widgets/searchBarWidget.dart';
import 'Widgets/sectionTitleHeader.dart';

class MyBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        SearchBarWidget(),
        SectionTitle(title: "Featured"),
        Products(),
        SectionTitle(title: "Categories"),
        Categories(),
        SectionTitle(title: "New Arrival"),
        Products(),
      ],
    ));
  }
}
