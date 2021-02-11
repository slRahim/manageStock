import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Widgets/CustomWidgets/search_bar.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';


class PurchasePage extends StatefulWidget {
  @override
  _PurchasePageState createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  List<String> AvantagesData = new List<String>();
  String Selectprodect;
  double prixmensuelle;
  List<PurchaseDetails> _purchases = [];
  static InAppPurchaseConnection _instance = InAppPurchaseConnection.instance;
  StreamSubscription<List<PurchaseDetails>> _subscription;
  Set<String> _productIds = <String>["010101", "121212", "999999"].toSet();


  @override
  void initState() {
    super.initState();
    prixmensuelle = 0;

    //from params inherited widget or get params
    // AvantagesData.add(localization.NombreDeComptesIllimites + '.');
    // AvantagesData.add(localization.NombreDImpressionDeChequesillimites + '.');
    // AvantagesData.add(localization.MultiDevises + '.');
    // AvantagesData.add(localization.TransfertsEntreComptes + '.');
    // AvantagesData.add(localization.SansPublicites + '.');

    retrieveoldPurchase();
    final Stream purchaseUpdates =
        _instance.purchaseUpdatedStream;
    _subscription = purchaseUpdates.listen((purchases) async {
      _purchases.addAll(purchases);
      await retrieveoldPurchase();
      await _verifyPurchase();

      // handle purchase details
    }, onDone: () async {
      await _subscription.cancel();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  PurchaseDetails _hasPurchased(String productID) {
    return _purchases.firstWhere((purchase) => purchase.productID == productID,
        orElse: () => null);
  }

  _verifyPurchase() async {
    PurchaseDetails purchase = _hasPurchased(Selectprodect);

    if (purchase != null && purchase.status == PurchaseStatus.purchased) {
//      update data base
      switch (purchase.productID) {
        case '999999':
          {

          }
          break;
        case '121212':
          {

          }
          break;
        case '010101':
          {
            // Provider.of<AppStateNotifier>(context, listen: false)
            //     .updateSubscription(
            //     2,
            //     DateTimeTODateSqlite(readTimestamp(
            //         purchase.billingClientPurchase.purchaseTime)));
            // await MyParamsMethode().EditSubscriptionParam(
            //     2,
            //     DateTimeTODateSqlite(readTimestamp(
            //         purchase.billingClientPurchase.purchaseTime)));
            // print(010101);
            // await retrieveoldPurchase();
            // Navigator.of(context).pop();
            // MyMsgSuccesfulUpgradeDialog(context);
          }
          break;
      }
    } else {
      if (purchase != null && purchase.status == PurchaseStatus.pending) {
        print('ddddd');
      }
    }
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
      body: Padding(
        padding:
        const EdgeInsets.only(top: 60, bottom: 60, right: 5, left: 5),
        child: Container(
          height: 550,
          decoration: BoxDecoration(

//              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white),
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.white)]),
          child: Column(children: [
            Text(
              "Premium",
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            Divider(
              color: Colors.grey,
              height: 15,
              indent: 50,
              endIndent: 50,
            ),
            SingleChildScrollView(
              child: Column(
                children: AvantagesData.map((item) => AvantegeItem(item))
                    .toList(),
              ),
            ),
            Divider(
              color: Colors.grey,
              height: 20,
              indent: 30,
              endIndent: 30,
            ),
            FutureBuilder<List<PurchaseDetails>>(
                future: retrieveoldPurchase(),
                initialData: List<PurchaseDetails>(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<PurchaseDetails>> products) {
                  if (products.data != null) {
                    if (products.data.length != 0) {
                      return new SingleChildScrollView(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                              children: products.data
                                  .map((item) {
//                                    Selectprodect = item.productID;
//                                    _verifyPurchase();
                                return InkWell(
                                  onTap: () async {
                                    Selectprodect = item.productID;
                                    await _verifyPurchase();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: Color(0xFF088787),
                                        width: 1, //                   <--- border width here
                                      ),
                                    ),
                                    margin: EdgeInsets.all(5.0),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: <Widget>[
                                            SizedBox(
                                              height: 40.0,
                                            ),
                                            Container(
                                              margin: EdgeInsetsDirectional
                                                  .only(start: 5),
                                              child: Row(
                                                children: <Widget>[
                                                  Text(
                                                      '${item.productID ==
                                                          '010101'
                                                          ? "Mensuel"
                                                          : item.productID ==
                                                          '121212'
                                                          ? "Annuel"
                                                          : "A vie"} ',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15,
                                                          letterSpacing: 1)),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              child: Text('12/12/2012',
                                                  style: TextStyle(color: Colors
                                                      .black,
                                                      fontSize: 15,
                                                      letterSpacing: 1)),
                                            ),
                                            SizedBox(
                                              height: 40.0,
                                            ),

                                          ],
                                        ),
                                        Container(
                                            child: Text(
                                                'Recuperer mon ancien abonnement',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    letterSpacing: 1))),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList()));
                    } else {
                      return FutureBuilder<List<ProductDetails>>(
                          future: retrieveProducts(),
                          initialData: List<ProductDetails>(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<ProductDetails>> products) {
                            if (products.data != null) {
                              return SingleChildScrollView(
                                  padding: new EdgeInsets.all(8.0),
                                  child: new Column(
                                      children: products.data
                                          .map((item) => buildProductRow(item))
                                          .toList()));
                            }
                            return CircularProgressIndicator();
                          });
                    }
                  }
                  return CircularProgressIndicator();
                }),
          ]),
        ),
      ),
    );
  }

