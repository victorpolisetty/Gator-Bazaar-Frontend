import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;
part 'categoryModel.g.dart';



@JsonSerializable()
class Category extends ChangeNotifier {
  int? id = -1;
  String? name = "";
  String? description = "";
  @JsonKey(ignore: true)
  Uint8List? imageURL = new Uint8List(0);



  Category(){}


  factory Category.fromJson(Map<String, dynamic> parsedJson) => _$CategoryFromJson(parsedJson);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}

class CategoryModel extends ChangeNotifier{
  /// Internal, private state of the cart. Stores the ids of each item.
  List<Category> categoryList = [];
  /// List of items in the cart.
  List<Category> get category => categoryList;

  CategoryModel() {
    // var initFuture = init();
    // initFuture.then((voidValue) {
    //   // state = HomeScreenModelState.initialized;
    //   notifyListeners();
    // });
  }

  Future<void> _getChatHomeHelper() async {
    // await getProfileFromDb(currentUser!.uid);
    categoryList.clear();
    await getCategories();
    await getImageForCategory();
    notifyListeners();

  }

  void getChatHomeHelper() {
    // categoryList.clear();
    var initFuture = _getChatHomeHelper();
    initFuture.then((voidValue) {
      // state = HomeScreenModelState.initialized;
      notifyListeners();
    });
  }



  //TODO
  Future<void> getCategories() async {
    // String firebaseId = currentUser!.uid;
    Map<String, dynamic> data;
    var url = Uri.parse('http://Gatorbazaarbackendtested2-env.eba-g27rcqgs.us-east-1.elasticbeanstalk.com/categories');
    http.Response response = await http.get(url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      // data.map<Item>((json) => Item.fromJson(json)).toList();
      print(response.body);
      data = jsonDecode(response.body);
      // categoryImage = response.bodyBytes;
      var categories = data['content'];
      for (int i = 0; i < categories.length; i++) {
        Category category = Category.fromJson(categories[i]);
        categoryList.add(category);
        // print(categoryList);
      }
    } else {
      print (response.statusCode);
    }
  }

  Future<void> getImageForCategory() async {
    Uint8List data = new Uint8List(0);
    int? categoryId = -1;
    for (int i = 0; i < categoryList.length; i++) {
        categoryId = categoryList[i].id;
        String urlString = "http://Gatorbazaarbackendtested2-env.eba-g27rcqgs.us-east-1.elasticbeanstalk.com/categoryImage/$categoryId";
        var url = Uri.parse(urlString);
        http.Response response = await http.get(
            url, headers: {"Accept": "application/json"});
        if (response.statusCode == 200) {
          data = response.bodyBytes;
          categoryList[i].imageURL = data;
          // print(categoryList[i].imageURL);
        } else {
          print (response.statusCode);
        }
      //  else { // Add default - no image
      //   data = (await rootBundle.load(
      //       'assets/images/no-picture-available-icon.png'))
      //       .buffer
      //       .asUint8List();
      // }
    }
  }

}

toNull(_) => null;