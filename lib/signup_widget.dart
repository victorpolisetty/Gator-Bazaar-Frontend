import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:student_shopping_v1/main.dart';
import 'package:student_shopping_v1/utils.dart';

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
  @override
  // void initState() {
  //   Future<void> createAuthPinAndVerificationCode( String? uid, String? email) async {
  //     String url = 'http://Gatorbazaarbackendtested2-env.eba-g27rcqgs.us-east-1.elasticbeanstalk.com/setPinAndSendEmail/$uid/$email';
  //     final http.Response response =  await http.post(
  //         Uri.parse(url),
  //         headers: {
  //           "Accept": "application/json",
  //           "Content-Type": "application/json"
  //         });
  //     if (response.statusCode == 200) {
  //       print(response.statusCode);
  //       print("Sent email");
  //     } else {
  //       print(response.statusCode);
  //     }
  //   }
  //   createAuthPinAndVerificationCode("pjT5CDwY5STAwP7LGvIAOnQTHfm2", "victorpolisetty@ufl.edu");
  // }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();

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
            controller: emailController,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: 'Email'),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (email) =>
            //TODO: uncomment this delete underneath this
               (email != null && !EmailValidator.validate(email)) || (email != null && !email.endsWith('@ufl.edu')) ? 'Enter a valid @ufl.edu email' : null,
            // (email != null && !EmailValidator.validate(email)) ? 'Enter a valid @ufl.edu email' : null,

          ),
          SizedBox(height: 4),
          TextFormField(
            textCapitalization: TextCapitalization.sentences,
            controller: firstNameController,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: 'First Name'),
            // autovalidateMode: AutovalidateMode.onUserInteraction,
            // validator: (email) =>
            // email != null && !EmailValidator.validate(email) ? 'Enter a valid email' : null,
          ),
          SizedBox(height: 4),
          TextFormField(
            textCapitalization: TextCapitalization.sentences,
            controller: lastNameController,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: 'Last Name'),
            // autovalidateMode: AutovalidateMode.onUserInteraction,
            // validator: (email) =>
            // email != null && !EmailValidator.validate(email) ? 'Enter a valid email' : null,
          ),
          SizedBox(height: 4),
          TextFormField(
            controller: passwordController,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(labelText: "Password"),
            obscureText: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => value != null && value.length < 6 ? 'Enter min. 6 characters' : null,
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            style:
            ElevatedButton.styleFrom(
              minimumSize: Size.fromHeight(50),
              primary: Colors.black
            ),
            icon: Icon(Icons.lock_open, size: 32),
            label: Text(
              'Sign Up',
              style: TextStyle(fontSize: 24),
            ),
            onPressed: signUp,
          ),
          SizedBox(height: 24),
          RichText(
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
          )
        ],
      ),
    ),
  );

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim()
      )
          .then((value) => FirebaseAuth.instance.currentUser?.updateDisplayName(firstNameController.text.trim() + " " + lastNameController.text.trim()))
          .then((value) => addProfileToDB(FirebaseAuth.instance.currentUser?.email,FirebaseAuth.instance.currentUser?.displayName,FirebaseAuth.instance.currentUser?.uid));
         await createAuthPinAndVerificationCode(FirebaseAuth.instance.currentUser!.uid, FirebaseAuth.instance.currentUser!.email);
    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
  Future<void> addProfileToDB(String? email, String? name, String? uid) async {
    final http.Response response =  await http.post(
      // Uri.parse('http://Gatorbazaarbackendtested2-env.eba-g27rcqgs.us-east-1.elasticbeanstalk.com/profiles'),
      Uri.parse('http://Gatorbazaarbackendtested2-env.eba-g27rcqgs.us-east-1.elasticbeanstalk.com/profiles'),

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
      print(response.statusCode);
      print("Done with adding profile");
    } else {
      print(response.statusCode);
    }
  }

  Future<void> createAuthPinAndVerificationCode( String? uid, String? email) async {
    String url = 'http://Gatorbazaarbackendtested2-env.eba-g27rcqgs.us-east-1.elasticbeanstalk.com/setPinAndSendEmail/$uid/$email';
    final http.Response response =  await http.post(
      Uri.parse(url),
        headers: {
        "Accept": "application/json",
          "Content-Type": "application/json"
    });
    if (response.statusCode == 200) {
      print(response.statusCode);
      print("Sent email");
    } else {
      print(response.statusCode);
    }
  }

  Future<void> getProfileFromDb(String? firebaseid) async {
    Map<String, dynamic> data;
    var url = Uri.parse('http://Gatorbazaarbackendtested2-env.eba-g27rcqgs.us-east-1.elasticbeanstalk.com/profiles/$firebaseid'); // TODO -  call the recentItem service when it is built
    http.Response response = await http.get(
        url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      // data.map<Item>((json) => Item.fromJson(json)).toList();
      data = jsonDecode(response.body);
      userIdFromDb = data['id'];
      print(response.statusCode);
    } else {
      print(response.statusCode);
    }
  }

}