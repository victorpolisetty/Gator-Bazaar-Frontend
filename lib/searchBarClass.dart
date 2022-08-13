import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

class searchBarClass extends StatefulWidget {
  @override
  _searchBarClassState createState() => _searchBarClassState();
}

class _searchBarClassState extends State<searchBarClass> {
  late SearchBar searchBar;
  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: new Text('My Home Page'),
        actions: [searchBar.getSearchAction(context)]
    );
  }

  _searchBarClassState() {
    searchBar = new SearchBar(
        inBar: false,
        setState: setState,
        onSubmitted: print,
        buildDefaultAppBar: buildAppBar
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        // searchBar.build(context)
    );
  }
}