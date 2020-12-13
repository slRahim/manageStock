
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/models/Piece.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PreviewPiece extends StatefulWidget {
  final Piece piece ;
  final  ValueChanged ticket ;
  PreviewPiece({Key key, @required this.piece , this.ticket}) : super(key: key);

  @override
  _PreviewPieceState createState() => _PreviewPieceState();
}

class _PreviewPieceState extends State<PreviewPiece> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: InkWell(
          child: Icon(Icons.arrow_back),
          onTap: (){
            Navigator.pop(context);
          },
        ),
        title: Text('Piece Preview'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.print),
            onPressed: () async{
              Ticket ticket = await _ticket(PaperSize.mm80) ;
              widget.ticket(ticket);
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        child: ListView(
          children: [
            Container(
                height: MediaQuery.of(context).size.height / 1.6,
                padding:EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logos/cirtait_logo.png',
                      height: 60.0,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 5,),
                    Text("Piece Type :${widget.piece.piece}"),
                    Text("Date :${Helpers.dateToText(widget.piece.date)}"),
                    Text("Tier :${widget.piece.raisonSociale}"),
                    Text("----------------------------------------------------------------------------------------------"),
                    Table(
                      columnWidths: {0:FractionColumnWidth(.4)},
                      children: [
                        TableRow(
                          children: [
                            Text("Referance",style: TextStyle(fontWeight: FontWeight.bold),),
                            Text("QTE",style: TextStyle(fontWeight: FontWeight.bold),),
                            Text("Prix \n UN \n",style: TextStyle(fontWeight: FontWeight.bold),),
                            Text("Monatant",style: TextStyle(fontWeight: FontWeight.bold),),
                          ]
                        ),
                        TableRow(
                            children: [
                              Text("Article1"),
                              Text("22"),
                              Text("155"),
                              Text("155"),
                            ]
                        ),
                        TableRow(
                            children: [
                              Text("Article2"),
                              Text("22"),
                              Text("222"),
                              Text("155"),
                            ]
                        ),
                      ],
                    ),
                    Text("----------------------------------------------------------------------------------------------"),
                    Text("\n Total HT:${widget.piece.total_ht}"),
                    Text("Total TVA :${widget.piece.total_tva}"),
                    Text("Total TTC :${widget.piece.total_ttc}"),
                    Text("Regler :${widget.piece.regler}"),
                    Text("Reste :${widget.piece.reste} \n"),
                    Text("------------------------------------------(FIN)-------------------------------------------"),
                    Icon(MdiIcons.qrcode , color: Colors.black, size: 100,),
                  ],
                ),
            ),
            SizedBox(height: 10),
            Container(
              height: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Text('Ticket'),
           ),
          ],
        ),
      ),
    );
  }

Future<Ticket> _ticket(PaperSize paper) async {
  final ticket = Ticket(paper);
  int total = 0;

  ticket.text("demo teste");

  ticket.feed(1);
  ticket.row([
    PosColumn(text: 'Total', width: 6, styles: PosStyles(bold: true)),
    PosColumn(text: 'Rp $total', width: 6, styles: PosStyles(bold: true)),
  ]);
  ticket.feed(2);
  ticket.text('Thank You',styles: PosStyles(align: PosAlign.center, bold: true));
  ticket.cut();

  return ticket;
}
}
