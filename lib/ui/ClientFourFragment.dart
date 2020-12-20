import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:gestmob/Widgets/utils.dart' as utils;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'AddArticlePage.dart';

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

  List<Object> _familleItems;
  List<DropdownMenuItem<Object>> _familleDropdownItems;
  var _selectedFamille;
  int _savedSelectedFamille = 0;

  bool _filterInHasCredit = false;
  bool _savedFilterHasCredit = false;

  bool _filterTierBloquer = false ;
  bool _savedFilterTierBloquer = false ;

  SliverListDataSource _dataSource;
  int _clientFour;

  @override
  Future<void> initState() {
    super.initState();
    _clientFour = widget.clientFourn ;
    fillFilter(_filterMap);
    fillFilter(_emptyFilterMap);
    _dataSource = SliverListDataSource(widget.clientFourn == 0? ItemsListTypes.clientsList : ItemsListTypes.fournisseursList, _filterMap);
  }

  void fillFilter(Map<String, dynamic> filter) {
    filter["Id_Famille"] = _savedSelectedFamille;
    filter["hasCredit"] = _savedFilterHasCredit;
    filter["Clientfour"] = _clientFour;
    filter["tierBloquer"] = _savedFilterTierBloquer ;
  }

  Future<Widget> futureInitState() async {
    _familleItems = await _dataSource.queryCtr.getAllTierFamilles();
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
              padding: EdgeInsets.only(left: 5, right: 5, bottom: 20),
              child: tile,
            ),
            SizedBox(
              width: 320.0,
              child: Padding(
                padding: EdgeInsets.only(right: 0, left: 0),
                child: RaisedButton(
                  onPressed: () async {
                    Navigator.pop(context);
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
                  },
                  child: Text(
                    S.current.filtrer_btn,
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.green[900],
                ),
              ),
            )
          ],
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: SpeedDial(
          marginRight: 18,
          marginBottom: 20,
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(size: 22.0),
          closeManually: false,
          curve: Curves.bounceIn,
          overlayColor: Colors.black,
          overlayOpacity: 0.1,
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          elevation: 8.0,
          shape: CircleBorder(),
          children: [
            SpeedDialChild(
                child: Icon(Icons.add),
                backgroundColor: Colors.green,
                label: S.current.ajouter,
                onTap: () {
                  Navigator.of(context).pushNamed(RoutesKeys.addTier,arguments: new Tiers.init(widget.clientFourn));
                }
            ),
            SpeedDialChild(
              child: Icon(MdiIcons.qrcode),
              backgroundColor: Colors.blue,
              label: S.current.scan_qr,
              onTap: () => scanQRCode(),
            ),
          ],
        ),
        appBar: SearchBar(
          searchController: searchController,
          mainContext: context,
          title: widget.clientFourn == 0? S.current.client_titre : S.current.fournisseur_titre,
          isFilterOn: isFilterOn,
          onSearchChanged: (String search) => _dataSource.updateSearchTerm(search),
          onFilterPressed: () async {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return addFilterdialogue();
                });
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
            return Dialog(
              child: snapshot.data,
            );
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
