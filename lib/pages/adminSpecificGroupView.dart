import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sizer/sizer.dart';
import 'package:student_shopping_v1/models/adminProfileModel.dart';
import 'package:student_shopping_v1/models/groupRequestModel.dart';
import 'package:student_shopping_v1/pages/AdminRowView.dart';
import 'package:student_shopping_v1/pages/RequestsRowAdminView.dart';

import 'package:provider/provider.dart';
import '../models/groupModel.dart';
import 'MembersRowAdminView.dart';

import 'itemDetailPage.dart';

class adminSpecificGroupView extends StatefulWidget {
  const adminSpecificGroupView({
    Key? key,
    required this.group,
    required this.onUserRemoved

  }) : super(key: key);

  final Group group;
  final VoidCallback onUserRemoved;

  @override
  State<adminSpecificGroupView> createState() => _adminSpecificGroupViewState();
}

class _adminSpecificGroupViewState extends State<adminSpecificGroupView> {
  late SearchBar searchBar;
  final PagingController<int, AdminProfile> _pagingControllerMembers =
  PagingController(firstPageKey: 0);
  final PagingController<int, AdminProfile> _pagingControllerRequests =
  PagingController(firstPageKey: 0);
  final PagingController<int, AdminProfile> _pagingControllerAdmins =
  PagingController(firstPageKey: 0);
  int totalPages = 0;
  @override
  void initState() {
    _pagingControllerMembers.addPageRequestListener((pageKey) {
      _fetchPageMembers(pageKey, widget.group.id!);
    });
    _pagingControllerRequests.addPageRequestListener((pageKey) {
      _fetchPageRequests(pageKey, widget.group.id!);
    });
    _pagingControllerAdmins.addPageRequestListener((pageKey) {
      _fetchPageAdmins(pageKey, widget.group.id!);
    });


    super.initState();
  }

  Future<void> _fetchPageMembers(int pageKey, int groupId) async {
    try {
      await Provider.of<AdminProfileModel>(context, listen: false).getMembersInGroup(pageKey, groupId);
      totalPages = Provider.of<AdminProfileModel>(context, listen: false).totalPages;
      if(mounted) {
        final isLastPage = (totalPages-1) == pageKey;

        if (isLastPage) {
          _pagingControllerMembers.appendLastPage(Provider.of<AdminProfileModel>(context, listen: false).memberInGroupList);
        } else {
          final int? nextPageKey = pageKey + 1;
          _pagingControllerMembers.appendPage(Provider.of<AdminProfileModel>(context, listen: false).memberInGroupList, nextPageKey);
        }
      }
    } catch (error) {
      _pagingControllerMembers.error = error;
    }
  }

  Future<void> _fetchPageRequests(int pageKey, int groupId) async {
    try {
      await Provider.of<AdminProfileModel>(context, listen: false).getRequestsInGroup(pageKey, groupId);
      totalPages = Provider.of<AdminProfileModel>(context, listen: false).totalPages;
      if(mounted) {
        final isLastPage = (totalPages-1) == pageKey;

        if (isLastPage) {
          _pagingControllerRequests.appendLastPage(Provider.of<AdminProfileModel>(context, listen: false).requestsInGroupList);
        } else {
          final int? nextPageKey = pageKey + 1;
          _pagingControllerRequests.appendPage(Provider.of<AdminProfileModel>(context, listen: false).requestsInGroupList, nextPageKey);
        }
      }
    } catch (error) {
      _pagingControllerMembers.error = error;
    }
  }

  Future<void> _fetchPageAdmins(int pageKey, int groupId) async {
    try {
      await Provider.of<AdminProfileModel>(context, listen: false).getAdminsInGroup(pageKey, groupId);
      totalPages = Provider.of<AdminProfileModel>(context, listen: false).totalPages;
      if(mounted) {
        final isLastPage = (totalPages-1) == pageKey;

        if (isLastPage) {
          _pagingControllerAdmins.appendLastPage(Provider.of<AdminProfileModel>(context, listen: false).adminInGroupList);
        } else {
          final int? nextPageKey = pageKey + 1;
          _pagingControllerAdmins.appendPage(Provider.of<AdminProfileModel>(context, listen: false).adminInGroupList, nextPageKey);
        }
      }
    } catch (error) {
      _pagingControllerAdmins.error = error;
    }
  }

