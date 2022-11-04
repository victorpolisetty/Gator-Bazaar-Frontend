import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:student_shopping_v1/models/chatMessageModel.dart';
import 'package:student_shopping_v1/models/messageModel.dart';
import '../../pages/itemDetailPage.dart';
import '../CustomUI/OwnMessageCard.dart';
import '../CustomUI/ReplyCard.dart';
import 'package:provider/provider.dart';


class IndividualPage extends StatefulWidget {
  IndividualPage({Key? key,required this.chatProfile}) : super(key: key);
  final ChatMessageHome chatProfile;
  @override
  _IndividualPageState createState() => _IndividualPageState();
}

class _IndividualPageState extends State<IndividualPage> {

   mockFetch(MessageModel messageList) async{
    if(allLoaded){
      print("ALL LOADED");
      return;
    }
    setState(() {
      loading = true;
    });
    if(messageList.currentPage != 0){
      loading = (await messageList.initNextMessagePage(messageList.currentPage))!;
    }
    if(messageList.currentPage <= messageList.totalPages-1){
      messageList.currentPage++;
    }
    if(loading == false){
      setState(() {
        allLoaded = messageList.currentPage == messageList.totalPages;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Provider.of<MessageModel>(context, listen: false).getCategoryItems(widget.categoryId);
    _scrollController.addListener((){
      // reached top
      if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        setState(() => isTop = true);
      }

      // IS SCROLLING
      if (_scrollController.offset >= _scrollController.position.minScrollExtent &&
          _scrollController.offset < _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange) {
        setState(() {
          isTop = false;
        });
      }

      // REACHED bottom
      if (_scrollController.offset <= _scrollController.position.minScrollExtent &&
          !_scrollController.position.outOfRange) {
        setState(() => isTop = false);
      }
    });
  }

  // bool show = false;
  // FocusNode focusNode = FocusNode();
  // IO.Socket socket;
  bool isTop = false;
  bool loading = false, allLoaded = false, sendButton=false;
  // List<UserMessage> messages = [];
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();

  @override

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  Widget build(BuildContext context) {
    var messages = context.watch<MessageModel>();
    return Stack(
      children: [
        Image.asset("assets/messengerBackground.png",
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leadingWidth: 70,
            titleSpacing: 0,
            leading: InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_back,
                  size: 24,),
                  CircleAvatar(
                    child:
                    SvgPicture.asset("assets/personIcon.svg",
                    color: Colors.white,
                      height: 36,
                    ),
                    radius: 20,
                    backgroundColor: Colors.blueGrey,
                  )
                ],
              ),
            ),
            title: InkWell(
              onTap: (){},
              child: Center(
                child: Container(
                  margin: EdgeInsets.all(6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.chatProfile.recipient_profile_name.toString(),style: TextStyle(
                        fontSize: 18.5,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                      Text("last seen today at 12:05", style: TextStyle(
                        fontSize: 13,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              // IconButton(icon: Icon(Icons.videocam), onPressed: (){}),
              // IconButton(icon: Icon(Icons.call), onPressed: (){}),
              PopupMenuButton<String>(
                onSelected: (value) {
                  print(value);
                },
                itemBuilder: (BuildContext context){
                  return [
                    // PopupMenuItem(child: Text("View Contact"), value: "View Contact",),
                    // PopupMenuItem(child: Text("Media, links, and docs"), value: "Media, links, and docs",),
                    // PopupMenuItem(child: Text("Mute Notifications"), value: "Mute Notifications",),
                    // PopupMenuItem(child: Text("Settings"), value: "Settings",),
                  ];
                },
              )
            ],
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                if(loading)(spinkit),
                ((isTop && !allLoaded && !loading && messages.totalPages != 1) && (messages.currentPage <= messages.totalPages-1 && !loading))?
                  FutureBuilder(
                    future: mockFetch(messages),
    // initialData: Future<dynamic>,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return spinkit;
                    }) :
                  Container(),
                (isTop && !allLoaded && !loading && messages.totalPages != 1)?
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                  ),
                  child: Center(
                    // child: Expanded(
                      child: Text("Show More")
                    //),
                  ),
                  onPressed: (){
                    setState(() {
                      if(messages.currentPage <= messages.totalPages-1 && !loading){
                        mockFetch(messages);
                      }
                    });
                  },
                )
                    : Container(),
                // Flexible(
                //   height: MediaQuery.of(context).size.height - 140,
                  ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    controller: _scrollController,
                    itemCount: messages.messageList.length + 1,
                    itemBuilder: (context, index){
                      if(index == messages.messageList.length){
                        return Container(
                          height: 70,
                        );
                      }
                      //TODO: implement this
                      if(messages.messageList[index].creator_user_id == 1){
                        return OwnMessageCard(message: messages.messageList[index].message_text, time: DateFormat("h:mm a").format(DateTime.parse(messages.messageList[index].createdAt)));
                      } else {
                        return ReplyCard(message: messages.messageList[index].message_text, time: DateFormat("h:mm a").format(DateTime.parse(messages.messageList[index].createdAt)));
                      }
                      return Container();
                    },
                  ),
                // ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 70,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width - 60,
                              child: Card(
                                margin: EdgeInsets.only(left: 6, right: 2, bottom: 20),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: TextFormField(
                                    textCapitalization: TextCapitalization.characters,
                                    autofocus:true,
                                    controller: _controller,
                                    // focusNode: focusNode,
                                    textAlignVertical: TextAlignVertical.center,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 2,
                                    minLines: 1,
                                    onChanged: (value){
                                      if(value.length > 0){
                                        setState(() {
                                          sendButton = true;
                                        });
                                      } else {
                                        sendButton = false;
                                      }
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Type a message",
                                      prefixIcon: IconButton(icon: Icon(Icons.emoji_emotions),onPressed: (){},),
                                      suffixIcon: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(icon: Icon(Icons.attach_file), onPressed: (){}),
                                          IconButton(icon: Icon(Icons.camera_alt), onPressed: (){})
                                        ],
                                      ),
                                      contentPadding: EdgeInsets.all(5)
                                    ),
                                  )
                              )
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20, right: 5, left: 2),
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor: Color(0xFF128C7E),
                                child: IconButton(icon: Icon(sendButton ? Icons.send: Icons.mic, color: Colors.white), onPressed: (){
                                  if(sendButton){
                                    _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
                                    // sendMessage(_controller.text, widget.sourcechat.id, widget.chatModel.id);
                                    // messages.sendMessage(UserMessage.CreateMessage(_controller.text,1,3,51,DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now())));
                                    setState(() {

                                    });
                                    _scrollDown();
                                    _controller.clear();
                                    setState(() {
                                      sendButton = false;
                                    });
                                  }
                                },),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
