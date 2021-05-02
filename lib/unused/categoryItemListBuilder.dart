import 'package:flutter/material.dart';
import 'package:student_shopping/pages/itemDescription.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:student_shopping/platformSupport.dart';

class categoryItemsList extends StatefulWidget {
  int categoryId = 0;
  categoryItemsList(int categoryId) {
    this.categoryId = categoryId;
  }
  @override
  _categoryDetailsStateNew createState() => _categoryDetailsStateNew();
}

class _categoryDetailsStateNew extends State<categoryItemsList> {
  List data;
  Future<String> getData() async {
    var hosturi = PlatformSupport().getLocalhost();
    var url = Uri.parse('${hosturi}:8080/item/categoryid?id=${widget.categoryId}');
    http.Response response = await http.get(url, headers: {"Accept": "application/json"});
    this.setState(() {});

    data = jsonDecode(response.body) as List;
  }

  @override
  void initState() {
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: data == null ? 0 : data.length,
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Single_prodz(
                prod_name: data[index]['name'],
                prod_picture: data[index]['imageURL'],
                prod_price: data[index]['price'],
                prod_description: data[index]['description'],
                prod_categoryId: data[index]['id']),
          );
        });
  }
}

class Single_prodz extends StatelessWidget {
  final prod_name;
  final prod_picture;
  final prod_price;
  final prod_description;
  final prod_categoryId;

  Single_prodz({
    this.prod_name,
    this.prod_picture,
    this.prod_price,
    this.prod_description,
    this.prod_categoryId,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Hero(
        tag: new Text("hero 1"),
        child: Material(
            child: InkWell(
          onTap: () => Navigator.of(context).push(new MaterialPageRoute(
              builder: (context) => new ProductDetails(
                    product_detail_name: prod_name,
                    product_detail_new_price: prod_price,
                    product_detail_picture: prod_picture,
                    product_detail_description: prod_description,
                    product_categoryId: prod_categoryId,
                    //prod_picture ,
                  ))),
          child: GridTile(
              footer: Container(
                color: Colors.white,
                child: new Row(
                  children: <Widget>[
                    Expanded(
                        child: new Text(
                      prod_name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    )),
                    new Text(
                      "\$$prod_price",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              child: Image.network(
                prod_picture,
                fit: BoxFit.cover,
              )),
        )),
      ),
    );
  }
}
