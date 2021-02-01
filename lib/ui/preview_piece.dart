import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:charset_converter/charset_converter.dart';

enum Format { format80, format58, formatA45 }
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
  bool _controlTotalTva = false;
  bool _controlTimbre = false;
  bool _controlReste = true;
  bool _controlCredit = true;

  QueryCtr _queryCtr = new QueryCtr();
  FormatPrint formaPrint = new FormatPrint.init();
  DefaultPrinter defaultPrinter = new DefaultPrinter.init();

  ScrollController _controller = new ScrollController();

  bool directionRtl = false;

  @override
  Widget build(BuildContext context) {
    directionRtl = Helpers.isDirectionRTL(context);
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
              child: (default_format != null)
                  ? Container(
                    child: ListView(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: (default_format == PaperSize.mm80)
                                ? CrossAxisAlignment.center
                                : CrossAxisAlignment.start,

                            children: [
                              Text(
                                  "${S.current.n} ${getPiecetype()} : ${widget.piece.num_piece}"),
                              Text(
                                  "${S.current.date} :${Helpers.dateToText(widget.piece.date)}"),
                              Text("${S.current.rs} : ${widget.tier.raisonSociale}"),
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
                                  ? Text(
                                  "\n ${S.current.total_ht}:${widget.piece.total_ht}")
                                  : SizedBox(),
                              (_controlRemise)
                                  ? Text(
                                  "${S.current.remise}:${((widget.piece.total_ht*widget.piece.remise)/100)}(${widget.piece.remise}%)")
                                  : SizedBox(),
                              (_controlNetHt)
                                  ? Text("${S.current.net_ht}:${widget.piece.net_ht}")
                                  : SizedBox(),
                              (_controlTotalTva)
                                  ? Text(
                                  "${S.current.total_tva} :${widget.piece.total_tva}")
                                  : SizedBox(),
                              Text("${S.current.total} :${widget.piece.total_ttc}"),
                              (_controlTimbre)
                                  ? Text(
                                  "${S.current.timbre} :${widget.piece.timbre}")
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
                              Row(
                                children: [
                                  Expanded(
                                    child: Text("${S.current.regler} :${widget.piece.regler}"),
                                  ),
                                  Expanded(child:(_controlReste)
                                      ? Text("${S.current.reste} :${widget.piece.reste}")
                                      : SizedBox(), )
                                ],
                              ),
                              (_controlCredit)
                                  ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                      "${S.current.credit} :${widget.tier.credit} \n",
                              ),
                                    ],
                                  )
                                  : SizedBox(),
                              Text(
                                "***BY CIRTA IT***",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),

                        ],
                      ),
                  )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info,
                          color: Colors.blue,
                          size: 50,
                        ),
                        Text(
                          "${S.current.msg_pdf_view}",
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
                    Divider(
                      height: 1,
                    ),
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
                    Divider(
                      height: 1,
                    ),
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

  _printChoise() async {
    if (default_format != null) {
      Ticket ticket = await _ticket(default_format);
      await _saveFormatPrint();
      Navigator.pop(context);
      widget.ticket(ticket);
    } else {
      await _saveLanPrinter();
      await _saveFormatPrint();
      Navigator.pop(context);
      final doc = await _pdfDocument();
      await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => doc.save());
    }
  }

  Future<Ticket> _ticket(PaperSize paper) async {
    final ticket = Ticket(paper);

    if(directionRtl){
      var input = "${S.current.n} ${getPiecetype()}";
      Uint8List encArabic = await CharsetConverter.encode("ISO-8859-6", "${widget.piece.num_piece}: ${input.split('').reversed.join()}");
      ticket.textEncoded(
          encArabic,
          styles: PosStyles(
              codeTable: PosCodeTable.arabic,
              align: (default_format == PaperSize.mm80)
                  ? PosAlign.center
                  : PosAlign.left));

      input = "${S.current.date}";
      encArabic = await CharsetConverter.encode("ISO-8859-6", "${Helpers.dateToText(widget.piece.date)}: ${input.split('').reversed.join()}");
      ticket.textEncoded(encArabic,
          styles: PosStyles(
              codeTable: PosCodeTable.arabic,
              align: (default_format == PaperSize.mm80)
                  ? PosAlign.center
                  : PosAlign.left));

      input = "${S.current.rs}";
      encArabic = await CharsetConverter.encode("ISO-8859-6", "${widget.piece.raisonSociale}: ${input.split('').reversed.join()}");
      ticket.textEncoded(encArabic,
          styles: PosStyles(
              codeTable: PosCodeTable.arabic,
              align: (default_format == PaperSize.mm80)
                  ? PosAlign.center
                  : PosAlign.left));

      ticket.hr(ch: '-');
      ticket.row([
        PosColumn(
            textEncoded: await CharsetConverter.encode("ISO-8859-6", "${S.current.articles.split('').reversed.join()}"),
            width: 6,
            styles: PosStyles(bold: true , codeTable: PosCodeTable.arabic,)),
        PosColumn(
            textEncoded: await CharsetConverter.encode("ISO-8859-6", "${S.current.qte.split('').reversed.join()}"),
            width: 2,
            styles: PosStyles(bold: true, codeTable: PosCodeTable.arabic,)),
        PosColumn(
            textEncoded: await CharsetConverter.encode("ISO-8859-6", "${S.current.prix.split('').reversed.join()}"),
            width: 2,
            styles: PosStyles(bold: true, codeTable: PosCodeTable.arabic,)),
        PosColumn(
            textEncoded: await CharsetConverter.encode("ISO-8859-6", "${S.current.montant.split('').reversed.join()}"),
            width: 2,
            styles: PosStyles(bold: true, codeTable: PosCodeTable.arabic,)),
      ]);
      for(int i=0 ; i<widget.articles.length ; i++){
        var element = widget.articles[i];
        ticket.row([
          (default_display == "Referance")
              ? PosColumn(textEncoded: await CharsetConverter.encode("ISO-8859-6", "${element.ref.substring(0 , (element.ref.length<10 ? element.ref.length : 10))}"), width: 6)
              : PosColumn(textEncoded: await CharsetConverter.encode("ISO-8859-6", "${element.designation.substring(0 ,((element.designation.length<10 ? element.designation.length : 10)))}"), width: 6),
          PosColumn(text: '${element.selectedQuantite.toStringAsFixed(2)}', width: 2),
          PosColumn(text: '${element.selectedPrice.toStringAsFixed(2)}', width: 2),
          PosColumn(
              text: '${(element.selectedPrice * element.selectedQuantite).toStringAsFixed(3)}',
              width: 2),
        ]);
      }
      ticket.hr(ch:'-');
      if (_controlTotalHT) {
        input = "${S.current.total_ht}";
        encArabic = await CharsetConverter.encode("ISO-8859-6", "${widget.piece.total_ht.toStringAsFixed(2)}: ${input.split('').reversed.join()}");
        ticket.textEncoded(encArabic,
            styles: PosStyles(
                codeTable: PosCodeTable.arabic,
                align: (default_format == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }
      if (_controlRemise) {
        input = "${S.current.remise}";
        encArabic = await CharsetConverter.encode("ISO-8859-6", "(% ${widget.piece.remise}) ${((widget.piece.total_ht*widget.piece.remise)/100).toStringAsFixed(2)}: ${input.split('').reversed.join()}");
        ticket.textEncoded(encArabic,
            styles: PosStyles(
                codeTable: PosCodeTable.arabic,
                align: (default_format == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }
      if (_controlNetHt) {
        input = "${S.current.net_ht}";
        encArabic = await CharsetConverter.encode("ISO-8859-6", "${widget.piece.net_ht.toStringAsFixed(2)}: ${input.split('').reversed.join()}");
        ticket.textEncoded(encArabic,
            styles: PosStyles(
                codeTable: PosCodeTable.arabic,
                align: (default_format == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }
      if (_controlTotalTva) {
        input = "${S.current.total_tva}";
        encArabic = await CharsetConverter.encode("ISO-8859-6", "${widget.piece.total_tva.toStringAsFixed(2)}: ${input.split('').reversed.join()}");
        ticket.textEncoded(encArabic,
            styles: PosStyles(
                codeTable: PosCodeTable.arabic,
                align: (default_format == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }

      input = "${S.current.total}";
      encArabic = await CharsetConverter.encode("ISO-8859-6", "${widget.piece.total_ttc.toStringAsFixed(2)}: ${input.split('').reversed.join()}");
      ticket.textEncoded(encArabic,
          styles: PosStyles(
              codeTable: PosCodeTable.arabic,
              align: (default_format == PaperSize.mm80)
                  ? PosAlign.center
                  : PosAlign.left));

      if (_controlTimbre) {
        input = "${S.current.timbre}";
        encArabic = await CharsetConverter.encode("ISO-8859-6", "${(widget.piece.total_ttc < widget.piece.net_a_payer) ? widget.piece.timbre.toStringAsFixed(2) : 0.0}: ${input.split('').reversed.join()}");
        ticket.textEncoded(
            encArabic,
            styles: PosStyles(
                codeTable: PosCodeTable.arabic,
                align: (default_format == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }

      ticket.hr(ch: '=');
      input = "${S.current.net_payer}";
      encArabic = await CharsetConverter.encode("ISO-8859-6", "${widget.piece.net_a_payer.toStringAsFixed(2)}: ${input.split('').reversed.join()}");
      ticket.textEncoded(encArabic,
          styles: PosStyles(
            codeTable: PosCodeTable.arabic,
            align: (default_format == PaperSize.mm80)
                ? PosAlign.center
                : PosAlign.left,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          ));
      ticket.hr(ch: '=');

      ticket.row([
        PosColumn(
          textEncoded: await CharsetConverter.encode("ISO-8859-6", "${widget.piece.regler.toStringAsFixed(2)}: ${S.current.regler.split('').reversed.join()}"),
          width: 6
        ),
        (_controlReste)?PosColumn(
            textEncoded: await CharsetConverter.encode("ISO-8859-6", "${widget.piece.reste.toStringAsFixed(2)}: ${S.current.reste.split('').reversed.join()}"),
            width: 6
        ):null,
      ]);
      if (_controlCredit) {
        input = "${S.current.credit}";
        encArabic = await CharsetConverter.encode("ISO-8859-6", "${widget.tier.credit.toStringAsFixed(2)}: ${input.split('').reversed.join()}");
        ticket.textEncoded(encArabic,
            styles: PosStyles(
                codeTable: PosCodeTable.arabic));
      }

      ticket.feed(1);
      ticket.text('***BY CIRTA IT***',
          styles: PosStyles(
              align: (default_format == PaperSize.mm80)
                  ? PosAlign.center
                  : PosAlign.left,
              bold: true));
      ticket.feed(1);
      ticket.cut();

    }else{
      ticket.text(
          "${S.current.n} ${getPiecetype()}: ${widget.piece.num_piece}",
          styles: PosStyles(
              codeTable: PosCodeTable.arabic,
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
        PosColumn(
            text: '${S.current.articles}',
            width: 6,
            styles: PosStyles(bold: true)),
        PosColumn(
            text: '${S.current.qte}', width: 2, styles: PosStyles(bold: true)),
        PosColumn(
            text: '${S.current.prix}', width: 2, styles: PosStyles(bold: true)),
        PosColumn(
            text: '${S.current.montant}',
            width: 2,
            styles: PosStyles(bold: true)),
      ]);
      widget.articles.forEach((element) {
        ticket.row([
          (default_display == "Referance")
              ? PosColumn(text: '${element.ref.substring(0,(element.ref.length<10 ? element.ref.length : 10))}', width: 6)
              : PosColumn(text: '${element.designation.substring(0,(element.designation.length<10 ? element.designation.length : 10))}', width: 6),
          PosColumn(text: '${element.selectedQuantite.toStringAsFixed(2)}', width: 2),
          PosColumn(text: '${element.selectedPrice.toStringAsFixed(2)}', width: 2),
          PosColumn(
              text: '${(element.selectedPrice * element.selectedQuantite).toStringAsFixed(2)}',
              width: 2),
        ]);
      });
      ticket.hr(ch: '-');
      if (_controlTotalHT) {
        ticket.text("${S.current.total_ht} : ${widget.piece.total_ht.toStringAsFixed(2)}",
            styles: PosStyles(
                align: (default_format == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }
      if (_controlRemise) {
        ticket.text("${S.current.remise} : ${((widget.piece.total_ht * widget.piece.remise)/100).toStringAsFixed(2)} (${widget.piece.remise} %)",
            styles: PosStyles(
                align: (default_format == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }
      if (_controlNetHt) {
        ticket.text("${S.current.net_ht} : ${widget.piece.net_ht.toStringAsFixed(2)}",
            styles: PosStyles(
                align: (default_format == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }
      if (_controlTotalTva) {
        ticket.text("${S.current.total_tva} : ${widget.piece.total_tva.toStringAsFixed(2)}",
            styles: PosStyles(
                align: (default_format == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }

      ticket.text("${S.current.total} : ${widget.piece.total_ttc.toStringAsFixed(2)}",
          styles: PosStyles(
              align: (default_format == PaperSize.mm80)
                  ? PosAlign.center
                  : PosAlign.left));

      if (_controlTimbre) {
        ticket.text(
            "${S.current.timbre} : ${(widget.piece.total_ttc < widget.piece.net_a_payer) ? widget.piece.timbre.toStringAsFixed(2) : 0.0}",
            styles: PosStyles(
                align: (default_format == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }

      ticket.hr(ch: '=');
      ticket.text("${S.current.net_payer} : ${widget.piece.net_a_payer.toStringAsFixed(2)}",
          styles: PosStyles(
            align: (default_format == PaperSize.mm80)
                ? PosAlign.center
                : PosAlign.left,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          ));
      ticket.hr(ch: '=');
      ticket.row([
        PosColumn(
            text: "${S.current.regler} : ${widget.piece.regler.toStringAsFixed(2)}",
            width: 6
        ),
        (_controlReste)? PosColumn(
            text: "${S.current.reste} : ${widget.piece.reste.toStringAsFixed(2)}",
            width: 6
        ):null,
      ]);
      if (_controlCredit) {
        ticket.text("${S.current.credit} : ${widget.tier.credit.toStringAsFixed(2)}");
      }

      ticket.feed(1);
      ticket.text('***BY CIRTA IT***',
          styles: PosStyles(
              align: (default_format == PaperSize.mm80)
                  ? PosAlign.center
                  : PosAlign.left,
              bold: true));
      ticket.feed(1);
      ticket.cut();
    }

    return ticket;
  }

  Future _pdfDocument() async {
    var data = await rootBundle.load("assets/arial.ttf");
    final ttf = pw.Font.ttf(data);

    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        textDirection: (directionRtl)?pw.TextDirection.rtl:pw.TextDirection.ltr,
        build: (context) => [
          pw.Row(children: [
            pw.Expanded(
                flex: 6,
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("${S.current.rs}\t  ${widget.tier.raisonSociale}",
                          style: pw.TextStyle(font: ttf)),
                      pw.Divider(height: 2),
                      pw.Text("${S.current.adresse}\t  ${widget.tier.adresse} ",
                          style: pw.TextStyle(font: ttf)),
                      pw.Text("${S.current.ville}\t  ${widget.tier.ville}",
                          style: pw.TextStyle(font: ttf)),
                    ])),
            pw.SizedBox(width: 3),
            pw.Expanded(
                flex: 6,
                child: pw.Column(children: [
                  pw.Text("|||||||||||||||||||||||||||||||"),
                  pw.Text("${Helpers.getPieceTitle(widget.piece.piece)}",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, font: ttf)),
                  pw.Text("${S.current.n}\t  ${widget.piece.num_piece}",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, font: ttf)),
                  pw.Text(
                      "${S.current.date}\t  ${Helpers.dateToText(widget.piece.date)}",
                      style: pw.TextStyle(font: ttf)),
                ]))
          ]),
          pw.SizedBox(height: 20),
          pw.Table(children: [
            pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey),
                children: [
                  pw.Text("${S.current.referance}",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, font: ttf)),
                  pw.Text("${S.current.designation}",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, font: ttf)),
                  pw.Text("${S.current.qte}",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, font: ttf)),
                  pw.Text("${S.current.prix}",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, font: ttf)),
                  pw.Text("${S.current.montant}",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, font: ttf))
                ]),
            for (var e in widget.articles)
              pw.TableRow(children: [
                pw.Text("${e.ref}",style: pw.TextStyle(font: ttf)),
                pw.Text("${e.designation}",style: pw.TextStyle(font: ttf)),
                pw.Text("${e.selectedQuantite.toStringAsFixed(2)}",),
                pw.Text("${e.selectedPrice.toStringAsFixed(2)}",),
                pw.Text("${(e.selectedPrice * e.selectedQuantite).toStringAsFixed(2)}",),
              ]),
          ]),
          pw.SizedBox(height: 10),
          pw.Divider(height: 2),
          pw.SizedBox(height: 10),
          pw.Row(children: [
            pw.Expanded(
                flex: 6,
                child: pw.Column(children: [
                  pw.Text(
                      "${S.current.regler}\t  ${widget.piece.regler.toStringAsFixed(2)}\t  ${S.current.da}",
                      style: pw.TextStyle(font: ttf)),
                  (_controlReste)
                      ? pw.Text(
                          "${S.current.reste}\t   ${widget.piece.reste.toStringAsFixed(2)}\t  ${S.current.da}",
                          style: pw.TextStyle(font: ttf),)
                      : pw.SizedBox(),
                  (_controlCredit)
                      ? pw.Text(
                          "${S.current.credit}\t  ${widget.tier.credit.toStringAsFixed(2)}\t ${S.current.da}",
                          style: pw.TextStyle(font: ttf),)
                      : pw.SizedBox(),
                  pw.Divider(height: 2),
                  pw.SizedBox(height: 4),
                  pw.Text("${S.current.msg_visite}",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, font: ttf),),
                  pw.Text("****BY Ciratit****",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, font: ttf),),
                ])),
            pw.SizedBox(width: 10),
            pw.Expanded(
                flex: 6,
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      (_controlTotalHT)
                          ? pw.Text(
                              "${S.current.total_ht}\t ${widget.piece.total_ht.toStringAsFixed(2)}\t ${S.current.da}",
                              style: pw.TextStyle(font: ttf),
                      )
                          : pw.SizedBox(),
                      (_controlRemise)
                          ? pw.Text(
                              "${S.current.remise}\t  ${((widget.piece.total_ht*widget.piece.remise)/100).toStringAsFixed(2)} (${widget.piece.remise}\t %)\t ${S.current.da} ",
                              style: pw.TextStyle(font: ttf),
                          )
                          : pw.SizedBox(),
                      (_controlNetHt)
                          ? pw.Text(
                              "${S.current.net_ht}\t ${widget.piece.net_ht.toStringAsFixed(2)}\t ${S.current.da}",
                              style: pw.TextStyle(font: ttf),
                        )
                          : pw.SizedBox(),
                      (_controlTotalTva)
                          ? pw.Text(
                              "${S.current.total_tva}\t ${widget.piece.total_tva.toStringAsFixed(2)}\t ${S.current.da}",
                              style: pw.TextStyle(font: ttf),
                      )
                          : pw.SizedBox(),
                      pw.Text(
                          "${S.current.total}\t  ${widget.piece.total_ttc.toStringAsFixed(2)}\t  ${S.current.da}",
                          style: pw.TextStyle(font: ttf)),
                      pw.Divider(height: 2),
                      (_controlTimbre)
                          ? pw.Text(
                              "${S.current.timbre}\t ${(widget.piece.total_ttc < widget.piece.net_a_payer) ? widget.piece.timbre.toStringAsFixed(2) : 0.0}\t ${S.current.da}",
                              style: pw.TextStyle(font: ttf))
                          : pw.SizedBox(),
                      pw.Text(
                          "${S.current.net_payer}\t  ${widget.piece.net_a_payer.toStringAsFixed(2)}\t  ${S.current.da}",
                          style: pw.TextStyle(font: ttf)),
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

  Future _saveFormatPrint() async {
    formaPrint.default_format = default_format;
    formaPrint.default_display = default_display;
    formaPrint.totalHt = (_controlTotalHT) ? 1 : 0;
    formaPrint.remise = (_controlRemise) ? 1 : 0;
    formaPrint.netHt = (_controlNetHt) ? 1 : 0;
    formaPrint.totalTva = (_controlTotalTva) ? 1 : 0;
    formaPrint.timbre = (_controlTimbre) ? 1 : 0;
    formaPrint.reste = (_controlReste) ? 1 : 0;
    formaPrint.credit = (_controlCredit) ? 1 : 0;
    await _queryCtr.addItemToTable(DbTablesNames.formatPrint, formaPrint);
  }

  String getPiecetype(){
    switch(widget.piece.piece){
      case "FP":
        return S.current.fp;
        break ;
      case "CC":
        return S.current.cc;
        break ;
      case "BL":
        return S.current.bl;
        break ;
      case "FC":
        return S.current.fc;
        break ;
      case "RC":
        return S.current.rc;
        break ;
      case "AC":
        return S.current.ac;
        break ;
      case "BC":
        return S.current.bc;
        break ;
      case "BR":
        return S.current.br;
        break ;
      case "FF":
        return S.current.ff;
        break ;
      case "RF":
        return S.current.rf;
        break ;
      case "AF":
        return S.current.af;
        break ;
    }
  }
}
