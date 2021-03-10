import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/Widgets/CustomWidgets/search_bar.dart';
import 'package:gestmob/Widgets/CustomWidgets/select_items_bar.dart';
import 'package:gestmob/Widgets/article_list_item.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/Article.dart';
import 'package:gestmob/models/ArticleFamille.dart';
import 'package:gestmob/models/ArticleMarque.dart';
import 'package:gestmob/models/Tiers.dart';
import 'package:gestmob/search/items_sliver_list.dart';
import 'package:gestmob/search/search_input_sliver.dart';
import 'package:gestmob/search/sliver_list_data_source.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:gestmob/Widgets/utils.dart' as utils;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'AddArticlePage.dart';
import 'package:gestmob/services/push_notifications.dart';
import 'package:gestmob/models/MyParams.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/scheduler.dart';


class ArticlesFragment extends StatefulWidget {
  final Function(List<dynamic>) onConfirmSelectedItems;
  final int tarification;

  const ArticlesFragment(
      {Key key, this.onConfirmSelectedItems, this.tarification})
      : super(key: key);

  @override
  _ArticlesFragmentState createState() => _ArticlesFragmentState();
}

class _ArticlesFragmentState extends State<ArticlesFragment> {
  bool isFilterOn = false;
  final TextEditingController searchController = new TextEditingController();
  List<dynamic> _selectedItems = new List<Object>();

  var _filterMap = new Map<String, dynamic>();
  var _emptyFilterMap = new Map<String, dynamic>();

  List<ArticleMarque> _marqueItems;
  List<DropdownMenuItem<ArticleMarque>> _marqueDropdownItems;

  List<ArticleFamille> _familleItems;
  List<DropdownMenuItem<ArticleFamille>> _familleDropdownItems;

  ArticleMarque _selectedMarque;
  ArticleFamille _selectedFamille;
  bool _filterOutStock = false;

  int _savedSelectedMarque = 0;
  int _savedSelectedFamille = 0;
  bool _savedFilterOutStock = false;

  SliverListDataSource _dataSource;
  MyParams _myParams;
  String feature9 = 'feature9' ;
  String feature10 = 'feature10' ;
  String feature13 = 'feature13' ;

