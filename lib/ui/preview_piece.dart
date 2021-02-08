import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/Article.dart';
import 'package:gestmob/models/DefaultPrinter.dart';
import 'package:gestmob/models/MyParams.dart';
import 'package:gestmob/models/Piece.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:gestmob/models/Tiers.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:charset_converter/charset_converter.dart';

class PreviewPiece extends StatefulWidget {
  final Piece piece;
  final ValueChanged ticket;
  final List<Article> articles;
  final Tiers tier;
  final int format;
  final pdfDoc ;

  PreviewPiece(
      {Key key,
      @required this.piece,
      this.articles,
      this.tier,
      this.ticket,
      this.format,
      this.pdfDoc})
      : super(key: key);

  @override
  _PreviewPieceState createState() => _PreviewPieceState();
}

class _PreviewPieceState extends State<PreviewPiece> {
  bool _finishedLoading = false;
  PaperSize _default_format;
  QueryCtr _queryCtr = new QueryCtr();
  MyParams _myParams ;
  PDFDocument _doc;

  bool directionRtl = false;

  @override
  void initState() {
    super.initState();
    _default_format = (widget.format == 80) ? PaperSize.mm80 : PaperSize.mm58;
    futureInit().then((value) {
      setState(() {
        _finishedLoading = true;
      });
    });
  }

  futureInit() async {
    if(widget.pdfDoc != null){
      final output = await getTemporaryDirectory();
      final file = File("${output.path}/my-document.pdf");
      await file.writeAsBytes(await widget.pdfDoc.save());

      _doc = await PDFDocument.fromFile(file);

    }else{
       _myParams = await _queryCtr.getAllParams() ;

    }
  }

  Future updateFormatPrint() async{
    switch(widget.format){
      case 80 :
        _myParams.defaultFormatPrint = PaperSize.mm80 ;
        break ;
      case 58 :
        _myParams.defaultFormatPrint = PaperSize.mm58 ;
        break ;
    }
    await _queryCtr.updateItemInDb(DbTablesNames.myparams, _myParams);
  }

