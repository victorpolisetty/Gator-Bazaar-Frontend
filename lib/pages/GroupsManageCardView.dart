import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
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
      padding: EdgeInsets.all(5.sp), // Use sizer to set padding
      child: SizedBox(
        width: width.w, // Use sizer to set width
        child: InkWell(
          onTap: () {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.5,
                child: Container(
                  padding: EdgeInsets.all(4.sp), // Use sizer to set padding
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15.sp), // Use sizer to set border radius
                  ),
                  child: Hero(
                    tag: group.id.toString() + uniqueIdentifier,
                    child: group.imageURL != null
                        ? Image.memory(group.imageURL!)
                        : Image.asset('assets/gb_placeholder.jpg'),
                  ),
                ),
              ),
              SizedBox(height: 10.sp), // Use sizer to set height
              Row(
                children: [
                  Flexible(
                    child: Text(
                      group.name!,
                      style: TextStyle(color: Colors.black),
                      maxLines: 2,
                    ),
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