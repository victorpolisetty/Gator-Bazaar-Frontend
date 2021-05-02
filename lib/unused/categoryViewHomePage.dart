import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io' as Io;
import 'package:student_shopping/platformSupport.dart';
import 'categoryItemListView.dart';

class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  List data;
  Future<String> getData() async {
    var hosturi = PlatformSupport().getLocalhost();
    var url = Uri.parse('${hosturi}:8080/categories/');
    http.Response response =
        await http.get(url, headers: {"Accept": "application/json"});
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
      height: 80.0,
      child: ListView.builder(
          itemCount: data == null ? 0 : data.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return Row(
              children: <Widget>[
                Category(
                  image_location: data[index]['image'],
                  image_caption: data[index]['name'],
                  category_Id: data[index]['id'],
                ),
              ],
            );
          }),
    );
  }
}

class Category extends StatelessWidget {
  final String image_location;
  final String image_caption;
  final int category_Id;

  Category({
    this.image_caption,
    this.image_location,
    this.category_Id,
  });
  @override
  Widget build(BuildContext context) {
    var converted = Image.memory(Base64Decoder().convert(image_location));

    return Padding(
      padding: const EdgeInsets.fromLTRB(2.0, 2.0, 6.0, 5.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (context) => new categoryDetails(
                    category_id: category_Id,
                    category_name: image_caption,
                  )));
        },
        child: Container(
          width: 90.0,
          child: ListTile(
            title: converted,
            subtitle: Container(
                alignment: Alignment.topCenter,
                child: Text(
                  image_caption,
                  style: TextStyle(
                    fontSize: 10.0,
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
