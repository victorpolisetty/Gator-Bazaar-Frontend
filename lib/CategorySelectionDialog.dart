import 'package:flutter/material.dart';

import 'custom_radio_tile.dart';

// Define these variables at the beginning of your Dart file.
Map<String, int?> categoryList = {
  "Select": -1,
  "Clothes": 1,
  "Formal": 2,
  "Tickets": 3,
  "Furniture": 4,
  "Subleases": 5,
  "Electronics": 6,
  "Books": 7,
  "Misc.": 8,
};

int? _selectedCategory = categoryList["Select"];

class CategorySelectionDialog extends StatefulWidget {
  final Map<String, int?> categoryList;
  final int? initialSelectedCategory;

  CategorySelectionDialog({
    required this.categoryList,
    required this.initialSelectedCategory,
  });

  @override
  _CategorySelectionDialogState createState() =>
      _CategorySelectionDialogState();
}

class _CategorySelectionDialogState extends State<CategorySelectionDialog> {
  int? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialSelectedCategory;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Category'),
      content: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.58,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.categoryList.length,
          itemBuilder: (BuildContext context, int index) {
            String category = widget.categoryList.keys.elementAt(index);
            int? categoryId = widget.categoryList.values.elementAt(index);

            return CustomRadioListTile<int?>(
              title: category,
              value: categoryId,
              groupValue: _selectedCategory,
              onChanged: (int? value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
              isSelected: _selectedCategory == categoryId,
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(_selectedCategory);
          },
          child: Text('Done', style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }
  void _showCategorySelectionDialog(BuildContext context) async {
    int? selectedCategory = await showDialog<int?>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CategorySelectionDialog(
          categoryList: categoryList, // Pass the categoryList here
          initialSelectedCategory: _selectedCategory, // Pass the initial selected category here
        );
      },
    );

    if (selectedCategory != null) {
      setState(() {
        _selectedCategory = selectedCategory;
      });
    }
  }
}



