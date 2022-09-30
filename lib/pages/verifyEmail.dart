import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_shopping_v1/applicationState.dart';
import 'package:student_shopping_v1/buyerhome.dart';

import '../Authentication/authentication.dart';
import '../widgets.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({Key? key}) : super(key: key);

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final auth = FirebaseAuth.instance;
  User? user;
  Timer? timer;
  int emailSendCounter = 0;

  @override
  void initState(){
    user = auth.currentUser;
    if(emailSendCounter == 0){
      user?.sendEmailVerification();
      emailSendCounter++;
    }
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(child: Text("An email has been sent to ${user?.email} please verify"),),
        Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 16.0, horizontal: 30),
          child: StyledButton(
            onPressed: () {
              user?.delete();
            },
            child: const Text('CANCEL',style: TextStyle(color: Colors.black),),
          ),
        ),
      ],
    );
  }
  Future<void> checkEmailVerified() async{
    user = auth.currentUser;
    await user?.reload();
    if(user?.emailVerified == true){
      timer?.cancel();

      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BuyerHomePage("Student Shop")));
    }
    // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BuyerHomePage("Student Shop")));
  }
}
