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
part 'groupItemModel.g.dart';



const String BASE_URI = 'http://gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/';
const String CATEGORY_ITEMS_URL = '${BASE_URI}categories/';  // TODO -  call the CategoryItem service when it is built
const String ITEMS_IMAGES_URL = '${BASE_URI}itemImages/';  // append id of image to fetch


@JsonSerializable(explicitToJson: true)
class GroupItemModel extends ChangeNotifier {
  /// Internal, private state of the cart. Stores the ids of each item.
  String keyword = "";
  int categoryId = 0;
  int totalPages = 0;
  int currentPage = 1;
  int userIdFromDb = -1;
  Set<int> groupIds = {};
  @JsonKey(ignore: true)
  User? currentUser = FirebaseAuth.instance.currentUser;
  List<ItemWithImages> groupItems = [];
  List<ItemWithImages> groupSearchedItems = [];

  /// List of items in the cart.
  List<ItemWithImages> get items => groupItems;
  //Add categoryItem

  GroupItemModel(){}


  factory GroupItemModel.fromJson(Map<String, dynamic> parsedJson) =>
      _$GroupItemModelFromJson(parsedJson);

  Map<String, dynamic> toJson() => _$GroupItemModelToJson(this);

  Future<void> _getItems() async {
    groupItems.clear();
    await getProfileFromDb(currentUser?.uid.toString());
    await getItemRestList(groupIds);
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
    groupItems.clear();
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



  Future<Item> postItemSingle(Item itm)  async {
    Map<String, dynamic> data;
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

  Future<bool?> initNextCatPage(int pageNum, Set<int> groupIds, int resultOfCatSelected) async {
    groupItems.clear();
    await getProfileFromDb(currentUser?.uid.toString());
    if(resultOfCatSelected == 10) {
      await getNextPageAll(pageNum, groupIds, resultOfCatSelected);
    } else {
      await getNextPageCat(pageNum, groupIds, resultOfCatSelected);
    }
    await get1stImageForItemIfAvailable();
    return false;
  }

  Future<bool?> initSearchCat(int pageNum, String keyword) async {
    await getNextSearchedPage(categoryId, keyword, pageNum,);
    await get1stImageForItemIfAvailable();
    return false;
  }

  // Future<int> getNextPage(int pageNum, int categoryId) async {
  //   Map<String, dynamic> data;
  //
  //   var url = Uri.parse('http://localhost:5000/getItemsByGroupIds?size=6&page=$pageNum&sort=createdAt,desc'); // TODO -  call the recentItem service when it is built
  //   http.Response response = await http.post(
  //       url, headers: {"Accept": "application/json"});
  //   if (response.statusCode == 200) {
  //
  //   } else {
  //     print(response.statusCode);
  //     return -1;
  //   }
  // }

  Future<int> getNextPageAll(int pageNum, Set<int> groupIds, resultOfCatSelected) async {
    Map<String, dynamic> data;

    // Convert groupIds to a comma-separated string for the URL
    String groupIdsString = groupIds.join(',');

    var url = Uri.parse('http://gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/getItemsByGroupIds?size=6&page=$pageNum&sort=createdAt,desc&groupIds=$groupIdsString');

    http.Response response = await http.get(
      url,
      headers: {"Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      var items = data['content'];
      totalPages = data['totalPages'];
      for (int i = 0; i < items.length; i++) {
        ItemWithImages itm = ItemWithImages.fromJson(items[i]);
        groupItems.add(itm);
      }
      return totalPages;
    } else {
      print(response.statusCode);
      return -1;
    }
  }

  Future<int> getNextPageCat(int pageNum, Set<int> groupIds, int selectedCategoryId) async {
    Map<String, dynamic> data;

    var url = Uri.parse('http://gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/getItemsByGroupAndCategoryIds?size=6&page=$pageNum&sort=createdAt,desc'
        '&groupIds=${groupIds.toList().join(",")}&categoryIds=$selectedCategoryId');

    http.Response response = await http.get(
      url,
      headers: {"Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      var items = data['content'];
      totalPages = data['totalPages'];
      for (int i = 0; i < items.length; i++) {
        ItemWithImages itm = ItemWithImages.fromJson(items[i]);
        groupItems.add(itm);
      }
      return totalPages;
    } else {
      print(response.statusCode);
      return -1;
    }
  }


  Future<int> getNextSearchedPage(int categoryId, String searchWord, int pageNum) async {
    Map<String, dynamic> data;

    var url = Uri.parse('http://Gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/items/search/$categoryId/$searchWord?size=10&page=$pageNum'); // TODO -  call the recentItem service when it is built
    http.Response response = await http.get(
        url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      var items = data['content'];
      totalPages = data['totalPages'];
      for (int i = 0; i < items.length; i++) {
        ItemWithImages itm = ItemWithImages.fromJson(items[i]);
        groupItems.add(itm);
      }
      return totalPages;
    } else {
      print(response.statusCode);
      return -1;
    }
  }

  Future<List<Uint8List>> getAllImagesForItem(ItemWithImages itm) async {
    // If images exist them get them
    if (itm.imageDataLoaded == false && itm.itemPictureIds!.length > 0) {
      // call itemmodel to get the images
      return itm.getAllImagesForItem();
    } else {
      throw NullThrownError();
    }
  }

  Future<void> getItemRestList(Set<int> groupIds) async {
    var url = Uri.parse('http://gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/getItemsByGroupIds');
    String jsonBody = json.encode({'groupIds': groupIds.toList()});
    final http.Response response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      print("Received Item IDs: $data");
      // Process item IDs as needed
    } else {
      print(response.statusCode);
    }
  }


  Future<void> getSearchedItemRestList() async {
    Map<String, dynamic> data;

    var url = Uri.parse('http://Gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/items/search/$categoryId/$keyword'); // TODO -  call the recentItem service when it is built
    http.Response response = await http.get(
        url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      var items = data['content'];
      for (int i = 0; i < items.length; i++) {
        ItemWithImages itm = ItemWithImages.fromJson(items[i]);
        groupItems.add(itm);
        totalPages = data['totalPages'];
        //Provider.of<RecentItemModel>(context, listen: false).add(itm);


        // for (int imgId in itm.itemImageList) {
        //   var url = Uri.parse(
        //       'http://localhost:8080/categories/1/items'); // TODO -  call the recentItem service when it is built
        // }
      }

      //     notifyListeners();
      print(groupItems);
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
    if (groupItems.isEmpty) return;
    Uint8List data = new Uint8List(0);

    for (int i = 0; i < groupItems.length; i++) {
      if (groupItems[i].itemPictureIds!.isNotEmpty) {
        String urlString = ITEMS_IMAGES_URL +
            (groupItems[i].itemPictureIds![0]).toString();
        var url = Uri.parse(urlString);
        http.Response response = await http.get(
            url, headers: {"Accept": "application/json"});
        if (response.statusCode == 200) {
          data = response.bodyBytes;
        }
        print(groupItems);
      } else { // Add default - no image
        data = (await rootBundle.load(
          // 'assets/images/no-picture-available-icon.png'
            'assets/images/GatorBazaar.jpg'

        ))
            .buffer
            .asUint8List();
      }
      groupItems[i].imageDataList.add(data);
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
    var uri = Uri.parse('http://Gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/items/$itemId/itemImages');

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



  Future<void> addCategoryItem (int categoryId, Item itm, List<File> imageDataList, BuildContext context, Set<int> groupIdsForItem) async {
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
          groupItems.add(itmRest);
          Provider.of<SellerItemModel>(context, listen: false).add(itmRest);
          Provider.of<RecentItemModel>(context, listen: false).shouldReload = true;
        }
        //TODO: add logic here to put group ids inside item
      }).then((value) => addItemToGroups(itm.id,groupIdsForItem));
    } catch (e) {
      print(e);
    }
  }

  Future<void> addItemToGroups(int? itemId, Set<int> groupIdsForItem) async {
    var url = Uri.parse('http://gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/setGroupsItemIsIn/$itemId/items');

    Map<String, dynamic> body = {
      "groupIds": groupIdsForItem.toList(),
    };

    final http.Response response = await http.put(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      print(response.statusCode);
    } else {
      print(response.statusCode);
    }
  }




  CategoryItemModel() {
  }

  /// Adds [item] to cart. This is the only way to modify the cart from outside.
  void add(ItemWithImages item) {
    groupItems.add(item);
    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
    notifyListeners();
  }

  void remove(ItemWithImages item) {
    groupItems.remove(item);
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
      userIdFromDb = data['id'];
      print(response.statusCode);
    } else {
      print(response.statusCode);
    }
  }
}



// Handle one Page of Items
@JsonSerializable(explicitToJson: true)
class GroupItemPage {

  GroupItemPage(){}

  List<ItemWithImages> groupItemList = [];
  List<ItemWithImages> get groupItems => groupItemList;

  CategoryItemPage(List<ItemWithImages> categoryItemList){
    this.groupItemList = categoryItemList;
  }
  factory GroupItemPage.fromJson(Map<String, dynamic> parsedJson) => _$GroupItemPageFromJson(parsedJson);
  Map<String, dynamic> toJson() => _$GroupItemPageToJson(this);
}