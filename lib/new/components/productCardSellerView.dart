import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import '../../Widgets/FavoriteWidget.dart';
import '../../models/itemModel.dart';
import '../../models/recentItemModel.dart';
import '../../pages/itemDetailPageSellerView.dart';
import '../constants.dart';
import '../size_config.dart';

class ProductCardSeller extends StatelessWidget {
  const ProductCardSeller({
    Key? key,
    required this.product,
    required this.uniqueIdentifier,
    required this.pagingController,
  }) : super(key: key);

  final ItemWithImages product;
  final String uniqueIdentifier;
  final PagingController<int, ItemWithImages> pagingController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(getProportionateScreenWidth(4)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return InkWell(
            onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => new ItemDetailPageSellerView(
                    context.watch<RecentItemModel>().currentUserId,
                    product,
                    pagingController
                ))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1.5,
                  child: Container(
                    padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                    decoration: BoxDecoration(
                      color: kSecondaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Hero(
                      tag: product.id.toString() + uniqueIdentifier,
                      child: product.imageDataList.length > 0 ?
                      Image.memory(product.imageDataList[0]) : Image.asset('assets/images/GatorBazaar.jpg'),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: TextStyle(color: Colors.black),
                        maxLines: 2,
                      ),
                    ),
                    if (product.isSold)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "SOLD!",
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${product.price}",
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(16),
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor,
                      ),
                    ),
                    FavoriteWidget(item: product)
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
