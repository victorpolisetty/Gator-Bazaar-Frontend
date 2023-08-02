import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:student_shopping_v1/models/groupRequestModel.dart';
import 'package:student_shopping_v1/models/sellerItemModel.dart';
import 'package:student_shopping_v1/new/components/productCardSellerView.dart';
import 'package:student_shopping_v1/pages/addNewGroupsRequestPage.dart';
import 'package:student_shopping_v1/pages/groupsCardViewMyGroups.dart';
import 'package:student_shopping_v1/pages/sellerProfilePageBody.dart';
import 'package:provider/provider.dart';
import '../models/groupModel.dart';
import '../new/size_config.dart';
import 'groupsCardViewAdminGroups.dart';
import 'groupsCardViewFindGroups.dart';
import 'itemDetailPage.dart';

class manageGroupsPage extends StatefulWidget {
  @override
  State<manageGroupsPage> createState() => _manageGroupsPageState();
}

class _manageGroupsPageState extends State<manageGroupsPage> {
  late SearchBar searchBar;
  final PagingController<int, Group> _pagingControllerMyGroups =
  PagingController(firstPageKey: 0);
  final PagingController<int, Group> _pagingControllerFindGroups =
  PagingController(firstPageKey: 0);
  final PagingController<int, Group> _pagingControllerAdminGroups =
  PagingController(firstPageKey: 0);
  final PagingController<int, Group> _pagingControllerRequestNewGroup =
  PagingController(firstPageKey: 0);
  int totalPages = 0;
  @override
  void initState() {
    Provider.of<GroupRequestModel>(context, listen: false).getGroupRequestsPrfId();
    _pagingControllerMyGroups.addPageRequestListener((pageKey) {
      _fetchPageMyGroups(pageKey, 1);
    });
    _pagingControllerFindGroups.addPageRequestListener((pageKey) {
      _fetchPageFindGroups(pageKey, 1);
    });
    _pagingControllerAdminGroups.addPageRequestListener((pageKey) {
      _fetchPageAdminGroups(pageKey, 1);
    });
    _pagingControllerRequestNewGroup.addPageRequestListener((pageKey) {
      _fetchPageRequestNewGroup(pageKey, 1);
    });
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
    if(!mounted) _pagingControllerMyGroups.dispose();
    if(!mounted) _pagingControllerFindGroups.dispose();
    if(!mounted) _pagingControllerAdminGroups.dispose();
    if(!mounted) _pagingControllerRequestNewGroup.dispose();

  }

  Future<void> _fetchPageMyGroups(int pageKey, int categoryId) async {
    try {
      await Provider.of<GroupModel>(context, listen: false).getGroupsUserInAndImages(pageKey);
      totalPages = Provider.of<GroupModel>(context, listen: false).totalPages;
      if(mounted) {
        final isLastPage = (totalPages-1) == pageKey;

        if (isLastPage) {
          _pagingControllerMyGroups.appendLastPage(Provider.of<GroupModel>(context, listen: false).groupListMyGroups);
        } else {
          final int? nextPageKey = pageKey + 1;
          _pagingControllerMyGroups.appendPage(Provider.of<GroupModel>(context, listen: false).groupListMyGroups, nextPageKey);
        }
      }
    } catch (error) {
      _pagingControllerMyGroups.error = error;
    }
  }

  Future<void> _fetchPageFindGroups(int pageKey, int categoryId) async {
    try {
      await Provider.of<GroupModel>(context, listen: false).getGroupsUserNotInAndImages(pageKey);
      totalPages = Provider.of<GroupModel>(context, listen: false).totalPages;
      if(mounted) {
        final isLastPage = (totalPages-1) == pageKey;

        if (isLastPage) {
          _pagingControllerFindGroups.appendLastPage(Provider.of<GroupModel>(context, listen: false).groupListFindGroups);
        } else {
          final int? nextPageKey = pageKey + 1;
          _pagingControllerFindGroups.appendPage(Provider.of<GroupModel>(context, listen: false).groupListFindGroups, nextPageKey);
        }
      }
    } catch (error) {
      _pagingControllerFindGroups.error = error;
    }
  }

