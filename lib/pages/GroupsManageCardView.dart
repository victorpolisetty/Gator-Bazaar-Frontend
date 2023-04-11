import 'package:flutter/material.dart';
import '../../Widgets/FavoriteWidget.dart';
import '../models/groupModel.dart';
import '../new/constants.dart';
import '../new/size_config.dart';

class GroupsManageCardView extends StatelessWidget {
  const GroupsManageCardView({
    Key? key,
    this.width = 140,
    this.aspectRetio = 1.02,
    required this.group,
    required this.uniqueIdentifier,
  }) : super(key: key);

  final double width, aspectRetio;
  final Group group;
  final String uniqueIdentifier;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(getProportionateScreenWidth(5)),
      child: SizedBox(
        width: getProportionateScreenWidth(width),
        child: InkWell(
          onTap: (){},
          // onTap: () => Navigator.of(context).push(new MaterialPageRoute(
          //     builder: (context) => new ItemDetailPageSellerView(
          //         context.watch<RecentItemModel>().currentUserId,
          //         product
          //     ))),
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
                    tag: group.id.toString() + uniqueIdentifier,
                    child: group.imageURL != null ?
                    Image.memory(group.imageURL!) : Image.asset('assets/images/GatorBazaar.jpg'),
                  ),

                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    group.name!,
                    style: TextStyle(color: Colors.black),
                    maxLines: 2,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}