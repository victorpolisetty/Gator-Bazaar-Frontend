// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:intl/intl.dart';
// import 'package:student_shopping_v1/messaging/Screens/ChatDetail.dart';
// import 'package:student_shopping_v1/models/chatMessageModel.dart';
//
// import '../Screens/IndividualPage.dart';
//
// class CustomCard extends StatelessWidget {
//   const CustomCard({Key? key, required this.chatProfile}) : super(key: key);
//   final ChatMessageHome chatProfile;
//   // final ChatModel sourcechat;
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: (){
//         // Navigator.push(context, MaterialPageRoute(builder: (context) => IndividualPage(chatProfile: chatProfile)));
//         Navigator.push(context, MaterialPageRoute(builder: (context) => ChatDetailPage(chatProfile: chatProfile)));
//       },
//       child: Column(
//         children: [
//           ListTile(
//             leading: CircleAvatar(
//               radius: 30,
//               child:
//                 SvgPicture.asset("assets/personIcon.svg",
//                 color: Colors.white,
//                 height: 36,
//                 width: 36,
//                 ),
//               backgroundColor: Colors.blueGrey,
//
//             ),
//             title: Text(chatProfile.recipient_profile_name.toString(), style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               ),
//             ),
//             subtitle: Row(children: [
//               Icon(Icons.done_all),
//               SizedBox(
//                 width: 3,
//               ),
//               Text(chatProfile.message_text.toString(),
//                 style: TextStyle(fontSize: 13),
//               ),
//             ],),
//             trailing: Text(DateFormat('hh:mm').format(DateTime.parse(chatProfile.createdAt.toString())).toString()),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(right: 20, left: 80),
//             child: Divider(thickness: 1,
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
