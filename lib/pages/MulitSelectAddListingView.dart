import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import '../api_utils.dart';
import '../models/groupModel.dart';


class MultiSelectAddListingView extends StatefulWidget {
  final Group group;
  final String uniqueIdentifier;
  final ValueChanged<int> onCheckboxChanged;
  final List<int> selectedGroupIds;

  const MultiSelectAddListingView({
    Key? key,
    required this.uniqueIdentifier,
    required this.group,
    required this.onCheckboxChanged,
    required this.selectedGroupIds,

  }) : super(key: key);

  @override
  State<MultiSelectAddListingView> createState() => _MultiSelectAddListingViewState();
}

class _MultiSelectAddListingViewState extends State<MultiSelectAddListingView> {
  @override
  void initState() {
    User? currentUser = FirebaseAuth.instance.currentUser;
    getProfileFromDb(currentUser?.uid);
    _isChecked = widget.selectedGroupIds.contains(widget.group.id);
    super.initState();
  }

  int userIdFromDb = -1;
  bool _isChecked = false;
  List<int> _selectedGroupIds = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Text(widget.group.name!, style: TextStyle(color: Colors.black)),
          ),
          Checkbox(
            checkColor: Colors.white,
            activeColor: Colors.black,
            value: _isChecked,
            onChanged: (bool? value) {
              setState(() {
                _isChecked = value!;
              });
              widget.onCheckboxChanged(widget.group.id!);
            },
          ),

        ],
      ),
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
