import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../api_utils.dart';
import '../models/itemModel.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class FavoriteModel extends ChangeNotifier {
  /// Internal, private state of the cart. Stores the ids of each item.
  List<ItemWithImages> _favoriteItems = [];
  int userIdFromDb = -1;
  int totalPages = 0;

  /// List of items in the cart.
  List<ItemWithImages> get items => _favoriteItems;



  // FavoriteModel(){
  //
  // }

  Future<bool?> initNextCatPage(int pageNum) async {
    _favoriteItems.clear();
    await getProfileFromDb();
    await getNextPage(pageNum);
    await get1stImageForItemIfAvailable();
    return false;
  }

  Future<int> getNextPage(int pageNum) async {
    User? currentUser = FirebaseAuth.instance.currentUser; // Retrieve currentUser here
    if(currentUser != null) {
      String? firebaseId = currentUser.uid;
      Map<String, dynamic> data;
      var url = ApiUtils.buildApiUrl('/profiles/$firebaseId/favorites?page=$pageNum&size=5&sort=createdAt,desc');
      http.Response response = await http.get(
          url, headers: {"Accept": "application/json"});
      if (response.statusCode == 200) {
        String responseJson = Utf8Decoder().convert(response.bodyBytes);
        data = json.decode(responseJson);
        var items = data['content'];
        totalPages = data['totalPages'];
        for (int i = 0; i < items.length; i++) {
          ItemWithImages itm = ItemWithImages.fromJson(items[i]);
          _favoriteItems.add(itm);
        }
        return totalPages;
      } else {
        print(response.statusCode);
        return -1;
      }
    } else {
      print("Couldn't find firebaseId");
      return -1;
    }
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
    User? currentUser = FirebaseAuth.instance.currentUser; // Retrieve currentUser here
    if (currentUser != null) {
      Map<String, dynamic> data; // Updated data type to Map<String, dynamic>
      String? firebaseId = currentUser.uid;
      var url = ApiUtils.buildApiUrl(
          '/profiles/$firebaseId/favorites');
      http.Response response =
      await http.get(url, headers: {"Accept": "application/json"});
      if (response.statusCode == 200) {
        String responseJson = Utf8Decoder().convert(response.bodyBytes);
        data = json.decode(responseJson);
        // Now data is a Map<String, dynamic> representing the JSON object
        _favoriteItems = [ItemWithImages.fromJson(data)]; // Assuming _favoriteItems is a List<ItemWithImages>
      } else {
        print(response.statusCode);
      }
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
    await getProfileFromDb();
    await getItemRestList();
    await get1stImageForItemIfAvailable();
    notifyListeners();
  }
  Future<void> get1stImageForItemIfAvailable() async {
    if (_favoriteItems.isEmpty) return;
    Uint8List data = Uint8List(0);

    for (int i = 0; i < _favoriteItems.length; i++) {
      if (_favoriteItems[i].itemPictureIds != null &&
          _favoriteItems[i].itemPictureIds!.isNotEmpty) {
        String urlString = '/itemImages/' +
            _favoriteItems[i].itemPictureIds![0].toString();
        var url = ApiUtils.buildApiUrl(urlString);
        http.Response response =
        await http.get(url, headers: {"Accept": "application/json"});
        if (response.statusCode == 200) {
          data = response.bodyBytes;
        }
      } else {
        // Add default - no image
        data = (await rootBundle.load('assets/images/GatorBazaar.jpg'))
            .buffer
            .asUint8List();
      }
      _favoriteItems[i].imageDataList.add(data);
    }
  }

  Future<void> getProfileFromDb() async {
    User? currentUser = FirebaseAuth.instance.currentUser; // Retrieve currentUser here
    if(currentUser != null) {
      String? firebaseId = currentUser.uid;
      Map<String, dynamic> data;
      var url = ApiUtils.buildApiUrl('/profiles/$firebaseId'); // TODO -  call the recentItem service when it is built
      http.Response response = await http.get(
          url, headers: {"Accept": "application/json"});
      if (response.statusCode == 200) {
        // data.map<Item>((json) => Item.fromJson(json)).toList();
        data = jsonDecode(response.body);
        userIdFromDb = data['id'];
      } else {
        print(response.statusCode);
      }
    }
  }
}



