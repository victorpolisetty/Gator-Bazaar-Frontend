import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:student_shopping_v1/buyerhome.dart';
import 'package:student_shopping_v1/pages/SeeSellerDetailsAsBuyer.dart';
import '../../models/chatMessageModel.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../pages/itemDetailPage.dart';
import '../Screens/ChatDetail.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  final PagingController<int, ChatMessageHome> _pagingController =
  PagingController(firstPageKey: 0);
  int totalPages = 0;

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey, context);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey, BuildContext context) async {
    try {
      await Provider.of<ChatMessageModel>(context, listen: false).initNextCatPage(pageKey);
      totalPages = Provider.of<ChatMessageModel>(context, listen: false).totalPages;
      if (mounted) {
        final isLastPage = (totalPages - 1) == pageKey;

        if (isLastPage) {
          _pagingController.appendLastPage(
              Provider.of<ChatMessageModel>(context, listen: false).chatHome);
        } else {
          final int? nextPageKey = pageKey + 1;
          _pagingController.appendPage(
              Provider.of<ChatMessageModel>(context, listen: false).chatHome,
              nextPageKey);
        }
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }


  @override
  void dispose() {
    super.dispose();
    if(!mounted) {
      _pagingController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Column(
          children: [
            Text(
              "Messaging",
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 4), // Add a small gap between the titles
            Text(
              "Pull down to refresh",
              style: TextStyle(color: Colors.grey, fontSize: 10.sp),
            ),
          ],
        ),
      ),
      body: Container(
        color: Color(0xFF333333),
        child: RefreshIndicator(
          onRefresh: () => Future.sync(() => _pagingController.refresh()),
          child: Consumer<ChatMessageModel>(
            builder: (context, chatMessageModel, child) {
              return PagedListView(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<ChatMessageHome>(
                  firstPageProgressIndicatorBuilder: (_) =>
                      Center(child: spinkit),
                  newPageProgressIndicatorBuilder: (_) =>
                      Center(child: spinkit),
                  noItemsFoundIndicatorBuilder: (_) => Center(
                    child: Text(
                      "No Messages Found.",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  itemBuilder: (BuildContext context, chatHomeObject, int index) {
                    return GestureDetector(
                      onTap: () async {
                        if (chatHomeObject.id != -1 &&
                            chatHomeObject.is_message_read ==
                                false) {
                          ChatMessageModel chatMessageModel =
                          Provider.of<ChatMessageModel>(context,
                              listen: false);
                          await chatMessageModel.changeLatestMessageToRead(
                              chatHomeObject.id).then((value) => _pagingController.refresh());
                        }
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => ChatDetailPage(
                              chatProfile: chatHomeObject,
                              currentUserDbId:
                              chatHomeObject.current_user_id!, sellerImage: chatHomeObject.image,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 10,
                          bottom: 10,
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  chatHomeObject
                                      .is_message_read! ||
                                      chatHomeObject
                                          .creator_user_id ==
                                          chatHomeObject.current_user_id
                                      ? SizedBox()
                                      : Icon(
                                    Icons.circle,
                                    color: Colors.blue.shade400,
                                    size: 15,
                                  ),
                                  SizedBox(),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) => SeeSellerDetailsAsBuyer(
                                            chatHomeObject),
                                        ),
                                      );
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      child: ClipOval( // Use ClipOval to create a circular clipping for the image
                                        child: chatHomeObject.image.isEmpty
                                            ? SvgPicture.asset(
                                          "assets/personIcon.svg",
                                          color: Colors.white,
                                          height: 36,
                                        )
                                            : Image.memory(
                                          chatHomeObject.image,
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      radius: 20,
                                    ),

                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: Container(
                                      color: Colors.transparent,
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            chatHomeObject
                                                .current_user_id ==
                                                chatHomeObject
                                                    .recipient_user_id
                                                ? chatHomeObject
                                                .creator_profile_name
                                                .toString()
                                                : chatHomeObject
                                                .recipient_profile_name
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 6,
                                          ),
                                          Text(

                                            chatHomeObject
                                                .message_text
                                                .toString()
                                                .length <=
                                                20
                                                ? chatHomeObject
                                                .message_text
                                                .toString()
                                                : '${chatHomeObject.message_text.toString().substring(0, 20)}...',
                                            maxLines: 1, // Limit to a single line
                                            overflow: TextOverflow.ellipsis, // Show ellipsis if the content overflows
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey,
                                              fontWeight: chatHomeObject
                                                  .is_message_read! ||
                                                  _pagingController.itemList![
                                                  index]
                                                      .creator_user_id ==
                                                      chatHomeObject.current_user_id
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
                                  .format(DateTime.parse(chatHomeObject.createdAt)
                                  .toLocal())
                                  .toString(),
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: false
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

