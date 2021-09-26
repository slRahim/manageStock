import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/Widgets/CustomWidgets/search_bar.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/MyParams.dart';
import 'package:gestmob/services/push_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PurchasePage extends StatefulWidget {
  @override
  _PurchasePageState createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  static InAppPurchaseConnection _instance = InAppPurchaseConnection.instance;
  List<PurchaseDetails> _purchases = [];
  StreamSubscription<List<PurchaseDetails>> _subscription;
  String _selectedProduct;
  Set<String> _productIds = <String>["010101", "121212", "999999"].toSet();
  double _prixmensuelle;

  List<Map<String, dynamic>> _avantages = <Map<String, dynamic>>[
    {
      "icon": Icon(
        Icons.all_inclusive,
        color: Colors.blue,
      ),
      "title": S.current.illimite,
      "small_description": S.current.illimite_desc,
    },
    {
      "icon": Icon(Icons.print, color: Colors.blue),
      "title": S.current.imprime,
      "small_description": S.current.imprime_desc,
    },
    {
      "icon": Icon(Icons.share, color: Colors.blue),
      "title": S.current.exporte,
      "small_description": S.current.exporte_desc,
    },
    {
      "icon": Icon(Icons.add_to_drive, color: Colors.blue),
      "title": S.current.save_rest,
      "small_description": S.current.save_rest_desc,
    },
    {
      "icon": Icon(Icons.headset_mic_outlined, color: Colors.blue),
      "title": S.current.support,
      "small_description": S.current.msg_support,
    }
  ];

  QueryCtr _queryCtr = new QueryCtr();
  MyParams _myParams;

  @override
  void initState() {
    super.initState();

    // retrieveoldPurchase();
    _prixmensuelle = 0;
    final Stream purchaseUpdates = _instance.purchaseUpdatedStream;
    _subscription = purchaseUpdates.listen((purchases) async {
      _purchases.addAll(purchases);
      await retrieveoldPurchase();
      await _verifyPurchase(context);
    }, onDone: () async {
      await _subscription.cancel();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    PushNotificationsManagerState data = PushNotificationsManager.of(context);
    _myParams = data.myParams;
  }

  //get mon ancien package
  Future<List<PurchaseDetails>> retrieveoldPurchase() async {
    final bool available = await _instance.isAvailable();
    if (available) {
      final QueryPurchaseDetailsResponse response =
      await _instance.queryPastPurchases();
      _purchases = response.pastPurchases;
      if (_purchases.length != 0) {
        _selectedProduct = _purchases[0].productID;
      }
      return new Future(() => response.pastPurchases);
    }
    return null;
  }

  // get tout les type d'abonement
  Future<List<ProductDetails>> retrieveProducts() async {
    final bool available = await _instance.isAvailable();
    if (available) {
      final ProductDetailsResponse response =
      await _instance.queryProductDetails(_productIds);
      return new Future(() => response.productDetails);
    }
    return null;
  }

  //****************************************************************************************************************************************************************************
  //**************************************************************************special affichage********************************************************************************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).selectedRowColor,
        appBar: SearchBar(
          mainContext: context,
          title: S.current.abonnement_title,
          isFilterOn: false,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              for (var e in _avantages) _buildAvantage(e),
              SizedBox(
                height: 10,
              ),
              FutureBuilder<List<PurchaseDetails>>(
                  future: retrieveoldPurchase(),
                  initialData: List<PurchaseDetails>(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<PurchaseDetails>> products) {
                    if (products.data != null) {
                      if (products.data.length != 0) {
                        // le produit deja acheté
                        return new SingleChildScrollView(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                                children: products.data.map((item) {
                                  _selectedProduct = item.productID;
                                  _verifyPurchase(context);
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          _selectedProduct = item.productID;
                                          await _verifyPurchase(context);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          margin: EdgeInsetsDirectional.only(
                                              bottom: 10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(5),
                                              border: Border.all(
                                                  color: Colors.indigo, width: 2),
                                              color: Theme.of(context)
                                                  .selectedRowColor),
                                          child: ListTile(
                                              title: Text(
                                                "${item.productID == '010101' ? S.current.mensuel : item.productID == '121212' ? S.current.annuel : S.current.a_vie}",
                                                style: GoogleFonts.lato(
                                                    textStyle: GoogleFonts.lato(
                                                        textStyle: TextStyle(
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontSize: 22))),
                                              ),
                                              subtitle: Text(
                                                "${DateTime.fromMillisecondsSinceEpoch((item.billingClientPurchase.purchaseTime))}",
                                                style: GoogleFonts.lato(
                                                    textStyle: TextStyle(
                                                        fontWeight:
                                                        FontWeight.bold)),
                                              ),
                                              trailing: Icon(
                                                Icons.check_circle,
                                                color: Colors.green,
                                                size: 30,
                                              )),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        S.current.msg_get_abonnement,
                                        style: GoogleFonts.lato(
                                            textStyle: TextStyle(
                                                color: Theme.of(context)
                                                    .tabBarTheme
                                                    .unselectedLabelColor,
                                                fontWeight: FontWeight.bold)),
                                      )
                                    ],
                                  );
                                }).toList()));
                      } else {
                        // get tous les produits
                        return FutureBuilder<List<ProductDetails>>(
                            future: retrieveProducts(),
                            initialData: List<ProductDetails>(),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<ProductDetails>> products) {
                              if (products.data != null) {
                                return SingleChildScrollView(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                        children: _buildListPurchasedCard(
                                            products.data)));
                              }
                              return CircularProgressIndicator();
                            });
                      }
                    }
                    return Container(
                        height: 300,
                        child: Center(child: CircularProgressIndicator()));
                  }),
            ],
          ),
        ));
  }

  Widget _buildAvantage(item) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).selectedRowColor),
      padding: EdgeInsets.all(8),
      child: ListTile(
        leading: item["icon"],
        title: Text(
          item["title"],
          style: GoogleFonts.lato(),
        ),
        subtitle: Text(
          item["small_description"],
          style: GoogleFonts.lato(),
        ),
        trailing: Icon(
          Icons.check,
          color: Colors.green,
        ),
      ),
    );
  }

  List<Widget> _buildListPurchasedCard(data) {
    List<Widget> list = new List<Widget>();
    data.sort((a, b) {
      return a.id.toString().compareTo(b.id.toString());
    });
    for (int i = 0; i < data.length; i++) {
      var item = _buildPurchaseCard(data[i]);
      list.add(item);
    }
    return list;
  }

  Widget _buildPurchaseCard(ProductDetails productDetail) {
    double _remisePercent = 0;

    //traitement de string
    String _prix_product = productDetail.price;
    if (Platform.localeName.substring(0, (2)) == 'fr') {
      _prix_product = _prix_product
          .replaceAll(",", ".")
          .replaceAll(new RegExp(r"\s+\b|\b\s"), "")
          .replaceAll(new RegExp('[a-zA-Z]'), '')
          .replaceAll(" ", "")
          .trim();
    } else {
      _prix_product = _prix_product
          .replaceAll(",", "")
          .replaceAll(new RegExp('[a-zA-Z]'), '')
          .trim();
    }

    _prix_product = _prix_product.replaceAll('\u00A0', '');
    _prix_product = _prix_product.replaceAll('&nbsp;', '');

    String _devise_product = productDetail.price;
    _devise_product =
        _devise_product.replaceAll(new RegExp('[0-9,.]'), '').trim();
    _devise_product = _devise_product.replaceAll('\u00A0', '');
    _devise_product = _devise_product.replaceAll('&nbsp;', '');

    switch (productDetail.id) {
      case "010101":
        _prixmensuelle =
            double.parse(Helpers.extractPriceInappPurchase(_prix_product));
        break;
      case "121212":
        _prix_product = Helpers.extractPriceInappPurchase(_prix_product);
        double _prix_annuel = double.parse(_prix_product);
        double _prixmensuelle_12 = _prixmensuelle * 12;
        double _remiseMontant = (_prixmensuelle_12 - _prix_annuel);
        _remisePercent = (_remiseMontant * 100) / _prixmensuelle_12;
        break;
    }
    return InkWell(
      onTap: () async {
        print("purchase");
        await purchaseItem(productDetail);
      },
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsetsDirectional.only(bottom: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
                color: (productDetail.id == "010101")
                    ? Colors.blue
                    : (productDetail.id == "121212")
                    ? Colors.green
                    : Colors.red,
                width: 2),
            color: Theme.of(context).selectedRowColor),
        child: ListTile(
          title: Text(
            "$_devise_product ${Helpers.numberFormat(double.parse(Helpers.extractPriceInappPurchase(_prix_product)))}",
            style: GoogleFonts.lato(
                textStyle:
                TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          ),
          subtitle: Text(
            "${translateProductSubTitle(productDetail.title).toString()}",
            style: GoogleFonts.lato(
                textStyle: TextStyle(fontWeight: FontWeight.bold)),
          ),
          trailing: (productDetail.id != "010101")
              ? Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: (productDetail.id == "010101")
                  ? Colors.blue[900]
                  : (productDetail.id == "121212")
                  ? Colors.green[700]
                  : Colors.red[900],
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (productDetail.id == "121212")
                    ? Text(
                  S.current.economiser,
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 14)),
                )
                    : SizedBox(),
                SizedBox(
                  height: 5,
                ),
                (productDetail.id == "121212")
                    ? Text("${_remisePercent.roundToDouble()} %",
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 14),
                    ))
                    : Text(
                  "${S.current.no_abonnement}",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 14)),
                ),
              ],
            ),
          )
              : null,
        ),
      ),
    );
  }

  translateProductSubTitle(String subtitle) {
    switch (subtitle) {
      case "mensuel (Gestmob)":
        return S.current.mensuel;
        break;
      case "annuel (Gestmob)":
        return S.current.annuel;
        break;
      case "à vie  (Gestmob)":
        return S.current.a_vie;
        break;
    }
  }

  //*****************************************************************************************************************************************************************************
  //**************************************************************************acheté*********************************************************************************************
  _verifyPurchase(context) async {
    PurchaseDetails purchase = _hasPurchased(_selectedProduct);

    if (purchase != null && purchase.status == PurchaseStatus.purchased) {
//      update data base
      switch (purchase.productID) {
        case '999999':
          _myParams.versionType = "premium";
          _myParams.codeAbonnement = "illimit";
          _myParams.startDate = DateTime.fromMillisecondsSinceEpoch(
              purchase.billingClientPurchase.purchaseTime);
          await _queryCtr.updateItemInDb(DbTablesNames.myparams, _myParams);
          PushNotificationsManager.of(context).onMyParamsChange(_myParams);
          await retrieveoldPurchase();
          break;
        case '121212':
          _myParams.versionType = "premium";
          _myParams.codeAbonnement = "annuel";
          _myParams.startDate = DateTime.fromMillisecondsSinceEpoch(
              purchase.billingClientPurchase.purchaseTime);
          await _queryCtr.updateItemInDb(DbTablesNames.myparams, _myParams);
          PushNotificationsManager.of(context).onMyParamsChange(_myParams);
          await retrieveoldPurchase();
          break;
        case '010101':
          _myParams.versionType = "premium";
          _myParams.codeAbonnement = "mensuel";
          _myParams.startDate = DateTime.fromMillisecondsSinceEpoch(
              purchase.billingClientPurchase.purchaseTime);
          await _queryCtr.updateItemInDb(DbTablesNames.myparams, _myParams);
          PushNotificationsManager.of(context).onMyParamsChange(_myParams);
          await retrieveoldPurchase();
          break;
      }
    } else {
      if (purchase != null && purchase.status == PurchaseStatus.pending) {
        print('ddddd');
      }
    }
  }

  PurchaseDetails _hasPurchased(String productID) {
    return _purchases.firstWhere((purchase) => purchase.productID == productID,
        orElse: () => null);
  }

  // pour acheter un item
  purchaseItem(ProductDetails productDetails) async {
    _selectedProduct = productDetails.id;
    final PurchaseParam purchaseParam =
    PurchaseParam(productDetails: productDetails);
    if ((Platform.isIOS &&
        productDetails.skProduct.subscriptionPeriod == null) ||
        (Platform.isAndroid && productDetails.skuDetail.type == SkuType.subs)) {
      await _instance.buyConsumable(
          purchaseParam: purchaseParam, autoConsume: false);
    } else {
      await _instance.buyNonConsumable(
        purchaseParam: purchaseParam,
      );
    }
  }
}
