import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:student_shopping_v1/Widgets/LoginWidget.dart';
import 'package:student_shopping_v1/auth_page.dart';
import 'package:student_shopping_v1/main.dart';
import 'package:student_shopping_v1/pages/sellerProfilePage.dart';
import '../models/itemModel.dart';
import '../models/sellerItemModel.dart';
import '../new/components/productCardSellerView.dart';
import '../new/size_config.dart';
import 'itemDetailPage.dart';


class SellerProfilePageNew extends StatefulWidget {
  const SellerProfilePageNew({Key? key}) : super(key: key);

  @override
  State<SellerProfilePageNew> createState() => _SellerProfilePageNewState();
}

class _SellerProfilePageNewState extends State<SellerProfilePageNew> {
  Future<User?> isSignedIn() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    return currentUser;
  }
  showAlertDialogSignOut(BuildContext context) {

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Future<void> _signOut() async {
      await FirebaseAuth.instance.signOut();
    }

    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed:  () async {
        _signOut()
            .then((value) => Navigator.of(context).pop())
        .then((res) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainPage()),
          );
        });
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
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed:  () {
        Navigator.of(context).pop();
        FirebaseAuth.instance.signOut();
        FirebaseAuth.instance.currentUser?.delete();
        FirebaseAuth.instance.authStateChanges();
        deleteUserFromDB(Provider.of<SellerItemModel>(context, listen: false).userIdFromDB);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete Account?"),
      content: Text("Are you sure you want to DELETE ACCOUNT?"),
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
    var url = Uri.parse('http://Gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/profiles/$id');
    http.Response response = await http.delete(url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print (response.statusCode);
    }
  }

  final PagingController<int, ItemWithImages> _pagingController =
  PagingController(firstPageKey: 0);
  int totalPages = 0;
  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey, 1);
    });
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
    if(!mounted) _pagingController.dispose();
  }

  Future<void> _fetchPage(int pageKey, int categoryId) async {
    try {
      await Provider.of<SellerItemModel>(context, listen: false).initNextCatPage(pageKey);
      totalPages = Provider.of<SellerItemModel>(context, listen: false).totalPages;
      if(mounted) {
        final isLastPage = (totalPages-1) == pageKey;

        if (isLastPage) {
          _pagingController.appendLastPage(Provider.of<SellerItemModel>(context, listen: false).items);
        } else {
          final int? nextPageKey = pageKey + 1;
          _pagingController.appendPage(Provider.of<SellerItemModel>(context, listen: false).items, nextPageKey);
        }
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          User currentUser = snapshot.data!;
          String? dname = snapshot.data!.displayName;
          String? email = snapshot.data!.email;
          return Scaffold(
            appBar: AppBar(
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black54,
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
            body: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate([
                    Center(
                      child: Text(
                        dname.toString(),
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 8.w, // Use sizer to set font size
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.sp), // Use sizer to set height
                    Center(
                      child: Text(
                        email.toString(),
                        style: TextStyle(
                          fontSize: 4.w, // Use sizer to set font size
                          fontFamily: 'Montserrat',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h), // Use sizer to set height
                    Padding(
                      padding: EdgeInsets.all(20.sp), // Use sizer to set padding
                      child: Text(
                        "My Listings",
                        style: TextStyle(
                          fontSize: 20.sp, // Use sizer to set font size
                          fontFamily: 'Montserrat',
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ]),
                ),
                SliverPadding(
                  padding: EdgeInsets.all(5.sp), // Use sizer to set padding
                  sliver: PagedSliverGrid(
                    pagingController: _pagingController,
                    builderDelegate: PagedChildBuilderDelegate<ItemWithImages>(
                      firstPageProgressIndicatorBuilder: (_) => Center(child: spinkit),
                      newPageProgressIndicatorBuilder: (_) => Center(child: spinkit),
                      noItemsFoundIndicatorBuilder: (_) => Center(child: Text("No Items Yet :)", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),)),
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
                      mainAxisSpacing: 0, // Use sizer to set main axis spacing
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container(
            height: 350.sp, // Use sizer to set height
            width: MediaQuery.of(context).size.width,
            child: spinkit,
          );
        }
      },
    );
  }
}