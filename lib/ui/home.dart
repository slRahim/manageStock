import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Widgets/navDrawer.dart';
import 'package:gestmob/cubit/home_cubit.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/HomeItem.dart';
import 'package:gestmob/ui/AddArticlePage.dart';

import 'GridHomeFragment.dart';

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

GlobalKey<ScaffoldState> _globalKey = GlobalKey();
HomeState _currentHomeState = null;
DateTime currentBackPressTime;

class _homeState extends State<home> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _globalKey,
        drawer: NavDrawer(),
        body: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state is HomeError) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(state.message),
              ));
            }
          },
          builder: (context, state) {
            return handleHomeState(context, state);
          },
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    DateTime now = DateTime.now();

    if (_globalKey.currentState.isDrawerOpen) {
      Navigator.pop(context); // closes the drawer if opened
      return Future.value(false); // won't exit the app
    } else if (_currentHomeState != null &&
        !(_currentHomeState is HomeLoaded ||
            _currentHomeState is HomeInitial)) {
      BlocProvider.of<HomeCubit>(context).getHomeData(homeItemAccueilId);
      return Future.value(false); // won't exit the app
    } else if (GridHomeWidget.Global_Draggable_Mode &&
        _currentHomeState != null &&
        (_currentHomeState is HomeLoaded || _currentHomeState is HomeInitial)) {
      return Future.value(true);
    } else {
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime) > Duration(seconds: 3)) {
        currentBackPressTime = now;
        Helpers.showToast(S.current.msg_quitter1);
        return Future.value(false);
      }
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: S.current.quitter,
        desc: S.current.msg_quitter,
        btnCancelText: S.current.non,
        btnCancelOnPress: (){

        },
        btnOkText: S.current.oui,
        btnOkOnPress: () async{
          exit(0);
        },
      )..show();
    }
  }

  Widget handleHomeState(BuildContext context, HomeState state) {
    GridHomeWidget.Global_Draggable_Mode = false;
    _currentHomeState = state;
    if (state is HomeInitial) {
      return GridHomeWidget();
    } else if (state is HomeLoading) {
      return buildLoading();
    } else if (state is HomeLoaded) {
      return state.widget;
    } else if (state is FragmentLoaded) {
      return state.widget;
    } else if (state is HomeError) {
      return GridHomeWidget();
    }
  }

  Widget buildLoading() {
    return Center(child: CircularProgressIndicator());
  }
}
