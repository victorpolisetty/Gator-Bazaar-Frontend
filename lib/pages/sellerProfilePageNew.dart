import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:student_shopping_v1/pages/addGroupsPage.dart';
import 'package:student_shopping_v1/pages/manageGroupsPage.dart';
import 'package:student_shopping_v1/pages/sellerProfilePage.dart';
import '../models/sellerItemModel.dart';
import '../new/size_config.dart';
import 'itemDetailPage.dart';
import 'dart:io';
import 'package:student_shopping_v1/models/groupModel.dart';


class SellerProfilePageNew extends StatefulWidget {
  const SellerProfilePageNew({Key? key}) : super(key: key);

  @override
  State<SellerProfilePageNew> createState() => _SellerProfilePageNewState();
}

class _SellerProfilePageNewState extends State<SellerProfilePageNew> {
  Future<User?> isSignedIn() async {
    await Future.delayed(Duration(seconds: 1));
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
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed:  () {
        Navigator.of(context).pop();
        FirebaseAuth.instance.signOut();
        FirebaseAuth.instance.authStateChanges();
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
    // String firebaseId = currentUser!.uid;
    Map<String, dynamic> data;
    var url = Uri.parse('http://Gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/profiles/$id');
    http.Response response = await http.delete(url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      // data.map<Item>((json) => Item.fromJson(json)).toList();
      print(response.body);
    } else {
      print (response.statusCode);
    }
  }
  XFile? _pickedImage;

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<User?>(
      future: isSignedIn(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.hasData) {
          String? dname = snapshot.data!.displayName;
          String? email = snapshot.data!.email;
          return Column(
            children: [
              AppBar(
                elevation: .1,
                actions: [
                  PopupMenuButton(
                    // add icon, by default "3 dot" icon
                    // icon: Icon(Icons.book)
                      itemBuilder: (context){
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
                      onSelected:(value){
                        if(value == 0){
                          showAlertDialogSignOut(context);
                        }else if(value == 1){
                          showAlertDialogDeleteAccount(context);
                        }
                      }
                  ),
                  // IconButton(
                  //   icon: Icon(Icons.exit_to_app_outlined),
                  //   color: Colors.black,
                  //   onPressed: () {
                  //     showAlertDialog(context);
                  //   },
                  // )
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(100),),
              Container(
                  height: getProportionateScreenHeight(67),
                  // width: MediaQuery.of(context).size.width,
                  child: Hero(
                    tag:
                        'https://images.unsplash.com/photo-1598369685311-a22ca3406009?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1234&q=80',
                    // child: InkWell(
                    // onTap: (){
                    //   // _showPickOptionsDialog(context);
                    //   print("HIT ME");
                    // },
                    child: CircleAvatar(
                      radius: 70,
                      // child: _pickedImage == null ? Text("Picture") : null,
                      backgroundImage: _pickedImage != null
                          ? FileImage(File(_pickedImage!.path))
                          : AssetImage('assets/images/defaultPic.png')
                              as ImageProvider,
                    )
                    // )
                    ,
                  )),
              SizedBox(height: getProportionateScreenHeight(20)),
              Text(
                dname.toString(),
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: getProportionateScreenWidth(40),
                    fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: getProportionateScreenHeight(8)),
              Text(
                email.toString(),
                style: TextStyle(fontSize: 20, fontFamily: 'Montserrat', color: Colors.black),
              ),
              SizedBox(height: getProportionateScreenHeight(19)),
              ElevatedButton.icon(
                style:
                ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                    primary: Colors.black
                ),
                icon: Icon(Icons.shopping_bag, size: 32),
                label: Text(
                  'See Listings',
                  style: TextStyle(fontSize: 24),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => sellerProfilePage(),
                  ));
        }
              ),
              SizedBox(height: getProportionateScreenHeight(19)),
              ElevatedButton.icon(
                  style:
                  ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50),
                      primary: Colors.black
                  ),
                  icon: Icon(Icons.group, size: 32),
                  label: Text(
                    'Manage Groups',
                    style: TextStyle(fontSize: 24),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => manageGroupsPage(),
                    ));
                  }
              ),
              // SizedBox(height: getProportionateScreenHeight(19)),
              // ElevatedButton.icon(
              //     style:
              //     ElevatedButton.styleFrom(
              //         minimumSize: Size.fromHeight(50),
              //         primary: Colors.black
              //     ),
              //     icon: Icon(Icons.add, size: 32),
              //     label: Text(
              //       'Add Groups',
              //       style: TextStyle(fontSize: 24),
              //     ),
              //     onPressed: () {
              //       Navigator.of(context).push(MaterialPageRoute(
              //         builder: (context) => addGroupsPage(),
              //       ));
              //     }
              // ),
              // Text(
              //   'My Listings',
              //   style: TextStyle(
              //       fontFamily: 'Montserrat',
              //       color: Colors.black),
              // )
            ]
          );
  }else {
          return Container(
            height: 350,
            width: MediaQuery.of(context).size.width,
            // height: MediaQuery.of(context).size.height,
            child: spinkit,
          );
        }
}
);
  }}
