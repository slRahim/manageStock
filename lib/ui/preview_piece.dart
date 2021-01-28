import 'dart:io';
import 'dart:ui';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/Article.dart';
import 'package:gestmob/models/DefaultPrinter.dart';
import 'package:gestmob/models/FormatPrint.dart';
import 'package:gestmob/models/Piece.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:gestmob/models/Tiers.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

enum Format { format80, format58 , formatA45 }
enum Display { referance, designation }

class PreviewPiece extends StatefulWidget {
  final Piece piece;
  final ValueChanged ticket;
  final List<Article> articles;
  final Tiers tier;

  PreviewPiece({
    Key key,
    @required this.piece,
    this.articles,
    this.tier,
    this.ticket,
  }) : super(key: key);

  @override
  _PreviewPieceState createState() => _PreviewPieceState();
}

class _PreviewPieceState extends State<PreviewPiece> {
  PaperSize default_format = PaperSize.mm80;

  String default_display = "Referance";
  Format _format = Format.format80;
  Display _item = Display.referance;
  bool _controlTotalHT = true;
  bool _controlRemise = true;
  bool _controlNetHt = true;
  bool _controlTotalTva = true;
  bool _controlTimbre = true;
  bool _controlReste = true;
  bool _controlCredit = true;

  QueryCtr _queryCtr = new QueryCtr();
  FormatPrint formaPrint = new FormatPrint.init();
  DefaultPrinter defaultPrinter = new DefaultPrinter.init();

