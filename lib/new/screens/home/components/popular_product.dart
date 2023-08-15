import 'package:flutter/material.dart';
import 'package:student_shopping_v1/models/favoriteModel.dart';
import 'package:student_shopping_v1/new/components/product_card.dart';
import 'package:student_shopping_v1/new/models/Product.dart';
import 'package:student_shopping_v1/pages/itemDetailPage.dart';

import '../../../../models/itemModel.dart';
import '../../../size_config.dart';
import 'section_title.dart';

import 'package:provider/provider.dart';
import 'package:student_shopping_v1/models/recentItemModel.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sizer/sizer.dart'; // Import the sizer package

class PopularProducts extends StatefulWidget {
  const PopularProducts({Key? key}) : super(key: key);

  @override
  State<PopularProducts> createState() => _PopularProductsState();
}

class _PopularProductsState extends State<PopularProducts> {
  PagingController<int, ItemWithImages> _pagingController =
  PagingController(firstPageKey: 0);
  int totalPages = 0;

  @override
  void initState() {
    Provider.of<RecentItemModel>(context, listen: false);
    Provider.of<FavoriteModel>(context, listen: false).getCategoryItems();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (mounted) _pagingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var itemList = context.watch<RecentItemModel>();
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.h), // Use sizer to set the horizontal padding
          child: SectionTitle(title: "Featured Products", press: () {}),
        ),
        SizedBox(height: 2.w), // Use sizer to set the vertical spacing
        itemList.items.length != 0
            ? SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...List.generate(
                itemList.items.length,
                    (index) {
                  return ProductCard(
                    product: itemList.items[index],
                    uniqueIdentifier: "recentProduct",
                  );
                },
              ),
              SizedBox(width: 2.w), // Use sizer to set the horizontal spacing
            ],
          ),
        )
            : Padding(
              padding: EdgeInsets.only(top: 20.w),
              child: Center(child: spinkit),
            )
      ],
    );
  }
}

