import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;
part 'groupRequestModel.g.dart';

@JsonSerializable(explicitToJson: true)
class GroupRequest extends ChangeNotifier {
  int? id = -1;
  int? group_id = -1;
  int? profile_id = -1;

  GroupRequest(){}

  factory GroupRequest.fromJson(Map<String, dynamic> parsedJson) => _$GroupRequestFromJson(parsedJson);
  Map<String, dynamic> toJson() => _$GroupRequestToJson(this);
}

class GroupRequestModel extends ChangeNotifier{
  List<GroupRequest> groupRequestList = [];
  List<GroupRequest> get groupRequest => groupRequestList;

  int userIdFromDB = -1;
  int totalPages = 0;
  int currentPage = 1;

  GroupRequestModel(){}

  Future<void> getGroupRequestsPrfId() async {
    groupRequestList.clear();
    await getProfileFromDb().then((value) =>
    getGroupRequestsByProfileId(userIdFromDB));
    notifyListeners();
  }

  Future<void> getProfileFromDb() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String? firebaseId = currentUser.uid;
      Map<String, dynamic> data;
      var url = Uri.parse('http://Gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/profiles/$firebaseId'); // TODO -  call the recentItem service when it is built
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

  Future<void> postGroupRequest(int? groupId)  async {
    Map<String, dynamic> data;
    //TODO: need to call this somewhere
    var url = Uri.parse('http://gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/group/addGroupReq/$userIdFromDB/$groupId');
    final http.Response response =  await http.post(url
        , headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        }
    );
    if (response.statusCode == 200) {
    } else {
      print(response.statusCode);
    }
  }

  Future<int> getGroupRequestsByProfileId(int? profileId) async {
    Map<String, dynamic> data;
    var url = Uri.parse('http://gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/group/checkAllGroupReq/$profileId'); // TODO -  call the recentItem service when it is built
    http.Response response = await http.get(
        url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      // data.map<Item>((json) => Item.fromJson(json)).toList();
      data = jsonDecode(response.body);

      var groupRequests = data['content'];
      var totalPages = data['totalPages'];

      for (int i = 0; i  < groupRequests.length; i++) {
        GroupRequest groupRequest = GroupRequest.fromJson(groupRequests[i]);
        groupRequestList.add(groupRequest);
      }
      return totalPages;
    } else {
      print(response.statusCode);
      return 0;
    }
  }


}


