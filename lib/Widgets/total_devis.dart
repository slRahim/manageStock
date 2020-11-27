import 'package:flutter/material.dart';
import 'package:gestmob/models/Piece.dart';

// montant de facture à afficher ds le bas de screen add piece
class TotalDevis extends StatelessWidget{
  final Piece piece;

  const TotalDevis({Key key, this.piece}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Center(
        child: Wrap(
            spacing: 13,
            runSpacing: 13,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text("Total HT = "),
                  Expanded(child: Text(".............................................................................................................",
                    maxLines: 1,)),
                  Text(piece.total_ht.toString() + " DA"),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text("Total TVA = "),
                  Expanded(child: Text(".............................................................................................................",
                    maxLines: 1,)),
                  Text(piece.total_tva.toString() + " DA"),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text("Net a payer = "),
                  Expanded(child: Text(".............................................................................................................",
                    maxLines: 1,)),
                  Text(piece.total_ttc.toString() + " DA"),
                ],
              ),
              SizedBox(height: 20),

            ]
        ),
      ),
    );
  }

}