import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:student_shopping_v1/models/favoriteModel.dart';
import 'package:student_shopping_v1/pages/itemDetailPage.dart';
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
  var favoriteList;
  void initState() {
    super.initState();
    Provider.of<FavoriteModel>(context, listen: false).getCategoryItems();
  }
  @override
  Widget build(BuildContext context) {
    var favoriteList = context.watch<FavoriteModel>();
          return new ListView.builder(
            itemCount: favoriteList.items.length == null ? 0 : favoriteList.items.length,
              itemBuilder: (context, index){
                // while(favoriteList.items.length == 0){
                //   return Container(
                //     child: Center(
                //         child: Text("No Favorites Added!")
                //     ),
                //   );
                // }
                return FavoriteItem(
                  item: favoriteList.items[index]
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
          trailing: Image.memory(item.imageDataList[0]),
          //============TITLE SECTION============
          title: new Text(item.name),
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
