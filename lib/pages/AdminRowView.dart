import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_shopping_v1/models/adminProfileModel.dart';
import 'package:http/http.dart' as http;
import '../api_utils.dart';
import '../models/groupModel.dart';


class AdminRowView extends StatefulWidget {
  final AdminProfile profile;
  final Group group;
  final String uniqueIdentifier;
  final VoidCallback onUserRemoved;

  const AdminRowView({
    Key? key,
    required this.profile,
    required this.group,
    required this.uniqueIdentifier,
    required this.onUserRemoved,
  }) : super(key: key);

  @override
  State<AdminRowView> createState() => _AdminRowViewState();
}

class _AdminRowViewState extends State<AdminRowView> {
  @override
  void initState() {
    User? currentUser = FirebaseAuth.instance.currentUser;
    getProfileFromDb(currentUser?.uid);
    super.initState();
  }

  int userIdFromDb = -1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Text(widget.profile.name!, style: TextStyle(color: Colors.white)),
          ),
          // IconButton(
          //   icon: Icon(Icons.delete),
          //   onPressed: () {
          //     showAlertDialogRequestGroup(context, widget.profile.id!, widget.group.id!, widget.profile.name);
          //   },
          // ),
          // IconButton(
          //   icon: Icon(Icons.admin_panel_settings_outlined),
          //   onPressed: () {
          //     // Implement delete functionality here
          //   },
          // ),
        ],
      ),
    );
  }

  showAlertDialogRequestGroup(BuildContext context, int profileId, int groupId, String? profileName) {
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed: () async {
        Navigator.of(context).pop();
        await Provider.of<AdminProfileModel>(context, listen: false).removeUserFromGroup(profileId, groupId);
        profileId == Provider.of<AdminProfileModel>(context, listen: false).userIdFromDB ? Navigator.of(context).pop() : null;
        widget.onUserRemoved();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Remove Member"),
      content: Text("Are you sure you want to remove this user from the group: $profileName"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> getProfileFromDb(String? firebaseid) async {
    Map<String, dynamic> data;
    var url = ApiUtils.buildApiUrl('/profiles/$firebaseid'); // TODO -  call the recentItem service when it is built
    http.Response response = await http.get(
        url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      userIdFromDb = data['id'];
    } else {
      print(response.statusCode);
    }
  }

}