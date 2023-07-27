// import 'dart:convert';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import 'package:student_shopping_v1/new/components/product_card.dart';
// import 'package:student_shopping_v1/new/size_config.dart';
// import 'package:student_shopping_v1/pages/itemDetailPageSellerView.dart';
// import '../models/itemModel.dart';
// import '../models/sellerItemModel.dart';
// import 'package:http/http.dart' as http;
//
// import '../new/components/productCardSellerView.dart';
// final spinkit = SpinKitFadingCircle(
//   itemBuilder: (BuildContext context, int index) {
//     return DecoratedBox(
//       decoration: BoxDecoration(
//         color: index.isEven ? Colors.black : Colors.black,
//       ),
//     );
//   },
// );
//
// class SellerProfilePageBody extends StatefulWidget {
//   const SellerProfilePageBody({Key? key}) : super(key: key);
//
//   @override
//   State<SellerProfilePageBody> createState() => _SellerProfilePageBodyState();
// }
//
// class _SellerProfilePageBodyState extends State<SellerProfilePageBody> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//
//   XFile? _pickedImage;
//   Future<User?> isSignedIn() async {
//     await Future.delayed(Duration(seconds: 1));
//     User? currentUser = FirebaseAuth.instance.currentUser;
//     return currentUser;
//   }
//
//   ScrollController _controller = new ScrollController();
//   bool isBottom = false;
//   bool loading = false, allLoaded = false;
//
//   @override
//   void initState() {
//     _pagingController.addPageRequestListener((pageKey) {
//       _fetchPage(pageKey);
//     });
//     super.initState();
//   }
//   @override
//   void dispose(){
//     super.dispose();
//     if(!mounted) _pagingController.dispose();
//   }
//
//
//   final PagingController<int, ItemWithImages> _pagingController =
//   PagingController(firstPageKey: 0);
//   int totalPages = 0;
//
//   Future<void> _fetchPage(int pageKey) async {
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
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     // var userItemList = context.watch<SellerItemModel>();
//     // var totalPages = userItemList.totalPages;
//     return WillPopScope(
//       onWillPop: () async => false,
//       child: Container(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         child: Scaffold(
//           appBar: new AppBar(
//             title:Text("My Listings", style: TextStyle(color: Colors.black),),
//             automaticallyImplyLeading: false,
//         ),
//           key: _scaffoldKey,
//           body: RefreshIndicator(
//               onRefresh: () => Future.sync(() => _pagingController.refresh()),
//               child: Center(
//                 child: new
//                 PagedGridView(
//                   pagingController: _pagingController,
//                   builderDelegate: PagedChildBuilderDelegate<ItemWithImages>(
//                       firstPageProgressIndicatorBuilder: (_) => Center(child: spinkit),
//                       newPageProgressIndicatorBuilder: (_) => Center(child: spinkit),
//                       noItemsFoundIndicatorBuilder: (_) => Center(child: Text("No Listings Yet :)", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),)),
//                       itemBuilder: (BuildContext context, item, int index) {
//                         return ProductCardSeller(
//                           product: item,
//                           uniqueIdentifier: "sellerItem",
//                           pagingController: _pagingController
//                         );
//                       }
//                   ),
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     mainAxisSpacing: 0,),
//                 ),
//               )
//           ),
//         ),
//       ),
//     );
//       // return new FutureBuilder<User?>(
//       //   future: isSignedIn(),
//       //   builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
//       //     if (snapshot.hasData) {
//       //       String? dname = snapshot.data!.displayName;
//       //       String? email = snapshot.data!.email;
//       //       return Column(
//       //         children: [
//       //           AppBar(
//       //             elevation: .1,
//       //             actions: [
//       //               PopupMenuButton(
//       //                 // add icon, by default "3 dot" icon
//       //                 // icon: Icon(Icons.book)
//       //                   itemBuilder: (context){
//       //                     return [
//       //                       PopupMenuItem<int>(
//       //                         value: 0,
//       //                         child: Text("Sign Out"),
//       //                       ),
//       //
//       //                       PopupMenuItem<int>(
//       //                         value: 1,
//       //                         child: Text("Delete Account"),
//       //                       ),
//       //                     ];
//       //                   },
//       //                   onSelected:(value){
//       //                     if(value == 0){
//       //                       showAlertDialogSignOut(context);
//       //                     }else if(value == 1){
//       //                       showAlertDialogDeleteAccount(context);
//       //                     }
//       //                   }
//       //               ),
//       //               // IconButton(
//       //               //   icon: Icon(Icons.exit_to_app_outlined),
//       //               //   color: Colors.black,
//       //               //   onPressed: () {
//       //               //     showAlertDialog(context);
//       //               //   },
//       //               // )
//       //             ],
//       //           ),
//       //           Container(
//       //               height: getProportionateScreenHeight(67),
//       //               // width: MediaQuery.of(context).size.width,
//       //               child: Hero(
//       //                 tag:
//       //                     'https://images.unsplash.com/photo-1598369685311-a22ca3406009?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1234&q=80',
//       //                 // child: InkWell(
//       //                 // onTap: (){
//       //                 //   // _showPickOptionsDialog(context);
//       //                 //   print("HIT ME");
//       //                 // },
//       //                 child: CircleAvatar(
//       //                   radius: 40,
//       //                   // child: _pickedImage == null ? Text("Picture") : null,
//       //                   backgroundImage: _pickedImage != null
//       //                       ? FileImage(File(_pickedImage!.path))
//       //                       : AssetImage('assets/images/defaultPic.png')
//       //                           as ImageProvider,
//       //                 )
//       //                 // )
//       //                 ,
//       //               )),
//       //           SizedBox(height: getProportionateScreenHeight(20)),
//       //           Text(
//       //             dname.toString(),
//       //             style: TextStyle(
//       //                 fontFamily: 'Montserrat',
//       //                 fontSize: 20.0,
//       //                 fontWeight: FontWeight.bold, color: Colors.black),
//       //           ),
//       //           SizedBox(height: getProportionateScreenHeight(8)),
//       //           Text(
//       //             email.toString(),
//       //             style: TextStyle(fontFamily: 'Montserrat', color: Colors.black),
//       //           ),
//       //           SizedBox(height: getProportionateScreenHeight(19)),
//       //           Text(
//       //             'My Listings',
//       //             style: TextStyle(
//       //                 fontFamily: 'Montserrat',
//       //                 color: Colors.black),
//       //           ),
//       //           RefreshIndicator(
//       //               onRefresh: () => Future.sync(() => _pagingController.refresh()),
//       //               child: Center(
//       //                 child: new
//       //                 PagedGridView(
//       //                   pagingController: _pagingController,
//       //                   builderDelegate: PagedChildBuilderDelegate<ItemWithImages>(
//       //                       firstPageProgressIndicatorBuilder: (_) => Center(child: spinkit),
//       //                       newPageProgressIndicatorBuilder: (_) => Center(child: spinkit),
//       //                       noItemsFoundIndicatorBuilder: (_) => Center(child: Text("No Listings Yet :)", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),)),
//       //                       itemBuilder: (BuildContext context, item, int index) {
//       //                         return ProductCardSeller(
//       //                           product: item,
//       //                           uniqueIdentifier: "sellerItem",
//       //                         );
//       //                       }
//       //                   ),
//       //                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//       //                     crossAxisCount: 2,
//       //                     mainAxisSpacing: 0,),
//       //                 ),
//       //               )
//       //           ),
//       //           //TODO:HERE
//       //           // userItemList.items.length != 0 ? SingleChildScrollView(
//       //           //   child: Container(
//       //           //       height: getProportionateScreenHeight(450),
//       //           //       width: getProportionateScreenWidth(450),
//       //           //       child: GridView.builder(
//       //           //         controller: _controller,
//       //           //         itemCount: userItemList.items.length == null
//       //           //             ? 0
//       //           //             : userItemList.items.length,
//       //           //         itemBuilder: (BuildContext context, int index) {
//       //           //           return ProductCardSeller(
//       //           //               product: userItemList.items[index],
//       //           //             uniqueIdentifier: "sellerItem",
//       //           //           );
//       //           //           // padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
//       //           //         },
//       //           //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//       //           //           crossAxisCount: 2,
//       //           //           mainAxisSpacing: 0,
//       //           //         ),
//       //           //       )
//       //           //       ),
//       //           // ) :
//       //           // SingleChildScrollView(
//       //           //   child:Container(
//       //           //       height: MediaQuery.of(context).size.height - 442,
//       //           //       width: MediaQuery.of(context).size.width,
//       //           //       child: Center(child: Text("No Listings!",style: TextStyle(fontWeight: FontWeight.bold),))
//       //           //   ),
//       //           // ),
//       //           //TODO: HERE
//       //           // if(loading)(spinkit),
//       //           // (isBottom && !allLoaded && !loading) ? ElevatedButton(
//       //           //   style: ElevatedButton.styleFrom(
//       //           //       primary: Colors.black
//       //           //   ),
//       //           //   child: Center(
//       //           //     // child: Expanded(
//       //           //       child: Text("Show More")
//       //           //     //),
//       //           //   ),
//       //           //   onPressed: (){
//       //           //     setState(() {
//       //           //       if(userItemList.currentPage <= totalPages-1 && !loading){
//       //           //         mockFetch(userItemList);
//       //           //       }
//       //           //       //recentList.getNextPage(1);
//       //           //     });
//       //           //   },
//       //           // ) : Container(),
//       //         ],
//       //       );
//       //     } else {
//       //       return Container(
//       //         height: 350,
//       //         width: MediaQuery.of(context).size.width,
//       //         // height: MediaQuery.of(context).size.height,
//       //         child: spinkit,
//       //       );
//       //     }
//       //   },
//       // );
//   }
//   Future<void> _signOut() async {
//     await FirebaseAuth.instance.signOut();
//   }
//
//   showAlertDialogSignOut(BuildContext context) {
//
//     // set up the buttons
//     Widget cancelButton = TextButton(
//       child: Text("No"),
//       onPressed:  () {
//         Navigator.of(context).pop();
//       },
//     );
//     Widget continueButton = TextButton(
//       child: Text("Yes"),
//       onPressed:  () {
//         Navigator.of(context).pop();
//         FirebaseAuth.instance.signOut();
//         FirebaseAuth.instance.authStateChanges();
//       },
//     );
//
//     // set up the AlertDialog
//     AlertDialog alert = AlertDialog(
//       title: Text("Sign out?"),
//       content: Text("Are you sure you want to SIGN OUT?"),
//       actions: [
//         cancelButton,
//         continueButton,
//       ],
//     );
//
//     // show the dialog
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }
//
//   showAlertDialogDeleteAccount(BuildContext context) async {
//
//     // set up the buttons
//     Widget cancelButton = TextButton(
//       child: Text("No"),
//       onPressed:  () {
//         Navigator.of(context).pop();
//       },
//     );
//     Widget continueButton = TextButton(
//       child: Text("Yes"),
//       onPressed:  () {
//         Navigator.of(context).pop();
//         FirebaseAuth.instance.signOut();
//         FirebaseAuth.instance.currentUser?.delete();
//         FirebaseAuth.instance.authStateChanges();
//         deleteUserFromDB(Provider.of<SellerItemModel>(context, listen: false).userIdFromDB);
//       },
//     );
//
//     // set up the AlertDialog
//     AlertDialog alert = AlertDialog(
//       title: Text("Delete Account?"),
//       content: Text("Are you sure you want to DELETE ACCOUNT?"),
//       actions: [
//         cancelButton,
//         continueButton,
//       ],
//     );
//
//     // show the dialog
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }
//   Future<void> deleteUserFromDB(int? id) async {
//     // String firebaseId = currentUser!.uid;
//     Map<String, dynamic> data;
//     var url = Uri.parse('http://Gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/profiles/$id');
//     http.Response response = await http.delete(url, headers: {"Accept": "application/json"});
//     if (response.statusCode == 200) {
//       // data.map<Item>((json) => Item.fromJson(json)).toList();
//       print(response.body);
//     } else {
//       print (response.statusCode);
//     }
//   }
//
// }
//
// class SingleItem extends StatelessWidget {
//   ItemWithImages item;
//
//   SingleItem({required this.item});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         InkWell(
//           onTap: () => Navigator.of(context).push(new MaterialPageRoute(
//               builder: (context) => new ItemDetailPageSellerView(context.watch<SellerItemModel>().userIdFromDB,item))),
//           child: Container(
//             margin: EdgeInsets.only(left: 15),
//             width: 130,
//             height: 130,
//             alignment: Alignment.topRight,
//             decoration: BoxDecoration(
//                 image: DecorationImage(
//                     image: item.imageDataList.length > 0 ?
//     MemoryImage(item.imageDataList[0]) : AssetImage('assets/images/GatorBazaar.jpg') as ImageProvider, fit: BoxFit.contain),
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(18)),
//             child: Container(
//               margin: EdgeInsets.only(right: 10, top: 5),
//             ),
//           ),
//         ),
//         Row(
//           children: [
//             Container(
//               alignment: Alignment.centerLeft,
//               width: MediaQuery.of(context).size.width * .19999,
//               margin: EdgeInsets.only(top: 0, left: MediaQuery.of(context).size.width * .12),
//               height: MediaQuery.of(context).size.height * .035,
//               child: Text((' \$${NumberFormat('#,##0.00', 'en_US').format(item.price)}'),
//                   style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
//             ),
//             item.isSold
//                 ? ClipRRect(
//                     borderRadius: BorderRadius.circular(10),
//                     child: Container(
//                       width: MediaQuery.of(context).size.width * .10,
//                       height: MediaQuery.of(context).size.height * .02,
//                       margin: EdgeInsets.only(top: 0, left: MediaQuery.of(context).size.width * .0001),
//                       child: Center(
//                         child: Text("SOLD!",
//                           style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
//
//                           // margin: EdgeInsets.all(8),
//                             // color: Colors.blue,
//                             ),
//                       ),
//                       color: Colors.green,
//                     ),
//                   )
//                 : Expanded(child: Container()),
//           ],
//         ),
//         Container(
//           alignment: Alignment.topLeft,
//           width: MediaQuery.of(context).size.width * .59,
//           margin: EdgeInsets.only(top: 0, left: MediaQuery.of(context).size.width * .13),
//           height: MediaQuery.of(context).size.height * .035,
//           child: Text("${item.name}",
//               style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
//         ),
//       ],
//     );
//   }
// }
