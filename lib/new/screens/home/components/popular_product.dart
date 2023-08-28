import 'package:flutter/material.dart';
import 'package:student_shopping_v1/models/favoriteModel.dart';
import 'package:student_shopping_v1/pages/itemDetailPage.dart';

import '../../../../models/itemModel.dart';
import '../../../components/productCardSellerView.dart';


import 'package:provider/provider.dart';
import 'package:student_shopping_v1/models/recentItemModel.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../components/product_card.dart';

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
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey, 1);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey, int categoryId) async {
    try {
      await Provider.of<FavoriteModel>(context, listen: false)
          .getItemRestList();
      await Provider.of<RecentItemModel>(context, listen: false)
          .initNextCatPage(pageKey);
      totalPages =
          Provider.of<RecentItemModel>(context, listen: false).totalPages;
      if (mounted) {
        final isLastPage = (totalPages - 1) == pageKey;

        if (isLastPage) {
          _pagingController.appendLastPage(
              Provider.of<RecentItemModel>(context, listen: false).items);
        } else {
          final int? nextPageKey = pageKey + 1;
          _pagingController.appendPage(
              Provider.of<RecentItemModel>(context, listen: false).items,
              nextPageKey);
        }
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }
  @override
  void dispose() {
    super.dispose();
    if (mounted) _pagingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PagedSliverGrid(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<ItemWithImages>(
          firstPageProgressIndicatorBuilder: (_) => Center(child: spinkit),
          newPageProgressIndicatorBuilder: (_) => Center(child: spinkit),
          noItemsFoundIndicatorBuilder: (_) => Center(
            child: Text(
              "No Items Found.",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          itemBuilder: (BuildContext context, item, int index) {
            return ProductCard(
              product: item,
              uniqueIdentifier: "sellerPopularProductTag",
            );
          },
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: .7,
          crossAxisCount: 2,
          mainAxisSpacing: 0, // Use sizer to set main axis spacing
        ),
      );
  }
}

