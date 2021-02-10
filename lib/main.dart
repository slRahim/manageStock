
import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/cubit/home_cubit.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/services/local_notification.dart';
import 'package:gestmob/services/push_notifications.dart';
import 'package:gestmob/ui/home.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Helpers/Statics.dart';
import 'Helpers/TouchIdUtil.dart';
import 'Helpers/route_generator.dart';
import 'Widgets/CustomWidgets/bottom_tab_bar.dart';
import 'models/MyParams.dart';


void main() {
  // Crashlytics.instance.enableInDevMode = false;
  // FlutterError.onError = Crashlytics.instance.recordFlutterError;
  //
  // runZoned(() {
  //   runApp(
  //       Phoenix(
  //           child: PushNotificationsManager (
  //               child: MyApp()
  //           )
  //       )
  //   );
  // }, onError: Crashlytics.instance.recordError);

  runApp(
      Phoenix(
          child: PushNotificationsManager (
              child: MyApp()
          )
      )
  );

}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int index = 0;

  List<Locale> localeList = [Locale('en'), Locale('fr'), Locale('ar')];
  var themeMode ;

  @override
  void initState() {
    super.initState();
    futureInit() ;
  }

  futureInit()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String _locale = prefs.getString("myLocale");
    switch(_locale){
      case ("en") :
        setState(() {
          index = 0 ;
        });
        break ;
      case ("fr") :
        setState(() {
          index = 1 ;
        });
        break ;
      case ("ar") :
        setState(() {
          index = 2 ;
        });
        break ;
      default:
        setState(() {
          index = 0 ;
        });
        break ;
    }

    String _theme = prefs.getString("myStyle");
    switch(_theme){
      case ("light") :
        setState(() {
          themeMode = ThemeMode.light ;
        });
        break ;
      case ("dark") :
        setState(() {
          themeMode = ThemeMode.dark ;
        });
        break ;
      case ("system") :
        setState(() {
          themeMode = ThemeMode.system ;
        });
        break ;
      default:
        setState(() {
          themeMode = ThemeMode.system ;
        });
        break ;
    }

    // if(prefs.getString("myDevise") == null ){
    //   prefs.setString("myDevise", "DZD");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus.unfocus();
          }
        },
        child: MaterialApp(
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.red,
            backgroundColor: Color(0xFFF1F8FA),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: Colors.redAccent
            ),
            secondaryHeaderColor: Colors.indigo[500],
            selectedRowColor: Colors.purple,
            primaryColorDark: Colors.black,
            bottomAppBarColor: Colors.white,
            disabledColor: Colors.white,
            hoverColor: Colors.blue[200],
            tabBarTheme: TabBarTheme(
              labelColor: Colors.blue,
              unselectedLabelStyle: TextStyle(color: Colors.black54, fontSize: 12),
              unselectedLabelColor: Colors.black54,
            ),
            appBarTheme: AppBarTheme(
              color: Colors.indigoAccent,
            )
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.red,
            backgroundColor: Colors.white10,
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.greenAccent,
              foregroundColor: Colors.black
            ),
            secondaryHeaderColor: Colors.blueGrey[900],
            selectedRowColor: Colors.deepPurple,
            primaryColorDark: Colors.white,
            disabledColor: Colors.black26,
            hoverColor: Colors.black26,
            tabBarTheme: TabBarTheme(
              labelColor: Colors.blue,
              unselectedLabelStyle: TextStyle(color: Colors.white60, fontSize: 12),
              unselectedLabelColor: Colors.white60,
            ),
            bottomAppBarColor: Colors.black,
            appBarTheme: AppBarTheme(
              color: Colors.black,
            )
          ),
          themeMode: themeMode,
          localizationsDelegates: [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          locale: localeList[index],
          title: "GestMob",
          initialRoute: RoutesKeys.loginPage,
          onGenerateRoute: RouteGenerator.generateRoute,
        )
    );

  }
}





