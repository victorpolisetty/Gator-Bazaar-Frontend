import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:student_shopping_v1/models/categoryItemModel.dart';
import 'package:student_shopping_v1/searchBarClass.dart';
import 'itemDetailPage.dart';
import '../models/itemModel.dart';
import 'dart:typed_data';


class CategoryItemPage extends StatefulWidget {
  final int categoryId;
  CategoryItemPage(this.categoryId);

  @override
  _CategoryItemPageState createState() => new _CategoryItemPageState();
}

class _CategoryItemPageState extends State<CategoryItemPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late SearchBar searchBar;
  String keyword = "";

  ScrollController _controller = new ScrollController();
  bool isBottom = false;
  bool loading = false, allLoaded = false, isSearching = false;

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      leading: InkWell(
        onTap: (){
          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.black54,
        ),
        // child: Container(
        //   // margin: EdgeInsets.only(right: 10),
        //   // child: Icon(
        //   //   Icons.search,
        //   //   color: Colors.grey[800],
        //   //   size: 27,
        //   // ),
        // ),
      ),
      iconTheme: new IconThemeData(color: Colors.grey[800], size: 27),
      backgroundColor: Colors.grey[300],
      elevation: .1,
      title: Center(
        child: Text(
          'Student Shopping',
          style: TextStyle(color: Colors.black),
        ),
      ),

      actions: [
        searchBar.getSearchAction(context),
        Container(
          margin: EdgeInsets.only(right: 10),
          child: Icon(
            Icons.notifications,
            color: Colors.grey[800],
            size: 27,
          ),
        ),
      ],
    );
    return new AppBar(
        title: new Text('Student Shop'),
        actions: [searchBar.getSearchAction(context)]);
  }

  void onSubmitted(String value) {
    setState(() {
      var context = _scaffoldKey.currentContext;
      isSearching = true;
      Provider.of<CategoryItemModel>(context!, listen: false).getSearchedCategoryItems(widget.categoryId, value);
      keyword = value;
      if (context == null) {
        return;
      }

      ScaffoldMessenger.maybeOf(context);
    });
  }

  _CategoryItemPageState() {
    searchBar = new SearchBar(
        inBar: false,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onSubmitted: onSubmitted,
        onCleared: () {
          print("Search bar has been cleared");
        },
        onClosed: () {
          print("Search bar has been closed");
        });
  }

  mockFetch(CategoryItemModel categoryList) async{
    if(allLoaded){
      print("ALL LOADED");
      return;
    }
    setState(() {
      loading = true;
    });
    if(categoryList.currentPage != 0){
      loading = (await categoryList.initNextCatPage(categoryList.currentPage))!;
    }
    if(categoryList.currentPage <= categoryList.totalPages-1){
      categoryList.currentPage++;
    }
    if(loading == false){
      setState(() {
        allLoaded = categoryList.currentPage == categoryList.totalPages;
      });
    }


  }

  mockSearchFetch(CategoryItemModel categoryList, String keyword) async{
    if(allLoaded){
      print("ALL LOADED");
      return;
    }
    setState(() {
      loading = true;
    });
    if(categoryList.currentPage != 0){
      loading = (await categoryList.initSearchCat(categoryList.currentPage, keyword))!;
    }
    if(categoryList.currentPage <= categoryList.totalPages-1){
      categoryList.currentPage++;
    }
    if(loading == false){
      setState(() {
        allLoaded = categoryList.currentPage == categoryList.totalPages;
      });
    }


  }

  @override
  void initState() {
    super.initState();
    Provider.of<CategoryItemModel>(context, listen: false).getCategoryItems(widget.categoryId);
    _controller.addListener((){
      // reached bottom
      if (_controller.offset >= _controller.position.maxScrollExtent &&
          !_controller.position.outOfRange) {
        setState(() => isBottom = true);
      }

      // IS SCROLLING
      if (_controller.offset >= _controller.position.minScrollExtent &&
          _controller.offset < _controller.position.maxScrollExtent && !_controller.position.outOfRange) {
        setState(() {
          isBottom = false;
        });
      }

      // REACHED TOP
      if (_controller.offset <= _controller.position.minScrollExtent &&
          !_controller.position.outOfRange) {
        setState(() => isBottom = false);
      }
    });
  }

  @override
  void dispose(){
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var categoryList = context.watch<CategoryItemModel>();
    var totalPages = categoryList.totalPages;
    // while(categoryList.items.length == 0){
    //   return Container(
    //     color: Colors.white,
    //     width: MediaQuery.of(context).size.width,
    //     height: MediaQuery.of(context).size.height,
    //     child: spinkit,
    //   );
    // }
    return new WillPopScope(
      child: new Scaffold(
          appBar: searchBar.build(context),
          key: _scaffoldKey,
          body: new Center(
            child: Column(
              children: [
                Column(
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: 10),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height-190,
                        child: GridView.builder(
                            controller: _controller,
                            itemCount: categoryList.items.length == null ? 0 : categoryList.items.length,
                            physics: ScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 0,),
                            itemBuilder: (BuildContext context, int index) {
                              return singleItem(
                                  item: categoryList.items[index]
                              );
                            }
                        )
                    ),
                    if(loading)(spinkit),
                    (isBottom && !allLoaded && !loading && categoryList.totalPages != 1) ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                      ),
                      child: Center(
                        // child: Expanded(
                          child: Text("Show More")
                        //),
                      ),
                      onPressed: (){
                        setState(() {
                          if(categoryList.currentPage <= totalPages-1 && !loading && isSearching == false){
                            mockFetch(categoryList);
                          }
                          if(categoryList.currentPage <= totalPages-1 && !loading && isSearching == true){
                            mockSearchFetch(categoryList, keyword);
                          }
                          //recentList.getNextPage(1);
                        });
                      },
                    )
                        : Container(),
                  ],
                )
              ],
            ),
          )
      ),
      onWillPop: () async {
        categoryList.currentPage = 1;
        isSearching = false;
        return true;
      },
    );
  }
}

class singleItem extends StatelessWidget {
  ItemWithImages item;


  singleItem({
    required this.item,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => Navigator.of(context).push(new MaterialPageRoute(
              builder: (context) => new ItemDetails(
                  item
                //prod_picture ,
              ))),
          child: Container(
            margin: EdgeInsets.only(left: 15),
            width: 150,
            height: 100,
            alignment: Alignment.topRight,
            decoration: BoxDecoration(
                image: DecorationImage(image: MemoryImage(item.imageDataList[0]), fit: BoxFit.cover),
                color: Colors.white,
                borderRadius: BorderRadius.circular(18)),
          ),
        ),
        Row(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              width: 80,
              margin: EdgeInsets.only(top: 5, left: 30),
              height: 30,
              child: Text("\$${item.price}",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            ),
            item.isSold ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 60,
                height: 20,
                // color: Colors.black,
                child: Center(
                  child: Text(
                      "SOLD!"
                    // margin: EdgeInsets.all(8),
                    // color: Colors.blue,
                  ),
                ),
                color: Colors.green,
              ),
            ) : Expanded(child: Container()),
          ],
        ),
        Container(
          alignment: Alignment.topLeft,
          width: 150,
          margin: EdgeInsets.only(top: 5, left: 15),
          height: 40,
          child: Text("${item.name}",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}