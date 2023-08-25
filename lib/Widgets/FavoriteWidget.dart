
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:student_shopping_v1/models/favoriteModel.dart';
import 'package:provider/provider.dart';
import 'package:student_shopping_v1/models/itemModel.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import '../api_utils.dart';
import '../new/constants.dart';
import '../new/size_config.dart';

class FavoriteWidget extends StatefulWidget {
  final item;

  FavoriteWidget({
    this.item,
  });

  @override
  _FavoriteWidgetState createState() =>
      _FavoriteWidgetState(item);
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  ItemWithImages item;

  _FavoriteWidgetState(this.item);

  void _toggleFavorite(var isInFavoritesList, ItemWithImages item) {

    setState(() {
        var favoriteList = context.read<FavoriteModel>();

        if(!isInFavoritesList){
          Future.wait([addUserFavoriteToDb()]).then((value) => favoriteList.add(item));
        } else {
          Future.wait([deleteUserFavoriteFromDb()]).then((value) => favoriteList.remove(item));
        }
      isInFavoritesList ? isInFavoritesList = false : isInFavoritesList = true;
    });
  }

  bool inFavorites(var favorite, ItemWithImages item){
    bool isFavorite = favorite.items.contains(item);
    return isFavorite;
  }
  @override
  Widget build(BuildContext context) {
    var isInFavoritesList = context.select<FavoriteModel, bool>(
          (favorite) => inFavorites(favorite, item),
    );

    return InkWell(
      borderRadius: BorderRadius.circular(50.sp), // Use sizer to set the borderRadius
      onTap: () {
        _toggleFavorite(isInFavoritesList, item);
      },
      child: Container(
        padding: EdgeInsets.all(8.sp), // Use sizer to set padding
        height: 28.sp, // Use sizer to set height
        width: 28.sp, // Use sizer to set width
        decoration: BoxDecoration(
          color: isInFavoritesList
              ? kPrimaryColor.withOpacity(0.15)
              : kSecondaryColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          "assets/icons/Heart Icon_2.svg",
          color: isInFavoritesList
              ? Color(0xFFFF4848)
              : Color(0xFFDBDEE4),
        ),
      ),
    );
  }

  Future<void> addUserFavoriteToDb()  async {
    Map<String, dynamic> data;
    String firebaseId = currentUser!.uid;
    String itemId = item.id.toString();
    var url = ApiUtils.buildApiUrl('/profiles/$firebaseId/favorites/$itemId');
    final http.Response response =  await http.post(url
        , headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        }
    );

    if (response.statusCode == 200) {
    } else {
      print(response.statusCode);
    }
  }

  Future<void> deleteUserFavoriteFromDb()  async {
    Map<String, dynamic> data;
    String firebaseId = currentUser!.uid;
    String itemId = item.id.toString();
    var url = ApiUtils.buildApiUrl('/profiles/$firebaseId/favorites/$itemId');
    // var tmpObj =  json.encode(itm.toJson());
    final http.Response response =  await http.delete(url
        , headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        }
    );
    if (response.statusCode == 200) {
    } else {
      print(response.statusCode);
    }
    //  });
  }
}
