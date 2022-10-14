// import 'dart:_http';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;
part 'messageModel.g.dart';

const String BASE_URI = 'http://studentshopspringbackend-env.eba-b2yvpimm.us-east-1.elasticbeanstalk.com/';
const String ITEMS_IMAGES_URL = '${BASE_URI}itemImages/';  // append id of image to fetch



@JsonSerializable()
class UserMessage extends ChangeNotifier {
  String? message_text = "";
  String? recipient_profile_name = "";
  String? creator_profile_name = "";
  int? creator_user_id = -1;
  int? recipient_user_id = -1;
  int? item_id = -1;
  String createdAt = "";

  UserMessage(){}

  UserMessage.CreateMessage(String? messageText, int? creator_user_id, int? recipient_user_id, int? item_id, String createdAt, String? recipient_profile_name) {
    this.recipient_profile_name = recipient_profile_name;
    this.message_text = messageText;
    this.creator_user_id = creator_user_id;
    this.recipient_user_id = recipient_user_id;
    this.item_id = item_id;
    this.createdAt = createdAt;
  }

  factory UserMessage.fromJson(Map<String, dynamic> parsedJson) => _$UserMessageFromJson(parsedJson);
  Map<String, dynamic> toJson() => _$UserMessageToJson(this);
}

class MessageModel extends ChangeNotifier{
  /// Internal, private state of the cart. Stores the ids of each item.
  List<UserMessage> messageList = [];

  int totalPages = 0;
  int currentPage = 1;
  int lastMessageItemId = -1;
  String? recipientDeviceToken = "";
  String? currentUserName = FirebaseAuth.instance.currentUser?.displayName;

  /// List of items in the cart.
  List<UserMessage> get msgs => messageList;

  MessageModel(){}
  // MessageModel() {
  //   var initFuture = init();
  //   initFuture.then((voidValue) {
  //     // state = HomeScreenModelState.initialized;
  //     notifyListeners();
  //   });
  // }
  // MessageModel.GetMessages(int creatorId, int recipientId) {
  //   this.creatorId = creatorId;
  //   this.recipientId = recipientId;
  // }

  Future<void> _getMessagesHelper(int creatorId, int recipientId) async {
    messageList.clear();
    await getMessages(creatorId, recipientId);
    notifyListeners();

}

  void getMessagesHelper(int creatorId, int recipientId) {
    var initFuture = _getMessagesHelper(creatorId, recipientId);
    initFuture.then((voidValue) {
      // state = HomeScreenModelState.initialized;
      notifyListeners();
    });
  }

  //TODO
  Future<void> getMessages(int creatorId, int recipientId) async {
    Map<String, dynamic> map;
    var url = Uri.parse('http://studentshopspringbackend-env.eba-b2yvpimm.us-east-1.elasticbeanstalk.com/messages/profile?creatorId=$creatorId&recipientId=$recipientId');
    http.Response response = await http.get(url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      // data.map<Item>((json) => Item.fromJson(json)).toList();
      String responseJson = Utf8Decoder().convert(response.bodyBytes);
      map = json.decode(responseJson);
      print(response.body);
      // map = jsonDecode(response.body);
      messageList = List.from(map['content']).map((msg)=>UserMessage.fromJson(msg)).toList();
      if(messageList.length != 0){
        lastMessageItemId = messageList[0].item_id!;
      }
      totalPages = map['totalPages'];
    } else {
      print (response.statusCode);
    }
  }

