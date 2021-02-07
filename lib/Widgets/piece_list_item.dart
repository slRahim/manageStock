import 'dart:ui';
import 'package:awesome_dialog/awesome_dialog.dart';
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
import 'package:url_launcher/url_launcher.dart';

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
          leading: CircleAvatar(
            radius: 28,
            backgroundColor: Colors.green,
            child: CircleAvatar(
              child: Text(getPiecetype()),
              radius:25,
              backgroundColor: Colors.grey[200],
              foregroundColor: Colors.black,
            ),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(Icons.access_time,
                size: SizeConfig.safeBlockHorizontal * 4,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "${Helpers.dateToText(widget.piece.date)}",
                style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 4.7,
                    color: Colors.white70),
              ),
            ],
          ),
          title:(widget.piece.raisonSociale != null)
              ? Row(
                  children: [
                    Icon(Icons.person_sharp , color: Colors.white,size: SizeConfig.safeBlockHorizontal * 5),
                    SizedBox(
                      width: 10,
                    ),
                    Text("${widget.piece.raisonSociale}" ,
                      style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4.5,
                            color: Colors.white)
                    )
                  ],
              )
              : null,
          trailingChildren: [
            Text(
             "${S.current.n}: ${widget.piece.num_piece}",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0),
            ),
            Text(
              "${S.current.regler}: ${Helpers.numberFormat(widget.piece.regler)} (${S.current.da})",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0),
            ),
            (widget.piece.net_a_payer < 0)
                ? Text("${Helpers.numberFormat(widget.piece.net_a_payer * -1).toString() } (${S.current.da})",
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold ,
                  color: (widget.piece.reste < 0)?Colors.redAccent : Colors.black ),
            )
                : Text('${Helpers.numberFormat(widget.piece.net_a_payer).toString()} (${S.current.da})',
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
                      text:"${Helpers.numberFormat(widget.piece.reste)} (${S.current.da})",
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
                    text: "${S.current.marge} : ",
                    style: TextStyle(fontSize: 15 , fontWeight: FontWeight.bold,color: Colors.green)
                  ),
                  TextSpan(
                    text:"${Helpers.numberFormat(widget.piece.marge)} (${S.current.da})",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0),
                  ),
                ]
              ),
            ),
            Text(
                (widget.piece.transformer == 1)? "${S.current.msg_piece_transfo}":"${S.current.msg_piece_origin}",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0),
            ),
          ],
        ),
        actions: <Widget>[
          IconSlideAction(
              color: Colors.white10,
              iconWidget: Icon(Icons.delete_forever,size: 50, color: Colors.red,),
              onTap: () async {
                 dellDialog(context);
              }
          ),
        ],
        secondaryActions: [
          IconSlideAction(
            color: Colors.white10,
            iconWidget: Icon(Icons.phone_enabled,size: 50, color: Colors.green,),
            onTap: () async{
              await _makePhoneCall("tel:${widget.piece.mobileTier}");
            },
            foregroundColor: Colors.green,
          ),
        ],
      ),
    );
  }

  String getPiecetype(){
    switch(widget.piece.piece){
      case "FP":
        return S.current.fp;
        break ;
      case "CC":
        return S.current.cc;
        break ;
      case "BL":
        return S.current.bl;
        break ;
      case "FC":
        return S.current.fc;
        break ;
      case "RC":
        return S.current.rc;
        break ;
      case "AC":
        return S.current.ac;
        break ;
      case "BC":
        return S.current.bc;
        break ;
      case "BR":
        return S.current.br;
        break ;
      case "FF":
        return S.current.ff;
        break ;
      case "RF":
        return S.current.rf;
        break ;
      case "AF":
        return S.current.af;
        break ;
    }
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

  Future<void> _makePhoneCall(String phone) async {
    if (await canLaunch(phone)) {
      await launch(phone);
    } else {
      throw 'Could not launch $phone';
    }
  }

  Widget dellDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      animType: AnimType.BOTTOMSLIDE,
      title: S.current.supp,
      desc: '${S.current.msg_supp} ... ',
      closeIcon: Icon(Icons.remove_circle_outline_sharp , color: Colors.red,size: 26,),
      showCloseIcon: true,
      btnCancelText: S.current.sans_tresorie,
      btnCancelOnPress: () async{
        int res = await _queryCtr.removeItemFromTable(DbTablesNames.pieces, widget.piece);
        var message = "" ;
        if(res > 0){
          message =S.current.msg_supp_ok;
          _confirmDell =true ;
        }else{
          message =S.current.msg_ereure;
        }
        Helpers.showFlushBar(context, message);
        if(_confirmDell){
          setState(() {
            _visible = false ;
          });
        }

      },
      btnOkText: S.current.avec_tresorie,
      btnOkOnPress: () async{
        int res = await _queryCtr.removeItemWithForeignKey (DbTablesNames.tresorie , widget.piece.id , "Piece_id");
        var message = "" ;
        if(res > 0){
          int res1 = await _queryCtr.removeItemFromTable(DbTablesNames.pieces, widget.piece);
          if(res > 0){
            message =S.current.msg_supp_ok;
            _confirmDell =true ;

          }else{
            message =S.current.msg_ereure;
          }
        }else{
          message =S.current.msg_err_tresorie;
        }

        Helpers.showFlushBar(context, message);
        if(_confirmDell){
          setState(() {
            _visible = false ;
          });
        }
      },
    )..show();
  }


}

