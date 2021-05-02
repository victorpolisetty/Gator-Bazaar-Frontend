import 'package:flutter/material.dart';
import 'package:student_shopping/shoppingCart/shoppingCartItemView.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red[600],
        title: Text("Favorites"),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {}),
        ],
      ),
      body: new Cart_products(),
      bottomNavigationBar: new Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(
              child: new ListTile(
                title: new Text("Total Amount: "),
                subtitle: new Text("\$230"),
              ),
            ),
            Expanded(
              child: new MaterialButton(
                  onPressed: () {},
                  child: new Text("Check Out",
                      style: TextStyle(color: Colors.white)),
                  color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
