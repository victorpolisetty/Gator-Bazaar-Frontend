import 'package:flutter/material.dart';

class Cart_products extends StatefulWidget {
  @override
  _Cart_productsState createState() => _Cart_productsState();
}

class _Cart_productsState extends State<Cart_products> {


  var Products_in_cart = [
    {
      "name": "Blazer",
      "picture":"images/cats/a2.jpg",
      "old_price": 120,
      "price": 85,
      "size": "M",
      "color": "Red",
      "Qty.": 2,
    },
    {
      "name": "Shoe",
      "picture":"images/cats/a2.jpg",
      "old_price": 120,
      "price": 85,
      "size": "M",
      "color": "Red",
      "Qty.": 1,
    },

  ];

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: Products_in_cart.length,
        itemBuilder: (context, index){
          return Single_cart_product(
            cart_prod_name: Products_in_cart[index]["name"],
            cart_prod_color: Products_in_cart[index]["color"],
            cart_prod_qty: Products_in_cart[index]["Qty."],
            cart_prod_size: Products_in_cart[index]["size"],
            cart_prod_price: Products_in_cart[index]["price"],
            cart_prod_picture: Products_in_cart[index]["picture"],

          );
        });
  }
}
class Single_cart_product extends StatelessWidget {
  final cart_prod_name;
  final cart_prod_picture;
  final cart_prod_price;
  final cart_prod_size;
  final cart_prod_color;
  final cart_prod_qty;
  Single_cart_product({
    this.cart_prod_name,
    this.cart_prod_picture,
    this.cart_prod_size,
    this.cart_prod_price,
    this.cart_prod_color,
    this.cart_prod_qty,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        //=======LEADING SECTION=========
        leading: new Image.asset(cart_prod_picture,width: 80.0,height: 80.0,),
        //============TITLE SECTION============
        title: new Text(cart_prod_name),
        //SUBTITLE SECTION=============
        subtitle: new Column(
          children: <Widget>[
            // ROW INSIDE THE COLUMN
            new Row(
              children: <Widget>[
//          THIS SECTION IS FOR THE SIZE OF THE PRODUCT
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: new Text("Size:"),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: new Text(cart_prod_size, style: TextStyle(color:Colors.red),),
                ),
//              =============This section is for the product color==============
                new Padding(padding: const EdgeInsets.fromLTRB(10.0, 8.0, 8.0, 8.0),
                  child: new Text("Color:"),),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: new Text(cart_prod_color, style: TextStyle(color:Colors.red),),
                ),
                new Padding(padding: const EdgeInsets.fromLTRB(10.0, 8.0, 8.0, 8.0),
                  child: new Text("Price:"),),
                Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: new Text("\$$cart_prod_price", style:TextStyle(color: Colors.red),)
                ),
              ],
            ),
//        ===============THIS SECTION IS FOR THE PRODUCT PRICE ====================

          ],
        ),
      ),
    );
  }
}
