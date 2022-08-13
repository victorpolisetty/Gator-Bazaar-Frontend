// import 'package:flutter/material.dart';
// import 'package:student_shopping_v1/models/chatMessageModel.dart';
// import '../CustomUI/CustomCard.dart';
//
// class ChatPage extends StatefulWidget {
//   ChatPage({Key? key, required this.chatProfiles}) : super(key: key);
//   final List<ChatMessageHome> chatProfiles;
//   @override
//   _ChatPageState createState() => _ChatPageState();
// }
//
// class _ChatPageState extends State<ChatPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         onPressed: (){},
//         child: Icon(Icons.chat),
//       ),
//       body: ListView.builder(
//         itemCount: widget.chatProfiles.length,
//         itemBuilder: (context, index)=>CustomCard(chatProfile: widget.chatProfiles[index]),
//
//       ),
//     );
//   }
// }
