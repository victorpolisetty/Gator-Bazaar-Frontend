import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:student_shopping_v1/main.dart';
import 'package:student_shopping_v1/utils.dart';
import 'package:url_launcher/url_launcher.dart';


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
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: EdgeInsets.all(16),
    child: Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/GatorBazaar.jpg'),
          SizedBox(height: 40),
          TextFormField(
            cursorColor: Colors.black,
            controller: emailController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: 'Email'),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (email) =>
            //TODO: uncomment this delete underneath this
            (email != null && !EmailValidator.validate(email)) || (email != null && !email.endsWith('@ufl.edu')) ? 'Enter a valid .edu email' : null,
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            style:
            ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(50),
                primary: Colors.black
            ),
            icon: Icon(Icons.send, size: 32),
            label: Text(
              'Send Reset Email',
              style: TextStyle(fontSize: 24),
            ),
            onPressed: (){resetPassword(email: emailController.text.trim());},
          ),
          SizedBox(height: 24),
          RichText(
              text: TextSpan (
                  style: TextStyle(color: Colors.black),
                  text: 'Already have an account?  ',
                  children: [
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickedForgotPassword,
                        text: 'Log In',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.black
                        )
                    )
                  ]
              )
          )
        ],
      ),
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