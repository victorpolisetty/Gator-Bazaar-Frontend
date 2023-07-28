import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:student_shopping_v1/new/models/Product.dart';
import '../../Widgets/FavoriteWidget.dart';
import '../../models/itemModel.dart';
import '../../models/recentItemModel.dart';
import '../../pages/itemDetailPage.dart';
import '../../pages/itemDetailPageSellerView.dart';
import '../constants.dart';
import 'package:sizer/sizer.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    this.width = 140,
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
      padding: EdgeInsets.all(SizerUtil.deviceType == DeviceType.mobile ? 2.0.sp : 2.0),
      child: SizedBox(
        width: SizerUtil.deviceType == DeviceType.mobile ? 80.0.w : 140.0, // Adjust the width as needed
        child: GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ItemDetails(
                context.watch<RecentItemModel>().currentUserId,
                product,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 2.3,
                child: Container(
                  padding: EdgeInsets.all(SizerUtil.deviceType == DeviceType.mobile ? 4.0.sp : 4.0),
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(SizerUtil.deviceType == DeviceType.mobile ? 10.0.sp : 10.0),
                  ),
                  child: Hero(
                    tag: product.id.toString() + uniqueIdentifier,
                    child: product.imageDataList.length > 0
                        ? Image.memory(product.imageDataList[0])
                        : Image.asset('assets/images/GatorBazaar.jpg'),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      product.name!,
                      style: TextStyle(color: Colors.black),
                      maxLines: 2,
                    ),
                  ),
                  product.isSold!
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(SizerUtil.deviceType == DeviceType.mobile ? 8.0.sp : 8.0),
                    child: Container(
                      width: SizerUtil.deviceType == DeviceType.mobile ? 10.0.w : 10.0,
                      height: SizerUtil.deviceType == DeviceType.mobile ? 2.0.h : 2.0,
                      margin: EdgeInsets.only(top: 0, left: SizerUtil.deviceType == DeviceType.mobile ? 0.1.w : 0.1),
                      child: Center(
                        child: Text(
                          "SOLD!",
                          style: TextStyle(
                            fontSize: SizerUtil.deviceType == DeviceType.mobile ? 8.sp : 8,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      color: Colors.green,
                    ),
                  )
                      : Container(),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\$${product.price}",
                    style: TextStyle(
                      fontSize: SizerUtil.deviceType == DeviceType.mobile ? 10.0.sp : 18.0,
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