  @override
  void dispose(){
    super.dispose();
    if(!mounted) _pagingControllerMembers.dispose();
    if(!mounted) _pagingControllerAdmins.dispose();
  }

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      leading: InkWell(
        onTap: (){
          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
      ),
      elevation: .1,
      title:
      Text(
        "My Groups",
        style: TextStyle(color: Colors.white),
      ),
      actions: [
      ],
    );
  }

  _adminSpecificGroupViewState() {
    searchBar = new SearchBar(
        inBar: false,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onCleared: () {
          print("Search bar has been cleared");
        },
        onClosed: () {
          print("Search bar has been closed");
        });
  }
  @override
  Widget build(BuildContext context) {
    final upperTab = new TabBar(labelColor: Colors.white, tabs: <Tab>[
      new Tab(text: "Members"),
      new Tab(text: "Requests"),
      new Tab(text: "Admins")
    ]);
    return Container(
      child: WillPopScope(
          onWillPop: () async {
            return true;
          },
          child: new DefaultTabController(
            length: 3,
            child: Scaffold(
              backgroundColor: Color(0xFF333333),
              appBar: AppBar(
                title: Text("Admin"),
                bottom: upperTab,
              ),
              body: TabBarView(
                children: [
                  //MEMBERS
                  RefreshIndicator(
                    onRefresh: () {
                      Provider.of<GroupRequestModel>(context, listen: false).getGroupRequestsPrfId();
                      return Future.sync(() => _pagingControllerMembers.refresh());
                    },

                    child: Column(
                      children: [
                        Flexible(
                          child: PagedListView(
                            pagingController: _pagingControllerMembers,
                            shrinkWrap: true,
                            builderDelegate:
                            PagedChildBuilderDelegate<AdminProfile>(
                              firstPageProgressIndicatorBuilder: (_) =>
                                  Center(child: spinkit),
                              newPageProgressIndicatorBuilder: (_) =>
                                  Center(child: spinkit),
                              noItemsFoundIndicatorBuilder: (_) => Padding(
                                padding: EdgeInsets.fromLTRB(0,30.h,0,0),
                                child: Center(
                                  child: Text(
                                    "No Members Found.",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              itemBuilder:
                                  (BuildContext context, profile, int index) {
                                return MembersRowAdminView(
                                  profile: profile,
                                  group: widget.group,
                                  uniqueIdentifier: "uniqueIdentifier",
                                  onUserRemoved: () {
                                    widget.onUserRemoved();
                                    // Refresh all your lists here
                                    // For example:
                                    Provider.of<AdminProfileModel>(context, listen: false).getNextPageMembersInGroup(0, widget.group.id!)
                                        .then((value) => Future.sync(() => _pagingControllerMembers.refresh()))
                                        .then((value) => Provider.of<AdminProfileModel>(context, listen: false).getNextPageAdminsInGroup(0, widget.group.id!))
                                        .then((value) => Future.sync(() => _pagingControllerAdmins.refresh()));
                                    // etc.
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //REQUESTS
                  RefreshIndicator(
                    onRefresh: () {
                      Provider.of<GroupRequestModel>(context, listen: false).getGroupRequestsPrfId();
                      return Future.sync(() => _pagingControllerRequests.refresh());
                    },

                    child: Column(
                      children: [
                          Flexible(
                            child: PagedListView(
                              pagingController: _pagingControllerRequests,
                              shrinkWrap: true,
                              builderDelegate:
                              PagedChildBuilderDelegate<AdminProfile>(
                                firstPageProgressIndicatorBuilder: (_) =>
                                    Center(child: spinkit),
                                newPageProgressIndicatorBuilder: (_) =>
                                    Center(child: spinkit),
                                noItemsFoundIndicatorBuilder: (_) => Padding(
                                  padding: EdgeInsets.fromLTRB(0,30.h,0,0),
                                  child: Center(
                                    child: Text(
                                      "No Requests Found.",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                itemBuilder:
                                    (BuildContext context, profile, int index) {
                                  return RequestsRowAdminView(
                                    profile: profile,
                                    group: widget.group,
                                    uniqueIdentifier: "uniqueIdentifier",
                                    onUserRemoved: () {
                                      widget.onUserRemoved();
                                      // Refresh all your lists here
                                      // For example:
                                      Provider.of<AdminProfileModel>(context, listen: false).getNextPageRequestsInGroup(0, widget.group.id!)
                                          .then((value) => Future.sync(() => _pagingControllerRequests.refresh()))
                                          .then((value) => Provider.of<AdminProfileModel>(context, listen: false).getNextPageMembersInGroup(0, widget.group.id!))
                                          .then((value) => Future.sync(() => _pagingControllerMembers.refresh()));
                                    },
                                  );
                                },
                              ),
                            ),
                          ),

                      ],
                    ),
                  ),
                  //ADMINS
                  RefreshIndicator(
                    onRefresh: () {
                      Provider.of<GroupRequestModel>(context, listen: false).getGroupRequestsPrfId();
                      return Future.sync(() => _pagingControllerAdmins.refresh());
                    },

                    child: Column(
                      children: [
                        Flexible(
                          child: PagedListView(
                            pagingController: _pagingControllerAdmins,
                            shrinkWrap: true,
                            builderDelegate:
                            PagedChildBuilderDelegate<AdminProfile>(
                              firstPageProgressIndicatorBuilder: (_) =>
                                  Center(child: spinkit),
                              newPageProgressIndicatorBuilder: (_) =>
                                  Center(child: spinkit),
                              noItemsFoundIndicatorBuilder: (_) => Padding(
                                padding: EdgeInsets.fromLTRB(0,30.h,0,0),
                                child: Center(
                                  child: Text(
                                    "No Admins Found.",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              itemBuilder:
                                  (BuildContext context, profile, int index) {
                                return AdminRowView(
                                  profile: profile,
                                  group: widget.group,
                                  uniqueIdentifier: "uniqueIdentifier",
                                  onUserRemoved: () {
                                    widget.onUserRemoved();
                                    // Refresh all your lists here
                                    // For example:
                                    Provider.of<AdminProfileModel>(context, listen: false).getNextPageAdminsInGroup(0, widget.group.id!)
                                        .then((value) => Future.sync(() => _pagingControllerAdmins.refresh()));
                                    // etc.
                                  },
                                );
                              },
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}