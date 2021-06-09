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
import 'package:gestmob/models/ArticleFamille.dart';
import 'package:gestmob/models/ArticleMarque.dart';
import 'package:gestmob/models/ArticleTva.dart';
import 'package:gestmob/models/ChargeTresorie.dart';
import 'package:gestmob/models/Journaux.dart';
import 'package:gestmob/models/Piece.dart';
import 'package:gestmob/models/Tiers.dart';
import 'package:gestmob/models/TiersFamille.dart';
import 'package:gestmob/models/Tresorie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:gestmob/Widgets/categorie_list_item.dart';
import 'search_input_sliver.dart';
import 'sliver_list_data_source.dart';
import 'package:gestmob/generated/l10n.dart';

class ItemsSliverList extends StatefulWidget {
  final SliverListDataSource dataSource;
  final Function(Object) onItemSelected;
  final bool canRefresh;
  final int tarification;

  final String pieceOrigin;

  ItemsSliverList(
      {Key key,
      @required this.dataSource,
      this.onItemSelected,
      this.canRefresh,
      this.tarification,
      this.pieceOrigin})
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
        dataSource: widget.dataSource,
      );
    } else if (item is Tiers) {
      item.originClientOrFourn =
          widget.dataSource.listType == ItemsListTypes.clientsList ? 0 : 2;
      return TierListItem(
        tier: item,
        onItemSelected: widget.onItemSelected,
        dataSource: widget.dataSource,
      );
    } else if (item is Piece) {
      return PieceListItem(
        piece: item,
        onItemSelected: widget.onItemSelected,
        dataSource: widget.dataSource,
      );
    } else if (item is Tresorie) {
      return TresorieListItem(
        tresorie: item,
        dataSource: widget.dataSource,
      );
    } else if (item is ArticleFamille ||
        item is ArticleMarque ||
        item is TiersFamille ||
        item is ChargeTresorie ||
        item is ArticleTva) {
      return CategoryListItem(item: item);
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
