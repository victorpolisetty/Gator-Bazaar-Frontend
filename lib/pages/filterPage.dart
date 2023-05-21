import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  String? _selectedCategory;
  final List<String> _categories = ['Category 1', 'Category 2', 'Category 3'];

  Map<String, bool> _groups = {
    'Group 1': false,
    'Group 2': false,
    'Group 3': false,
    'Group 4': false,
    'Group 5': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter Page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Select Category', style: Theme.of(context).textTheme.headline6),
              DropdownButton<String>(
                isExpanded: true,
                hint: Text('Select Category'),
                value: _selectedCategory,
                items: _categories.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
              ),
              SizedBox(height: 24.0),
              Text('Select Groups', style: Theme.of(context).textTheme.headline6),
              Column(
                children: _groups.keys.map((String key) {
                  return CheckboxListTile(
                    title: Text(key),
                    value: _groups[key],
                    onChanged: (bool? value) {
                      setState(() {
                        _groups[key] = value!;
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}