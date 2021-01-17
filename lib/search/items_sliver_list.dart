
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/Widgets/article_list_item.dart';
import 'package:gestmob/Widgets/piece_list_item.dart';
import 'package:gestmob/Widgets/tier_list_item.dart';
import 'package:gestmob/Widgets/tresorie_list_item.dart';
import 'package:gestmob/models/Article.dart';
import 'package:gestmob/models/Journaux.dart';
import 'package:gestmob/models/Piece.dart';
import 'package:gestmob/models/Tiers.dart';
import 'package:gestmob/models/Tresorie.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'search_input_sliver.dart';
import 'sliver_list_data_source.dart';

class ItemsSliverList extends StatefulWidget {
  final SliverListDataSource dataSource;
  final Function(Object) onItemSelected;
  final bool canRefresh;
  final int tarification ;

  ItemsSliverList({Key key, @required this.dataSource, this.onItemSelected, this.canRefresh , this.tarification,}) : super(key: key);

  @override
  _ItemsSliverListState createState() => _ItemsSliverListState();
}

class _ItemsSliverListState extends State<ItemsSliverList> {
  @override
  Widget build(BuildContext context) {
    return (widget.canRefresh == null || widget.canRefresh)? RefreshIndicator(
        onRefresh: () => Future.sync(
          widget.dataSource.refresh,
        ),
        child: scrollView()
    ) : scrollView();
  }

  Widget scrollView(){
    return new CustomScrollView(
      slivers: <Widget>[
        PagedSliverList<int, Object>(
          dataSource: widget.dataSource,
          builderDelegate: PagedChildBuilderDelegate<Object>(
              itemBuilder: (context, _item, index) => createItemWidget(_item)
          ),
        ),
      ],
    );
  }

  Widget createItemWidget(item){
    if(item is Article){
      return ArticleListItem(article: item, onItemSelected: widget.onItemSelected,tarification: widget.tarification,);
    } else if(item is Tiers){
      item.originClientOrFourn = widget.dataSource.listType == ItemsListTypes.clientsList? 0 : 2;
      return TierListItem(tier: item, onItemSelected: widget.onItemSelected,);
    } else if(item is Piece){
      return PieceListItem(piece: item , onItemSelected: widget.onItemSelected,);
    }else if (item is Tresorie){
      return TresorieListItem(tresorie : item);
    } else{
      return null;
    }
  }

  @override
  void dispose() {
    widget.dataSource.dispose();
    super.dispose();
  }
}
