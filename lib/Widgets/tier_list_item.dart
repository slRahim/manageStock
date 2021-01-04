
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
  SlidingCardController controller ;

  @override
  void initState() {
    super.initState();
    controller = SlidingCardController();
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
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
          radius: 30,
          backgroundImage: (widget.tier.imageUint8List == null) ? MemoryImage(
              widget.tier.imageUint8List) : null,

        ),
        title: ("RS: "+widget.tier.raisonSociale),
        subtitle: ("Statut: " + Statics.statutItems[widget.tier.statut]),
        trailingChildren: [
          Text(
            widget.tier.credit.toString(),
            style: TextStyle(
                color: widget.tier.credit > 0 ? Colors.redAccent : Colors.black,
                fontSize: 15.0),
          )
          // fournisseur reverse colors
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
                  });
            }
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          color: Theme.of(context).backgroundColor,
          iconWidget: Icon(Icons.delete_forever,size: 50, color: Colors.green,),
          onTap: () async{
            await _makePhoneCall("tel:${widget.tier.mobile}");
          },
          foregroundColor: Colors.green,
        ),
      ],
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
            child: Text(S.current.oui),
            onPressed: ()async {
              if(widget.tier.id == 1 || widget.tier.id == 2){
                Navigator.pop(context);
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
                    Navigator.pop(context);
                  }else{
                    message =S.current.msg_ereure;
                    Navigator.pop(context);
                  }
                  Helpers.showFlushBar(context, message);
                }else{
                  Navigator.pop(context);
                  var message =S.current.msg_supp_err2;
                  Helpers.showFlushBar(context, message);
                }
              }
            }
        ),
      ],
    );
  }
}

