import 'package:flutter/material.dart';
import 'package:student_shopping/pages/itemDescription.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Products extends StatefulWidget {
  @override
  _categoryDetailsStateNew createState() => _categoryDetailsStateNew();
}

class _categoryDetailsStateNew extends State<Products> {
  List data;
  Future<String> getData() async {
    var url = Uri.parse('http://localhost:8080/items/');
    http.Response response =
        await http.get(url,
            //Uri.encodeFull("http://localhost:8080/items/"),
            headers: {"Accept": "application/json"});
    this.setState(() {});

    data = jsonDecode(response.body) as List;
  }

  @override
  void initState() {
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 10),
        width: MediaQuery.of(context).size.width,
        height: 280,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: data == null ? 0 : data.length,
            itemBuilder: (BuildContext context, int index) {
              // padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
              return Single_prodz(
                  prod_name: data[index]['name'],
                  prod_picture: data[index]['imageURL'],
                  prod_price: data[index]['price'],
                  prod_description: data[index]['description'],
                  prod_categoryId: data[index]['id']);
            }));
    return ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
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
    return Column(
      children: [
        InkWell(
          onTap: () => Navigator.of(context).push(new MaterialPageRoute(
              builder: (context) => new ProductDetails(
                    product_detail_name: prod_name,
                    product_detail_new_price: prod_price,
                    product_detail_picture: prod_picture,
                    product_detail_description: prod_description,
                    product_categoryId: prod_categoryId,
                    //prod_picture ,
                  ))),
          child: Container(
            margin: EdgeInsets.only(left: 15),
            width: 150,
            height: 200,
            alignment: Alignment.topRight,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(prod_picture), fit: BoxFit.cover),
                color: Colors.white,
                borderRadius: BorderRadius.circular(18)),
            child: Container(
              margin: EdgeInsets.only(right: 10, top: 10),
              child: Icon(
                Icons.favorite_border,
                size: 26,
                color: Colors.grey[500],
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          width: 150,
          margin: EdgeInsets.only(top: 5, left: 15),
          height: 30,
          child: Text("\$${prod_price}",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
        ),
        Container(
          alignment: Alignment.topLeft,
          width: 150,
          margin: EdgeInsets.only(top: 5, left: 15),
          height: 40,
          child: Text("${prod_name}",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ),
      ],
    );
    // return Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: <Widget>[
    //       InkWell(
    //         onTap: () => Navigator.of(context).push(new MaterialPageRoute(
    //             builder: (context) => new ProductDetails(
    //                   product_detail_name: prod_name,
    //                   product_detail_new_price: prod_price,
    //                   product_detail_picture: prod_picture,
    //                   product_detail_description: prod_description,
    //                   product_categoryId: prod_categoryId,
    //                   //prod_picture ,
    //                 ))),
    //         child: Padding(
    //           padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
    //           child: Container(
    //               height: 200.0,
    //               decoration: BoxDecoration(
    //                   borderRadius: BorderRadius.circular(15.0),
    //                   image: DecorationImage(
    //                       image: NetworkImage(prod_picture),
    //                       fit: BoxFit.cover))),
    //         ),
    //       ),
    //       Padding(
    //         padding: EdgeInsets.only(
    //             left: 25.0, right: 25.0, top: 10.0, bottom: 15.0),
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: <Widget>[
    //             Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: <Widget>[
    //                 Text(
    //                   prod_name,
    //                   style: TextStyle(
    //                       fontWeight: FontWeight.bold,
    //                       fontFamily: 'Montserrat',
    //                       fontSize: 15.0),
    //                 ),
    //                 SizedBox(height: 7.0),
    //                 Row(
    //                   children: <Widget>[
    //                     Text(
    //                       'John Smith',
    //                       style: TextStyle(
    //                           color: Colors.grey.shade700,
    //                           fontFamily: 'Montserrat',
    //                           fontSize: 11.0),
    //                     ),
    //                     SizedBox(width: 4.0),
    //                     Icon(
    //                       Icons.timer,
    //                       size: 4.0,
    //                       color: Colors.black,
    //                     ),
    //                     SizedBox(width: 4.0),
    //                     Text(
    //                       'University of Florida',
    //                       style: TextStyle(
    //                           color: Colors.grey.shade500,
    //                           fontFamily: 'Montserrat',
    //                           fontSize: 11.0),
    //                     )
    //                   ],
    //                 )
    //               ],
    //             ),
    //             Row(
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children: <Widget>[
    //                 SizedBox(width: 7.0),
    //                 InkWell(
    //                   onTap: () {},
    //                   child: Container(
    //                     height: 20.0,
    //                     width: 20.0,
    //                     child: Text("\$$prod_price"),
    //                   ),
    //                 ),
    //                 SizedBox(width: 7.0),
    //                 InkWell(
    //                   onTap: () {},
    //                   child: Container(
    //                     height: 20.0,
    //                     width: 20.0,
    //                     child: Image.network(
    //                         'https://github.com/rajayogan/flutterui-minimalprofilepage/blob/master/assets/navarrow.png?raw=true'),
    //                   ),
    //                 ),
    //                 SizedBox(width: 7.0),
    //                 InkWell(
    //                   onTap: () {},
    //                   child: Container(
    //                     height: 20.0,
    //                     width: 20.0,
    //                     child: Image.network(
    //                         'https://github.com/rajayogan/flutterui-minimalprofilepage/blob/master/assets/speechbubble.png?raw=true'),
    //                   ),
    //                 ),
    //                 SizedBox(width: 7.0),
    //                 InkWell(
    //                   onTap: () {},
    //                   child: Container(
    //                     height: 22.0,
    //                     width: 22.0,
    //                     child: Image.network(
    //                         'https://github.com/rajayogan/flutterui-minimalprofilepage/blob/master/assets/fav.png?raw=true'),
    //                   ),
    //                 )
    //               ],
    //             )
    //           ],
    //         ),
    //       )
    //     ]);
    // return Card(
    //   child: Hero(
    //     tag: new Text("hero 1"),
    //     child: Material(
    //         child: InkWell(
    //       onTap: () => Navigator.of(context).push(new MaterialPageRoute(
    //           builder: (context) => new ProductDetails(
    //                 product_detail_name: prod_name,
    //                 product_detail_new_price: prod_price,
    //                 product_detail_picture: prod_picture,
    //                 product_detail_description: prod_description,
    //                 product_categoryId: prod_categoryId,
    //                 //prod_picture ,
    //               ))),
    //       child: GridTile(
    //           footer: Container(
    //             color: Colors.white,
    //             child: new Row(
    //               children: <Widget>[
    //                 Expanded(
    //                     child: new Text(
    //                   prod_name,
    //                   style: TextStyle(
    //                       fontWeight: FontWeight.bold, fontSize: 16.0),
    //                 )),
    //                 new Text(
    //                   "\$$prod_price",
    //                   style: TextStyle(
    //                       color: Colors.red, fontWeight: FontWeight.bold),
    //                 )
    //               ],
    //             ),
    //           ),
    //           child: Image.network(
    //             prod_picture,
    //             fit: BoxFit.cover,
    //           )),
    //     )),
    //   ),
    // );
  }
}
