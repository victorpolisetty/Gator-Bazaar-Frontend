import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:student_shopping_v1/pages/ConversationListPage.dart';

import '../../models/chatMessageModel.dart';
import 'package:provider/provider.dart';

import '../Screens/ChatDetail.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ChatMessageModel>(context, listen: false).getChatHomeHelper();
  }
  @override
  Widget build(BuildContext context) {
    var chatProfiles = context.watch<ChatMessageModel>();
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16,right: 16,top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Conversations",style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold),),
                    Container(
                      padding: EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 2),
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.pink[50],
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.add,color: Colors.pink,size: 20,),
                          SizedBox(width: 2,),
                          Text("Add New",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.only(top: 16,left: 16,right: 16),
            //   child: TextField(
            //     decoration: InputDecoration(
            //       hintText: "Search...",
            //       hintStyle: TextStyle(color: Colors.grey.shade600),
            //       prefixIcon: Icon(Icons.search,color: Colors.grey.shade600, size: 20,),
            //       filled: true,
            //       fillColor: Colors.grey.shade100,
            //       contentPadding: EdgeInsets.all(8),
            //       enabledBorder: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(20),
            //           borderSide: BorderSide(
            //               color: Colors.grey.shade100
            //           )
            //       ),
            //     ),
            //   ),
            // ),
            ListView.builder(
              itemCount: chatProfiles.ChatMessageHomeList.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 16),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index){
                return GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => new ChatDetailPage(chatProfile: chatProfiles.chatHome[index], currentUserDbId: chatProfiles.chatHome[index].current_user_id!)))
                        .then((value) => Provider.of<ChatMessageModel>(context, listen: false).getChatHomeHelper());
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                radius: 30,
                                child:
                                SvgPicture.asset("assets/personIcon.svg",
                                  color: Colors.white,
                                  height: 36,
                                  width: 36,
                                ),
                                backgroundColor: Colors.blueGrey,

                              ),
                              SizedBox(width: 16,),
                              Expanded(
                                child: Container(
                                  color: Colors.transparent,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(chatProfiles.chatHome[index].current_user_id == chatProfiles.chatHome[index].recipient_user_id ?
                                      chatProfiles.chatHome[index].creator_profile_name.toString() : chatProfiles.chatHome[index].recipient_profile_name.toString()
                                        , style: TextStyle(fontSize: 16),),
                                      SizedBox(height: 6,),
                                      Text(chatProfiles.chatHome[index].message_text.toString(), style: TextStyle(fontSize: 13,color: Colors.grey.shade600, fontWeight: false?FontWeight.bold:FontWeight.normal),),
                                      // Text(widget.chatProfile.message_text.toString(), style: TextStyle(fontSize: 13,color: Colors.grey.shade600, fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal),),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // DateTime.parse(chatProfiles.chatHome[index].createdAt+"Z").toLocal().toString()
                        Text(DateFormat('h:mm a').format(DateTime.parse(chatProfiles.chatHome[index].createdAt).toLocal()).toString(),style: TextStyle(fontSize: 12,fontWeight: false ? FontWeight.bold:FontWeight.normal),),
                        // Text(DateFormat('h:mm a').format(DateTime.parse(chatProfiles.chatHome[index].createdAt.toString())).toString(),style: TextStyle(fontSize: 12,fontWeight: false ? FontWeight.bold:FontWeight.normal),),
                      ],
                    ),
                  ),
                );;
              },
            ),
          ],

        ),
      ),
    );
  }
}