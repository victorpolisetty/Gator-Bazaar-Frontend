import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sizer/sizer.dart';
import 'package:student_shopping_v1/main.dart';
import 'package:student_shopping_v1/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api_utils.dart';
import '../pages/itemDetailPage.dart';


class SignUpWidget extends StatefulWidget {
  final VoidCallback onClickedSignIn;

  const SignUpWidget({Key? key, required this.onClickedSignIn}) : super(key: key);
  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  int userIdFromDb = -1;
  bool? checkBoxValue = false;
  FocusNode myFocusNode = new FocusNode();

  @override

  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) => Form(
    key: formKey,
    child: ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: [
        SizedBox(
            height: 25.h,
            width: 25.w,
            child: Image.asset('assets/images/GatorBazaar.jpg')),        // TextFormField(
        //   cursorColor: Colors.black,
        //   controller: emailController,
        //   textInputAction: TextInputAction.next,
        //   decoration: InputDecoration(labelText: 'Email'),
        //   autovalidateMode: AutovalidateMode.onUserInteraction,
        //   validator: (email) =>
        //   //TODO: uncomment this delete underneath this
        //      (email != null && !EmailValidator.validate(email)) || (email != null && !email.endsWith('@ufl.edu')) ? 'Enter a valid .edu email' : null,
        // ),
        Padding(
          padding: EdgeInsets.fromLTRB(3.w, 0, 0, 0),
          child: Text("Email", style: TextStyle(fontWeight: FontWeight.bold, color:  Colors.black)),
        ),
        Padding(
          padding: EdgeInsets.all(3.w), // Use sizer to set padding
          child: TextFormField(
            cursorColor: Colors.black,
            keyboardType: TextInputType.multiline,
            maxLines: 1,
            controller: emailController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) =>
              //TODO: uncomment this delete underneath this
                 (email != null && !EmailValidator.validate(email)) || (email != null && !email.endsWith('@ufl.edu')) ? 'Enter a valid .edu email' : null,
            decoration: InputDecoration(
              hintText: 'Email',
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
        SizedBox(height: 4),
        Padding(
          padding: EdgeInsets.fromLTRB(3.w, 0, 0, 0),
          child: Text("First Name", style: TextStyle(fontWeight: FontWeight.bold, color:  Colors.black)),
        ),
        Padding(
          padding: EdgeInsets.all(3.w), // Use sizer to set padding
          child: TextFormField(
            cursorColor: Colors.black,
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
            maxLines: 1,
            controller: firstNameController,
            decoration: InputDecoration(
              hintText: 'First Name',
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
        SizedBox(height: 4),
        Padding(
          padding: EdgeInsets.fromLTRB(3.w, 0, 0, 0),
          child: Text("Last Name", style: TextStyle(fontWeight: FontWeight.bold, color:  Colors.black)),
        ),
        Padding(
          padding: EdgeInsets.all(3.w), // Use sizer to set padding
          child: TextFormField(
            cursorColor: Colors.black,
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
            maxLines: 1,
            controller: lastNameController,
            decoration: InputDecoration(
              hintText: 'Last Name',
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
        SizedBox(height: 4),
        Padding(
          padding: EdgeInsets.fromLTRB(3.w, 0, 0, 0),
          child: Text("Password", style: TextStyle(fontWeight: FontWeight.bold, color:  Colors.black)),
        ),
        // TextFormField(
        //   cursorColor: Colors.black,
        //   controller: passwordController,
        //   textInputAction: TextInputAction.done,
        //   decoration: InputDecoration(labelText: "Password"),
        //   obscureText: true,
        //   autovalidateMode: AutovalidateMode.onUserInteraction,
        //   validator: (value) => value != null && value.length < 6 ? 'Enter min. 6 characters' : null,
        // ),
        Padding(
          padding: EdgeInsets.all(3.w), // Use sizer to set padding
          child: TextFormField(
            cursorColor: Colors.black,
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
            maxLines: 1,
            controller: passwordController,
              obscureText: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => value != null && value.length < 6 ? 'Enter min. 6 characters' : null,
            decoration: InputDecoration(
              hintText: 'Password',
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
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.fromLTRB(3.w,0,3.w,3.5.h), // Use sizer to set padding
          child: FloatingActionButton.extended(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0), // Set the border radius here
            ),
            backgroundColor: Colors.black,
            onPressed: () {
              _launchUrl("https://docs.google.com/document/d/1Au1nHDDSdrnfFZFROdV6aSrVBg0tnemU8PJ-6c1oHfQ/edit#heading=h.5wn9zmiu3ly6");
            },
            icon: Icon(Icons.note_alt_sharp),
            label: Text("Terms of Service"),
          ),
        ),
        // ElevatedButton(  style:ElevatedButton.styleFrom(
        //     primary: Colors.black
        // ),onPressed: () { _launchUrl("https://docs.google.com/document/d/1Au1nHDDSdrnfFZFROdV6aSrVBg0tnemU8PJ-6c1oHfQ/edit#heading=h.5wn9zmiu3ly6"); },
        //     child: Text("Terms of Service")),
        Padding(
          padding: EdgeInsets.fromLTRB(3.w,0,3.w,2.h), // Use sizer to set padding
          child: FloatingActionButton.extended(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0), // Set the border radius here
            ),
            backgroundColor: Colors.black,
            onPressed: () {
              _launchUrl("https://docs.google.com/document/d/1K0FeDwN0YmE13Hbf3FZA77Q4sLiRmw2cz3C7Xd28GJ4/edit#heading=h.eykxcvd8q5gq");            },
            icon: Icon(Icons.note_alt_sharp),
            label: Text("End User License Agreement"),
          ),
        ),
        // ElevatedButton(  style:ElevatedButton.styleFrom(
        //     primary: Colors.black
        // ),onPressed: () { _launchUrl("https://docs.google.com/document/d/1K0FeDwN0YmE13Hbf3FZA77Q4sLiRmw2cz3C7Xd28GJ4/edit#heading=h.eykxcvd8q5gq"); },
        //     child: Text("End User License Agreement")),
        Row(
          children: [
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(left: 5.w), // Adjust the value as needed
                child: Text(
                  "I agree to the Terms of Service and End User License Agreement",
                  softWrap: true,
                  style: TextStyle(color: Colors.grey[800]),
                ),
              ),
            ),
            Checkbox(
              value: checkBoxValue,
              activeColor: Colors.black,
              onChanged: (bool? newValue) {
                setState(() {
                  checkBoxValue = newValue;
                });
              },
            ),
          ],
        ),

        Padding(
          padding: EdgeInsets.fromLTRB(3.w,1.5.h,3.w,3.5.h), // Use sizer to set padding
          child: FloatingActionButton.extended(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0), // Set the border radius here
            ),
            backgroundColor: Colors.black,
            onPressed: () {
              signUp();
            },
            icon: Icon(Icons.check),
            label: Text("Sign Up"),
          ),
        ),
        Center(
          child: RichText(
              text: TextSpan (
                  style: TextStyle(color: Colors.black),
                  text: 'Already have an account?  ',
                  children: [
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickedSignIn,
                        text: 'Log In',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.black
                        )
                    )
                  ]
              )
          ),
        )
      ],
    ),
  );

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    if (checkBoxValue == false) {
      showAlertDialogUserAgreement(context);
    }
    else {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(child: spinkit));
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim()
        )
            .then((value) => FirebaseAuth.instance.currentUser?.updateDisplayName(firstNameController.text.trim() + " " + lastNameController.text.trim()))
            .then((value) => addProfileToDB(FirebaseAuth.instance.currentUser?.email,FirebaseAuth.instance.currentUser?.displayName,FirebaseAuth.instance.currentUser?.uid))
            .then((value) => getProfileFromDb(FirebaseAuth.instance.currentUser!.uid))
            .then((value) => addGroupToProfile(userIdFromDb,1));
        await createAuthPinAndVerificationCode(FirebaseAuth.instance.currentUser!.uid, FirebaseAuth.instance.currentUser!.email);
      } on FirebaseAuthException catch (e) {
        print(e);

        Utils.showSnackBar(e.message);
      }
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    }
  }
  Future<void> addProfileToDB(String? email, String? name, String? uid) async {
    final http.Response response =  await http.post(
      ApiUtils.buildApiUrl('/profiles'),

      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'emailId': email!,
        'name': name!,
        'description': name,
        'firebaseUID' : uid!
      }),
    );

    if (response.statusCode == 200) {
    } else {
      print(response.statusCode);
    }
  }

  Future<void> createAuthPinAndVerificationCode( String? uid, String? email) async {
    String url = '/setPinAndSendEmail/$uid/$email';
    final http.Response response =  await http.post(
        ApiUtils.buildApiUrl(url),
        headers: {
        "Accept": "application/json",
          "Content-Type": "application/json"
    });
    if (response.statusCode == 200) {
      print("Sent email");
    } else {
      print(response.statusCode);
    }
  }

  Future<void> getProfileFromDb(String? firebaseid) async {
    Map<String, dynamic> data;
    var url = ApiUtils.buildApiUrl('/profiles/$firebaseid'); // TODO -  call the recentItem service when it is built
    http.Response response = await http.get(
        url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      // data.map<Item>((json) => Item.fromJson(json)).toList();
      data = jsonDecode(response.body);
      userIdFromDb = data['id'];
    } else {
      print(response.statusCode);
    }
  }

  Future<void> addGroupToProfile(int profileId, int groupId) async {
    final url = ApiUtils.buildApiUrl('/profile/addGroupToProfile/$profileId/$groupId');

    final response = await http.put(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      // Assuming the response contains the ProfileGroup dat
      return;
    } else {
      throw Exception('Failed to add group to profile');
    }
  }
  showAlertDialogUserAgreement(BuildContext context) async {

    // set up the buttons
    Widget okButton = TextButton(
      child: Text("Ok"),
      onPressed:  () {
        Navigator.of(context).pop();
        return;
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Terms of Service and End User License"),
      content: Text("You must accept the Terms of Service and End User License Agreement to use Gator Bazaar"),
      actions: [
        okButton,
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

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch';
    }
  }
}