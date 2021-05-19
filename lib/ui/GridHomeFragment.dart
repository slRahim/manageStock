import 'dart:convert';
import 'package:draggable_container/draggable_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/Widgets/HomeItemsWidgets.dart';
import 'package:gestmob/Widgets/HomeItemsWidgets.dart';
import 'package:gestmob/Widgets/HomeItemsWidgets.dart';
import 'package:gestmob/Widgets/navDrawer.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/MyParams.dart';
import 'package:gestmob/services/local_notification.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gestmob/cubit/home_cubit.dart';
import 'package:gestmob/models/HomeItem.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:reorderables/reorderables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AddArticlePage.dart';
import 'package:gestmob/services/push_notifications.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/scheduler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
class GridHomeWidget extends StatefulWidget {
  static bool Global_Draggable_Mode = false;

  @override
  _GridHomeWidgetState createState() => _GridHomeWidgetState();
}

class _GridHomeWidgetState extends State<GridHomeWidget> {
  List<DraggableItem> homeDraggableItemList = <DraggableItem>[];
  final originalHomeDraggableItemList = <DraggableItem>[];
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final GlobalKey<DraggableContainerState> _containerKey = GlobalKey();
  DraggableItem _addButton;
  int _count = 0;

  String _appBarTitle;
  Locale _userLocale;
  List<HomeItem> homeItemList = [
    homeItemTableauDeBord,
    homeItemArticles,
    homeItemClients,
    homeItemDevis,
    homeItemCommandeClient,
    homeItemBonDeLivraison,
    homeItemFactureDeVente,
    homeItemFournisseurs,
    homeItemBonDeReception,
    homeItemFactureDachat,
    homeItemTresorerie,
    homeItemRapports,
    homeItemParametres
  ];

  QueryCtr _queryCtr = new QueryCtr();
  var _indiceFinanciere;
  String _devise;
  bool _finishLoading = false;
  String feature11 = 'feature11';


