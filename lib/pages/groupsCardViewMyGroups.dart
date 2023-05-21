import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:student_shopping_v1/pages/specificGroupPage.dart';
import '../../Widgets/FavoriteWidget.dart';
import '../../models/itemModel.dart';
import '../../models/recentItemModel.dart';
import '../../pages/itemDetailPageSellerView.dart';
import '../constants.dart';
import '../models/groupModel.dart';
import '../new/constants.dart';
import '../new/size_config.dart';

class GroupsCardViewMyGroups extends StatelessWidget {
  const GroupsCardViewMyGroups({
    Key? key,
    this.width = 140,
    this.aspectRetio = 1.02,
    required this.group,
    required this.uniqueIdentifier,
    required this.pagingControllerFindGroups,
    required this.pagingControllerMyGroups,
    required this.pagingControllerAdminGroups,
    required this.context,
  }) : super(key: key);

  final double width, aspectRetio;
  final Group group;
  final String uniqueIdentifier;
  final BuildContext context;
  final PagingController<int, Group> pagingControllerFindGroups;
  final PagingController<int, Group> pagingControllerMyGroups;
  final PagingController<int, Group> pagingControllerAdminGroups;

  @override
  Widget build(BuildContext buildContext) {
    return Padding(
      padding: EdgeInsets.all(getProportionateScreenWidth(5)),
      child: SizedBox(
        width: getProportionateScreenWidth(width),
        child: AspectRatio(
          aspectRatio: aspectRetio,
          child: InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SpecificGroupPage(groupId: group.id!, groupName: group.name!)),);
            },
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
                SizedBox(height: getProportionateScreenHeight(10)),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        group.name!,
                        style: TextStyle(color: Colors.black),
                        maxLines: 2,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                          icon: Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () {
                            _showConfirmDeleteButton(buildContext, 0);
                          }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _showConfirmDeleteButton(BuildContext buildContext, int? itemId){
    BuildContext dialogContext;
    showDialog(context: buildContext,
        builder: (context) => WillPopScope(
        onWillPop: () async => false,
    child: AlertDialog(
    // dialogContext = context;
    content: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
    Text("Are you sure you want to leave this group?"),
    ListTile(
    title: Text("Yes"),
    onTap: (){
    Provider.of<GroupModel>(buildContext, listen: false).packagedDeleteGroupFromProfile(group.id)
        .then((value) => Navigator.of(buildContext).pop())
        .then((value) => Provider.of<GroupModel>(buildContext, listen: false).getGroupsUserNotInAndImages(0))
        .then((value) => Future.sync(() => pagingControllerFindGroups.refresh()))
        .then((value) => Provider.of<GroupModel>(buildContext, listen: false).getGroupsUserInAndImages(0))
        .then((value) => Future.sync(() => pagingControllerMyGroups.refresh()))
        .then((value) => Provider.of<GroupModel>(buildContext, listen: false).getGroupsUserInAndImagesAdmin(0))
        .then((value) => Future.sync(() => pagingControllerAdminGroups.refresh()));
    },
    ),
      ListTile(
        title: Text("No"),
        onTap: (){
          // _loadPicker(ImageSource.gallery, imageNumber);
          Navigator.pop(context);
        },
      ),
    ],
    ),
    ),
        ) );
  }
}

