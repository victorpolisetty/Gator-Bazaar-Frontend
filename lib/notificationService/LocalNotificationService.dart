import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../messaging/Pages/NewChatPage.dart';

class LocalNotificationService{
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context){
    final InitializationSettings initializationSettings = InitializationSettings(
        iOS: IOSInitializationSettings(
          requestSoundPermission: false,
          requestAlertPermission: false,
          requestBadgePermission: false,
        ));


    _notificationsPlugin.initialize(initializationSettings,onSelectNotification: (String? payload) async {
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (context) => new ChatPage(), fullscreenDialog: true));
    });
  }

  static void display(RemoteMessage message) async{

    try{
      final id = DateTime.now().millisecondsSinceEpoch ~/100;

      final NotificationDetails notificationDetails = NotificationDetails(
          iOS: IOSNotificationDetails()
      );

      await _notificationsPlugin.show(
          id,
          message.notification!.title,
          message.notification!.body,
          notificationDetails,
          payload: message.data["route"],
      );
    } on Exception catch (e) {

      print(e);

    }



  }

}