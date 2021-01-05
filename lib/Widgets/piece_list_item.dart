import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/Article.dart';
import 'package:gestmob/models/Piece.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sliding_card/sliding_card.dart';

import 'CustomWidgets/list_tile_card.dart';

// element à afficher lors de listing des factures
class PieceListItem extends StatefulWidget {

 PieceListItem({
    @required this.piece,
    Key key, this.onItemSelected ,
  })  : assert(piece != null),
        super(key: key);

  final Piece piece;
  final Function(Object) onItemSelected;

  @override
  _PieceListItemState createState() => _PieceListItemState();
}

class _PieceListItemState extends State<PieceListItem> {

  QueryCtr _queryCtr = new QueryCtr() ;
  bool _confirmDell = false ;
  bool _visible = true ;
  SlidingCardController controller ;

  @override
  void initState() {
    super.initState();
    controller = SlidingCardController();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Visibility(
      visible: _visible,
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: ListTileCard(
          from: widget.piece,
          onLongPress:  () => widget.onItemSelected != null? widget.onItemSelected(widget.piece) : null,
          onTap: () => {
            if(widget.onItemSelected == null){
              Navigator.of(context).pushNamed(RoutesKeys.addPiece, arguments: widget.piece)
            }
          },
          slidingCardController: controller,
          onCardTapped: () {
            if(controller.isCardSeparated == true) {
              controller.collapseCard();
            } else {
              controller.expandCard();
            }
          },
          leading: Container(
            child: CircleAvatar(
              child: Text("${widget.piece.piece}"),
              radius: 30,
              backgroundColor: Colors.grey[200],
              foregroundColor: Colors.black,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                width: 2,
                color: Colors.green,
              ),
              color: Colors.grey[100],
            ),
          ),
          subtitle: Helpers.dateToText(widget.piece.date),
          title:(widget.piece.raisonSociale != null) ? ("RS: " + widget.piece.raisonSociale) : null,
          trailingChildren: [
            Text(
             "N°: ${widget.piece.num_piece}",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0),
            ),
            Text(
              "${S.current.regler}: ${widget.piece.regler} ${S.current.da}",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0),
            ),
            (widget.piece.total_ttc < 0)
                ? Text('${S.current.prix} : '+(widget.piece.total_ttc * -1).toString()+" ${S.current.da}",
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold ,
                  color: (widget.piece.reste < 0)?Colors.redAccent : Colors.black ),
            )
                : Text('${S.current.prix}  : '+(widget.piece.total_ttc).toString()+" ${S.current.da}",
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold ,
                  color: (widget.piece.reste > 0)?Colors.redAccent : Colors.black ),
            ) ,
            getIcon(),
            RichText(
              text: TextSpan(
                  children: [
                    TextSpan(
                        text: "${S.current.reste} : ",
                        style: TextStyle(fontSize: 15 , fontWeight: FontWeight.bold,color: Colors.red)
                    ),
                    TextSpan(
                      text:"${widget.piece.reste} ${S.current.da}",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0),
                    ),
                  ]
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Marge : ",
                    style: TextStyle(fontSize: 15 , fontWeight: FontWeight.bold,color: Colors.green)
                  ),
                  TextSpan(
                    text:"${widget.piece.marge} ${S.current.da}",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0),
                  ),
                ]
              ),
            ),
            Text(
                (widget.piece.transformer == 1)? "C'est une piece transformer":"C'est une piece d'origine",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0),
            ),
          ],
        ),
        actions: <Widget>[
          IconSlideAction(
              color: Theme.of(context).backgroundColor,
              iconWidget: Icon(Icons.delete_forever,size: 50, color: Colors.red,),
              onTap: () async {
                await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return dellDialog(context);
                    }).then((value){
                  if(_confirmDell){
                    setState(() {
                      _visible = false ;
                    });
                  }
                });

              }
          ),
        ],
      ),
    );
  }


  Widget getIcon() {
    switch (widget.piece.mov){
      case 1 :
        return Icon(Icons.check_circle , color: Colors.blue,size: 26,);
        break;
      case 2 :
        return Icon(Icons.broken_image , color: Colors.black45,size: 26,);
        break;
      case 0 :
        return Icon(Icons.check_circle_outline , color: Colors.black45,size: 26,);
        break;
    }
  }

  Widget dellDialog(BuildContext context) {
    return AlertDialog(
      title:  Text(S.current.supp),
      content: Text(S.current.msg_supp),
      actions: [
        FlatButton(
          child: Text(S.current.non),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text(S.current.sans_tresorie),
          onPressed: ()async{
            int res = await _queryCtr.removeItemFromTable(DbTablesNames.pieces, widget.piece);
            var message = "" ;
            if(res > 0){
               message =S.current.msg_supp_ok;
              _confirmDell =true ;
               Navigator.pop(context);
            }else{
              message =S.current.msg_ereure;
              Navigator.pop(context);
            }
            Helpers.showFlushBar(context, message);
          },
        ),
        FlatButton(
          child: Text(S.current.avec_tresorie),
          onPressed: ()async{
            int res = await _queryCtr.removeItemWithForeignKey (DbTablesNames.tresorie , widget.piece.id , "Piece_id");
            var message = "" ;
            if(res > 0){
              int res1 = await _queryCtr.removeItemFromTable(DbTablesNames.pieces, widget.piece);
              if(res > 0){
                message =S.current.msg_supp_ok;
                _confirmDell =true ;

                Navigator.pop(context);
              }else{
                message =S.current.msg_ereure;
                Navigator.pop(context);
              }
            }else{
              message =S.current.msg_err_tresorie;
              Navigator.pop(context);
            }

            Helpers.showFlushBar(context, message);
          },
        ),
      ],
    );
  }
}

