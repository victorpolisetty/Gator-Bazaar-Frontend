import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../api_utils.dart';
import '../models/itemModel.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';

import 'ItemWithImagesSerializer.dart';
part 'recentItemModel.g.dart';

// Handle one Page of Items
@JsonSerializable(explicitToJson: true)
@RecentItemPageSerializer()
class RecentItemPage {
  List<Item> recentItemList = [];
  List<Item> get recentItems => recentItemList;

  RecentItemPage(List<Item> recentItemList){
    this.recentItemList = recentItemList;
  }
  factory RecentItemPage.fromJson(Map<String, dynamic> parsedJson) => _$RecentItemPageFromJson(parsedJson);
  Map<String, dynamic> toJson() => _$RecentItemPageToJson(this);
}


@JsonSerializable(explicitToJson: true)
@FeaturedItemsSerializer()
class RecentItemModel extends ChangeNotifier {
  /// Internal, private state of the cart. Stores the ids of each item.
  List<ItemWithImages> _recentItems = [];
  int totalPages = 0;
  int currentPage = 1;
  int currentUserId = -1;
  bool shouldReload = true;


  /// List of items in the cart.
  List<ItemWithImages> get items => _recentItems;

  factory RecentItemModel.fromJson(Map<String, dynamic> parsedJson) =>
      _$RecentItemModelFromJson(parsedJson);

  Map<String, dynamic> toJson() => _$RecentItemModelToJson(this);

  RecentItemModel() {
    // var initFuture = init();
    // initFuture.then((voidValue) {
    //   notifyListeners();
    // });
  }
  // Future<void> init() async {
  //   this.totalPages = 1;
  //   await getProfileFromDb();
  //   await getFeaturedItems();
  //   await add1stImageToItemIfAvailable();
  // }

  Future<bool?> initNextCatPage(int pageNum) async {
    _recentItems.clear();
    await getProfileFromDb();
    totalPages = await getFeaturedItems();
    await add1stImageToItemIfAvailable();
    return false;
  }

  void getRecentItems() {
    if (shouldReload) {
      var initFuture = getItems();
      initFuture.then((voidValue) {
//      notifyListeners();
      });
    }
  }

  Future<void> getItems() async {
    _recentItems.clear();
    await getProfileFromDb();
    await getFeaturedItems();
    await add1stImageToItemIfAvailable();
    notifyListeners();
  }

  Future<void> init1(int pageNum) async {
    _recentItems.clear();
    await getProfileFromDb();
    await getNextPage(pageNum);
    await add1stImageToItemIfAvailable();
  }

  Future<int> getNextPage(int pageNum) async {
    Map<String, dynamic> data;
    var url = ApiUtils.buildApiUrl('/items?size=6&page=$pageNum&sort=createdAt,desc'); // TODO -  call the recentItem service when it is built
    http.Response response = await http.get(
        url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      var items = data['content'];
      totalPages = data['totalPages'];
      for (int i = 0; i < items.length; i++) {
        ItemWithImages itm = ItemWithImages.fromJson(items[i]);
        _recentItems.add(itm);
      }
      return totalPages;
    } else {
      return 0;
    }
  }

  Future<int> getFeaturedItems() async {
    Map<String, dynamic> data;
    var url = ApiUtils.buildApiUrl('/api/featured-items/get-all-featured-items');

    http.Response response = await http.get(
      url,
      headers: {"Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      String responseJson = Utf8Decoder().convert(response.bodyBytes);
      data = json.decode(responseJson);

      var items = data['content'];
      var totalPages = data['totalPages'];


      for (int i = 0; i < items.length; i++) {
        ItemWithImages itm = ItemWithImages.fromJson(items[i], useCustomSerializer: true);
        _recentItems.add(itm);
      }
      return totalPages;
    } else {
      print('Failed with status: ${response.statusCode}.');
      print('Response body: ${response.body}');
      throw Exception('Failed to load selected items');
    }
  }


  Future<void> getProfileFromDb() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if(currentUser != null) {
      String? firebaseId = currentUser.uid;
      Map<String, dynamic> data;
      var url = ApiUtils.buildApiUrl('/profiles/$firebaseId');
      http.Response response = await http.get(
          url, headers: {"Accept": "application/json"});
      if (response.statusCode == 200) {
        data = jsonDecode(response.body);
        currentUserId = data['id'];
      } else {
        print(response.statusCode);
      }
    }
  }

  Future<void> add1stImageToItemIfAvailable() async {
    if (_recentItems.isEmpty) return;

    Uint8List data = new Uint8List(0) ;
    for (int i = 0; i < _recentItems.length; i++) {
      if (_recentItems[i].itemPictureIds!.isNotEmpty) {
        String urlString = '/itemImages/' +
            (_recentItems[i].itemPictureIds![0]).toString();
        var url = ApiUtils.buildApiUrl(urlString);
        http.Response response = await http.get(
            url, headers: {"Accept": "application/json"});
        if (response.statusCode == 200) {
          data = response.bodyBytes;
        }
      } else {   // Add default - no image
        data = (await rootBundle.load(
            // 'assets/images/no-picture-available-icon.png'
            'assets/images/GatorBazaar.jpg'
        ))
            .buffer
            .asUint8List();
      }
      _recentItems[i].imageDataList.add(data);
    }
  }

  RecentItemModel.paging(int pageNum){
    var initFuture = init1(pageNum);
    initFuture.then((voidValue){
      notifyListeners();
    });
  }


  /// Adds [item] to cart. This is the only way to modify the cart from outside.
  void add(ItemWithImages item) {
    _recentItems.add(item);
    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
    notifyListeners();
  }

  void remove(ItemWithImages item) {
    _recentItems.remove(item);
    // Don't forget to tell dependent widgets to rebuild _every time_
    // you change the model.
    notifyListeners();
  }
}