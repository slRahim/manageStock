import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/Piece.dart';
import 'package:gestmob/services/push_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sliding_card/sliding_card.dart';
import 'package:url_launcher/url_launcher.dart';

import 'CustomWidgets/list_tile_card.dart';

// element à afficher lors de listing des factures
class PieceListItem extends StatefulWidget {
  PieceListItem(
      {@required this.piece,
      Key key,
      this.onItemSelected,
      this.fromTresory})
      : assert(piece != null),
        super(key: key);

  Piece piece;
  final Function(Object) onItemSelected;
  final bool fromTresory;

  @override
  _PieceListItemState createState() => _PieceListItemState();
}

class _PieceListItemState extends State<PieceListItem> {
  QueryCtr _queryCtr = new QueryCtr();
  bool _confirmDell = false;
  bool _visible = true;
  SlidingCardController controller;
  String _devise;
  String feature5 = 'feature5';

  @override
  void initState() {
    super.initState();
    if(widget.piece.piece == PieceType.retourClient ||
        widget.piece.piece == PieceType.avoirClient ||
        widget.piece.piece == PieceType.retourFournisseur ||
        widget.piece.piece == PieceType.avoirFournisseur){

      widget.piece.regler =(widget.piece.regler != 0)? widget.piece.regler *-1 : widget.piece.regler;
      widget.piece.reste = (widget.piece.reste != 0)? widget.piece.reste *-1 : widget.piece.reste;

    }
    controller = SlidingCardController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    PushNotificationsManagerState data = PushNotificationsManager.of(context);
    _devise = Helpers.getDeviseTranslate(data.myParams.devise);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Visibility(
      visible: _visible,
      child: DescribedFeatureOverlay(
        featureId: feature5,
        tapTarget: Icon(
          MdiIcons.arrowSplitVertical,
          color: Colors.black,
        ),
        backgroundColor: Colors.red,
        contentLocation: ContentLocation.below,
        title: Text(
          S.current.swipe,
          style: GoogleFonts.lato(fontWeight: FontWeight.bold),
        ),
        description: Container(width: 150, child: Text(S.current.msg_swipe_lr)),
        onBackgroundTap: () async {
          await FeatureDiscovery.completeCurrentStep(context);
          return true;
        },
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: ListTileCard(
            from: widget.piece,
            onLongPress: () =>
                (widget.onItemSelected != null && widget.fromTresory == null)
                    ? widget.onItemSelected(widget.piece)
                    : null,
            onTap: () => {
              if (widget.fromTresory == null)
                {
                  if (widget.onItemSelected == null)
                    {
                      Navigator.of(context)
                          .pushNamed(RoutesKeys.addPiece,
                              arguments: widget.piece)
                          .then((value) {
                            if(value is Piece){
                              setState(() {
                                widget.piece = value ;
                              });
                            }
                      })
                    }
                  else
                    {widget.onItemSelected(widget.piece)}
                }
            },
            slidingCardController: controller,
            onCardTapped: () {
              if (controller.isCardSeparated == true) {
                controller.collapseCard();
              } else {
                controller.expandCard();
              }
            },
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: getColor(),
              child: CircleAvatar(
                child: Text(
                  getPiecetype(),
                  style: GoogleFonts.lato(),
                ),
                radius: 23,
                backgroundColor: Colors.grey[200],
                foregroundColor: Colors.black,
              ),
            ),
            title: (widget.piece.raisonSociale != '')
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Text(
                            "(# : ${widget.piece.num_piece}) ${widget.piece.raisonSociale}",
                            style: GoogleFonts.lato(
                                textStyle: TextStyle(
                              fontSize: 14,
                            ))),
                      ],
                    ),
                  )
                : null,
            trailingChildren: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.date_range,
                    size: 12,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    "${Helpers.dateToText(widget.piece.date)}",
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).primaryColorDark)),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    MdiIcons.sigma,
                    size: 16,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  (widget.piece.net_a_payer < 0)
                      ? Text(
                          "${Helpers.numberFormat(widget.piece.net_a_payer * -1).toString()} $_devise",
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColorDark)),
                        )
                      : Text(
                          '${Helpers.numberFormat(widget.piece.net_a_payer).toString()} $_devise',
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColorDark)),
                        ),
                ],
              ),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: (widget.piece.piece != PieceType.avoirClient &&
                              widget.piece.piece != PieceType.retourClient &&
                              widget.piece.piece !=
                                  PieceType.avoirFournisseur &&
                              widget.piece.piece != PieceType.retourFournisseur)
                          ? "${S.current.regler} : "
                          : "${S.current.rembourcement} : ",
                      style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue))),
                  TextSpan(
                    text:
                        "${Helpers.numberFormat(widget.piece.regler)} $_devise",
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: 14)),
                  ),
                ]),
              ),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: "${S.current.reste} : ",
                      style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent))),
                  TextSpan(
                    text:
                        "${Helpers.numberFormat(widget.piece.reste)} $_devise",
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: 15.0)),
                  ),
                ]),
              ),
              (widget.piece.piece != PieceType.bonReception &&
                  widget.piece.piece != PieceType.factureFournisseur &&
                  widget.piece.piece != PieceType.bonCommande &&
                  widget.piece.piece != PieceType.retourFournisseur &&
                  widget.piece.piece != PieceType.avoirFournisseur
              ) ? RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: "${S.current.marge} : ",
                      style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.green))),
                  TextSpan(
                    text:
                        "${Helpers.numberFormat(widget.piece.marge)} $_devise",
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: 14.0)),
                  ),
                ]),
              ) : SizedBox(),
            ],
          ),
          actions: (widget.fromTresory == null && widget.onItemSelected == null)
              ? <Widget>[
                  IconSlideAction(
                      color: Colors.white10,
                      iconWidget: Icon(
                        Icons.delete_forever,
                        size: 50,
                        color: Colors.red,
                      ),
                      onTap: () async {
                        dellDialog(context);
                      }),
                ]
              : [],
          secondaryActions: (widget.fromTresory == null &&
                  widget.onItemSelected == null)
              ? [
                  IconSlideAction(
                    color: Colors.white10,
                    iconWidget: Icon(
                      Icons.phone_enabled,
                      size: 50,
                      color: Colors.green,
                    ),
                    onTap: () async {
                      await _makePhoneCall("tel:${widget.piece.mobileTier}");
                    },
                    foregroundColor: Colors.green,
                  ),
                ]
              : [],
        ),
      ),
    );
  }

  String getPiecetype() {
    switch (widget.piece.piece) {
      case "FP":
        return S.current.fp;
        break;
      case "CC":
        return S.current.cc;
        break;
      case "BL":
        return S.current.bl;
        break;
      case "FC":
        return S.current.fc;
        break;
      case "RC":
        return S.current.rc;
        break;
      case "AC":
        return S.current.ac;
        break;
      case "BC":
        return S.current.bc;
        break;
      case "BR":
        return S.current.br;
        break;
      case "FF":
        return S.current.ff;
        break;
      case "RF":
        return S.current.rf;
        break;
      case "AF":
        return S.current.af;
        break;
    }
  }

  Color getColor() {
    if (widget.piece.piece == PieceType.devis) {
      if (widget.piece.etat == 1) {
        return Colors.green;
      } else {
        switch (widget.piece.mov) {
          case 2:
            return Colors.black26;
            break;
          case 0:
            return Colors.red;
            break;
        }
      }
    } else {
      switch (widget.piece.mov) {
        case 1:
          if (widget.piece.reste > 0) {
            return Colors.red;
          } else {
            return Colors.green;
          }
          break;
        case 2:
          return Colors.black26;
          break;
        case 0:
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
      closeIcon: Icon(
        Icons.cancel_sharp,
        color: Colors.red,
        size: 26,
      ),
      showCloseIcon: (widget.piece.piece != PieceType.devis &&
          widget.piece.piece != PieceType.bonCommande &&
          widget.piece.etat != 1 &&
          widget.piece.mov != 2),
      btnCancelText: (widget.piece.piece != PieceType.devis &&
          widget.piece.piece != PieceType.bonCommande &&
          widget.piece.etat != 1 &&
          widget.piece.mov != 2)
          ? S.current.sans_tresorie
          : S.current.non,
      btnCancelOnPress: () async {
        if (widget.piece.piece != PieceType.devis &&
            widget.piece.piece != PieceType.bonCommande &&
            widget.piece.etat != 1 &&
            widget.piece.mov != 2 ) {

          if(widget.piece.transformer == 1 &&
              widget.piece.piece != PieceType.retourClient &&
              widget.piece.piece != PieceType.avoirClient &&
              widget.piece.piece != PieceType.retourFournisseur &&
              widget.piece.piece != PieceType.avoirFournisseur){

            await _queryCtr.updateObjetTresorie(oldPiece : widget.piece , objet : '${S.current.reglement_piece}');
          }

          int res = await _queryCtr.removeItemFromTable(
              DbTablesNames.pieces, widget.piece);
          var message = "";
          if (res > 0) {
            message = S.current.msg_supp_ok;
            _confirmDell = true;
          } else {
            message = S.current.msg_ereure;
          }
          Helpers.showFlushBar(context, message);
          if (_confirmDell) {
            setState(() {
              _visible = false;
            });
          }
        }
      },
      btnOkText: (widget.piece.piece != PieceType.devis &&
          widget.piece.piece != PieceType.bonCommande &&
          widget.piece.etat != 1 &&
          widget.piece.mov != 2)
          ? S.current.avec_tresorie
          : S.current.oui,
      btnOkOnPress: () async {
        if (widget.piece.piece != PieceType.devis &&
            widget.piece.piece != PieceType.bonCommande &&
            widget.piece.etat != 1 ) {
          int res = await _queryCtr.removeItemWithForeignKey(
              DbTablesNames.tresorie, widget.piece.id, "Piece_id");
          var message = "";
          if (res < 0) {
            message = S.current.msg_err_tresorie;
            Helpers.showFlushBar(context, message);

          }else{
            int res1 = await _queryCtr.removeItemFromTable(
                DbTablesNames.pieces, widget.piece);

            await _queryCtr.updateComptesSolde();
            if (res1 > 0) {
              message = S.current.msg_supp_ok;
              _confirmDell = true;
            } else {
              message = S.current.msg_ereure;
            }

            Helpers.showFlushBar(context, message);
            if (_confirmDell) {
              setState(() {
                _visible = false;
              });
            }
          }

        } else {
          //ds le cas d'un devis uniquement
          int res = await _queryCtr.removeItemFromTable(
              DbTablesNames.pieces, widget.piece);
          var message = "";
          if (res > 0) {
            message = S.current.msg_supp_ok;
            _confirmDell = true;
          } else {
            message = S.current.msg_ereure;
          }
          Helpers.showFlushBar(context, message);
          if (_confirmDell) {
            setState(() {
              _visible = false;
            });
          }
        }
      },
    )..show();
  }
}
