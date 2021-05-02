import 'package:flutter/material.dart';

class FavoriteWidget extends StatefulWidget {
  final product_name;
  final product_price;
  final product_picture;

  FavoriteWidget({
    this.product_name,
    this.product_price,
    this.product_picture,
  });

  @override
  _FavoriteWidgetState createState() =>
      _FavoriteWidgetState(product_name, product_price, product_picture);
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  bool _isFavorited = false;
  String product_name;
  String product_price;
  String product_picture;

  _FavoriteWidgetState(
      this.product_name, this.product_price, this.product_picture);

  void _toggleFavorite() {
    setState(() {
      if (_isFavorited) {
        _isFavorited = false;
      } else {
        _isFavorited = true;
        print(product_name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(1.0, 2.0, 10.0, 4.0),
        child: Container(
          child: new IconButton(
              icon: Icon(_isFavorited ? Icons.favorite : Icons.favorite_border),
              color: Colors.red,
              onPressed: () {
                _toggleFavorite();
              }),
        ));
  }
}
