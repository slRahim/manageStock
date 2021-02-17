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
      body:IntroductionScreen(
        pages: _getPageViews(context),
        next: const Icon(Icons.navigate_next,size: 35,),
        done: SizedBox(),
        onDone: ()=>null,
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

  List<PageViewModel> _getPageViews(context) {
    return <PageViewModel>[
      PageViewModel(
        title: "",
        bodyWidget: FlipCard(
          front: Container(
            height: 500,
            width: 500,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green,
              border: Border.all(
                color: Colors.blueAccent,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Center(child: Text("Fron card"))
          ),
          back: Container(
            height: 500,
            width: 500,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue,
              border: Border.all(
                color: Colors.blueAccent,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Center(child: Text("back card"))
          ),
        ),
      ),
      PageViewModel(
        titleWidget: Container(
          margin: EdgeInsets.only(top: 100),
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    "assets/map_pin.png",
                    height: 150,
                  )),
              SizedBox(
                height: 30,
              ),
              Text(
                S.current.intro_select_region,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        bodyWidget:  Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.blueAccent,
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Row(
            children: [
              Icon(
                Icons.language,
                color: Theme.of(context).accentColor,
              ),
            ],
          ),
        ),
      ),
      PageViewModel(
          titleWidget: Container(
            margin: EdgeInsets.only(top: 100),
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Image.asset("assets/edit_pen.png", height: 150),
                SizedBox(
                  height: 30,
                ),
                Text(
                  S.current.intro_infor,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          bodyWidget:  Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.blueAccent,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.language,
                  color: Theme.of(context).accentColor,
                ),
              ],
            ),
          ),
      )

    ];
  }


}

