import 'package:flutter/material.dart';
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
  }) : super(key: key);

  final ItemWithImages product;
  final String uniqueIdentifier;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(getProportionateScreenWidth(4)),  // reducing padding
      child: LayoutBuilder(
        builder: (context, constraints) {
          return InkWell(
            onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => new ItemDetailPageSellerView(
                    context.watch<RecentItemModel>().currentUserId,
                    product
                ))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1.5,  // adjusting aspect ratio
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
                const SizedBox(height: 5),  // reducing vertical spacing
                Text(
                  product.name,
                  style: TextStyle(color: Colors.black),
                  maxLines: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${product.price}",
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(16),  // reducing font size
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
