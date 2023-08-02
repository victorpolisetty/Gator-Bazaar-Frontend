import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:student_shopping_v1/Widgets/addedListingDialog.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import 'package:student_shopping_v1/models/categoryItemModel.dart';
import 'package:student_shopping_v1/pages/MulitSelectAddListingView.dart';
import 'package:student_shopping_v1/pages/addNewGroupRequestDialog.dart';
import 'package:sizer/sizer.dart';

import '../models/groupModel.dart';
import '../models/itemModel.dart';
import '../new/size_config.dart';
import 'itemDetailPage.dart';
import 'package:http/http.dart' as http;

class AddNewGroupsRequest extends StatefulWidget {
  @override
  _AddNewGroupsRequestState createState() => _AddNewGroupsRequestState();
}

class _AddNewGroupsRequestState extends State<AddNewGroupsRequest> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController groupNameController = TextEditingController();
  TextEditingController groupDescriptionController = TextEditingController();

  bool itemGroupRequestSuccess = false;
  bool dialogShowed = false;

  late Future<File> imageFile;
  File? _image1;
  int? currDbId = -1;

  String userEmail = "";
  late Map data;
  late File file;
  final PagingController<int, Group> _pagingControllerMyGroups =
  PagingController(firstPageKey: 0);
  int totalPages = 0;
  Set<int> resultOfGroupsSelected = {};

  Future<int?> getUserDbIdRealFunc() async {
    // Assume user is logged in for this example
    String? firebaseId = FirebaseAuth.instance.currentUser?.uid;

    Future<void> updatedUserDbId() async {
      Map<String, dynamic> data;
      var url = Uri.parse(
          'http://Gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/profiles/$firebaseId'); // TODO -  call the recentItem service when it is built
      http.Response response =
      await http.get(url, headers: {"Accept": "application/json"});
      if (response.statusCode == 200) {
        data = jsonDecode(response.body);
        currDbId = data['id'];
        print(response.statusCode);
      } else {
        print(response.statusCode);
      }
    }

    await updatedUserDbId();
    return null;
  }

  Future<int?> getUserDbId() async {
    return await getUserDbIdRealFunc();
  }

  @override
  void initState() {
    super.initState();
    getUserDbId();
    _pagingControllerMyGroups.addPageRequestListener((pageKey) {
      _fetchPageMyGroups(pageKey, 1);
    });
  }

  @override
  void dispose() {
    if(!mounted) _pagingControllerMyGroups.dispose();
    super.dispose();
  }

  Future<void> _fetchPageMyGroups(int pageKey, int categoryId) async {
    try {
      await Provider.of<GroupModel>(context, listen: false).getGroupsUserInAndImages(pageKey);
      totalPages = Provider.of<GroupModel>(context, listen: false).totalPages;
      if(mounted) {
        final isLastPage = (totalPages-1) == pageKey;

        if (isLastPage) {
          _pagingControllerMyGroups.appendLastPage(Provider.of<GroupModel>(context, listen: false).groupListMyGroups);
        } else {
          final int? nextPageKey = pageKey + 1;
          _pagingControllerMyGroups.appendPage(Provider.of<GroupModel>(context, listen: false).groupListMyGroups, nextPageKey);
        }
      }
    } catch (error) {
      _pagingControllerMyGroups.error = error;
    }
  }

  Future getImage(int type) async {
    PickedFile pickedImage = (await ImagePicker().getImage(
      source: type == 1 ? ImageSource.camera : ImageSource.gallery,
    ))!;
    return pickedImage;
  }


  @override
  Widget build(BuildContext context) {
    itemGroupRequestSuccess = false;
    //   var recentList = context.watch<CategoryItemModel>();
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: ClampingScrollPhysics(),
          child: Container(
            height: 80.h, // Use sizer to set the height
            padding: EdgeInsets.symmetric(horizontal: 2.w), // Use sizer to set horizontal padding
            child: Form(
              key: _formKey,
              child: ListView(
                  children: <Widget>[
                    SizedBox(height: 1.h),
                    Padding(
                      padding: EdgeInsets.fromLTRB(3.w,0,0,0),
                      child: Text("Group Name", style: TextStyle(fontWeight: FontWeight.bold, color:  Colors.black)),
                    ),// Use sizer to set vertical spacing
                    Padding(
                      padding: EdgeInsets.all(3.w), // Use sizer to set padding
                      child: TextFormField(
                        cursorColor: Colors.black,

                        keyboardType: TextInputType.multiline,
                        maxLines: 1,
                        controller: groupNameController,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(19),
                        ],
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: 'Group Name',
                          fillColor: Colors.black,
                          focusColor: Colors.black,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 1.h), // Remove horizontal padding

                        ),
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.fromLTRB(3.w,0,0,0),
                      child: Text("Group Description", style: TextStyle(fontWeight: FontWeight.bold, color:  Colors.black)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(3.w), // Use sizer to set padding
                      child: TextFormField(
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        controller: groupDescriptionController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: 'Who are you in relation to this group?',
                          fillColor: Colors.black,
                          focusColor: Colors.black,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 2.w), // Remove horizontal padding
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly, // Space images evenly
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(2.w), // Use sizer to set padding
                            child: SizedBox(
                              height: 35.h,
                              child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    primary: Colors.grey.withOpacity(0.5),
                                    side: BorderSide(color: Colors.black, width: 1),
                                  ),
                                  onPressed: () async {
                                    _showPickOptionsDialog(context, 1);
                                  },
                                  child: _displayChild1()),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(3.w,0,3.w,3.5.h), // Use sizer to set padding
                      child: FloatingActionButton.extended(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0), // Set the border radius here
                        ),
                        backgroundColor: Colors.black,
                        onPressed: () {
                          groupNameController.text.isNotEmpty &&
                              groupDescriptionController.text.isNotEmpty &&
                              _image1 != null
                              ? itemGroupRequestSuccess =
                          // addNewItemToDB(
                          // context,
                          // groupNameController.text,
                          // groupDescriptionController.text,
                          // ownerController.text,
                          // _value, // _value = categoryid
                          // _image1,
                          // resultOfGroupsSelected)
                          addNewGroupRequestToDB(
                              currDbId.toString(),
                              groupNameController.text,
                              groupDescriptionController.text,
                              _image1!
                          )
                              : null;
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  addNewGroupRequestDialog(itemGroupRequestSuccess));
                          if (itemGroupRequestSuccess) {
                            groupNameController.clear();
                            groupDescriptionController.clear();
                            setState(() {
                              _image1 = null;
                            });
                          }
                        },
                        icon: Icon(Icons.add),
                        label: Text("Request Group"),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }


  Widget _displayChild1() {
    if (_image1 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14.0, 50.0, 14.0, 50.0),
        child: new Icon(
          Icons.camera_alt_outlined,
          color: Colors.grey,
        ),
      );
    } else {
      return Image.file(
        _image1!,
        height: 200,
        width: 150,
        // fit: BoxFit.fill,
        // width: double.infinity,
      );
    }
  }

  bool addNewItemToDB(
      BuildContext context,
      String name,
      String description,
      String price,
      String categoryId,
      File? image1,
      File? image2,
      File? image3,
      Set<int> groupIdsForItem) {
    var item = Item(int.parse(categoryId), name, num.parse(price), description);
    List<File> imageDataList = [];

    if (_image1 != null) {
      imageDataList.add(_image1!);
    }

    Provider.of<CategoryItemModel>(context, listen: false)
        .addCategoryItem(int.parse(categoryId), item, imageDataList, context, groupIdsForItem);

    return true;
  }

  bool addNewGroupRequestToDB(
      String profileId,
      String groupName,
      String groupReqDescription,
      File imageFile,){
    try{
      createNewGroupRequest(profileId, groupName, groupReqDescription, imageFile);
      return true;
    } catch (e) {
      print(e);
      return false;
    }

  }

  Future<void> createNewGroupRequest(
      String profileId,
      String groupName,
      String groupReqDescription,
      File imageFile,
      ) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/group/createNewGroupRequest/$profileId'),
    );

    // Add form fields
    request.fields['groupName'] = groupName;
    request.fields['groupReqDescription'] = groupReqDescription;

    // Add the image file
    request.files.add(
      await http.MultipartFile.fromPath('image', imageFile.path),
    );

    try {
      var streamedResponse = await request.send();
      if (streamedResponse.statusCode == 200) {
        // Success
        var response = await http.Response.fromStream(streamedResponse);
        print('New group request created: ${response.body}');
      } else {
        // Handle error
        print('Failed to create group request: ${streamedResponse.reasonPhrase}');
      }
    } catch (e) {
      print('Error while sending request: $e');
    }
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) {
      return;
    }
    final path = result.files.single.path;
    setState(() {
      file = File(path!);
    });
  }

  void _loadPicker(ImageSource source, int imageNumber) async {
    XFile? picked = await ImagePicker()
        .pickImage(source: source, maxHeight: 600, maxWidth: 600);
    if (picked != null) {
      switch (imageNumber) {
        case 1:
          setState(() {
            _image1 = File(picked.path);
          });
          break;
      }
    }
    Navigator.of(context, rootNavigator: true).pop();
  }

  void _showPickOptionsDialog(BuildContext context, int imageNumber) {
    BuildContext dialogContext;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          // dialogContext = context;
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Pick from Gallery"),
                onTap: () {
                  _loadPicker(ImageSource.gallery, imageNumber);
                },
              ),
              ListTile(
                title: Text("Take a picture"),
                onTap: () {
                  _loadPicker(ImageSource.camera, imageNumber);
                },
              )
            ],
          ),
        ));
  }
}
