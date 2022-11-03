import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:student_shopping_v1/models/recentItemModel.dart';
import 'package:student_shopping_v1/models/sellerItemModel.dart';
import '../models/itemModel.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:provider/provider.dart';
part 'categoryItemModel.g.dart';



const String BASE_URI = 'http://Gatorbazaarbackendtested2-env.eba-g27rcqgs.us-east-1.elasticbeanstalk.com/';
const String CATEGORY_ITEMS_URL = '${BASE_URI}categories/';  // TODO -  call the CategoryItem service when it is built
const String ITEMS_IMAGES_URL = '${BASE_URI}itemImages/';  // append id of image to fetch


@JsonSerializable(explicitToJson: true)
class CategoryItemModel extends ChangeNotifier {
  /// Internal, private state of the cart. Stores the ids of each item.
  String keyword = "";
  int categoryId = 0;
  int totalPages = 0;
  int currentPage = 1;
  int userIdFromDb = -1;
  @JsonKey(ignore: true)
  User? currentUser = FirebaseAuth.instance.currentUser;
  List<ItemWithImages> categoryItems = [];
  List<ItemWithImages> categorySearchedItems = [];

  /// List of items in the cart.
  List<ItemWithImages> get items => categoryItems;
  //Add categoryItem



  factory CategoryItemModel.fromJson(Map<String, dynamic> parsedJson) =>
      _$CategoryItemModelFromJson(parsedJson);

  Map<String, dynamic> toJson() => _$CategoryItemModelToJson(this);

// Todo -- Move below to service class

  Future<void> _getItems() async {
    categoryItems.clear();
    await getProfileFromDb(currentUser?.uid.toString());
    await getItemRestList();
    await get1stImageForItemIfAvailable();
    notifyListeners();
  }

  Future<void> init1() async{
    await getProfileFromDb(currentUser!.uid);
  }

  Future<void> init2() async{
    await init1();
  }


  Future<void> _getSearchedItems() async {
    categoryItems.clear();
    await getSearchedItemRestList();
    await get1stImageForItemIfAvailable();
    notifyListeners();
  }

  Future <Item?> postItem(Item itm) async  {
      await init2();
      itm = await postItemSingle(itm) //;
   //   notifyListeners();
     // return itm;
       .then((value)  {
         itm = value;
         return itm;
       }) ;
      return null;
  }



  //TODO: fix api endpoint for user
  Future<Item> postItemSingle(Item itm)  async {
    Map<String, dynamic> data;
    //TODO: need to call this somewhere
    var url = Uri.parse(CATEGORY_ITEMS_URL +
        '${categoryId}/items?profileId=$userIdFromDb');
    var tmpObj =  json.encode(itm.toJson());
    final http.Response response =  await http.post(url
        , headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        }
        , body: tmpObj
        );

