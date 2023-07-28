import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../Widgets/FavoriteWidget.dart';
import '../../models/itemModel.dart';
import '../../models/recentItemModel.dart';
import '../../pages/itemDetailPageSellerView.dart';
import '../constants.dart';
import '../models/groupModel.dart';
import '../models/groupRequestModel.dart';
import '../new/constants.dart';
import '../new/size_config.dart';
import 'manageGroupsPage.dart';

class GroupsCardViewFindGroups extends StatelessWidget {
  const GroupsCardViewFindGroups({
    Key? key,
    this.width = 140,
    this.aspectRetio = 1.02,
    required this.group,
    required this.uniqueIdentifier,
    required this.isRequested,
    required this.pagingControllerFindGroups
  }) : super(key: key);

  final double width, aspectRetio;
  final Group group;
  final String uniqueIdentifier;
  final bool isRequested;
  final PagingController<int, Group> pagingControllerFindGroups;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.sp),
      child: SizedBox(
        width: width.w,
        child: InkWell(
          onTap: () {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(4.sp),
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15.sp),
                  ),
                  child: Hero(
                    tag: group.id.toString() + uniqueIdentifier,
                    child: group.imageURL != null
                        ? Image.memory(group.imageURL!)
                        : Image.asset('assets/images/GatorBazaar.jpg'),
                  ),
                ),
              ),
              SizedBox(height: 10.sp),
              Row(
                children: [
                  Expanded(
                    child: AutoSizeText(
                      group.name!,
                      style: TextStyle(color: Colors.black),
                      maxLines: 2,
                      minFontSize: 8,
                      stepGranularity: 8,
                    ),
                  ),
                  SizedBox(width: 10.sp),
                  Container(
                    width: 20.w,
                    height: 5.h,
                    child: !isRequested
                        ? TextButton(
                      onPressed: () {
                        showAlertDialogRequestGroup(context, group.name);
                      },
                      child: Text(
                        'Request to Join',
                        style: TextStyle(color: Colors.white, fontSize: 5.sp),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 8.sp),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.sp),
                        ),
                      ),
                    )
                        : TextButton(
                      onPressed: () {
                        showAlertDialogRequestGroup(context, group.name);
                      },
                      child: Text(
                        'Pending',
                        style: TextStyle(color: Colors.white, fontSize: 12.sp),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 8.sp),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.sp),
                        ),
                      ),
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


  showAlertDialogRequestGroup(BuildContext context, String? groupName) {

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed:  () {
        Provider.of<GroupRequestModel>(context, listen: false).postGroupRequest(group.id)
            .then((value) => Navigator.of(context).pop())
            .then((value) => Provider.of<GroupRequestModel>(context, listen: false).getGroupRequestsPrfId()
            .then((value) => Future.sync(() => pagingControllerFindGroups.refresh())));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Request to Join"),
      content: Text("Are you sure you want to request to join the group: $groupName"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
