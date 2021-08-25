import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/Tresorie.dart';
import 'package:gestmob/services/push_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sliding_card/sliding_card.dart';

import 'CustomWidgets/list_tile_card.dart';

// element à afficher lors de listing des tresorie
class TresorieListItem extends StatefulWidget {
  TresorieListItem({@required this.tresorie, Key key,})
      : assert(tresorie != null),
        super(key: key);

  Tresorie tresorie;

  @override
  _TresorieListItemState createState() => _TresorieListItemState();
}

class _TresorieListItemState extends State<TresorieListItem> {
  QueryCtr _queryCtr = new QueryCtr();

  bool _confirmDell = false;

  bool _visible = true;

  SlidingCardController controller;

  String _devise;

  String feature6 = 'feature6';

  @override
  void initState() {
    super.initState();
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
        featureId: feature6,
        tapTarget: Icon(
          MdiIcons.arrowExpandRight,
          color: Colors.black,
        ),
        backgroundColor: Colors.red,
        contentLocation: ContentLocation.below,
        title: Text(
          S.current.swipe,
          style: GoogleFonts.lato(fontWeight: FontWeight.bold),
        ),
        description:
            Container(width: 100, child: Text(S.current.msg_swipe_start)),
        onBackgroundTap: () async {
          await FeatureDiscovery.completeCurrentStep(context);
          return true;
        },
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: ListTileCard(
            from: widget.tresorie,
            onTap: _tapItem,
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
                child: (widget.tresorie.categorie == 2 ||
                        widget.tresorie.categorie == 7 ||
                    widget.tresorie.categorie == 4)
                    ? Icon(
                        Icons.arrow_upward_outlined,
                        color: Colors.green,
                      )
                    : Icon(
                        Icons.arrow_downward_outlined,
                        color: Colors.red,
                      ),
                radius: 23,
                backgroundColor: Colors.grey[100],
              ),
            ),
            title:
                (widget.tresorie.tierRS != '' && widget.tresorie.tierRS != null)
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Text(
                                "(# : ${widget.tresorie.numTresorie}) ${widget.tresorie.tierRS}",
                                style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                  fontSize: 14,
                                ))),
                          ],
                        ),
                      )
                    : Text("(# : ${widget.tresorie.numTresorie}) __",
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                          fontSize: 14,
                        ))),
            trailingChildren: [
              Text(
                "${S.current.objet}: ${widget.tresorie.objet}",
                style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 14.0)),
              ),
              Row(
                children: [
                  Icon(
                    MdiIcons.cashMultiple,
                    size: 16,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  (widget.tresorie.montant >= 0)
                      ? Text(
                          '${Helpers.numberFormat(widget.tresorie.montant).toString()} $_devise',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ))
                      : Text(
                          '${Helpers.numberFormat(widget.tresorie.montant * -1).toString()} $_devise',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          )),
                ],
              ),
            ],
          ),
          actions: <Widget>[
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
          ],
        ),
      ),
    );
  }

  _tapItem(){
    Navigator.of(context)
        .pushNamed(RoutesKeys.addTresorie, arguments: widget.tresorie)
        .then((value) {
      if(value is Tresorie){
        setState(() {
          widget.tresorie = value ;
        });
      }
    });
  }

  Color getColor() {
    switch (widget.tresorie.mov) {
      case 1:
        return Colors.green;
        break;
      case 2:
        return Colors.red;
        break;
      case 0:
        return Colors.black26;
        break;
    }
  }

  Widget dellDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.QUESTION,
      animType: AnimType.BOTTOMSLIDE,
      title: S.current.supp,
      desc: '${S.current.msg_supp}',
      btnCancelText: S.current.non,
      btnCancelOnPress: () {},
      btnOkText: S.current.oui,
      btnOkOnPress: () async {
        int res = await _queryCtr.removeItemFromTable(
            DbTablesNames.tresorie, widget.tresorie);

        var message = "";
        if (res > 0) {
          message = S.current.msg_supp_ok;
          _confirmDell = true;
        } else {
          message = S.current.msg_ereure;
        }
        await _queryCtr.updateComptesSolde();
        Helpers.showToast(message);
        if (_confirmDell) {
          setState(() {
            _visible = false;
          });
        }
      },
    )..show();
  }
}
