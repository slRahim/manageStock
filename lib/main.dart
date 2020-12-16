
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/cubit/home_cubit.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/ui/home.dart';
import 'package:get_it/get_it.dart';

import 'Helpers/Statics.dart';
import 'Helpers/TouchIdUtil.dart';
import 'Helpers/route_generator.dart';


void main() {

  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  int index = 0;
  List<Locale> localeList = [Locale('en'), Locale('fr'), Locale('ar')];

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus.unfocus();
          }
        },
        child: new MaterialApp(

          localizationsDelegates: [S.delegate],
          supportedLocales: S.delegate.supportedLocales,

          locale: localeList[index],

          title: "GestMob",
          theme: ThemeData(
            primarySwatch: Colors.red,
          ),

          initialRoute: RoutesKeys.loginPage,
          onGenerateRoute: RouteGenerator.generateRoute,
        )
    );
  }
}



