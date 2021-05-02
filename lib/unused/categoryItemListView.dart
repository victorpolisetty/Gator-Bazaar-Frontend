import 'package:flutter/material.dart';
import 'categoryItemListBuilder.dart';

class categoryDetails extends StatefulWidget {
  final int category_id;
  final String category_name;

  const categoryDetails({Key key, this.category_id, this.category_name})
      : super(key: key);

  @override
  _categoryDetailsState createState() => _categoryDetailsState();
}

class _categoryDetailsState extends State<categoryDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          elevation: 0.1,
          backgroundColor: Colors.red[600],
          title: Text(widget.category_name),
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
        body: new Column(
          children: <Widget>[
            new Flexible(child: categoryItemsList(widget.category_id))
          ],
        ));
  }
}
