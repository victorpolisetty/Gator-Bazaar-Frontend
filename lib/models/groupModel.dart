import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;

import '../api_utils.dart';
part 'groupModel.g.dart';



@JsonSerializable(explicitToJson: true)
class Group extends ChangeNotifier {
  int? id = -1;
  String? name = "";
  @JsonKey(ignore: true)
  Uint8List? imageURL = new Uint8List(0);

  Group(){}

  factory Group.fromJson(Map<String, dynamic> parsedJson) => _$GroupFromJson(parsedJson);
  Map<String, dynamic> toJson() => _$GroupToJson(this);
}

class GroupModel extends ChangeNotifier{
  /// Internal, private state of the cart. Stores the ids of each item.
  List<Group> groupListMyGroups = [];
  List<Group> groupListFindGroups = [];
  List<Group> groupListAdminGroups = [];

  /// List of items in the cart.
  List<Group> get group => groupListMyGroups;
  List<Group> get group1 => groupListFindGroups;
  List<Group> get group2 => groupListAdminGroups;

  int userIdFromDB = -1;
  int totalPages = 0;
  int currentPage = 1;


  GroupModel() {}

  Future<void> getGroupsUserInAndImages(int pageNum) async {
    groupListMyGroups.clear();
    await getProfileFromDb();
    totalPages = await getNextPageGroupsUserIn(pageNum);
    await getImageForGroupMyGroups();
    notifyListeners();
  }

  Future<void> getGroupsUserNotInAndImages(int pageNum) async {
    groupListFindGroups.clear();
    await getProfileFromDb();
    totalPages = await getNextPageGroupsUserNotIn(pageNum);
    await getImageForGroupFindGroups();
    notifyListeners();
  }

  Future<void> getGroupsUserInAndImagesAdmin(int pageNum) async {
    groupListAdminGroups.clear();
    await getProfileFromDb();
    totalPages = await getNextPageGroupsAdminGroups(pageNum);
    await getImageForGroupAdminGroups();
    notifyListeners();
  }

  Future<void> packagedDeleteGroupFromProfile(int? groupId) async {
    await getProfileFromDb().then((value) => deleteGroupFromProfile(userIdFromDB, groupId));
    notifyListeners();
  }

  Future<void> deleteGroupFromProfile(int? profileId, int? groupId) async {
    var url = ApiUtils.buildApiUrl(
        '/group/deleteGroupFromProfile/$profileId/$groupId');
    http.Response response = await http.delete(
        url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
    } else {
      print(response.statusCode);
    }
  }



  //TODO
  Future<void> getGroupsMyGroups() async {
    Map<String, dynamic> data;
    var url = ApiUtils.buildApiUrl('/group/getAllGroups');
    http.Response response = await http.get(url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      var groups = data['content'];
      for (int i = 0; i < groups.length; i++) {
        Group group = Group.fromJson(groups[i]);
        groupListMyGroups.add(group);
      }
    } else {
      print (response.statusCode);
    }
  }

  Future<void> getGroupsFindGroups() async {
    Map<String, dynamic> data;
    var url = ApiUtils.buildApiUrl('/group/getAllGroups');
    http.Response response = await http.get(url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      var groups = data['content'];
      for (int i = 0; i < groups.length; i++) {
        Group group = Group.fromJson(groups[i]);
        groupListFindGroups.add(group);
      }
    } else {
      print (response.statusCode);
    }
  }

  //TODO
  Future<int> getNextPageGroupsAdminGroups(int pageNum) async {
    // String firebaseId = currentUser!.uid;
    Map<String, dynamic> data;
    var url = ApiUtils.buildApiUrl('/group/getGroupsProfileIsAdmin/$userIdFromDB?size=10&page=$pageNum');
    http.Response response = await http.get(url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      var groups = data['content'];
      for (int i = 0; i < groups.length; i++) {
        Group group = Group.fromJson(groups[i]);
        groupListAdminGroups.add(group);
      }
      return totalPages;
    } else {
      print (response.statusCode);
      return 0;
    }
  }

  //TODO
  Future<int> getNextPageGroupsUserIn(int pageNum) async {
    // String firebaseId = currentUser!.uid;
    Map<String, dynamic> data;
    var url = ApiUtils.buildApiUrl('/group/getGroupsInProfile/$userIdFromDB?size=10&page=$pageNum');
    http.Response response = await http.get(url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      // data.map<Item>((json) => Item.fromJson(json)).toList();
      data = jsonDecode(response.body);
      // categoryImage = response.bodyBytes;
      var groups = data['content'];
      var totalPages = data['totalPages'];
      for (int i = 0; i < groups.length; i++) {
        Group group = Group.fromJson(groups[i]);
        groupListMyGroups.add(group);
      }
      return totalPages;
    } else {
      print (response.statusCode);
      return 0;
    }
  }

  //TODO
  Future<int> getNextPageGroupsUserNotIn(int pageNum) async {
    // String firebaseId = currentUser!.uid;
    Map<String, dynamic> data;
    var url = ApiUtils.buildApiUrl('/group/getGroupsNotInProfile/$userIdFromDB?size=10&page=$pageNum');
    http.Response response = await http.get(url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      var groups = data['content'];
      var totalPages = data['totalPages'];
      for (int i = 0; i < groups.length; i++) {
        Group group = Group.fromJson(groups[i]);
        groupListFindGroups.add(group);
      }
      return totalPages;
    } else {
      print (response.statusCode);
      return 0;
    }
  }


  Future<void> getImageForGroupMyGroups() async {
    Uint8List data = new Uint8List(0);
    for (int i = 0; i < groupListMyGroups.length; i++) {
      int? groupId = groupListMyGroups[i].id;
      String urlString = "/group/getGroupImageById/$groupId";
      var url = ApiUtils.buildApiUrl(urlString);
      http.Response response = await http.get(url, headers: {"Accept": "application/json"});
      if (response.statusCode == 200) {
        data = response.bodyBytes;
        groupListMyGroups[i].imageURL = data;
      } else {
        print (response.statusCode);
      }
    }
  }

  Future<void> getImageForGroupFindGroups() async {
    Uint8List data = new Uint8List(0);
    for (int i = 0; i < groupListFindGroups.length; i++) {
      int? groupId = groupListFindGroups[i].id;
      String urlString = "/group/getGroupImageById/$groupId";
      var url = ApiUtils.buildApiUrl(urlString);
      http.Response response = await http.get(
          url, headers: {"Accept": "application/json"});
      if (response.statusCode == 200) {
        data = response.bodyBytes;
        groupListFindGroups[i].imageURL = data;
      } else {
        print (response.statusCode);
      }
    }
  }

  Future<void> getImageForGroupAdminGroups() async {
    Uint8List data = new Uint8List(0);
    for (int i = 0; i < groupListAdminGroups.length; i++) {
      int? groupId = groupListAdminGroups[i].id;
      String urlString = "/group/getGroupImageById/$groupId";
      var url = ApiUtils.buildApiUrl(urlString);
      http.Response response = await http.get(
          url, headers: {"Accept": "application/json"});
      if (response.statusCode == 200) {
        data = response.bodyBytes;
        groupListAdminGroups[i].imageURL = data;
      } else {
        print (response.statusCode);
      }
    }
  }


  Future<void> getProfileFromDb() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if(currentUser != null) {
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
}

toNull(_) => null;