  //  .then((response) {
      if (response.statusCode == 200) {
        data = jsonDecode(response.body);
        itm.id = data['id'];
     //   return itm;
      } else {
        print(response.statusCode);
      }
  //  });
    return itm;
  }

  Future<bool?> initNextCatPage(int pageNum, int categoryId) async {
    categoryItems.clear();
    await getProfileFromDb(currentUser?.uid.toString());
    await getNextPage(pageNum, categoryId);
    await get1stImageForItemIfAvailable();
    return false;
  }
  Future<bool?> initSearchCat(int pageNum, String keyword) async {
    await getNextSearchedPage(categoryId, keyword, pageNum,);
    await get1stImageForItemIfAvailable();
    return false;
  }

  Future<int> getNextPage(int pageNum, int categoryId) async {
    Map<String, dynamic> data;

    var url = Uri.parse(CATEGORY_ITEMS_URL+'${categoryId}/items?size=6&page=$pageNum&sort=createdAt,desc'); // TODO -  call the recentItem service when it is built
    http.Response response = await http.get(
        url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      var items = data['content'];
      totalPages = data['totalPages'];
      for (int i = 0; i < items.length; i++) {
        ItemWithImages itm = ItemWithImages.fromJson(items[i]);
        categoryItems.add(itm);
        //Provider.of<RecentItemModel>(context, listen: false).add(itm);


        // for (int imgId in itm.itemImageList) {
        //   var url = Uri.parse(
        //       'http://localhost:8080/categories/1/items'); // TODO -  call the recentItem service when it is built
        // }
      }
      return totalPages;

      //     notifyListeners();
      //print(categoryItems);
    } else {
      print(response.statusCode);
      return -1;
    }
  }

  Future<int> getNextSearchedPage(int categoryId, String searchWord, int pageNum) async {
    Map<String, dynamic> data;

    var url = Uri.parse('http://Gatorbazaarbackendtested2-env.eba-g27rcqgs.us-east-1.elasticbeanstalk.com/items/search/$categoryId/$searchWord?size=10&page=$pageNum'); // TODO -  call the recentItem service when it is built
    http.Response response = await http.get(
        url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      var items = data['content'];
      totalPages = data['totalPages'];
      for (int i = 0; i < items.length; i++) {
        ItemWithImages itm = ItemWithImages.fromJson(items[i]);
        categoryItems.add(itm);
        //Provider.of<RecentItemModel>(context, listen: false).add(itm);


        // for (int imgId in itm.itemImageList) {
        //   var url = Uri.parse(
        //       'http://localhost:8080/categories/1/items'); // TODO -  call the recentItem service when it is built
        // }
      }
      return totalPages;

      //     notifyListeners();
      //print(categoryItems);
    } else {
      print(response.statusCode);
      return -1;
    }
  }

  Future<List<Uint8List>> getAllImagesForItem(ItemWithImages itm) async {
    // If images exist them get them
    if (itm.imageDataLoaded == false && itm.itemPictureIds.length > 0) {
      // call itemmodel to get the images
      return itm.getAllImagesForItem();
    } else {
      throw NullThrownError();
    }
  }

  Future<void> getItemRestList() async {
    Map<String, dynamic> data;

    var url = Uri.parse(CATEGORY_ITEMS_URL+'${categoryId}/items?size=10&page=0&sort=createdAt,desc'); // TODO -  call the recentItem service when it is built
    http.Response response = await http.get(
        url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      String responseJson = Utf8Decoder().convert(response.bodyBytes);
      data = json.decode(responseJson);
      var items = data['content'];
      for (int i = 0; i < items.length; i++) {
        // if(items[i]['seller_id'] == userIdFromDb) {
        //   continue;
        // }
        ItemWithImages itm = ItemWithImages.fromJson(items[i]);
        categoryItems.add(itm);
        totalPages = data['totalPages'];
        // Provider.of<RecentItemModel>(context, listen: false).add(itm);
      }
 //     notifyListeners();
      print(categoryItems);
    } else {
      print(response.statusCode);
    }
  }

  Future<void> getSearchedItemRestList() async {
    Map<String, dynamic> data;

    var url = Uri.parse('http://Gatorbazaarbackendtested2-env.eba-g27rcqgs.us-east-1.elasticbeanstalk.com/items/search/$categoryId/$keyword'); // TODO -  call the recentItem service when it is built
    http.Response response = await http.get(
        url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      var items = data['content'];
      for (int i = 0; i < items.length; i++) {
        ItemWithImages itm = ItemWithImages.fromJson(items[i]);
        categoryItems.add(itm);
        totalPages = data['totalPages'];
        //Provider.of<RecentItemModel>(context, listen: false).add(itm);


        // for (int imgId in itm.itemImageList) {
        //   var url = Uri.parse(
        //       'http://localhost:8080/categories/1/items'); // TODO -  call the recentItem service when it is built
        // }
      }

      //     notifyListeners();
      print(categoryItems);
    } else {
      print(response.statusCode);
    }
  }

  // Future<List<Uint8List>> getAllImagesForItem(ItemWithImages itm) async {
  //   // If images exist them get them
  //   if (itm.imageDataLoaded == false && itm.itemPictureIds.length > 0) {
  //     // call itemmodel to get the images
  //     return itm.getAllImagesForItem();
  //   } else {
  //     throw NullThrownError();
  //   }
  // }


  Future<void> get1stImageForItemIfAvailable() async {
    if (categoryItems.isEmpty) return;
    Uint8List data = new Uint8List(0);

    for (int i = 0; i < categoryItems.length; i++) {
      if (categoryItems[i].itemPictureIds.isNotEmpty) {
        String urlString = ITEMS_IMAGES_URL +
            (categoryItems[i].itemPictureIds[0]).toString();
        var url = Uri.parse(urlString);
        http.Response response = await http.get(
            url, headers: {"Accept": "application/json"});
        if (response.statusCode == 200) {
          data = response.bodyBytes;
        }
        print(categoryItems);
      } else { // Add default - no image
        data = (await rootBundle.load(
            // 'assets/images/no-picture-available-icon.png'
            'assets/images/GatorBazaar.jpg'

        ))
            .buffer
            .asUint8List();
      }
      categoryItems[i].imageDataList.add(data);
    }
  }

  void getCategoryItems (int categoryId) {
    this.categoryId = categoryId;
    var initFuture = _getItems();
    initFuture.then((voidValue) {
//      notifyListeners();
    });
  }

  void getSearchedCategoryItems (int categoryId, String keyword) {
    this.categoryId = categoryId;
    this.keyword = keyword;
    var initFuture = _getSearchedItems();
    initFuture.then((voidValue) {
//      notifyListeners();
    });
  }


  Future<ItemWithImages?> uploadItemImageToDB(File imageFile, ItemWithImages itmRest) async {
    int sizeInBytes = imageFile.lengthSync();
    double sizeInMb = sizeInBytes / (1024 * 1024);
    print("SIZE OF IMAGE IS: + " + sizeInMb.toString()) ;
    // String fileExtension = p.extension(imageFile.path).replaceAll('.', '');
    // if(fileExtension == 'heic'){
    //   print("convert to jpeg");
    //   String? jpegPath = await HeicToJpg.convert(imageFile.path);
    //   imageFile = File(jpegPath!);
    //   fileExtension = 'jpeg';
    // }
    var stream  = new http.ByteStream(imageFile.openRead()); stream.cast();
    var length = await imageFile.length();
    var itemId = itmRest.id!;
    var uri = Uri.parse('http://Gatorbazaarbackendtested2-env.eba-g27rcqgs.us-east-1.elasticbeanstalk.com/items/$itemId/itemImages');

    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));
    //contentType: new MediaType('image', 'png'));

    request.files.add(multipartFile);
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      print(response.statusCode);
      var data = response.bodyBytes;
      itmRest.imageDataList.add(data);
      //response.transform(utf8.decoder).listen((value) {
      return itmRest;
        print(data);
      }
    return null;
  }



  Future<void> addCategoryItem (int categoryId, Item itm, List<File> imageDataList, BuildContext context) async {
    this.categoryId = categoryId;

    try {
      postItem(itm)
          .then((retItm) async {
             if (itm.id != null) {
               //TODO: put seller_id instead of 1
               ItemWithImages itmRest = new ItemWithImages.CreateItem(itm.category_id, 1 ,itm.name,itm.price,itm.description,itm.id, new List.empty());
               for (File img in imageDataList) { // Insert images
                  uploadItemImageToDB(img, itmRest);
               }
               categoryItems.add(itmRest);
               Provider.of<SellerItemModel>(context, listen: false).add(itmRest);
               // Provider.of<RecentItemModel>(context, listen: false).add(itmRest);
               Provider.of<RecentItemModel>(context, listen: false).shouldReload = true;
             }
      });
    } catch (e) {
      print(e);
    }
  }

  CategoryItemModel() {
  }

  /// Adds [item] to cart. This is the only way to modify the cart from outside.
  void add(ItemWithImages item) {
    categoryItems.add(item);
    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
   notifyListeners();
  }

  void remove(ItemWithImages item) {
    categoryItems.remove(item);
    // Don't forget to tell dependent widgets to rebuild _every time_
    // you change the model.
   notifyListeners();
  }
  Future<void> getProfileFromDb(String? firebaseid) async {
    Map<String, dynamic> data;
    var url = Uri.parse('http://Gatorbazaarbackendtested2-env.eba-g27rcqgs.us-east-1.elasticbeanstalk.com/profiles/$firebaseid'); // TODO -  call the recentItem service when it is built
    http.Response response = await http.get(
        url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      // data.map<Item>((json) => Item.fromJson(json)).toList();
      data = jsonDecode(response.body);
      userIdFromDb = data['id'];
      print(response.statusCode);
    } else {
      print(response.statusCode);
    }
  }
}



// Handle one Page of Items
@JsonSerializable(explicitToJson: true)
class CategoryItemPage {
  List<ItemWithImages> categoryItemList = [];
  List<ItemWithImages> get categoryItems => categoryItemList;

  CategoryItemPage(List<ItemWithImages> categoryItemList){
    this.categoryItemList = categoryItemList;
  }
  factory CategoryItemPage.fromJson(Map<String, dynamic> parsedJson) => _$CategoryItemPageFromJson(parsedJson);
  Map<String, dynamic> toJson() => _$CategoryItemPageToJson(this);
}