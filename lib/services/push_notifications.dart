import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'local_notification.dart';

class PushNotificationsManager extends StatelessWidget {
  Widget child;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  PushNotificationsManager({this.child});

  @override
  Widget build(BuildContext context) {
    configureCloudMessaginCallbacks();
    notificationPlugin.setOnNotificationClick(onNotificationClick);
    return child;
  }

  configureCloudMessaginCallbacks() async {
    _firebaseMessaging.configure(
      onMessage: (message) async {
        print("onMessage: $message");
        if ((message['data']).containsKey('type')) {
          notificationPlugin.showNotification(
              body: message['notification']['body'],
              title: message['notification']['title'],
              payload: message['data']['type']);

          onNotificationClick(message['data']['type']);
        } else
          notificationPlugin.showNotification(
              body: message['notification']['body'],
              title: message['notification']['title']);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }


  onNotificationClick(String payload) {
    print('taped notification : $payload');
  }
}
