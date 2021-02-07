import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/Tresorie.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sliding_card/sliding_card.dart';

import 'CustomWidgets/list_tile_card.dart';

// element à afficher lors de listing des tresorie
class TresorieListItem extends StatefulWidget {
  TresorieListItem({
    @required this.tresorie,
    Key key,
  })  : assert(tresorie != null),
        super(key: key);

  final Tresorie tresorie;

  @override
  _TresorieListItemState createState() => _TresorieListItemState();
}

class _TresorieListItemState extends State<TresorieListItem> {
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
          from: widget.tresorie,
          onTap: () =>
          {
            Navigator.of(context).pushNamed(
                RoutesKeys.addTresorie, arguments: widget.tresorie)
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
            backgroundColor: Colors.yellow[700],
            child: CircleAvatar(
              child: (widget.tresorie.categorie == 2 ||
                  widget.tresorie.categorie == 7) ? Icon(
                Icons.arrow_upward_outlined, color: Colors.green,)
                  : Icon(Icons.arrow_downward_outlined, color: Colors.red,),
              radius: 25,
              backgroundColor: Colors.grey[100],
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
                "${Helpers.dateToText(widget.tresorie.date)}",
                style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 4.7,
                    color: Colors.white70),
              ),
            ],
          ),
          title: Row(
            children: [
              Icon(Icons.person_sharp , color: Colors.white,size: SizeConfig.safeBlockHorizontal * 5),
              SizedBox(
                width: 10,
              ),
              (widget.tresorie.tierRS != null) ? Text("${widget.tresorie.tierRS}" ,
                  style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 4.5,
                      color: Colors.white)
              ):Text("__" ,
                  style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 4.5,
                      color: Colors.white)
              )
            ],
          ),
          trailingChildren: [
            Text(
              "${S.current.n}: ${widget.tresorie.numTresorie}",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0),
            ),
            Text(
              "${widget.tresorie.objet}",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0),
            ),
            (widget.tresorie.montant >= 0) ? Text(
              '${Helpers.numberFormat(widget.tresorie.montant).toString()} (${S.current.da})',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),)
                : Text(
              '${Helpers.numberFormat(widget.tresorie.montant * -1).toString()} (${S.current.da})',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
            getIcon(),
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
      ),
    );
  }

  Widget getIcon() {
    switch (widget.tresorie.mov){
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
        int res = await _queryCtr.removeItemFromTable(DbTablesNames.tresorie, widget.tresorie);
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
    )..show();
  }
}

