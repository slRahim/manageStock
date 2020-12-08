import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
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
      child: Center(child: Text("TR"),),
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
      Text('Montant : '+tresorie.montant.toString(), style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold ),) ,
      SizedBox(height: 5),
      Text(Helpers.dateToText(tresorie.date), style: TextStyle(color: Colors.black, fontSize: 14.0),),
      SizedBox(height: 5),
      Icon(Icons.check_circle , color: Colors.blue),
    ],
  );


  Widget dellDialog(BuildContext context) {
      return AlertDialog(
        title:  Text('Delete ?'),
        content: Text('do you wont to delete the item'),
        actions: [
          FlatButton(
            child: Text('No'),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text('YES'),
            onPressed: ()async {
              int res = await _queryCtr.removeItemFromTable(DbTablesNames.tresorie, tresorie);
              var message = "" ;
              if(res > 0){
                message ="Piece deleted successfully";
                _confirmDell =true ;
                Navigator.pop(context);
              }else{
                message ="Error has occured";
                Navigator.pop(context);
              }
              Helpers.showFlushBar(context, message);
            }
          ),
        ],
      );
  }


}
