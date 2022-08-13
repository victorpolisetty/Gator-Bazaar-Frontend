// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart'; // new
// import 'package:image_picker/image_picker.dart';
// import 'package:student_shopping_v1/models/sellerItemModel.dart';
// import 'package:provider/provider.dart';
// import '../models/itemModel.dart';
// import 'itemDetailPage.dart';
//
// class UserProfile extends StatefulWidget {
//   const UserProfile({Key? key}) : super(key: key);
//
//   @override
//   _UserProfileState createState() => _UserProfileState();
// }
//
// class _UserProfileState extends State<UserProfile> {
//
//   @override
//   Widget build(BuildContext context) {
//
//   }
//   // void _loadPicker(ImageSource source) async{
//   //   XFile? picked = await ImagePicker().pickImage(source: source);
//   //   if(picked != null){
//   //     setState(() {
//   //       _pickedImage = picked;
//   //     });
//   //
//   //   }
//   //   Navigator.of(context, rootNavigator: true).pop();
//   // }
//
//   // void _showPickOptionsDialog(BuildContext context){
//   //   BuildContext dialogContext;
//   //   showDialog(context: context,
//   //       builder: (context) => AlertDialog(
//   //         // dialogContext = context;
//   //         content: Column(
//   //           mainAxisSize: MainAxisSize.min,
//   //           children: [
//   //             ListTile(
//   //               title: Text("Pick from Gallery"),
//   //               onTap: (){
//   //                 _loadPicker(ImageSource.gallery);
//   //               },
//   //             ),
//   //             ListTile(
//   //               title: Text("Take a picture"),
//   //               onTap: (){
//   //                 _loadPicker(ImageSource.camera);
//   //               },
//   //             )
//   //           ],
//   //         ),
//   //       ) );
//   // }
// }
//
//
//
//
//
//
// // Widget buildImages() {
// //   return Padding(
// //     padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
// //     child: Container(
// //         height: 200.0,
// //         decoration: BoxDecoration(
// //             borderRadius: BorderRadius.circular(15.0),
// //             image: DecorationImage(
// //                 image: NetworkImage(
// //                     'https://images.unsplash.com/photo-1576797371181-97b48d7f6550?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1620&q=80'),
// //                 fit: BoxFit.cover))
// //     ),
// //   );
// // }
//
//
// // Widget buildInfoDetail() {
// //   return Padding(
// //     padding:
// //         EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0, bottom: 15.0),
// //     child: Row(
// //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //       children: <Widget>[
// //         Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: <Widget>[
// //             Text(
// //               'Spanish Text Books',
// //               style: TextStyle(
// //                   fontWeight: FontWeight.bold,
// //                   fontFamily: 'Montserrat',
// //                   fontSize: 15.0),
// //             ),
// //             SizedBox(height: 7.0),
// //             Row(
// //               children: <Widget>[
// //                 Text(
// //                   'John Smith',
// //                   style: TextStyle(
// //                       color: Colors.grey.shade700,
// //                       fontFamily: 'Montserrat',
// //                       fontSize: 11.0),
// //                 ),
// //                 SizedBox(width: 4.0),
// //                 Icon(
// //                   Icons.timer,
// //                   size: 4.0,
// //                   color: Colors.black,
// //                 ),
// //                 SizedBox(width: 4.0),
// //                 Text(
// //                   'University of Florida',
// //                   style: TextStyle(
// //                       color: Colors.grey.shade500,
// //                       fontFamily: 'Montserrat',
// //                       fontSize: 11.0),
// //                 )
// //               ],
// //             )
// //           ],
// //         ),
// //         Row(
// //           crossAxisAlignment: CrossAxisAlignment.center,
// //           children: <Widget>[
// //             SizedBox(width: 7.0),
// //             InkWell(
// //               onTap: () {},
// //               child: Container(
// //                 height: 20.0,
// //                 width: 20.0,
// //                 child: Image.network(
// //                     'https://github.com/rajayogan/flutterui-minimalprofilepage/blob/master/assets/navarrow.png?raw=true'),
// //               ),
// //             ),
// //             SizedBox(width: 7.0),
// //             InkWell(
// //               onTap: () {},
// //               child: Container(
// //                 height: 20.0,
// //                 width: 20.0,
// //                 child: Image.network(
// //                     'https://github.com/rajayogan/flutterui-minimalprofilepage/blob/master/assets/speechbubble.png?raw=true'),
// //               ),
// //             ),
// //             SizedBox(width: 7.0),
// //             InkWell(
// //               onTap: () {},
// //               child: Container(
// //                 height: 22.0,
// //                 width: 22.0,
// //                 child: Image.network(
// //                     'https://github.com/rajayogan/flutterui-minimalprofilepage/blob/master/assets/fav.png?raw=true'),
// //               ),
// //             )
// //           ],
// //         )
// //       ],
// //     ),
// //   );
// //
// // }
