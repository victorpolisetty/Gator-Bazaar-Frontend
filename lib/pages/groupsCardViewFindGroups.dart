import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
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
      padding: EdgeInsets.all(getProportionateScreenWidth(5)),
      child: SizedBox(
        width: getProportionateScreenWidth(width),
        child: InkWell(
          onTap: (){},
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
              Row(
                children: [
                  Flexible(
                    child: AutoSizeText(
                      group.name!,
                      style: TextStyle(color: Colors.black),
                      maxLines: 2,
                      minFontSize: 8, // Set a minimum font size to ensure visibility
                    ),
                  ),
                  SizedBox(width: getProportionateScreenWidth(10)), // Reduce the space between the text and the button
                  Container(
                    width: getProportionateScreenWidth(100), // Set a fixed width for the button
                    child: !isRequested
                        ? TextButton(
                      onPressed: () {
                        showAlertDialogRequestGroup(context, group.name);
                      },
                      child: AutoSizeText(
                        'Request to Join',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: getProportionateScreenWidth(12)),
                        maxLines: 1,
                        minFontSize: 8, // Set a minimum font size to ensure visibility
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(
                          vertical: getProportionateScreenHeight(8),// Adjust vertical padding
                          horizontal: getProportionateScreenWidth(8),// Adjust horizontal padding
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),// Add BorderRadius to the button
                        ),
                      ),
                      // ...
                    )
                        : TextButton(
                      onPressed: () {
                        showAlertDialogRequestGroup(context, group.name);
                      },
                      child: AutoSizeText(
                        'Pending',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: getProportionateScreenWidth(12)),
                        maxLines: 1,
                        minFontSize: 8, // Set a minimum font size to ensure visibility
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: EdgeInsets.symmetric(
                          vertical: getProportionateScreenHeight(8),// Adjust vertical padding
                          horizontal: getProportionateScreenWidth(8),// Adjust horizontal padding
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),// Add BorderRadius to the button
                        ),
                      ),
                      // ...
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
