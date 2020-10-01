import 'package:barcode_scan/barcode_scan.dart';
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
import 'package:gestmob/search/items_sliver_list.dart';
import 'package:gestmob/search/search_input_sliver.dart';
import 'package:gestmob/search/sliver_list_data_source.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:gestmob/Widgets/utils.dart' as utils;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'AddArticlePage.dart';

class ArticlesFragment extends StatefulWidget {
  // final QueryCtr queryCtr;
  // const ArticlesFragment ({Key key, this.queryCtr}): super(key: key);

  final Function(List<dynamic>) onConfirmSelectedItems;

  const ArticlesFragment({Key key, this.onConfirmSelectedItems}) : super(key: key);
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
  bool _filterInStock = false;

  int _savedSelectedMarque = 0;
  int _savedSelectedFamille = 0;
  bool _savedFilterInStock = false;

  SliverListDataSource _dataSource;

  @override
  Future<void> initState() {
    super.initState();

    fillFilter(_filterMap);
    fillFilter(_emptyFilterMap);
    _dataSource = SliverListDataSource(ItemsListTypes.articlesList, _filterMap);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            widget.onConfirmSelectedItems != null? scanBarCode() : Navigator.of(context).pushNamed(RoutesKeys.addArticle,
                arguments: new Article.init());
          },
          child: widget.onConfirmSelectedItems != null? Icon(MdiIcons.barcode) : Icon(Icons.add),
        ),
        appBar: getAppBar(setState),
        body: ItemsSliverList(dataSource: _dataSource, canRefresh: _selectedItems.length <= 0,
            onItemSelected: widget.onConfirmSelectedItems != null? (selectedItem) {
          onItemSelected(setState, selectedItem);
        } : null
        ));
  }

  onItemSelected(setState, selectedItem){
    setState(() {
      if(selectedItem != null){
        if (_selectedItems.contains(selectedItem)) {
          _selectedItems.remove(selectedItem);
        } else {
          _selectedItems.add(selectedItem);
        }
      }
    });
  }

  Widget getAppBar(setState){
    if(_selectedItems.length > 0){
      return SelectItemsBar(
        itemsCount: _selectedItems.length,
        onConfirm: () => {
          widget.onConfirmSelectedItems(_selectedItems),
          Navigator.pop(context)
        },
        onCancel:  () => {
          setState(() {
            _selectedItems.forEach((item) {
              item.selectedQuantite = -1.0;
            });
            _selectedItems = new List<Object>();
          })
        },
      );
    } else{
      return SearchBar(
        searchController: searchController,
        mainContext: widget.onConfirmSelectedItems != null? null : context,
        title: S.of(context).articles,
        isFilterOn: isFilterOn,
        onSearchChanged: (String search) => _dataSource.updateSearchTerm(search),
        onFilterPressed: () async {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return addFilterdialogue();
              });
        },
      );
    }
  }

  Future<Widget> futureInitState() async {

    _marqueItems = await _dataSource.queryCtr.getAllArticleMarques();
    _familleItems = await _dataSource.queryCtr.getAllArticleFamilles();

    _marqueDropdownItems = utils.buildMarqueDropDownMenuItems(_marqueItems);
    _familleDropdownItems = utils.buildDropFamilleArticle(_familleItems);

    _selectedMarque = _marqueItems[_savedSelectedMarque];
    _selectedFamille = _familleItems[_savedSelectedFamille];
    _filterInStock = _savedFilterInStock;

    final tile = StatefulBuilder(builder: (context, StateSetter _setState) {
      return Builder(
        builder: (context) => Column(
          children: [
            new ListTile(
              title: new Text('Marque'),
              trailing: marquesDropDown(_setState),
            ),
            new ListTile(
              title: new Text('Famille'),
              trailing: famillesDropDown(_setState),
            ),
            stockCheckBox(_setState)
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
                      _savedSelectedMarque = _marqueItems.indexOf(_selectedMarque);
                      _savedSelectedFamille = _familleItems.indexOf(_selectedFamille);
                      _savedFilterInStock = _filterInStock;

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
                    "Filter",
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

  Future scanBarCode() async {
    try {
      var options = ScanOptions(
        strings: {
          "cancel": "Cancel",
          "flash_on": "Flash on",
          "flash_off": "Flash off",
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
          result.rawContent = 'The user did not grant the camera permission!';
        });
      } else {
        result.rawContent = 'Unknown error: $e';
      }
      Helpers.showToast(result.rawContent);
    }
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
      title: Text("In stock"),
      value: _filterInStock,
      onChanged: (bool value){
        _setState(() {
          _filterInStock = value;
        });
      },
    );
  }

  void fillFilter(Map<String, dynamic> filter) {
    filter["Id_Marque"] = _savedSelectedMarque;
    filter["Id_Famille"] = _savedSelectedFamille;
    filter["inStock"] = _savedFilterInStock;
  }

}
