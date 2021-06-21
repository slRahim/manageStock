import 'package:draggable_container/draggable_container.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/Widgets/HomeItemsWidgets.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/HomeItem.dart';
import 'package:gestmob/services/push_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
    homeItemRapports
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
      child: InkWell(
        onTap: () async {
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
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 1,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                LineIcons.plus,
                size: 45,
                color: Colors.white,
              ),
              SizedBox(
                width: 10.0,
                height: 10.0,
              ),
              Text(
                S.current.ajouter,
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
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

      homeItemAccueil.title = S.current.accueil;
      homeItemParametres.title = S.current.settings;
      drawerItemAvoirFournisseur.title = S.current.avoir_fournisseur;
      drawerItemAvoirClient.title = S.current.avoir_client;
      drawerItemRetourClient.title = S.current.retour_client;
      drawerItemRetourFournisseur.title = S.current.retour_fournisseur;
      drawerItemBonDeCommande.title = S.current.bon_commande;
      drawerItemExit.title = S.current.quitter;
      drawerItemPurchase.title = S.current.abonnement;
      drawerItemVente.title = S.current.vente;
      drawerItemAchat.title = S.current.achat;
      drawerItemFamilleMarque.title = S.current.famille_marque;

      _appBarTitle = S.current.app_name;

      Statics.statutItems[0] = S.current.statut_m;
      Statics.statutItems[1] = S.current.statut_mlle;
      Statics.statutItems[2] = S.current.statut_mme;
      Statics.statutItems[3] = S.current.statut_dr;
      Statics.statutItems[4] = S.current.statut_pr;
      Statics.statutItems[5] = S.current.statut_eurl;
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
    var size = (MediaQuery.of(context).size.width % 115).toInt() / 2;

    if (!_finishLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        key: _key,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.menu, size: 25),
            // change this size and style
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
          title: Container(
            padding: EdgeInsets.only(top: 10),
            child: Text(_appBarTitle,
                style: GoogleFonts.anton(
                  fontSize: 28,
                )),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                Icons.contact_support,
                size: 30,
              ),
              onPressed: () async {
                // Navigator.pushNamed(context, RoutesKeys.supportPage);
                var url = "https://cirtait.com/contact";
                if (await canLaunch(url)) {
                  await launch(
                    url,
                    forceSafariVC: true,
                    forceWebView: true,
                    enableJavaScript: true,
                    headers: <String, String>{
                      'my_header_key': 'my_header_value'
                    },
                  );
                } else {
                  throw 'Could not launch $url';
                }
              },
            )
          ],
          bottom: PreferredSize(
            preferredSize:
                (MediaQuery.of(context).orientation == Orientation.portrait)
                    ? Size.fromHeight(MediaQuery.of(context).size.height / 6)
                    : Size.fromHeight(MediaQuery.of(context).size.height / 3),
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsetsDirectional.only(start: 15, end: 15),
                height:
                    (MediaQuery.of(context).orientation == Orientation.portrait)
                        ? MediaQuery.of(context).size.height / 6
                        : MediaQuery.of(context).size.height / 3,
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
                                      children: [
                                        Text("${S.current.ca_mois}",
                                            style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)))
                                      ],
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
                                        "${Helpers.numberFormat((_indiceFinanciere[0] != null) ? _indiceFinanciere[0] : 0.0)}",
                                        style: GoogleFonts.lato(
                                            textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 18))),
                                    Text(" ${_devise}",
                                        style: GoogleFonts.lato(
                                            textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white))),
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
                                      children: [
                                        Text("${S.current.achat_mois}",
                                            style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)))
                                      ],
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
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.white))),
                                    Text(" $_devise",
                                        style: GoogleFonts.lato(
                                            textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white))),
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
        ),
        body: FutureBuilder(
            future: asyncStart(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                return SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(left: size, top: size),
                    child: DescribedFeatureOverlay(
                      featureId: feature11,
                      tapTarget: Icon(
                        MdiIcons.gestureTapHold,
                        color: Colors.black,
                      ),
                      backgroundColor: Colors.yellow[700],
                      contentLocation: ContentLocation.below,
                      title: Text(S.current.long_presse),
                      description: Container(
                          width: 150,
                          child: Text(
                            S.current.msg_long_presse,
                          )),
                      onBackgroundTap: () async {
                        await FeatureDiscovery.completeCurrentStep(context);
                        return true;
                      },
                      child: DraggableContainer(
                        key: _containerKey,
                        draggableMode: false,
                        autoReorder: true,
                        // the decoration when dragging item
                        dragDecoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 10)
                        ]),
                        // slot margin
                        slotMargin: EdgeInsets.only(
                            left: 5, right: 5, top: 2.5, bottom: 2.5),
                        // the slot size
                        slotSize: Size(110, 110),
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
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Icon(
                            Icons.delete_forever,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        onDraggableModeChanged: (bool draggableMode) {
                          GridHomeWidget.Global_Draggable_Mode = draggableMode;

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
            }),
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

  DraggableItem getMissingItem(
      BuildContext context, List<DraggableItem> items, int count) {
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
