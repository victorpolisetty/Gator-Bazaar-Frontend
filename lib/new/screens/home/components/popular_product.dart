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
    // _pagingController.addPageRequestListener((pageKey) {
    //   _fetchPage(pageKey);
    // });
    Provider.of<RecentItemModel>(context, listen: false);
    Provider.of<FavoriteModel>(context, listen: false).getCategoryItems();
    super.initState();
  }

  // Future<void> _fetchPage(int pageKey) async {
  //   await Provider.of<RecentItemModel>(context, listen: false).init1(pageKey);
  //   totalPages = Provider.of<RecentItemModel>(context, listen: false).totalPages;
  //   // if(mounted) {
  //   final isLastPage = (totalPages-1) == pageKey;
  //   if (isLastPage) {
  //     _pagingController.appendLastPage(Provider.of<RecentItemModel>(context, listen: false).items);
  //   } else {
  //     final int? nextPageKey = pageKey + 1;
  //     _pagingController.appendPage(Provider.of<RecentItemModel>(context, listen: false).items, nextPageKey);
  //   }
  //   // }
  // }

  @override
  void dispose(){
    super.dispose();
    if(!mounted) _pagingController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var itemList = context.watch<RecentItemModel>();
    return Column(
      children: [
        Padding(
          padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(title: "Recent Products", press: () {}),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        itemList.items.length != 0 ? SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...List.generate(
                itemList.items.length,
                    (index) {
                  // if (demoProducts[index].isPopular)
                  //     final int id;
                  //     final String title, description;
                  //     final List<String> images;
                  //     final List<Color> colors;
                  //     final double rating, price;
                  //     final bool isFavourite, isPopular;
                  return ProductCard(
                      product: itemList.items[index],
                  uniqueIdentifier: "recentProduct",);

                  return SizedBox
                      .shrink(); // here by default width and height is 0
                },
              ),
              SizedBox(width: getProportionateScreenWidth(20)),
            ],
          ),
        ) : spinkit
      ],
    );
  }
}


