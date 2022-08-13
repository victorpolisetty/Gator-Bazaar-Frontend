// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import '../messaging/Screens/ChatDetail.dart';
// import '../models/chatMessageModel.dart';
//
// class ConversationList extends StatefulWidget{
//   // String name;
//   // String messageText;
//   // String imageUrl;
//   // String time;
//   // bool isMessageRead;
//   ConversationList({Key? key, required this.chatProfile}) : super(key: key);
//   final ChatMessageHome chatProfile;
//   // ConversationList({@required this.name,@required this.messageText,@required this.imageUrl,@required this.time,@required this.isMessageRead});
//   @override
//   _ConversationListState createState() => _ConversationListState();
// }
//
// class _ConversationListState extends State<ConversationList> {
//   User? currentUser = FirebaseAuth.instance.currentUser;
//
//   @override
//   Widget build(BuildContext context) {
//     // return GestureDetector(
//     //   onTap: (){
//     //     Navigator.of(context).push(new MaterialPageRoute(
//     //         builder: (BuildContext context) => new ChatDetailPage(chatProfile: widget.chatProfile, currentUserDbId: widget.chatProfile.current_user_id!)));
//     //   },
//     //   child: Container(
//     //     padding: EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
//     //     child: Row(
//     //       children: <Widget>[
//     //         Expanded(
//     //           child: Row(
//     //             children: <Widget>[
//     //               CircleAvatar(
//     //                 radius: 30,
//     //                 child:
//     //                 SvgPicture.asset("assets/personIcon.svg",
//     //                   color: Colors.white,
//     //                   height: 36,
//     //                   width: 36,
//     //                 ),
//     //                 backgroundColor: Colors.blueGrey,
//     //
//     //               ),
//     //               SizedBox(width: 16,),
//     //               Expanded(
//     //                 child: Container(
//     //                   color: Colors.transparent,
//     //                   child: Column(
//     //                     crossAxisAlignment: CrossAxisAlignment.start,
//     //                     children: <Widget>[
//     //                       Text(widget.chatProfile.current_user_id == widget.chatProfile.recipient_user_id ?
//     //                       widget.chatProfile.creator_profile_name.toString() : widget.chatProfile.recipient_profile_name.toString()
//     //                         , style: TextStyle(fontSize: 16),),
//     //                       SizedBox(height: 6,),
//     //                       Text(widget.chatProfile.message_text.toString(), style: TextStyle(fontSize: 13,color: Colors.grey.shade600, fontWeight: false?FontWeight.bold:FontWeight.normal),),
//     //                       // Text(widget.chatProfile.message_text.toString(), style: TextStyle(fontSize: 13,color: Colors.grey.shade600, fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal),),
//     //                     ],
//     //                   ),
//     //                 ),
//     //               ),
//     //             ],
//     //           ),
//     //         ),
//     //         Text(DateFormat('h:mm a').format(DateTime.parse(widget.chatProfile.createdAt.toString())).toString(),style: TextStyle(fontSize: 12,fontWeight: false ? FontWeight.bold:FontWeight.normal),),
//     //         // Text(DateFormat('h:mm a').format(DateTime.parse(widget.chatProfile.createdAt.toString())).toString(),style: TextStyle(fontSize: 12,fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal),),
//     //       ],
//     //     ),
//     //   ),
//     // );
//   }
// }