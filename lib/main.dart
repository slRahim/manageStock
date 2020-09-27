
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/cubit/home_cubit.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/ui/home.dart';

import 'Helpers/Statics.dart';
import 'Helpers/route_generator.dart';


void main() {
  int index = 0;
  List<Locale> localeList = [Locale('en'), Locale('fr'), Locale('ar')];


  runApp(new MaterialApp(

    localizationsDelegates: [S.delegate],
    supportedLocales: S.delegate.supportedLocales,
    // localeResolutionCallback: S.delegate.resolution(fallback: Locale('en')),

    locale: localeList[index],

    title: "GestMob",
    theme: ThemeData(
        primarySwatch: Colors.red,
      ),

      initialRoute: RoutesKeys.homePage,
      onGenerateRoute: RouteGenerator.generateRoute,

     /* home: BlocProvider(
          create: (context) => HomeCubit(),
          child: new home())*/
  ));

}



