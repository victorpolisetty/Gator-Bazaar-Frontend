import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
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
  Widget build(BuildContext context){
    return Container(
      color: Colors.black87,
      child: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          SizedBox(
              height: 25.h,
              width: 25.w,
              child: Image.asset('assets/GatorBZR_Home.png')),
          Form(
            key: _formKey, // Set the GlobalKey to the Form
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0,0,82.w,0),
                  child: Text("Email", style: TextStyle(fontWeight: FontWeight.bold, color:  Colors.white)),
                ),
                Padding(
                  padding: EdgeInsets.all(3.w), // Use sizer to set padding
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
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
                      fillColor: Colors.white,
                      focusColor: Colors.white,
                      hintStyle: TextStyle(color:Colors.grey),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 1.h), // Remove horizontal padding
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0,0,75.w,0),
                  child: Text("Password", style: TextStyle(fontWeight: FontWeight.bold, color:  Colors.white)),
                ),
                Padding(
                  padding: EdgeInsets.all(3.w), // Use sizer to set padding
                  child: TextFormField(
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
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
                      fillColor: Colors.white,
                      focusColor: Colors.white,
                      hintStyle: TextStyle(color:Colors.grey),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
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
              backgroundColor: Colors.white,
              onPressed: () {
                signIn();
              },
              icon: Icon(Icons.check, color: Colors.black,),
              label: Text("Sign In", style: TextStyle(color: Colors.black),),
            ),
          ),
          SizedBox(height: 1.h),
          Center(
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.white),
                text: 'No account?  ',
                children: [
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = widget.onClickedSignUp,
                    text: 'Sign Up',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.white,
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
                style: TextStyle(color: Colors.white),
                text: 'Forgot Password?  ',
                children: [
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = widget.onClickedForgotPassword,
                    text: 'Reset',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }



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