import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Widgets/FavoriteWidget.dart';
import '../../models/itemModel.dart';
import '../../models/recentItemModel.dart';
import '../../pages/itemDetailPage.dart';
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
      padding: EdgeInsets.all(3.w), // Increase the padding
      child: SizedBox(
        width: SizerUtil.deviceType == DeviceType.mobile ? 40.0.w : 100.0.w, // Adjust the width as needed
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
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(SizerUtil.deviceType == DeviceType.mobile ? 10.0.sp : 10.0),
                    image: product.imageDataList.isNotEmpty
                        ? DecorationImage(
                      image: MemoryImage(product.imageDataList[0]),
                      fit: BoxFit.cover,
                    )
                        : DecorationImage(
                      image: AssetImage('assets/gb_placeholder.jpg'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10), // Increase the space between the image and other elements
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      product.name!,
                      style: TextStyle(color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (product.isSold!)
                    Container(
                      width: SizerUtil.deviceType == DeviceType.mobile ? 10.0.w : 10.0,
                      height: SizerUtil.deviceType == DeviceType.mobile ? 2.0.h : 2.0,
                      margin: EdgeInsets.only(left: SizerUtil.deviceType == DeviceType.mobile ? 0.1.w : 0.1),
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
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      "\$${product.price}",
                      style: TextStyle(
                        fontSize: SizerUtil.deviceType == DeviceType.mobile ? 10.0.sp : 18.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
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
