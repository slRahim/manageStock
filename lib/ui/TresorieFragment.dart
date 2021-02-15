import 'package:awesome_dialog/awesome_dialog.dart';
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
import 'package:gestmob/services/push_notifications.dart';
import 'package:gestmob/models/MyParams.dart';
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

  TresorieCategories  _selectedCategorie;
  int _savedSelectedCategorie = 0;

  SliverListDataSource _dataSource;
  MyParams _myParams;

  @override
  Future<void> initState() {
    super.initState();

    fillFilter(_filterMap);
    fillFilter(_emptyFilterMap);
    _dataSource = SliverListDataSource(ItemsListTypes.tresorieList, _filterMap);
  }

  @override
  void didChangeDependencies() {
    PushNotificationsManagerState data = PushNotificationsManager.of(context);
    _myParams = data.myParams;
  }

  //***************************************************partie speciale pour le filtre de recherche***************************************
  void fillFilter(Map<String, dynamic> filter) {
    filter["Categorie"] = _savedSelectedCategorie+1 ;
  }

  Future<Widget> futureInitState() async {
    _categorieItems = await _dataSource.queryCtr.getAllTresorieCategorie();

    _categorieItems[0].libelle = S.current.choisir ;
    _categorieItems[1].libelle = S.current.reglemnt_client ;
    _categorieItems[2].libelle = S.current.reglement_fournisseur ;
    _categorieItems[3].libelle = S.current.encaissement ;
    _categorieItems[4].libelle = S.current.charge ;
    _categorieItems[5].libelle = S.current.rembourcement_client ;
    _categorieItems[6].libelle = S.current.rembourcement_four ;
    _categorieItems[7].libelle = S.current.decaissement ;

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
                  )
              ),
            );
          } else {
            return snapshot.data ;

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
          backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
          onPressed: () {
              _addNewTresorie(context);
          },
          child: Icon(Icons.add),
        ),
        appBar: SearchBar(
          searchController: searchController,
          mainContext: context,
          title: S.current.tresorie_titre,
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
                closeIcon: Icon(Icons.remove_circle_outline_sharp , color: Colors.red , size: 26,),
                showCloseIcon: true,
                btnOkOnPress: () async{
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
                }
            )..show();
          },
        ),
        body: ItemsSliverList(
            dataSource: _dataSource,
        )
    );
  }

  _addNewTresorie (context){
    if (_myParams.versionType != "demo" &&
        _myParams.startDate
            .isBefore(Helpers.getDateExpiration(_myParams))) {
      Navigator.of(context).pushNamed(RoutesKeys.addTresorie, arguments: new Tresorie.init())
          .then((value){
        _dataSource.refresh();
      });
    } else {
      if (_myParams.versionType == "demo") {
        if (_myParams.startDate.isBefore(
            _myParams.startDate.add(Duration(days: 30)))) {
          Navigator.of(context).pushNamed(RoutesKeys.addTresorie, arguments: new Tresorie.init())
              .then((value){
            _dataSource.refresh();
          });
        } else {
          var message = "Evaluation period has expired you can't add more items";
          Helpers.showFlushBar(context, message);
          Navigator.pushNamed(context, RoutesKeys.appPurchase);
        }
      } else {
        var message = "Your licence has expired you can't add more items";
        Helpers.showFlushBar(context, message);
        Navigator.pushNamed(context, RoutesKeys.appPurchase);
      }
    }
  }




}
