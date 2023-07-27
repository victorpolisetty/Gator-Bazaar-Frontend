import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:student_shopping_v1/models/itemModel.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import '../buyerhome.dart';
import '../models/recentItemModel.dart';
import '../models/sellerItemModel.dart';

class isSoldWidgetSellerPage extends StatefulWidget {
  var item;
  var isSold;
  final PagingController<int, ItemWithImages> pagingController;

  isSoldWidgetSellerPage({
    this.isSold,
    this.item,
    required this.pagingController
  });

  @override
  _isSoldWidgetSellerPageState createState() =>
      _isSoldWidgetSellerPageState(item);
}

class _isSoldWidgetSellerPageState extends State<isSoldWidgetSellerPage> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  ItemWithImages item;

  _isSoldWidgetSellerPageState(this.item);

  void _toggleIsSold(var isSold, ItemWithImages item) {

    setState(() {

      // if(!isInFavoritesList){
      //   Future.wait([addUserFavoriteToDb()]).then((value) => favoriteList.add(item));
      // } else {
      //   Future.wait([deleteUserFavoriteFromDb()]).then((value) => favoriteList.remove(item));
      // }
      isSold ? isSold = false : isSold = true;
      widget.isSold = isSold;
    });
  }

  // bool inFavorites(var favorite, ItemWithImages item){
  //   bool isFavorite = favorite.items.contains(item);
  //   return isFavorite;
  // }

  @override
  Widget build(BuildContext context) {
    // var itm = new ItemWithImages.FavoriteItem(item.id!,item.name,item.price,item.description,item.imageDataList[0]);


    // var isInFavoritesList = context.select<FavoriteModel, bool>(
    //         (favorite) => inFavorites(favorite, item)
    // );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(30.0,0,0,0),
          child: Container(
            child: widget.isSold == false ? Text(
              "Mark Item as Sold!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.black),
            ) : Text(
              "Mark Item as Available!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0.0, 0.0, .0),
            child: Container(
              child: new IconButton(
                  icon: Icon(widget.isSold ? Icons.check_box : Icons.check_box_outlined),
                  color: Colors.black,
                  onPressed: () {
                    updateIsSoldStatus().then((value) => Provider.of<RecentItemModel>(context, listen: false).getRecentItems())
                        .then((value) => Provider.of<SellerItemModel>(context, listen: false).getProfileIdAndItems()).then((value) => widget.pagingController.refresh());
                    _toggleIsSold(widget.isSold, item);
                  }),
            )),
        // Padding(
        // padding: const EdgeInsets.fromLTRB(1.0, 2.0, 2.0, 4.0),
        Container(
          child: new IconButton(
              icon: Icon(Icons.delete),
              color: Colors.red,
              onPressed: () {
                _showConfirmDeleteButton(context, widget.item.id);
              }),
        )
        // ),
      ],
    );
  }
  Future<void> updateIsSoldStatus()  async {
    Map<String, dynamic> data;
    String itemId = widget.item.id.toString();
    String categoryId = widget.item.category_id.toString();
    var url = Uri.parse('http://Gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/categories/$categoryId/items/soldStatus/$itemId');
    // var tmpObj =  json.encode(itm.toJson());
    final http.Response response =  await http.put(url
        , headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        }
      // , body: tmpObj
    );

    //  .then((response) {
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      print("STATUS OF ITEM SELLING: " + data['isSold'].toString());
      print(response.statusCode);
    } else {
      print(response.statusCode);
    }
    //  });
  }

  void _showConfirmDeleteButton(BuildContext context, int? itemId){
    BuildContext dialogContext;
    showDialog(context: context,
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
                  onTap: (){
                    // _loadPicker(ImageSource.gallery, imageNumber);
                    // Provider.of<RecentItemModel>(context, listen: false).getRecentItems();
                    deleteListing(itemId).then((value) => Provider.of<RecentItemModel>(context, listen: false).getRecentItems())
                        .then((value) => Navigator.pop(context)).then((value) =>
                        Navigator.pushReplacementNamed(context, "/home"));
                  },
                ),
                ListTile(
                  title: Text("No"),
                  onTap: (){
                    // _loadPicker(ImageSource.gallery, imageNumber);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ) );
  }

  Future<void> deleteListing(int? itemId) async {
    Map<String, dynamic> data;
    var url = Uri.parse(
        'http://Gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/categories/items/$itemId');
    // var url = Uri.parse(
    //     'http://localhost:8080/items/profile?profileId=$userIdFromDB&size=10'); // TODO -  call the recentItem service when it is built
    http.Response response = await http.delete(
        url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      print(response.statusCode);
    } else {
      print(response.statusCode);
    }
  }
}
