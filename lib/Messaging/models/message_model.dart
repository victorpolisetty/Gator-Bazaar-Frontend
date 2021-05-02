import 'package:student_shopping/Messaging/models/user_model.dart';

class Message {
  User sender;
  String time;
  String text;
  bool isLiked;
  bool unread;
  Message({
    this.sender,
    this.time,
    this.text,
    this.isLiked,
    this.unread,
  });
}

// Current User
final User currentUser =
    User(id: 0, name: "Current User", imageURL: 'assets/images/greg.jpg');

// Other Contacts

final User james =
    User(id: 1, name: "James", imageURL: 'assets/images/james.jpg');

final User john = User(id: 2, name: "John", imageURL: 'assets/images/john.jpg');

final User sam = User(id: 3, name: "Sam", imageURL: 'assets/images/sam.jpg');

final User sophia =
    User(id: 4, name: "Sophia", imageURL: 'assets/images/sophia.jpg');

final User steven =
    User(id: 5, name: "Steven", imageURL: 'assets/images/steven.jpg');

final User olivia =
    User(id: 6, name: "Olivia", imageURL: 'assets/images/olivia.jpg');

final User greg = User(id: 7, name: "Greg", imageURL: 'assets/images/greg.jpg');

//Recently Contacted

List<User> favorites = [sam, steven, olivia, john, james];

//Example Chats

List<Message> chats = [
  Message(
    sender: james,
    time: "5:30 PM",
    text: "Hey, how\'s it going? What did you do today?",
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: olivia,
    time: "4:30 PM",
    text: "Hey, how\'s it going? What did you do today?",
    isLiked: true,
    unread: true,
  ),
  Message(
    sender: sophia,
    time: "3:30 PM",
    text: "Hey, how\'s it going? What did you do today?",
    isLiked: true,
    unread: false,
  ),
  Message(
    sender: steven,
    time: "2:30 PM",
    text: "Hey, how\'s it going? What did you do today?",
    isLiked: false,
    unread: false,
  ),
];

List<Message> messages = [
  Message(
    sender: james,
    time: "5:30 PM",
    text: "Hey, how\'s it going? What did you do today?",
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: currentUser,
    time: "4:30 PM",
    text: "I walked the dog",
    isLiked: true,
    unread: true,
  ),
  Message(
    sender: james,
    time: "3:30 PM",
    text: "Nice.",
    isLiked: true,
    unread: false,
  ),
  Message(
    sender: james,
    time: "2:30 PM",
    text: "For how long?",
    isLiked: false,
    unread: false,
  ),
  Message(
    sender: currentUser,
    time: "2:30 PM",
    text: "2 hours",
    isLiked: false,
    unread: false,
  ),
  Message(
    sender: james,
    time: "2:30 PM",
    text: "Ok I have to go.",
    isLiked: false,
    unread: false,
  ),
];