  ScrollController _controller = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: InkWell(
          child: Icon(Icons.arrow_back),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text(S.current.preview_titre),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () async {
              var doc01 = await _pdfDocument();
              await Printing.sharePdf(
                  bytes: await doc01.save(), filename: 'my-document.pdf');
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _printChoise(),
        child: Icon(
          Icons.print_rounded,
          color: Colors.white,
          size: 30,
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ListView(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2,
              padding: EdgeInsets.symmetric(horizontal: 5),
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
              child: (default_format != null)? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: (default_format == PaperSize.mm80)
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  Text("N° ${widget.piece.piece} : ${widget.piece.num_piece}"),
                  Text("${S.current.date} :${Helpers.dateToText(widget.piece.date)}"),
                  Text("${S.current.rs} : Client01"),
                  Text(
                      "----------------------------------------------------------------------------------------"),
                  Table(
                    columnWidths: {0: FractionColumnWidth(.4)},
                    children: [
                      TableRow(children: [
                        Text(
                          "${S.current.articles}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${S.current.qte}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${S.current.prix}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${S.current.montant}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ]),
                      TableRow(children: [
                        (default_display != "Referance")
                            ? Text("Article1")
                            : Text("Ref01"),
                        Text("XXX"),
                        Text("XXX"),
                        Text("XXX"),
                      ]),
                      TableRow(children: [
                        (default_display != "Referance")
                            ? Text("Article2")
                            : Text("Ref02"),
                        Text("XXX"),
                        Text("XXX"),
                        Text("XXX"),
                      ]),
                    ],
                  ),
                  Text(
                      "---------------------------------------------------------------------------------------"),
                  (_controlTotalHT)
                      ? Text("\n ${S.current.total_ht}:${widget.piece.total_ht}")
                      : SizedBox(),
                  (_controlRemise)
                      ? Text("${S.current.remise}:${widget.piece.remise}%")
                      : SizedBox(),
                  (_controlNetHt)
                      ? Text("${S.current.net_ht}:${widget.piece.net_ht}")
                      : SizedBox(),
                  (_controlTotalTva)
                      ? Text("${S.current.total_tva} :${widget.piece.total_tva}")
                      : SizedBox(),
                  (_controlTimbre)
                      ? Text("${S.current.timbre} :${widget.piece.timbre}")
                      : SizedBox(),
                  Text("${S.current.regler} :${widget.piece.regler}"),
                  (_controlReste)
                      ? Text("${S.current.reste} :${widget.piece.reste}")
                      : SizedBox(),
                  (_controlCredit)
                      ? Text("${S.current.credit} :${widget.tier.credit} \n")
                      : SizedBox(),
                  Text("============================================"),
                  Text(
                    "${S.current.net_payer} :${widget.piece.net_a_payer}",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text("============================================"),
                  SizedBox(
                    height: 17,
                  ),
                  Text(
                    "***BY CIRTA IT***",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              )
              :Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info,color: Colors.blue, size: 50,),
                  Text("${S.current.msg_pdf_view}", style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: MediaQuery.of(context).size.height / 3,
              child: Scrollbar(
                isAlwaysShown: true,
                controller: _controller,
                child: ListView(
                  controller: _controller,
                  children: [
                    Column(children: [
                      RadioListTile<Format>(
                        title: Text(S.current.format_80),
                        value: Format.format80,
                        groupValue: _format,
                        onChanged: (Format value) {
                          setState(() {
                            _format = value;
                            default_format = PaperSize.mm80;
                          });
                        },
                      ),
                      RadioListTile<Format>(
                        title: Text(S.current.format_58),
                        value: Format.format58,
                        groupValue: _format,
                        onChanged: (Format value) {
                          setState(() {
                            _format = value;
                            default_format = PaperSize.mm58;
                          });
                        },
                      ),
                      RadioListTile<Format>(
                        title: Text("${S.current.format_a45}"),
                        value: Format.formatA45,
                        groupValue: _format,
                        onChanged: (Format value) {
                          setState(() {
                            _format = value;
                            default_format = null;
                          });
                        },
                      ),
                    ]),
                    Divider(height: 1,),
                    Column(children: [
                      RadioListTile<Display>(
                        title: Text(S.current.par_ref),
                        value: Display.referance,
                        groupValue: _item,
                        onChanged: (Display value) {
                          setState(() {
                            _item = value;
                            default_display = "Referance";
                          });
                        },
                      ),
                      RadioListTile<Display>(
                        title: Text(S.current.par_desgn),
                        value: Display.designation,
                        groupValue: _item,
                        onChanged: (Display value) {
                          setState(() {
                            _item = value;
                            default_display = "Designation";
                          });
                        },
                      ),
                    ]),
                    Divider(height: 1,),
                    CheckboxListTile(
                      title: Text(
                        S.current.total_ht,
                        maxLines: 1,
                      ),
                      value: _controlTotalHT,
                      onChanged: (bool value) {
                        setState(() {
                          _controlTotalHT = value;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text(
                        "${S.current.remise}",
                        maxLines: 1,
                      ),
                      value: _controlRemise,
                      onChanged: (bool value) {
                        setState(() {
                          _controlRemise = value;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text(
                        "${S.current.net_ht}",
                        maxLines: 1,
                      ),
                      value: _controlNetHt,
                      onChanged: (bool value) {
                        setState(() {
                          _controlNetHt = value;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text(
                        S.current.total_tva,
                        maxLines: 1,
                      ),
                      value: _controlTotalTva,
                      onChanged: (bool value) {
                        setState(() {
                          _controlTotalTva = value;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text(
                        "${S.current.timbre}",
                        maxLines: 1,
                      ),
                      value: _controlTimbre,
                      onChanged: (bool value) {
                        setState(() {
                          _controlTimbre = value;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text(
                        S.current.reste,
                        maxLines: 1,
                      ),
                      value: _controlReste,
                      onChanged: (bool value) {
                        setState(() {
                          _controlReste = value;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text(
                        "${S.current.total} ${S.current.credit}",
                        maxLines: 1,
                      ),
                      value: _controlCredit,
                      onChanged: (bool value) {
                        setState(() {
                          _controlCredit = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _printChoise() async{
    if(default_format != null){
      Ticket ticket = await _ticket(default_format);
      await _saveFormatPrint();
      Navigator.pop(context);
      widget.ticket(ticket);

    }else{
      await _saveLanPrinter();
      await _saveFormatPrint();
      Navigator.pop(context);
      final doc = await _pdfDocument();
      await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async =>
              doc.save());
    }
  }

  Future<Ticket> _ticket(PaperSize paper) async {
    final ticket = Ticket(paper);

    ticket.text("N° ${widget.piece.piece}: ${widget.piece.num_piece}",
        styles: PosStyles(
            align: (default_format == PaperSize.mm80)
                ? PosAlign.center
                : PosAlign.left));
    ticket.text("${S.current.date} : ${Helpers.dateToText(widget.piece.date)}",
        styles: PosStyles(
            align: (default_format == PaperSize.mm80)
                ? PosAlign.center
                : PosAlign.left));
    ticket.text("${S.current.rs} : ${widget.piece.raisonSociale}",
        styles: PosStyles(
            align: (default_format == PaperSize.mm80)
                ? PosAlign.center
                : PosAlign.left));
    ticket.hr(ch: '-');
    ticket.row([
      PosColumn(text: '${S.current.articles}', width: 6, styles: PosStyles(bold: true)),
      PosColumn(text: '${S.current.qte}', width: 2, styles: PosStyles(bold: true)),
      PosColumn(text: '${S.current.prix}', width: 2, styles: PosStyles(bold: true)),
      PosColumn(text: '${S.current.montant}', width: 2, styles: PosStyles(bold: true)),
    ]);
    widget.articles.forEach((element) {
      ticket.row([
        (default_display == "Referance")
            ? PosColumn(text: '${element.ref}', width: 6)
            : PosColumn(text: '${element.designation}', width: 6),

        PosColumn(text: '${element.selectedQuantite}', width: 2),
        PosColumn(text: '${element.selectedPrice}', width: 2),
        PosColumn(
            text: '${element.selectedPrice * element.selectedQuantite}',
            width: 2),
      ]);
    });
    ticket.hr(ch: '-');
    if (_controlTotalHT) {
      ticket.text("${S.current.total_ht} : ${widget.piece.total_ht}",
          styles: PosStyles(
              align: (default_format == PaperSize.mm80)
                  ? PosAlign.center
                  : PosAlign.left));
    }
    if(_controlRemise){
      ticket.text("${S.current.remise} : ${widget.piece.remise} %",
          styles: PosStyles(
              align: (default_format == PaperSize.mm80)
                  ? PosAlign.center
                  : PosAlign.left));
    }
    if(_controlNetHt){
      ticket.text("${S.current.net_ht} : ${widget.piece.net_ht}",
          styles: PosStyles(
              align: (default_format == PaperSize.mm80)
                  ? PosAlign.center
                  : PosAlign.left));
    }
    if (_controlTotalTva) {
      ticket.text("${S.current.total_tva} : ${widget.piece.total_tva}",
          styles: PosStyles(
              align: (default_format == PaperSize.mm80)
                  ? PosAlign.center
                  : PosAlign.left));
    }

    if(_controlTimbre){
      ticket.text("${S.current.timbre} : ${(widget.piece.total_ttc == widget.piece.net_a_payer)?widget.piece.timbre:0.0}",
          styles: PosStyles(
              align: (default_format == PaperSize.mm80)
                  ? PosAlign.center
                  : PosAlign.left));
    }

    ticket.text("${S.current.regler} : ${widget.piece.regler}",
        styles: PosStyles(
            align: (default_format == PaperSize.mm80)
                ? PosAlign.center
                : PosAlign.left));


    if (_controlReste) {
      ticket.text("${S.current.reste} : ${widget.piece.reste}",
          styles: PosStyles(
              align: (default_format == PaperSize.mm80)
                  ? PosAlign.center
                  : PosAlign.left));
    }
    if (_controlCredit) {
      ticket.text("${S.current.credit} : ${widget.tier.credit}",
          styles: PosStyles(
              align: (default_format == PaperSize.mm80)
                  ? PosAlign.center
                  : PosAlign.left));
    }
    ticket.hr(ch: '=');
    ticket.text("${S.current.net_payer} : ${widget.piece.net_a_payer}",
        styles: PosStyles(
          align: (default_format == PaperSize.mm80)
              ? PosAlign.center
              : PosAlign.left,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));
    ticket.hr(ch: '=');
    ticket.feed(1);
    ticket.text('***BY CIRTA IT***',
        styles: PosStyles(
            align: (default_format == PaperSize.mm80)
                ? PosAlign.center
                : PosAlign.left,
            bold: true));
    ticket.feed(1);
    ticket.cut();

    return ticket;
  }

  Future _pdfDocument() async{
    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Center(child: pw.Text("${S.current.telephone} : 0000000000")),
                pw.Center(child: pw.Text("${S.current.mail} : 0000000000"))
              ]),
          pw.SizedBox(height: 10),
          pw.Row(children: [
            pw.Expanded(
                flex: 6,
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("${S.current.rs} : ${widget.tier.raisonSociale} "),
                      pw.Divider(height: 2),
                      pw.Text("${S.current.adresse} : ${widget.tier.adresse} "),
                      pw.Text("${S.current.ville} : ${widget.tier.ville}"),
                    ])),
            pw.SizedBox(width: 3),
            pw.Expanded(
                flex: 6,
                child: pw.Column(children: [
                  pw.Text("|||||||||||||||||||||||||||||||"),
                  pw.Text("${Helpers.getPieceTitle(widget.piece.piece)}",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text("N°: ${widget.piece.num_piece}",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text("${S.current.date}: ${Helpers.dateToText(widget.piece.date)}"),
                ]))
          ]),
          pw.SizedBox(height: 20),
          pw.Table(
            children:[
              pw.TableRow(
                  decoration: pw.BoxDecoration(color: PdfColors.grey),
                  children: [
                    pw.Text("${S.current.referance}",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text("${S.current.designation}",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text("${S.current.qte}",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text("${S.current.prix}",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text("${S.current.montant}",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
                  ]),
              for(var e in widget.articles) pw.TableRow(children: [
                    pw.Text("${e.ref}"),
                    pw.Text("${e.designation}"),
                    pw.Text("${e.selectedQuantite}"),
                    pw.Text("${e.selectedPrice}"),
                    pw.Text("${e.selectedPrice*e.selectedQuantite}"),
                ]),

            ]
          ),
          pw.SizedBox(height: 10),
          pw.Divider(height: 2),
          pw.SizedBox(height: 10),
          pw.Row(children: [
            pw.Expanded(
                flex: 6,
                child: pw.Column(children: [
                  pw.Text("${S.current.regler} : ${widget.piece.regler} DZD"),
                  (_controlReste)?pw.Text("${S.current.reste} : ${widget.piece.reste} DZD"):pw.SizedBox(),
                  (_controlCredit)?pw.Text("${S.current.credit} : ${widget.tier.credit} DZD"):pw.SizedBox(),
                  pw.Divider(height: 2),
                  pw.SizedBox(height: 4),
                  pw.Text("${S.current.msg_visite}",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text("****BY Ciratit****",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ])),
            pw.SizedBox(width: 10),
            pw.Expanded(
                flex: 6,
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      (_controlTotalHT)?pw.Text("${S.current.total_ht} : ${widget.piece.total_ht} ${S.current.da}"):pw.SizedBox(),
                      (_controlRemise)?pw.Text("${S.current.remise} : ${widget.piece.remise} %"):pw.SizedBox(),
                      (_controlNetHt)?pw.Text("${S.current.net_ht} : ${widget.piece.net_ht} ${S.current.da}"):pw.SizedBox(),
                      pw.Divider(height: 2),
                      (_controlTotalTva)?pw.Text("${S.current.total_tva} : ${widget.piece.total_tva} ${S.current.da}"):pw.SizedBox(),
                      (_controlTimbre)?pw.Text("${S.current.timbre} : ${(widget.piece.total_ttc == widget.piece.net_a_payer)?widget.piece.timbre:0.0} ${S.current.da}"):pw.SizedBox(),
                      pw.Text("${S.current.net_payer} : ${widget.piece.net_a_payer} ${S.current.da}"),
                      pw.Divider(height: 2),
                    ])),
            pw.SizedBox(width: 3),
          ]),

        ],
      ),
    );

    return doc;
  }

  Future _saveLanPrinter() async {
    defaultPrinter.name = "lan printer";
    defaultPrinter.adress = "192.168.1.1";
    defaultPrinter.type = 0;
    await _queryCtr.addItemToTable(
        DbTablesNames.defaultPrinter, defaultPrinter);
  }

  Future _saveFormatPrint()async{
    formaPrint.default_format = default_format;
    formaPrint.default_display = default_display;
    formaPrint.totalHt = (_controlTotalHT) ? 1 : 0;
    formaPrint.remise = (_controlRemise) ? 1 : 0;
    formaPrint.netHt = (_controlNetHt) ? 1 : 0;
    formaPrint.totalTva = (_controlTotalTva) ? 1 : 0;
    formaPrint.timbre = (_controlTimbre) ? 1 : 0;
    formaPrint.reste = (_controlReste) ? 1 : 0;
    formaPrint.credit = (_controlCredit) ? 1 : 0;
    await _queryCtr.addItemToTable(
        DbTablesNames.formatPrint, formaPrint);
  }
}
