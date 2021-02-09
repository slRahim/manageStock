import 'dart:convert';
import 'package:draggable_container/draggable_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  QueryCtr _queryCtr = new QueryCtr() ;
  var _indiceFinanciere ;
  bool _finishLoading = false ;

  @override
  Future<void> initState() {
    super.initState();
    futurInit().then((value){
      setState(() {
        _finishLoading = true ;
      });
    });
    _addButton = DraggableItem(
      fixed: true,
      deletable: false,
      child: Container(
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
              label: Text(S.current.ajouter, style: TextStyle(fontSize: 12)))),
    );
  }

  @override
  void didChangeDependencies() async {
    final newLocale = Localizations.localeOf(context);

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
      drawerItemHelp.title = S.current.aide;
      drawerItemExit.title = S.current.quitter;

      _appBarTitle = S.current.app_name;
    }
    super.didChangeDependencies();
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
    if(!_finishLoading){
      return Center(child: CircularProgressIndicator());
    }else{
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(MediaQuery.of(context).size.height / 7),
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
                ]
            ),
            child: Column(
              children: [
                AppBar(
                  leading: IconButton(
                    icon: Icon(Icons.menu, size: 25),
                    // change this size and style
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                  title: Text(_appBarTitle),
                  centerTitle: true,
                  elevation: 0,
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsetsDirectional.only(start: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              MdiIcons.cashMultiple,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Wrap(
                                direction: Axis.horizontal,
                                children: [
                                  Text("${Helpers.numberFormat((_indiceFinanciere[0] != null)?_indiceFinanciere[0]:0.0)}",
                                      style: TextStyle(fontWeight: FontWeight.bold ,color: Colors.white)),
                                  Text("(${S.current.da})",
                                      style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 0.1,),
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              MdiIcons.basketFill,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Wrap(
                                direction: Axis.horizontal,
                                children: [
                                  Text("${Helpers.numberFormat((_indiceFinanciere[1] != null)?_indiceFinanciere[1]:0.0)}",
                                      style: TextStyle(fontWeight: FontWeight.bold,color:Colors.white)),
                                  Text("(${S.current.da})",
                                      style: TextStyle(fontWeight: FontWeight.bold,color:Colors.white)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Container(
            alignment: Alignment.center,
            child: FutureBuilder(
                future: asyncStart(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return SingleChildScrollView(
                      child: Container(
                        alignment: Alignment.center,
                        padding:
                        const EdgeInsetsDirectional.only(start: 20, end: 20),
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
                          slotSize: Size(90, 90),
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
