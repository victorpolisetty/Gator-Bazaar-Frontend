import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:student_shopping_v1/buyerhome.dart';
import 'package:student_shopping_v1/messaging/Pages/NewChatPage.dart';
import 'package:student_shopping_v1/models/categoryModel.dart';
import 'package:student_shopping_v1/models/chatMessageModel.dart';
import 'package:student_shopping_v1/models/groupItemModel.dart';
import 'package:student_shopping_v1/models/groupModel.dart';
import 'package:student_shopping_v1/models/groupRequestModel.dart';
import 'package:student_shopping_v1/models/sellerItemModel.dart';
import 'package:student_shopping_v1/notificationService/LocalNotificationService.dart';
import 'package:student_shopping_v1/utils.dart';
import 'package:student_shopping_v1/verify_email_page.dart';
import 'auth_page.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/adminProfileModel.dart';
import 'models/categoryItemModel.dart';
import 'models/messageModel.dart';
import 'models/recentItemModel.dart';
import 'models/favoriteModel.dart';
import 'new/theme.dart';
import 'package:student_shopping_v1/new/size_config.dart';



//recieve message when app is in backgorund solutioon for on message
Future<void> backgroundHandler(RemoteMessage message) async{
  print(message.data.toString());
  print(message.notification?.title);
}

// Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print("Handling a background message: ${message.messageId}");
// }

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




  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }
  //
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

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
  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}



class _MyAppState extends State<MyApp> {

  @override
  void initState(){
    super.initState();

    LocalNotificationService.initialize(context);

    //gives you the message on which the user taps and it opens the app from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if(message != null) {
        final routeFromMessage = message.data["routePage"];
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (context) => new ChatPage(), fullscreenDialog: true));
        print(routeFromMessage);
      }
    });

    //forground
    FirebaseMessaging.onMessage.listen((message) {
      if(message.notification != null) {
        print(message.notification?.body);
        print(message.notification?.title);
      }

      LocalNotificationService.display(message);
    });

    //when the app is in background but opened and user taps on the notication
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromMessage = message.data["routePage"];
      if(routeFromMessage == "ChatPage") {
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (context) => new ChatPage(), fullscreenDialog: true));
      }
      print(routeFromMessage);
    });

  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => FavoriteModel(),
          ),
          ChangeNotifierProvider(
            create: (context) => MessageModel(),
          ),
          ChangeNotifierProvider(
            create: (context) => RecentItemModel(),
          ),
          ChangeNotifierProvider(
            create: (context) => CategoryItemModel(),
          ),
          // ChangeNotifierProvider(
          //   create: (context) => ApplicationState(),
          //   //builder: (context, _) => App(),
          // ),
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
          ChangeNotifierProvider(
            create: (context) => GroupModel(),
            //builder: (context, _) => App(),
          ),
          ChangeNotifierProvider(
            create: (context) => GroupRequestModel(),
            //builder: (context, _) => App(),
          ),
          ChangeNotifierProvider(
            create: (context) => AdminProfileModel(),
            //builder: (context, _) => App(),
          ),
          ChangeNotifierProvider(
            create: (context) => GroupItemModel(),
            //builder: (context, _) => App(),
          ),
        ],
          child: MaterialApp(
            routes: {
              "/home": (_) => new BuyerHomePage("Gator Bazaar"),
            },
            scaffoldMessengerKey: Utils.messengerKey,
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: theme(),
            home: MainPage(),
            // home: App(),
          )
          );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Something went wrong!"));
            } else if (snapshot.hasData) {
              return VerifyEmailPage();
            } else {
              return AuthPage();
            }
          },
        ),
      );
}
}


