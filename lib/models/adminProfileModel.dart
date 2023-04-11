
import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;
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

  factory AdminProfile.fromJson(Map<String, dynamic> parsedJson) => _$AdminProfileFromJson(parsedJson);
  Map<String, dynamic> toJson() => _$AdminProfileToJson(this);
}

class AdminProfileModel extends ChangeNotifier {
  List<AdminProfile> memberInGroupList = [];
  List<AdminProfile> adminInGroupList = [];
  int userIdFromDB = -1;
  int totalPages = 0;
  int currentPage = 1;
  User? currentUser = FirebaseAuth.instance.currentUser;

  Future<void> getMembersInGroup(int pageNum, int groupId) async {
    memberInGroupList.clear();
    await getProfileFromDb(currentUser!.uid.toString());
    totalPages = await getNextPageMembersInGroup(pageNum, groupId);
    notifyListeners();
  }

  Future<void> getAdminsInGroup(int pageNum, int groupId) async {
    adminInGroupList.clear();
    await getProfileFromDb(currentUser!.uid.toString());
    totalPages = await getNextPageAdminsInGroup(pageNum, groupId);
    notifyListeners();
  }

  Future<int> getNextPageMembersInGroup(int pageNum, int groupId) async {
    // String firebaseId = currentUser!.uid;
    Map<String, dynamic> data;
    var url = Uri.parse('http://localhost:5000/profile/findAllProfilesInGroup/$groupId?size=10&page=$pageNum');
    http.Response response = await http.get(url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      // data.map<Item>((json) => Item.fromJson(json)).toList();
      print(response.body);
      data = jsonDecode(response.body);
      // categoryImage = response.bodyBytes;
      var members = data['content'];
      totalPages = data["totalPages"];
      for (int i = 0; i < members.length; i++) {
        int? id = members[i]['user']['id'];
        String? name = members[i]['user']['name'];
        String? emailId = members[i]['user']['emailId'];
        bool? isAdmin = members[i]['isAdmin'];
        AdminProfile adminProfile = new AdminProfile(id, name, emailId, isAdmin);
        // AdminProfile adminProfile = AdminProfile.fromJson(members[i]);
        memberInGroupList.add(adminProfile);
      }
      print("DONE");
      return totalPages;
    } else {
      print (response.statusCode);
      return 0;
    }
  }

  Future<int> getNextPageAdminsInGroup(int pageNum, int groupId) async {
    // String firebaseId = currentUser!.uid;
    Map<String, dynamic> data;
    var url = Uri.parse('http://localhost:5000/profile/findAllAdminProfilesInGroup/$groupId?size=10&page=$pageNum');
    http.Response response = await http.get(url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      // data.map<Item>((json) => Item.fromJson(json)).toList();
      print(response.body);
      data = jsonDecode(response.body);
      // categoryImage = response.bodyBytes;
      var members = data['content'];
      totalPages = data["totalPages"];
      for (int i = 0; i < members.length; i++) {
        AdminProfile adminProfile = AdminProfile.fromJson(members[i]);
        adminInGroupList.add(adminProfile);
      }
      print("DONE");
      return totalPages;
    } else {
      print (response.statusCode);
      return 0;
    }
  }

  Future<void> getProfileFromDb(String? firebaseid) async {
    Map<String, dynamic> data;
    var url = Uri.parse('http://Gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/profiles/$firebaseid'); // TODO -  call the recentItem service when it is built
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

  Future<void> removeUserFromGroup(int? profileId, int? groupId) async {
    // String firebaseId = currentUser!.uid;
    Map<String, dynamic> data;
    var url = Uri.parse('http://localhost:5000/group/deleteGroupFromProfile/$profileId/$groupId');
    http.Response response = await http.delete(url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      // data.map<Item>((json) => Item.fromJson(json)).toList();
      print(response.body);
    } else {
      print (response.statusCode);
    }
  }

  Future<void> makeUserAdmin(int? profileId, int? groupId) async {
    // String firebaseId = currentUser!.uid;
    Map<String, dynamic> data;
    var url = Uri.parse('http://localhost:5000/profile/admin/$profileId/$groupId');
    http.Response response = await http.put(url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      // data.map<Item>((json) => Item.fromJson(json)).toList();
      print(response.body);
    } else {
      print (response.statusCode);
    }
  }
}