  Future<void> sendMessage(UserMessage message)  async {
    Map<String, dynamic> myjson = message.toJson();
    Map<String, dynamic> myjsonNew = {};

    myjsonNew["message_text"] = myjson["message_text"];
    myjsonNew["creator_user_id"] = myjson["creator_user_id"];
    myjsonNew["recipient_user_id"] = myjson["recipient_user_id"];
    myjsonNew["item_id"] = myjson["item_id"];

    if(myjsonNew["item_id"] == -1 && lastMessageItemId != -1){
      myjsonNew["item_id"] = lastMessageItemId;
    }

    var url = Uri.parse('http://studentshopspringbackend-env.eba-b2yvpimm.us-east-1.elasticbeanstalk.com/messages');
    var tmpObj =  json.encode(myjsonNew);
    // var tmpObj =  json.encode(message.toJson());
    final http.Response response =  await http.post(url
        , headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        }
        , body: tmpObj
    );
    //  .then((response) {
    if (response.statusCode == 200) {
      messageList.insert(0,message);
      await sendMessageNotification(myjsonNew["message_text"], myjsonNew["creator_user_id"], myjsonNew["recipient_user_id"]);
      notifyListeners();
    } else {
      print(response.statusCode);
      throw Future.error("Future did not work for sendMessage function in messageModel");
    }
    //  });
  }

  Future<void> sendMessageNotification(String? messageText, int? creatorUserId, int? recipientUserId) async {
    await getDeviceToken(recipientUserId).then((value) => sendMessageNotificationHelper(messageText, creatorUserId));
  }

  Future<void> getDeviceToken(int? recipientUserId) async {
    Map<String, dynamic> data;
    // var url = Uri.parse('http://studentshopspringbackend-env.eba-b2yvpimm.us-east-1.elasticbeanstalk.com/profiles/id/1'); // TODO -  call the recentItem service when it is built

    var url = Uri.parse('http://studentshopspringbackend-env.eba-b2yvpimm.us-east-1.elasticbeanstalk.com/profiles/id/$recipientUserId'); // TODO -  call the recentItem service when it is built
    http.Response response = await http.get(
        url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      // data.map<Item>((json) => Item.fromJson(json)).toList();
      data = jsonDecode(response.body);
      recipientDeviceToken = data['deviceToken'];
      print(response.statusCode);
    } else {
      print(response.statusCode);
    }
  }

  Future<void> sendMessageNotificationHelper(String? messageText, int? creatorUserId) async {
    // final HttpClient httpClient = HttpClient();
    final String fcmUrl = 'https://fcm.googleapis.com/fcm/send';
    final fcmKey = "AAAA8gRWlF0:APA91bH8WJNgwnlcHtC5nHIiW78x_HJxqZlLu64pAFRWpE1uwmWb69tqcbvE4Yuai0fA0S35OF_pg1gJGv4_jNw6y_F0Ckh6aJ44w8sH0nHt8SeyWcBy3BsyCKCfADx_AHxNnHkvijIP";
    final fcmToken = recipientDeviceToken;

    var headers = {'Content-Type': 'application/json', 'Authorization': 'key=$fcmKey'};
    var request = http.Request('POST', Uri.parse(fcmUrl));
    // request.body = '''{"to":"dX3OvDFxl07snDMXDYnxNh:APA91bHFeZFIXQSEBFynTmy0VpF_HXm1nNaupt80sSuwrrm4bSVOprU8KO6fnoRpCMYp_7U4PqDvGO7P_IF0pf_hC3fvRdn3I4vQ2kLuPO6HkK5H2xRJM4lTM617tDSoOuK8ZPJO1IJG","priority":"high","notification":{"title":"Victor Polisetty","body":"$messageText","sound": "default"}}''';
    request.body = '''{"to":"$fcmToken","priority":"high","notification":{"title":"$currentUserName","body":"$messageText","sound": "default"}}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
    //
  }

  Future<bool?> initNextMessagePage(int pageNum) async {
    await getNextPage(pageNum);
    return false;
  }

  Future<int> getNextPage(int pageNum) async {
    Map<String, dynamic> map;


    var url = Uri.parse('http://studentshopspringbackend-env.eba-b2yvpimm.us-east-1.elasticbeanstalk.com/messages/profile?creatorId=1&recipientId=3&page=$pageNum');
    http.Response response = await http.get(
        url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      print(response.body);
      map = jsonDecode(response.body);
      final messages = map['content'];
      totalPages = map['totalPages'];
      for (int i = 0; i < messages.length; i++) {
        UserMessage msg = UserMessage.fromJson(messages[i]);
        messageList.add(msg);
        //Provider.of<RecentItemModel>(context, listen: false).add(itm);


        // for (int imgId in itm.itemImageList) {
        //   var url = Uri.parse(
        //       'http://localhost:8080/categories/1/items'); // TODO -  call the recentItem service when it is built
        // }
      }
      return totalPages;

      //     notifyListeners();
      //print(categoryItems);
    } else {
      print(response.statusCode);
      return -1;
    }
  }



  /// Adds [item] to cart. This is the only way to modify the cart from outside.
  // void add(UserMessage msg) {
  //   messageList.insert(0, msg);
  //   // This line tells [Model] that it should rebuild the widgets that
  //   // depend on it.
  //   notifyListeners();
  // }
}

toNull(_) => null;





