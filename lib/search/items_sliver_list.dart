import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/Widgets/article_list_item.dart';
import 'package:gestmob/Widgets/categorie_list_item.dart';
import 'package:gestmob/Widgets/piece_list_item.dart';
import 'package:gestmob/Widgets/tier_list_item.dart';
import 'package:gestmob/Widgets/tresorie_list_item.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/Article.dart';
import 'package:gestmob/models/ArticleFamille.dart';
import 'package:gestmob/models/ArticleMarque.dart';
import 'package:gestmob/models/ArticleTva.dart';
import 'package:gestmob/models/ChargeTresorie.dart';
import 'package:gestmob/models/Piece.dart';
import 'package:gestmob/models/Tiers.dart';
import 'package:gestmob/models/TiersFamille.dart';
import 'package:gestmob/models/Tresorie.dart';
import 'package:gestmob/models/CompteTresorie.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'sliver_list_data_source.dart';

class ItemsSliverList extends StatefulWidget {
  final SliverListDataSource dataSource;
  final Function(Object) onItemSelected;
  final bool canRefresh;
  final int tarification;

  final String pieceOrigin;
  final List<dynamic> articleOriginalList ;

  ItemsSliverList(
      {Key key,
      @required this.dataSource,
      this.onItemSelected,
      this.canRefresh,
      this.tarification,
      this.pieceOrigin ,
      this.articleOriginalList})
      : super(key: key);

  @override
  _ItemsSliverListState createState() => _ItemsSliverListState();
}

class _ItemsSliverListState extends State<ItemsSliverList> {
  @override
  Widget build(BuildContext context) {
    return (widget.canRefresh == null || widget.canRefresh)
        ? RefreshIndicator(
            onRefresh: () => Future.sync(
                  widget.dataSource.refresh,
                ),
            child: scrollView())
        : scrollView();
  }

  Widget scrollView() {
    return new CustomScrollView(
      slivers: <Widget>[
        PagedSliverList<int, Object>(
          dataSource: widget.dataSource,
          builderDelegate: PagedChildBuilderDelegate<Object>(
              noItemsFoundIndicatorBuilder: (context) {
                return Center(
                    child: Container(
                        padding: EdgeInsets.only(top: 100, bottom: 100),
                        child: Column(
                          children: [
                            Text(
                              S.current.no_element,
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              S.current.liste_vide,
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        )));
              },
              itemBuilder: (context, _item, index) => createItemWidget(_item)),
        ),
      ],
    );
  }

  Widget createItemWidget(item) {
    if (item is Article) {
      return ArticleListItem(
        article: item,
        onItemSelected: widget.onItemSelected,
        tarification: widget.tarification,
        pieceOrigin: widget.pieceOrigin,
        alreadySelected:(widget.articleOriginalList.isNotEmpty)? widget.articleOriginalList.where((element) => element.id == item.id ).isNotEmpty : null,
      );
    } else if (item is Tiers) {
      // item.originClientOrFourn =
      //     widget.dataSource.listType == ItemsListTypes.clientsList ? 0 : 2;
      return TierListItem(
        tier: item,
        onItemSelected: widget.onItemSelected,
      );
    } else if (item is Piece) {
      return PieceListItem(
        piece: item,
        onItemSelected: widget.onItemSelected,
      );
    } else if (item is Tresorie) {
      return TresorieListItem(
        tresorie: item,
      );
    } else if (item is ArticleFamille ||
        item is ArticleMarque ||
        item is TiersFamille ||
        item is ChargeTresorie ||
        item is ArticleTva ||
    item is CompteTresorie) {
      return CategoryListItem(
        item: item,
      );
    } else {
      return null;
    }
  }

// @override
// void dispose() {
//   widget.dataSource.dispose();
//   super.dispose();
// }
}
