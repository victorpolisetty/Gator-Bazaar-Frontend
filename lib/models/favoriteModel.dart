import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/itemModel.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class FavoriteModel extends ChangeNotifier {
  /// Internal, private state of the cart. Stores the ids of each item.
  List<ItemWithImages> _favoriteItems = [];
  /// List of items in the cart.
  List<ItemWithImages> get items => _favoriteItems;
  User? currentUser = FirebaseAuth.instance.currentUser;



  FavoriteModel(){

  }

  // FavoriteModel() {
  //   var initFuture = init1();
  //   initFuture.then((voidValue) {
  //     notifyListeners();
  //   });
  // }

  /// Adds [item] to cart. This is the only way to modify the cart from outside.
  void add(ItemWithImages item) {

    _favoriteItems.add(item);
    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
    notifyListeners();
  }

  void remove(ItemWithImages item) {
    _favoriteItems.remove(item);
    // Don't forget to tell dependent widgets to rebuild _every time_
    // you change the model.
    notifyListeners();
  }



  Future<void> getItemRestList() async {
    List data;
    String firebaseId = currentUser!.uid;
    var url = Uri.parse('http://studentshopspringbackend-env.eba-b2yvpimm.us-east-1.elasticbeanstalk.com/profiles/$firebaseId/favorites');
    http.Response response = await http.get(url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      String responseJson = Utf8Decoder().convert(response.bodyBytes);
      data = json.decode(responseJson);
      _favoriteItems = data.map((itm) => new ItemWithImages.fromJson(itm)).toList();
      print(_favoriteItems);
    } else {
      print (response.statusCode);
    }
  }
  void getCategoryItems () {
    var initFuture = _getItems();
    initFuture.then((voidValue) {
//      notifyListeners();
    });
  }
  Future<void> _getItems() async {
    _favoriteItems.clear();
    await getItemRestList();
    await get1stImageForItemIfAvailable();
    notifyListeners();
  }
  Future<void> get1stImageForItemIfAvailable() async {
    if (_favoriteItems.isEmpty) return;
    Uint8List data = new Uint8List(0);

    for (int i = 0; i < _favoriteItems.length; i++) {
      if (_favoriteItems[i].itemPictureIds.isNotEmpty) {
        String urlString = ITEMS_IMAGES_URL +
            (_favoriteItems[i].itemPictureIds[0]).toString();
        var url = Uri.parse(urlString);
        http.Response response = await http.get(
            url, headers: {"Accept": "application/json"});
        if (response.statusCode == 200) {
          data = response.bodyBytes;
        }
        print(_favoriteItems);
      } else { // Add default - no image
        data = (await rootBundle.load(
            'assets/images/no-picture-available-icon.png'))
            .buffer
            .asUint8List();
      }
      _favoriteItems[i].imageDataList.add(data);
    }
  }
}



