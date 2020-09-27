import 'package:flutter/material.dart';

class BottomTabBar extends StatelessWidget{
  final controller;
  final tabs;

  const BottomTabBar({Key key, this.tabs, this.controller}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: TabBar(
        controller: controller,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.all(5.0),
        indicatorColor: Colors.blue,
        tabs: tabs
      ),
    );
  }

}