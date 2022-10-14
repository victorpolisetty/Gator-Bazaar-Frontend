import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../Widgets/circleIcon.dart';
import '../models/categoryModel.dart';
import '../pages/categoryItemPage.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    super.initState();
    // Provider.of<CategoryModel>(context, listen: false).getChatHomeHelper();
  }
  @override
  Widget build(BuildContext context) {
    // var categoryList = context.watch<CategoryModel>();
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 80,
      width: MediaQuery.of(context).size.width,
    //   child: ListView.builder(
    //     scrollDirection: Axis.horizontal,
    //     itemCount: categoryList.categoryList.length,
    //     itemBuilder: (context, index) {
    // // return  Column(
    // //       children: [
    // //         InkWell(
    // //           onTap: () => Navigator.of(context).push(new MaterialPageRoute(
    // //               // builder: (context) => CategoryItemPage(1))),
    // //               builder: (context) => CategoryItemPage(1))),
    // //
    // //           child: CircleAvatar(
    // //             backgroundColor: Color(0xff00A3FF),
    // //             radius: 28.0,
    // //             backgroundImage:
    // //             MemoryImage(categoryList.categoryList[index].imageURL!),
    // //           ),
    // //       ),
    // //         Padding(
    // //           padding: const EdgeInsets.fromLTRB(20,0,0,0),
    // //           child: Center(child: Text(categoryList.categoryList[index].name.toString())),
    // //         )
    // // ]
    // //     );
    //     },
    //       child ListView.builder(
    //   // shrinkWrap: true,
    //   itemCount: _messages.length,
    //   itemBuilder: (context, index) {
    //     RemoteMessage message = _messages[index];
    //
    //     return ListTile(
    //       title: Text(
    //           message.messageId ?? 'no RemoteMessage.messageId available'),
    //       subtitle:
    //       Text(message.sentTime?.toString() ?? DateTime.now().toString()),
    //       onTap: () => Navigator.pushNamed(context, '/message',
    //           arguments: MessageArguments(message, false)),
    //     );
    //   });
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Column(
              children: [
                InkWell(
                    onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                      // builder: (context) => CategoryItemPage(1))),
                        builder: (context) => CategoryItemPage(1, "Clothes"))),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(25, 20, 0, 0),
                        height: 62,
                        width: 70,
                        child: Image.asset('assets/images/male-clothes.png'),

                      ),
                    )

                  // child: CircleIcon(
                  //   Colors.green,
                  //   Icon(
                  //     Icons.clothes,
                  //     color: Colors.grey[200],
                  //     size: 28,
                  //   ),
                  // ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20,0,0,0),
                  child: Text("Clothes",style: TextStyle(fontSize: 12),),
                )
              ]
          ),
          Column(
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                    // builder: (context) => CategoryItemPage(1))),
                      builder: (context) => CategoryItemPage(2, "Formal Dresses"))),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(25, 20, 0, 0),
                      height: 62,
                      width: 70,
                      child: Image.asset('assets/images/dress.png'),

                    ),
                  )

                  // child: CircleIcon(
                  //   Colors.green,
                  //   Icon(
                  //     Icons.clothes,
                  //     color: Colors.grey[200],
                  //     size: 28,
                  //   ),
                  // ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20,0,0,0),
                  child: Text("Formal Dresses",style: TextStyle(fontSize: 12),),
                )
              ]
          ),
          Column(
              children: [
                InkWell(
                    onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                      // builder: (context) => CategoryItemPage(1))),
                        builder: (context) => CategoryItemPage(3, "Student Tickets"))),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(25, 20, 0, 0),
                        height: 62,
                        width: 70,
                        child: Image.asset('assets/images/tickets.png'),

                      ),
                    )

                  // child: CircleIcon(
                  //   Colors.green,
                  //   Icon(
                  //     Icons.clothes,
                  //     color: Colors.grey[200],
                  //     size: 28,
                  //   ),
                  // ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20,0,0,0),
                  child: Text("Student Tickets",style: TextStyle(fontSize: 12),),
                )
              ]
          ),
          Column(
              children: [
                InkWell(
                    onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                      // builder: (context) => CategoryItemPage(1))),
                        builder: (context) => CategoryItemPage(4, "Furniture"))),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(25, 20, 0, 0),
                        height: 62,
                        width: 70,
                        child: Image.asset('assets/images/furnitures.png'),
                      ),
                    )

                  // child: CircleIcon(
                  //   Colors.green,
                  //   Icon(
                  //     Icons.clothes,
                  //     color: Colors.grey[200],
                  //     size: 28,
                  //   ),
                  // ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20,0,0,0),
                  child: Text("Furniture",style: TextStyle(fontSize: 12),),
                )
              ]
          ),
          Column(
              children: [
                InkWell(
                    onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                      // builder: (context) => CategoryItemPage(1))),
                        builder: (context) => CategoryItemPage(5, "Subleases"))),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(25, 20, 0, 0),
                        height: 62,
                        width: 70,
                        child: Image.asset('assets/images/home.png'),

                      ),
                    )

                  // child: CircleIcon(
                  //   Colors.green,
                  //   Icon(
                  //     Icons.clothes,
                  //     color: Colors.grey[200],
                  //     size: 28,
                  //   ),
                  // ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20,0,0,0),
                  child: Text("Subleases",style: TextStyle(fontSize: 12),),
                ),
              ]
          ),
          Column(
              children: [
                InkWell(
                    onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                      // builder: (context) => CategoryItemPage(1))),
                        builder: (context) => CategoryItemPage(6, "Electronics"))),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(25, 20, 0, 0),
                        height: 62,
                        width: 70,
                        child: Image.asset('assets/images/responsive.png'),

                      ),
                    )

                  // child: CircleIcon(
                  //   Colors.green,
                  //   Icon(
                  //     Icons.clothes,
                  //     color: Colors.grey[200],
                  //     size: 28,
                  //   ),
                  // ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20,0,0,0),
                  child: Text("Electronics",style: TextStyle(fontSize: 12),),
                )
              ]
          ),
          Column(
              children: [
                InkWell(
                    onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                      // builder: (context) => CategoryItemPage(1))),
                        builder: (context) => CategoryItemPage(7, "Books"))),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(25, 20, 0, 0),
                        height: 62,
                        width: 70,
                        child: Image.asset('assets/images/textbook1.png'),

                      ),
                    )

                  // child: CircleIcon(
                  //   Colors.green,
                  //   Icon(
                  //     Icons.clothes,
                  //     color: Colors.grey[200],
                  //     size: 28,
                  //   ),
                  // ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20,0,0,0),
                  child: Text("Books",style: TextStyle(fontSize: 12),),
                )
              ]
          ),
          Column(
              children: [
                InkWell(
                    onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                      // builder: (context) => CategoryItemPage(1))),
                        builder: (context) => CategoryItemPage(8, "Misc."))),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(25, 20, 0, 0),
                        height: 62,
                        width: 70,
                        child: Image.asset('assets/images/magic-box.png'),

                      ),
                    )

                  // child: CircleIcon(
                  //   Colors.green,
                  //   Icon(
                  //     Icons.clothes,
                  //     color: Colors.grey[200],
                  //     size: 28,
                  //   ),
                  // ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20,0,0,0),
                  child: Text("Misc.",style: TextStyle(fontSize: 12),),
                )
              ]
          ),
        ],
      ),
    );
    }
}
