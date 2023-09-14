import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:path/path.dart' as path;

import 'package:student_shopping_v1/main.dart';
import 'package:url_launcher/url_launcher.dart';
import '../api_utils.dart';
import '../models/itemModel.dart';
import '../models/sellerItemModel.dart';
import '../new/components/productCardSellerView.dart';

import 'itemDetailPage.dart';

class SellerProfilePageNew extends StatefulWidget {
  const SellerProfilePageNew({Key? key}) : super(key: key);

  @override
  State<SellerProfilePageNew> createState() => _SellerProfilePageNewState();
}

class _SellerProfilePageNewState extends State<SellerProfilePageNew> {
  File? _image1;
  int? currDbId = -1;
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _paymentController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isInstagramHandleFetched = false;
  bool isProfileDescriptionFetched = false;
  bool isPaymentMethodFetched = false;

  Future<User?> isSignedIn() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    return currentUser;
  }

  showAlertDialogSignOut(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("No", style: TextStyle(color: Colors.black),),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Future<void> _signOut() async {
      await FirebaseAuth.instance.signOut();
    }

    Widget continueButton = TextButton(
      child: Text("Yes", style: TextStyle(color: Colors.black),),
      onPressed: () async {
        Navigator.of(context).pop();
        await _signOut().then((value) => Navigator.of(context)
            .pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => MainPage()),
                (route) => false));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Sign out?"),
      content: Text("Are you sure you want to SIGN OUT?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogDeleteAccount(BuildContext context) async {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Future<void> _signOutAndDelete(BuildContext context) async {
      try {
        await FirebaseAuth.instance.currentUser!.delete();
        await FirebaseAuth.instance.signOut();
      } catch (e) {
        // Handle any exceptions that might occur during deletion
        print("Error deleting account: $e");
        // You can show an error dialog here
        return;
      }
    }

    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed: () async {
        // Show a loading dialog while deleting the account
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(child: CircularProgressIndicator()),
        );

        await _signOutAndDelete(context);
        await deleteUserFromDB(
            Provider.of<SellerItemModel>(context, listen: false).userIdFromDB);

        // Close the loading dialog
        Navigator.of(context).pop();

        // Navigate back to the main page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete Account?"),
      content: Text("Are you sure you want to DELETE account?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> deleteUserFromDB(int? id) async {
    var url = ApiUtils.buildApiUrl('/profiles/$id');
    http.Response response =
        await http.delete(url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
    } else {
      print(response.statusCode);
    }
  }

  final PagingController<int, ItemWithImages> _pagingController =
      PagingController(firstPageKey: 0);
  int totalPages = 0;
  String instagramHandle = "";
  String profileDescription = "";
  String paymentDescription = "";
  Uint8List? imageURL = new Uint8List(0);

  @override
  void initState() {
    _initializeData();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey, 1);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (!mounted) _pagingController.dispose();
    if (!mounted) _instagramController.dispose();
    if (!mounted) _descriptionController.dispose();
    if (!mounted) _paymentController.dispose();
  }

  Future<void> _fetchPage(int pageKey, int categoryId) async {
    try {
      await Provider.of<SellerItemModel>(context, listen: false)
          .initNextCatPage(pageKey);
      totalPages =
          Provider.of<SellerItemModel>(context, listen: false).totalPages;
      if (mounted) {
        final isLastPage = (totalPages - 1) == pageKey;

        if (isLastPage) {
          _pagingController.appendLastPage(
              Provider.of<SellerItemModel>(context, listen: false).items);
        } else {
          final int? nextPageKey = pageKey + 1;
          _pagingController.appendPage(
              Provider.of<SellerItemModel>(context, listen: false).items,
              nextPageKey);
        }
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  Future<void> _initializeData() async {
    if (!isInstagramHandleFetched) {
      await getInstagramHandle();
    }
    if (!isProfileDescriptionFetched) {
      await getDescriptionHandle();
    }
    if (!isPaymentMethodFetched) {
      await getPaymentHandle();
    }
    await getImageByProfile();
  }

  User? user = FirebaseAuth.instance.currentUser!;
  String? firebaseId = FirebaseAuth.instance.currentUser?.uid;
  String? displayName = FirebaseAuth.instance.currentUser?.displayName;
  String? email = FirebaseAuth.instance.currentUser?.email;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeData(), // Change here to use first
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Colors.black,
            height: 350.sp, // Use sizer to set height
            width: MediaQuery.of(context).size.width,
            child: spinkit,
          );
        } else if (snapshot.hasError) {
          // Handle error case
          return Text('Error: ${snapshot.error}');
        } else {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              title: Text(displayName!.toString()),
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
              automaticallyImplyLeading: false,
              elevation: .1,
              actions: [
                PopupMenuButton(
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem<int>(
                        value: 0,
                        child: Text("Sign Out"),
                      ),
                      PopupMenuItem<int>(
                        value: 1,
                        child: Text("Delete Account"),
                      ),
                    ];
                  },
                  onSelected: (value) {
                    if (value == 0) {
                      showAlertDialogSignOut(context);
                    } else if (value == 1) {
                      showAlertDialogDeleteAccount(context);
                    }
                  },
                ),
              ],
            ),
            body: Container(
              color: Color(0xFF333333),
              width: 100.w,
              height: 100.h,
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Row(
                        children: [
                          SizedBox(width: 5.w), // Use sizer to set width

                          Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // Adjust this property for vertical alignment
                            children: [
                              SizedBox(
                                  height:
                                      5.0), // Adjust the height value as needed
                              buildProfileImage(),
                            ],
                          ),

                          SizedBox(width: 5.w), // Use sizer to set width
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  height: 4.h), // Use sizer to set height
                              Center(
                                child: Text(
                                  email!.toString(),
                                  style: TextStyle(
                                    fontSize: 3.w, // Use sizer to set font size
                                    fontFamily: 'Montserrat',
                                    color: Colors.white60,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 1.h),
                              profileDescription == ""
                                  ? Row(
                                children: [
                                  Text(
                                    "No Profile Description",
                                    style: TextStyle(
                                        fontSize: 1.2.h, color: Colors.redAccent),
                                  ),
                                  SizedBox(height: 1.h,width: 1.w,),
                                ],
                              )
                                  :
                              Container(
                                width: 55.w, // Set a specific width or adjust as needed
                                child: Row(
                                  children: [
                                    // SizedBox(height: 2.h),
                                    Flexible(
                                      child: Text(
                                        profileDescription,
                                        softWrap: true,
                                        maxLines: 3,
                                        style: TextStyle(
                                          fontSize: 3.w,
                                          color: Colors.grey,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                  ],
                                ),
                              ),
                              instagramHandle == ""
                                  ? Row(
                                children: [
                                  Image.asset(
                                    "assets/insta.png",
                                    height: 5.h,
                                    width: 5.w,
                                  ),
                                  SizedBox(width: 5,),
                                  Text(
                                    "No Instagram Linked",
                                    style: TextStyle(
                                        fontSize: 1.2.h, color: Colors.redAccent),
                                  ),
                                  SizedBox(width: 1.w,),
                                ],
                              ) :
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _launchUrl(
                                          "https://instagram.com/$instagramHandle");
                                    },
                                    child: Image.asset(
                                      "assets/insta_white.png",
                                      height: 5.h,
                                      width: 5.w,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _launchUrl(
                                          "https://instagram.com/$instagramHandle");
                                    },
                                    child: Text(
                                      "@" + instagramHandle,
                                      style: TextStyle(
                                          fontSize: 3.w,
                                          color: Colors.blueAccent),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              paymentDescription == ""
                                  ? Container(
                                width: 55.w, // Set a specific width or adjust as needed
                                height: 2.h,
                                    child: Row(
                                children: [
                                    Image.asset(
                                      "assets/payment_grey.png",
                                      height: 5.h,
                                      width: 5.w,
                                      // Add margin to move it to the left
                                      // margin: EdgeInsets.only(left: 10.0), // Adjust the left margin as needed
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "No Payment Method",
                                      style: TextStyle(
                                          fontSize: 1.2.h, color: Colors.redAccent),
                                    ),
                                    SizedBox(height: 1.h,width: 1.w,),
                                    // GestureDetector(child: Icon(Icons.edit, color: Colors.white, size: 3.w,),onTap: (){
                                    //   _openInstagramDialog();
                                    // },)
                                ],
                              ),
                                  )
                                  :
                              Container(
                                width: 55.w, // Set a specific width or adjust as needed
                                height: 2.h,
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "assets/payment_white.png",
                                      height: 5.h,
                                      width: 5.w,
                                      // Add margin to move it to the left
                                      // margin: EdgeInsets.only(left: 10.0), // Adjust the left margin as needed
                                    ),
                                    SizedBox(width: 5),
                                    Flexible(
                                      child: Text(
                                        paymentDescription,
                                        softWrap: true,
                                        maxLines: 3,
                                        style: TextStyle(
                                          fontSize: 3.w,
                                          color: Colors.grey,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(width: 5,height: 0,),
                                  ],
                                ),
                              ),


                              ElevatedButton(
                                onPressed: () {
                                  _editProfileDialog();
                                },
                                child: Text('Edit Profile', style: TextStyle(fontSize: 12),),
                                style: ButtonStyle(
                                  fixedSize: MaterialStateProperty.all(Size(200, 0)),
                                  backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                                ),
                              )


                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h), // Use sizer to set height
                      Padding(
                        padding:
                            EdgeInsets.all(10.sp), // Use sizer to set padding
                        child: Text(
                          "My Listings",
                          style: TextStyle(
                            fontSize: 15.sp, // Use sizer to set font size
                            fontFamily: 'Montserrat',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ]),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.all(5.sp), // Use sizer to set padding
                    sliver: PagedSliverGrid(
                      pagingController: _pagingController,
                      builderDelegate:
                          PagedChildBuilderDelegate<ItemWithImages>(
                        firstPageProgressIndicatorBuilder: (_) =>
                            Center(child: spinkit),
                        newPageProgressIndicatorBuilder: (_) =>
                            Center(child: spinkit),
                        noItemsFoundIndicatorBuilder: (_) => Center(
                            child: Text(
                          "No Items Found.",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        )),
                        itemBuilder: (BuildContext context, item, int index) {
                          return ProductCardSeller(
                            product: item,
                            uniqueIdentifier: "sellerItem",
                            pagingController: _pagingController,
                          );
                        },
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: .7,
                        crossAxisCount: 2,
                        mainAxisSpacing:
                            0, // Use sizer to set main axis spacing
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  void _showPickOptionsDialog(BuildContext context, int imageNumber) {
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

  void _openInstagramDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Instagram"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      0, 0, 0, 0), // Use sizer to set padding
                  child: TextFormField(
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.multiline,
                    maxLines: 1,
                    controller: _instagramController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(19),
                    ],
                    textCapitalization: TextCapitalization.none,
                    decoration: InputDecoration(
                      hintText: 'Instagram Handle',
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
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 1.h), // Remove horizontal padding
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Perform actions with the entered Instagram username
                  updateInstagramHandle(_instagramController.text);
                  setState(() {
                    instagramHandle = _instagramController.text;
                    _instagramController.clear();
                  });
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: Text(
                "Update",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _openDescriptionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Profile Description"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      0, 0, 0, 0), // Use sizer to set padding
                  child: TextFormField(
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.multiline,
                    maxLines: 1,
                    controller: _descriptionController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(100),
                    ],
                    textCapitalization: TextCapitalization.none,
                    decoration: InputDecoration(
                      hintText: 'Profile Description',
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
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 1.h), // Remove horizontal padding
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Perform actions with the entered Instagram username
                  updateProfileDescription(_descriptionController.text);
                  setState(() {
                    profileDescription = _descriptionController.text;
                    _descriptionController.clear();
                  });
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: Text(
                "Update",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _openPaymentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Profile Payment Method"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      0, 0, 0, 0), // Use sizer to set padding
                  child: TextFormField(
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.multiline,
                    maxLines: 1,
                    controller: _paymentController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(50),
                    ],
                    textCapitalization: TextCapitalization.none,
                    decoration: InputDecoration(
                      hintText: 'Payment (Venmo, etc...)',
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
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 1.h), // Remove horizontal padding
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Perform actions with the entered Instagram username
                  updateProfilePayment(_paymentController.text);
                  setState(() {
                    paymentDescription = _paymentController.text;
                    _paymentController.clear();
                  });
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: Text(
                "Update",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // void _unlinkInstagramDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text("Unlink Instagram"),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Close the dialog
  //             },
  //             child: Text(
  //               "Cancel",
  //               style: TextStyle(color: Colors.black),
  //             ),
  //           ),
  //           ElevatedButton(
  //             style: ElevatedButton.styleFrom(
  //               primary: Colors.black,
  //             ),
  //             onPressed: () {
  //               deleteInstagramHandle();
  //               Navigator.of(context).pop(); // Close the dialog
  //             },
  //             child: Text(
  //               "Unlink Account",
  //               style: TextStyle(color: Colors.white),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void _editProfileDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Profile"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  _openInstagramDialog();
                },
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(Size(200, 50)),
                  backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                ),
                child: Text("Edit Instagram", style: TextStyle(color: Colors.white),),
              ),
              SizedBox(height: 1.h,),
              ElevatedButton(
                onPressed: () {
                  _openDescriptionDialog();
                  // Handle "Edit Description" action
                },
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(Size(200, 50)),
                  backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                ),
                child: Text("Edit Description", style: TextStyle(color: Colors.white),),
              ),
              SizedBox(height: 1.h,),
              ElevatedButton(
                onPressed: () {
                  _openPaymentDialog();
                  // Handle "Edit Payment Method" action
                },
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(Size(200, 50)),
                  backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                ),
                child: Text("Edit Payment Method", style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel", style: TextStyle(color: Colors.black),),
            ),
          ],
        );
      },
    );
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
          await uploadItemImageToDB(_image1!);
          break;
      }
    }
    Navigator.of(context, rootNavigator: true).pop();
  }

  Widget buildProfileImage() => GestureDetector(
        onTap: () async {
          _showPickOptionsDialog(context, 1);
        },
        child: CircleAvatar(
          radius: 60, // Adjust the radius as needed
          backgroundColor: Colors.grey.shade800,
          backgroundImage: (_image1 != null && _image1!.existsSync())
              ? Image.file(
                  _image1!,
                  height: 80, // Adjust the height as needed
                  width: 80, // Adjust the width as needed
                  fit: BoxFit.cover,
                ).image
              : (imageURL != null && !imageURL!.isEmpty)
                  ? Image.memory(
                      imageURL!,
                      height: 100, // Adjust the height as needed
                      width: 100, // Adjust the width as needed
                      fit: BoxFit.cover,
                    ).image
                  : null,
          child: (_image1 == null && imageURL!.length == 0)
              ? Container(
                  width: 120, // Adjust the width as needed
                  height: 120, // Adjust the height as needed
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: Icon(
                    Icons.person,
                    color: Colors.white, // Set the color of the icon
                    size: 40, // Adjust the size of the icon
                  ),
                )
              : null,
        ),
      );

  Future<void> updateInstagramHandle(String instagramUsername) async {
    String url = "";
    if(instagramUsername == "") {
      url = '/updateInstagramHandle/$firebaseId';
    } else {
      url = '/updateInstagramHandle/$firebaseId/$instagramUsername';
    }
    try {
      final response = await http.post(ApiUtils.buildApiUrl(url));
      if (response.statusCode == 200) {
        print('Instagram handle updated successfully');
      } else {
        throw Exception('Failed to update Instagram handle');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  Future<void> updateProfileDescription(String profileDescription) async {
    String url = "";
    if(profileDescription == "") {
      url = '/updateProfileDescription/$firebaseId';
    } else {
      url = '/updateProfileDescription/$firebaseId/$profileDescription';
    }
    try {
      final response = await http.post(ApiUtils.buildApiUrl(url));
      if (response.statusCode == 200) {
        print('Profile description updated successfully');
      } else {
        throw Exception('Failed to update Instagram handle');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }


  Future<void> updateProfilePayment(String profilePayment) async {
    String url = "";
    if(profilePayment == "") {
      url = '/updateProfilePayment/$firebaseId';
    } else {
      url = '/updateProfilePayment/$firebaseId/$profilePayment';
    }
    try {
      final response = await http.post(ApiUtils.buildApiUrl(url));
      if (response.statusCode == 200) {
        print('Profile payment updated successfully');
      } else {
        throw Exception('Failed to update Instagram handle');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }


  Future<void> getInstagramHandle() async {
    Map<String, dynamic> data;
    var url = ApiUtils.buildApiUrl('/profiles/$firebaseId');
    http.Response response =
        await http.get(url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      String responseJson = Utf8Decoder().convert(response.bodyBytes);
      data = json.decode(responseJson);
      if (data['instagramHandle'] != null) {
        setState(() {
          instagramHandle = data['instagramHandle'];
          isInstagramHandleFetched = true; // Mark as fetched
        });
      }
    } else {
      print(response.statusCode);
    }
  }

  Future<void> getDescriptionHandle() async {
    Map<String, dynamic> data;
    var url = ApiUtils.buildApiUrl('/profiles/$firebaseId');
    http.Response response =
    await http.get(url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      String responseJson = Utf8Decoder().convert(response.bodyBytes);
      data = json.decode(responseJson);
      if (data['profileDescription'] != null) {
        setState(() {
          profileDescription = data['profileDescription'];
          isProfileDescriptionFetched = true; // Mark as fetched
        });
      }
    } else {
      print(response.statusCode);
    }
  }

  Future<void> getPaymentHandle() async {
    Map<String, dynamic> data;
    var url = ApiUtils.buildApiUrl('/profiles/$firebaseId');
    http.Response response =
    await http.get(url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      String responseJson = Utf8Decoder().convert(response.bodyBytes);
      data = json.decode(responseJson);
      if (data['profilePayment'] != null) {
        setState(() {
          paymentDescription = data['profilePayment'];
          isPaymentMethodFetched = true; // Mark as fetched
        });
      }
    } else {
      print(response.statusCode);
    }
  }

  // Future<void> deleteInstagramHandle() async {
  //   final url = '/deleteInstagramHandle/$firebaseId';
  //
  //   try {
  //     final response = await http.delete(ApiUtils.buildApiUrl(url));
  //     if (response.statusCode == 200) {
  //       setState(() {
  //         instagramHandle = "";
  //         isInstagramHandleFetched = true; // Mark as fetched
  //       });
  //     } else {
  //       throw Exception('Failed to delete Instagram handle');
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to connect to the server');
  //   }
  // }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch';
    }
  }

  Future<Uint8List?> getImageByProfile() async {
    final url = ApiUtils.buildApiUrl('/profilePicture/$firebaseId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        imageURL = response.bodyBytes;
        return response.bodyBytes;
      } else {
        throw Exception('Failed to load image');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> uploadItemImageToDB(File imageFile) async {
    const double MAX_FILE_SIZE_MB = 25.0;
    try {
      // Calculate file size
      int sizeInBytes = imageFile.lengthSync();
      double sizeInMb = sizeInBytes / (1024 * 1024);

      // Check file size limit (adjust limit as needed)
      if (sizeInMb > MAX_FILE_SIZE_MB) {
        throw Exception('File size exceeds the limit.');
      }

      // Open file stream
      var stream = await http.ByteStream(imageFile.openRead());

      var length = await imageFile.length();
      var uri = ApiUtils.buildApiUrl('/profile/profilePic/$firebaseId');

      var request = http.MultipartRequest("PUT", uri);
      var multipartFile = http.MultipartFile('file', stream, length,
          filename: path.basename(imageFile.path));

      request.files.add(multipartFile);

      // Send the request and wait for response
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var data = response.bodyBytes;
        print(data);
      } else {
        // Handle different status codes if needed
        print('Image upload failed. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // Handle exceptions
      print('Error uploading image: $e');
      return null;
    }
  }
}
