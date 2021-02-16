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
import 'package:gestmob/services/push_notifications.dart';

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
  String _devise ;

  @override
  void initState() {
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
            radius: 23,
            backgroundColor: getColor(),
            child: CircleAvatar(
              child: (widget.tresorie.categorie == 2 ||
                  widget.tresorie.categorie == 7) ? Icon(
                Icons.arrow_upward_outlined, color: Colors.green,)
                  : Icon(Icons.arrow_downward_outlined, color: Colors.red,),
              radius: 20,
              backgroundColor: Colors.grey[100],
            ),
          ),
          title: Row(
            children: [
              Icon(Icons.home_work_outlined , color: Theme.of(context).accentColor,size: 20),
              SizedBox(
                width: 10,
              ),
              (widget.tresorie.tierRS != null) ? Text("(${S.current.n}: ${widget.tresorie.numTresorie}) ${widget.tresorie.tierRS}" ,
                  style: TextStyle(
                      fontSize: 16,)
              ):Text("(${S.current.n}: ${widget.tresorie.numTresorie}) __" ,
                  style: TextStyle(
                      fontSize: 16,)
              )
            ],
          ),
          trailingChildren: [
            Text(
              "${S.current.objet}: ${widget.tresorie.objet}",
              style: TextStyle(
                  fontSize: 16.0),
            ),
            (widget.tresorie.montant >= 0) ? Text(
              '${Helpers.numberFormat(widget.tresorie.montant).toString()} ${_devise}',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),)
                : Text(
              '${Helpers.numberFormat(widget.tresorie.montant * -1).toString()} ${_devise}',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
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

  Color getColor() {
    switch (widget.tresorie.mov){
      case 1 :
        return Colors.green;
        break;
      case 2 :
        return Colors.red;
        break;
      case 0 :
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

