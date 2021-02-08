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
  final int tierId ;

  final Function(dynamic) onConfirmSelectedItem;

  const PiecesFragment ({Key key, this.clientFourn , this.peaceType,this.tierId,this.onConfirmSelectedItem}): super(key: key);

  @override
  _PiecesFragmentState createState() => _PiecesFragmentState();
}

class _PiecesFragmentState extends State<PiecesFragment> {
  bool isFilterOn = false;
  final TextEditingController searchController = new TextEditingController();

  var _filterMap = new Map<String, dynamic>();
  var _emptyFilterMap = new Map<String, dynamic>();
  var _tier_id ;

  bool _filterInHasCredit = false;
  bool _savedFilterHasCredit = false;

  bool _filterIsDraft = false;
  bool _savedFilterIsDraft = false;

  SliverListDataSource _dataSource;

  @override
  Future<void> initState() {
    super.initState();
    _tier_id = widget.tierId ;
    fillFilter(_filterMap);
    fillFilter(_emptyFilterMap);
    _dataSource = SliverListDataSource(ItemsListTypes.pieceList, _filterMap);
  }

  //***************************************************partie speciale pour le filtre de recherche***************************************
  void fillFilter(Map<String, dynamic> filter) {
    filter["Piece"] = widget.peaceType ;
    filter["Mov"] = 0;
    filter["Credit"] = _savedFilterHasCredit ;
    filter["Draft"] = _savedFilterIsDraft ;
    filter["Tierid"] = _tier_id ;
  }

  Future<Widget> futureInitState() async {
    _filterInHasCredit = _savedFilterHasCredit;
    _filterIsDraft = _savedFilterIsDraft ;

    final tile = StatefulBuilder(builder: (context, StateSetter _setState) {
      return Builder(
        builder: (context) => Column(
          children: [
            isDraftCheckBox(_setState),
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
            return snapshot.data;
          }
        });
  }

  Widget isDraftCheckBox(StateSetter _setState) {
    return CheckboxListTile(
      title: Text(S.current.aff_draft),
      value: _filterIsDraft,
      onChanged: (bool value){
        _setState(() {
          _filterIsDraft = value;
        });
      },
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

  //**************************************************************************************************************************************
  //********************************************listing des pieces**********************************************************************
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
          onPressed: () {
             Navigator.of(context).pushNamed(RoutesKeys.addPiece, arguments: new Piece.typePiece(widget.peaceType))
                 .then((value){
               _dataSource.refresh();
             });
          },
          child: Icon(Icons.add),
        ),
        appBar: SearchBar(
          searchController: searchController,
          mainContext: context,
          title: (widget.peaceType !=null) ? Helpers.getPieceTitle(widget.peaceType) : S.current.piece_titre,
          isFilterOn: isFilterOn,
          onSearchChanged: (String search) => _dataSource.updateSearchTerm(search),
          onFilterPressed: () async {
            if(widget.tierId != null){
              var message = S.current.filtre_non_dispo;
              Helpers.showFlushBar(context, message);
            }else{
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
                      _savedFilterIsDraft = _filterIsDraft ;
                      _savedFilterHasCredit = _filterInHasCredit;

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
            }
          },
        ),
        body: ItemsSliverList(
            dataSource: _dataSource,
            onItemSelected: (widget.onConfirmSelectedItem != null ) ? (selectedItem) {
              widget.onConfirmSelectedItem(selectedItem);
              Navigator.pop(context);
            } : null
        )
    );
  }


}
