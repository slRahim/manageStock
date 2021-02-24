import 'dart:ui';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
import 'package:gestmob/services/push_notifications.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/scheduler.dart';

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
  String _devise ;
  String feature7 = 'feature7';

  @override
  void initState() {
    if(FeatureDiscovery.hasPreviouslyCompleted(context, feature7) == false){
      SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
        FeatureDiscovery.discoverFeatures(context, <String>{feature7});
      });
    }
    super.initState();
    controller = SlidingCardController();

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    PushNotificationsManagerState data = PushNotificationsManager.of(context);
    _devise = getDeviseTranslate(data.myParams.devise) ;
  }

  String getDeviseTranslate(devise){
    switch(devise){
      case "DZD" :
        return S.current.da ;
        break;
      default :
        return devise ;
        break ;
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return DescribedFeatureOverlay(
      featureId: feature7,
      tapTarget: Icon(MdiIcons.arrowExpandRight , color: Colors.black,),
      backgroundColor: Colors.green,
      contentLocation: ContentLocation.below,
      title: Text(S.current.swipe),
      description: Text(S.current.msg_swipe_start),
      onBackgroundTap: () async{
        await FeatureDiscovery.completeCurrentStep(context);
        return true ;
      },
      child: Visibility(
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
                backgroundColor: Colors.white,
                radius: 25,
                backgroundImage:  MemoryImage(widget.tier.imageUint8List),

              ),
            ),
            title:(widget.tier.raisonSociale != null)
                ? Text("(${Statics.statutItems[widget.tier.statut]}) ${widget.tier.raisonSociale}" ,
                    style: TextStyle(
                        fontSize: 16,)
                )
                : null,
            trailingChildren: [
              Text(
                "${S.current.regler}: ${Helpers.numberFormat(widget.tier.regler).toString()} ${_devise}",
                style: TextStyle(
                    fontSize: 16.0),
              ),
              Text(
               "${Helpers.numberFormat(widget.tier.credit).toString()} ${_devise}",
                style: TextStyle(
                    color: widget.tier.credit > 0 ? Colors.redAccent : Theme.of(context).primaryColorDark,
                    fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              RichText(
                text: TextSpan(
                    children: [
                      TextSpan(
                          text: "${S.current.mobile} : ",
                          style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Theme.of(context).primaryColorDark,)
                      ),
                      TextSpan(
                        text:"${widget.tier.mobile} ",
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
                          text: "${S.current.chifre_affaire} : ",
                          style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Theme.of(context).primaryColorDark,)
                      ),
                      TextSpan(
                        text:"${Helpers.numberFormat(widget.tier.chiffre_affaires)} ${_devise}",
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
                          text: "${S.current.adresse} : ",
                          style: TextStyle(fontSize: 15 , fontWeight: FontWeight.bold,color: Theme.of(context).primaryColorDark,)
                      ),
                      TextSpan(
                        text:"${widget.tier.adresse}",
                        style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
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

