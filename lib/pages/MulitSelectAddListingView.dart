import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:student_shopping_v1/models/adminProfileModel.dart';
import 'package:http/http.dart' as http;

import '../../Widgets/FavoriteWidget.dart';
import '../../models/itemModel.dart';
import '../../models/recentItemModel.dart';
import '../../pages/itemDetailPageSellerView.dart';
import '../constants.dart';
import '../models/groupModel.dart';
import '../models/groupRequestModel.dart';
import '../new/constants.dart';
import '../new/size_config.dart';
import 'manageGroupsPage.dart';

class MultiSelectAddListingView extends StatefulWidget {
  final Group group;
  final String uniqueIdentifier;
  final ValueChanged<int> onCheckboxChanged;
  final Set<int> selectedGroupIds;

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
  Set<int> _selectedGroupIds = {};

  void _onCheckboxChanged(int groupId, bool? value) {
    setState(() {
      if (value == true) {
        _selectedGroupIds.add(groupId);
      } else {
        _selectedGroupIds.remove(groupId);
      }
    });
  }
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
    var url = Uri.parse('http://gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/profiles/$firebaseid'); // TODO -  call the recentItem service when it is built
    http.Response response = await http.get(
        url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      userIdFromDb = data['id'];
      print(response.statusCode);
    } else {
      print(response.statusCode);
    }
  }
}
