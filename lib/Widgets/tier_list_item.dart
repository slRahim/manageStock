
import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/Article.dart';
import 'package:gestmob/models/Tiers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sliding_card/sliding_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'CustomWidgets/list_tile_card.dart';

// element à afficher lors de listing des clients ou des fournisseurs
class TierListItem extends StatefulWidget {
  TierListItem({
    @required this.tier,
    Key key, this.onItemSelected,
  })  : assert(tier != null),
        super(key: key);

  final Tiers tier;
  final Function(Object) onItemSelected;

  @override
  _TierListItemState createState() => _TierListItemState();
}

class _TierListItemState extends State<TierListItem> {
  final QueryCtr _queryCtr = new QueryCtr() ;
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
          from: widget.tier,
          onLongPress: () =>
          widget.onItemSelected != null ? widget.onItemSelected(widget.tier) : null,
          onTap: () =>
          {
            if(widget.onItemSelected == null){
              Navigator.of(context)
                  .pushNamed(RoutesKeys.addTier, arguments: widget.tier)
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
            backgroundColor: Colors.yellow[700],
            radius: 28,
            child: CircleAvatar(
              radius: 25,
              backgroundImage: (widget.tier.imageUint8List == null) ? MemoryImage(
                  widget.tier.imageUint8List) : null,

            ),
          ),
          title: ("RS: "+widget.tier.raisonSociale),
          subtitle: ("${S.current.statut}: " + Statics.statutItems[widget.tier.statut]),
          trailingChildren: [
            Text(
              "${S.current.mobile} : "+widget.tier.mobile.toString(),
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              "${S.current.regler} : "+widget.tier.regler.toString(),
              style: TextStyle(
                  fontSize: 16.0),
            ),
            Text(
             "${S.current.credit} : "+widget.tier.credit.toString(),
              style: TextStyle(
                  color: widget.tier.credit > 0 ? Colors.redAccent : Colors.black,
                  fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(),
            RichText(
              text: TextSpan(
                  children: [
                    TextSpan(
                        text: "${S.current.chifre_affaire} : ",
                        style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black)
                    ),
                    TextSpan(
                      text:"${widget.tier.chiffre_affaires} ${S.current.da}",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0),
                    ),
                  ]
              ),
            ),
            SizedBox(),
            RichText(
              text: TextSpan(
                  children: [
                    TextSpan(
                        text: "${S.current.adresse} : ",
                        style: TextStyle(fontSize: 15 , fontWeight: FontWeight.bold,color: Colors.black)
                    ),
                    TextSpan(
                      text:"${widget.tier.adresse} :",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0),
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
        secondaryActions: <Widget>[
          IconSlideAction(
            color: Colors.white10,
            iconWidget: Icon(Icons.phone_enabled,size: 50, color: Colors.green,),
            onTap: () async{
              await _makePhoneCall("tel:${widget.tier.mobile}");
            },
            foregroundColor: Colors.green,
          ),
        ],
      ),
    );
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
      dialogType: DialogType.QUESTION,
      animType: AnimType.BOTTOMSLIDE,
      title: S.current.supp,
      desc: '${S.current.msg_supp} ... ',
      btnCancelText: S.current.non,
      btnCancelOnPress: (){},
      btnOkText: S.current.oui,
      btnOkOnPress: () async{
        if(widget.tier.id == 1 || widget.tier.id == 2){
          var message =S.current.msg_supp_err1;
          Helpers.showFlushBar(context, message);
        }else{
          bool hasItems = await _queryCtr.checkTierItems(widget.tier);
          if(hasItems == false){
            int res = await _queryCtr.removeItemFromTable(DbTablesNames.tiers, widget.tier);
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
          }else{
            var message =S.current.msg_supp_err2;
            Helpers.showFlushBar(context, message);
          }
       }
      },
    )..show();

  }
}

