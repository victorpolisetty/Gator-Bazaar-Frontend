import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:student_shopping_v1/models/groupItemModel.dart';
import '../models/itemModel.dart';
import '../new/components/product_card.dart';
import '../new/screens/home/components/icon_btn_with_counter.dart';
import 'itemDetailPage.dart';
import 'package:provider/provider.dart';

class SpecificGroupPage extends StatefulWidget {
  const SpecificGroupPage({
    Key? key,
    required this.groupId,
    required this.groupName,
  }) : super(key: key);

  @override
  State<SpecificGroupPage> createState() => _SpecificGroupPageState();
  final int groupId;
  final String groupName;
}

class _SpecificGroupPageState extends State<SpecificGroupPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final PagingController<int, ItemWithImages> _pagingController =
  PagingController(firstPageKey: 0);
  int totalPages = 0;
  int _selectedCategoryId = 10;
  int resultOfCatSelected = 10;

  List<Map<String, dynamic>> categories1 = [

    {"icon": "assets/icons/misc.png", "text": "All Items", "pressNumber" : 10},
    {"icon": "assets/icons/clothes.png", "text": "Clothes", "pressNumber": 1},
    {"icon": "assets/icons/formal.png", "text": "Formal", "pressNumber": 2},
    {"icon": "assets/icons/ticket.png", "text": "Tickets", "pressNumber": 3},
    {"icon": "assets/icons/furniture.png", "text": "Furniture", "pressNumber": 4},
    {"icon": "assets/icons/sublease.png", "text": "Subleases", "pressNumber": 5},
    {"icon": "assets/icons/electronics.png", "text": "Electronics", "pressNumber": 6},
    {"icon": "assets/icons/open-book.png", "text": "Books", "pressNumber": 7},
    {"icon": "assets/all_items.png", "text": "Misc.", "pressNumber": 8},
    {"icon": "assets/icons/free.png", "text": "Free", "pressNumber": 9},
  ];

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey, widget.groupId, _selectedCategoryId);
    });
    super.initState();
  }
  Future<void> _fetchPage(int pageKey, int groupId, int resultOfCatSelected) async {
    try {
      Set<int> groupIds = {};
      groupIds.add(widget.groupId);
      await Provider.of<GroupItemModel>(context, listen: false).initNextCatPage(pageKey, groupIds, resultOfCatSelected);
      totalPages = Provider.of<GroupItemModel>(context, listen: false).totalPages;
      if(mounted) {
        final isLastPage = totalPages == 0 || (totalPages-1) == pageKey; // Check if totalPages is 0

        if (isLastPage) {
          _pagingController.appendLastPage(Provider.of<GroupItemModel>(context, listen: false).items);
        } else {
          final int? nextPageKey = pageKey + 1;
          _pagingController.appendPage(Provider.of<GroupItemModel>(context, listen: false).items, nextPageKey);
        }
      }
    } catch (error) {
      print('Error: $error'); // Add this line
      _pagingController.error = error;
    }
  }
  @override
  void dispose(){
    super.dispose();
    _pagingController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
          onWillPop: () async {
            return true;
          },
          child: new Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black,
                title: Center(
                  child: Text(
                    widget.groupName,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                actions: <Widget>[
                  GestureDetector(
                    onTap: () {
                      // Add your onTap functionality here
                      _showListViewDialog(context);
                    },
                    child: Image.asset(
                      "assets/icons/filter.png", // Provide the path to your .png icon
                      width: 24, // Set the desired width
                      height: 24, // Set the desired height
                      color: Colors.white, // Set the icon color
                    ),
                  )
                ],
              ),
              key: _scaffoldKey,
              body:
              Center(
                child: Container(
                  color: Color(0xFF333333),
                  child: new
                  PagedGridView(
                    pagingController: _pagingController,
                    builderDelegate: PagedChildBuilderDelegate<ItemWithImages>(
                        firstPageProgressIndicatorBuilder: (_) => Center(child: spinkit),
                        newPageProgressIndicatorBuilder: (_) => Center(child: spinkit),
                        noItemsFoundIndicatorBuilder: (_) => Center(child: Text("No Items Found.", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),)),
                        itemBuilder: (BuildContext context, item, int index) {
                          return ProductCard(
                            product: item,
                            uniqueIdentifier: "groupItem",
                          );
                        }
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: .7,
                      crossAxisCount: 2,
                      mainAxisSpacing: 0,),
                  ),
                ),
              )
            // ),
          ));
  }
// Define this in your state class
  void _showListViewDialog(BuildContext context) async {
    int? selected = await showDialog<int>(
      context: context,
      barrierDismissible: false, // Allows tapping outside to close the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Category'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * .58,
                child: ListView.builder(
                  itemCount: categories1.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: SizedBox(
                        width: 24, // You can adjust the size as needed.
                        child: Image.asset(categories1[index]['icon'], color: Colors.black,),
                      ),
                      title: Text(categories1[index]['text']),
                      trailing: Radio<int>(
                        activeColor: Colors.black,
                        value: categories1[index]['pressNumber'],
                        groupValue: _selectedCategoryId,
                        onChanged: (int? value) {
                          setState(() {
                            if (value != null) {
                              _selectedCategoryId = value;
                            }
                          });
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(_selectedCategoryId);
              },
              child: Text('Done', style: TextStyle(color: Colors.black),),
            ),
          ],
        );
      },
    );

    if (selected != null) {
      setState(() {
        _selectedCategoryId = selected;
        _pagingController.refresh();
        // _fetchPage(0, widget.groupId, _selectedCategoryId); // trigger new fetch
      });
    }
  }

}
