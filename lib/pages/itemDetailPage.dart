import 'dart:convert';
import 'dart:core';

import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_shopping_v1/Authentication/authentication.dart';
import 'package:student_shopping_v1/Widgets/FavoriteWidget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:student_shopping_v1/messaging/Screens/ChatDetail.dart';
import 'package:student_shopping_v1/messaging/Screens/IndividualPage.dart';
import 'package:student_shopping_v1/messaging/Screens/LoginScreen.dart';
import 'package:student_shopping_v1/models/chatMessageModel.dart';
import '../models/itemModel.dart';
import 'package:http/http.dart' as http;

import 'messagePage.dart';

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
  ItemDetails(
      item
  ) : this.item = item{
  }
  @override
  _ItemDetailsState createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {

  User? currentUser = FirebaseAuth.instance.currentUser;
  // String recipientProfileName = "";
  int currentUserId = -1;
  String sellerUserName = "";

  @override
  void initState() {
    // TODO: implement initState
    getProfileFromDb(currentUser?.uid.toString());
    getProfileFromDbWithSellerId(widget.item.seller_id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var numberOfImagesInItem = widget.item.itemPictureIds.length;
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
          if(snapshot.data == null){
            return Container(
              child: Center(
                child: spinkit
              ),
            );
          } else {
            // final List<Object> imgList = [
            //   numberOfImagesInItem > 0 ? MemoryImage(snapshot.data[0]) : AssetImage(
            //       "assets/images/no-picture-available-icon.png"),
            //   numberOfImagesInItem > 1 ? MemoryImage(snapshot.data[1]) : AssetImage(
            //       "assets/images/no-picture-available-icon.png"),
            //   numberOfImagesInItem > 2 ? MemoryImage(snapshot.data[2]) : AssetImage(
            //       "assets/images/no-picture-available-icon.png"),
            // ];
            // final List<Widget> imageSliders = imgList
            //     .map((item) => Container(
            //   child: Container(
            //     margin: EdgeInsets.all(5.0),
            //     child: ClipRRect(
            //         borderRadius: BorderRadius.all(Radius.circular(5.0)),
            //         child: Stack(
            //           children: <Widget>[
            //             MemoryImage(item),
            //             Positioned(
            //               bottom: 0.0,
            //               left: 0.0,
            //               right: 0.0,
            //               child: Container(
            //                 decoration: BoxDecoration(
            //                   gradient: LinearGradient(
            //                     colors: [
            //                       Color.fromARGB(200, 0, 0, 0),
            //                       Color.fromARGB(0, 0, 0, 0)
            //                     ],
            //                     begin: Alignment.bottomCenter,
            //                     end: Alignment.topCenter,
            //                   ),
            //                 ),
            //                 padding: EdgeInsets.symmetric(
            //                     vertical: 10.0, horizontal: 20.0),
            //                 child: Text(
            //                   'No. ${imgList.indexOf(item)} image',
            //                   style: TextStyle(
            //                     color: Colors.white,
            //                     fontSize: 20.0,
            //                     fontWeight: FontWeight.bold,
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ],
            //         )),
            //   ),
            // ))
            //     .toList();

          return Container(
            child: SingleChildScrollView(
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
              //     child: CarouselSlider(
              //     options: CarouselOptions(
              //     aspectRatio: 2.0,
              //     enlargeCenterPage: true,
              //     enableInfiniteScroll: false,
              //     initialPage: 2,
              //       autoPlay: true
              //
              // ),
              //       items: [
              //         imageSliders,
              //       ],
              // )
              //       // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
                    //   boxShadow: [BoxShadow(spreadRadius: 0, blurRadius: 19, offset: Offset(0, 4), color: Colors.grey)],
                    child: Carousel(
                      boxFit: BoxFit.contain,
                      images: [
                        numberOfImagesInItem > 0 ? MemoryImage(snapshot.data[0]) : AssetImage(
                            "assets/images/no-picture-available-icon.png"),
                        numberOfImagesInItem > 1 ? MemoryImage(snapshot.data[1]) : AssetImage(
                            "assets/images/no-picture-available-icon.png"),
                        numberOfImagesInItem > 2 ? MemoryImage(snapshot.data[2]) : AssetImage(
                            "assets/images/no-picture-available-icon.png"),
                      ],
                      autoplay: false,


                      //   image: DecorationImage(
                      //image: MemoryImage(widget.itemPicture), fit: BoxFit.cover),
                    ),

                    //     image: NetworkImage(widget.item_detail_picture),fit: BoxFit.cover)
                  ),
                  Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      margin: EdgeInsets.only(left: 15, top: 15),
                      child: Text(widget.item.name,
                        style: TextStyle(fontSize: 19, color: Colors.grey[700]),
                        textAlign: TextAlign.left,)
                  ),
                  Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      margin: EdgeInsets.only(left: 15, top: 15),
                      child: Text((' \$${NumberFormat('#,##0.00', 'en_US').format(widget.item.price)}'),

                        style: TextStyle(fontSize: 19, color: Colors.grey[700]),
                        textAlign: TextAlign.left,)
                  ),
                  Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      margin: EdgeInsets.only(left: 15, top: 15),
                      child: Text('Description', style: TextStyle(fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[700]), textAlign: TextAlign.left,)
                  ),
                  Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      margin: EdgeInsets.only(left: 15, top: 15),
                      child: Text(widget.item.description,
                        style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                        textAlign: TextAlign.left,)
                  ),
                  Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      margin: EdgeInsets.only(left: 15, top: 15),
                      child: Text('Seller Name', style: TextStyle(fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[700]), textAlign: TextAlign.left,)
                  ),
                  Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      margin: EdgeInsets.only(left: 15, top: 15),
                      child: Text(sellerUserName,
                        style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                        textAlign: TextAlign.left,)
                  ),
                ],
              ),

            ),
          );}

        } ),