  @override
  Widget build(BuildContext context) {
    directionRtl = Helpers.isDirectionRTL(context);
    if (!_finishedLoading) {
      return Scaffold(body: Helpers.buildLoading());
    } else {
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
          ),
          body: (widget.format == 45)
              ? PDFViewer(
                document: _doc,
                showIndicator: true,
                lazyLoad: true,
              )
              : Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: EdgeInsets.all(10),
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
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: (_default_format == PaperSize.mm80)
                            ? CrossAxisAlignment.center
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                              "${S.current.n} ${getPiecetype()} : ${widget.piece.num_piece}" , style: TextStyle(color: Colors.black),),
                          Text(
                              "${S.current.date} :${Helpers.dateToText(widget.piece.date)}", style: TextStyle(color: Colors.black),),
                          Text(
                              "${S.current.rs} : ${widget.tier.raisonSociale}", style: TextStyle(color: Colors.black),),
                          Text(
                              "----------------------------------------------------------------------------------------", style: TextStyle(color: Colors.black),),
                          Table(
                            columnWidths: {0: FractionColumnWidth(.4)},
                            children: [
                              TableRow(children: [
                                Text(
                                  "${S.current.articles}",
                                  style: TextStyle(fontWeight: FontWeight.bold ,color: Colors.black),
                                ),
                                Text(
                                  "${S.current.qte}",
                                  style: TextStyle(fontWeight: FontWeight.bold , color: Colors.black),
                                ),
                                Text(
                                  "${S.current.prix}",
                                  style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
                                ),
                                Text(
                                  "${S.current.montant}",
                                  style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
                                ),
                              ]),
                              TableRow(children: [
                                (_myParams.printDisplay != 0)
                                    ? Text("Article1", style: TextStyle(color: Colors.black),)
                                    : Text("Ref01", style: TextStyle(color: Colors.black),),
                                Text("XXX", style: TextStyle(color: Colors.black),),
                                Text("XXX", style: TextStyle(color: Colors.black),),
                                Text("XXX", style: TextStyle(color: Colors.black),),
                              ]),
                              TableRow(children: [
                                (_myParams.printDisplay  != 0)
                                    ? Text("Article2", style: TextStyle(color: Colors.black),)
                                    : Text("Ref02", style: TextStyle(color: Colors.black),),
                                Text("XXX", style: TextStyle(color: Colors.black),),
                                Text("XXX", style: TextStyle(color: Colors.black),),
                                Text("XXX", style: TextStyle(color: Colors.black),),
                              ]),
                            ],
                          ),
                          Text(
                              "---------------------------------------------------------------------------------------", style: TextStyle(color: Colors.black),),
                          (widget.piece.total_tva > 0)
                              ? Text(
                                  "\n ${S.current.total_ht}:${Helpers.numberFormat(widget.piece.total_ht)}", style: TextStyle(color: Colors.black),)
                              : SizedBox(),
                          (widget.piece.remise > 0)
                              ? Text(
                                  "${S.current.remise}:${Helpers.numberFormat((widget.piece.total_ht * widget.piece.remise) / 100)}(${Helpers.numberFormat(widget.piece.remise)}%)"
                            , style: TextStyle(color: Colors.black),)
                              : SizedBox(),
                          (widget.piece.remise > 0)
                              ? Text(
                                  "${S.current.net_ht}:${Helpers.numberFormat(widget.piece.net_ht)}", style: TextStyle(color: Colors.black),)
                              : SizedBox(),
                          (widget.piece.total_tva > 0)
                              ? Text(
                                  "${S.current.total_tva} :${Helpers.numberFormat(widget.piece.total_tva)}", style: TextStyle(color: Colors.black),)
                              : SizedBox(),
                          (widget.piece.total_tva > 0)
                              ? Text(
                                  "${S.current.total} :${Helpers.numberFormat(widget.piece.total_ttc)}", style: TextStyle(color: Colors.black),)
                              : SizedBox(),
                          (_myParams.timbre)
                              ? Text(
                                  "${S.current.timbre} :${Helpers.numberFormat(widget.piece.timbre)}", style: TextStyle(color: Colors.black),)
                              : SizedBox(),
                          Text("============================================", style: TextStyle(color: Colors.black),),
                          Text(
                            "${S.current.net_payer} :${Helpers.numberFormat(widget.piece.net_a_payer)}",
                            style: TextStyle(fontSize: 20,color: Colors.black),
                          ),
                          Text("============================================", style: TextStyle(color: Colors.black),),
                          SizedBox(
                            height: 17,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                    "${S.current.regler} :${Helpers.numberFormat(widget.piece.regler)}", style: TextStyle(color: Colors.black),),
                              ),
                              Expanded(
                                child: (widget.piece.reste > 0)
                                    ? Text(
                                        "${S.current.reste} :${Helpers.numberFormat(widget.piece.reste)}", style: TextStyle(color: Colors.black),)
                                    : SizedBox(),
                              )
                            ],
                          ),
                          (_myParams.creditTier)
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${S.current.credit} :${Helpers.numberFormat(widget.tier.credit)} \n",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                )
                              : SizedBox(),
                          Text(
                            "***BY CIRTA IT***",
                            style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          floatingActionButton: (widget.format == 45)
              ? FloatingActionButton(
                  backgroundColor: Colors.blue,
                  onPressed: ()async {
                    await Printing.sharePdf(bytes: await widget.pdfDoc.save(), filename: 'my-document.pdf');
                  },
                  child: Icon(
                    Icons.share,
                    color: Colors.white,
                    size: 30,
                  ),
                )
              : FloatingActionButton(
                  onPressed: () async {
                    await updateFormatPrint();
                    Ticket ticket = await _ticket(_default_format);
                    Navigator.pop(context);
                    widget.ticket(ticket);
                  },
                  child: Icon(
                    Icons.print_rounded,
                    color: Theme.of(context).floatingActionButtonTheme.foregroundColor,
                    size: 30,
                  ),
                ));
    }
  }

  Future<Ticket> _ticket(PaperSize paper) async {
    final ticket = Ticket(paper);

    if (directionRtl) {
      var input = "${S.current.n} ${getPiecetype()}";
      Uint8List encArabic = await CharsetConverter.encode("ISO-8859-6",
          "${widget.piece.num_piece}: ${input.split('').reversed.join()}");
      ticket.textEncoded(encArabic,
          styles: PosStyles(
              codeTable: PosCodeTable.arabic,
              align: (_default_format == PaperSize.mm80)
                  ? PosAlign.center
                  : PosAlign.left));

      input = "${S.current.date}";
      encArabic = await CharsetConverter.encode("ISO-8859-6",
          "${Helpers.dateToText(widget.piece.date)}: ${input.split('').reversed.join()}");
      ticket.textEncoded(encArabic,
          styles: PosStyles(
              codeTable: PosCodeTable.arabic,
              align: (_default_format == PaperSize.mm80)
                  ? PosAlign.center
                  : PosAlign.left));

      input = "${S.current.rs}";
      encArabic = await CharsetConverter.encode("ISO-8859-6",
          "${widget.piece.raisonSociale}: ${input.split('').reversed.join()}");
      ticket.textEncoded(encArabic,
          styles: PosStyles(
              codeTable: PosCodeTable.arabic,
              align: (_default_format == PaperSize.mm80)
                  ? PosAlign.center
                  : PosAlign.left));

      ticket.hr(ch: '-');
      ticket.row([
        PosColumn(
            textEncoded: await CharsetConverter.encode("ISO-8859-6",
                "${S.current.articles.split('').reversed.join()}"),
            width: 6,
            styles: PosStyles(
              bold: true,
              codeTable: PosCodeTable.arabic,
            )),
        PosColumn(
            textEncoded: await CharsetConverter.encode(
                "ISO-8859-6", "${S.current.qte.split('').reversed.join()}"),
            width: 2,
            styles: PosStyles(
              bold: true,
              codeTable: PosCodeTable.arabic,
            )),
        PosColumn(
            textEncoded: await CharsetConverter.encode(
                "ISO-8859-6", "${S.current.prix.split('').reversed.join()}"),
            width: 2,
            styles: PosStyles(
              bold: true,
              codeTable: PosCodeTable.arabic,
            )),
        PosColumn(
            textEncoded: await CharsetConverter.encode(
                "ISO-8859-6", "${S.current.montant.split('').reversed.join()}"),
            width: 2,
            styles: PosStyles(
              bold: true,
              codeTable: PosCodeTable.arabic,
            )),
      ]);
      for (int i = 0; i < widget.articles.length; i++) {
        var element = widget.articles[i];
        ticket.row([
          (_myParams.printDisplay == 0)
              ? PosColumn(
                  textEncoded: await CharsetConverter.encode("ISO-8859-6",
                      "${element.ref.substring(0, (element.ref.length < 8 ? element.ref.length : 8))}"),
                  width: 6)
              : PosColumn(
                  textEncoded: await CharsetConverter.encode("ISO-8859-6",
                      "${element.designation.substring(0, ((element.designation.length < 8 ? element.designation.length : 8)))}"),
                  width: 6),
          PosColumn(
              text: '${Helpers.numberFormat(element.selectedQuantite).toString()}', width: 2),
          PosColumn(
              text: '${Helpers.numberFormat(element.selectedPrice).toString()}', width: 2),
          PosColumn(
              text:
                  '${Helpers.numberFormat((element.selectedPrice * element.selectedQuantite)).toString()}',
              width: 2),
        ]);
      }
      ticket.hr(ch: '-');
      if (widget.piece.total_tva > 0) {
        input = "${S.current.total_ht}";
        encArabic = await CharsetConverter.encode("ISO-8859-6",
            "${Helpers.numberFormat(widget.piece.total_ht).toString()}: ${input.split('').reversed.join()}");
        ticket.textEncoded(encArabic,
            styles: PosStyles(
                codeTable: PosCodeTable.arabic,
                align: (_default_format == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }
      if (widget.piece.remise > 0) {
        input = "${S.current.remise}";
        encArabic = await CharsetConverter.encode("ISO-8859-6",
            "(% ${Helpers.numberFormat(widget.piece.remise).toString()}) ${Helpers.numberFormat(((widget.piece.total_ht * widget.piece.remise) / 100)).toString()}: ${input.split('').reversed.join()}");
        ticket.textEncoded(encArabic,
            styles: PosStyles(
                codeTable: PosCodeTable.arabic,
                align: (_default_format == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));

        input = "${S.current.net_ht}";
        encArabic = await CharsetConverter.encode("ISO-8859-6",
            "${Helpers.numberFormat(widget.piece.net_ht).toString()}: ${input.split('').reversed.join()}");
        ticket.textEncoded(encArabic,
            styles: PosStyles(
                codeTable: PosCodeTable.arabic,
                align: (_default_format == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }

      if (widget.piece.total_tva > 0) {
        input = "${S.current.total_tva}";
        encArabic = await CharsetConverter.encode("ISO-8859-6",
            "${Helpers.numberFormat(widget.piece.total_tva).toString()}: ${input.split('').reversed.join()}");
        ticket.textEncoded(encArabic,
            styles: PosStyles(
                codeTable: PosCodeTable.arabic,
                align: (_default_format == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));

        input = "${S.current.total}";
        encArabic = await CharsetConverter.encode("ISO-8859-6",
            "${Helpers.numberFormat(widget.piece.total_ttc).toString()}: ${input.split('').reversed.join()}");
        ticket.textEncoded(encArabic,
            styles: PosStyles(
                codeTable: PosCodeTable.arabic,
                align: (_default_format == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }

      if (_myParams.timbre) {
        input = "${S.current.timbre}";
        encArabic = await CharsetConverter.encode("ISO-8859-6",
            "${(widget.piece.total_ttc < widget.piece.net_a_payer) ? Helpers.numberFormat(widget.piece.timbre).toString() : Helpers.numberFormat(0.0).toString()}: ${input.split('').reversed.join()}");
        ticket.textEncoded(encArabic,
            styles: PosStyles(
                codeTable: PosCodeTable.arabic,
                align: (_default_format == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }

      ticket.hr(ch: '=');
      input = "${S.current.net_payer}";
      encArabic = await CharsetConverter.encode("ISO-8859-6",
          "${Helpers.numberFormat(widget.piece.net_a_payer).toString()}: ${input.split('').reversed.join()}");
      ticket.textEncoded(encArabic,
          styles: PosStyles(
            codeTable: PosCodeTable.arabic,
            align: (_default_format == PaperSize.mm80)
                ? PosAlign.center
                : PosAlign.left,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          ));
      ticket.hr(ch: '=');

      ticket.row([
        PosColumn(
            textEncoded: await CharsetConverter.encode("ISO-8859-6",
                "${Helpers.numberFormat(widget.piece.regler).toString()}: ${S.current.regler.split('').reversed.join()}"),
            width: 6),
        (widget.piece.reste > 0)
            ? PosColumn(
                textEncoded: await CharsetConverter.encode("ISO-8859-6",
                    "${Helpers.numberFormat(widget.piece.reste).toString()}: ${S.current.reste.split('').reversed.join()}"),
                width: 6)
            : PosColumn(width: 6),
      ]);
      if (_myParams.creditTier) {
        input = "${S.current.credit}";
        encArabic = await CharsetConverter.encode("ISO-8859-6",
            "${Helpers.numberFormat(widget.tier.credit).toString()}: ${input.split('').reversed.join()}");
        ticket.textEncoded(encArabic,
            styles: PosStyles(codeTable: PosCodeTable.arabic));
      }

      ticket.feed(1);
      ticket.text('***BY CIRTA IT***',
          styles: PosStyles(
              align: (_default_format == PaperSize.mm80)
                  ? PosAlign.center
                  : PosAlign.left,
              bold: true));
      ticket.feed(1);
      ticket.cut();
    }
    else {
      ticket.text("${S.current.n} ${getPiecetype()}: ${widget.piece.num_piece}",
          styles: PosStyles(
              codeTable: PosCodeTable.arabic,
              align: (_default_format == PaperSize.mm80)
                  ? PosAlign.center
                  : PosAlign.left));
      ticket.text(
          "${S.current.date} : ${Helpers.dateToText(widget.piece.date)}",
          styles: PosStyles(
              align: (_default_format == PaperSize.mm80)
                  ? PosAlign.center
                  : PosAlign.left));
      ticket.text("${S.current.rs} : ${widget.piece.raisonSociale}",
          styles: PosStyles(
              align: (_default_format == PaperSize.mm80)
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
      widget.articles.forEach((element) async{
        ticket.row([
          (_myParams.printDisplay  == 0)
              ? PosColumn(
                  text:
                      '${element.ref.substring(0, (element.ref.length < 8 ? element.ref.length : 8))}',
                  width: 6)
              : PosColumn(
                  text:
                      '${element.designation.substring(0, (element.designation.length < 8 ? element.designation.length : 8))}',
                  width: 6),
          PosColumn(
              textEncoded:await CharsetConverter.encode("ISO-8859-6", '${Helpers.numberFormat(element.selectedQuantite).toString()}'), width: 2),
          PosColumn(
              textEncoded: await CharsetConverter.encode("ISO-8859-6",'${Helpers.numberFormat(element.selectedPrice).toString()}'),
              width: 2
          ),
          PosColumn(
              textEncoded:
                await CharsetConverter.encode("ISO-8859-6",'${Helpers.numberFormat((element.selectedPrice*element.selectedQuantite)).toString()}'),
              width: 2),
        ]);
      });
      ticket.hr(ch: '-');
      var encode ;
      if (widget.piece.total_tva > 0) {
        encode = await CharsetConverter.encode("ISO-8859-6", "${S.current.total_ht} : ${Helpers.numberFormat(widget.piece.total_ht).toString()}");
        ticket.textEncoded(
            encode,
            styles: PosStyles(
                align: (_default_format == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }
      if (widget.piece.remise > 0) {
        encode = await CharsetConverter.encode("ISO-8859-6",
            "${S.current.remise} : ${Helpers.numberFormat(((widget.piece.total_ht * widget.piece.remise) / 100)).toString()} (${Helpers.numberFormat(widget.piece.remise).toString()} %)");
        ticket.textEncoded(
            encode,
            styles: PosStyles(
                align: (_default_format == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));

        encode = await CharsetConverter.encode("ISO-8859-6", "${S.current.net_ht} : ${Helpers.numberFormat(widget.piece.net_ht).toString()}");
        ticket.textEncoded(
            encode,
            styles: PosStyles(
                align: (_default_format == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }
      if (widget.piece.total_tva > 0) {
        encode = await CharsetConverter.encode("ISO-8859-6", "${S.current.total_tva} : ${Helpers.numberFormat(widget.piece.total_tva).toString()}");
        ticket.textEncoded(
            encode,
            styles: PosStyles(
                align: (_default_format == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));

        encode = await CharsetConverter.encode("ISO-8859-6", "${S.current.total} : ${Helpers.numberFormat(widget.piece.total_ttc).toString()}");
        ticket.textEncoded(
            encode,
            styles: PosStyles(
                align: (_default_format == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }

      if (_myParams.timbre) {
        encode = await CharsetConverter.encode("ISO-8859-6",
            "${S.current.timbre} : ${(widget.piece.total_ttc < widget.piece.net_a_payer) ? Helpers.numberFormat(widget.piece.timbre).toString() : Helpers.numberFormat(0.0).toString()}");
        ticket.textEncoded(
            encode,
            styles: PosStyles(
                align: (_default_format == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }

      ticket.hr(ch: '=');
      encode = await CharsetConverter.encode("ISO-8859-6", "${S.current.net_payer} : ${Helpers.numberFormat(widget.piece.net_a_payer).toString()}");
      ticket.textEncoded(
          encode,
          styles: PosStyles(
            align: (_default_format == PaperSize.mm80)
                ? PosAlign.center
                : PosAlign.left,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          ));
      ticket.hr(ch: '=');
      ticket.row([
        PosColumn(
            textEncoded:
               await CharsetConverter.encode("ISO-8859-6","${S.current.regler} : ${Helpers.numberFormat(widget.piece.regler).toString()}"),
            width: 6),
        (widget.piece.reste > 0)
            ? PosColumn(
                textEncoded:
                  await CharsetConverter.encode("ISO-8859-6", "${S.current.reste} : ${Helpers.numberFormat(widget.piece.reste).toString()}"),
                width: 6)
            : PosColumn(width: 6),
      ]);

      if (_myParams.creditTier) {
        encode = await CharsetConverter.encode("ISO-8859-6", "${S.current.credit} : ${Helpers.numberFormat(widget.tier.credit).toString()}");
        ticket.textEncoded(
            encode);
      }

      ticket.feed(1);
      ticket.text('***BY CIRTA IT***',
          styles: PosStyles(
              align: (_default_format == PaperSize.mm80)
                  ? PosAlign.center
                  : PosAlign.left,
              bold: true));
      ticket.feed(1);
      ticket.cut();
    }

    return ticket;
  }

  String getPiecetype() {
    switch (widget.piece.piece) {
      case "FP":
        return S.current.fp;
        break;
      case "CC":
        return S.current.cc;
        break;
      case "BL":
        return S.current.bl;
        break;
      case "FC":
        return S.current.fc;
        break;
      case "RC":
        return S.current.rc;
        break;
      case "AC":
        return S.current.ac;
        break;
      case "BC":
        return S.current.bc;
        break;
      case "BR":
        return S.current.br;
        break;
      case "FF":
        return S.current.ff;
        break;
      case "RF":
        return S.current.rf;
        break;
      case "AF":
        return S.current.af;
        break;
    }
  }
}
