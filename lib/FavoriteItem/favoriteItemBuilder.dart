import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:student_shopping_v1/models/favoriteModel.dart';
import 'package:student_shopping_v1/new/components/product_card.dart';
import 'package:student_shopping_v1/pages/itemDetailPage.dart';
import '../ProductCardFav.dart';
import '../models/itemModel.dart';


class FavoriteItems extends StatefulWidget {
  final itemName;
  final itemPrice;
  final itemPicture;
  final itemDesc;
  final itemCategoryId;

  FavoriteItems({
    this.itemName,
    this.itemPrice,
    this.itemPicture,
    this.itemDesc,
    this.itemCategoryId,
  });

  @override
  _FavoriteItemsState createState() => _FavoriteItemsState();
}



class _FavoriteItemsState extends State<FavoriteItems> {
  @override
  final PagingController<int, ItemWithImages> _pagingController =
  PagingController(firstPageKey: 0);
  int totalPages = 0;
  var favoriteList;

  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    // Provider.of<FavoriteModel>(context, listen: false).getCategoryItems();
    super.initState();
  }
  Future<void> _fetchPage(int pageKey) async {
    try {
      await Provider.of<FavoriteModel>(context, listen: false).initNextCatPage(pageKey);
      totalPages = Provider.of<FavoriteModel>(context, listen: false).totalPages;
      if(mounted) {
        final isLastPage = (totalPages-1) == pageKey;

        if (isLastPage) {
          _pagingController.appendLastPage(Provider.of<FavoriteModel>(context, listen: false).items);
        } else {
          final int? nextPageKey = pageKey + 1;
          _pagingController.appendPage(Provider.of<FavoriteModel>(context, listen: false).items, nextPageKey);
        }
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }
  @override
  Widget build(BuildContext context) {
    // var favoriteList = context.watch<FavoriteModel>();
    return new RefreshIndicator(
        onRefresh: () => Future.sync(() => _pagingController.refresh()),
        child: Center(
          child: new
          PagedGridView(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<ItemWithImages>(
                firstPageProgressIndicatorBuilder: (_) => Center(child: spinkit),
                newPageProgressIndicatorBuilder: (_) => Center(child: spinkit),
                noItemsFoundIndicatorBuilder: (_) => Center(child: Text("No Favorites Yet :)", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),)),
                itemBuilder: (BuildContext context, item, int index) {
                  return ProductCardFav(
                    product: item,
                    uniqueIdentifier: "favorite",
                  );
                }
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisSpacing: 0,),
          ),
        )
    );
          return new ListView.builder(
            itemCount: favoriteList.items.length == null ? 0 : favoriteList.items.length,
              itemBuilder: (context, index){
                int reverseIndex = favoriteList.items.length - 1 - index;
                // while(favoriteList.items.length == 0){
                //   return Container(
                //     child: Center(
                //         child: Text("No Favorites Added!")
                //     ),
                //   );
                // }
                return ProductCardFav(
                  product: favoriteList.items[reverseIndex],
                  uniqueIdentifier: "favorite",
                );
              });
        // );

  }
}
// class Child extends StatelessWidget {
//   final favoriteList;
//   Child({this.favoriteList});
//
//
//   @override
//   Widget build(BuildContext context) {
//     // var futureProvider = Provider.of<FavoriteModel>(context);
//     // return FutureBuilder(
//     //   initialData: <Widget>[],
//     //   future: FavoriteModel().getItemRestList(),
//     //   builder: (BuildContext context, AsyncSnapshot snapshot) {
//     //     if (snapshot.connectionState == ConnectionState.none &&
//     //         snapshot.hasData == true) {
//           return ListView.builder(
//             itemCount: futureProvider.items.length == null ? 0 : futureProvider.items.length,
//             itemBuilder: (BuildContext context, int index) {
//             return FavoriteItem(
//               item: futureProvider.items[index]
//             );
//             },
//           );
//         }
//         // else {
//         //   return Text('ALAWS');
//         // }
//       // },
// //     );
// //   }
// }

class FavoriteItem extends StatelessWidget {

  ItemWithImages item;

  FavoriteItem({
    required this.item

  });
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[210],
      child: InkWell(
        onTap: () => Navigator.of(context).push(new MaterialPageRoute(
            builder: (context) => new ItemDetails(
                context.watch<FavoriteModel>().userIdFromDb,
              item
            ))),
        child: ListTile(
          //=======LEADING SECTION=========
          //DecorationImage(image: MemoryImage(item_picture), fit: BoxFit.cover),
          trailing: Image.memory(item.imageDataList.length > 0 ? item.imageDataList[0] : AssetImage('assets/images/GatorBazaar.jpg') as Uint8List),
          //============TITLE SECTION============
          title: new Text(item.name!),
          //SUBTITLE SECTION=============
          subtitle: new Column(
            children: <Widget>[
              // ROW INSIDE THE COLUMN
              new Row(
                children: <Widget>[
                  new Padding(padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                    child: new Text("Price:"),),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                      child: Text((' \$${NumberFormat('#,##0.00', 'en_US').format(item.price)}'),
                        style:TextStyle(color: Colors.black),)
                  ),
                ],
              ),
//        ===============THIS SECTION IS FOR THE PRODUCT PRICE ====================
            ],
          ),
        ),
      ),
    );
  }
}
