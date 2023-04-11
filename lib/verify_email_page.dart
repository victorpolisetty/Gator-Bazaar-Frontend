import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:http/http.dart' as http;
import 'package:student_shopping_v1/HomePageContent.dart';
import 'package:student_shopping_v1/new/screens/home/home_screen.dart';
import 'buyerhome.dart';

class VerifyEmailPage extends StatefulWidget {
  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  int pinNumber = 0;
  String firebaseId = "";
  Timer? timer;
  final controller = TextEditingController();
  final focusNode = FocusNode();
  bool isCorrectPin = false;
  int userIdFromDb = -1;

  @override
  void initState() {
    super.initState();

    /// user needs to be created before!
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    firebaseId = FirebaseAuth.instance.currentUser!.uid;
    // if (!isEmailVerified) {
    //   timer = Timer.periodic(
    //     Duration(seconds: 3),
    //     (_) => reloadFirebaseUser(),
    //   );
    // }
  }

  @override
  void dispose() {
    timer?.cancel();
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Future<void> updatedUserDbId() async {
    Map<String, dynamic> data;
    var url = Uri.parse(
        'http://Gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/profiles/$firebaseId'); // TODO -  call the recentItem service when it is built
    http.Response response =
        await http.get(url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      // data.map<Item>((json) => Item.fromJson(json)).toList();
      data = jsonDecode(response.body);
      currDbId = data['id'];
      // recipientProfileName = data['name'];
      print(response.statusCode);
    } else {
      print(response.statusCode);
    }
    //  });
  }

  // Future checkEmailVerified(int pinNumber) async {
  //   // call after email verification!
  //   await FirebaseAuth.instance.currentUser!.reload();
  //
  //   setState(() {
  //     isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
  //     if(isEmailVerified == true) {
  //       print("EMAIL VERIFIED");
  //     }
  //   });
  //
  //   if (isEmailVerified) timer?.cancel();
  // }

  // Future sendVerificationEmail() async {
  //   try {
  //     final user = FirebaseAuth.instance.currentUser!;
  //     await user.sendEmailVerification();
  //
  //     // setState(() => canResendEmail = false);
  //     // await Future.delayed(Duration(seconds: 5));
  //     // setState(() => canResendEmail = true);
  //   } catch (e) {
  //     Utils.showSnackBar(e.toString());
  //   }
  // }

  // Future sendVerificationEmail() async {
  //   try {
  //     await sendEmail(
  //         name: FirebaseAuth.instance.currentUser!.displayName,
  //         email: FirebaseAuth.instance.currentUser!.email,
  //         subject: "Verify Email for Gator Bazaar",
  //         message: "Your verification pin is: $pinNumber");
  //     // setState(() => canResendEmail = false);
  //     // await Future.delayed(Duration(seconds: 5));
  //     // setState(() => canResendEmail = true);
  //   } catch (e) {
  //     Utils.showSnackBar(e.toString());
  //   }
  // }

  // Future<void> updateAuthPin(int currDbId, int authPin) async {
  //   var url = Uri.parse(
  //       'http://Gatorbazaarbackend-env.eba-dktfi83z.us-east-1.elasticbeanstalk.com/profiles/$currDbId/deviceToken/$authPin');
  //   final http.Response response = await http.put(url, headers: {
  //     "Accept": "application/json",
  //     "Content-Type": "application/json"
  //   }
  //       // , body: tmpObj
  //       );
  //
  //   //  .then((response) {
  //   if (response.statusCode == 200) {
  //     print("Updated user pin to: " + authPin.toString());
  //     print(response.statusCode);
  //   } else {
  //     print(response.statusCode);
  //   }
  //   //  });
  // }

  // Future sendEmail(
  //     {required String? name,
  //     required String? email,
  //     required String subject,
  //     required String message}) async {
  //   final serviceId = 'service_go1yqd8';
  //   final templateId = 'template_jeol99r';
  //   final userId = '5mSpHYDMdzodEw91f';
  //   final accessToken = 'HX4LS_4uC9sqs9ZRex67S';
  //
  //   final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  //   final response = await http.post(
  //     url,
  //     headers: {'Content-Type': 'application/json'},
  //     body: json.encode({
  //       'service_id': serviceId,
  //       'template_id': templateId,
  //       'user_id': userId,
  //       'accessToken': accessToken,
  //       'template_params': {
  //         'user_name': name,
  //         'user_email': email,
  //         'user_subject': subject,
  //         'user_message': message
  //       }
  //     }),
  //   );
  //
  //   print(response.body);
  // }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? BuyerHomePage("Gator Bazaar")
      : Scaffold(
    backgroundColor: Colors.grey[350],
          // appBar: AppBar(
          //   title: Text('Verify Email'),
          //   backgroundColor: Colors.grey,
          // ),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'A verification pin has been sent to the email: ' +
                      FirebaseAuth.instance.currentUser!.email!,
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                Center(
                  child: Pinput(
                    length: 4,
                    controller: controller,
                    focusNode: focusNode,
                    defaultPinTheme: defaultPinTheme,
                    onCompleted: (pin) => setEmailVerification(firebaseId, pin, context).then((value) => reloadFirebaseUser()),

                    separator: const SizedBox(width: 16),
                    // validator: (value) {
                    //   return isCorrectPin ? null : 'Pin is incorrect. Check email for correct pin.';
                    // },
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(114, 178, 238, 1),
                            offset: Offset(0, 3),
                            blurRadius: 16,
                          )
                        ],
                      ),
                    ),
                    // onClipboardFound: (value) {
                    //   debugPrint('onClipboardFound: $value');
                    //   controller.setText(value);
                    // },
                    showCursor: true,
                    cursor: cursor,
                  ),
                ),
                SizedBox(height: 8),
                TextButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 24, color: Colors.black),
                  ),
                  onPressed: () => FirebaseAuth.instance.signOut(),
                ),
              ],
            ),
          ),
        );
  // Scaffold(
  //   appBar: AppBar(
  //     title: Text('Verify Email'),
  //   ),
  //   body: Padding(
  //     padding: EdgeInsets.all(16),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Text(
  //           'A verification email has been sent to your email.',
  //           style: TextStyle(fontSize: 20),
  //           textAlign: TextAlign.center,
  //         ),
  //         SizedBox(height: 24),
  //         ElevatedButton.icon(
  //           style: ElevatedButton.styleFrom(
  //             minimumSize: Size.fromHeight(50),
  //             primary: Colors.black
  //           ),
  //           icon: Icon(Icons.email, size: 32),
  //           label: Text(
  //             'Resend Email',
  //             style: TextStyle(fontSize: 24),
  //           ),
  //           onPressed: canResendEmail ? sendVerificationEmail : null,
  //           // onPressed: canResendEmail ? sendVerificationEmail : null,
  //         ),
  //         SizedBox(height: 8),
  //         TextButton(
  //           style: ElevatedButton.styleFrom(
  //             minimumSize: Size.fromHeight(50),
  //           ),
  //           child: Text(
  //             'Cancel',
  //             style: TextStyle(fontSize: 24),
  //           ),
  //           onPressed: () => FirebaseAuth.instance.signOut(),
  //         ),
  //       ],
  //     ),
  //   ),
  // );
  final defaultPinTheme = PinTheme(
    width: 56,
    height: 60,
    textStyle: GoogleFonts.poppins(
      fontSize: 22,
      color: const Color.fromRGBO(30, 60, 87, 1),
    ),
    decoration: BoxDecoration(
      color: Color.fromRGBO(222, 231, 240, .57),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.transparent),
    ),
  );

  final cursor = Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      width: 21,
      height: 1,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(137, 146, 160, 1),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );

  Future<void> reloadFirebaseUser() async {
    await FirebaseAuth.instance.currentUser?.reload();
    //   // call after email verification!
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      if (isEmailVerified == true) {
        print("EMAIL VERIFIED");
      }
    });

    if (isEmailVerified) timer?.cancel();
  }

  Future<void> setEmailVerification(String? uid, String? providedAuthPin, BuildContext context) async {
    //TODO: need to call this somewhere
    var url = Uri.parse(
        'http://Gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com/emailVerifiedStatus/$uid/$providedAuthPin');
    final http.Response response = await http.post(url, headers: {
      "Accept": "application/json",
      "Content-Type": "application/json"
    });

    //  .then((response) {
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      //TODO: GET TRUE OR FALSE
      //if false set pin code to "-1"
      //if true set pin code to "1"
      if (data == false) {
        setState(() {
          isCorrectPin = false;
        });
        showAlertDialog(context);
      } else {
        setState(() {
          isCorrectPin = true;
        });
      }
    } else {

      print(response.statusCode);
    }
    //  });
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
  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK", style: TextStyle(color: Colors.black),),
      onPressed: () {
        Navigator.pop(context);
        },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Gator Bazaar Verification"),
      content: Text("Incorrect Pin. Please try again!"),
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
}
