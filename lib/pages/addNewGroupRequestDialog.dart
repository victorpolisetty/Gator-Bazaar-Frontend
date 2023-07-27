import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../buyerhome.dart';
import '../models/recentItemModel.dart';

class addNewGroupRequestDialog extends StatefulWidget {
  final bool itemAddSuccess;

  addNewGroupRequestDialog(this.itemAddSuccess);
  @override
  _addNewGroupRequestDialogState createState() => _addNewGroupRequestDialogState();
}

class _addNewGroupRequestDialogState extends State<addNewGroupRequestDialog> {
  @override
  Widget build(BuildContext context) {
    //WillPopScope makes it so cant swipe back
    return WillPopScope(
      onWillPop: () async => false,
      child: new AlertDialog(
        title:
        widget.itemAddSuccess ? Center(child: const Text('Group request added successfully! This request will be reviewed in 24-48 hours.')) :
        Center(child: const Text('Please enter the information for all fields.')),
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
              if(widget.itemAddSuccess) {
                Provider.of<RecentItemModel>(context, listen: false).getRecentItems();
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) =>
                    new BuyerHomePage("Gator Marketplace")));
              }
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