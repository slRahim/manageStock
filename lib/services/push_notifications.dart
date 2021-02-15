import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/models/HomeItem.dart';
import 'package:gestmob/models/MyParams.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'local_notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PushNotificationsManager extends StatefulWidget {
  Widget child;

  PushNotificationsManager({Key key, this.child}) : super(key: key);

  static PushNotificationsManagerState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyInheritedWidget>().data;
  }

  @override
  PushNotificationsManagerState createState() =>
      PushNotificationsManagerState();
}

class PushNotificationsManagerState extends State<PushNotificationsManager> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  MyParams _myParams;
  bool _pieceHasCredit;
  QueryCtr _queryCtr = new QueryCtr();

  @override
  void initState() {
    super.initState();
    futurinit();
  }

  Future futurinit() async {
    notificationPlugin.setOnNotificationClick(onNotificationClick);
    notificationPlugin
        .setListenerForLowerVersions(onNotificationInLowerVersions);
    await configureCloudMessaginCallbacks();
    await configureLocalNotification();
  }

  MyParams get myParams => _myParams;

  @override
  Widget build(BuildContext context) {
    return MyInheritedWidget(data: this, child: widget.child);
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
        } else {
          notificationPlugin.showNotification(
              body: message['notification']['body'],
              title: message['notification']['title']);
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  configureLocalNotification() async {
    _myParams = await _queryCtr.getAllParams();
    _pieceHasCredit = await _queryCtr.pieceHasCredit();

    if (_pieceHasCredit) {
      if (_myParams.notifications) {
        await notificationPlugin.cancelAllNotification();
        switch (_myParams.notificationDay) {
          case 0:
            await notificationPlugin
                .showDailyAtTime(_myParams.notificationTime);
            break;
          default:
            await notificationPlugin.showWeeklyAtDayTime(
                _myParams.notificationTime, _myParams.notificationDay);
            break;
        }
      } else {
        await notificationPlugin.cancelAllNotification();
      }
    } else {
      await notificationPlugin.cancelAllNotification();
    }
  }

  onNotificationInLowerVersions(ReceivedNotification receivedNotification) {
    print('Notification Received ${receivedNotification.id}');
  }

  onNotificationClick(String payload) {
    print('taped notification from service: $payload');
  }
}

class MyInheritedWidget extends InheritedWidget {
  final PushNotificationsManagerState data;

  MyInheritedWidget({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}
