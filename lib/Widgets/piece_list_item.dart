import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/models/Article.dart';
import 'package:gestmob/models/Piece.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'CustomWidgets/list_tile_card.dart';

class PieceListItem extends StatelessWidget {
  const PieceListItem({
    @required this.piece,
    Key key,
  })  : assert(piece != null),
        super(key: key);

  final Piece piece;

  @override
  Widget build(BuildContext context) => ListTileCard(
    onTap: () => {
      Navigator.of(context).pushNamed(
          RoutesKeys.addPiece,
          arguments: piece
      )
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
    subtitle: Text("RS: " + piece.tier_raisonSociale),
    trailingChildren: [
      Text(piece.net_a_payer.toString(), style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
      SizedBox(height: 5),
      Text(Helpers.dateToText(piece.date), style: TextStyle(color: Colors.black, fontSize: 14.0),)
    ],
  );
}
