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
import 'package:gestmob/models/Piece.dart';
import 'package:gestmob/search/items_sliver_list.dart';
import 'package:gestmob/search/search_input_sliver.dart';
import 'package:gestmob/search/sliver_list_data_source.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:gestmob/Widgets/utils.dart' as utils;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'AddArticlePage.dart';

class PiecesFragment extends StatefulWidget {
  final int clientFourn;
  final String peaceType ;
  const PiecesFragment ({Key key, this.clientFourn , this.peaceType}): super(key: key);

  @override
  _PiecesFragmentState createState() => _PiecesFragmentState();
}

class _PiecesFragmentState extends State<PiecesFragment> {
  bool isSearching = false;
  bool isFilterOn = false;

  var _filterMap = new Map<String, dynamic>();
  var _emptyFilterMap = new Map<String, dynamic>();

  List<Object> _familleItems;
  List<DropdownMenuItem<Object>> _familleDropdownItems;
  var _selectedFamille;
  int _savedSelectedFamille = 0;

  bool _filterInHasCredit = false;
  bool _savedFilterHasCredit = false;

  SliverListDataSource _dataSource;

  @override
  Future<void> initState() {
    super.initState();

    fillFilter(_filterMap);
    fillFilter(_emptyFilterMap);
    _dataSource = SliverListDataSource(ItemsListTypes.devisList, _filterMap);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
             Navigator.of(context).pushNamed(RoutesKeys.addPiece, arguments: new Piece.typePiece("FP"));
          },
          child: Icon(Icons.add),
        ),
        appBar: SearchBar(
          mainContext: context,
          title: "Devis",
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
        body: ItemsSliverList(dataSource: _dataSource));
  }

  Future<Widget> futureInitState() async {
    _familleItems = await _dataSource.queryCtr.getAllArticleFamilles();
    _familleDropdownItems = utils.buildDropFamilleArticle(_familleItems);
    _selectedFamille = _familleItems[_savedSelectedFamille];

    _filterInHasCredit = _savedFilterHasCredit;

    final tile = StatefulBuilder(builder: (context, StateSetter _setState) {
      return Builder(
        builder: (context) => Column(
          children: [
            /*new ListTile(
              title: new Text('Marque'),
              trailing: marquesDropDown(_setState),
            ),*/
            new ListTile(
              title: new Text('Famille'),
              trailing: famillesDropDown(_setState),
            ),
            hasCreditCheckBox(_setState)
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
                      // _savedSelectedMarque = _marqueItems.indexOf(_selectedMarque);
                      _savedSelectedFamille = _familleItems.indexOf(_selectedFamille);
                      _savedFilterHasCredit = _filterInHasCredit;

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

  Widget hasCreditCheckBox(StateSetter _setState) {
    return CheckboxListTile(
      title: Text("Has credit"),
      value: _filterInHasCredit,
      onChanged: (bool value){
        _setState(() {
          _filterInHasCredit = value;
        });
      },
    );
  }

  void fillFilter(Map<String, dynamic> filter) {
    filter["Piece"] = widget.peaceType ;
    filter["Mov"] = 0;
  }

}