  @override
  Future<void> initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      FeatureDiscovery.discoverFeatures(context, <String>{feature11});
    });
    futurInit().then((value) {
      setState(() {
        _finishLoading = true;
      });
    });
    _addButton = DraggableItem(
      fixed: true,
      deletable: false,
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: RaisedButton.icon(
              color: Colors.orange,
              onPressed: () async {
                final items = _containerKey.currentState.items;
                final buttonIndex = items.indexOf(_addButton),
                    nullIndex = items.indexOf(null);

                /// use new item to instead of the button position
                if (buttonIndex > -1) {
                  await _containerKey.currentState.insteadOfIndex(
                      buttonIndex, getMissingItem(context, items, _count),
                      force: true, triggerEvent: false);
                  _count++;

                  /// use the button instead of the first null position
                  if (nullIndex > -1) {
                    await _containerKey.currentState.insteadOfIndex(
                        nullIndex, _addButton,
                        force: true, triggerEvent: false);
                  }
                }
              },
              textColor: Colors.white,
              icon: Icon(Icons.add_box, size: 20),
              label: Text(S.current.ajouter, style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 12))))),
    );
  }


  @override
  void didChangeDependencies() {
    final newLocale = Localizations.localeOf(context);
    PushNotificationsManagerState data = PushNotificationsManager.of(context);
    _devise = Helpers.getDeviseTranslate(data.myParams.devise);
    if (newLocale != _userLocale) {
      homeItemList[0].title = S.current.tableau_bord;
      homeItemList[1].title = S.current.articles;
      homeItemList[2].title = S.current.client;
      homeItemList[3].title = S.current.devis;
      homeItemList[4].title = S.current.commande_client;
      homeItemList[5].title = S.current.bon_livraison;
      homeItemList[6].title = S.current.facture_vente;
      homeItemList[7].title = S.current.fournisseur;
      homeItemList[8].title = S.current.bon_reception;
      homeItemList[9].title = S.current.facture_achat;
      homeItemList[10].title = S.current.tresories;
      homeItemList[11].title = S.current.rapports;
      homeItemList[12].title = S.current.settings;

      homeItemAccueil.title = S.current.accueil;

      drawerItemAvoirFournisseur.title = S.current.avoir_fournisseur;
      drawerItemAvoirClient.title = S.current.avoir_client;
      drawerItemRetourClient.title = S.current.retour_client;
      drawerItemRetourFournisseur.title = S.current.retour_fournisseur;
      drawerItemBonDeCommande.title = S.current.bon_commande;
      drawerItemExit.title = S.current.quitter;
      drawerItemPurchase.title = S.current.abonnement;

      _appBarTitle = S.current.app_name;

      Statics.statutItems[0] = S.current.statut_m ;
      Statics.statutItems[1] = S.current.statut_mlle ;
      Statics.statutItems[2] = S.current.statut_mme ;
      Statics.statutItems[3] = S.current.statut_dr ;
      Statics.statutItems[4] = S.current.statut_pr ;
      Statics.statutItems[5] = S.current.statut_eurl ;
    }
  }

  Future futurInit() async {
    _indiceFinanciere = await _queryCtr.statHomePage();
  }

  void showSnackBar(String text) {
    _key.currentState.hideCurrentSnackBar();
    _key.currentState.showSnackBar(SnackBar(
      content: Text(text),
    ));
  }

  @override
  Widget build(BuildContext context) {
    var padding = (MediaQuery.of(context).size.width%112).toInt()/2;

    if (!_finishLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize:
          (MediaQuery.of(context).orientation == Orientation.portrait)
              ? Size.fromHeight(MediaQuery.of(context).size.height / 4.2)
              :Size.fromHeight(MediaQuery.of(context).size.height / 2),
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.color,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(2, 1), // changes position of shadow
                  ),
                ]),
            child: Column(
              children: [
                AppBar(
                  leading: IconButton(
                    icon: Icon(Icons.menu, size: 25),
                    // change this size and style
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                  title: Text(_appBarTitle , style: GoogleFonts.anton(fontSize: 28, )),
                  centerTitle: true,
                  elevation: 0,
                  actions: [
                    IconButton(
                      icon: Icon(Icons.contact_support,size: 30,),
                      onPressed: ()async{
                        // Navigator.pushNamed(context, RoutesKeys.supportPage);
                        var url = "https://cirtait.com/contact" ;
                        if (await canLaunch(url)) {
                          await launch(
                          url,
                          forceSafariVC: true,
                          forceWebView: true,
                          enableJavaScript: true,
                          headers: <String, String>{'my_header_key': 'my_header_value'},
                          );
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    )
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(left: 25, right: 25),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.arrow_upward,
                                          color: Colors.white,
                                          size: 40,
                                        ),
                                        SizedBox(
                                          width: 1,
                                        ),
                                        Container(
                                          child: Wrap(
                                            direction: Axis.vertical,
                                            children: [Text("${S.current.ca_mois}",
                                                style: GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white)
                                                ))],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Container(
                                      child: Wrap(
                                        direction: Axis.horizontal,
                                        children: [
                                          Text(
                                              "${Helpers.numberFormat((_indiceFinanciere[0] != null) ? _indiceFinanciere[0]: 0.0)}",
                                              style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize: 18)
                                              )),
                                          Text(" ${_devise}",
                                              style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.arrow_downward,
                                          color: Colors.white,
                                          size: 40,
                                        ),
                                        SizedBox(
                                          width: 1,
                                        ),
                                        Container(
                                          child: Wrap(
                                            direction: Axis.vertical,
                                            children: [Text("${S.current.achat_mois}",
                                                style: GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white)
                                                )
                                            )],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Container(
                                      child: Wrap(
                                        direction: Axis.horizontal,
                                        children: [
                                          Text(
                                              "${Helpers.numberFormat((_indiceFinanciere[1] != null) ? _indiceFinanciere[1] : 0.0)}",
                                              style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,fontSize: 18,
                                                    color: Colors.white)
                                              )),
                                          Text(" ${_devise}",
                                              style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Center(
            child: FutureBuilder(
                future: asyncStart(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(left: padding, top: 10),
                        child: DescribedFeatureOverlay(
                          featureId: feature11,
                          tapTarget: Icon(MdiIcons.gestureTapHold , color: Colors.black,),
                          backgroundColor: Colors.yellow[700],
                          contentLocation: ContentLocation.below,
                          title: Text(S.current.long_presse),
                          description: Container(
                               width: 150,
                              child: Text(S.current.msg_long_presse,)),
                          onBackgroundTap: () async{
                            await FeatureDiscovery.completeCurrentStep(context);
                            return true ;
                          },
                          child: DraggableContainer(
                              key: _containerKey,
                              draggableMode: false,
                              autoReorder: true,
                              // the decoration when dragging item
                              dragDecoration: BoxDecoration(boxShadow: [
                                BoxShadow(color: Colors.black, blurRadius: 10)
                              ]),
                              // slot margin
                              slotMargin: EdgeInsets.only(
                                  left: 10, right: 10, top: 5, bottom: 5),
                              // the slot size

                              // item list
                              items: homeDraggableItemList,
                              // onDragEnd: () {
                              //   _containerKey.currentState.draggableMode = false;
                              // },
                              deleteButton: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                                ),
                                child: Icon(
                                  Icons.delete_forever,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                              onDraggableModeChanged: (bool draggableMode) {
                                GridHomeWidget.Global_Draggable_Mode =
                                    draggableMode;

                                final items = _containerKey.currentState.items;
                                if (draggableMode) {
                                  draggableItemsListOnChange(items);
                                } else {
                                  _containerKey.currentState
                                      .removeItem(_addButton, triggerEvent: false);
                                  if (items.isNotEmpty) {
                                    saveCurrentItemsOrder(items);
                                  }
                                }
                              },
                              onChanged: (items) async {
                                draggableItemsListOnChange(items);
                              },
                            ),
                          ),
                        ),
                    );
                  }
                })),
      );
    }
  }

  //get items list +order +
  Future<List<DraggableItem>> asyncStart() async {
    for (var i = 0, j = homeItemList.length; i < j; i++) {
      HomeDraggableItem item = new HomeDraggableItem(
          index: i, context: context, data: homeItemList[i]);

      originalHomeDraggableItemList.add(item);
    }

    List<int> savedItemsOrder = await getSavedItemsOrder();

    if (savedItemsOrder == null || savedItemsOrder.isEmpty) {
      homeDraggableItemList = originalHomeDraggableItemList;
    } else {
      for (var i = 0, j = savedItemsOrder.length; i < j; i++) {
        if (savedItemsOrder[i] > -1) {
          HomeDraggableItem item =
              originalHomeDraggableItemList[savedItemsOrder[i]];
          item.index = savedItemsOrder[i];
          homeDraggableItemList.add(item);
        }
      }
      for (var i = 0, j = (homeItemList.length - homeDraggableItemList.length);
          i < j;
          i++) {
        homeDraggableItemList.add(null);
      }
    }

    return homeDraggableItemList;
  }

  DraggableItem getMissingItem(BuildContext context, List<DraggableItem> items, int count) {
    for (DraggableItem item in originalHomeDraggableItemList) {
      if (!items.contains(item)) {
        return item;
      }
    }
  }

  void draggableItemsListOnChange(items) {
    final nullIndex = items.indexOf(null);
    final buttonIndex = items.indexOf(_addButton);
    if (nullIndex > -1) {
      if (buttonIndex == -1) {
        setState(() {
          _containerKey.currentState
              .insteadOfIndex(nullIndex, _addButton, triggerEvent: false);
        });
      } else if (nullIndex < buttonIndex) {
        _containerKey.currentState
            .moveTo(buttonIndex, nullIndex, triggerEvent: false);
      }
    }
  }

  Future<void> saveCurrentItemsOrder(List<DraggableItem> currentItems) async {
    List<int> currentItemsIndexList = new List<int>();

    for (var i = 0, j = currentItems.length; i < j; i++) {
      var index = originalHomeDraggableItemList.indexOf(currentItems[i]);
      if (index != null && index > -1) {
        currentItemsIndexList.add(index);
      }
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> stringsList =
        currentItemsIndexList.map((i) => i.toString()).toList();

    prefs.setStringList("ItemsOrderStringList", stringsList);
  }

  Future<List<int>> getSavedItemsOrder() async {
    Future<SharedPreferences> _sPrefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _sPrefs;
    List<String> mList = prefs.getStringList('ItemsOrderStringList');
    if (mList != null && mList.isNotEmpty) {
      List<int> mSavedList = mList.map((i) => int.parse(i)).toList();
      return mSavedList;
    } else {
      return null;
    }
  }
}
