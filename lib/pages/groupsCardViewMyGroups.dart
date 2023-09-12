import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:student_shopping_v1/pages/specificGroupPage.dart';

import '../models/groupModel.dart';
import '../new/constants.dart';

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
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3.w), // Increase the padding
      child: SizedBox(
        width: SizerUtil.deviceType == DeviceType.mobile ? 40.0.w : 100.0.w, // Adjust the width as needed
        child: GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SpecificGroupPage(
                groupId: group.id!,
                groupName: group.name!,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.2,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(SizerUtil.deviceType == DeviceType.mobile ? 10.0.sp : 10.0),
                    image: group.imageURL != null
                        ? DecorationImage(
                      image: MemoryImage(group.imageURL!),
                      fit: BoxFit.scaleDown,
                    )
                        : DecorationImage(
                      image: AssetImage('assets/gb_placeholder.jpg'),
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
                      style: TextStyle(color: Colors.white),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(Icons.delete,size: 20.sp,),
                      color: Colors.red,
                      onPressed: () {
                        _showConfirmDeleteButton(context, 0);
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
}
  void _showConfirmDeleteButton(BuildContext buildContext, int? itemId) {
    showDialog(
      context: buildContext,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: group.id != 1 ? AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Are you sure you want to leave this group?"),
              ListTile(
                title: Text("Yes"),
                onTap: () {
                  Provider.of<GroupModel>(buildContext, listen: false)
                      .packagedDeleteGroupFromProfile(group.id)
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
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ) : AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("You cannot leave the University of Florida group"),
              ListTile(
                title: Text("Ok"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


