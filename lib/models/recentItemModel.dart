import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/itemModel.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';
part 'recentItemModel.g.dart';

const String BASE_URI = 'http://Gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/';
const String RECENT_ITEMS_URL = '${BASE_URI}items?size=10&sort=createdAt,desc';  // TODO -  call the recentItem service when it is built
const String ITEMS_IMAGES_URL = '${BASE_URI}itemImages/';  // append id of image to fetch

// Handle one Page of Items
@JsonSerializable(explicitToJson: true)
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
class RecentItemModel extends ChangeNotifier {
  /// Internal, private state of the cart. Stores the ids of each item.
  List<ItemWithImages> _recentItems = [];
  int totalPages = 0;
  int currentPage = 1;
  int currentUserId = -1;
  @JsonKey(ignore: true)
  User? currentUser = FirebaseAuth.instance.currentUser;
  bool shouldReload = true;


  /// List of items in the cart.
  List<ItemWithImages> get items => _recentItems;

  factory RecentItemModel.fromJson(Map<String, dynamic> parsedJson) =>
      _$RecentItemModelFromJson(parsedJson);

  Map<String, dynamic> toJson() => _$RecentItemModelToJson(this);

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
    await getProfileFromDb(currentUser?.uid.toString());
    this.totalPages = await getItemRestList();
    await add1stImageToItemIfAvailable();
    notifyListeners();
  }

  Future<void> init1(int pageNum) async {
    _recentItems.clear();
    await getProfileFromDb(currentUser?.uid.toString());
    await getNextPage(pageNum);
    await add1stImageToItemIfAvailable();
  }

  Future<int> getNextPage(int pageNum) async {
    Map<String, dynamic> data;
    var url = Uri.parse('http://Gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/items?size=6&page=$pageNum&sort=createdAt,desc'); // TODO -  call the recentItem service when it is built
    http.Response response = await http.get(
        url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      // data.map<Item>((json) => Item.fromJson(json)).toList();
      data = jsonDecode(response.body);
      var items = data['content'];
      totalPages = data['totalPages'];
      print(totalPages);


      for (int i = 0; i < items.length; i++) {
        ItemWithImages itm = ItemWithImages.fromJson(items[i]);
        _recentItems.add(itm);
        // for (int imgId in itm.itemImageList) {
        //   var url = Uri.parse(
        //       'http://localhost:8080/categories/1/items'); // TODO -  call the recentItem service when it is built
        // }
      }
      return totalPages;
      print(_recentItems);
    } else {
      return 0;
      print(response.statusCode);
    }
  }

  Future<int> getItemRestList() async {
    Map<String, dynamic> data;
    var url = Uri.parse(
        'http://Gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/items?size=20&sort=createdAt,desc'); // TODO -  call the recentItem service when it is built
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
        // if(items[i]['seller_id'] == currentUserId) {
        //   continue;
        // }
        ItemWithImages itm = ItemWithImages.fromJson(items[i]);
        _recentItems.add(itm);
      }
      return totalPages;
    } else {
      return 0;
    }
  }

  Future<void> getProfileFromDb(String? firebaseid) async {
    Map<String, dynamic> data;
    var url = Uri.parse('http://Gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/profiles/$firebaseid'); // TODO -  call the recentItem service when it is built
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

  Future<void> add1stImageToItemIfAvailable() async {
    if (_recentItems.isEmpty) return;

    Uint8List data = new Uint8List(0) ;
    for (int i = 0; i < _recentItems.length; i++) {
      if (_recentItems[i].itemPictureIds.isNotEmpty) {
        String urlString = ITEMS_IMAGES_URL +
            (_recentItems[i].itemPictureIds[0]).toString();
        var url = Uri.parse(urlString);
        http.Response response = await http.get(
            url, headers: {"Accept": "application/json"});
        if (response.statusCode == 200) {
          data = response.bodyBytes;
        }
        print(_recentItems);
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

  RecentItemModel() {
    // var initFuture = init();
    // initFuture.then((voidValue) {
    //   // state = HomeScreenModelState.initialized;
    //   notifyListeners();
    // });
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