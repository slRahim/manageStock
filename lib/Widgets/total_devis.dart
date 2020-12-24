import 'package:flutter/material.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/Piece.dart';

// montant de facture à afficher ds le bas de screen add piece
class TotalDevis extends StatelessWidget{

  final double total_ttc ;
  final double total_ht ;
  final double total_tva ;

  const TotalDevis({Key key, this.total_ttc , this.total_tva , this.total_ht}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 10),
      child: Center(
        child: Wrap(
            spacing: 13,
            runSpacing: 13,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text("${S.current.total_ht}= "),
                  Expanded(child: Text(".............................................................................................................",
                    maxLines: 1,)),
                  Text(total_ht.toString() + " ${S.current.da}"),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text("${S.current.total_tva}= "),
                  Expanded(child: Text(".............................................................................................................",
                    maxLines: 1,)),
                  Text(total_tva.toString() + " ${S.current.da}"),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text("${S.current.net_payer}= "),
                  Expanded(child: Text(".............................................................................................................",
                    maxLines: 1,)),
                  Text(total_ttc.toString() + " ${S.current.da}"),
                ],
              ),
              SizedBox(height: 20),

            ]
        ),
      ),
    );
  }

}