  @override
  Future<void> initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      FeatureDiscovery.discoverFeatures(context, <String>{feature9,feature10,feature13});
    });
    fillFilter(_filterMap);
    fillFilter(_emptyFilterMap);
    _dataSource = SliverListDataSource(ItemsListTypes.articlesList, _filterMap);
  }

  @override
  void didChangeDependencies() {
    PushNotificationsManagerState data = PushNotificationsManager.of(context);
    _myParams = data.myParams;
  }

  //***************************************************partie speciale pour le filtre de recherche***************************************
  void fillFilter(Map<String, dynamic> filter) {
    filter["Id_Marque"] = _savedSelectedMarque;
    filter["Id_Famille"] = _savedSelectedFamille;
    filter["outStock"] = _savedFilterOutStock;
  }

  Future<Widget> futureInitState() async {
    _marqueItems = await _dataSource.queryCtr.getAllArticleMarques();
    _marqueItems[0].setLibelle(S.current.no_marque);

    _familleItems = await _dataSource.queryCtr.getAllArticleFamilles();
    _familleItems[0].setLibelle(S.current.no_famille);

    _marqueDropdownItems = utils.buildMarqueDropDownMenuItems(_marqueItems);
    _familleDropdownItems = utils.buildDropFamilleArticle(_familleItems);

    _selectedMarque = _marqueItems[_savedSelectedMarque];
    _selectedFamille = _familleItems[_savedSelectedFamille];
    _filterOutStock = _savedFilterOutStock;

    final tile = StatefulBuilder(builder: (context, StateSetter _setState) {
      return Builder(
        builder: (context) => Column(
          children: [
            new ListTile(
              title: new Text(S.current.marque),
              trailing: marquesDropDown(_setState),
            ),
            new ListTile(
              title: new Text(S.current.famile),
              trailing: famillesDropDown(_setState),
            ),
            stockCheckBox(_setState),
          ],
        ),
      );
    });

    return Wrap(children: [
      Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.only(start: 5, end: 5, bottom: 5),
              child: tile,
            ),
          ],
        ),
      ),
    ]);
  }

  Widget addFilterdialogue() {
    return FutureBuilder(
        future: futureInitState(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Dialog(
              child: Container(
                  height: 100.0,
                  width: 100.0,
                  child: Center(
                    child: CircularProgressIndicator(),
                  )),
            );
          } else {
            return snapshot.data;
          }
        });
  }

  Widget marquesDropDown(StateSetter _setState) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<ArticleMarque>(
          value: _selectedMarque,
          items: _marqueDropdownItems,
          onChanged: (value) {
            _setState(() {
              _selectedMarque = value;
            });
          }),
    );
  }

  Widget famillesDropDown(StateSetter _setState) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<ArticleFamille>(
          value: _selectedFamille,
          items: _familleDropdownItems,
          onChanged: (value) {
            _setState(() {
              _selectedFamille = value;
            });
          }),
    );
  }

  Widget stockCheckBox(StateSetter _setState) {
    return CheckboxListTile(
      title: Text(S.current.non_stocke),
      value: _filterOutStock,
      onChanged: (bool value) {
        _setState(() {
          _filterOutStock = value;
        });
      },
    );
  }

  //********************************************listing des pieces**********************************************************************
  Widget getAppBar(setState) {
    if (_selectedItems.length > 0) {
      return SelectItemsBar(
        itemsCount: _selectedItems.length,
        onConfirm: () => {
          widget.onConfirmSelectedItems(_selectedItems),
          Navigator.pop(context)
        },
        onCancel: () => {
          setState(() {
            _selectedItems.forEach((item) {
              item.selectedQuantite = -1.0;
            });
            _selectedItems = new List<Object>();
          })
        },
      );
    } else {
      return SearchBar(
        searchController: searchController,
        mainContext: widget.onConfirmSelectedItems != null ? null : context,
        title: S.current.articles,
        isFilterOn: isFilterOn,
        onSearchChanged: (String search) => {
          _dataSource.updateSearchTerm(search),
           for(var item in _dataSource.itemList){
             for(var e in _selectedItems){
               if (e.hashCode == item.hashCode){

               }
             }
           }
        },
        onFilterPressed: () async {
          AwesomeDialog(
              context: context,
              dialogType: DialogType.INFO,
              animType: AnimType.BOTTOMSLIDE,
              title: S.current.supp,
              body: addFilterdialogue(),
              btnOkText: S.current.filtrer_btn,
              closeIcon: Icon(
                Icons.close,
                color: Colors.red,
                size: 26,
              ),
              showCloseIcon: true,
              btnOkOnPress: () async {
                setState(() {
                  _savedSelectedMarque = _marqueItems.indexOf(_selectedMarque);
                  _savedSelectedFamille =
                      _familleItems.indexOf(_selectedFamille);
                  _savedFilterOutStock = _filterOutStock;

                  fillFilter(_filterMap);

                  if (_filterMap.toString() == _emptyFilterMap.toString()) {
                    isFilterOn = false;
                  } else {
                    isFilterOn = true;
                  }
                  _dataSource.updateFilters(_filterMap);
                });

              })
            ..show();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton:CircularMenu(
            alignment: (Helpers.isDirectionRTL(context))
                ? Alignment.bottomLeft
                : Alignment.bottomRight,
            startingAngleInRadian:
                (Helpers.isDirectionRTL(context)) ? 1.6 * pi : 1.1 * pi,
            endingAngleInRadian:
                (Helpers.isDirectionRTL(context)) ? 1.9 * pi : 1.4 * pi,
            radius: 90,
            toggleButtonColor:
                Theme.of(context).floatingActionButtonTheme.backgroundColor,
            toggleButtonIconColor:
                Theme.of(context).floatingActionButtonTheme.foregroundColor,
            toggleButtonSize: 35,
            toggleButtonBoxShadow: [
              BoxShadow(
                color: Colors.white10,
                blurRadius: 0,
              ),
            ],
            items: [
              CircularMenuItem(
                  icon: (Icons.add),
                  color: Colors.green,
                  iconSize: 30.0,
                  margin: 10.0,
                  padding: 10.0,
                  onTap: () {
                    _addNewArticle(context) ;
                  },
              ),
              CircularMenuItem(
                icon: (MdiIcons.barcode),
                iconSize: 30.0,
                margin: 10.0,
                padding: 10.0,
                color: Colors.blue,
                onTap: () {
                  scanBarCode();
                },
              )
            ]
        ),
        appBar: getAppBar(setState),
        body: ItemsSliverList(
            dataSource: _dataSource,
            canRefresh: _selectedItems.length <= 0,
            tarification: widget.tarification,
            onItemSelected: widget.onConfirmSelectedItems != null
                ? (selectedItem) {
                    onItemSelected(setState, selectedItem);
                  }
                : null));
  }

  _addNewArticle(context){
    if(_myParams.versionType == "demo"){
      if(_dataSource.itemCount < 10){
        Navigator.of(context)
            .pushNamed(RoutesKeys.addArticle,
            arguments: new Article.init())
            .then((value) {
          _dataSource.refresh();
        });
      }else{
        Navigator.pushNamed(context, RoutesKeys.appPurchase);
        var message = S.current.msg_demo_exp;
        Helpers.showFlushBar(context, message);
      }
    }else{
      if(DateTime.now().isBefore(Helpers.getDateExpiration(_myParams))){
        Navigator.of(context)
            .pushNamed(RoutesKeys.addArticle,
            arguments: new Article.init())
            .then((value) {
          _dataSource.refresh();
        });
      }else{
        Navigator.pushNamed(context, RoutesKeys.appPurchase);
        var message = S.current.msg_premium_exp;
        Helpers.showFlushBar(context, message);
      }
    }

  }

  onItemSelected(setState, selectedItem) {
    setState(() {
      if (selectedItem != null) {
        if (_selectedItems.contains(selectedItem)) {
          _selectedItems.remove(selectedItem);
        } else {
          _selectedItems.add(selectedItem);
        }
      }
    });
  }

  Future scanBarCode() async {
    try {
      var options = ScanOptions(
        strings: {
          "cancel": S.current.annuler,
          "flash_on": S.current.flash_on,
          "flash_off": S.current.flash_off,
        },
      );

      var result = await BarcodeScanner.scan(options: options);
      if (result.rawContent.isNotEmpty) {
        setState(() {
          searchController.text = result.rawContent;
          _dataSource.updateSearchTerm(result.rawContent);
          FocusScope.of(context).requestFocus(null);

        });
      }
    } catch (e) {
      var result = ScanResult(
        type: ResultType.Error,
        format: BarcodeFormat.unknown,
      );

      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          result.rawContent = S.current.msg_cam_permission;
        });
      } else {
        result.rawContent = '${S.current.msg_ereure}: ($e)';
      }
      Helpers.showToast(result.rawContent);
    }
  }
}
