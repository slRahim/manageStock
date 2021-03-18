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
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sliding_card/sliding_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'CustomWidgets/list_tile_card.dart';
import 'package:gestmob/services/push_notifications.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/scheduler.dart';

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
  String _devise ;
  String feature5 = 'feature5';

  @override
  void initState() {
    super.initState();
    controller = SlidingCardController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    PushNotificationsManagerState data = PushNotificationsManager.of(context);
    _devise = Helpers.getDeviseTranslate(data.myParams.devise) ;
  }




  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Visibility(
        visible: _visible,
        child: DescribedFeatureOverlay(
          featureId: feature5,
          tapTarget: Icon(MdiIcons.arrowSplitVertical , color: Colors.black,),
          backgroundColor: Colors.red,
          contentLocation: ContentLocation.below,
          title: Text(S.current.swipe),
          description: Container(width:150,child: Text(S.current.msg_swipe_lr)),
          onBackgroundTap: () async{
            await FeatureDiscovery.completeCurrentStep(context);
            return true ;
          },
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
                radius: 25,
                backgroundColor: getColor(),
                child: CircleAvatar(
                  child: Text(getPiecetype()),
                  radius:23,
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black,
                ),
              ),
              title:(widget.piece.raisonSociale != null)
                  ?SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Text("(# : ${widget.piece.num_piece}) ${widget.piece.raisonSociale}" ,
                            style: TextStyle(
                                  fontSize: 14,)
                          ),
                      ],
                    ),
                  )
                  : null,
              trailingChildren: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.date_range,
                      size: 14,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Text(
                      "${Helpers.dateToText(widget.piece.date)}",
                      style: TextStyle(
                          fontSize: 14 , color: Theme.of(context).primaryColorDark),
                    ),
                  ],
                ),
                (widget.piece.net_a_payer < 0)
                    ? Row(
                      children: [
                        Icon(MdiIcons.sigma,
                          size: 16,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text("${Helpers.numberFormat(widget.piece.net_a_payer * -1).toString() } ${_devise}",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold ,
                            color:Theme.of(context).primaryColorDark ),
                        ),
                      ],
                    )
                    : Row(
                      children: [
                        Icon(MdiIcons.sigma,
                          size: 16,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text('${Helpers.numberFormat(widget.piece.net_a_payer).toString()} ${_devise}',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold ,
                            color: Theme.of(context).primaryColorDark ),
                        ),
                      ],
                    ) ,
                RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(
                            text: "${S.current.regler} : ",
                            style: TextStyle(fontSize: 14 , fontWeight: FontWeight.bold,color: Colors.blue)
                        ),
                        TextSpan(
                          text:"${Helpers.numberFormat(widget.piece.regler)} ${_devise}",
                          style: TextStyle(
                              color: Theme.of(context).primaryColorDark,
                              fontSize: 14),
                        ),
                      ]
                  ),
                ),
                RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(
                            text: "${S.current.reste} : ",
                            style: TextStyle(fontSize: 14 , fontWeight: FontWeight.bold,color: Colors.redAccent)
                        ),
                        TextSpan(
                          text:"${Helpers.numberFormat(widget.piece.reste)} ${_devise}",
                          style: TextStyle(
                              color: Theme.of(context).primaryColorDark,
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
                        style: TextStyle(fontSize: 14 , fontWeight: FontWeight.bold,color: Colors.green)
                      ),
                      TextSpan(
                        text:"${Helpers.numberFormat(widget.piece.marge)} ${_devise}",
                        style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: 14.0),
                      ),
                    ]
                  ),
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

  Color getColor() {
    if(widget.piece.piece == "FP"){
      if(widget.piece.etat == 1){
        return Colors.green ;
      }else{
        switch (widget.piece.mov){
          case 2 :
            return Colors.black26;
            break;
          case 0 :
            return Colors.red;
            break;
        }
      }
    }else{
      switch (widget.piece.mov){
        case 1 :
          if(widget.piece.reste > 0){
            return Colors.red;
          }else{
            return Colors.green;
          }
          break;
        case 2 :
          return Colors.black26;
          break;
        case 0 :
          return Colors.yellow[700];
          break;
      }
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
      closeIcon: Icon(Icons.close , color: Colors.red,size: 26,),
      showCloseIcon: true,
      btnCancelText:(widget.piece.piece != PieceType.devis)? S.current.sans_tresorie : S.current.non,
      btnCancelOnPress: () async{
        if(widget.piece.piece != PieceType.devis){
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
        }
      },
      btnOkText:(widget.piece.piece != PieceType.devis)? S.current.avec_tresorie : S.current.oui,
      btnOkOnPress: () async{
        if(widget.piece.piece != PieceType.devis){
          int res = await _queryCtr.removeItemWithForeignKey (DbTablesNames.tresorie , widget.piece.id , "Piece_id");
          var message = "" ;
          if(res < 0){
            message =S.current.msg_err_tresorie;
            Helpers.showFlushBar(context, message);
          }

          int res1 = await _queryCtr.removeItemFromTable(DbTablesNames.pieces, widget.piece);
          if(res1 > 0){
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

          Helpers.showFlushBar(context, message);
          if(_confirmDell){
            setState(() {
              _visible = false ;
            });
          }
        }else{
          //ds le cas d'un devis uniquement
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
        }
      },
    )..show();
  }


}

