import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../buyerhome.dart';
import '../models/recentItemModel.dart';

class addedListingDialog extends StatefulWidget {
  final bool itemAddSuccess;

  addedListingDialog(this.itemAddSuccess);
  @override
  _addedListingDialogState createState() => _addedListingDialogState();
}

class _addedListingDialogState extends State<addedListingDialog> {
  @override
  Widget build(BuildContext context) {
    //WillPopScope makes it so cant swipe back
    return WillPopScope(
      onWillPop: () async => false,
      child: new AlertDialog(
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
            },
            textColor: Theme.of(context).primaryColor,
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }
}

bool showedDialog() {
  return true;
}