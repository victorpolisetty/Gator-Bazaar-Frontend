import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:student_shopping/ProfileFile/sellerShop.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' ;

import 'productFB.dart';

class addListing extends StatefulWidget {
  @override
  _addListingState createState() => _addListingState();
}

class _addListingState extends State<addListing> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController productNameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  final priceController = TextEditingController();
  ProductService productService = ProductService();
  File _image1;
  File _image2;
  File _image3;
  bool isLoading = false;

  Future<File> imageFile;

  Future getImage(int type) async {
    PickedFile pickedImage = await ImagePicker().getImage(
        source: type == 1 ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 50);
    return pickedImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          iconTheme: new IconThemeData(color: Colors.grey[800], size: 27),
          backgroundColor: Colors.grey[200],
          elevation: 0,
          title: Center(
            child: Text(
              'Student Shop',
              style: TextStyle(color: Colors.black),
            ),
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.notifications,
                color: Colors.grey[800],
                size: 27,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => sellerShop()),
                );
              },
              child: Container(
                margin: EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.shopping_cart,
                  color: Colors.grey[800],
                  size: 27,
                ),
              ),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView(children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OutlineButton(
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.5),
                                  width: 2.5),
                              onPressed: () async {


                                final tmpFile =  await getImage(2);

                                setState(() {
                                  imageFile =  tmpFile;
                                });

                                _selectImage(
                                    imageFile,
                                    1);
                              },
                              child: _displayChild1()),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OutlineButton(
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.5),
                                  width: 2.5),
                              onPressed: () async {

                                final tmpFile =  await getImage(1);
                                setState(() {
                                  imageFile =  tmpFile;
                                });
                                _selectImage(
                                    imageFile,
                                    2);
                              },
                              child: _displayChild2()),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OutlineButton(
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.5),
                                  width: 2.5),
                              onPressed: () async {
                                final tmpFile =  await getImage(1);
                                setState(() {
                                  imageFile =  tmpFile;
                                });
                                _selectImage(
                                    imageFile,
                                    3);
                              },
                              child: _displayChild3()),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Enter the product name with 10 characters maximum',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      controller: productNameController,
                      decoration: InputDecoration(
                        hintText: 'Product name',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'You must enter the product name';
                        } else if (value.length > 10) {
                          return 'Product name cant have more than 10 letters';
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      controller: quantityController,
                      // initialValue: '1',
                      decoration: InputDecoration(
                        hintText: 'Quantity',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'You must enter the quantity';
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      // initialValue: '0.00',
                      controller: priceController,
                      decoration: InputDecoration(
                        hintText: 'Price',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'You must enter the price';
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      controller: brandController,
                      decoration: InputDecoration(
                        hintText: 'Brand Name',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'You must enter the brand name';
                        } else if (value.length > 10) {
                          return 'Brand name cant have more than 10 letters';
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      controller: categoryController,
                      decoration: InputDecoration(
                        hintText: 'Category Name',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'You must enter the category name';
                        } else if (value.length > 10) {
                          return 'category name cant have more than 10 letters';
                        }
                      },
                    ),
                  ),
                  FlatButton(
                    color: Colors.red,
                    textColor: Colors.white,
                    child: Text('Add Product'),
                    onPressed: () {
                      validateAndUpload();
                    },
                  )
                ]),
        ));
  }

  void _selectImage(Future<File> pickImage, int imageNumber) async {
    File tempImg = await pickImage;
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
        _image1,
        fit: BoxFit.fill,
        width: double.infinity,
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
        _image2,
        fit: BoxFit.fill,
        width: double.infinity,
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
        _image3,
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }

  void validateAndUpload() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      if (_image1 != null && _image2 != null && _image3 != null) {
        var selectedSizes = 5;
        if (selectedSizes == 5) {
          String imageUrl1;
          String imageUrl2;
          String imageUrl3;

         final FirebaseStorage storage = FirebaseStorage.instance;
          final String picture1 =
              "1${DateTime.now().microsecondsSinceEpoch.toString()}.jpg";
          UploadTask task1 = storage.ref().child(picture1).putFile(_image1);
          final String picture2 =
              "2${DateTime.now().microsecondsSinceEpoch.toString()}.jpg";
          UploadTask task2 = storage.ref().child(picture1).putFile(_image2);
          final String picture3 =
              "3${DateTime.now().microsecondsSinceEpoch.toString()}.jpg";
          UploadTask task3 = storage.ref().child(picture1).putFile(_image3);

          TaskSnapshot snapshot1 = await task1.then((snapshot) => snapshot);
          TaskSnapshot snapshot2 = await task2.then((snapshot) => snapshot);

          task3.then((snapshot3) async {
            imageUrl1 = await snapshot1.ref.getDownloadURL();
            imageUrl2 = await snapshot2.ref.getDownloadURL();
            imageUrl3 = await snapshot3.ref.getDownloadURL();
            List<String> imageList = [imageUrl1, imageUrl2, imageUrl3];

            productService.uploadProduct(
                productName: productNameController.text,
                price: double.parse(priceController.text),
                images: imageList,
                quantity: int.parse(quantityController.text));
            ;
          });
          _formKey.currentState.reset();
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: 'Product Added');
        } else {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: 'select atleast one size');
        }
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: 'all images must be provided');
      }
    }
  }
}
