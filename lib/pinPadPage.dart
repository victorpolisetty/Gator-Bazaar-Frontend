// import 'dart:async';
//
// import 'package:firebase_admin/firebase_admin.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:pinput/pinput.dart';
// import 'package:http/http.dart' as http;
//
//
// class RoundedWithShadow extends StatefulWidget {
//   const RoundedWithShadow({Key? key, required this.pinNumber, required this.userEmail}) : super(key: key);
//   final String pinNumber;
//   final String? userEmail;
//
//   @override
//   _RoundedWithShadowState createState() => _RoundedWithShadowState();
//
//   @override
//   String toStringShort() => 'Rounded With Shadow';
// }
//
// class _RoundedWithShadowState extends State<RoundedWithShadow> {
//   final controller = TextEditingController();
//   final focusNode = FocusNode();
//   final String firebaseId = FirebaseAuth.instance.currentUser!.uid;
//   Timer? timer;
//
//   @override
//   void dispose() {
//     controller.dispose();
//     focusNode.dispose();
//     timer?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final defaultPinTheme = PinTheme(
//       width: 60,
//       height: 64,
//       textStyle: GoogleFonts.poppins(
//         fontSize: 20,
//         color: const Color.fromRGBO(70, 69, 66, 1),
//       ),
//       decoration: BoxDecoration(
//         color: const Color.fromRGBO(232, 235, 241, 0.37),
//         borderRadius: BorderRadius.circular(24),
//       ),
//     );
//
//     final cursor = Align(
//       alignment: Alignment.bottomCenter,
//       child: Container(
//         width: 21,
//         height: 1,
//         margin: const EdgeInsets.only(bottom: 12),
//         decoration: BoxDecoration(
//           color: const Color.fromRGBO(137, 146, 160, 1),
//           borderRadius: BorderRadius.circular(8),
//         ),
//       ),
//     );
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text('Verify Email'),
//       //   backgroundColor: Colors.grey,
//       // ),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'A verification pin has been sent to the email: ' + widget.userEmail!,
//               style: TextStyle(fontSize: 20),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 24),
//             Center(
//               child: Pinput(
//                 length: 4,
//                 controller: controller,
//                 focusNode: focusNode,
//                 defaultPinTheme: defaultPinTheme,
//                 onCompleted: (pin) => pin == widget.pinNumber ?
//                 setEmailVerificationToTrue(firebaseId).then((value) => reloadFirebaseUser()) : print("The pin $pin is wrong"),
//                 validator: (s) {
//                   return s == widget.pinNumber.toString()
//                       ? null
//                       : 'Incorrect Pin. Please check your email.';
//                 },
//                 separator: const SizedBox(width: 16),
//                 focusedPinTheme: defaultPinTheme.copyWith(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(8),
//                     boxShadow: const [
//                       BoxShadow(
//                         color: Color.fromRGBO(0, 0, 0, 0.05999999865889549),
//                         offset: Offset(0, 3),
//                         blurRadius: 16,
//                       )
//                     ],
//                   ),
//                 ),
//                 // onClipboardFound: (value) {
//                 //   debugPrint('onClipboardFound: $value');
//                 //   controller.setText(value);
//                 // },
//                 showCursor: true,
//                 cursor: cursor,
//               ),
//             ),
//             SizedBox(height: 8),
//             TextButton(
//               style: ElevatedButton.styleFrom(
//                 minimumSize: Size.fromHeight(50),
//               ),
//               child: Text(
//                 'Cancel',
//                 style: TextStyle(fontSize: 24, color: Colors.black),
//               ),
//               onPressed: () => FirebaseAuth.instance.signOut(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//   Future<void> setEmailVerificationToTrue(String? uid) async {
//     http.post(
//       Uri.parse('http://studentshopspringbackend-env.eba-b2yvpimm.us-east-1.elasticbeanstalk.com/emailVerifiedStatus/$uid'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//     );
//     print(response.)
//     print("Done with setting email to TRUE");
//   }
//
//   Future<void> reloadFirebaseUser() async {
//     await FirebaseAuth.instance.currentUser?.reload();
//     //   // call after email verification!
//     setState(() {
//       isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
//       if(isEmailVerified == true) {
//         print("EMAIL VERIFIED");
//       }
//     });
//
//       if (isEmailVerified) timer?.cancel();
//   }
// }
