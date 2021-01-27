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

enum Format { format80, format58 }
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
  bool _controlTotalTva = true;
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
              var doc01 = _pdfDocument();
              await Printing.sharePdf(
                  bytes: await doc01.save(), filename: 'my-document.pdf');
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.QUESTION,
            animType: AnimType.BOTTOMSLIDE,
            title: S.current.supp,
            body: addChoicesDialog(),
            closeIcon: Icon(
              Icons.remove_circle_outline_sharp,
              color: Colors.red,
              size: 26,
            ),
            showCloseIcon: true,
          )..show();
        },
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: (default_format == PaperSize.mm80)
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  Text("N° ${widget.piece.piece} : ${widget.piece.num_piece}"),
                  Text("Date :${Helpers.dateToText(widget.piece.date)}"),
                  Text("Tier : Client01"),
                  Text(
                      "----------------------------------------------------------------------------------------"),
                  Table(
                    columnWidths: {0: FractionColumnWidth(.4)},
                    children: [
                      TableRow(children: [
                        Text(
                          "Item",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "QTE",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Prix",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Monatant",
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
                      ? Text("\n Total HT:${widget.piece.total_ht}")
                      : SizedBox(),
                  (_controlTotalTva)
                      ? Text("Total TVA :${widget.piece.total_tva}")
                      : SizedBox(),
                  Text("Regler :${widget.piece.regler}"),
                  (_controlReste)
                      ? Text("Reste :${widget.piece.reste}")
                      : SizedBox(),
                  (_controlCredit)
                      ? Text("Total Credit :${widget.tier.credit} \n")
                      : SizedBox(),
                  Text("============================================"),
                  Text(
                    "Total TTC :${widget.piece.total_ttc}",
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
                    ]),
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

  Widget addChoicesDialog() {
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Builder(
          builder: (context) => SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Wrap(spacing: 13, runSpacing: 13, children: [
                    Center(
                        child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        "${S.current.choisir_action}: ",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )),
                    SizedBox(
                      width: 320.0,
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(end: 0, start: 0),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          onPressed: () async {
                            await _saveLanPrinter();
                            Navigator.pop(context);
                            Navigator.pop(context);
                            final doc = _pdfDocument();
                            await Printing.layoutPdf(
                                onLayout: (PdfPageFormat format) async =>
                                    doc.save());
                          },
                          child: Text(
                            "Local Printer",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 320.0,
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(end: 0, start: 0),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          onPressed: () async {
                            Navigator.pop(context);
                            Ticket ticket = await _ticket(default_format);
                            formaPrint.default_format = default_format;
                            formaPrint.default_display = default_display;
                            formaPrint.totalHt = (_controlTotalHT) ? 1 : 0;
                            formaPrint.totalTva = (_controlTotalTva) ? 1 : 0;
                            formaPrint.reste = (_controlReste) ? 1 : 0;
                            formaPrint.credit = (_controlCredit) ? 1 : 0;
                            await _queryCtr.addItemToTable(
                                DbTablesNames.formatPrint, formaPrint);

                            Navigator.pop(context);
                            widget.ticket(ticket);
                          },
                          child: Text(
                            "Bluetooth printer",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ]),
                ),
              ));
    });
  }

  Future<Ticket> _ticket(PaperSize paper) async {
    final ticket = Ticket(paper);

    ticket.text("N° ${widget.piece.piece}: ${widget.piece.num_piece}",
        styles: PosStyles(
            align: (default_format == PaperSize.mm80)
                ? PosAlign.center
                : PosAlign.left));
    ticket.text("Date : ${Helpers.dateToText(widget.piece.date)}",
        styles: PosStyles(
            align: (default_format == PaperSize.mm80)
                ? PosAlign.center
                : PosAlign.left));
    ticket.text("Tier : ${widget.piece.raisonSociale}",
        styles: PosStyles(
            align: (default_format == PaperSize.mm80)
                ? PosAlign.center
                : PosAlign.left));
    ticket.hr(ch: '-');
    ticket.row([
      PosColumn(text: 'Item', width: 6, styles: PosStyles(bold: true)),
      PosColumn(text: 'QTE', width: 2, styles: PosStyles(bold: true)),
      PosColumn(text: 'Prix', width: 2, styles: PosStyles(bold: true)),
      PosColumn(text: 'Montant', width: 2, styles: PosStyles(bold: true)),
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
      ticket.text("Total HT : ${widget.piece.total_ht}",
          styles: PosStyles(
              align: (default_format == PaperSize.mm80)
                  ? PosAlign.center
                  : PosAlign.left));
    }
    if (_controlTotalTva) {
      ticket.text("Total TVA : ${widget.piece.total_tva}",
          styles: PosStyles(
              align: (default_format == PaperSize.mm80)
                  ? PosAlign.center
                  : PosAlign.left));
    }

    ticket.text("Regler : ${widget.piece.net_ht}",
        styles: PosStyles(
            align: (default_format == PaperSize.mm80)
                ? PosAlign.center
                : PosAlign.left));

    ticket.text("Regler : ${widget.piece.regler}",
        styles: PosStyles(
            align: (default_format == PaperSize.mm80)
                ? PosAlign.center
                : PosAlign.left));

    if (_controlReste) {
      ticket.text("Reste : ${widget.piece.reste}",
          styles: PosStyles(
              align: (default_format == PaperSize.mm80)
                  ? PosAlign.center
                  : PosAlign.left));
    }
    if (_controlCredit) {
      ticket.text("Total Credit : ${widget.tier.credit}",
          styles: PosStyles(
              align: (default_format == PaperSize.mm80)
                  ? PosAlign.center
                  : PosAlign.left));
    }
    ticket.hr(ch: '=');
    ticket.text("TOTAL TTC : ${widget.piece.net_a_payer}",
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

  _pdfDocument() {
    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Center(child: pw.Text("Téléphone : 0000000000")),
                pw.Center(child: pw.Text("Email : 0000000000"))
              ]),
          pw.SizedBox(height: 10),
          pw.Row(children: [
            pw.Expanded(
                flex: 6,
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Client RS : ${widget.tier.raisonSociale} "),
                      pw.Divider(height: 2),
                      pw.Text("Adresse : ${widget.tier.adresse} "),
                      pw.Text("Ville : ${widget.tier.ville}"),
                    ])),
            pw.SizedBox(width: 3),
            pw.Expanded(
                flex: 6,
                child: pw.Column(children: [
                  pw.Text("|||||||||||||||||||||||||||||||"),
                  pw.Text("Bon de Comptoir",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text("N°: 002/02222",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text("Date: 02/22/2200"),
                ]))
          ]),
          pw.SizedBox(height: 20),
          pw.Table(
            children:[
              pw.TableRow(
                  decoration: pw.BoxDecoration(color: PdfColors.grey),
                  children: [
                    pw.Text("Referance",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text("Designation",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text("QTE",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text("Prix-U",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text("Montant",
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
                  pw.Text("Merci pour Votre Visite",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text("****BY Ciratit****",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ])),
            pw.Expanded(
                flex: 6,
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Total HT : ${widget.piece.total_ht} DZD"),
                      pw.Text("Remise : ${widget.piece.remise} %"),
                      pw.Text("Net-HT : ${widget.piece.net_ht} DZD"),
                      pw.Divider(height: 2),
                      pw.Text("Total Tva : ${widget.piece.total_tva} DZD"),
                      pw.Text("Net-Payer : ${widget.piece.net_a_payer} DZD"),
                      pw.Divider(height: 2),
                    ])),
            pw.SizedBox(width: 3),
          ]),

        ],
      ),
    );

    return doc;
  }

  List _getArticleList(){
    List list = new List();

     final header = pw.TableRow(
        decoration: pw.BoxDecoration(color: PdfColors.grey),
        children: [
          pw.Text("Referance",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text("Designation",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text("qte",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text("prix u",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text("montant",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
        ]);

    list.add(header);

    for(int i =0 ; i<25 ; i++){
      var widget = pw.TableRow(children: [
        pw.Text("gzgjzgebkz zign gzvnbzg "),
        pw.Text("f gghng zkeg z gge zke g "),
        pw.Text("1000000"),
        pw.Text("9999999"),
        pw.Text("1000000000000")
      ]);
      list.add(widget);
    }

    return list ;
  }

  Future _saveLanPrinter() async {
    defaultPrinter.name = "lan printer";
    defaultPrinter.adress = "192.168.1.1";
    defaultPrinter.type = 0;
    await _queryCtr.addItemToTable(
        DbTablesNames.defaultPrinter, defaultPrinter);
  }
}
