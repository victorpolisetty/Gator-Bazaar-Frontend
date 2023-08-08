
import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:student_shopping_v1/pages/userProfilePage.dart';
part 'adminProfileModel.g.dart';


@JsonSerializable(explicitToJson: true)
class AdminProfile extends ChangeNotifier {
  int? id = -1;
  String? name = "";
  String? emailId = "";
  bool? isAdmin = false;

  AdminProfile(int? id, String? name, String? emailId, bool? isAdmin){
    this.id = id;
    this.name = name;
    this.emailId = emailId;
    this.isAdmin = isAdmin;
  }

  factory AdminProfile.fromJson(Map<String, dynamic> parsedJson) {
    return AdminProfile(
      parsedJson['user']['id'] as int?,
      parsedJson['user']['name'] as String?,
      parsedJson['user']['emailId'] as String?,
      parsedJson['isAdmin'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => _$AdminProfileToJson(this);
}

class AdminProfileModel extends ChangeNotifier {
  List<AdminProfile> memberInGroupList = [];
  List<AdminProfile> adminInGroupList = [];
  List<AdminProfile> requestsInGroupList = [];

  int userIdFromDB = -1;
  int totalPages = 0;
  int currentPage = 1;

  Future<void> getMembersInGroup(int pageNum, int groupId) async {
    memberInGroupList.clear();
    await getProfileFromDb();
    totalPages = await getNextPageMembersInGroup(pageNum, groupId);
    notifyListeners();
  }

  Future<void> getRequestsInGroup(int pageNum, int groupId) async {
    requestsInGroupList.clear();
    await getProfileFromDb();
    totalPages = await getNextPageRequestsInGroup(pageNum, groupId);
    notifyListeners();
  }

  Future<void> getAdminsInGroup(int pageNum, int groupId) async {
    adminInGroupList.clear();
    await getProfileFromDb();
    totalPages = await getNextPageAdminsInGroup(pageNum, groupId);
    notifyListeners();
  }

  Future<int> getNextPageMembersInGroup(int pageNum, int groupId) async {
    // String firebaseId = currentUser!.uid;
    Map<String, dynamic> data;
    var url = Uri.parse('http://gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/profile/findAllProfilesInGroup/$groupId?size=10&page=$pageNum');
    http.Response response = await http.get(url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      var members = data['content'];
      totalPages = data["totalPages"];
      for (int i = 0; i < members.length; i++) {
        int? id = members[i]['user']['id'];
        String? name = members[i]['user']['name'];
        String? emailId = members[i]['user']['emailId'];
        bool? isAdmin = members[i]['isAdmin'];
        AdminProfile adminProfile = new AdminProfile(id, name, emailId, isAdmin);
        memberInGroupList.add(adminProfile);
      }
      return totalPages;
    } else {
      print (response.statusCode);
      return 0;
    }
  }

  Future<int> getNextPageRequestsInGroup(int pageNum, int groupId) async {
    try {
      Map<String, dynamic> data;
      var url = Uri.parse('http://gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/profile/findAllPendingRequestsInGroup/$groupId');
      http.Response response = await http.get(url, headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
        data = jsonDecode(response.body);
        var members = data['content'];
        totalPages = data["totalPages"];
        for (int i = 0; i < members.length; i++) {
          int? id = members[i]['id'];
          String? name = members[i]['name'];
          String? emailId = members[i]['emailId'];
          AdminProfile adminProfile = new AdminProfile(id, name, emailId, false);
          requestsInGroupList.add(adminProfile);
        }
        return totalPages;
      } else {
        print("Request failed with status: ${response.statusCode}");
        return 0;
      }
    } catch (e) {
      print("Error decoding JSON: $e");
      return 0;
    }
  }


  Future<int> getNextPageAdminsInGroup(int pageNum, int groupId) async {
    // String firebaseId = currentUser!.uid;
    Map<String, dynamic> data;
    var url = Uri.parse('http://gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/profile/findAllAdminProfilesInGroup/$groupId?size=10&page=$pageNum');
    http.Response response = await http.get(url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      var members = data['content'];
      totalPages = data["totalPages"];
      for (int i = 0; i < members.length; i++) {
        AdminProfile adminProfile = AdminProfile.fromJson(members[i]);
        adminInGroupList.add(adminProfile);
      }
      return totalPages;
    } else {
      print (response.statusCode);
      return 0;
    }
  }

  Future<void> getProfileFromDb() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if(currentUser != null) {
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

  Future<void> removeUserFromGroup(int? profileId, int? groupId) async {
    // String firebaseId = currentUser!.uid;
    Map<String, dynamic> data;
    var url = Uri.parse('http://gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/group/deleteGroupFromProfile/$profileId/$groupId');
    http.Response response = await http.delete(url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
    } else {
      print (response.statusCode);
    }
  }

  Future<bool> deleteGroupRequest(int profileId, int groupId) async {
    var url = Uri.parse('http://gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/group/deleteGroupReq/$profileId/$groupId');
    http.Response response = await http.delete(url, headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      print('Group request deleted successfully.');
      return true;
    } else if (response.statusCode == 404) {
      print('Group request not found.');
      return false;
    } else {
      print('Failed to delete group request. Status code: ${response.statusCode}');
      return false;
    }
  }

  Future<bool> acceptGroupRequest(int profileId, int groupId) async {
    var url = Uri.parse('http://gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/group/acceptGroupReq/$profileId/$groupId');
    http.Response response = await http.put(url, headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      print('Group request accepted successfully.');
      return true;
    } else if (response.statusCode == 404) {
      print('Group request not found.');
      return false;
    } else {
      print('Failed to accept group request. Status code: ${response.statusCode}');
      return false;
    }
  }



  Future<void> makeUserAdmin(int? profileId, int? groupId) async {
    // String firebaseId = currentUser!.uid;
    Map<String, dynamic> data;
    var url = Uri.parse('http://gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/profile/admin/$profileId/$groupId');
    http.Response response = await http.put(url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
    } else {
      print (response.statusCode);
    }
  }
}