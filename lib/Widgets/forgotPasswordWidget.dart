import 'package:flutter/cupertino.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sizer/sizer.dart';
import 'package:student_shopping_v1/utils.dart';


class ForgotPasswordWidget extends StatefulWidget {
  final VoidCallback onClickedForgotPassword;

  const ForgotPasswordWidget({Key? key, required this.onClickedForgotPassword}) : super(key: key);
  @override
  State<ForgotPasswordWidget> createState() => _ForgotPasswordWidgetState();
}

class _ForgotPasswordWidgetState extends State<ForgotPasswordWidget> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  int userIdFromDb = -1;
  bool? checkBoxValue = false;
  @override

  void dispose() {
    emailController.dispose();

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
            child: Image.asset('assets/GatorBZR_Home.png')),
        Padding(
          padding: EdgeInsets.fromLTRB(3.w, 0, 0, 0),
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
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (email) =>
            //TODO: uncomment this delete underneath this
            (email != null && !EmailValidator.validate(email)) || (email != null && !email.endsWith('@ufl.edu')) ? 'Enter a valid .edu email' : null,
            decoration: InputDecoration(
              hintStyle: TextStyle(color: Colors.grey),
              hintText: 'Email',
              fillColor: Colors.white,
              focusColor: Colors.white,
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
        // ElevatedButton.icon(
        //   style:
        //   ElevatedButton.styleFrom(
        //       minimumSize: Size.fromHeight(50),
        //       primary: Colors.black
        //   ),
        //   icon: Icon(Icons.send, size: 32),
        //   label: Text(
        //     'Send Reset Email',
        //     style: TextStyle(fontSize: 24),
        //   ),
        //   onPressed: (){resetPassword(email: emailController.text.trim());},
        // ),
        Padding(
          padding: EdgeInsets.fromLTRB(3.w,1.5.h,3.w,3.5.h), // Use sizer to set padding
          child: FloatingActionButton.extended(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0), // Set the border radius here
            ),
            backgroundColor: Colors.white,
              onPressed: (){resetPassword(email: emailController.text.trim());},
            icon: Icon(Icons.check, color: Colors.black,),
            label: Text("Send Reset Email", style: TextStyle(color: Colors.black),),
          ),
        ),
        Center(
          child: RichText(
              text: TextSpan (
                  style: TextStyle(color: Colors.white),
                  text: 'Already have an account?  ',
                  children: [
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickedForgotPassword,
                        text: 'Log In',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.white
                        )
                    )
                  ]
              )
          ),
        )
      ],
    ),
  );
  Future resetPassword({required String email}) async {
    try {
      print(email);
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email)
          .then((value) =>
          showDialog(context: context,
        builder: (_) => alertDialog(context),
      ));

    } on FirebaseException catch (e) {
      print(e);
      
      Utils.showSnackBar(e.message);
    }

  }
  alertDialog(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text("Email Reset Sent!"),
      content: Text(emailController.text.trim()),
      actions: [
        CupertinoDialogAction(onPressed: () {
          Navigator.pop(context);
        },child: Text("Ok",style: TextStyle(fontWeight: FontWeight.bold))),

      ],
    );
  }

  // Future signIn() async {
  //   showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (context) => Center(child: CircularProgressIndicator()));
  //   try {
  //     await FirebaseAuth.instance.signInWithEmailAndPassword(
  //         email: emailController.text.trim(),
  //         password: passwordController.text.trim()
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     print(e);
  //
  //     Utils.showSnackBar(e.message);
  //   }
  //   navigatorKey.currentState!.popUntil((route) => route.isFirst);
  // }
}