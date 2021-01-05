
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/cubit/home_cubit.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/ui/home.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Helpers/Statics.dart';
import 'Helpers/TouchIdUtil.dart';
import 'Helpers/route_generator.dart';


void main() => runApp(Phoenix(child: MyApp()));


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int index = 0;
  List<Locale> localeList = [Locale('en'), Locale('fr'), Locale('ar')];

  @override
  void initState() {
    super.initState();
    initLanguage() ;

  }

  initLanguage()async{
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
            appBarTheme: AppBarTheme(
              color: Colors.indigoAccent,
            )
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.red,
            primaryColorDark: Colors.white10
          ),
          themeMode: ThemeMode.light,
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





