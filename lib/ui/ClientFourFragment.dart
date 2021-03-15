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
import 'package:gestmob/Widgets/article_list_item.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/Article.dart';
import 'package:gestmob/models/ArticleFamille.dart';
import 'package:gestmob/models/ArticleMarque.dart';
import 'package:gestmob/models/Tiers.dart';
import 'package:gestmob/models/TiersFamille.dart';
import 'package:gestmob/search/items_sliver_list.dart';
import 'package:gestmob/search/search_input_sliver.dart';
import 'package:gestmob/search/sliver_list_data_source.dart';
import 'package:image/image.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:gestmob/Widgets/utils.dart' as utils;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'AddArticlePage.dart';
import 'package:gestmob/services/push_notifications.dart';
import 'package:gestmob/models/MyParams.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/scheduler.dart';

class ClientFourFragment extends StatefulWidget {
  final int clientFourn;
  const ClientFourFragment ({Key key, this.clientFourn, this.onConfirmSelectedItem}): super(key: key);

  final Function(dynamic) onConfirmSelectedItem;

  @override
  _ClientFourFragmentState createState() => _ClientFourFragmentState();
}

class _ClientFourFragmentState extends State<ClientFourFragment> {
  bool isFilterOn = false;
  TextEditingController searchController = new TextEditingController();

  var _filterMap = new Map<String, dynamic>();
  var _emptyFilterMap = new Map<String, dynamic>();

  List<TiersFamille> _familleItems;
  List<DropdownMenuItem<Object>> _familleDropdownItems;
  var _selectedFamille;
  int _savedSelectedFamille = 0;

  bool _filterInHasCredit = false;
  bool _savedFilterHasCredit = false;

  bool _filterTierBloquer = false ;
  bool _savedFilterTierBloquer = false ;

  SliverListDataSource _dataSource;
  int _clientFour;
  MyParams _myParams;
  String feature7 = 'feature7';
  String feature8 = 'feature8';

