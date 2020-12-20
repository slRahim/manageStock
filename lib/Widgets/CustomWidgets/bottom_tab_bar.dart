import 'package:fancy_bottom_bar/fancy_bottom_bar.dart';
import 'package:flutter/material.dart';

// le tab bar au dessous des screens add/detail/modification
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
      child: SizedBox(height: 58,
        child: TabBar(
            controller: controller,
            labelColor: Colors.blue,
            labelStyle: TextStyle(color: Colors.transparent, fontSize: 14),
            unselectedLabelStyle: TextStyle(color: Colors.black45, fontSize: 12),
            indicator: CircleTabIndicator(color: Colors.blue[700], radius: 4),
            unselectedLabelColor: Colors.black45,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: Colors.black,
            tabs: tabs
        ),
      ),
    );
  }


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