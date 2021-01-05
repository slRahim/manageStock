import 'package:flutter/material.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/Piece.dart';

// montant de facture à afficher ds le bas de screen add piece
class TotalDevis extends StatelessWidget{
  final double total_ht ;
  final double remise ;
  final double net_ht ;
  final double total_tva ;
  final double total_ttc ;
  final double timbre ;
  final double net_payer ;

  const TotalDevis({Key key, this.total_ttc , this.total_tva , this.total_ht
    , this.timbre ,this.net_ht ,this.remise , this.net_payer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 10),
      child: Center(
        child: ListView(
            padding: EdgeInsetsDirectional.only(top: 30 , start: 3 , end: 3),
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
              SizedBox(height: 5),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text("Remise= "),
                  Expanded(child: Text(".............................................................................................................",
                    maxLines: 1,)),
                  Text(remise.toString() + " %"),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text("Net-HT= "),
                  Expanded(child: Text(".............................................................................................................",
                    maxLines: 1,)),
                  Text(net_ht.toString() + " ${S.current.da}"),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text("${S.current.total_tva}= "),
                  Expanded(child: Text(".............................................................................................................",
                    maxLines: 1,)),
                  Text(total_tva.toString() + " ${S.current.da}"),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text("${S.current.total}= "),
                  Expanded(child: Text(".............................................................................................................",
                    maxLines: 1,)),
                  Text(total_ttc.toString() + " ${S.current.da}"),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text("Timbre= "),
                  Expanded(child: Text(".............................................................................................................",
                    maxLines: 1,)),
                  Text(timbre.toString() + " ${S.current.da}"),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text("${S.current.net_payer}= "),
                  Expanded(child: Text(".............................................................................................................",
                    maxLines: 1,)),
                  Text(net_payer.toString() + " ${S.current.da}"),
                ],
              ),
              SizedBox(height: 20),
            ]
        ),
      ),
    );
  }

}