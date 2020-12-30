import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/Article.dart';
import 'package:gestmob/models/Piece.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'CustomWidgets/list_tile_card.dart';

// element à afficher lors de listing des factures
class PieceListItem extends StatelessWidget {
   PieceListItem({
    @required this.piece,
    Key key, this.onItemSelected ,
  })  : assert(piece != null),
        super(key: key);

  final Piece piece;
  final Function(Object) onItemSelected;

  QueryCtr _queryCtr = new QueryCtr() ;
  bool _confirmDell = false ;

  @override
  Widget build(BuildContext context) => ListTileCard(
    id: piece.id,
    from: piece,
    confirmDismiss:(DismissDirection dismissDirection) async {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return dellDialog(context);
          });
          return _confirmDell ;
    },
    onLongPress:  () => onItemSelected != null? onItemSelected(piece) : null,
    onTap: () => {
      if(onItemSelected == null){
        Navigator.of(context).pushNamed(RoutesKeys.addPiece, arguments: piece)
      }
    },
    leading: Container(
      child: Center(child: Text(piece.piece),),
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          width: 3,
          color: Colors.green,
        ),
        color: Colors.white,
      ),
    ),
    title: Text(piece.num_piece),
    subtitle:(piece.raisonSociale != null) ? Text("RS: " + piece.raisonSociale) : null,
    trailingChildren: [
      (piece.total_ttc < 0)
          ? Text('TTC : '+(piece.total_ttc * -1).toString()+" ${S.current.da}",
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold ,
                      color: (piece.reste < 0)?Colors.redAccent : Colors.black ),
            )
         : Text('TTC : '+(piece.total_ttc).toString()+" ${S.current.da}",
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold ,
                      color: (piece.reste > 0)?Colors.redAccent : Colors.black ),
            ) ,

      SizedBox(height: 5),
      Text(Helpers.dateToText(piece.date), style: TextStyle(color: Colors.black, fontSize: 14.0),),
      SizedBox(height: 5),
      getIcon(),

    ],
  );

  Widget getIcon() {
    switch (piece.mov){
      case 1 :
        return Icon(Icons.check_circle , color: Colors.blue);
        break;
      case 2 :
        return Icon(Icons.broken_image , color: Colors.black45);
        break;
      case 0 :
        return Icon(Icons.check_circle_outline , color: Colors.black45);
        break;
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
          child: Text("Seulement"),
          onPressed: ()async{
            int res = await _queryCtr.removeItemFromTable(DbTablesNames.pieces, piece);
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
          },
        ),
        FlatButton(
          child: Text("Avec Tresorie"),
          onPressed: ()async{
            int res = await _queryCtr.removeItemWithForeignKey (DbTablesNames.tresorie , piece.id , "Piece_id");
            var message = "" ;
            if(res > 0){
              int res1 = await _queryCtr.removeItemFromTable(DbTablesNames.pieces, piece);
              if(res > 0){
                message =S.current.msg_supp_ok;
                _confirmDell =true ;
                Navigator.pop(context);
              }else{
                message =S.current.msg_ereure;
                Navigator.pop(context);
              }
            }else{
              message ="Pas de tresorie associer à la piece";
              Navigator.pop(context);
            }

            Helpers.showFlushBar(context, message);
          },
        ),
      ],
    );
  }


}
