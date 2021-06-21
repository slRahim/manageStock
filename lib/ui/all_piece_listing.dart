import 'package:flutter/material.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/Widgets/CustomWidgets/search_bar.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/search/items_sliver_list.dart';
import 'package:gestmob/search/sliver_list_data_source.dart';

class PiecesScreen extends StatefulWidget {
  @override
  _PiecesScreenState createState() => _PiecesScreenState();
}

class _PiecesScreenState extends State<PiecesScreen> {
  final TextEditingController searchController = new TextEditingController();

  var _filterMap = new Map<String, dynamic>();

  SliverListDataSource _dataSource;

  @override
  Future<void> initState() {
    super.initState();

    fillFilter(_filterMap);
    _dataSource = SliverListDataSource(ItemsListTypes.pieceList, _filterMap);
  }

  //***************************************************partie speciale pour le filtre de recherche***************************************
  void fillFilter(Map<String, dynamic> filter) {
    filter["Piece"] = null;
    filter["Mov"] = 1;
    filter["Credit"] = true;
    filter["Draft"] = false;
    filter["Tierid"] = null;
  }

  //**************************************************************************************************************************************
  //********************************************listing des pieces**********************************************************************
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SearchBar(
          searchController: searchController,
          mainContext: context,
          title: S.current.piece_titre,
          onSearchChanged: (String search) =>
              _dataSource.updateSearchTerm(search.trim()),
        ),
        body: ItemsSliverList(
          dataSource: _dataSource,
        ));
  }
}
