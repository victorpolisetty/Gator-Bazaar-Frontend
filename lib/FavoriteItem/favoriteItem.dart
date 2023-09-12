import 'package:flutter/material.dart';
import 'favoriteItemBuilder.dart';

class FavoriteItem extends StatefulWidget {
  final itemName;
  final itemPrice;
  final itemPicture;
  final itemDesc;
  final itemCategoryId;

  FavoriteItem({
    this.itemName,
    this.itemPrice,
    this.itemPicture,
    this.itemDesc,
    this.itemCategoryId,
  });
  @override
  _FavoriteItemState createState() => _FavoriteItemState();
}

class _FavoriteItemState extends State<FavoriteItem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF333333),
      body: new FavoriteItems(
        itemName: widget.itemName,
        itemPrice: widget.itemPrice,
        itemPicture: widget.itemPicture,
        itemDesc: widget.itemDesc,
        itemCategoryId: widget.itemCategoryId,
      ),
    );
  }
}
