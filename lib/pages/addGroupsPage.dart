import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:student_shopping_v1/models/sellerItemModel.dart';
import 'package:student_shopping_v1/new/components/productCardSellerView.dart';
import 'package:student_shopping_v1/pages/GroupsManageCardView.dart';
import 'package:student_shopping_v1/pages/groupsCardViewMyGroups.dart';
import 'package:student_shopping_v1/pages/sellerProfilePageBody.dart';
import 'package:provider/provider.dart';
import '../models/groupModel.dart';
import '../models/itemModel.dart';
import '../new/size_config.dart';
import 'itemDetailPage.dart';

class addGroupsPage extends StatefulWidget {
  @override
  State<addGroupsPage> createState() => _addGroupsPageState();
}

class _addGroupsPageState extends State<addGroupsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late SearchBar searchBar;
  final PagingController<int, Group> _pagingController =
  PagingController(firstPageKey: 0);
  int totalPages = 0;
  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey, 1);
    });
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
    if(!mounted) _pagingController.dispose();
  }

  Future<void> _fetchPage(int pageKey, int categoryId) async {
    try {
      await Provider.of<GroupModel>(context, listen: false).getGroupsUserNotInAndImages(pageKey);
      totalPages = Provider.of<GroupModel>(context, listen: false).totalPages;
      if(mounted) {
        final isLastPage = (totalPages-1) == pageKey;

        if (isLastPage) {
          _pagingController.appendLastPage(Provider.of<GroupModel>(context, listen: false).groupListMyGroups);
        } else {
          final int? nextPageKey = pageKey + 1;
          _pagingController.appendPage(Provider.of<GroupModel>(context, listen: false).groupListMyGroups, nextPageKey);
        }
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }
  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      leading: InkWell(
        onTap: (){
          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.black54,
        ),
      ),
      elevation: .1,
      title:
      Text(
        "Add Groups",
        style: TextStyle(color: Colors.black),
      ),
      actions: [
      ],
    );
  }

  _addGroupsPageState() {
    searchBar = new SearchBar(
        inBar: false,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        // onSubmitted: onSubmitted,
        onCleared: () {
          print("Search bar has been cleared");
        },
        onClosed: () {
          print("Search bar has been closed");
        });
  }
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: new Scaffold(
            appBar: searchBar.build(context),
            key: _scaffoldKey,
            body:
            Center(
              child:
              new
              PagedGridView(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<Group>(
                    firstPageProgressIndicatorBuilder: (_) => Center(child: spinkit),
                    newPageProgressIndicatorBuilder: (_) => Center(child: spinkit),
                    noItemsFoundIndicatorBuilder: (_) => Center(child: Text("No Groups Yet :)", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),)),
                    itemBuilder: (BuildContext context, group, int index) {
                      return GroupsManageCardView(
                        group: group,
                        uniqueIdentifier: "groupCard",
                      );
                    }
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 0,),
              ),
            )
        ));
  }
}