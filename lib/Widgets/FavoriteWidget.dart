
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:student_shopping_v1/models/favoriteModel.dart';
import 'package:provider/provider.dart';
import 'package:student_shopping_v1/models/itemModel.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

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
    // var itm = new ItemWithImages.FavoriteItem(item.id!,item.name,item.price,item.description,item.imageDataList[0]);


    var isInFavoritesList = context.select<FavoriteModel, bool>(
          (favorite) => inFavorites(favorite, item)
    );
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: () {

        _toggleFavorite(isInFavoritesList, item);
        isInFavoritesList = !isInFavoritesList;
      },
      child: Container(
        padding: EdgeInsets.all(getProportionateScreenWidth(8)),
        height: getProportionateScreenWidth(28),
        width: getProportionateScreenWidth(28),
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
    // return Padding(
    //     padding: const EdgeInsets.fromLTRB(1.0, 2.0, 10.0, 4.0),
    //     child: Container(
    //       child: new IconButton(
    //         iconSize: 40,
    //           icon: Icon(isInFavoritesList ? Icons.favorite : Icons.favorite_border),
    //           color: Colors.black,
    //           onPressed: () {
    //             _toggleFavorite(isInFavoritesList, item);
    //           }),
    //     ));
  }
  Future<void> addUserFavoriteToDb()  async {
    Map<String, dynamic> data;
    String firebaseId = currentUser!.uid;
    String itemId = item.id.toString();
    var url = Uri.parse('http://Gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/profiles/$firebaseId/favorites/$itemId');
    // var tmpObj =  json.encode(itm.toJson());
    final http.Response response =  await http.post(url
        , headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        }
        // , body: tmpObj
    );

    //  .then((response) {
    if (response.statusCode == 200) {
      print(response.statusCode);
    } else {
      print(response.statusCode);
    }
    //  });
  }

  Future<void> deleteUserFavoriteFromDb()  async {
    Map<String, dynamic> data;
    String firebaseId = currentUser!.uid;
    String itemId = item.id.toString();
    var url = Uri.parse('http://Gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/profiles/$firebaseId/favorites/$itemId');
    // var tmpObj =  json.encode(itm.toJson());
    final http.Response response =  await http.delete(url
        , headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        }
      // , body: tmpObj
    );

    //  .then((response) {
    if (response.statusCode == 200) {
      // data = jsonDecode(response.body);
      // itm.id = data['id'];
      //   return itm;
      print(response.statusCode);
    } else {
      print(response.statusCode);
    }
    //  });
  }
}
