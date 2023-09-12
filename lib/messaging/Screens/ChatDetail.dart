import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../api_utils.dart';
import '../../models/chatMessageModel.dart';
import '../../models/messageModel.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;

import '../../pages/SeeSellerDetailsAsBuyer.dart';



class ChatDetailPage extends StatefulWidget{
  ChatDetailPage({Key? key,required this.chatProfile, required this.currentUserDbId, required this.sellerImage}) : super(key: key);
  final ChatMessageHome chatProfile;
  final int currentUserDbId;
  final Uint8List sellerImage;
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
    _socket.on('message', (data) {
      if (mounted) {
        final messageModel = Provider.of<MessageModel>(context, listen: false);
        final chatMessageModel = Provider.of<ChatMessageModel>(context, listen: false);

        if (messageModel != null && chatMessageModel != null) {
          messageModel.sendMessage(UserMessage.fromJson(data));
        }


      }
    });
  }

  @override
  void initState() {
    super.initState();

    _socket = IO.io("http://messagingbackendstudentshop2-env.eba-7vhh5ptn.us-east-1.elasticbeanstalk.com", IO.OptionBuilder().enableForceNew()
        .setTransports(['websocket']).setQuery({'username': widget.chatProfile.recipient_profile_name}).build());
    _connectSocket();
    Provider.of<MessageModel>(context, listen: false).getMessagesHelperReal(widget.chatProfile.creator_user_id!, widget.chatProfile.recipient_user_id!);
  }

  @override
  Widget build(BuildContext context) {
    var messages = context.watch<MessageModel>();
    return Scaffold(
      extendBody: false,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          flexibleSpace: SafeArea(
            child: Container(
              padding: EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back,color: Colors.white,),
                  ),
                  SizedBox(width: 2,),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => SeeSellerDetailsAsBuyer(
                              widget.chatProfile),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: ClipOval( // Use ClipOval to create a circular clipping for the image
                        child: widget.sellerImage.isEmpty
                            ? SvgPicture.asset(
                          "assets/personIcon.svg",
                          color: Colors.white,
                          height: 36,
                        )
                            : Image.memory(
                          widget.sellerImage,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      radius: 20,
                    ),

                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => SeeSellerDetailsAsBuyer(
                                widget.chatProfile),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(widget.chatProfile.current_user_id == widget.chatProfile.recipient_user_id ?
                          widget.chatProfile.creator_profile_name.toString() : widget.chatProfile.recipient_profile_name.toString(),style: TextStyle( fontSize: 16 ,fontWeight: FontWeight.w600, color: Colors.white)),
                          SizedBox(height: 6,),
                        ],
                      ),
                    ),
                  ),
                  PopupMenuButton(
                    // add icon, by default "3 dot" icon
                    icon: Icon(Icons.more_horiz_outlined, color: Colors.white,),
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
      body: Container(
        color: Color(0xFF333333),
        child: GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                bottom: 75,
                left: 0,
                right: 0,
                child: ListView.builder(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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

                  padding: EdgeInsets.fromLTRB(2.w, 1.w, .8.w, 2.5.h),
                  height: 80,
                  width: double.infinity,
                  color: Colors.black,
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 1.h,),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0,0,0,0),
                          child: TextFormField(
                            style: TextStyle(color: Colors.white), // Set the text color to white
                            cursorColor: Colors.white,
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 20,
                            controller: _controller,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              hintText: 'Write Message...',
                              hintStyle: TextStyle(color: Colors.white),
                              fillColor: Colors.white,
                              focusColor: Colors.white,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.w),
                              labelStyle: TextStyle(color: Colors.white), // Remove horizontal padding
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
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
                        backgroundColor: Colors.blueAccent,
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
    var url = ApiUtils.buildApiUrl('/messages/profile?creatorId=$creatorId&recipientId=$recipientId');
    http.Response response = await http.get(url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      map = jsonDecode(response.body);
      userMessagesBetweenUsersForQuery = List.from(map['content']).map((msg)=>UserMessage.fromJson(msg)).toList();
      if(userMessagesBetweenUsersForQuery.length != 0) {
        latestItemDbId = userMessagesBetweenUsersForQuery[0].item_id!;
      }
    } else {
      print (response.statusCode);
    }
  }

  Future<void> getLatestItemInformation(int? latestItemDbId) async{
    Map<String, dynamic> map;
    var url = ApiUtils.buildApiUrl('/categories/items/$latestItemDbId');
    http.Response response = await http.get(url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      map = jsonDecode(response.body);
      latestItemSellerId = map['content'][0]['seller_id'];
      latestItemName = map['content'][0]['name'];
    } else {
      print (response.statusCode);
    }
  }

  Future<void> getMessagesForSpecificItem(int? creatorId, int? recipientId, int? itemId) async {
    Map<String, dynamic> map;
    var url = ApiUtils.buildApiUrl('/messages/profile/itemMessages?creatorId=$creatorId&recipientId=$recipientId&itemId=$itemId');
    http.Response response = await http.get(url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      map = jsonDecode(response.body);
      userMessagesForSpecificItem = List.from(map['content']).map((msg)=>UserMessage.fromJson(msg)).toList();
      } else {
      print (response.statusCode);
      }
      }
}