import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:student_shopping_v1/models/categoryItemModel.dart';
import '../models/favoriteModel.dart';
import '../new/components/product_card.dart';
import 'itemDetailPage.dart';
import '../models/itemModel.dart';


class CategoryItemPage extends StatefulWidget {
  final int categoryId;
  final String categoryName;
  CategoryItemPage(this.categoryId, this.categoryName);

  @override
  _CategoryItemPageState createState() => new _CategoryItemPageState();
}

class _CategoryItemPageState extends State<CategoryItemPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late SearchBar searchBar;
  String keyword = "";

  bool isBottom = false;
  bool loading = false, allLoaded = false, isSearching = false;

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      // systemOverlayStyle: SystemUiOverlayStyle.dark,
      // backgroundColor: Colors.black,
      // iconTheme: IconThemeData(color: Colors.white), // Set the color of the back arrow

      leading: InkWell(
        onTap: (){
          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
      ),
      elevation: .1,
      title:
        Text(
          widget.categoryName,
          style: TextStyle(color: Colors.white),
        ),


      actions: [
      ],
    );
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

  final PagingController<int, ItemWithImages> _pagingController =
  PagingController(firstPageKey: 0);
  int totalPages = 0;

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey, widget.categoryId);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey, int categoryId) async {
    try {
      await Provider.of<FavoriteModel>(context, listen: false)
          .getItemRestList();
      await Provider.of<CategoryItemModel>(context, listen: false).initNextCatPage(pageKey, categoryId);
      totalPages = Provider.of<CategoryItemModel>(context, listen: false).totalPages;
      if(mounted) {
        final isLastPage = (totalPages-1) == pageKey;

        if (isLastPage) {
          _pagingController.appendLastPage(Provider.of<CategoryItemModel>(context, listen: false).items);
        } else {
          final int? nextPageKey = pageKey + 1;
          _pagingController.appendPage(Provider.of<CategoryItemModel>(context, listen: false).items, nextPageKey);
        }
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void dispose(){
    super.dispose();
    _pagingController.dispose();
    // _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var categoryList = context.watch<CategoryItemModel>();
    // var totalPages = categoryList.totalPages;
    return WillPopScope(
        onWillPop: () async {
            return true;
        },
        child: new Scaffold(
            appBar: searchBar.build(context),
            key: _scaffoldKey,
            body:
    // RefreshIndicator(
    //           onRefresh: () => Future.sync(() => _pagingController.refresh()),
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
                                      uniqueIdentifier: "categoryItem",
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
}

class singleItem extends StatelessWidget {
  final ItemWithImages item;
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
                  context.watch<CategoryItemModel>().userIdFromDb,
                  item
                //prod_picture ,
              ))),
          child: Container(
            margin: EdgeInsets.only(left: 15),
            width: 130,
            height: 130,
            alignment: Alignment.topRight,
            decoration: BoxDecoration(
                image: DecorationImage(image: MemoryImage(item.imageDataList[0]), fit: BoxFit.contain),
                color: Colors.white,
                borderRadius: BorderRadius.circular(18)),
          ),
        ),
        Row(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width * .19999,
              margin: EdgeInsets.only(top: 0, left: MediaQuery.of(context).size.width * .12),
              height: MediaQuery.of(context).size.height * .035,
              child: Text((' \$${NumberFormat('#,##0.00', 'en_US').format(item.price)}'),
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            ),
            item.isSold! ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: MediaQuery.of(context).size.width * .10,
                height: MediaQuery.of(context).size.height * .02,
                margin: EdgeInsets.only(top: 0, left: MediaQuery.of(context).size.width * .0001),
                child: Center(
                  child: Text(
                      "SOLD!",
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
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
          width: MediaQuery.of(context).size.width * .59,
          margin: EdgeInsets.only(top: 0, left: MediaQuery.of(context).size.width * .13),
          height: MediaQuery.of(context).size.height * .035,
          child: Text("${item.name}",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}