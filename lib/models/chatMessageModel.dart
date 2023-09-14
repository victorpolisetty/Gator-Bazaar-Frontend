import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;

import '../api_utils.dart';
part 'chatMessageModel.g.dart';



@JsonSerializable()
class ChatMessageHome extends ChangeNotifier {
  String? message_text = "";
  String? recipient_profile_name = "";
  String? creator_profile_name = "";
  int? item_id = -1;
  int? creator_user_id = -1;
  int? recipient_user_id = -1;
  String createdAt = "";
  @JsonKey(ignore: true)
  int? current_user_id = -1;
  @JsonKey(ignore : true)
  Uint8List image = new Uint8List(0);
  bool? is_message_read = false;
  int? id = -1;




  ChatMessageHome(){}
  ChatMessageHome.NewChatMessage(String? message_text,
  String? recipient_profile_name,
  String? creator_profile_name,
  int? creator_user_id,
  int? recipient_user_id,
  String createdAt,
  int? current_user_id,
      int? item_id,
      // Uint8List? image,
      bool? is_message_read,
      int? id){
    this.message_text = message_text;
    this.recipient_profile_name = recipient_profile_name;
    this.creator_profile_name = creator_profile_name;
    this.creator_user_id = creator_user_id;
    this.recipient_user_id = recipient_user_id;
    this.createdAt = createdAt;
    this.current_user_id = current_user_id;
    this.item_id = item_id;
    // this.image = image;
    this.is_message_read = is_message_read;
    this.id = id;
  }


  factory ChatMessageHome.fromJson(Map<String, dynamic> parsedJson) => _$ChatMessageHomeFromJson(parsedJson);
  Map<String, dynamic> toJson() => _$ChatMessageHomeToJson(this);
}

class ChatMessageModel extends ChangeNotifier{
  /// Internal, private state of the cart. Stores the ids of each item.
  List<ChatMessageHome> ChatMessageHomeList = [];
  /// List of items in the cart.
  List<ChatMessageHome> get chatHome => ChatMessageHomeList;

  int userIdFromDB = -1;
  int totalPages = 0;

  ChatMessageModel() {
  }


  Future<bool?> initNextCatPage(int pageNum) async {
    ChatMessageHomeList.clear();
    await getProfileFromDb();
    await getNextPageChatHistory(pageNum);
    await fetchAllProfilePictures();
    return false;
  }

  Future<Uint8List> fetchProfilePictureForUser(int userId) async {
    var profilePictureUrl = ApiUtils.buildApiUrl('/profilePicture/profileId/$userId');
    http.Response profileResponse = await http.get(profilePictureUrl);

    if (profileResponse.statusCode == 200) {
      return profileResponse.bodyBytes;
    } else {
      print(profileResponse.statusCode);
      return Uint8List(0);
    }
  }

  Future<void> fetchAllProfilePictures() async {
    for (int i = 0; i < ChatMessageHomeList.length; i++) {
      int? otherUserId = ChatMessageHomeList[i].current_user_id ==
          ChatMessageHomeList[i].creator_user_id
          ? ChatMessageHomeList[i].recipient_user_id
          : ChatMessageHomeList[i].creator_user_id;

      var profilePictureUrl = ApiUtils.buildApiUrl('/profilePicture/profileId/$otherUserId');
      http.Response profileResponse = await http.get(profilePictureUrl);
      if (profileResponse.statusCode == 200) {
        if (!profileResponse.bodyBytes.isEmpty) {
          ChatMessageHomeList[i].image = profileResponse.bodyBytes;
        } else {
          ChatMessageHomeList[i].image = Uint8List(0);
        }
        // notifyListeners();
      } else {
        print(profileResponse.statusCode);
      }
    }
  }


  Future<int> getNextPageChatHistory(int pageNum) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String? firebaseId = currentUser.uid;

      var url = ApiUtils.buildApiUrl('/messages/profile/chathome/$firebaseId?page=$pageNum&size=5&sort=updatedAt,asc');
      Map<String, dynamic> data;
      http.Response response = await http.get(
          url, headers: {"Accept": "application/json"});
      if (response.statusCode == 200) {
        String responseJson = Utf8Decoder().convert(response.bodyBytes);
        data = json.decode(responseJson);
        var chatHomes = data['content'];
        totalPages = data['totalPages'];
        // if (chatHomes.length == ChatMessageHomeList.length) {
        //   ChatMessageHomeList.clear();
        // }
        for (int i = 0; i < chatHomes.length; i++) {
          ChatMessageHome chatMessage = ChatMessageHome.fromJson(chatHomes[i]);

          chatMessage.current_user_id = userIdFromDB;
          int? otherUserId = chatMessage.current_user_id ==
              chatMessage.creator_user_id
              ? chatMessage.recipient_user_id
              : chatMessage.creator_user_id;

          // Use pre-fetched profile pictures
          // Uint8List profilePictureBytes = profilePictures[otherUserId] ?? Uint8List(0);

          // if (!profilePictureBytes.isEmpty) {
          //   chatMessage.image = profilePictureBytes;
          // }

          ChatMessageHomeList.add(chatMessage);
        }
        return totalPages;
      } else {
        print(response.statusCode);
        return -1;
      }
    }
    print("Couldn't find firebaseId");
    return -1;
  }





  Future<void> getProfileFromDb() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String? firebaseId = currentUser.uid;
      Map<String, dynamic> data;
      var url = ApiUtils.buildApiUrl('/profiles/$firebaseId'); // TODO -  call the recentItem service when it is built
      http.Response response = await http.get(
          url, headers: {"Accept": "application/json"});
      if (response.statusCode == 200) {
        // data.map<Item>((json) => Item.fromJson(json)).toList();
        data = jsonDecode(response.body);
        userIdFromDB = data['id'];
      } else {
        print(response.statusCode);
      }
    }
  }

  Future<void> changeLatestMessageToRead(int? userMessageId)  async {
    var url = ApiUtils.buildApiUrl('/message/readStatus/$userMessageId');
    final http.Response response =  await http.put(url
        , headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        }
    );

    if (response.statusCode == 200) {
    } else {
      print(response.statusCode);
    }
    //  });
  }

  int getCurrentUserDbId(){
    return userIdFromDB;
  }

  Future<void> refreshChatHistory() async {
    await getNextPageChatHistory(1); // Fetch the latest page of messages
    await fetchAllProfilePictures(); // Update profile pictures if needed
  }

}

toNull(_) => null;