import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sizer/sizer.dart';
import 'package:student_shopping_v1/main.dart';
import 'package:student_shopping_v1/pages/itemDetailPage.dart';
import 'package:student_shopping_v1/utils.dart';

import '../buyerhome.dart';

class LoginWidget extends StatefulWidget {
  final VoidCallback onClickedSignUp;
  final VoidCallback onClickedForgotPassword;

  const LoginWidget({Key? key, required this.onClickedSignUp, required this.onClickedForgotPassword}) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode myFocusNode = new FocusNode();


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => 
      ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
      SizedBox(
        height: 25.h,
          width: 25.w,
          child: Image.asset('assets/images/GatorBazaar.jpg')),
      Form(
        key: _formKey, // Set the GlobalKey to the Form
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0,0,82.w,0),
              child: Text("Email", style: TextStyle(fontWeight: FontWeight.bold, color:  Colors.black)),
            ),
            Padding(
              padding: EdgeInsets.all(3.w), // Use sizer to set padding
              child: TextFormField(
                cursorColor: Colors.black,
                keyboardType: TextInputType.multiline,
                maxLines: 1,
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
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
            Padding(
              padding: EdgeInsets.fromLTRB(0,0,75.w,0),
              child: Text("Password", style: TextStyle(fontWeight: FontWeight.bold, color:  Colors.black)),
            ),
            Padding(
              padding: EdgeInsets.all(3.w), // Use sizer to set padding
              child: TextFormField(
                cursorColor: Colors.black,
                keyboardType: TextInputType.multiline,
                maxLines: 1,
                controller: passwordController,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
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
          ],
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
            signIn();
          },
          icon: Icon(Icons.check),
          label: Text("Sign In"),
        ),
      ),
      SizedBox(height: 1.h),
      Center(
        child: RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black),
            text: 'No account?  ',
            children: [
              TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = widget.onClickedSignUp,
                text: 'Sign Up',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
      ),
      SizedBox(height: 10),
      Center(
        child: RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black),
            text: 'Forgot Password?  ',
            children: [
              TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = widget.onClickedForgotPassword,
                text: 'Reset',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
      ),
    ],
  );

  Future<void> signIn() async {
    // Validate the form
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: spinkit),
      );

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        // Navigate to BuyerHomePage after successful sign-in
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Sizer(
            builder: (context, orientation, deviceType) {
              return BuyerHomePage("Gator Bazaar");
            },
          ),
        ));
      } on FirebaseAuthException catch (e) {
        print(e);
        Utils.showSnackBar(e.message);
      } finally {
        // Close the loading spinner dialog regardless of success or failure
        Navigator.of(context).pop();
      }
    }
  }
}