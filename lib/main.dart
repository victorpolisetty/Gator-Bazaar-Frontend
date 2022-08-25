import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:student_shopping_v1/models/categoryModel.dart';
import 'package:student_shopping_v1/models/chatMessageModel.dart';
import 'package:student_shopping_v1/models/sellerItemModel.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_shopping_v1/models/itemModel.dart';
import 'models/categoryItemModel.dart';
import 'models/messageModel.dart';
import 'models/recentItemModel.dart';
import 'models/favoriteModel.dart';
import 'applicationState.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();

    print("Handling a background message: ${message.messageId}");
  }

  // final fcmToken = await FirebaseMessaging.instance.getToken();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => FavoriteModel(),
        ),
        // FutureProvider(
        //   create: (context) async => FavoriteModel().getItemRestList(),
        //   lazy: false, initialData: null,
        // ),
        ChangeNotifierProvider(
          create: (context) => MessageModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => RecentItemModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => CategoryItemModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ApplicationState(),
          //builder: (context, _) => App(),
        ),
        ChangeNotifierProvider(
          create: (context) => CategoryModel(),
          //builder: (context, _) => App(),
        ),
        ChangeNotifierProvider(
          create: (context) => SellerItemModel(),
          //builder: (context, _) => App(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChatMessageModel(),
          //builder: (context, _) => App(),
        ),
      ],
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
        home: App(),
      )
    );
  }
}