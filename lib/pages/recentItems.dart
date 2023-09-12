import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:student_shopping_v1/pages/itemDetailPage.dart';
import 'package:student_shopping_v1/models/recentItemModel.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../models/itemModel.dart';



class RecentItems extends StatefulWidget {
  @override
  _RecentItemsState createState() => _RecentItemsState();
}

class _RecentItemsState extends State<RecentItems> {
  PagingController<int, ItemWithImages> _pagingController =
  PagingController(firstPageKey: 0);
  int totalPages = 0;


  @override
  void initState() {
      _pagingController.addPageRequestListener((pageKey) {
        _fetchPage(pageKey);
      });

    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
      await Provider.of<RecentItemModel>(context, listen: false).init1(pageKey);
      totalPages = Provider.of<RecentItemModel>(context, listen: false).totalPages;
      // if(mounted) {
        final isLastPage = (totalPages-1) == pageKey;
        if (isLastPage) {
          _pagingController.appendLastPage(Provider.of<RecentItemModel>(context, listen: false).items);
        } else {
          final int? nextPageKey = pageKey + 1;
          _pagingController.appendPage(Provider.of<RecentItemModel>(context, listen: false).items, nextPageKey);
        }
      // }
  }

  @override
  void dispose(){
    super.dispose();
    if(!mounted) _pagingController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // var recentList = context.watch<RecentItemModel>();
    // var totalPages = recentList.totalPages;
    return RefreshIndicator(
      onRefresh: () => Future.sync(() => _pagingController.refresh()),
      child: Column(
        children: [
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*.58,
                child: PagedGridView(
                  pagingController: _pagingController,
                  shrinkWrap: true,
                  builderDelegate: PagedChildBuilderDelegate<ItemWithImages>(
                    firstPageProgressIndicatorBuilder: (_) => Center(child: spinkit),
                    newPageProgressIndicatorBuilder: (_) => Center(child: spinkit),
                    itemBuilder: (BuildContext context, item, int index) {
                      return SingleItem(
                          item: item
                      );
                      // padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
                    },
                  ),
                  // controller: _controller,
                  // itemCount: recentList.items.length,

                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 0,),
                ),

            ),
        ],
      ),
    );
  }
}

class SingleItem extends StatelessWidget {
  final ItemWithImages item;

  SingleItem({
    required this.item
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          InkWell(
            onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => new ItemDetails(
                    context.watch<RecentItemModel>().currentUserId,
                    item
                ))),
            child: Container(
              margin: EdgeInsets.only(left: 15),
              width: 130,
              height: 130,
              alignment: Alignment.topRight,
              decoration: BoxDecoration(
                  image: DecorationImage(image: item.imageDataList.length > 0 ?
                  MemoryImage(item.imageDataList[0]) : AssetImage('assets/gb_placeholder.jpg') as ImageProvider, fit: BoxFit.contain),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18)),
              child: Container(
                margin: EdgeInsets.only(right: 10, top: 5),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                // color: Colors.black,
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
                  // color: Colors.black,
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
              // item.isSold ? Container(
              //
              //   // margin: EdgeInsets.only(left: 0, right:2, bottom: 0, top: 20),
              //   foregroundDecoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(30)),
              //     child: Text("Item Sold"),
              // ) : Container(),
            ],
          ),
          Container(
            alignment: Alignment.topLeft,
            width: MediaQuery.of(context).size.width * .59,
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0 , left: MediaQuery.of(context).size.width * .13),
            height: MediaQuery.of(context).size.height * .035,
            child: Text("${item.name}",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
