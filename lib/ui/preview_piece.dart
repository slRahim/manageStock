
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/models/Article.dart';
import 'package:gestmob/models/FormatPrint.dart';
import 'package:gestmob/models/Piece.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:gestmob/models/Tiers.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

enum Format {format80, format58}
enum Display {referance, designation}

class PreviewPiece extends StatefulWidget {
  final Piece piece ;
  final  ValueChanged ticket ;
  final List<Article> articles ;
  final Tiers tier ;
  PreviewPiece({Key key, @required this.piece , this.articles ,this.tier,this.ticket ,}) : super(key: key);

  @override
  _PreviewPieceState createState() => _PreviewPieceState();
}

class _PreviewPieceState extends State<PreviewPiece> {
  PaperSize default_format = PaperSize.mm80 ;
  String default_display = "Referance" ;
  Format _format = Format.format80 ;
  Display _item = Display.referance ;

  bool _controlTotalHT = true ;
  bool _controlTotalTva =true ;
  bool _controlReste =true ;
  bool _controlCredit =true ;

  QueryCtr _queryCtr = new QueryCtr() ;
  FormatPrint formaPrint = new FormatPrint.init();

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
              Ticket ticket = await _ticket(default_format) ;

              formaPrint.default_format = default_format ;
              formaPrint.default_display = default_display ;
              formaPrint.totalHt = (_controlTotalHT)? 1 : 0 ;
              formaPrint.totalTva = (_controlTotalTva)? 1 : 0 ;
              formaPrint.reste = (_controlReste) ? 1 :0 ;
              formaPrint.credit = (_controlCredit)? 1 : 0;
              await _queryCtr.addItemToTable(DbTablesNames.formatPrint, formaPrint);

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
                height: MediaQuery.of(context).size.height /2,
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
                  crossAxisAlignment: (default_format == PaperSize.mm80)?CrossAxisAlignment.center : CrossAxisAlignment.start,
                  children: [
                    Text("N° ${widget.piece.piece} : ${widget.piece.num_piece}"),
                    Text("Date :${Helpers.dateToText(widget.piece.date)}"),
                    Text("Tier : Client01"),
                    Text("----------------------------------------------------------------------------------------------"),
                    Table(
                      columnWidths: {0:FractionColumnWidth(.4)},
                      children: [
                        TableRow(
                          children: [
                            Text("Item",style: TextStyle(fontWeight: FontWeight.bold),),
                            Text("QTE",style: TextStyle(fontWeight: FontWeight.bold),),
                            Text("Prix",style: TextStyle(fontWeight: FontWeight.bold),),
                            Text("Monatant",style: TextStyle(fontWeight: FontWeight.bold),),
                          ]
                        ),
                        TableRow(
                            children: [
                              (default_display != "Referance")?Text("Article1"):Text("Ref01"),
                              Text("XXX"),
                              Text("XXX"),
                              Text("XXX"),
                            ]
                        ),
                        TableRow(
                            children: [
                              (default_display != "Referance")?Text("Article2"):Text("Ref02"),
                              Text("XXX"),
                              Text("XXX"),
                              Text("XXX"),
                            ]
                        ),
                      ],
                    ),
                    Text("----------------------------------------------------------------------------------------------"),
                    (_controlTotalHT)?Text("\n Total HT:${widget.piece.total_ht}"):SizedBox(),
                    (_controlTotalTva)?Text("Total TVA :${widget.piece.total_tva}"):SizedBox(),
                    Text("Regler :${widget.piece.regler}"),
                    (_controlReste)?Text("Reste :${widget.piece.reste}"):SizedBox(),
                    (_controlCredit)?Text("Total Credit :${widget.tier.credit} \n"):SizedBox(),
                    Text("=============================================="),
                    Text("Total TTC :${widget.piece.total_ttc}",style: TextStyle(fontSize: 20),),
                    Text("=============================================="),
                    SizedBox(height: 20,),
                    Text("***BY CIRTA IT***",style: TextStyle(fontWeight: FontWeight.bold),),
                  ],
                ),
            ),
            SizedBox(height: 10),
            Container(
              height: MediaQuery.of(context).size.height / 3,
              child: ListView(
                children: [
                  Column(
                    children: [
                      RadioListTile<Format>(
                        title: const Text('Format 80Cm'),
                        value: Format.format80,
                        groupValue: _format,
                        onChanged: (Format value) {
                          setState(() {
                            _format = value;
                            default_format = PaperSize.mm80 ;
                          });
                        },
                      ),
                      RadioListTile<Format>(
                        title: const Text('Format 58Cm'),
                        value: Format.format58,
                        groupValue: _format,
                        onChanged: (Format value) {
                          setState(() {
                            _format = value;
                            default_format = PaperSize.mm58 ;
                          });
                        },
                      ),
                    ]
                  ),
                  Column(
                      children: [
                        RadioListTile<Display>(
                          title: const Text('Par Referance'),
                          value: Display.referance,
                          groupValue: _item,
                          onChanged: (Display value) {
                            setState(() {
                              _item = value;
                              default_display = "Referance" ;
                            });
                          },
                        ),
                        RadioListTile<Display>(
                          title: const Text('Par Designation'),
                          value: Display.designation,
                          groupValue: _item,
                          onChanged: (Display value) {
                            setState(() {
                              _item = value;
                              default_display = "Designation" ;
                            });
                          },
                        ),
                      ]
                  ),
                  CheckboxListTile(
                    title: Text("Total HT", maxLines: 1,),
                    value: _controlTotalHT,
                    onChanged: (bool value) {
                      setState(() {
                          _controlTotalHT = value ;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text("Total TVA", maxLines: 1,),
                    value: _controlTotalTva,
                    onChanged: (bool value) {
                      setState(() {
                          _controlTotalTva = value ;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text("Reste", maxLines: 1,),
                    value: _controlReste,
                    onChanged: (bool value) {
                      setState(() {
                        _controlReste =value ;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text("Total Credit", maxLines: 1,),
                    value: _controlCredit,
                    onChanged: (bool value) {
                      setState(() {
                          _controlCredit =value ;
                      });
                    },
                  ),
                ],
              ),
           ),
          ],
        ),
      ),
    );
  }

Future<Ticket> _ticket(PaperSize paper) async {
  final ticket = Ticket(paper);

  ticket.text("N° ${widget.piece.piece}: ${widget.piece.num_piece}",
      styles:PosStyles(
          align:(default_format == PaperSize.mm80)? PosAlign.center : PosAlign.left
      ));
  ticket.text("Date : ${Helpers.dateToText(widget.piece.date)}",
      styles:PosStyles(
          align:(default_format == PaperSize.mm80)? PosAlign.center : PosAlign.left
      ));
  ticket.text("Tier : ${widget.piece.raisonSociale}",
      styles:PosStyles(
          align:(default_format == PaperSize.mm80)? PosAlign.center : PosAlign.left
      ));
  ticket.hr(ch: '-');
  ticket.row([
    PosColumn(text: 'Item', width: 6, styles: PosStyles(bold: true)),
    PosColumn(text: 'QTE', width: 2, styles: PosStyles(bold: true)),
    PosColumn(text: 'Prix', width: 2, styles: PosStyles(bold: true)),
    PosColumn(text: 'Montant', width: 2, styles: PosStyles(bold: true)),
  ]);
  widget.articles.forEach((element) {
    ticket.row([
      (default_display == "Referance")?PosColumn(text: '${element.ref}', width: 6):PosColumn(text: '${element.designation}', width: 6),
      PosColumn(text: '${element.selectedQuantite}', width: 2),
      PosColumn(text: '${element.selectedPrice}', width: 2),
      PosColumn(text: '${element.selectedPrice * element.selectedQuantite}', width: 2),
    ]);
  });
  ticket.hr(ch: '-');
  if(_controlTotalHT){
    ticket.text("Total HT : ${widget.piece.total_ht}",
        styles:PosStyles(
            align:(default_format == PaperSize.mm80)? PosAlign.center : PosAlign.left
        ));
  }
  if(_controlTotalTva){
    ticket.text("Total TVA : ${widget.piece.total_tva}",
        styles:PosStyles(
            align:(default_format == PaperSize.mm80)? PosAlign.center : PosAlign.left
        ));
  }

  ticket.text("Regler : ${widget.piece.regler}",
      styles:PosStyles(
          align:(default_format == PaperSize.mm80)? PosAlign.center : PosAlign.left
      ));

  if(_controlReste){
    ticket.text("Reste : ${widget.piece.reste}",
        styles:PosStyles(
            align:(default_format == PaperSize.mm80)? PosAlign.center : PosAlign.left
        ));
  }
  if(_controlCredit){
    ticket.text("Total Credit : ${widget.tier.credit}",
        styles:PosStyles(
            align:(default_format == PaperSize.mm80)? PosAlign.center : PosAlign.left
        ));
  }
  ticket.hr(ch: '=');
  ticket.text("TOTAL TTC : ${widget.piece.total_ttc}",
      styles:PosStyles(
        align:(default_format == PaperSize.mm80)? PosAlign.center : PosAlign.left,
        height: PosTextSize.size2,
        width: PosTextSize.size2,));
  ticket.hr(ch: '=');
  ticket.feed(1);
  ticket.text('***BY CIRTA IT***',
      styles: PosStyles(
          align:(default_format == PaperSize.mm80)? PosAlign.center : PosAlign.left ,
          bold: true
      ));
  ticket.feed(1);
  ticket.cut();

  return ticket;
}
}
