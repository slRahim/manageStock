import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/Tresorie.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'CustomWidgets/list_tile_card.dart';

// element à afficher lors de listing des tresorie
class TresorieListItem extends StatelessWidget {
  TresorieListItem({
    @required this.tresorie,
    Key key,
  })  : assert(tresorie != null),
        super(key: key);

  final Tresorie tresorie;
  QueryCtr _queryCtr = new QueryCtr() ;
  bool _confirmDell = false ;

  @override
  Widget build(BuildContext context) => ListTileCard(
    id: tresorie.id,
    from: tresorie,
    confirmDismiss: (DismissDirection dismissDirection) async {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return dellDialog(context);
          });
      return _confirmDell ;
    },
    onTap: () => {
      Navigator.of(context).pushNamed(RoutesKeys.addTresorie, arguments: tresorie)
    },
    leading: Container(
      child: Center(
        child: (tresorie.categorie == 2 || tresorie.categorie ==7) ? Icon(Icons.arrow_upward_outlined , color: Colors.green,)
            :Icon(Icons.arrow_downward_outlined , color: Colors.red,),
      ),
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          width: 3,
          color: Colors.red,
        ),
        color: Colors.white,
      ),
    ),
    title: Text(tresorie.numTresorie),
    subtitle: Text("RS: " + tresorie.tierRS),
    trailingChildren: [
      (tresorie.montant >=0)?Text('${S.current.montant} : '+tresorie.montant.toString(), style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold ),)
      :Text('${S.current.montant} : '+(tresorie.montant * -1).toString(), style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold ),),
      SizedBox(height: 5),
      Text(Helpers.dateToText(tresorie.date), style: TextStyle(color: Colors.black, fontSize: 14.0),),
      SizedBox(height: 5),
      Icon(Icons.check_circle , color: Colors.blue),
    ],
  );


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
              int res = await _queryCtr.removeItemFromTable(DbTablesNames.tresorie, tresorie);
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
            }
          ),
        ],
      );
  }


}
