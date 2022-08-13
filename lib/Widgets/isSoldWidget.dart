import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_shopping_v1/models/favoriteModel.dart';
import 'package:provider/provider.dart';
import 'package:student_shopping_v1/models/itemModel.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import '../models/sellerItemModel.dart';

class isSoldWidget extends StatefulWidget {
  var item;
  var isSold;

  isSoldWidget({
    this.isSold,
    this.item,
  });

  @override
  _isSoldWidgetState createState() =>
      _isSoldWidgetState(item);
}

class _isSoldWidgetState extends State<isSoldWidget> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  ItemWithImages item;

  _isSoldWidgetState(this.item);

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
        Container(
          child: widget.isSold == false ? Text(
            "Click here to mark item as Sold!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),
          ) : Text(
            "Click here to mark item as Available!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),
          ),
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(1.0, 2.0, 10.0, 4.0),
            child: Container(
              child: new IconButton(
                  icon: Icon(widget.isSold ? Icons.check_box : Icons.check_box_outlined),
                  color: Colors.black,
                  onPressed: () {
                    updateIsSoldStatus();
                    _toggleIsSold(widget.isSold, item);
                    Provider.of<SellerItemModel>(context, listen: false).getProfileIdAndItems();
                  }),
            )),
      ],
    );
  }
  Future<void> updateIsSoldStatus()  async {
    Map<String, dynamic> data;
    String itemId = widget.item.id.toString();
    String categoryId = widget.item.category_id.toString();
    var url = Uri.parse('http://localhost:8080/categories/$categoryId/items/soldStatus/$itemId');
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
}
