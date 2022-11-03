import 'package:flutter/material.dart';

import '../buyerhome.dart';

class addedListingDialog extends StatefulWidget {
  final bool itemAddSuccess;

  addedListingDialog(this.itemAddSuccess);
  @override
  _addedListingDialogState createState() => _addedListingDialogState();
}

class _addedListingDialogState extends State<addedListingDialog> {
  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title:
        widget.itemAddSuccess ? Center(child: const Text('Item Added Successfully. Check your profile page to see your listing!')) : Center(child: const Text('Please select a category or enter required fields')),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        // children: <Widget>[
        //   Text("Hello"),
        // ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(new MaterialPageRoute(
            builder: (context) => new BuyerHomePage("Gator Marketplace")));
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Ok'),
        ),
      ],
    );
  }
}

bool showedDialog() {
  return true;
}