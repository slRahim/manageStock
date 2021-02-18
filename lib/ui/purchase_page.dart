import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Widgets/CustomWidgets/search_bar.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flip_card/flip_card.dart';

class PurchasePage extends StatefulWidget {
  @override
  _PurchasePageState createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  List<PurchaseDetails> _purchases = [];
  static InAppPurchaseConnection _instance = InAppPurchaseConnection.instance;
  StreamSubscription<List<PurchaseDetails>> _subscription;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: SearchBar(
        mainContext: context,
        title: "Purchase",
        isFilterOn: false,
      ),
      body: IntroductionScreen(
        pages: [
          _buildCard(context, Colors.orange[400], Colors.orange[200],
              Colors.orange[100]),
          _buildCard(
              context, Colors.blue[300], Colors.blue[200], Colors.blue[100]),
          _buildCard(context, Colors.deepPurple[400], Colors.deepPurple[200],
              Colors.deepPurple[100]),
        ],
        next: const Icon(
          Icons.navigate_next,
          size: 35,
        ),
        done: SizedBox(),
        onDone: () => null,
        dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            color: Colors.black26,
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0))),
      ),
    );
  }

  PageViewModel _buildCard(context, color1, color2, color3) {
    return PageViewModel(
      title: "",
      bodyWidget: FlipCard(
        front: Center(
          child: Stack(
            children: [
              Container(
                  height: 500,
                  width: 500,
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        offset: Offset(1, 2),
                        color: Colors.black12,
                        spreadRadius: 3,
                        blurRadius: 5),
                  ]),
                  child: Column(
                    children: [
                      Container(
                        child: CustomPaint(
                          child: Container(
                            height: 300.0,
                          ),
                          painter: CurvePainter(color1, color2, color3),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.yellow,
                        ),
                      )
                    ],
                  )),
              InkWell(
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsetsDirectional.fromSTEB(40, 20, 40, 20),
                        child: Text(
                          "BUY NOW",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [color3, color1],
                              begin: FractionalOffset.topLeft,
                              end: FractionalOffset.bottomRight,
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        back: Container(
            height: 500,
            width: 500,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.grey[200], boxShadow: [
              BoxShadow(
                  offset: Offset(1, 2),
                  color: Colors.black12,
                  spreadRadius: 3,
                  blurRadius: 5),
            ]),
            child: Center(child: Text("back card"))),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  final Color colorOne;

  final Color colorTwo;
  final Color colorThree;

  CurvePainter(this.colorOne, this.colorTwo, this.colorThree);

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();

    path.lineTo(0, size.height * 0.75);
    path.quadraticBezierTo(size.width * 0.10, size.height * 0.70,
        size.width * 0.17, size.height * 0.90);
    path.quadraticBezierTo(
        size.width * 0.20, size.height, size.width * 0.25, size.height * 0.90);
    path.quadraticBezierTo(size.width * 0.40, size.height * 0.40,
        size.width * 0.50, size.height * 0.70);
    path.quadraticBezierTo(size.width * 0.60, size.height * 0.85,
        size.width * 0.65, size.height * 0.65);
    path.quadraticBezierTo(
        size.width * 0.70, size.height * 0.90, size.width, 0);
    path.close();

    paint.color = colorThree;
    canvas.drawPath(path, paint);

    path = Path();
    path.lineTo(0, size.height * 0.50);
    path.quadraticBezierTo(size.width * 0.10, size.height * 0.80,
        size.width * 0.15, size.height * 0.60);
    path.quadraticBezierTo(size.width * 0.20, size.height * 0.45,
        size.width * 0.27, size.height * 0.60);
    path.quadraticBezierTo(
        size.width * 0.45, size.height, size.width * 0.50, size.height * 0.80);
    path.quadraticBezierTo(size.width * 0.55, size.height * 0.45,
        size.width * 0.75, size.height * 0.75);
    path.quadraticBezierTo(
        size.width * 0.85, size.height * 0.93, size.width, size.height * 0.60);
    path.lineTo(size.width, 0);
    path.close();

    paint.color = colorTwo;
    canvas.drawPath(path, paint);

    path = Path();
    path.lineTo(0, size.height * 0.75);
    path.quadraticBezierTo(size.width * 0.10, size.height * 0.55,
        size.width * 0.22, size.height * 0.70);
    path.quadraticBezierTo(size.width * 0.30, size.height * 0.90,
        size.width * 0.40, size.height * 0.75);
    path.quadraticBezierTo(size.width * 0.52, size.height * 0.50,
        size.width * 0.65, size.height * 0.70);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.85, size.width, size.height * 0.60);
    path.lineTo(size.width, 0);
    path.close();

    paint.color = colorOne;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
