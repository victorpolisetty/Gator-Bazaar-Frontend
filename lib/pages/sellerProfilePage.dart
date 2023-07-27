// import 'package:flutter/material.dart';
// import 'package:flutter_search_bar/flutter_search_bar.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:student_shopping_v1/models/sellerItemModel.dart';
// import 'package:student_shopping_v1/new/components/productCardSellerView.dart';
// import 'package:student_shopping_v1/pages/sellerProfilePageBody.dart';
// import 'package:provider/provider.dart';
// import '../models/itemModel.dart';
//
// class sellerProfilePage extends StatefulWidget {
//   @override
//   State<sellerProfilePage> createState() => _sellerProfilePageState();
// }
//
// class _sellerProfilePageState extends State<sellerProfilePage> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//   late SearchBar searchBar;
//   final PagingController<int, ItemWithImages> _pagingController =
//   PagingController(firstPageKey: 0);
//   int totalPages = 0;
//   @override
//   void initState() {
//     _pagingController.addPageRequestListener((pageKey) {
//       _fetchPage(pageKey, 1);
//     });
//     super.initState();
//   }
//
//   @override
//   void dispose(){
//     super.dispose();
//     if(!mounted) _pagingController.dispose();
//   }
//
//   Future<void> _fetchPage(int pageKey, int categoryId) async {
//     try {
//       await Provider.of<SellerItemModel>(context, listen: false).initNextCatPage(pageKey);
//       totalPages = Provider.of<SellerItemModel>(context, listen: false).totalPages;
//       if(mounted) {
//         final isLastPage = (totalPages-1) == pageKey;
//
//         if (isLastPage) {
//           _pagingController.appendLastPage(Provider.of<SellerItemModel>(context, listen: false).items);
//         } else {
//           final int? nextPageKey = pageKey + 1;
//           _pagingController.appendPage(Provider.of<SellerItemModel>(context, listen: false).items, nextPageKey);
//         }
//       }
//     } catch (error) {
//       _pagingController.error = error;
//     }
//   }
//   AppBar buildAppBar(BuildContext context) {
//     return new AppBar(
//       leading: InkWell(
//         onTap: (){
//           Navigator.pop(context);
//         },
//         child: Icon(
//           Icons.arrow_back_ios,
//           color: Colors.black54,
//         ),
//         // child: Container(
//         //   // margin: EdgeInsets.only(right: 10),
//         //   // child: Icon(
//         //   //   Icons.search,
//         //   //   color: Colors.grey[800],
//         //   //   size: 27,
//         //   // ),
//         // ),
//       ),
//       // iconTheme: new IconThemeData(color: Colors.grey[800], size: 27),
//       // backgroundColor: Colors.grey[200],
//       elevation: .1,
//       title:
//       Text(
//         "My Listings",
//         style: TextStyle(color: Colors.black),
//       ),
//
//
//       actions: [
//         // searchBar.getSearchAction(context),
//         // Container(
//         //   margin: EdgeInsets.only(right: 10),
//         //   child: Icon(
//         //     Icons.notifications,
//         //     color: Colors.grey[800],
//         //     size: 27,
//         //   ),
//         // ),
//       ],
//     );
//     return new AppBar(
//         title: new Text('Student Shop'),
//         actions: [searchBar.getSearchAction(context)]);
//   }
//
//   _sellerProfilePageState() {
//     searchBar = new SearchBar(
//         inBar: false,
//         buildDefaultAppBar: buildAppBar,
//         setState: setState,
//         // onSubmitted: onSubmitted,
//         onCleared: () {
//           print("Search bar has been cleared");
//         },
//         onClosed: () {
//           print("Search bar has been closed");
//         });
//   }
//   // void onSubmitted(String value) {
//   //   setState(() {
//   //     var context = _scaffoldKey.currentContext;
//   //     isSearching = true;
//   //     Provider.of<CategoryItemModel>(context!, listen: false).getSearchedCategoryItems(widget.categoryId, value);
//   //     keyword = value;
//   //     if (context == null) {
//   //       return;
//   //     }
//   //
//   //     ScaffoldMessenger.maybeOf(context);
//   //   });
//   // }
//   @override
//   Widget build(BuildContext context) {
//     // return new Column(
//     //   children: [
//     //     SellerProfilePageBody(),
//     //   ],
//     // );
//     return WillPopScope(
//         onWillPop: () async {
//           return true;
//         },
//         child: new Scaffold(
//             appBar: searchBar.build(context),
//             key: _scaffoldKey,
//             body:
//             // RefreshIndicator(
//             //           onRefresh: () => Future.sync(() => _pagingController.refresh()),
//             Center(
//               child: new
//               PagedGridView(
//                 pagingController: _pagingController,
//                 builderDelegate: PagedChildBuilderDelegate<ItemWithImages>(
//                     firstPageProgressIndicatorBuilder: (_) => Center(child: spinkit),
//                     newPageProgressIndicatorBuilder: (_) => Center(child: spinkit),
//                     noItemsFoundIndicatorBuilder: (_) => Center(child: Text("No Items Yet :)", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),)),
//                     itemBuilder: (BuildContext context, item, int index) {
//                       return ProductCardSeller(
//                         product: item,
//                         uniqueIdentifier: "sellerItem",
//                       );
//                     }
//                 ),
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   mainAxisSpacing: 0,),
//               ),
//             )
//           // ),
//         ));
//   }
// }