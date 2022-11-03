import 'dart:core';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_shopping_v1/Widgets/FavoriteWidget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:student_shopping_v1/messaging/Screens/ChatDetail.dart';
import 'package:student_shopping_v1/models/chatMessageModel.dart';
import '../models/itemModel.dart';

final spinkit = SpinKitFadingCircle(
  itemBuilder: (BuildContext context, int index) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: index.isEven ? Colors.black : Colors.black,
      ),
    );
  },
);

class ItemDetails extends StatefulWidget {
  ItemWithImages item;
  int currentUserId = -1;
  ItemDetails(currentUserId, item)
      : this.item = item,
        this.currentUserId = currentUserId;
  @override
  _ItemDetailsState createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  // String recipientProfileName = "";
  // int currentUserId = -1;
  // String sellerUserName = "";

  @override
  void initState() {
    // TODO: implement initState
    // getProfileFromDb(currentUser?.uid.toString());
    // getProfileFromDbWithSellerId(widget.item.seller_id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var numberOfImagesInItem = widget.item.itemPictureIds.length;
    List<dynamic> imgList = [];
    List<dynamic> emptyList = [];
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.grey[800], size: 27),
        backgroundColor: Colors.grey[300],
        elevation: 0,
      ),
      body: FutureBuilder(
          future: widget.item.getAllImagesForItem(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(child: spinkit),
              );
            } else {
              for (int i = 0; i < numberOfImagesInItem; i++) {
                imgList.add(snapshot.data[i]);
              }
              if (imgList.length == 0) {
                emptyList.add(1);
              }

              return Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                          height: MediaQuery.of(context).size.height * .5,
                          width: MediaQuery.of(context).size.width,
                          child: CarouselSlider(
                            options: CarouselOptions(
                                aspectRatio: 1.0,
                                enlargeCenterPage: true,
                                enableInfiniteScroll: false,
                                initialPage: 0,
                                autoPlay: false),
                            items: imgList.length != 0
                                ? imgList
                                    .map((item) => Container(
                                          child:
                                              Center(child: Image.memory(item)
                                                  // MemoryImage(item)
                                                  ),
                                        ))
                                    .toList()
                                : emptyList
                                    .map((item) => Container(
                                          child: Center(
                                              child: Image.asset(
                                                  "assets/images/GatorBazaar.jpg")
                                              // MemoryImage(item)
                                              ),
                                        ))
                                    .toList(),

                            // items: [
                            //   imageSliders,
                            // ],
                          )
                          //       // decoration: BoxDecoration(
                          //   borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
                          //   boxShadow: [BoxShadow(spreadRadius: 0, blurRadius: 19, offset: Offset(0, 4), color: Colors.grey)],
                          // child: Carousel(
                          //   boxFit: BoxFit.contain,
                          //   images: [
                          //     numberOfImagesInItem > 0 ? MemoryImage(snapshot.data[0]) : AssetImage(
                          //         "assets/images/no-picture-available-icon.png"),
                          //     numberOfImagesInItem > 1 ? MemoryImage(snapshot.data[1]) : AssetImage(
                          //         "assets/images/no-picture-available-icon.png"),
                          //     numberOfImagesInItem > 2 ? MemoryImage(snapshot.data[2]) : AssetImage(
                          //         "assets/images/no-picture-available-icon.png"),
                          //   ],
                          //   autoplay: false,
                          //
                          //
                          //   //   image: DecorationImage(
                          //   //image: MemoryImage(widget.itemPicture), fit: BoxFit.cover),
                          // ),

                          //     image: NetworkImage(widget.item_detail_picture),fit: BoxFit.cover)
                          ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(left: 15, top: 15, right: 15),
                          child: Text(
                            widget.item.name,
                            style: TextStyle(
                                fontSize: 19, color: Colors.grey[700]),
                            textAlign: TextAlign.left,
                          )),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(left: 15, top: 15),
                          child: Text(
                            'Price',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey[700]),
                            textAlign: TextAlign.left,
                          )),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                          child: Text(
                            (' \$${NumberFormat('#,##0.00', 'en_US').format(widget.item.price)}'),
                            style: TextStyle(
                                fontSize: 15, color: Colors.grey[700]),
                            textAlign: TextAlign.left,
                          )),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(left: 15, top: 15),
                          child: Text(
                            'Description',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey[700]),
                            textAlign: TextAlign.left,
                          )),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(left: 15, top: 15, right: 15),
                          child: Text(
                            widget.item.description,
                            style: TextStyle(
                                fontSize: 15, color: Colors.grey[700]),
                            textAlign: TextAlign.left,
                          )),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(left: 15, top: 15),
                          child: Text(
                            'Seller Information',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey[700]),
                            textAlign: TextAlign.left,
                          )),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(left: 15, top: 15),
                          child: Text(
                            widget.item.seller_name!,
                            style: TextStyle(
                                fontSize: 15, color: Colors.grey[700]),
                            textAlign: TextAlign.left,
                          )),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(left: 15, top: 15),
                          child: Text(
                            widget.item.seller_email!,
                            style: TextStyle(
                                fontSize: 15, color: Colors.grey[700]),
                            textAlign: TextAlign.left,
                          )),
                    ],
                  ),
                ),
              );
            }
          }),
      bottomNavigationBar: widget.item.seller_id != widget.currentUserId
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: Container(
                margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                // decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(50)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (context) => new ChatDetailPage(chatProfile: new ChatMessageHome.NewChatMessage
                                    ("", widget.item.seller_name, currentUser?.displayName, widget.currentUserId, widget.item.seller_id, "createdAt", widget.currentUserId, widget.item.id, false, -1), currentUserDbId: widget.currentUserId)));
                      },
                      child: Text(
                        'Message',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: EdgeInsets.zero,
                            fixedSize: Size.fromWidth(250)
                          ),
                    )
                        // child: InkWell(
                        //   onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                        //       builder: (context) => new ChatDetailPage(chatProfile: new ChatMessageHome.NewChatMessage
                        //         ("", widget.item.seller_name, currentUser?.displayName, widget.currentUserId, widget.item.seller_id, "createdAt", widget.currentUserId, widget.item.id, false, -1), currentUserDbId: widget.currentUserId))),
                        //   child: Text(
                        //     "Click here to buy!",
                        //     textAlign: TextAlign.center,
                        //     style: TextStyle(fontSize: 20),
                        //   ),
                        // ),
                        ),
                    InkWell(
                      //todo: update list
                      child: Container(
                        child: FavoriteWidget(item: widget.item),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  // Future<void> getProfileFromDb(String? firebaseid) async {
  //   Map<String, dynamic> data;
  //   var url = Uri.parse('http://studentshopspringbackend-env.eba-b2yvpimm.us-east-1.elasticbeanstalk.com/profiles/$firebaseid'); // TODO -  call the recentItem service when it is built
  //   http.Response response = await http.get(
  //       url, headers: {"Accept": "application/json"});
  //   if (response.statusCode == 200) {
  //     // data.map<Item>((json) => Item.fromJson(json)).toList();
  //     data = jsonDecode(response.body);
  //     currentUserId = data['id'];
  //     // recipientProfileName = data['name'];
  //     print(response.statusCode);
  //   } else {
  //     print(response.statusCode);
  //   }
  // }

  // Future<void> getProfileFromDbWithSellerId(int? profileId) async {
  //   Map<String, dynamic> data;
  //   var url = Uri.parse('http://studentshopspringbackend-env.eba-b2yvpimm.us-east-1.elasticbeanstalk.com/profiles/id/$profileId'); // TODO -  call the recentItem service when it is built
  //   http.Response response = await http.get(
  //       url, headers: {"Accept": "application/json"});
  //   if (response.statusCode == 200) {
  //     // data.map<Item>((json) => Item.fromJson(json)).toList();
  //     data = jsonDecode(response.body);
  //     sellerUserName = data['name'];
  //     // recipientProfileName = data['name'];
  //     print(response.statusCode);
  //   } else {
  //     print(response.statusCode);
  //   }
  // }

}
