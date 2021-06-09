import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gestmob/models/ArticleTva.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:gestmob/models/ArticleFamille.dart';
import 'package:gestmob/models/ArticleMarque.dart';
import 'package:gestmob/models/ArticleTva.dart';
import 'package:gestmob/models/ChargeTresorie.dart';
import 'package:gestmob/models/TiersFamille.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/Helpers/Helpers.dart';

class CategoryListItem extends StatefulWidget {
  final dynamic item;
  CategoryListItem({Key key, this.item}) : super(key: key);

  @override
  _CategoryListItemState createState() => _CategoryListItemState();
}

class _CategoryListItemState extends State<CategoryListItem> {
    final QueryCtr _queryCtr = new QueryCtr();
  bool _visible = true ;

  @override
  Widget build(BuildContext context) {
    if (widget.item is ArticleTva) {
      return Visibility(
        visible: _visible,
        child: Card(
          elevation: 1,
          color: Theme.of(context).selectedRowColor,
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).selectedRowColor,
                borderRadius: BorderRadius.circular(5)),
            padding: EdgeInsets.all(2),
            child: ListTile(
                title: Text(
                  "${S.current.tva} ${widget.item.tva}%",
                  style:
                      GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                leading: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                ),
                trailing: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                )),
          ),
        ),
      );
    }
    return Visibility(
      visible: _visible,
      child: Card(
        elevation: 1,
        color: Theme.of(context).selectedRowColor,
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).selectedRowColor,
              borderRadius: BorderRadius.circular(5)),
          padding: EdgeInsets.all(2),
          child: ListTile(
              title: Text(
                widget.item.libelle,
                style:
                    GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              leading: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.edit,
                  color: Colors.blue,
                ),
              ),
              trailing: IconButton(
                onPressed: () => dellDialog(context),
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              )),
        ),
      ),
    );
  }

  Widget dellDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.QUESTION,
      animType: AnimType.BOTTOMSLIDE,
      title: S.current.supp,
      desc: '${S.current.msg_supp} ... ',
      btnCancelText: S.current.non,
      btnCancelOnPress: () {},
      btnOkText: S.current.oui,
      btnOkOnPress: () async {
        var res =0;
        if (widget.item is ArticleFamille) {
          res = await _queryCtr.removeItemFromTable(DbTablesNames.articlesFamilles, widget.item);
        } else if (widget.item is ArticleMarque) {
          res = await _queryCtr.removeItemFromTable(DbTablesNames.articlesMarques, widget.item);
        } else if (widget.item is TiersFamille) {
          res = await _queryCtr.removeItemFromTable(DbTablesNames.tiersFamille, widget.item);
        } else if (widget.item is ChargeTresorie) {
          res = await _queryCtr.removeItemFromTable(DbTablesNames.chargeTresorie, widget.item);
        } else if (widget.item is ArticleTva) {
          res = await _queryCtr.removeItemFromTable(DbTablesNames.articlesTva, widget.item);
        }

        var message = "";
        if (res > 0) {
          message = S.current.msg_supp_ok;
          setState(() {
            _visible = false;
          });
        } else {
          message = S.current.msg_ereure;
        }
        Helpers.showFlushBar(context, message);

      },
    )..show();
  }
}