bottomNavigationBar: Container(
  width: MediaQuery.of(context).size.width,
  height: 100,
  child: Container(
    margin: EdgeInsets.only(left: 10, right:10, bottom: 10),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(50)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          child: InkWell(
            onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => new ChatDetailPage(chatProfile: new ChatMessageHome.NewChatMessage
                  ("", sellerUserName, currentUser?.displayName, currentUserId, widget.item.seller_id, "createdAt", currentUserId,widget.item.id, false, -1), currentUserDbId: currentUserId))),
            child: Text(
              "Click here to buy!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
        InkWell(
          //todo: update list
          child: Container(
            child: FavoriteWidget(
              item: widget.item
            ),
          ),
        ),
      ],
    ),
  ),
),
    );
  }

  Future<void> getProfileFromDb(String? firebaseid) async {
    Map<String, dynamic> data;
    var url = Uri.parse('http://studentshopspringbackend-env.eba-b2yvpimm.us-east-1.elasticbeanstalk.com/profiles/$firebaseid'); // TODO -  call the recentItem service when it is built
    http.Response response = await http.get(
        url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      // data.map<Item>((json) => Item.fromJson(json)).toList();
      data = jsonDecode(response.body);
      currentUserId = data['id'];
      // recipientProfileName = data['name'];
      print(response.statusCode);
    } else {
      print(response.statusCode);
    }
  }

  Future<void> getProfileFromDbWithSellerId(int? profileId) async {
    Map<String, dynamic> data;
    var url = Uri.parse('http://studentshopspringbackend-env.eba-b2yvpimm.us-east-1.elasticbeanstalk.com/profiles/id/$profileId'); // TODO -  call the recentItem service when it is built
    http.Response response = await http.get(
        url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      // data.map<Item>((json) => Item.fromJson(json)).toList();
      data = jsonDecode(response.body);
      sellerUserName = data['name'];
      // recipientProfileName = data['name'];
      print(response.statusCode);
    } else {
      print(response.statusCode);
    }
  }



}


