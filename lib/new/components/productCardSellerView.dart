import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import '../../Widgets/FavoriteWidget.dart';
import '../../models/itemModel.dart';
import '../../models/recentItemModel.dart';
import '../../pages/itemDetailPageSellerView.dart';
import '../constants.dart';
import 'package:sizer/sizer.dart';

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
      padding: EdgeInsets.all(SizerUtil.deviceType == DeviceType.mobile ? 2.0.sp : 2.0),
      child: SizedBox(
        width: SizerUtil.deviceType == DeviceType.mobile ? 80.0.w : 140.0, // Adjust the width as needed
        child: GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ItemDetailPageSellerView(
                context.watch<RecentItemModel>().currentUserId,
                product,
                pagingController,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.5,
                child: Container(
                  padding: EdgeInsets.all(SizerUtil.deviceType == DeviceType.mobile ? 10.0.sp : 10.0),
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(SizerUtil.deviceType == DeviceType.mobile ? 10.0.sp : 10.0),
                  ),
                  child: Hero(
                    tag: product.id.toString() + uniqueIdentifier,
                    child: product.imageDataList.length > 0
                        ? Image.memory(
                      product.imageDataList[0],
                      fit: BoxFit.cover,
                    )
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
                  if (product.isSold!)
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizerUtil.deviceType == DeviceType.mobile ? 2.0.sp : 2.0,
                          vertical: SizerUtil.deviceType == DeviceType.mobile ? 1.0.sp : 1.0), // 2% of the screen width, 1% of the screen height
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(SizerUtil.deviceType == DeviceType.mobile ? 8.0.sp : 8.0),
                      ),
                      child: Text(
                        "SOLD!",
                        style: TextStyle(
                          fontSize: SizerUtil.deviceType == DeviceType.mobile ? 8.sp : 8,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
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
