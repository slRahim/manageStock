import 'dart:async';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
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
  static InAppPurchaseConnection _instance = InAppPurchaseConnection.instance;
  List<PurchaseDetails> _purchases = [];
  StreamSubscription<List<PurchaseDetails>> _subscription;
  String _selectedProduct;
  Set<String> _productIds = <String>[].toSet();
  double _prixmensuelle;


  List<Map<String , dynamic>> _avantages = <Map<String , dynamic>> [
    {
      "icon" : Icon(Icons.all_inclusive , color: Colors.blue,),
      "title" : S.current.illimite,
      "small_description" : S.current.illimite_desc ,
    },
    {
      "icon" : Icon(Icons.print, color: Colors.blue),
      "title" :  S.current.imprime,
      "small_description" :  S.current.imprime_desc,
    },
    {
      "icon" : Icon(Icons.share , color: Colors.blue),
      "title" :  S.current.exporte,
      "small_description" :  S.current.exporte_desc,
    },
    {
      "icon" : Icon(Icons.add_to_drive , color: Colors.blue),
      "title" :  S.current.save_rest,
      "small_description" :  S.current.save_rest_desc,
    }
  ];

  @override
  void initState() {
    super.initState();

    retrieveoldPurchase();
    final Stream purchaseUpdates = _instance.purchaseUpdatedStream;
    _subscription = purchaseUpdates.listen((purchases) async {
      _purchases.addAll(purchases);
      await retrieveoldPurchase();
      await _verifyPurchase();
    }, onDone: () async {
      await _subscription.cancel();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  //get mon ancien package
  Future<List<PurchaseDetails>> retrieveoldPurchase() async {
    final bool available = await _instance.isAvailable();
    if (!available) {
      // Handle store not available
    } else {
      final QueryPurchaseDetailsResponse response =
      await _instance.queryPastPurchases();
      _purchases = response.pastPurchases;
      if(_purchases.length!=0){
        _selectedProduct = _purchases[0].productID;
      }
      return new Future(() => response.pastPurchases);
    }
  }

  // get tout les type d'abonement
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

  //****************************************************************************************************************************************************************************
  //**************************************************************************special affichage********************************************************************************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: SearchBar(
        mainContext: context,
        title: S.current.abonnement_title,
        isFilterOn: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            for (var e in _avantages)
              _buildAvantage(e),
            SizedBox(height: 10,),
            FutureBuilder<List<PurchaseDetails>>(
                future: retrieveoldPurchase(),
                initialData: List<PurchaseDetails>(),
                builder: (BuildContext context, AsyncSnapshot<List<PurchaseDetails>> products) {
                  if (products.data != null) {
                    if (products.data.length != 0) {
                      // le produit deja acheté
                      return new SingleChildScrollView(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                              children: products.data.map((item) {
                                   _selectedProduct = item.productID;
                                   _verifyPurchase();
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    _selectedProduct = item.productID;
                                    await _verifyPurchase();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    margin: EdgeInsetsDirectional.only(bottom: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.indigo,width: 2),
                                        color: Theme.of(context).selectedRowColor
                                    ),
                                    child: ListTile(
                                      title: Text("${item.productID == '010101' ? "Mensuel" : item.productID == '121212' ? "Annuel" : "A vie"}", style: TextStyle(fontWeight: FontWeight.bold , fontSize: 22),),
                                      subtitle: Text("${item.transactionDate}" , style: TextStyle(fontWeight: FontWeight.bold),),
                                      trailing:  Icon(Icons.check_circle ,color: Colors.green, size: 30,)
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Text(S.current.msg_get_abonnement ,
                                  style: TextStyle(
                                      color: Theme.of(context).tabBarTheme.unselectedLabelColor ,
                                      fontWeight: FontWeight.bold
                                  ),
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
                                  padding: new EdgeInsets.all(8.0),
                                  child: new Column(
                                      children: products.data
                                          .map((item) => _buildPurchaseCard(Colors.orange,item))
                                          .toList()));
                            }
                            return CircularProgressIndicator();
                          });
                    }
                  }
                  return Container(
                      height: 300,
                      child: Center(child: CircularProgressIndicator())
                  );
                }),
          ],
        ),
      )
    );
  }

  Widget _buildAvantage(item) {
     return Container(
       decoration: BoxDecoration(
         color: Theme.of(context).selectedRowColor
       ),
       padding: EdgeInsets.all(8),
       child: ListTile(
         leading: item["icon"],
         title: Text(item["title"]),
         subtitle: Text(item["small_description"]),
         trailing: Icon(Icons.check , color: Colors.green,),
       ),
     );
  }

  Widget _buildPurchaseCard(color1,productDetail){
    return InkWell(
      onTap: () async{
        print("purchase");
        await purchaseItem(productDetail);
      },
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsetsDirectional.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color1,width: 2),
          color: Theme.of(context).selectedRowColor
        ),
        child: ListTile(
          title: Text("${productDetail.price}", style: TextStyle(fontWeight: FontWeight.bold , fontSize: 22),),
          subtitle: Text("${productDetail.title.replaceAll('(Gestmob)', '')}" , style: TextStyle(fontWeight: FontWeight.bold),),
          trailing:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Economisé" , style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox (height: 5,),
              Text("10 %" , style: TextStyle(fontWeight: FontWeight.bold),)
            ],
          ),
        ),
      ),
    );
  }

  //*****************************************************************************************************************************************************************************
  //**************************************************************************acheté*********************************************************************************************
  _verifyPurchase() async {
    PurchaseDetails purchase = _hasPurchased(_selectedProduct);

    if (purchase != null && purchase.status == PurchaseStatus.purchased) {
//      update data base
      switch (purchase.productID) {
        case '999999':

          break;
        case '121212':

          break;
        case '010101':

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
