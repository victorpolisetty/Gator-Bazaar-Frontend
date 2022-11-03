import 'dart:io';
import 'package:student_shopping_v1/Widgets/addedListingDialog.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';


import 'package:student_shopping_v1/models/categoryItemModel.dart';

import '../models/itemModel.dart';

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
  // String clothingVal = "5";
  //late String imageUrl;
  late Future<File> imageFile;
  File? _image1;
  File? _image2;
  File? _image3;

  String userEmail = "";
  late Map data;
  late File file;

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
    //   var recentList = context.watch<CategoryItemModel>();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[200],
        appBar: new AppBar(
          automaticallyImplyLeading: false,
          iconTheme: new IconThemeData(color: Colors.grey[800], size: 27),
          backgroundColor: Colors.grey[300],
          elevation: 0,
          // title: Center(
          title: Text(
            'Add Item',
            style: TextStyle(color: Colors.black),
          ),
          // ),
        ),
        body: GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
            width: MediaQuery
                  .of(context)
                  .size
                  .width,
                child: Form(
                  key: _formKey,
                  child: ListView
                    (
                      children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  primary: Colors.grey.withOpacity(0.5),
                                  side: BorderSide(color: Colors.black, width: 5),
                                ),
                                onPressed: () async {
                                  //TODO
                                  // _selectImage(
                                  //     ImagePicker()
                                  //         .pickImage(source: ImageSource.gallery),
                                  //     1);
                                  _showPickOptionsDialog(context,1);
                                  // _showChoiceDialog(context);
                                },
                                child: _displayChild1()),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  primary: Colors.grey.withOpacity(0.5),
                                  side: BorderSide(color: Colors.black, width: 5),
                                ),
                                onPressed: () async {
                                  // _selectImage(
                                  //     ImagePicker()
                                  //         .pickImage(source: ImageSource.gallery),
                                  //     2);
                                  _showPickOptionsDialog(context,2);

                                },
                                child: _displayChild2()),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  primary: Colors.grey.withOpacity(0.5),
                                  side: BorderSide(color: Colors.black, width: 5),
                                ),
                                onPressed: () async {
                                  // _selectImage(
                                  //     ImagePicker()
                                  //         .pickImage(source: ImageSource.gallery),
                                  //     3);
                                  _showPickOptionsDialog(context,3);
                                },
                                child: _displayChild3()),
                          ),
                        ),
                      ],
                    ),
                    // Text(
                    //   'Enter the product name with 10 characters maximum',
                    //   textAlign: TextAlign.center,
                    //   style: TextStyle(color: Colors.red, fontSize: 12),
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
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
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 2,
                        controller: itemDescriptionController,
                        textCapitalization: TextCapitalization.sentences,
                        // initialValue: '1',
                        decoration: InputDecoration(
                          hintText: 'Description',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        maxLines: 2,
                        // initialValue: '0.00',
                        controller: itemPriceController,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(6),
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
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
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
                                DropdownMenuItem(child: Text("Formal Dresses"), value: "2"),
                                DropdownMenuItem(
                                  child: Text("Student Tickets"),
                                  value: "3",
                                ),
                                DropdownMenuItem(child: Text("Furniture"), value: "4"),
                                DropdownMenuItem(child: Text("Subleases"), value: "5"),
                                DropdownMenuItem(child: Text("Electronics"), value: "6"),
                                DropdownMenuItem(child: Text("Books"), value: "7"),
                                DropdownMenuItem(child: Text("Misc."), value: "8"),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _value = value.toString();
                                });
                              }),
                        )),
                    TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                        ),
                        child: Text('Add Product', style: TextStyle(color: Colors.white),),
                        onPressed: () {

                          _value != "-1" &&
                                  itemNameController.text.isNotEmpty &&
                                  itemDescriptionController.text.isNotEmpty &&
                                  itemPriceController.text.isNotEmpty
                              ? itemAddSuccess = addNewItemToDB(
                                  context,
                                  itemNameController.text,
                                  itemDescriptionController.text,
                                  itemPriceController.text,
                                  _value, // _value = categoryid
                                  _image1,
                                  _image2,
                                  _image3)
                              : null;
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => addedListingDialog(itemAddSuccess));
                          if(itemAddSuccess){
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
                        })
                  ]),
                ),
            ),
          ),
        )
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
      File? image3) {
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
        .addCategoryItem(int.parse(categoryId), item, imageDataList,context);

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
  void _loadPicker(ImageSource source, int imageNumber) async{
    XFile? picked = await ImagePicker().pickImage(source: source, maxHeight: 600, maxWidth: 600);
    if(picked != null){
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

  void _showPickOptionsDialog(BuildContext context, int imageNumber){
    BuildContext dialogContext;
    showDialog(context: context,
        builder: (context) => AlertDialog(
          // dialogContext = context;
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Pick from Gallery"),
                onTap: (){
                  _loadPicker(ImageSource.gallery, imageNumber);
                },
              ),
              ListTile(
                title: Text("Take a picture"),
                onTap: (){
                  _loadPicker(ImageSource.camera, imageNumber);
                },
              )
            ],
          ),
        ) );
  }



}
