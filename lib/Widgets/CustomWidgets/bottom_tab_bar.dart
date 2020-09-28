import 'package:fancy_bottom_bar/fancy_bottom_bar.dart';
import 'package:flutter/material.dart';

class BottomTabBar extends StatelessWidget{
  final TabController controller;
  final tabs;
  final selectedIndex;
  final Function(int index) onItemSelected;

  const BottomTabBar({Key key, this.tabs, this.controller, this.selectedIndex, this.onItemSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: TabBar(
          controller: controller,
          labelColor: Colors.black,
          labelStyle: TextStyle(color: Colors.transparent, fontSize: 14),
          unselectedLabelStyle: TextStyle(color: Colors.black45, fontSize: 12),
          indicator: CircleTabIndicator(color: Colors.black, radius: 4),
          unselectedLabelColor: Colors.black45,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: Colors.black,
          tabs: tabs
      ),
    );
  }
/*
  @override
  Widget build(BuildContext context) {
    return FancyBottomBar(
        selectedPosition: controller.index,
        onItemSelected: (index) => ({
          controller.index = index
        }),
        items: [
          FancyBottomItem(
            icon: Icon(Icons.event),
            title: Text('Events'),
          ),
          FancyBottomItem(
            icon: Icon(Icons.search),
            title: Text('Search'),
          ),
          FancyBottomItem(
            icon: Icon(Icons.highlight),
            title: Text('Highlights'),
          ),
        ]);
  }*/

  /*@override
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
  }*/


  /*@override
  Widget build(BuildContext context) {
    return FlashyTabBar(
        selectedIndex: 0,
        showElevation: true,
        onItemSelected: (index) => ({
          index = index + 1
        }),
        items: [
          FlashyTabBarItem(
            icon: Icon(Icons.event),
            title: Text('Events'),
          ),
          FlashyTabBarItem(
            icon: Icon(Icons.search),
            title: Text('Search'),
          ),
          FlashyTabBarItem(
            icon: Icon(Icons.highlight),
            title: Text('Highlights'),
          ),
          FlashyTabBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
          ),
          FlashyTabBarItem(
            icon: Icon(Icons.settings),
            title: Text('한국어'),
          ),
        ]);
  }*/

}

class CircleTabIndicator extends Decoration {
  final BoxPainter _painter;

  CircleTabIndicator({@required Color color, @required double radius}) : _painter = _CirclePainter(color, radius);

  @override
  BoxPainter createBoxPainter([onChanged]) => _painter;
}

class _CirclePainter extends BoxPainter {
  final Paint _paint;
  final double radius;

  _CirclePainter(Color color, this.radius)
      : _paint = Paint()
    ..color = color
    ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Offset circleOffset = offset + Offset(cfg.size.width / 2, cfg.size.height - radius);
    canvas.drawCircle(circleOffset, radius, _paint);
  }
}