import 'package:barcode_scan/barcode_scan.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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

class JournalFragment extends StatefulWidget {
  final Function(List<dynamic>) onConfirmSelectedItems;
  final Tiers tier ;


  const JournalFragment({Key key, this.onConfirmSelectedItems , this.tier}) : super(key: key);
  @override
  _JournalFragmentState createState() => _JournalFragmentState();
}

class _JournalFragmentState extends State<JournalFragment> {
  bool isFilterOn = false;
  final TextEditingController searchController = new TextEditingController();
  List<dynamic> _selectedItems = new List<Object>();

  var _filterMap = new Map<String, dynamic>();
  var _emptyFilterMap = new Map<String, dynamic>();


  SliverListDataSource _dataSource;

  @override
  Future<void> initState() {
    super.initState();

    fillFilter(_filterMap);
    fillFilter(_emptyFilterMap);
    _dataSource = SliverListDataSource(ItemsListTypes.journalList, _filterMap);
  }

  //***************************************************partie speciale pour le filtre de recherche***************************************

  void fillFilter(Map<String, dynamic> filter) {
    filter["idTier"] = widget.tier;
  }

  //********************************************listing des pieces**********************************************************************
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getAppBar(setState),
        body: ItemsSliverList(
            dataSource: _dataSource,
            canRefresh: _selectedItems.length <= 0,
            onItemSelected: widget.onConfirmSelectedItems != null ? (selectedItem) {
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
              item.selectedQuantite = -1;
            });
            _selectedItems = new List<Object>();
          })
        },
      );
    } else{
      return SearchBar(
        searchController: searchController,
        mainContext: widget.onConfirmSelectedItems != null ? null : context,
        title:"Journaux",
        isFilterOn: isFilterOn,
        onSearchChanged: (String search) => _dataSource.updateSearchTerm(search),
        onFilterPressed: () async {

        },
      );
    }
  }



}
