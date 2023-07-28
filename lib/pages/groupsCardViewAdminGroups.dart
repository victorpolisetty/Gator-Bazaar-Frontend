import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:student_shopping_v1/pages/adminSpecificGroupView.dart';
import '../../Widgets/FavoriteWidget.dart';
import '../../models/itemModel.dart';
import '../../models/recentItemModel.dart';
import '../../pages/itemDetailPageSellerView.dart';
import '../constants.dart';
import '../models/groupModel.dart';
import '../new/constants.dart';
import '../new/size_config.dart';
import 'manageGroupsPage.dart';
import 'package:sizer/sizer.dart'; // Import the sizer package

class GroupsCardViewAdminGroups extends StatelessWidget {
  const GroupsCardViewAdminGroups({
    Key? key,
    this.width = 140,
    this.aspectRetio = 1.02,
    required this.group,
    required this.uniqueIdentifier,
    required this.onUserRemoved,
  }) : super(key: key);

  final double width, aspectRetio;
  final Group group;
  final String uniqueIdentifier;
  final VoidCallback onUserRemoved;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.sp), // Use sizer to set padding
      child: SizedBox(
        width: 140.w, // Use sizer to set width
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => adminSpecificGroupView(
                group: group,
                onUserRemoved: onUserRemoved,
              ),
            ));
          },
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
                        : Image.asset('assets/images/GatorBazaar.jpg'),
                  ),
                ),
              ),
              const SizedBox(height: 10), // Use sizer to set vertical spacing
              Text(
                group.name!,
                style: TextStyle(color: Colors.black),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