  Widget buildProductRow(ProductDetails productDetail) {
    String p12;
    double pm_12 = 0;
    String p1;
    double prixmensuelle_12 = 0;
    double remise = 0;
    double remiseprcntg = 0;
    if (productDetail.id == '010101') {
      p1 = productDetail.price;
      p1 =
          p1.replaceAll(",", ".").replaceAll(new RegExp('[a-zA-Z]'), '').trim();

      p1 = p1.replaceAll('\u00A0', '');
      p1 = p1.replaceAll('&nbsp;', '');
      var _p1 = '';
      for (var i = 0; i < p1.length; i++) {
        if (p1[i] != ' ') {
          _p1 = _p1 + p1[i];
        }
      }
      p1 = _p1;
      prixmensuelle = double.parse(p1);
    } else if (productDetail.id == '121212') {
      p12 = productDetail.price;
      p12 = p12
          .replaceAll(",", ".")
          .replaceAll(new RegExp('[a-zA-Z]'), '')
          .trim();
      p12 = p12.replaceAll('\u00A0', '');
      p12 = p12.replaceAll('&nbsp;', '');
      var _p12 = '';
      for (var i = 0; i < p12.length; i++) {
        if (p12[i] != ' ') {
          _p12 = _p12 + p12[i];
        }
      }
      p12 = _p12;
      pm_12 = double.parse(_p12);
      prixmensuelle_12 = prixmensuelle * 12;
      remise = (prixmensuelle_12 - pm_12);
      remiseprcntg = (remise * 100) / prixmensuelle_12;
    }
    return InkWell(
      onTap: () async {
        await purchaseItem(productDetail);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Color(0xFF088787),
            width: 1, //                   <--- border width here
          ),
        ),
        margin: new EdgeInsets.all(5.0),
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Container(
              height: 40.0,
              width: 50.0,
            ),
            new Container(
              margin: EdgeInsetsDirectional.only(start: 5, end: 5),
              child: Row(
                children: <Widget>[
                  new Text(
                      '${productDetail.title.replaceAll('(Gestmob)', '')} ',
                      style: TextStyle(fontSize: 15, letterSpacing: 1)),
                ],
              ),
            ),
            Container(
              child: new Text('${productDetail.price} ',
                  style: TextStyle(fontSize: 15, letterSpacing: 1)),
            ),
            productDetail.id == '121212'
                ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Container(
                height: 30.0,
                width: 70.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: new LinearGradient(
                        colors: [Color(0xFF088787), Color(0xFF088787)],
                        begin: FractionalOffset.topLeft,
                        end: FractionalOffset.bottomRight,
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp)),
                child: Flexible(
                  child: new Text('${S.current.remise}\n-${Helpers.numberFormat(
                      remiseprcntg.roundToDouble())}%',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          letterSpacing: 1)),
                ),
              ),
            )
                : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 30.0,
                width: 50.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  readTimestamp(int timestamp) {
    final DateTime timeStamp = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return timeStamp;
  }

  Future<List<PurchaseDetails>> retrieveoldPurchase() async {
    final bool available = await _instance.isAvailable();
    if (!available) {
      // Handle store not available
    } else {
      final QueryPurchaseDetailsResponse response =
      await _instance.queryPastPurchases();
      _purchases = response.pastPurchases;
//      if(_purchases.length!=0){
////        Selectprodect = _purchases[0].productID;
//      }
      return new Future(() => response.pastPurchases);
    }
  }

  Future<List<ProductDetails>> retrieveProducts() async {
    final bool available = await _instance.isAvailable();
    if (!available) {
      // Handle store not available
    } else {
      final ProductDetailsResponse response = await InAppPurchaseConnection
          .instance
          .queryProductDetails(_productIds);
      if (response.notFoundIDs.isNotEmpty) {
        print("notFoundIDs : ${response.notFoundIDs}");
      }
      print("productDetails : ${response.productDetails}");
      return new Future(() => response.productDetails);
    }
  }

  purchaseItem(ProductDetails productDetails) async {
    Selectprodect = productDetails.id;
    final PurchaseParam purchaseParam =
    PurchaseParam(productDetails: productDetails);
    if ((Platform.isIOS &&
        productDetails.skProduct.subscriptionPeriod == null) ||
        (Platform.isAndroid && productDetails.skuDetail.type == SkuType.subs)) {
      await _instance
          .buyConsumable(purchaseParam: purchaseParam, autoConsume: false);
    } else {
      await _instance
          .buyNonConsumable(purchaseParam: purchaseParam,);
    }
  }
}

class AvantegeItem extends StatelessWidget {
  final String Label;

  AvantegeItem(this.Label);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      margin: EdgeInsets.all(10.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
//            height: 60.0,
            width: 50.0,
            child: new Center(
                child: Icon(
                  Icons.check_circle_outline,
                  color: Color(0xFF088787),
                )),
          ),
          Container(
            margin: EdgeInsetsDirectional.only(start: 5, end: 5),
            child: Row(
              children: <Widget>[
                new Text('$Label',
                    style: TextStyle(fontSize: 12, letterSpacing: 1)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
