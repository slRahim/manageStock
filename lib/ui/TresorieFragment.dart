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
import 'package:gestmob/models/Tresorie.dart';
import 'package:gestmob/models/TresorieCategories.dart';
import 'package:gestmob/search/items_sliver_list.dart';
import 'package:gestmob/search/search_input_sliver.dart';
import 'package:gestmob/search/sliver_list_data_source.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:gestmob/Widgets/utils.dart' as utils;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'AddArticlePage.dart';

class TresorieFragment extends StatefulWidget {

  @override
  _TresorieFragmentState createState() => _TresorieFragmentState();
}

class _TresorieFragmentState extends State<TresorieFragment> {
  bool isFilterOn = false;
  final TextEditingController searchController = new TextEditingController();

  var _filterMap = new Map<String, dynamic>();
  var _emptyFilterMap = new Map<String, dynamic>();

  List<TresorieCategories> _categorieItems;
  List<DropdownMenuItem<TresorieCategories>> _categorieDropdownItems;
  TresorieCategories  _selectedCategorie=null;
  int _savedSelectedCategorie = 0;

  SliverListDataSource _dataSource;

  @override
  Future<void> initState() {
    super.initState();
    _dataSource = SliverListDataSource(ItemsListTypes.tresorieList, _filterMap);
  }

  //***************************************************partie speciale pour le filtre de recherche***************************************
  void fillFilter(Map<String, dynamic> filter) {
    filter["Categorie"] = _selectedCategorie.id ;
  }

  Future<Widget> futureInitState() async {
    _categorieItems = await _dataSource.queryCtr.getAllTresorieCategorie();
    _categorieDropdownItems= utils.buildDropTresorieCategoriesDownMenuItems(_categorieItems);
    _selectedCategorie = _categorieItems[_savedSelectedCategorie];

    final tile = StatefulBuilder(builder: (context, StateSetter _setState) {
      return Builder(
        builder: (context) => Column(
          children: [
            new ListTile(
              trailing: categorieDropDown(_setState),
            ),

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
                      _savedSelectedCategorie = _categorieItems.indexOf(_selectedCategorie) ;
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

  Widget categorieDropDown(StateSetter _setState) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<TresorieCategories>(
          value: _selectedCategorie,
          items: _categorieDropdownItems,
          onChanged: (value) {
            _setState(() {
              _selectedCategorie = value;
            });
          }),
    );
  }


  //********************************************listing des pieces**********************************************************************
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(RoutesKeys.addTresorie, arguments: new Tresorie.init());
          },
          child: Icon(Icons.add),
        ),
        appBar: SearchBar(
          searchController: searchController,
          mainContext: context,
          title: "Tresorie",
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
        )
    );
  }





}
