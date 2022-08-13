// import '../models/itemModel.dart';
// import '../models/sellerItemModel.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import 'itemDetailPage.dart';
// class SellerItems extends StatefulWidget {
//   const SellerItems({Key? key}) : super(key: key);
//
//   @override
//   State<SellerItems> createState() => _SellerItemsState();
// }
//
// class _SellerItemsState extends State<SellerItems> {
//
//   @override
//   Widget build(BuildContext context) {
//
//
//   }
// }
// class SingleItem extends StatelessWidget {
//   ItemWithImages item;
//
//   SingleItem({
//     required this.item
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         InkWell(
//           onTap: () => Navigator.of(context).push(new MaterialPageRoute(
//               builder: (context) => new ItemDetails(
//                   item
//               ))),
//           child: Container(
//             margin: EdgeInsets.only(left: 15),
//             width: 150,
//             height: 100,
//             alignment: Alignment.topRight,
//             decoration: BoxDecoration(
//                 image: DecorationImage(image: MemoryImage(item.imageDataList[0]), fit: BoxFit.cover),
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(18)),
//             child: Container(
//               margin: EdgeInsets.only(right: 10, top: 5),
//             ),
//           ),
//         ),
//         Container(
//           alignment: Alignment.centerLeft,
//           width: 150,
//           margin: EdgeInsets.only(top: 5, left: 15),
//           height: 30,
//           child: Text("\$${item.price}",
//               style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
//         ),
//         Container(
//           alignment: Alignment.topLeft,
//           width: 150,
//           margin: EdgeInsets.only(top: 0, left: 15),
//           height: 30,
//           child: Text("${item.name}",
//               style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
//         ),
//       ],
//     );
//   }
// }

// sellerItemList.items.length != 0 ?
// Column(
// children: [
// Column(
// // margin: EdgeInsets.only(top: 10),
// // width: MediaQuery.of(context).size.width,
// // // height: double.,
// // height: MediaQuery.of(context).size.height - 452,
// children: [
// Container(
// // width: MediaQuery.of(context).size.width,
// // height: double.,
// // height: MediaQuery.of(context).size.height - 452,
// height: double.infinity,
// width: double.infinity,
// child: GridView.builder(
// controller: _controller,
// itemCount: sellerItemList.items.length == null ? 0 : sellerItemList.items.length,
// itemBuilder: (BuildContext context, int index) {
// return SingleItem(
// item: sellerItemList.items[index]
// );
// // padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
// },
// gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// crossAxisCount: 2,
// mainAxisSpacing: 0,),
// ),
// ),
// if(loading)(spinkit),
// (isBottom && !allLoaded && !loading) ? ElevatedButton(
// style: ElevatedButton.styleFrom(
// primary: Colors.black
// ),
// child: Center(
// // child: Expanded(
// child: Text("Show More")
// //),
// ),
// onPressed: (){
// setState(() {
// if(sellerItemList.currentPage <= totalPages-1 && !loading){
// mockFetch(sellerItemList);
// }
// //recentList.getNextPage(1);
// });
// },
// ) : Container(),
// ]
// ),
// ],
// ) : Container(child: Padding(
// padding: const EdgeInsets.all(100),
// child: Center(child: Text("No Listings Yet!")),
// ),)
