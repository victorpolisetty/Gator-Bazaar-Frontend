import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Widgets/FavoriteWidget.dart';
import '../../models/itemModel.dart';
import '../../models/recentItemModel.dart';
import '../../pages/itemDetailPage.dart';
import 'new/constants.dart';

class ProductCardFav extends StatelessWidget {
  const ProductCardFav({
    Key? key,
    this.width = 140.0,
    this.aspectRetio = 1.02,
    required this.product,
    required this.uniqueIdentifier,
  }) : super(key: key);

  final double width, aspectRetio;
  final ItemWithImages product;
  final String uniqueIdentifier;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.sp),
      child: SizedBox(
        width: width.sp,
        child: InkWell(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ItemDetails(
              context.watch<RecentItemModel>().currentUserId,
              product,
            ),
          )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.5,
                child: Container(
                  padding: EdgeInsets.all(4.sp),
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15.sp),
                  ),
                  child: Hero(
                    tag: uniqueIdentifier + product.id.toString(),
                    child: product.imageDataList.length > 0
                        ? Image.memory(product.imageDataList[0])
                        : Image.asset('assets/gb_placeholder.jpg'),
                  ),
                ),
              ),
              SizedBox(height: 10.sp),
              Text(
                product.name!,
                style: TextStyle(color: Colors.black),
                maxLines: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\$${product.price}",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor,
                    ),
                  ),
                  FavoriteWidget(item: product),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}


