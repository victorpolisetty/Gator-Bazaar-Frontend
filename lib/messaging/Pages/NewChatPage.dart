import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:student_shopping_v1/new/size_config.dart';
import '../../models/chatMessageModel.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;


import '../Screens/ChatDetail.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  int currentUserId = -1;
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    getProfileFromDb(currentUser?.uid.toString());
    Provider.of<ChatMessageModel>(context, listen: false).getChatHomeHelper();
  }


  @override
  Widget build(BuildContext context) {
    var chatProfiles = context.watch<ChatMessageModel>();
           return  Scaffold(
             appBar: AppBar(
             elevation: 0,
             automaticallyImplyLeading: false,
             backgroundColor: Colors.white,
               title: Text("Messaging", style: TextStyle(color: Colors.black),),
           ),
             body: chatProfiles.ChatMessageHomeList.isEmpty
                 ? Center(
               child: Text(
                 "No messages found. Send a message!",
                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
               ),
             )
                 : ListView.builder(
               itemCount: chatProfiles.ChatMessageHomeList.length,
               shrinkWrap: true,
               itemBuilder: (context, index) {
                 return GestureDetector(
                   onTap: () {
                     if (chatProfiles.chatHome[index].id != -1 &&
                         chatProfiles.chatHome[index].is_message_read == false) {
                       chatProfiles
                           .changeLatestMessageToRead(chatProfiles.chatHome[index].id);
                     }
                     Navigator.of(context).push(
                       MaterialPageRoute(
                         builder: (BuildContext context) => ChatDetailPage(
                           chatProfile: chatProfiles.chatHome[index],
                           currentUserDbId: chatProfiles.chatHome[index].current_user_id!,
                         ),
                       ),
                     ).then(
                           (value) =>
                           Provider.of<ChatMessageModel>(context, listen: false)
                               .getChatHomeHelper(),
                     );
                   },
                   child: Container(
                     padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
                     child: Row(
                       children: <Widget>[
                         Expanded(
                           child: Row(
                             children: <Widget>[
                               chatProfiles.chatHome[index].is_message_read! ||
                                   chatProfiles.chatHome[index].creator_user_id ==
                                       currentUserId
                                   ? SizedBox()
                                   : Icon(
                                 Icons.circle,
                                 color: Colors.blue.shade400,
                                 size: 15,
                               ),
                               SizedBox(),
                               CircleAvatar(
                                 radius: 30,
                                 backgroundColor: Colors.grey,
                                 child: SvgPicture.asset(
                                   "assets/personIcon.svg",
                                   color: Colors.white,
                                   height: 36,
                                   width: 36,
                                 ),
                               ),
                               SizedBox(width: 16,),
                               Expanded(
                                 child: Container(
                                   color: Colors.transparent,
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: <Widget>[
                                       Text(
                                         chatProfiles.chatHome[index].current_user_id ==
                                             chatProfiles.chatHome[index]
                                                 .recipient_user_id
                                             ? chatProfiles.chatHome[index]
                                             .creator_profile_name
                                             .toString()
                                             : chatProfiles.chatHome[index]
                                             .recipient_profile_name
                                             .toString(),
                                         style: TextStyle(
                                           fontSize: 16,
                                           color: Colors.black,
                                         ),
                                       ),
                                       SizedBox(height: 6,),
                                       Text(
                                         chatProfiles.chatHome[index].message_text
                                             .toString()
                                             .length <= 20
                                             ? chatProfiles.chatHome[index]
                                             .message_text
                                             .toString()
                                             : '${chatProfiles.chatHome[index].message_text.toString().substring(0, 20)}...',
                                         style: TextStyle(
                                           fontSize: 13,
                                           color: Colors.black,
                                           fontWeight: chatProfiles.chatHome[index]
                                               .is_message_read! ||
                                               chatProfiles.chatHome[index]
                                                   .creator_user_id ==
                                                   currentUserId
                                               ? FontWeight.normal
                                               : FontWeight.bold,
                                         ),
                                       ),
                                       // Text(widget.chatProfile.message_text.toString(), style: TextStyle(fontSize: 13,color: Colors.grey.shade600, fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal),),
                                     ],
                                   ),
                                 ),
                               ),
                             ],
                           ),
                         ),
                         Text(
                           DateFormat('h:mm a')
                               .format(DateTime.parse(chatProfiles
                               .chatHome[index].createdAt)
                               .toLocal())
                               .toString(),
                           style: TextStyle(
                             fontSize: 12,
                             fontWeight: false ? FontWeight.bold : FontWeight.normal,
                           ),
                         ),
                       ],
                     ),
                   ),
                 );
               },
             ),
           );





  }
  Future<void> getProfileFromDb(String? firebaseid) async {
    Map<String, dynamic> data;
    var url = Uri.parse('http://Gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/profiles/$firebaseid'); // TODO -  call the recentItem service when it is built
    http.Response response = await http.get(
        url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      currentUserId = data['id'];
    } else {
      print(response.statusCode);
    }
  }
}