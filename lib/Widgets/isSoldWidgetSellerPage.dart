import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:student_shopping_v1/models/itemModel.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import '../api_utils.dart';
import '../models/recentItemModel.dart';
import '../models/sellerItemModel.dart';

class isSoldWidgetSellerPage extends StatefulWidget {
  var item;
  var isSold;
  final PagingController<int, ItemWithImages> pagingController;

  isSoldWidgetSellerPage(
      {this.isSold, this.item, required this.pagingController});

  @override
  _isSoldWidgetSellerPageState createState() =>
      _isSoldWidgetSellerPageState(item);
}

class _isSoldWidgetSellerPageState extends State<isSoldWidgetSellerPage> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  ItemWithImages item;

  _isSoldWidgetSellerPageState(this.item);

  // void _toggleIsSold(var isSold, ItemWithImages item) {
  //
  //   setState(() {
  //     isSold ? isSold = false : isSold = true;
  //     widget.isSold = isSold;
  //   });
  // }

  void _toggleIsSold(var isSold, ItemWithImages item) async {
    final newIsSoldStatus = !isSold; // Toggle the status

    // Update the item's status in the data model
    setState(() {
      widget.isSold = newIsSoldStatus;
      item.isSold = newIsSoldStatus; // Update the data model
    });

    try {
      // Send a request to update the isSold status on the server
      // await updateIsSoldStatus();
    } catch (error) {
      // Handle any errors that occur during the server request
      print("Error updating isSold status: $error");
      // You may want to handle errors differently based on your app's requirements.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
        child: ElevatedButton(
          onPressed: () {
            updateIsSoldStatus()
                .then((value) =>
                    Provider.of<RecentItemModel>(context, listen: false)
                        .getRecentItems())
                .then((value) => _toggleIsSold(widget.isSold, item))
                .then((value) => widget.pagingController.refresh());
          },
          child: widget.isSold == false ? Text(
              "Mark Item as Sold!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.white),
            ) : Text(
              "Mark Item as Available!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
          style: ButtonStyle(
            fixedSize: MaterialStateProperty.all(Size(50, 50)),
            backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
          ),
        )
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //   children: [
        //     Padding(
        //       padding: const EdgeInsets.fromLTRB(30.0,0,0,0),
        //       child: Container(
        //         child: widget.isSold == false ? Text(
        //           "Mark Item as Sold!",
        //           textAlign: TextAlign.center,
        //           style: TextStyle(fontSize: 15, color: Colors.white),
        //         ) : Text(
        //           "Mark Item as Available!",
        //           textAlign: TextAlign.center,
        //           style: TextStyle(fontSize: 15, color: Colors.white),
        //         ),
        //       ),
        //     ),
        //     Padding(
        //         padding: const EdgeInsets.fromLTRB(30.0, 0.0, 0.0, .0),
        //         child: Container(
        //           child: new IconButton(
        //               icon: Icon(widget.isSold ? Icons.check_box : Icons.check_box_outlined),
        //               color: Colors.white,
        //               onPressed: () {
        //                 updateIsSoldStatus()
        //                     .then((value) => Provider.of<RecentItemModel>(context, listen: false).getRecentItems())
        //                     .then((value) => _toggleIsSold(widget.isSold, item)).then((value) => widget.pagingController.refresh());
        //               }),
        //         )),
        //     // Padding(
        //     // padding: const EdgeInsets.fromLTRB(1.0, 2.0, 2.0, 4.0),
        //     Container(
        //       child: new IconButton(
        //           icon: Icon(Icons.delete),
        //           color: Colors.red,
        //           onPressed: () {
        //             _showConfirmDeleteButton(context, widget.item.id);
        //           }),
        //     )
        //     // ),
        //   ],
        // ),
        );
  }

  Future<void> updateIsSoldStatus() async {
    Map<String, dynamic> data;
    String itemId = widget.item.id.toString();
    String categoryId = widget.item.category_id.toString();
    var url = ApiUtils.buildApiUrl(
        '/categories/$categoryId/items/soldStatus/$itemId');
    // var tmpObj =  json.encode(itm.toJson());
    final http.Response response = await http.put(url, headers: {
      "Accept": "application/json",
      "Content-Type": "application/json"
    }
        // , body: tmpObj
        );

    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
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
}
