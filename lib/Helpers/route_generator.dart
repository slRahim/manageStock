import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestmob/cubit/home_cubit.dart';
import 'package:gestmob/models/Article.dart';
import 'package:gestmob/models/Piece.dart';
import 'package:gestmob/models/Tiers.dart';
import 'package:gestmob/models/Tresorie.dart';
import 'package:gestmob/ui/AddPiecePage.dart';
import 'package:gestmob/ui/AddTierPage.dart';
import 'package:gestmob/ui/AddTresoriePage.dart';
import 'package:gestmob/ui/ProfilePage.dart';
import 'package:gestmob/ui/LoginPage.dart';
import 'package:gestmob/ui/SettingsPage.dart';
import 'package:gestmob/ui/AddArticlePage.dart';
import 'package:gestmob/ui/all_piece_listing.dart';
import 'package:gestmob/ui/backup_restore_listing.dart';
import 'package:gestmob/ui/home.dart';
import 'package:gestmob/ui/intro_page.dart';
import 'package:gestmob/ui/purchase_page.dart';
import 'package:gestmob/ui/support_page.dart';
import 'QueryCtr.dart';
import 'Statics.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case RoutesKeys.introPage:
        return MaterialPageRoute(
          builder: (_) => IntroPage(),
        );
        break;
      case RoutesKeys.loginPage:
        return MaterialPageRoute(
          builder: (_) => LoginApp(),
        );
        break;
      case RoutesKeys.homePage:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (context) => HomeCubit(), child: new home()));
      case RoutesKeys.profilePage:
        return MaterialPageRoute(
          builder: (_) => ProfilePage(),
        );
       break;
      case RoutesKeys.addArticle:
        if (args is Article){
          return PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 200),
            transitionsBuilder: (context,Animation<double> animation,Animation<double>  secondeAnimation , Widget child){
              animation = CurvedAnimation(parent: animation ,curve: Curves.bounceInOut);
              return ScaleTransition(
                alignment: Alignment.center,
                scale: animation,
                child: child,
              );
            },
            pageBuilder: (context,Animation<double> animation,Animation<double>  secondeAnimation) =>AddArticlePage(arguments: args,),
          );
        }
       break;
      case RoutesKeys.addTier:
        if (args is Tiers){
          return PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 200),
            transitionsBuilder: (context,Animation<double> animation,Animation<double>  secondeAnimation , Widget child){
              animation = CurvedAnimation(parent: animation ,curve: Curves.bounceInOut);
              return ScaleTransition(
                alignment: Alignment.center,
                scale: animation,
                child: child,
              );
            },
            pageBuilder: (context,Animation<double> animation,Animation<double>  secondeAnimation) => AddTierPage(arguments: args,),
          );
        }
       break;
      case RoutesKeys.addPiece:
        if (args is Piece){
          return PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 200),
            transitionsBuilder: (context,Animation<double> animation,Animation<double>  secondeAnimation , Widget child){
              animation = CurvedAnimation(parent: animation ,curve: Curves.bounceInOut);
              return ScaleTransition(
                alignment: Alignment.center,
                scale: animation,
                child: child,
              );
            },
            pageBuilder: (context,Animation<double> animation,Animation<double>  secondeAnimation) => AddPiecePage(arguments: args,),
          );
        }
       break;
      case RoutesKeys.addTresorie:
        if (args is Tresorie){
          return PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 200),
            transitionsBuilder: (context,Animation<double> animation,Animation<double>  secondeAnimation , Widget child){
              animation = CurvedAnimation(parent: animation ,curve: Curves.bounceInOut);
              return ScaleTransition(
                alignment: Alignment.center,
                scale: animation,
                child: child,
              );
            },
            pageBuilder: (context,Animation<double> animation,Animation<double>  secondeAnimation) => AddTresoriePage(arguments: args,),
          );
        }
        break;
      case RoutesKeys.allPieces:
        return MaterialPageRoute(
          builder: (_) => PiecesScreen(),
        );
      case RoutesKeys.appPurchase:
        return MaterialPageRoute(
          builder: (_) => PurchasePage(),
        );
      case RoutesKeys.settingsPage:
        return MaterialPageRoute(
          builder: (_) => SettingsPage(),
        );
      case RoutesKeys.supportPage:
        return MaterialPageRoute(
          builder: (_) => SupportPage(),
        );
      case RoutesKeys.driveListing:
        return MaterialPageRoute(
          builder: (_) => Selectfromdrive(),
        );
        break;
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
        builder: (_) => BlocProvider(
            create: (context) => HomeCubit(),
            child: Scaffold(
              appBar: AppBar(
                title: Text('Error'),
              ),
              body: Center(
                child: Text('ERROR'),
              ),
            )));
  }
}
