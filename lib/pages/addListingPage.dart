import 'dart:io';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sizer/sizer.dart';
import 'package:student_shopping_v1/Widgets/addedListingDialog.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import 'package:student_shopping_v1/models/categoryItemModel.dart';
import 'package:student_shopping_v1/pages/MulitSelectAddListingView.dart';

import '../Widgets/MultiSelectDialog.dart';
import '../models/adminProfileModel.dart';
import '../models/groupModel.dart';
import '../models/itemModel.dart';
import '../new/size_config.dart';
import 'itemDetailPage.dart';

class AddListing extends StatefulWidget {
  @override
  _AddListingState createState() => _AddListingState();
}

class _AddListingState extends State<AddListing> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemDescriptionController = TextEditingController();
  TextEditingController itemPriceController = TextEditingController();

  bool itemAddSuccess = false;
  String _value = "-1";
  bool dialogShowed = false;
  Set<int> _selectedGroupIds = {};

  // String clothingVal = "5";
  //late String imageUrl;
  late Future<File> imageFile;
  File? _image1;
  File? _image2;
  File? _image3;

  String userEmail = "";
  late Map data;
  late File file;
  final PagingController<int, Group> _pagingControllerMyGroups =
  PagingController(firstPageKey: 0);
  int totalPages = 0;
  Set<int> resultOfGroupsSelected = {};

  @override
  void initState() {
    super.initState();
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
      // imageQuality: 50
    ))!;
    return pickedImage;
  }

  @override
  Widget build(BuildContext context) {
    itemAddSuccess = false;
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      onPrimary: Colors.black87,
      primary: Colors.grey[300],
      minimumSize: Size(88, 36),
      padding: EdgeInsets.symmetric(horizontal: 2.w), // Use sizer to set horizontal padding
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
    );
    //   var recentList = context.watch<CategoryItemModel>();
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        iconTheme: new IconThemeData(color: Colors.black, size: 27),
        elevation: 0,
        title: Text(
          'Add Listing',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Container(
            height: 80.h, // Use sizer to set the height
            padding: EdgeInsets.symmetric(horizontal: 2.w), // Use sizer to set horizontal padding
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(2.w), // Use sizer to set padding
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              primary: Colors.grey.withOpacity(0.5),
                              side: BorderSide(color: Colors.black, width: 5),
                            ),
                            onPressed: () async {
                              _showPickOptionsDialog(context, 1);
                            },
                            child: _displayChild1(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(2.w), // Use sizer to set padding
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              primary: Colors.grey.withOpacity(0.5),
                              side: BorderSide(color: Colors.black, width: 5),
                            ),
                            onPressed: () async {
                              _showPickOptionsDialog(context, 2);
                            },
                            child: _displayChild2(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(2.w), // Use sizer to set padding
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              primary: Colors.grey.withOpacity(0.5),
                              side: BorderSide(color: Colors.black, width: 5),
                            ),
                            onPressed: () async {
                              _showPickOptionsDialog(context, 3);
                            },
                            child: _displayChild3(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h), // Use sizer to set vertical spacing
                  Padding(
                    padding: EdgeInsets.all(2.w), // Use sizer to set padding
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 2,
                      controller: itemNameController,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(19),
                      ],
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: 'Item Name',
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
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(2.w), // Use sizer to set padding
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 2,
                      controller: itemDescriptionController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: 'Description',
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
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(2.w), // Use sizer to set padding
                    child: TextFormField(
                      maxLines: 2,
                      controller: itemPriceController,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(5),
                        FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          try {
                            final text = newValue.text;
                            if (text.isNotEmpty) double.parse(text);
                            return newValue;
                          } catch (e) {}
                          return oldValue;
                        }),
                      ],
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                        signed: false,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Price',
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
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(2.w), // Use sizer to set padding
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: DropdownButton(
                          menuMaxHeight: 200,
                          value: _value,
                          items: [
                            DropdownMenuItem(
                              child: Text("Select Category"),
                              value: "-1",
                            ),
                            DropdownMenuItem(
                              child: Text("Clothes"),
                              value: "1",
                            ),
                            DropdownMenuItem(
                                child: Text("Formal Dresses"), value: "2"),
                            DropdownMenuItem(
                              child: Text("Student Tickets"),
                              value: "3",
                            ),
                            DropdownMenuItem(
                                child: Text("Furniture"), value: "4"),
                            DropdownMenuItem(
                                child: Text("Subleases"), value: "5"),
                            DropdownMenuItem(
                                child: Text("Electronics"), value: "6"),
                            DropdownMenuItem(child: Text("Books"), value: "7"),
                            DropdownMenuItem(child: Text("Misc."), value: "8"),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _value = value.toString();
                            });
                          }),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(2.w), // Use sizer to set padding
                    child: ElevatedButton(
                      onPressed: () {
                        _showPagedListViewDialog(context);
                      },
                      child: Text('Select Groups'),
                    ),
                  ),
                  SizedBox(height: 2.h), // Use sizer to set vertical spacing
                  Padding(
                    padding: EdgeInsets.all(2.w), // Use sizer to set padding
                    child: FloatingActionButton.extended(
                      backgroundColor: Colors.black,
                      onPressed: () {
                        _value != "-1" &&
                            itemNameController.text.isNotEmpty &&
                            itemDescriptionController.text.isNotEmpty &&
                            itemPriceController.text.isNotEmpty && resultOfGroupsSelected.length != 0
                            ? itemAddSuccess = addNewItemToDB(
                            context,
                            itemNameController.text,
                            itemDescriptionController.text,
                            itemPriceController.text,
                            _value, // _value = categoryid
                            _image1,
                            _image2,
                            _image3,
                            resultOfGroupsSelected)
                            : null;
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                addedListingDialog(itemAddSuccess));
                        if (itemAddSuccess) {
                          itemNameController.clear();
                          itemDescriptionController.clear();
                          itemPriceController.clear();
                          setState(() {
                            _image1 = null;
                            _image2 = null;
                            _image3 = null;
                            _value = "-1";
                          });
                        }
                      },
                      icon: Icon(Icons.add),
                      label: Text("Add Listing"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _selectImage(Future<XFile?> pickImage, int imageNumber) async {
    XFile? tempImg1 = await pickImage;
    File tempImg = File(tempImg1!.path);
    switch (imageNumber) {
      case 1:
        setState(() {
          _image1 = tempImg;
        });
        break;
      case 2:
        setState(() {
          _image2 = tempImg;
        });
        break;
      case 3:
        setState(() {
          _image3 = tempImg;
        });
        break;
    }
  }

  Widget _displayChild1() {
    if (_image1 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14.0, 50.0, 14.0, 50.0),
        child: new Icon(
          Icons.add,
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

  Widget _displayChild2() {
    if (_image2 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14.0, 50.0, 14.0, 50.0),
        child: new Icon(
          Icons.add,
          color: Colors.grey,
        ),
      );
    } else {
      return Image.file(
        _image2!,
        // fit: BoxFit.fill,
        // width: double.infinity,
        height: 200,
        width: 200,
      );
    }
  }

  Widget _displayChild3() {
    if (_image3 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14.0, 50.0, 14.0, 50.0),
        child: new Icon(
          Icons.add,
          color: Colors.grey,
        ),
      );
    } else {
      return Image.file(
        _image3!,
        // fit: BoxFit.fill,
        // width: double.infinity,
        height: 200,
        width: 200,
      );
    }
  }

  //TODO: add clothing filters
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

    if (_image2 != null) {
      imageDataList.add(_image2!);
    }

    if (_image3 != null) {
      imageDataList.add(_image3!);
    }

    Provider.of<CategoryItemModel>(context, listen: false)
        .addCategoryItem(int.parse(categoryId), item, imageDataList, context, groupIdsForItem);

    return true;
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
        case 2:
          setState(() {
            _image2 = File(picked.path);
          });
          break;
        case 3:
          setState(() {
            _image3 = File(picked.path);
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

  void _showPagedListViewDialog(BuildContext context) async {
    resultOfGroupsSelected = (await showDialog<Set<int>>(
      context: context,
      barrierDismissible: true, // Allows tapping outside to close the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Options'),
          content: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * .58,
                child: PagedListView(
                  pagingController: _pagingControllerMyGroups,
                  shrinkWrap: true,
                  builderDelegate:
                  PagedChildBuilderDelegate<Group>(
                    firstPageProgressIndicatorBuilder: (_) =>
                        Center(child: spinkit),
                    newPageProgressIndicatorBuilder: (_) =>
                        Center(child: spinkit),
                    itemBuilder: (BuildContext context, group, int index) {
                      return MultiSelectAddListingView(
                        group: group,
                        uniqueIdentifier: "groupCardFindGroups",
                        onCheckboxChanged: (int groupId) {
                          setState(() {
                            if (_selectedGroupIds.contains(groupId)) {
                              _selectedGroupIds.remove(groupId);
                            } else {
                              _selectedGroupIds.add(groupId);
                            }
                          });
                        },
                        selectedGroupIds: _selectedGroupIds,
                      );
                    },

                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(_selectedGroupIds);
              },
              child: Text('Done'),
            ),
          ],
        );
      },
    )) ?? resultOfGroupsSelected;
  }
}
