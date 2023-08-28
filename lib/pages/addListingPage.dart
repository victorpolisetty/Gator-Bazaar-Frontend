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
import '../models/groupModel.dart';
import '../models/itemModel.dart';
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
  List<int> _selectedGroupIds = [];
  String _selectedCategory = "Select"; // Initialize with a default value that matches one of the category names in the map
  Map<String, int?> categoryList = {
    "Select": -1,
    "Clothes": 1,
    "Formal": 2,
    "Tickets": 3,
    "Furniture": 4,
    "Subleases": 5,
    "Electronics": 6,
    "Books": 7,
    "Misc.": 8,
  };


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
  List<int> resultOfGroupsSelected = [];

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
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(2.w), // Use sizer to set padding
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              primary: Colors.grey.withOpacity(0.5),
                              side: BorderSide(color: Colors.black, width: 1),
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
                              side: BorderSide(color: Colors.black, width: 1),
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
                              side: BorderSide(color: Colors.black, width: 1),
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
                  SizedBox(height: 1.h),
                  Padding(
                    padding: EdgeInsets.fromLTRB(3.w,0,0,0),
                    child: Text("Item Name", style: TextStyle(fontWeight: FontWeight.bold, color:  Colors.black)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(3.w), // Use sizer to set padding
                    child: TextFormField(
                      cursorColor: Colors.black,


                      keyboardType: TextInputType.multiline,
                      maxLines: 1,
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
                        contentPadding: EdgeInsets.symmetric(horizontal: 1.h), // Remove horizontal padding
                      ),
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.fromLTRB(3.w,0,0,0),
                    child: Text("Price", style: TextStyle(fontWeight: FontWeight.bold, color:  Colors.black)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(3.w), // Use sizer to set padding
                    child: TextFormField(
                      cursorColor: Colors.black,
                      maxLines: 1,
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
                        contentPadding: EdgeInsets.symmetric(horizontal: 1.h), // Remove horizontal padding
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(3.w,0,0,0),
                    child: Text("Description", style: TextStyle(fontWeight: FontWeight.bold, color:  Colors.black)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(3.w), // Use sizer to set padding
                    child: TextFormField(
                      cursorColor: Colors.black,

                      textAlignVertical: TextAlignVertical.top,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      controller: itemDescriptionController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: 'Add details about condition, retail price, link to retail page, etc...',
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
                    padding: EdgeInsets.fromLTRB(3.w,0,0,0),
                    child: Text("Info", style: TextStyle(fontWeight: FontWeight.bold, color:  Colors.black)),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.all(3.w), // Use sizer to set padding
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       border: Border.all(color: Colors.black),
                  //       borderRadius: BorderRadius.circular(3.0),
                  //     ),
                  //     padding: EdgeInsets.fromLTRB(3.w,0,0,0),
                  //     child: DropdownButton(
                  //       isExpanded: true,
                  //         menuMaxHeight: 200,
                  //         value: _value,
                  //         items: [
                  //           DropdownMenuItem(
                  //             child: Text("Select", style: TextStyle(color: Colors.grey[600]),),
                  //             value: "-1",
                  //           ),
                  //           DropdownMenuItem(
                  //             child: Text("Clothes"),
                  //             value: "1",
                  //           ),
                  //           DropdownMenuItem(
                  //               child: Text("Formal",), value: "2"),
                  //           DropdownMenuItem(
                  //             child: Text("Tickets",),
                  //             value: "3",
                  //           ),
                  //           DropdownMenuItem(
                  //               child: Text("Furniture",), value: "4"),
                  //           DropdownMenuItem(
                  //               child: Text("Subleases",), value: "5"),
                  //           DropdownMenuItem(
                  //               child: Text("Electronics",), value: "6"),
                  //           DropdownMenuItem(child: Text("Books",), value: "7"),
                  //           DropdownMenuItem(child: Text("Misc."), value: "8"),
                  //         ],
                  //         onChanged: (value) {
                  //           setState(() {
                  //             _value = value.toString();
                  //           });
                  //         }),
                  //   ),
                  // ),
                  Padding(
                    padding: EdgeInsets.all(3.w),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(bottom: BorderSide(color: Colors.black, width: 1.0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Category', style: TextStyle(fontSize: 16, color: Colors.black)),
                          Row(
                            children: [
                              _selectedCategory.toString() == "Select" ? Text(
                                _selectedCategory.toString(),
                                style: TextStyle(fontSize: 16, color: Colors.black),
                              ) : Text(
                                // _selectedCategory.toString() + "✅",
                                "Selected Category✅",
                                style: TextStyle(fontSize: 16, color: Colors.black),
                              ),
                              InkWell(
                                  onTap: (){
                                    _showCategorySelectionDialog(context);
                                  },
                                  child: Icon(
                                      Icons.arrow_forward_ios)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(3.w),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(bottom: BorderSide(color: Colors.black, width: 1.0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Group', style: TextStyle(fontSize: 16, color: Colors.black)),
                          Row(
                            children: [
                              _selectedGroupIds.isEmpty ? Text(
                                'Select',
                                style: TextStyle(fontSize: 16, color: Colors.black),
                              ) : Text(
                                'Selected Group(s)' + "✅",
                                style: TextStyle(fontSize: 16, color: Colors.black),
                              ),
                              InkWell(
                                onTap: (){
                                  _showPagedListViewDialog(context);
                                },
                                  child: Icon(
                                      Icons.arrow_forward_ios)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h), // Use sizer to set vertical spacing
                  Padding(
                    padding: EdgeInsets.fromLTRB(3.w,0,3.w,3.5.h), // Use sizer to set padding
                    child: FloatingActionButton.extended(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0), // Set the border radius here
                      ),
                      backgroundColor: Colors.black,
                      onPressed: () async {
                        if (_value != "-1" &&
                            itemNameController.text.isNotEmpty &&
                            itemDescriptionController.text.isNotEmpty &&
                            itemPriceController.text.isNotEmpty &&
                            resultOfGroupsSelected.length != 0 &&
                            _selectedCategory != "Select") {
                          bool? itemAddSuccess = await addNewItemToDB(
                            context,
                            itemNameController.text,
                            itemDescriptionController.text,
                            itemPriceController.text,
                            _value,
                            _image1,
                            _image2,
                            _image3,
                            _selectedGroupIds,
                          );

                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                addedListingDialog(itemAddSuccess ?? false),
                          );

                          if (itemAddSuccess ?? false) {
                            itemNameController.clear();
                            itemDescriptionController.clear();
                            itemPriceController.clear();
                            setState(() {
                              _image1 = null;
                              _image2 = null;
                              _image3 = null;
                              _value = "-1";
                              _selectedGroupIds.clear();
                              _selectedCategory = "Select";
                            });
                          }
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                addedListingDialog(false),
                          );
                        }
                      },
                      icon: Icon(Icons.add),
                      label: Text("Add Listing"),
                    ),
                  ),
                  SizedBox(height: 3.h), // Use sizer to set vertical spacing

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

  void _showCategorySelectionDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Select Category'),
              content: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * .58,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: categoryList.length,
                  itemBuilder: (BuildContext context, int index) {
                    String category = categoryList.keys.elementAt(index);
                    int? categoryId = categoryList.values.elementAt(index);

                    return RadioListTile<int?>(
                      title: Text(category, style: TextStyle(color: Colors.black)),
                      value: categoryId,
                      groupValue: categoryList[_selectedCategory],
                      onChanged: (int? value) {
                        setState(() {
                          _selectedCategory = category;
                          _value = categoryId.toString();
                        });
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(_selectedCategory);
                  },
                  child: Text('Done'),
                ),
              ],
            );
          }
        );
      },
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

  Widget _displayChild2() {
    if (_image2 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14.0, 50.0, 14.0, 50.0),
        child: new Icon(
          Icons.camera_alt_outlined,
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
          Icons.camera_alt_outlined,
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
  Future<bool?> addNewItemToDB(
      BuildContext context,
      String name,
      String description,
      String price,
      String categoryId,
      File? image1,
      File? image2,
      File? image3,
      List<int> groupIdsForItem) async {
    var item = Item(int.parse(categoryId), name, num.parse(price), description);
    List<File> imageDataList = [];

    if (image1 != null) {
      imageDataList.add(image1);
    }

    if (image2 != null) {
      imageDataList.add(image2);
    }

    if (image3 != null) {
      imageDataList.add(image3);
    }

    // Here, we are using the local parameter "groupIdsForItem" instead of "_selectedGroupIds"
    int? itemId = await Provider.of<CategoryItemModel>(context, listen: false)
        .addCategoryItem(int.parse(categoryId), item, imageDataList, context);
    // await addItemToGroups(itm.id, capturedGroupIds);
    Provider.of<CategoryItemModel>(context, listen: false).addItemToGroups(itemId, groupIdsForItem);
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
    resultOfGroupsSelected = (await showDialog<List<int>>(
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