  Future<void> _fetchPageAdminGroups(int pageKey, int categoryId) async {
    try {
      await Provider.of<GroupModel>(context, listen: false).getGroupsUserInAndImagesAdmin(pageKey);
      totalPages = Provider.of<GroupModel>(context, listen: false).totalPages;
      if(mounted) {
        final isLastPage = (totalPages-1) == pageKey;

        if (isLastPage) {
          _pagingControllerAdminGroups.appendLastPage(Provider.of<GroupModel>(context, listen: false).groupListAdminGroups);
        } else {
          final int? nextPageKey = pageKey + 1;
          _pagingControllerAdminGroups.appendPage(Provider.of<GroupModel>(context, listen: false).groupListAdminGroups, nextPageKey);
        }
      }
    } catch (error) {
      _pagingControllerAdminGroups.error = error;
    }
  }

  Future<void> _fetchPageRequestNewGroup(int pageKey, int categoryId) async {
    try {
      await Provider.of<GroupModel>(context, listen: false).getGroupsUserInAndImagesAdmin(pageKey);
      totalPages = Provider.of<GroupModel>(context, listen: false).totalPages;
      if(mounted) {
        final isLastPage = (totalPages-1) == pageKey;

        if (isLastPage) {
          _pagingControllerRequestNewGroup.appendLastPage(Provider.of<GroupModel>(context, listen: false).groupListAdminGroups);
        } else {
          final int? nextPageKey = pageKey + 1;
          _pagingControllerRequestNewGroup.appendPage(Provider.of<GroupModel>(context, listen: false).groupListAdminGroups, nextPageKey);
        }
      }
    } catch (error) {
      _pagingControllerRequestNewGroup.error = error;
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
        "My Groups",
        style: TextStyle(color: Colors.black),
      ),

      actions: [
      ],
    );
  }

  _manageGroupsPageState() {
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
    int numTabs = 4; // Number of tabs
    double availableWidth = MediaQuery.of(context).size.width / numTabs;
    double maxFontSize = availableWidth * 0.2; // Adjust the scaling factor (0.1) as needed
    final upperTab = new TabBar(labelColor: Colors.black, tabs: <Tab>[
      new Tab(child: Text("My Groups", style: TextStyle(fontSize: maxFontSize))),
      new Tab(child: Text("Find Groups", style: TextStyle(fontSize: maxFontSize))),
      new Tab(child: Text("New Groups", style: TextStyle(fontSize: maxFontSize))),
      new Tab(child: Text("Admin Groups", style: TextStyle(fontSize: maxFontSize)),
      )]);
    //MY GROUPS
    return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: new DefaultTabController(
          length: 4,
          child: Scaffold(
            resizeToAvoidBottomInset: false,

            appBar: AppBar(
              title: Text("Manage Groups", style: TextStyle(color: Colors.black),),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  TabBar(
                    labelColor: Colors.black,
                    isScrollable: true, // Make the TabBar scrollable
                    tabs: <Widget>[
                      Center(
                        child: Text(
                          "My Groups",
                          style: TextStyle(fontSize: maxFontSize),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Center(
                        child: Text(
                          "Find Groups",
                          style: TextStyle(fontSize: maxFontSize),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Center(
                        child: Text(
                          "Request Group",
                          style: TextStyle(fontSize: maxFontSize),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Center(
                        child: Text(
                          "Admin Groups",
                          style: TextStyle(fontSize: maxFontSize),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
            body: TabBarView(
              children: [
                //MY GROUPS
                RefreshIndicator(
                  onRefresh: () =>
                      Future.sync(() => _pagingControllerMyGroups.refresh()),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * .58,
                        child: PagedGridView(
                          pagingController: _pagingControllerMyGroups,
                          shrinkWrap: true,
                          builderDelegate:
                          PagedChildBuilderDelegate<Group>(
                            firstPageProgressIndicatorBuilder: (_) =>
                                Center(child: spinkit),
                            newPageProgressIndicatorBuilder: (_) =>
                                Center(child: spinkit),
                            itemBuilder:
                                (BuildContext context, group, int index) {
                              return GroupsCardViewMyGroups(
                                  group: group,
                                  pagingControllerFindGroups: _pagingControllerFindGroups,
                                  pagingControllerMyGroups: _pagingControllerMyGroups,
                                  pagingControllerAdminGroups: _pagingControllerAdminGroups,
                                  uniqueIdentifier: "groupCardMyGroups",
                                  context: context);
                              // padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
                            },
                          ),
                          // controller: _controller,
                          // itemCount: recentList.items.length,
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: .7,
                            crossAxisCount: 2,
                            mainAxisSpacing: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //FIND GROUPS
                RefreshIndicator(
                  onRefresh: () {
                    Provider.of<GroupRequestModel>(context, listen: false).getGroupRequestsPrfId();
                    return Future.sync(() => _pagingControllerFindGroups.refresh());
                  },

                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * .58,
                        child: PagedGridView(
                          pagingController: _pagingControllerFindGroups,
                          shrinkWrap: true,
                          builderDelegate:
                          PagedChildBuilderDelegate<Group>(
                            firstPageProgressIndicatorBuilder: (_) =>
                                Center(child: spinkit),
                            newPageProgressIndicatorBuilder: (_) =>
                                Center(child: spinkit),
                            itemBuilder:
                                (BuildContext context, group, int index) {
                                  bool isRequested = false;
                                  List<GroupRequest> groupRequestList = Provider.of<GroupRequestModel>(context, listen: false).groupRequestList;
                                  for(int i = 0; i < groupRequestList.length; i++) {
                                    if(groupRequestList[i].group_id == group.id) {
                                      isRequested = true;
                                      break;
                                    }
                                  }
                              return GroupsCardViewFindGroups(
                                group: group,
                                pagingControllerFindGroups: _pagingControllerFindGroups,
                                isRequested: isRequested,
                                uniqueIdentifier: "groupCardFindGroups",);
                            },
                          ),
                          // controller: _controller,
                          // itemCount: recentList.items.length,
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: .7,
                            crossAxisCount: 2,
                            mainAxisSpacing: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //REQUEST NEW GROUP
                SafeArea(
                    child: IndexedStack(
                      children: [
                        AddNewGroupsRequest()
                      ],
                    )),
                //ADMIN GROUPS
                RefreshIndicator(
                  onRefresh: () =>
                      Future.sync(() => _pagingControllerAdminGroups.refresh()),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * .58,
                        child: PagedGridView(
                          pagingController: _pagingControllerAdminGroups,
                          shrinkWrap: true,
                          builderDelegate:
                          PagedChildBuilderDelegate<Group>(
                            firstPageProgressIndicatorBuilder: (_) =>
                                Center(child: spinkit),
                            newPageProgressIndicatorBuilder: (_) =>
                                Center(child: spinkit),
                            itemBuilder:
                                (BuildContext context, group, int index) {
                              return GroupsCardViewAdminGroups(
                                group: group,
                                onUserRemoved: refreshLists,
                                uniqueIdentifier: "groupCardAdminGroups",);
                              // padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
                            },
                          ),
                          // controller: _controller,
                          // itemCount: recentList.items.length,

                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: .7,
                            crossAxisCount: 2,
                            mainAxisSpacing: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));

  }
  void refreshLists() async {
    await Provider.of<GroupModel>(context, listen: false).getGroupsUserNotInAndImages(0);
    _pagingControllerFindGroups.refresh();

    await Provider.of<GroupModel>(context, listen: false).getGroupsUserInAndImages(0);
    _pagingControllerMyGroups.refresh();

    await Provider.of<GroupModel>(context, listen: false).getGroupsUserInAndImagesAdmin(0);
    _pagingControllerAdminGroups.refresh();
  }
}