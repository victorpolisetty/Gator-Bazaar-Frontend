import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_shopping_v1/pages/itemDetailPage.dart';
import 'package:student_shopping_v1/models/recentItemModel.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../models/itemModel.dart';



class RecentItems extends StatefulWidget {
  @override
  _RecentItemsState createState() => _RecentItemsState();
}

class _RecentItemsState extends State<RecentItems> {
  ScrollController _controller = new ScrollController();
  bool isBottom = false;
  bool loading = false, allLoaded = false;
  //var recentList = RecentItemModel();

  mockFetch(RecentItemModel recentList) async{
    if(allLoaded){
      print("ALL LOADED");
      return;
    }
    setState(() {
      loading = true;
    });
    if(recentList.currentPage != 0){
      await recentList.init1(recentList.currentPage);
    }
    if(recentList.currentPage <= recentList.totalPages-1){
      recentList.currentPage++;
    }

    setState(() {
      loading = false;
      allLoaded = recentList.currentPage == recentList.totalPages;
    });
  }

  @override
  void initState() {
    super.initState();
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
        setState(() {
          isBottom = false;
        });
      }
    });
    Provider.of<RecentItemModel>(context, listen: false);
  }
  @override
  void dispose(){
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var recentList = context.watch<RecentItemModel>();
    var totalPages = recentList.totalPages;
    while(recentList.items.length == 0){
      return Container(
        margin: EdgeInsets.only(top: 10),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height-407,
        child: spinkit,
      );
    }
    return Column(
      children: [
        Container(
            // margin: EdgeInsets.only(top: 10),
            width: MediaQuery.of(context).size.width,
            // height: double.,
            height: MediaQuery.of(context).size.height - 452,
            child: recentList.items.length > 0 ? Container(
              height: double.infinity,
              width: double.infinity,
              child: GridView.builder(
                  controller: _controller,
                  itemCount: recentList.items.length,
                  itemBuilder: (BuildContext context, int index) {
                      return SingleItem(
                          item: recentList.items[index]
                      );
                    // padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 0,),
                ),
            ) : Container(
              height: double.infinity,
              width: double.infinity,
              child: GridView.builder(
                controller: _controller,
                itemCount: recentList.items.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container();
                  // padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 0,),
              ),
            ),
        ),
        if(loading)(spinkit),
        (isBottom && !allLoaded && !loading) ? ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.black
          ),
          child: Center(
           // child: Expanded(
                child: Text("Show More")
            //),
          ),
          onPressed: (){
            setState(() {
              if(recentList.currentPage <= totalPages-1 && !loading){
                mockFetch(recentList);
              }
              //recentList.getNextPage(1);
            });
          },
        ) : Container(),
      ],
    );
  }
}

class SingleItem extends StatelessWidget {
  ItemWithImages item;

  SingleItem({
    required this.item
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => Navigator.of(context).push(new MaterialPageRoute(
              builder: (context) => new ItemDetails(
                  item
              ))),
          child: Container(
            margin: EdgeInsets.only(left: 15),
            width: 150,
            height: 100,
            alignment: Alignment.topRight,
            decoration: BoxDecoration(
                image: DecorationImage(image: item.imageDataList.length > 0 ? MemoryImage(item.imageDataList[0]) : AssetImage('assets/images/no-picture-available-icon.png') as ImageProvider, fit: BoxFit.cover),
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
          width: 150,
          margin: EdgeInsets.only(top: 0, left: 15),
          height: 30,
          child: Text("${item.name}",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}
