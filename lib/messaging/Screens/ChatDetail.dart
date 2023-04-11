import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../models/chatMessageModel.dart';
import '../../models/messageModel.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;



class ChatDetailPage extends StatefulWidget{
  ChatDetailPage({Key? key,required this.chatProfile, required this.currentUserDbId}) : super(key: key);
  final ChatMessageHome chatProfile;
  final int currentUserDbId;
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  late IO.Socket _socket;
  TextEditingController _controller = TextEditingController();
  int latestItemSellerId = -1;
  String latestItemName = "";
  int latestItemDbId = -1;
  List<UserMessage> userMessagesForSpecificItem = [];
  List<UserMessage> userMessagesBetweenUsersForQuery = [];



  _sendMessage(String? message, int? creatorId, int? recipientId, int? itemId, String timeSent, String? recipientProfileName) {
    _socket.emit('message', {
      'message_text': message,
      'creator_user_id' : creatorId,
      'recipient_user_id' : recipientId,
      'item_id' : itemId,
      'createdAt' : DateTime.now().toString()
    });
    if (message != null && message.startsWith("Interested in:")) {
      userMessagesForSpecificItem.add(UserMessage.CreateMessage(message, creatorId, recipientId, itemId, DateTime.now().toString(), "USER"));
    } else {
      _controller.clear();
    }
  }
  _connectSocket() {
    _socket.onConnect((data) => print('Connection Established'));
    _socket.onConnectError((data) => print('Connect Error: $data'));
    _socket.onDisconnect((data) => print('Socket.IO server disconnected'));
    _socket.on('message',
          (data) {
      if(mounted) {
        Provider.of<MessageModel>(context, listen: false).sendMessage(
          UserMessage.fromJson(data),
        );
      }
          }
    );
  }


  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  @override
  void initState() {
    super.initState();


    // getSellerId(widget.chatProfile.item_id);

    _socket = IO.io("http://messagingbackendstudentshop2-env.eba-7vhh5ptn.us-east-1.elasticbeanstalk.com", IO.OptionBuilder().enableForceNew()
        .setTransports(['websocket']).setQuery({'username': widget.chatProfile.recipient_profile_name}).build());
    _connectSocket();
    Provider.of<MessageModel>(context, listen: false).getMessagesHelper(widget.chatProfile.creator_user_id!, widget.chatProfile.recipient_user_id!);
    // if(widget.chatProfile.item_id == -1) {
    //   getLatestItemDbId(widget.chatProfile.creator_user_id, widget.chatProfile.recipient_user_id).then((value) => getLatestItemInformation(latestItemDbId).then((value) => getMessagesForSpecificItem(widget.chatProfile.creator_user_id,widget.chatProfile.recipient_user_id,latestItemDbId)));
    // } else {
    //   getLatestItemInformation(widget.chatProfile.item_id).then((value) => getMessagesForSpecificItem(widget.chatProfile.creator_user_id,widget.chatProfile.recipient_user_id, widget.chatProfile.item_id));
    // }
  }



