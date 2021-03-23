import 'package:flutter/material.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/MyParams.dart';
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
  final MyParams myParams;


  const TotalDevis({Key key, this.total_ttc , this.total_tva , this.total_ht
    , this.timbre ,this.net_ht ,this.remise , this.net_payer , this.myParams}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    String _devise = Helpers.getDeviseTranslate(myParams.devise);
    return Container(
      margin: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 10),
      child: Center(
        child: ListView(
            padding: EdgeInsetsDirectional.only(top: 30 , start: 3 , end: 3),
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text("${S.current.total_ht}",style: TextStyle(color: Colors.white),),
                  Expanded(child: Text(".............................................................................................................",
                    maxLines: 1,style: TextStyle(color: Colors.white),)),
                  Text(Helpers.numberFormat(total_ht).toString() + " ${(_devise)}",style: TextStyle(color: Colors.white),),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text("${S.current.remise}",style: TextStyle(color: Colors.white),),
                  Expanded(child: Text(".............................................................................................................",
                    maxLines: 1,style: TextStyle(color: Colors.white),)),
                  Text("${Helpers.numberFormat((total_ht*remise)/100)} ${_devise} (${Helpers.numberFormat(remise)} %)",style: TextStyle(color: Colors.white),),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text("${S.current.net_ht}",style: TextStyle(color: Colors.white),),
                  Expanded(child: Text(".............................................................................................................",
                    maxLines: 1,style: TextStyle(color: Colors.white),)),
                  Text(net_ht.toString() + " ${_devise}",style: TextStyle(color: Colors.white),),
                ],
              ),
              SizedBox(height: 5),
              Visibility(
                visible: (myParams.tva),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text("${S.current.total_tva}",style: TextStyle(color: Colors.white),),
                    Expanded(child: Text(".............................................................................................................",
                      maxLines: 1,style: TextStyle(color: Colors.white),)),
                    Text(total_tva.toString() + " ${_devise}",style: TextStyle(color: Colors.white),),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Visibility(
                visible: (myParams.tva),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text("${S.current.total}",style: TextStyle(color: Colors.white),),
                    Expanded(child: Text(".............................................................................................................",
                      maxLines: 1,style: TextStyle(color: Colors.white),)),
                    Text(total_ttc.toString() + " ${_devise}",style: TextStyle(color: Colors.white),),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Visibility(
                visible: (myParams.timbre),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text("${S.current.timbre}",style: TextStyle(color: Colors.white),),
                    Expanded(child: Text(".............................................................................................................",
                      maxLines: 1,style: TextStyle(color: Colors.white),)),
                    Text(timbre.toString() + " ${_devise}",style: TextStyle(color: Colors.white),),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text("${S.current.net_payer}",style: TextStyle(color: Colors.white),),
                  Expanded(child: Text(".............................................................................................................",
                    maxLines: 1,style: TextStyle(color: Colors.white),)),
                  Text(net_payer.toString() + " ${_devise}",style: TextStyle(color: Colors.white),),
                ],
              ),
              SizedBox(height: 20),
            ]
        ),
      ),
    );
  }

}