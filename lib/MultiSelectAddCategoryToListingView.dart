import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class MultiSelectAddCategoryToListingView extends StatefulWidget {
  final int? categoryId;
  final String? categoryName;
  final String uniqueIdentifier;
  final ValueChanged<int?> onCheckboxChanged;
  final Set<int?> selectedGroupIds;

  const MultiSelectAddCategoryToListingView({
    Key? key,
    required this.categoryName,
    required this.uniqueIdentifier,
    required this.categoryId,
    required this.onCheckboxChanged,
    required this.selectedGroupIds,
  }) : super(key: key);

  @override
  State<MultiSelectAddCategoryToListingView> createState() =>
      _MultiSelectAddCategoryToListingViewState();
}

class _MultiSelectAddCategoryToListingViewState
    extends State<MultiSelectAddCategoryToListingView> {
  @override
  Widget build(BuildContext context) {
    bool isChecked = widget.selectedGroupIds.contains(widget.categoryId);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Text(widget.categoryName!, style: TextStyle(color: Colors.black)),
          ),
          Checkbox(
            value: isChecked,
            onChanged: (bool? value) {
              setState(() {
                if (value == true) {
                  widget.onCheckboxChanged(widget.categoryId);
                } else {
                  widget.onCheckboxChanged(null);
                }
              });
            },
          ),
        ],
      ),
    );
  }
}