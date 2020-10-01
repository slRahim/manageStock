import 'package:flutter/material.dart';
import 'package:gestmob/models/Piece.dart';

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
                  Text("Net a payer = "),
                  Expanded(child: Text(".............................................................................................................",
                    maxLines: 1,)),
                  Text(piece.net_a_payer.toString() + " DA"),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(child: Text("Net a payer")),
                  Text(piece.net_a_payer.toString()),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(child: Text("Net a payer")),
                  Text(piece.net_a_payer.toString()),
                ],
              ),
              SizedBox(height: 20),

            ]
        ),
      ),
    );
  }

}