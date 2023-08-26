
import 'package:flutter/material.dart';

import 'package:student_shopping_v1/pages/adminSpecificGroupView.dart';

import '../models/groupModel.dart';
import '../new/constants.dart';

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
      padding: EdgeInsets.all(1.w), // Increase the padding
      child: SizedBox(
        width: width.w,
        child: InkWell(
          onTap: (){
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
                aspectRatio: 1.2,
                child: Container(
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(SizerUtil.deviceType == DeviceType.mobile ? 10.0.sp : 10.0),
                    image: group.imageURL != null
                        ? DecorationImage(
                      image: MemoryImage(group.imageURL!),
                      fit: BoxFit.scaleDown,
                    )
                        : DecorationImage(
                      image: AssetImage('assets/images/GatorBazaar.jpg'),
                      fit: BoxFit.scaleDown,
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
                      group.name!,
                      style: TextStyle(color: Colors.black),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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


