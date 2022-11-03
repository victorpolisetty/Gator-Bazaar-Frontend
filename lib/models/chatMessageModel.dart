import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;
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
    this.is_message_read = is_message_read;
    this.id = id;
  }


  factory ChatMessageHome.fromJson(Map<String, dynamic> parsedJson) => _$ChatMessageHomeFromJson(parsedJson);
  Map<String, dynamic> toJson() => _$ChatMessageHomeToJson(this);
}

class ChatMessageModel extends ChangeNotifier{
  /// Internal, private state of the cart. Stores the ids of each item.
  List<ChatMessageHome> ChatMessageHomeList = [];

  @JsonKey(ignore: true)
  User? currentUser = FirebaseAuth.instance.currentUser;
  /// List of items in the cart.
  List<ChatMessageHome> get chatHome => ChatMessageHomeList;

  int userIdFromDB = -1;

  ChatMessageModel() {
    // var initFuture = init();
    // initFuture.then((voidValue) {
    //   // state = HomeScreenModelState.initialized;
    //   notifyListeners();
    // });
  }

  Future<void> _getChatHomeHelper() async {
    ChatMessageHomeList.clear();
    await getProfileFromDb(currentUser!.uid);
    await getChatHistory();
    notifyListeners();

  }

  void getChatHomeHelper() {
    var initFuture = _getChatHomeHelper();
    initFuture.then((voidValue) {
      // state = HomeScreenModelState.initialized;
      notifyListeners();
    });
  }



  //TODO
  Future<void> getChatHistory() async {
    String firebaseId = currentUser!.uid;
    List<dynamic> data;
    var url = Uri.parse('http://Gatorbazaarbackendtested2-env.eba-g27rcqgs.us-east-1.elasticbeanstalk.com/messages/profile/chathome/$firebaseId');

    // var url = Uri.parse('http://localhost:8080/messages/profile/chathome/$firebaseId');
    // var url = Uri.parse('http://localhost:8080/messages/profile/chathome/$firebaseId');
    http.Response response = await http.get(url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      // data.map<Item>((json) => Item.fromJson(json)).toList();
      print(response.body);
      String responseJson = Utf8Decoder().convert(response.bodyBytes);
      data = json.decode(responseJson);
      for (int i = 0; i < data.length; i++) {
        ChatMessageHome chatMessage = ChatMessageHome.fromJson(data[i]);
        chatMessage.current_user_id = userIdFromDB;
        ChatMessageHomeList.add(chatMessage);
      }
    } else {
      print (response.statusCode);
    }
  }

  Future<void> getProfileFromDb(String? firebaseid) async {
    Map<String, dynamic> data;
    var url = Uri.parse('http://Gatorbazaarbackendtested2-env.eba-g27rcqgs.us-east-1.elasticbeanstalk.com/profiles/$firebaseid'); // TODO -  call the recentItem service when it is built
    http.Response response = await http.get(
        url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      // data.map<Item>((json) => Item.fromJson(json)).toList();
      data = jsonDecode(response.body);
      userIdFromDB = data['id'];

      print(response.statusCode);
    } else {
      print(response.statusCode);
    }
  }

  Future<void> changeLatestMessageToRead(int? userMessageId)  async {
    Map<String, dynamic> data;
    var url = Uri.parse('http://Gatorbazaarbackendtested2-env.eba-g27rcqgs.us-east-1.elasticbeanstalk.com/message/readStatus/$userMessageId');
    // var tmpObj =  json.encode(itm.toJson());
    final http.Response response =  await http.put(url
        , headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        }
      // , body: tmpObj
    );

    //  .then((response) {
    if (response.statusCode == 200) {
      print(response.statusCode);
    } else {
      print(response.statusCode);
    }
    //  });
  }

  int getCurrentUserDbId(){
    return userIdFromDB;
  }

}

toNull(_) => null;