import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/models/Article.dart';
import 'package:gestmob/models/Piece.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'CustomWidgets/list_tile_card.dart';

// element à afficher lors de listing des factures
class PieceListItem extends StatelessWidget {
  const PieceListItem({
    @required this.piece,
    Key key, this.onItemSelected ,
  })  : assert(piece != null),
        super(key: key);

  final Piece piece;
  final Function(Object) onItemSelected;

  @override
  Widget build(BuildContext context) => ListTileCard(
    id: piece.id,
    from: piece,
    confirmDismiss:(DismissDirection dismissDirection) async {
      print("Mov: " + piece.mov.toString());
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return dellDialog();
          });;
    } ,
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
      (piece.reste > 0) ? Text('TTC : '+piece.total_ttc.toString(), style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold ,color: Colors.redAccent),)
      : Text('TTC : '+piece.total_ttc.toString(), style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold ),) ,
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

  Widget dellDialog() {

  }


}
