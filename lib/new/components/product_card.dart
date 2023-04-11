import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:student_shopping_v1/new/models/Product.dart';
// import 'package:student_shopping_v1/new/screens/details/details_screen.dart';

import '../../Widgets/FavoriteWidget.dart';
import '../../models/itemModel.dart';
import '../../models/recentItemModel.dart';
import '../../pages/itemDetailPage.dart';
import '../../pages/itemDetailPageSellerView.dart';
import '../constants.dart';
import '../size_config.dart';

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
      padding: EdgeInsets.all(getProportionateScreenWidth(5)),
      child: SizedBox(
        width: getProportionateScreenWidth(width),
        child: GestureDetector(
          onTap: () => Navigator.of(context).push(new MaterialPageRoute(
              builder: (context) => new ItemDetails(
                  context.watch<RecentItemModel>().currentUserId,
                  product
              ))),
          //TODO: ADD BACK
          // onTap: () => Navigator.pushNamed(
          //   context,
          //   DetailsScreen.routeName,
          //   arguments: ProductDetailsArguments(product: product),
          // ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.5,
                child: Container(
                  padding: EdgeInsets.all(getProportionateScreenWidth(4)),
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
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    product.name,
                    style: TextStyle(color: Colors.black),
                    maxLines: 2,
                  ),
                  product.isSold ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: MediaQuery.of(context).size.width * .10,
                      height: MediaQuery.of(context).size.height * .02,
                      margin: EdgeInsets.only(top: 0, left: MediaQuery.of(context).size.width * .001),
                      child: Center(
                        child: Text(
                          "SOLD!",
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black),
                          // margin: EdgeInsets.all(8),
                          // color: Colors.blue,
                        ),
                      ),
                      color: Colors.green,
                    ),
                  ) : Expanded(child: Container()),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\$${product.price}",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(18),
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor,
                    ),
                  ),
                  FavoriteWidget(item: product)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
