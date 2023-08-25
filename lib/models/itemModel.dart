import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'ItemWithImagesSerializer.dart';
part 'itemModel.g.dart';

const String BASE_URI = 'http://Gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/';
const String ITEMS_IMAGES_URL = '${BASE_URI}itemImages/';  // append id of image to fetch

@JsonSerializable()
class ItemPage{
  List<Item>itemList = [];
  List<Item> get items => itemList;

  ItemPage(List<Item> itemList){
    this.itemList = itemList;
  }
  factory ItemPage.fromJson(Map<String, dynamic> parsedJson) => _$ItemPageFromJson(parsedJson);
  Map<String, dynamic> toJson() => _$ItemPageToJson(this);
}

@JsonSerializable()
class ItemWithImages extends ChangeNotifier{
  int ?category_id = 0;
  int ?seller_id = 0;
  int ?id ;
  String? name = "";
  String? seller_email = "";
  String? seller_name = "";
  // String imageURL = "";
  String? description = "";
  num? price = 0;
  bool? isSold = false;
  //Item item ;
  List<int>? itemPictureIds = [];  // list of image ids . this should match the json element name
  @JsonKey(ignore : true)
  List<Uint8List> imageDataList = [];
  @JsonKey(ignore : true)
  bool imageDataLoaded = false;   //set it to true after loading images


  Future<List<Uint8List>> getAllImagesForItem() async {
    Uint8List data = new Uint8List(0);
    for (int i = this.imageDataList.length; i < this.itemPictureIds!.length && imageDataLoaded == false; i++) {
        String urlString = ITEMS_IMAGES_URL +
            (this.itemPictureIds![i]).toString();
        var url = Uri.parse(urlString);
        http.Response response = await http.get(
            url, headers: {"Accept": "application/json"});
        if (response.statusCode == 200) {
          data = response.bodyBytes;
        }
        this.imageDataList.add(data);
    }
    this.imageDataLoaded = true;
    return imageDataList;
  }

  ItemWithImages() {
  }

  ItemWithImages.CreateItem(int? category_id, int? seller_id, String name, num price, String description, int? id, List<int> itemPictureIds) {
    this.category_id = category_id;
    this.name = name;
    this.price = price;
    this.description = description;
    this.id = id;
    this.itemPictureIds = itemPictureIds;
    this.seller_id = seller_id;
    this.isSold = false;
  }
  ItemWithImages.FavoriteItem(int id, String name, num price, String description, Uint8List picture){
    this.id = id;
    this.name = name;
    this.price = price;
    this.description = description;
    imageDataList.add(picture);
  }
  ItemWithImages.RecentItem(int? category_id, String name, num price, String description, int? id){
    this.category_id = category_id;
    this.name = name;
    this.price = price;
    this.description = description;
    this.id = id;
  }

  @override
  bool operator ==(other) {
    if (other is ItemWithImages) {
      return other.id == this.id;
    } else {
      return false;
    }
  }
  // factory ItemWithImages.fromJson(Map<String, dynamic> json) =>
  //     itemWithImagesFromJson(jsonEncode(json));
  //
  // Map<String, dynamic> toJson() => jsonDecode(itemWithImagesToJson(this));

  factory ItemWithImages.fromJson(Map<String, dynamic> parsedJson, {bool useCustomSerializer = false}) {
    if (useCustomSerializer) {
      return FeaturedItemsSerializer().fromJson(parsedJson);
    }
    return _$ItemWithImagesFromJson(parsedJson);
  }
  Map<String, dynamic> toJson() => _$ItemWithImagesToJson(this);

}

toNull(_) => null;

@JsonSerializable()
class Item {
  @JsonKey(toJson: toNull, includeIfNull: false)
  int ?category_id = 0;
  @JsonKey (includeIfNull: false )
  int ?id ;
  String name = "";
 // String imageURL = "";
  String description = "";
  num price = 0;

  Item(int category_id,  String name, num price, String description, {int? id = -1}){
    this.id = id;
    this.category_id = category_id;
    this.name = name;
    this.price = price;
 //   this.imageURL = imageURL;
    this.description = description;
  }

  factory Item.fromJson(Map<String, dynamic> parsedJson) => _$ItemFromJson(parsedJson);
  Map<String, dynamic> toJson() => _$ItemToJson(this);

  @override
  bool operator ==(other) {
    if (other is ItemWithImages) {
      return other.id == id;
    } else {
      return false;
    }
  }
}
class ItemModel extends ChangeNotifier{
  List <Item> itemList = [];
}





