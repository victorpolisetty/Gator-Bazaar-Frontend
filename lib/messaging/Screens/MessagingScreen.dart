// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:student_shopping_v1/models/messageModel.dart';
// import '../../models/chatMessageModel.dart';
// import '../Pages/ChatPage.dart';
//
// class MessagingScreen extends StatefulWidget {
//   // Homescreen({Key? key,required this.chatmodels,required this.sourceChat}) : super(key: key);
//   // final List<ChatModel> chatmodels;
//   // final ChatModel sourceChat;
//
//
//
//   // List<ChatModel> chatmodels = [
//   //   ChatModel(
//   //       name: "Dev Stack",
//   //       isGroup: false,
//   //       currentMessage: "Hi Everyone",
//   //       time: "4:00",
//   //       icon: "personIcon.svg",
//   //       id: 1),
//   //   ChatModel(
//   //       name: "Victor Polisetty",
//   //       isGroup: false,
//   //       currentMessage: "Hi Victor",
//   //       time: "10:00",
//   //       icon: "personIcon.svg",
//   //       id: 2),
//   //   // ChatModel(
//   //   //     name: "UF A Reason to Give Club",
//   //   //     isGroup: true,
//   //   //     currentMessage: "Hi Everyone!",
//   //   //     time: "2:00",
//   //   //     icon: "groupIcon.svg"
//   //   // ),
//   //   ChatModel(
//   //       name: "Neal Polisetty",
//   //       isGroup: false,
//   //       currentMessage: "Hi Neal",
//   //       time: "4:00",
//   //       icon: "personIcon.svg",
//   //       id: 3),
//   //   // ChatModel(
//   //   //     name: "UF KickBoxing",
//   //   //     isGroup: true,
//   //   //     currentMessage: "Hi Everyone!",
//   //   //     time: "10:00",
//   //   //     icon: "groupsIcon.svg"
//   //   // ),
//   // ];
//
//
//
//   @override
//   _MessagingScreenState createState() => _MessagingScreenState();
// }
//
// class _MessagingScreenState extends State<MessagingScreen> with SingleTickerProviderStateMixin {
//   TabController? _controller;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _controller = TabController(length: 1, vsync: this, initialIndex: 0);
//     Provider.of<ChatMessageModel>(context, listen: false);
//   }
//   @override
//   Widget build(BuildContext context) {
//     var chatProfiles = context.watch<ChatMessageModel>();
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Messages"),
//         actions: [
//           IconButton(icon: Icon(Icons.search), onPressed: (){}),
//           PopupMenuButton<String>(
//             onSelected: (value) {
//               print(value);
//             },
//             itemBuilder: (BuildContext context){
//             return [
//               // PopupMenuItem(child: Text("New Group"), value: "New Group",),
//               // PopupMenuItem(child: Text("New broadcast"), value: "New broadcast",),
//               // PopupMenuItem(child: Text("Whatsapp Web"), value: "Whatsapp Web",),
//               // PopupMenuItem(child: Text("Starred messages"), value: "Starred messages",),
//               // PopupMenuItem(child: Text("Settings"), value: "Settings",),
//             ];
//           },
//           )
//         ],
//         bottom: TabBar(
//           controller: _controller,
//           indicatorColor: Colors.white,
//           tabs: [
//             // Tab(
//             //   icon: Icon(Icons.camera_alt),
//             // ),
//             Tab(
//               text: "CHATS",
//             ),
//             // Tab(
//             //   text: "STATUS",
//             // ),
//             // Tab(
//             //   text: "CALLS",
//             // ),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _controller,
//         children: [
//           // Text("Camera"),
//           ChatPage(chatProfiles : chatProfiles.chatHome),
//           // Text("Status"),
//           // Text("Calls"),
//         ],
//       ),
//     );
//   }
// }