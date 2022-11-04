import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/itemModel.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';
part 'sellerItemModel.g.dart';


const String BASE_URI = 'http://Gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/';
const String RECENT_ITEMS_URL = '${BASE_URI}items?size=10&sort=createdAt,desc';  // TODO -  call the recentItem service when it is built
const String ITEMS_IMAGES_URL = '${BASE_URI}itemImages/';  // append id of image to fetch

// Handle one Page of Items
@JsonSerializable(explicitToJson: true)
class SellerItemPage {
  List<Item> sellerItemList = [];
  List<Item> get sellerItems => sellerItemList;

  SellerItemPage(List<Item> sellerItemList){
    this.sellerItemList = sellerItemList;
  }
  factory SellerItemPage.fromJson(Map<String, dynamic> parsedJson) => _$SellerItemPageFromJson(parsedJson);
  Map<String, dynamic> toJson() => _$SellerItemPageToJson(this);
}


@JsonSerializable(explicitToJson: true)
class SellerItemModel extends ChangeNotifier {
  /// Internal, private state of the cart. Stores the ids of each item.
  List<ItemWithImages> _sellerItems = [];
  int totalPages = 0;
  int currentPage = 1;
  int userIdFromDB = -1;
  @JsonKey(ignore: true)
  User? currentUser = FirebaseAuth.instance.currentUser;


  /// List of items in the cart.
  List<ItemWithImages> get items => _sellerItems;

  factory SellerItemModel.fromJson(Map<String, dynamic> parsedJson) =>
      _$SellerItemModelFromJson(parsedJson);

  Map<String, dynamic> toJson() => _$SellerItemModelToJson(this);

  // Future<void> init100() async {
  //   Future.wait([getProfileFromDb(currentUser!.uid)]);
  //   await Future.delayed(Duration(seconds: 5));
  //   this.totalPages = await getItemRestList();
  //   // await Future.delayed(Duration(seconds: 5));
  //   await add1stImageToItemIfAvailable();
  // }
  //
  Future<void> init1(int pageNum) async {
    await getNextPage(pageNum);
    await add1stImageToItemIfAvailable();
  }

  void getProfileIdAndItems () {
    var initFuture = _getItems();
    initFuture.then((voidValue) {
//      notifyListeners();
    });
  }

  Future<void> _getItems() async {
    _sellerItems.clear();
    await getProfileFromDb(currentUser!.uid);
    this.totalPages = await getItemRestList();
    await get1stImageForItemIfAvailable();
    notifyListeners();
  }

  Future<void> get1stImageForItemIfAvailable() async {
    if (_sellerItems.isEmpty) return;
    Uint8List data = new Uint8List(0);

    for (int i = 0; i < _sellerItems.length; i++) {
      if (_sellerItems[i].itemPictureIds.isNotEmpty) {
        String urlString = ITEMS_IMAGES_URL +
            (_sellerItems[i].itemPictureIds[0]).toString();
        var url = Uri.parse(urlString);
        http.Response response = await http.get(
            url, headers: {"Accept": "application/json"});
        if (response.statusCode == 200) {
          data = response.bodyBytes;
        }
        print(_sellerItems);
      } else { // Add default - no image
        data = (await rootBundle.load(
            'assets/images/GatorBazaar.jpg'))
            .buffer
            .asUint8List();
      }
      _sellerItems[i].imageDataList.add(data);
    }
  }

  Future<int> getNextPage(int pageNum) async {
    Map<String, dynamic> data;
    var url = Uri.parse('http://Gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/items/profile?profileId=$userIdFromDB&size=10&page=$pageNum'); // TODO -  call the recentItem service when it is built
    http.Response response = await http.get(
        url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      // data.map<Item>((json) => Item.fromJson(json)).toList();
      data = jsonDecode(response.body);
      var items = data['content'];
      var totalPages = data['totalPages'];
      print(totalPages);


      for (int i = 0; i < items.length; i++) {
        ItemWithImages itm = ItemWithImages.fromJson(items[i]);
        _sellerItems.add(itm);
        // for (int imgId in itm.itemImageList) {
        //   var url = Uri.parse(
        //       'http://localhost:8080/categories/1/items'); // TODO -  call the recentItem service when it is built
        // }
      }
      return totalPages;
      print(_sellerItems);
    } else {
      return 0;
      print(response.statusCode);
    }
  }




  Future<int> getItemRestList() async {
    Map<String, dynamic> data;
    var url = Uri.parse(
        'http://Gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/items/profile?profileId=$userIdFromDB');
    // var url = Uri.parse(
    //     'http://localhost:8080/items/profile?profileId=$userIdFromDB&size=10'); // TODO -  call the recentItem service when it is built
    http.Response response = await http.get(
        url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      // data.map<Item>((json) => Item.fromJson(json)).toList();
      String responseJson = Utf8Decoder().convert(response.bodyBytes);
      data = json.decode(responseJson);
      var items = data['content'];
      var totalPages = data['totalPages'];
      print(totalPages);

      for (int i = 0; i < items.length; i++) {
        ItemWithImages itm = ItemWithImages.fromJson(items[i]);
        _sellerItems.add(itm);
      }
      return totalPages;
    } else {
      return 0;
    }
  }

  Future<void> add1stImageToItemIfAvailable() async {
    if (_sellerItems.isEmpty) return;

    Uint8List data = new Uint8List(0) ;
    for (int i = 0; i < _sellerItems.length; i++) {
      if (_sellerItems[i].itemPictureIds.isNotEmpty) {
        String urlString = ITEMS_IMAGES_URL +
            (_sellerItems[i].itemPictureIds[0]).toString();
        var url = Uri.parse(urlString);
        http.Response response = await http.get(
            url, headers: {"Accept": "application/json"});
        if (response.statusCode == 200) {
          data = response.bodyBytes;
        }
        print(_sellerItems);
      } else {   // Add default - no image
        data = (await rootBundle.load('assets/images/GatorBazaar.jpg'))
            .buffer
            .asUint8List();
      }
      _sellerItems[i].imageDataList.add(data);
    }
  }

  Future<void> getUserIdFromDb() async {

  }

  SellerItemModel.paging(int pageNum){
    var initFuture = init1(pageNum);
    initFuture.then((voidValue){
      notifyListeners();
    });
  }

  SellerItemModel() {
  //   var initFuture = init();
  //   initFuture.then((voidValue) {
  //     // state = HomeScreenModelState.initialized;
  //     notifyListeners();
  //   });
  }

  /// Adds [item] to cart. This is the only way to modify the cart from outside.
  void add(ItemWithImages item) {
    _sellerItems.add(item);
    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
    notifyListeners();
  }

  void remove(ItemWithImages item) {
    _sellerItems.remove(item);
    // Don't forget to tell dependent widgets to rebuild _every time_
    // you change the model.
    notifyListeners();
  }
  Future<void> getProfileFromDb(String? firebaseid) async {
    Map<String, dynamic> data;
    var url = Uri.parse('http://Gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/profiles/$firebaseid'); // TODO -  call the recentItem service when it is built
    http.Response response = await http.get(
        url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      // data.map<Item>((json) => Item.fromJson(json)).toList();
      data = jsonDecode(response.body);
      userIdFromDB = data['id'];
      print(response.statusCode);
    } else {
      print(response.statusCode);
    }
  }
}