  @override
  Future<void> initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      FeatureDiscovery.discoverFeatures(context, <String>{feature7,feature8});
    });
    _clientFour = widget.clientFourn ;
    fillFilter(_filterMap);
    fillFilter(_emptyFilterMap);
    _dataSource = SliverListDataSource(widget.clientFourn == 0? ItemsListTypes.clientsList : ItemsListTypes.fournisseursList, _filterMap);
  }

  @override
  void didChangeDependencies() {
    PushNotificationsManagerState data = PushNotificationsManager.of(context);
    _myParams = data.myParams;
  }

  Future<Widget> futureInitState() async {
    _familleItems = await _dataSource.queryCtr.getAllTierFamilles();
    _familleItems[0].libelle = S.current.no_famille ;

    _familleDropdownItems = utils.buildDropFamilleTier(_familleItems);
    _selectedFamille = _familleItems[_savedSelectedFamille];

    _filterInHasCredit = _savedFilterHasCredit;
    _filterTierBloquer = _savedFilterTierBloquer ;

    final tile = StatefulBuilder(builder: (context, StateSetter _setState) {
      return Builder(
        builder: (context) => Column(
          children: [
            new ListTile(
              title: new Text(S.current.famile),
              trailing: famillesDropDown(_setState),
            ),
            hasCreditCheckBox(_setState),
            tierBloquer(_setState),
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

  //*****************************************************************************************************************************************************
  //*************************************************************************filtre**********************************************************************
  void fillFilter(Map<String, dynamic> filter) {
    filter["Id_Famille"] = _savedSelectedFamille;
    filter["hasCredit"] = _savedFilterHasCredit;
    filter["Clientfour"] = _clientFour;
    filter["tierBloquer"] = _savedFilterTierBloquer ;
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
                  )
              ),
            );
          } else {
            return snapshot.data;
          }
        });
  }

  Widget famillesDropDown(StateSetter _setState) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<Object>(
          value: _selectedFamille,
          items: _familleDropdownItems,
          onChanged: (value) {
            _setState(() {
              _selectedFamille = value;
            });
          }),
    );
  }

  Widget hasCreditCheckBox(StateSetter _setState) {
    return CheckboxListTile(
      title: Text(S.current.a_credit),
      value: _filterInHasCredit,
      onChanged: (bool value){
        _setState(() {
          _filterInHasCredit = value;
        });
      },
    );
  }

  Widget tierBloquer(StateSetter _setState) {
    return CheckboxListTile(
      title: Text(S.current.aff_bloquer),
      value: _filterTierBloquer,
      onChanged: (bool value){
        _setState(() {
          _filterTierBloquer = value;
        });
      },
    );
  }

  //***************************************************************************************************************************************************
  //***************************************************************************affichage***************************************************************
  @override
  Widget build(BuildContext context) {
    setState(() {
      _filterMap ["Clientfour"] = widget.clientFourn;
    });
    _dataSource.updateFilters(_filterMap);

    return Scaffold(
        floatingActionButton: CircularMenu(
            alignment: (Helpers.isDirectionRTL(context))?Alignment.bottomLeft:Alignment.bottomRight,
            startingAngleInRadian:(Helpers.isDirectionRTL(context))? 1.6 * pi : 1.1 * pi,
            endingAngleInRadian: (Helpers.isDirectionRTL(context))? 1.9 * pi :1.4 * pi,
            radius: 90,
            toggleButtonColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
            toggleButtonIconColor: Theme.of(context).floatingActionButtonTheme.foregroundColor,
            toggleButtonSize: 35,
            toggleButtonBoxShadow: [
              BoxShadow(
                color: Colors.white10,
                blurRadius: 0,
              ),
            ],
            items: [
              CircularMenuItem(
                  icon:(Icons.add),
                  color: Colors.green,
                  iconSize: 30.0,
                  margin: 10.0,
                  padding: 10.0,
                  onTap: () {
                      _addNewTier(context);
                  },
              ),
              CircularMenuItem(
                icon: (MdiIcons.qrcode),
                iconSize: 30.0,
                margin: 10.0,
                padding: 10.0,
                color: Colors.blue,
                onTap: () {
                  scanQRCode() ;
                },

              )
            ]
        ),
        appBar: SearchBar(
          searchController: searchController,
          mainContext: widget.onConfirmSelectedItem != null ? null : context,
          title: widget.clientFourn == 0? S.current.client : S.current.fournisseur,
          isFilterOn: isFilterOn,
          onSearchChanged: (String search) => _dataSource.updateSearchTerm(search),
          onFilterPressed: () async {
            AwesomeDialog(
                context: context,
                dialogType: DialogType.INFO,
                animType: AnimType.BOTTOMSLIDE,
                title: S.current.supp,
                body: addFilterdialogue(),
                btnOkText: S.current.filtrer_btn,
                closeIcon: Icon(Icons.close , color: Colors.red , size: 26,),
                showCloseIcon: true,
                btnOkOnPress: () async{
                  setState(() {
                    _savedSelectedFamille = _familleItems.indexOf(_selectedFamille);
                    _savedFilterHasCredit = _filterInHasCredit;
                    _savedFilterTierBloquer = _filterTierBloquer ;

                    fillFilter(_filterMap);

                    if( _filterMap.toString() == _emptyFilterMap.toString()){
                      isFilterOn = false;
                    } else{
                      isFilterOn = true;
                    }
                    _dataSource.updateFilters(_filterMap);
                  });

                }
            )..show();
          },
        ),
        body: ItemsSliverList(
            dataSource: _dataSource,
            onItemSelected: widget.onConfirmSelectedItem != null? (selectedItem) {
              widget.onConfirmSelectedItem(selectedItem);
              Navigator.pop(context);
            } : null
        ));
  }

  //********************************************************************************************************************************************************
  //******************************************************************************************************************************************************************

  _addNewTier (context){
    if(_myParams.versionType == "demo"){
      if(_dataSource.itemCount < 10){
        Navigator.of(context).pushNamed(RoutesKeys.addTier,arguments: new Tiers.init(widget.clientFourn))
            .then((value){
          _dataSource.refresh();
        });
      }else{
        Navigator.pushNamed(context, RoutesKeys.appPurchase);
        var message = S.current.msg_demo_exp;
        Helpers.showFlushBar(context, message);
      }
    }else{
      if(DateTime.now().isBefore(Helpers.getDateExpiration(_myParams))){
        Navigator.of(context).pushNamed(RoutesKeys.addTier,arguments: new Tiers.init(widget.clientFourn))
            .then((value){
          _dataSource.refresh();
        });
      }else{
        Navigator.pushNamed(context, RoutesKeys.appPurchase);
        var message = S.current.msg_premium_exp;
        Helpers.showFlushBar(context, message);
      }
    }

  }

  Future scanQRCode() async {
    try {
      var options = ScanOptions(
        strings: {
          "cancel": S.current.annuler,
          "flash_on": S.current.flash_on,
          "flash_off": S.current.flash_off,
        },
      );

      var result = await BarcodeScanner.scan(options: options);
      if(result.rawContent.isNotEmpty){
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
        result.rawContent = '${S.current.msg_ereure}($e)';
      }
      Helpers.showToast(result.rawContent);
    }
  }

}
