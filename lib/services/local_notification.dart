import 'dart:io' show File, Platform;

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

class NotificationPlugin {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final BehaviorSubject<ReceivedNotification>
      didReceivedLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();
  var initializationSettings;
  int IdNotification = 0;

  NotificationPlugin._() {
    init();
  }

  //***********************************************************************************************************************************************************************************
  //******************************************************************************configuration*****************************************************************************************
  init() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      _requestIOSPermission();
    }
    initializePlatformSpecifics();
  }

  initializePlatformSpecifics() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        ReceivedNotification receivedNotification = ReceivedNotification(
            id: id, title: title, body: body, payload: payload);
        didReceivedLocalNotificationSubject.add(receivedNotification);
      },
    );

    initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
  }

  _requestIOSPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(
          alert: false,
          badge: true,
          sound: true,
        );
  }

  setListenerForLowerVersions(Function onNotificationInLowerVersions) {
    didReceivedLocalNotificationSubject.listen((receivedNotification) {
      onNotificationInLowerVersions(receivedNotification);
    });
  }

  setOnNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      onNotificationClick(payload);
    });
  }

  //******************************************************************************************************************************************************************
  //*********************************************************notifications********************************************************************************************
  Future<void> showNotification(
      {String body, String title, String payload = ''}) async {
    var androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      "CHANNEL_DESCRIPTION",
      importance: Importance.Max,
      priority: Priority.High,
      playSound: true,
    );
    var iosChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics =
        NotificationDetails(androidChannelSpecifics, iosChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        IdNotification, title, body, platformChannelSpecifics,
        payload: payload);
    IdNotification++;
  }

  Future<void> showDailyAtTime(String dayTime) async {
    var hh_mm = dayTime.split(":");
    var time = Time(int.parse(hh_mm.first), int.parse(hh_mm.last), 0);
    var androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID 41',
      'CHANNEL_NAME 41',
      "CHANNEL_DESCRIPTION 41",
      importance: Importance.Max,
      priority: Priority.Max,
    );
    var iosChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics =
        NotificationDetails(androidChannelSpecifics, iosChannelSpecifics);

    await flutterLocalNotificationsPlugin.showDailyAtTime(
      IdNotification,
      'Credit',
      'Vous avez des pieces non payer', //null
      time,
      platformChannelSpecifics,
      payload: 'Test Payload',
    );
    IdNotification++;
  }

  // la semaine demmare par dimanche = 1 / termine le samedi = 7
  Future<void> showWeeklyAtDayTime(String dayTime, int day) async {
    var hh_mm = dayTime.split(":");
    var time = Time(int.parse(hh_mm.first), int.parse(hh_mm.last), 0);
    var days = [
      null,
      Day.Sunday,
      Day.Monday,
      Day.Tuesday,
      Day.Wednesday,
      Day.Thursday,
      Day.Friday,
      Day.Sunday
    ];
    print(days[day]);
    var androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID 55',
      'CHANNEL_NAME 55',
      "CHANNEL_DESCRIPTION 55",
      importance: Importance.Max,
      priority: Priority.Max,
    );
    var iosChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics =
        NotificationDetails(androidChannelSpecifics, iosChannelSpecifics);
    await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
      IdNotification,
      'Credit',
      'Vous avez des pieces non payer',
      days[day],
      time,
      platformChannelSpecifics,
      payload: 'Test Payload',
    );
    IdNotification++;
  }

  Future<void> cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  Future<void> cancelAllNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

//***************************************************************************************************************************************************************************
//**************************************************************************************************************************************************************************
NotificationPlugin notificationPlugin = NotificationPlugin._();

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}
