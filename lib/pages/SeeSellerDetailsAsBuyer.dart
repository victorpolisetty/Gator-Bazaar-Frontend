import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

import 'package:student_shopping_v1/main.dart';
import 'package:student_shopping_v1/new/components/product_card.dart';
import 'package:url_launcher/url_launcher.dart';
import '../api_utils.dart';
import '../models/chatMessageModel.dart';
import '../models/itemModel.dart';
import '../models/sellerItemModel.dart';

import 'itemDetailPage.dart';

class SeeSellerDetailsAsBuyer extends StatefulWidget {
  ChatMessageHome chatHome;
  SeeSellerDetailsAsBuyer(chatHome) : this.chatHome = chatHome;
  @override
  State<SeeSellerDetailsAsBuyer> createState() =>
      _SeeSellerDetailsAsBuyerState();
}

class _SeeSellerDetailsAsBuyerState extends State<SeeSellerDetailsAsBuyer> {
  File? _image1;
  bool isInstagramHandleFetched = false;
  bool isProfileDescriptionFetched = false;
  bool isProfilePaymentFetched = false;

  late String? displayName;
  late int? currentDbId;

  Future<User?> isSignedIn() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    return currentUser;
  }

  showAlertDialogSignOut(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Future<void> _signOut() async {
      await FirebaseAuth.instance.signOut();
    }

    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed: () async {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Block?"),
      content: Text("Are you sure you want to block this account?"),
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
    Future<void> _signOut() async {
      await FirebaseAuth.instance.signOut();
    }

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
    Map<String, dynamic> data;
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
  String? instagramHandle = "";
  String? profileDescription = "";
  String? profilePayment = "";
  String? email = "";
  Uint8List? imageURL = new Uint8List(0);

  @override
  void initState() {
    currentDbId =
        widget.chatHome.current_user_id == widget.chatHome.creator_user_id
            ? widget.chatHome.recipient_user_id
            : widget.chatHome.creator_user_id;
    displayName =
        widget.chatHome.current_user_id == widget.chatHome.creator_user_id
            ? widget.chatHome.recipient_profile_name
            : widget.chatHome.creator_profile_name;
    widget.chatHome.creator_profile_name;
    _initializeData();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey, currentDbId!);
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (!mounted) _pagingController.dispose();
  }

  Future<void> _fetchPage(int pageKey, int currentDbId) async {
    try {
      await Provider.of<SellerItemModel>(context, listen: false)
          .initNextPageUserClicksMessage(pageKey, currentDbId);
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
      await getProfileDescription();
    }
    if (!isProfilePaymentFetched) {
      await getProfilePayment();
    }
    await getImageByProfile();
  }

  User? user = FirebaseAuth.instance.currentUser!;
  String? firebaseId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeData(), // Change here to use first
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Colors.black87,
            height: 350.sp, // Use sizer to set height
            width: MediaQuery.of(context).size.width,
            child: spinkit,
          );
        } else if (snapshot.hasError) {
          // Handle error case
          return Text('Error: ${snapshot.error}');
        } else {
          return Scaffold(
            appBar: AppBar(
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
              title: Text(widget.chatHome.creator_user_id ==
                      widget.chatHome.current_user_id
                  ? widget.chatHome.recipient_profile_name!
                  : widget.chatHome.creator_profile_name!),
              actions: [
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
                                  25.0), // Adjust the height value as needed
                              buildProfileImage(),
                            ],
                          ),

                          SizedBox(width: 5.w), // Use sizer to set width
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  height: 2.h), // Use sizer to set height
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
                                        fontSize: 1.2.h, color: Colors.grey),
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
                                        profileDescription!,
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
                                        fontSize: 1.2.h, color: Colors.grey),
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
                                      "@" + instagramHandle!,
                                      style: TextStyle(
                                          fontSize: 3.w,
                                          color: Colors.blueAccent),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              profilePayment! == ""
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
                                          fontSize: 1.2.h, color: Colors.grey),
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
                                        profilePayment!,
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
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 1.h), // Use sizer to set height
                      Padding(
                        padding:
                            EdgeInsets.all(10.sp), // Use sizer to set padding
                        child: Text(
                          displayName!.split(' ')[0] + "'s Listings",
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
                          return ProductCard(
                            product: item,
                            uniqueIdentifier: "messagingView",
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

  Widget buildProfileImage() => CircleAvatar(
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
                  color: Colors.grey,
                ),
                child: Icon(
                  Icons.person,
                  color: Colors.white, // Set the color of the icon
                  size: 40, // Adjust the size of the icon
                ),
              )
            : null,
      );

  Future<void> getInstagramHandle() async {
    Map<String, dynamic> data;
    var url = ApiUtils.buildApiUrl('/profiles/profileId/$currentDbId');
    http.Response response =
        await http.get(url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      if (data['instagramHandle'] != null) {
        setState(() {
          instagramHandle = data['instagramHandle'];
          isInstagramHandleFetched = true; // Mark as fetched
        });
      }
      email = data['emailId'];
    } else {
      print(response.statusCode);
    }
  }

  Future<void> getProfileDescription() async {
    Map<String, dynamic> data;
    var url = ApiUtils.buildApiUrl('/profiles/profileId/$currentDbId');
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

  Future<void> getProfilePayment() async {
    Map<String, dynamic> data;
    var url = ApiUtils.buildApiUrl('/profiles/profileId/$currentDbId');
    http.Response response =
        await http.get(url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      String responseJson = Utf8Decoder().convert(response.bodyBytes);
      data = json.decode(responseJson);
      if (data['profilePayment'] != null) {
        setState(() {
          profilePayment = data['profilePayment'];
          isProfilePaymentFetched = true; // Mark as fetched
        });
      }
    } else {
      print(response.statusCode);
    }
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch';
    }
  }

  Future<Uint8List?> getImageByProfile() async {
    final url = ApiUtils.buildApiUrl('/profilePicture/profileId/$currentDbId');

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
}
