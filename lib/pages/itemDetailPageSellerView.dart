import 'dart:convert';
import 'dart:core';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sizer/sizer.dart';
import 'package:student_shopping_v1/Widgets/isSoldWidgetSellerPage.dart';
import '../Widgets/isSoldWidget.dart';
import '../api_utils.dart';
import '../models/itemModel.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../models/recentItemModel.dart';

final spinkit = SpinKitFadingCircle(
  itemBuilder: (BuildContext context, int index) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: index.isEven ? Colors.black : Colors.black,
      ),
    );
  },
);

class ItemDetailPageSellerView extends StatefulWidget {
  ItemWithImages item;
  int currentUserId = -1;
  PagingController<int, ItemWithImages> pagingController;
  ItemDetailPageSellerView(currentUserId, item, pagingController)
      : this.item = item,
        this.currentUserId = currentUserId,
        this.pagingController = pagingController;
  @override
  _ItemDetailPageSellerViewState createState() => _ItemDetailPageSellerViewState();
}

class _ItemDetailPageSellerViewState extends State<ItemDetailPageSellerView> {

  User? currentUser = FirebaseAuth.instance.currentUser;
  // String recipientProfileName = "";
  int currentUserId = -1;
  // String sellerUserName = "";

  @override
  void initState() {
    getProfileFromDb(currentUser?.uid.toString());
    // getProfileFromDbWithSellerId(widget.item.seller_id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var numberOfImagesInItem = widget.item.itemPictureIds!.length;
    List <dynamic> imgList = [];
    List <dynamic> emptyList = [];
    return Scaffold(
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.white, size: 27),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        height: 100.h,
        color: Color(0xFF333333),
        child: FutureBuilder(
            future: widget.item.getAllImagesForItem(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if(snapshot.data == null){
                return Container(
                  child: Center(
                      child: spinkit
                  ),
                );
              } else {
                for(int i = 0; i < numberOfImagesInItem; i++){
                  imgList.add(snapshot.data[i]);
                }
                if (imgList.length == 0) {
                  emptyList.add(1);
                }
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * .5,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          child: CarouselSlider(
                            options: CarouselOptions(
                                aspectRatio: 1.0,
                                enlargeCenterPage: true,
                                enableInfiniteScroll: false,
                                initialPage: 0,
                                autoPlay: false

                            ),
                            items: imgList.length != 0 ? imgList
                                .map((item) => Container(
                              child: Center(
                                  child:
                                  Image.memory(item)
                                // MemoryImage(item)
                              ),
                            ))
                                .toList() :
                            emptyList
                                .map((item) => Container(
                              child: Center(
                                  child:
                                  Image.asset("assets/gb_placeholder.jpg")
                                // MemoryImage(item)
                              ),
                            ))
                                .toList(),
                          )
                      ),
                      Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          margin: EdgeInsets.only(left: 15, top: 15),
                          child: Text(widget.item.name!,
                            style: TextStyle(fontSize: 19, color: Colors.white),
                            textAlign: TextAlign.left,)
                      ),
                      Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          margin: EdgeInsets.only(left: 15, top: 15),
                          child: Text('Price', style: TextStyle(fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white), textAlign: TextAlign.left,)
                      ),
                      Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            child: Text((' \$${NumberFormat('#,##0.00', 'en_US').format(widget.item.price)}'),
                              style: TextStyle(fontSize: 15, color: Colors.white),
                              )
                        ),
                      ),
                      Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          margin: EdgeInsets.only(left: 15, top: 15),
                          child: Text('Description', style: TextStyle(fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white), textAlign: TextAlign.left,)
                      ),
                      Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          margin: EdgeInsets.only(left: 15, top: 15, right: 15),
                          child: Text(widget.item.description!,
                            style: TextStyle(fontSize: 15, color: Colors.white),
                            textAlign: TextAlign.left,)
                      ),
                      SizedBox(height: 4.h,),
                      Row(
                        children: [
                          Container(
                            color: Color(0xFF333333),
                            width: 75.w,
                            height: 5.h,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10.w,0,0,0),
                              child: Container(
                                // margin: EdgeInsets.only(left: 20, right: 20, bottom: 30,),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                ),
                                child: Container(
                                  child: isSoldWidgetSellerPage(
                                    isSold: widget.item.isSold,
                                    item: widget.item,
                                    pagingController: widget.pagingController,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: new IconButton(
                                icon: Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () {
                                  _showConfirmDeleteButton(context, widget.item.id);
                                }),
                          )
                        ],
                      ),
                      SizedBox(height: 2.h),
                      // SizedBox(
                      //   height: 10,
                      //   width: 10,
                      // ),
                    ],
                  ),

                );
              }

            } ),
      ),
    );
  }

  void _showConfirmDeleteButton(BuildContext context, int? itemId) {
    BuildContext dialogContext;
    showDialog(
        context: context,
        builder: (context) => WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            // dialogContext = context;
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Are you sure?"),
                ListTile(
                  title: Text("Yes"),
                  onTap: () {
                    // _loadPicker(ImageSource.gallery, imageNumber);
                    // Provider.of<RecentItemModel>(context, listen: false).getRecentItems();
                    deleteListing(itemId)
                        .then((value) => Provider.of<RecentItemModel>(
                        context,
                        listen: false)
                        .getRecentItems())
                        .then((value) => Navigator.pop(context))
                        .then((value) => Navigator.pushReplacementNamed(
                        context, "/home"));
                  },
                ),
                ListTile(
                  title: Text("No"),
                  onTap: () {
                    // _loadPicker(ImageSource.gallery, imageNumber);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> getProfileFromDb(String? firebaseid) async {
    Map<String, dynamic> data;
    var url = ApiUtils.buildApiUrl('/profiles/$firebaseid'); // TODO -  call the recentItem service when it is built
    http.Response response = await http.get(
        url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      // data.map<Item>((json) => Item.fromJson(json)).toList();
      data = jsonDecode(response.body);
      currentUserId = data['id'];
    } else {
      print(response.statusCode);
    }
  }

  Future<void> deleteListing(int? itemId) async {
    var url = ApiUtils.buildApiUrl('/categories/items/$itemId');
    http.Response response =
    await http.delete(url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
    } else {
      print(response.statusCode);
    }
  }

  // Future<void> getProfileFromDbWithSellerId(int? profileId) async {
  //   Map<String, dynamic> data;
  //   var url = ApiUtils.buildApiUrl('/profiles/profileId/$profileId'); // TODO -  call the recentItem service when it is built
  //   http.Response response = await http.get(
  //       url, headers: {"Accept": "application/json"});
  //   if (response.statusCode == 200) {
  //     // data.map<Item>((json) => Item.fromJson(json)).toList();
  //     data = jsonDecode(response.body);
  //     sellerUserName = data['name'];
  //   } else {
  //     print(response.statusCode);
  //   }
  // }





}