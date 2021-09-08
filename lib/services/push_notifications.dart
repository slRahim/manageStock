import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/models/MyParams.dart';
import 'package:gestmob/models/Profile.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'local_notification.dart';

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
  Profile _profile;
  bool _pieceHasCredit;
  QueryCtr _queryCtr = new QueryCtr();
  bool _finishLoading = false;

  @override
  void initState() {
    super.initState();
    futurinit().then((value) {
      setState(() {
        _finishLoading = true;
      });
    });
  }

  Future futurinit() async {
    notificationPlugin.setOnNotificationClick(onNotificationClick);
    notificationPlugin
        .setListenerForLowerVersions(onNotificationInLowerVersions);
    await configureLocalNotification();
    await configureCloudMessaginCallbacks();
    await updateCurrentIndexPiece();
  }

  MyParams get myParams => _myParams;
  Profile get profile => _profile;

  void onMyParamsChange(newValue) {
    setState(() {
      _myParams = newValue;
    });
  }

  void onProfileChange(newValue) {
    setState(() {
      _profile = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_finishLoading) {
      return MyInheritedWidget(data: this, child: widget.child);
    }
    return Center(
        child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.transparent)));
  }

  updateCurrentIndexPiece() async {
    var res = await _queryCtr.getAllFormatPiece();
    var formatPiece = res.first;
    if (formatPiece.year != DateTime.now().year.toString()) {
      formatPiece.year = DateTime.now().year.toString();
      await _queryCtr.updateItemInDb(DbTablesNames.formatPiece, formatPiece);
    }
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _profile = await _queryCtr.getProfileById(1);
    _myParams = await _queryCtr.getAllParams();

    if(prefs.getInt("currencyDecimalText") == null){
      _myParams.currencyDecimalText = 0;
      await prefs.setInt("currencyDecimalText",0);
    }else{
      _myParams.currencyDecimalText = prefs.getInt("currencyDecimalText");
    }

    if (_myParams.notifications) {

      //notification du credit
      _pieceHasCredit = await _queryCtr.pieceHasCredit();
      if (_pieceHasCredit) {
        await notificationPlugin.cancelAllNotification();
        switch (_myParams.notificationDay) {
          case 0:
            await notificationPlugin
                .showDailyAtTime(_myParams.notificationTime , false);
            break;
          default:
            await notificationPlugin.showWeeklyAtDayTime(
                _myParams.notificationTime, _myParams.notificationDay , false);
            break;
        }
      }else{
        await notificationPlugin.cancelAllNotification();
      }

      //special pour la notification du backup
      if (_myParams.versionType != "demo" &&
          DateTime.now().isBefore(Helpers.getDateExpiration(_myParams))){
        switch (_myParams.notificationDay) {
          case 0:
            await notificationPlugin
                .showDailyAtTime(_myParams.notificationTime , true);
            break;
          default:
            await notificationPlugin.showWeeklyAtDayTime(
                _myParams.notificationTime, _myParams.notificationDay , true);
            break;
        }
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
  final ValueChanged<dynamic> onMyParamsChanged;
  final ValueChanged<dynamic> onProfileChanged;

  MyInheritedWidget(
      {Key key,
      @required Widget child,
      @required this.data,
      this.onMyParamsChanged,
      this.onProfileChanged})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}
