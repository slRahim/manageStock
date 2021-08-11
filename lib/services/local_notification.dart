import 'dart:io' show File, Platform;

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPlugin {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final BehaviorSubject<ReceivedNotification>
      didReceivedLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();
  var initializationSettings;
  int IdNotification = 0;

  SharedPreferences _prefs;

  NotificationPlugin._() {
    init();
  }


  //***********************************************************************************************************************************************************************************
  //******************************************************************************configuration*****************************************************************************************
  init() async {
    _prefs = await SharedPreferences.getInstance();
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
    try{
      await flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: (String payload) async {
            onNotificationClick(payload);
          });
    }catch(e){
      print(e);
    }

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

  Future<void> showDailyAtTime(String dayTime , bool backupNotification) async {
    var hh_mm = dayTime.split(":");
    var time = Time(int.parse(hh_mm.first), int.parse(hh_mm.last), 0);

    String credit = '';
    String msg_credit = '' ;

    String backup = '';
    String backupMsg = '';

    if(!backupNotification){
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

      switch (_prefs.getString("myLocale")) {
        case ("en"):
          credit = 'Credit' ;
          msg_credit = 'You have unpaid invoices';
          break;
        case ("fr"):
          credit = 'Credit' ;
          msg_credit = 'Vous avez des pièces non payer';
          break;
        case ("ar"):
          credit = 'ديون' ;
          msg_credit = '"لديك فواتير بها ديون';
          break;
        default:
          credit = 'Credit' ;
          msg_credit = 'You have unpaid invoices';
          break;
      }

      await flutterLocalNotificationsPlugin.showDailyAtTime(
        IdNotification,
        credit,
        msg_credit, //null
        time,
        platformChannelSpecifics,
        payload: 'Credit Payload',
      );
      IdNotification++;

    }else{
      var androidChannelSpecifics = AndroidNotificationDetails(
        'CHANNEL_ID 42',
        'CHANNEL_NAME 42',
        "CHANNEL_DESCRIPTION 42",
        importance: Importance.Max,
        priority: Priority.Max,
      );
      var iosChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics =
      NotificationDetails(androidChannelSpecifics, iosChannelSpecifics);

      switch (_prefs.getString("myLocale")) {
        case ("en"):
          backup = 'Backup' ;
          backupMsg = 'backup your data of the last day';
          break;
        case ("fr"):
          backup = 'Sauvegarde' ;
          backupMsg = 'sauvegardez vos données du dernier jour';
          break;
        case ("ar"):
          backup = 'نسخة إحتياطية' ;
          backupMsg = 'احتفظ بنسخة احتياطية من بياناتك  لليوم الأخير';
          break;
        default:
          backup = 'Backup' ;
          backupMsg = 'backup your data of the last day';
          break;
      }

      await flutterLocalNotificationsPlugin.showDailyAtTime(
        IdNotification,
        backup,
        backupMsg, //null
        time,
        platformChannelSpecifics,
        payload: 'Backup Payload',
      );
      IdNotification++;
    }

  }

  // la semaine demmare par dimanche = 1 / termine le samedi = 7
  Future<void> showWeeklyAtDayTime(String dayTime, int day , bool backupNotification) async {
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

    String credit = '';
    String msg_credit = '' ;

    String backup = '';
    String backupMsg = '';

    if(!backupNotification){
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

      switch (_prefs.getString("myLocale")) {
        case ("en"):
          credit = 'Credit' ;
          msg_credit = 'You have unpaid invoices';
          break;
        case ("fr"):
          credit = 'Credit' ;
          msg_credit = 'Vous avez des pièces non payer';
          break;
        case ("ar"):
          credit = 'ديون' ;
          msg_credit = '"لديك فواتير بها ديون';
          break;
        default:
          credit = 'Credit' ;
          msg_credit = 'You have unpaid invoices';
          break;
      }

      await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
        IdNotification,
        credit,
        msg_credit,
        days[day],
        time,
        platformChannelSpecifics,
        payload: 'Credit Payload',
      );
      IdNotification++;
    }else{
      var androidChannelSpecifics = AndroidNotificationDetails(
        'CHANNEL_ID 56',
        'CHANNEL_NAME 56',
        "CHANNEL_DESCRIPTION 56",
        importance: Importance.Max,
        priority: Priority.Max,
      );
      var iosChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics =
      NotificationDetails(androidChannelSpecifics, iosChannelSpecifics);

      switch (_prefs.getString("myLocale")) {
        case ("en"):
          backup = 'Backup' ;
          backupMsg = 'backup your data of the last day';
          break;
        case ("fr"):
          backup = 'Sauvegarde' ;
          backupMsg = 'sauvegardez vos données du dernier jour';
          break;
        case ("ar"):
          backup = 'نسخة إحتياطية' ;
          backupMsg = 'احتفظ بنسخة احتياطية من بياناتك  لليوم الأخير';
          break;
        default:
          backup = 'Backup' ;
          backupMsg = 'backup your data of the last day';
          break;
      }

      await flutterLocalNotificationsPlugin.showDailyAtTime(
        IdNotification,
        backup,
        backupMsg, //null
        time,
        platformChannelSpecifics,
        payload: 'Backup Payload',
      );
      IdNotification++;
    }


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