  // void connect() {
  //   // socket = IO.io("http://192.168.1.170:5000", <String,dynamic>{
  //   //   "transports": ["websocket"],
  //   //   "autoConnect": false,
  //   // });
  //   socket.connect();
  //   socket.onConnect((data) => print("Connected"));
  //   print(socket.connected);
  // }
  @override
  Widget build(BuildContext context) {
    var messages = context.watch<MessageModel>();
    return Scaffold(
      extendBody: false,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          flexibleSpace: SafeArea(
            child: Container(
              padding: EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back,color: Colors.black,),
                  ),
                  SizedBox(width: 2,),
                  // CircleAvatar(
                  //   backgroundImage: SVgP("<https://randomuser.me/api/portraits/men/5.jpg>"),
                  //   maxRadius: 20,
                  // ),
                  CircleAvatar(
                    child:
                    SvgPicture.asset("assets/personIcon.svg",
                      color: Colors.white,
                      height: 36,
                    ),
                    radius: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(widget.chatProfile.current_user_id == widget.chatProfile.recipient_user_id ?
                        widget.chatProfile.creator_profile_name.toString() : widget.chatProfile.recipient_profile_name.toString(),style: TextStyle( fontSize: 16 ,fontWeight: FontWeight.w600, color: Colors.black),),
                        SizedBox(height: 6,),
                        Text("Online",style: TextStyle(fontSize: 13),),
                      ],
                    ),
                  ),
                  PopupMenuButton(
                    // add icon, by default "3 dot" icon
                    // icon: Icon(Icons.book)
                      itemBuilder: (context){
                        return [
                          PopupMenuItem<int>(
                            value: 0,
                            child: Text("Report"),
                          ),

                          PopupMenuItem<int>(
                            value: 1,
                            child: Text("Block"),
                          ),
                        ];
                      },
                      onSelected:(value){
                        if(value == 0){
                          showAlertDialogReportUser(context);
                        }else if(value == 1){
                          showAlertDialogBlockUser(context);
                        }
                      }
                  ),
                  // Icon(Icons.settings,color: Colors.black54,),
                ],
              ),
            ),
          ),
        ),
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              bottom: 60,
              left: 0,
              right: 0,
              child: ListView.builder(
                itemCount: messages.messageList.length,
                shrinkWrap: true,
                reverse: true,
                padding: EdgeInsets.only(top: 10,bottom: 10),
                // physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index){
                  return Container(
                    padding: EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
                    child: Align(
                      alignment: (messages.messageList[index].creator_user_id != widget.currentUserDbId?Alignment.topLeft:Alignment.topRight),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: (messages.messageList[index].creator_user_id != widget.currentUserDbId ? Colors.grey.shade200:Colors.blue[200]),
                        ),
                        padding: EdgeInsets.all(16),
                        child: Text(messages.messageList[index].message_text.toString(), style: TextStyle(fontSize: 15, color: Colors.black),),
                      ),
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
                height: 70,
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    // GestureDetector(
                    //   onTap: (){
                    //   },
                    //   child: Container(
                    //     height: 30,
                    //     width: 30,
                    //     decoration: BoxDecoration(
                    //       color: Colors.lightBlue,
                    //       borderRadius: BorderRadius.circular(30),
                    //     ),
                    //     child: Icon(Icons.add, color: Colors.white, size: 20, ),
                    //   ),
                    // ),
                    SizedBox(width: 15,),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                            hintText: "Write message...",
                            hintStyle: TextStyle(color: Colors.black54),
                            border: InputBorder.none
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    FloatingActionButton(
                      onPressed: (){
                        if(_controller.text.trim().isNotEmpty) {
                          // if(userMessagesForSpecificItem.length == 0) {
                          //   _sendMessage("Interested in: " + latestItemName, widget.currentUserDbId,
                          //       widget.currentUserDbId == widget.chatProfile.creator_user_id ? widget.chatProfile.recipient_user_id : widget.chatProfile.creator_user_id ,widget.chatProfile.item_id != -1 ? widget.chatProfile.item_id : latestItemDbId,DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now()),
                          //       widget.chatProfile.recipient_profile_name);
                          // }

                          UserMessage message = new UserMessage.CreateMessage(_controller.text,widget.currentUserDbId,
                              widget.currentUserDbId == widget.chatProfile.creator_user_id ? widget.chatProfile.recipient_user_id : widget.chatProfile.creator_user_id ,widget.chatProfile.item_id != -1 ? widget.chatProfile.item_id : latestItemDbId,DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now()),
                              widget.chatProfile.recipient_profile_name);
                          setState(() {
                            setState(() {
                              Provider.of<MessageModel>(context, listen: false).messageList.insert(0, message);
                            });
                          });
                          String messageText = _controller.text;
                          _controller.clear();
                          _sendMessage(messageText,widget.currentUserDbId,
                              widget.currentUserDbId == widget.chatProfile.creator_user_id ? widget.chatProfile.recipient_user_id : widget.chatProfile.creator_user_id ,widget.chatProfile.item_id != -1 ? widget.chatProfile.item_id : latestItemDbId,DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now()),
                              widget.chatProfile.recipient_profile_name);
                        }

                      },
                      child: Icon(Icons.send,color: Colors.white,size: 18,),
                      backgroundColor: Colors.blue,
                      elevation: 0,
                    ),
                    SizedBox(width: 15,),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  showAlertDialogReportUser(BuildContext context) {

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Report User"),
      content: Text("Are you sure you want to REPORT this user?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogBlockUser(BuildContext context) {

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Block User"),
      content: Text("Are you sure you want to BLOCK this user?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> getLatestItemDbId(int? creatorId, int? recipientId) async{
    Map<String, dynamic> map;
    var url = Uri.parse('http://Gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/messages/profile?creatorId=$creatorId&recipientId=$recipientId');
    http.Response response = await http.get(url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      // data.map<Item>((json) => Item.fromJson(json)).toList();
      print(response.body);
      map = jsonDecode(response.body);
      userMessagesBetweenUsersForQuery = List.from(map['content']).map((msg)=>UserMessage.fromJson(msg)).toList();
      // itemSellerId = userMessagesBetweenUsersForQuery[0]['seller_id'];
      // itemName = userMessagesBetweenUsersForQuery[0].;
      if(userMessagesBetweenUsersForQuery.length != 0) {
        latestItemDbId = userMessagesBetweenUsersForQuery[0].item_id!;
      }
      // print(itemSellerId);
      // messageList = List.from(map['content']).map((msg)=>UserMessage.fromJson(msg)).toList();
      // totalPages = map['totalPages'];
    } else {
      print (response.statusCode);
    }
  }

  Future<void> getLatestItemInformation(int? latestItemDbId) async{
    Map<String, dynamic> map;
    var url = Uri.parse('http://Gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/categories/items/$latestItemDbId');
    http.Response response = await http.get(url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      // data.map<Item>((json) => Item.fromJson(json)).toList();
      print(response.body);
      map = jsonDecode(response.body);
      // userMessagesBetweenUsersForQuery = List.from(map['content']).map((msg)=>UserMessage.fromJson(msg)).toList();
      latestItemSellerId = map['content'][0]['seller_id'];
      latestItemName = map['content'][0]['name'];
      // latestItemDbId = userMessagesBetweenUsersForQuery[0].item_id!;
      // print(itemSellerId);
      // messageList = List.from(map['content']).map((msg)=>UserMessage.fromJson(msg)).toList();
      // totalPages = map['totalPages'];
    } else {
      print (response.statusCode);
    }
  }

  Future<void> getMessagesForSpecificItem(int? creatorId, int? recipientId, int? itemId) async {
    Map<String, dynamic> map;
    var url = Uri.parse('http://Gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/messages/profile/itemMessages?creatorId=$creatorId&recipientId=$recipientId&itemId=$itemId');
    http.Response response = await http.get(url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {

      // data.map<Item>((json) => Item.fromJson(json)).toList();
      print(response.body);
      map = jsonDecode(response.body);
      userMessagesForSpecificItem = List.from(map['content']).map((msg)=>UserMessage.fromJson(msg)).toList();
      } else {
      print (response.statusCode);
      }
      }
}