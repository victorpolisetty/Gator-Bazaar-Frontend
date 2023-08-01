import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:student_shopping_v1/main.dart';
import 'package:student_shopping_v1/utils.dart';
import 'package:url_launcher/url_launcher.dart';


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
  @override

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
            cursorColor: Colors.black,
            controller: emailController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: 'Email'),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (email) =>
            //TODO: uncomment this delete underneath this
               (email != null && !EmailValidator.validate(email)) || (email != null && !email.endsWith('@ufl.edu')) ? 'Enter a valid .edu email' : null,
          ),
          SizedBox(height: 4),
          TextFormField(
            cursorColor: Colors.black,
            textCapitalization: TextCapitalization.sentences,
            controller: firstNameController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: 'First Name'),
          ),
          SizedBox(height: 4),
          TextFormField(
            cursorColor: Colors.black,

            textCapitalization: TextCapitalization.sentences,
            controller: lastNameController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: 'Last Name'),
            // autovalidateMode: AutovalidateMode.onUserInteraction,
            // validator: (email) =>
            // email != null && !EmailValidator.validate(email) ? 'Enter a valid email' : null,
          ),
          SizedBox(height: 4),
          TextFormField(
            cursorColor: Colors.black,

            controller: passwordController,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(labelText: "Password"),
            obscureText: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => value != null && value.length < 6 ? 'Enter min. 6 characters' : null,
          ),
          SizedBox(height: 20),
          ElevatedButton(  style:ElevatedButton.styleFrom(
              primary: Colors.black
          ),onPressed: () { _launchUrl("https://docs.google.com/document/d/1Au1nHDDSdrnfFZFROdV6aSrVBg0tnemU8PJ-6c1oHfQ/edit#heading=h.5wn9zmiu3ly6"); },
              child: Text("Terms of Service")),
          ElevatedButton(  style:ElevatedButton.styleFrom(
              primary: Colors.black
          ),onPressed: () { _launchUrl("https://docs.google.com/document/d/1K0FeDwN0YmE13Hbf3FZA77Q4sLiRmw2cz3C7Xd28GJ4/edit#heading=h.eykxcvd8q5gq"); },
              child: Text("End User License Agreement")),
          Row(
            children: [
              Expanded(child: Text("I agree to the Terms of Service and End User License Agreement")),
              Checkbox(
                  value: checkBoxValue,
                  activeColor: Colors.black,
                  onChanged:(bool? newValue){
                    setState(() {
                      checkBoxValue = newValue;
                    });
                  }
                  ),
            ],
          ),

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
    if (checkBoxValue == false) {
      showAlertDialogUserAgreement(context);
    }
    else {
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
  }
  Future<void> addProfileToDB(String? email, String? name, String? uid) async {
    final http.Response response =  await http.post(
      Uri.parse('http://Gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/profiles'),

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
    String url = 'http://Gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/setPinAndSendEmail/$uid/$email';
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
    var url = Uri.parse('http://Gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/profiles/$firebaseid'); // TODO -  call the recentItem service when it is built
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