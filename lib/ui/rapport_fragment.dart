import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/Widgets/CustomWidgets/search_bar.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/Widgets/utils.dart' as utils;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class Rapport extends StatefulWidget {
  @override
  _RapportState createState() => _RapportState();
}

class _RapportState extends State<Rapport> {
  TextEditingController _dateControl = new TextEditingController();
  TextEditingController _yearControl = new TextEditingController();
  DateTimeRange _dateRange;

  List<DropdownMenuItem<String>> _parentDropdownItems;
  String _selectedParent;

  List<DropdownMenuItem<String>> _achatDropdownItems;
  List<DropdownMenuItem<String>> _venteDropdownItems;
  List<DropdownMenuItem<String>> _stockDropdownItems;
  List<DropdownMenuItem<String>> _tierDropdownItems;
  List<DropdownMenuItem<String>> _generalDropdownItems;

  List<DropdownMenuItem<String>> _subDropdownItems;
  String _selectedSubItem;

  QueryCtr _queryCtr = new QueryCtr();

  @override
  void initState() {
    super.initState();
    futurInit();
  }

  futurInit() {
    _parentDropdownItems = utils.buildDropStatutTier(Statics.rapportItems);
    _selectedParent = Statics.rapportItems[0];

    _venteDropdownItems = utils.buildDropStatutTier(Statics.rapportVenteItems);
    _achatDropdownItems = utils.buildDropStatutTier(Statics.rapportAchatItems);
    _stockDropdownItems =
        utils.buildDropStatutTier(Statics.rapportStocktockItems);
    _tierDropdownItems = utils.buildDropStatutTier(Statics.rapportTierItems);
    _generalDropdownItems =
        utils.buildDropStatutTier(Statics.rapportGeneralItems);

    _subDropdownItems = _venteDropdownItems;
    _selectedSubItem = Statics.rapportVenteItems[0];
    setState(() {
      _dateRange = new DateTimeRange(
          start: DateTime.now(), end: DateTime.now().add(Duration(days: 30)));
      _dateControl.text =
          "${Helpers.dateToText(DateTime.now())} / ${Helpers.dateToText(DateTime.now().add(Duration(days: 30)))}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchBar(
        title: "Rapports",
        isFilterOn: false,
        mainContext: context,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(10),
                height: 350,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(.5),
                      blurRadius: 20.0, // soften the shadow
                      spreadRadius: 0.0, //extend the shadow
                      offset: Offset(
                        5.0, // Move to right 10  horizontally
                        5.0, // Move to bottom 10 Vertically
                      ),
                    )
                  ],
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              margin: EdgeInsetsDirectional.only(
                                  start: 20, bottom: 8),
                              child: Text("Categorie Rapport :"))
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                                margin: EdgeInsetsDirectional.only(
                                    start: 10, end: 10),
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.blueAccent,
                                  ),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                      disabledHint: Text(_selectedParent),
                                      value: _selectedParent,
                                      items: _parentDropdownItems,
                                      onChanged: (value) {
                                        setState(() {
                                          generateSubList(Statics.rapportItems
                                              .indexOf(value));
                                          _selectedParent = value;
                                        });
                                      }),
                                )),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              margin: EdgeInsetsDirectional.only(
                                  start: 20, bottom: 8),
                              child: Text("Type Rapport :"))
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                                margin: EdgeInsetsDirectional.only(
                                    start: 10, end: 10),
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.blueAccent,
                                  ),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                      disabledHint: Text(_selectedSubItem),
                                      value: _selectedSubItem,
                                      items: _subDropdownItems,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedSubItem = value;
                                        });
                                      }),
                                )),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Visibility(
                        visible:  ((Statics.rapportItems.indexOf(_selectedParent) != 2 &&
                            Statics.rapportItems.indexOf(_selectedParent) != 3 ) &&
                            (Statics.rapportGeneralItems
                                .indexOf(_selectedSubItem) !=
                                2)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                margin: EdgeInsetsDirectional.only(
                                    start: 20, bottom: 8),
                                child:(Statics.rapportItems.indexOf(_selectedParent) ==
                                    4 &&
                                    Statics.rapportGeneralItems
                                        .indexOf(_selectedSubItem) ==
                                        1)
                                    ?Text("Années : "):Text("Date (Debut / Fin) :")
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: ((Statics.rapportItems
                                    .indexOf(_selectedParent) !=
                                2 &&
                            Statics.rapportItems.indexOf(_selectedParent) != 3 ) &&
                            (Statics.rapportGeneralItems
                                    .indexOf(_selectedSubItem) !=
                                    2)
                        ),
                        child: Row(
                          children: [
                            (Statics.rapportItems.indexOf(_selectedParent) ==
                                        4 &&
                                    Statics.rapportGeneralItems
                                            .indexOf(_selectedSubItem) ==
                                        1)
                                ? Expanded(
                                  child: Container(
                                    margin: EdgeInsetsDirectional.only(
                                        start: 8, end: 8),
                                    padding: const EdgeInsets.all(5),
                                    child: TextField(
                                        controller: _yearControl,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.date_range,
                                            color: Colors.blue,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: Colors.blue),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide:
                                              BorderSide(color: Colors.blue),
                                              borderRadius:
                                              BorderRadius.circular(20))
                                        ),
                                        keyboardType: TextInputType.number,
                                      ),
                                  ),
                                )
                                : Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        callDatePicker();
                                      },
                                      child: Container(
                                        margin: EdgeInsetsDirectional.only(
                                            start: 10, end: 10),
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.blueAccent,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: TextField(
                                          controller: _dateControl,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.date_range,
                                              color: Colors.blue,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.blue),
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                          ),
                                          enabled: false,
                                          keyboardType: TextInputType.text,
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ]),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.all(10),
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(.5),
                      blurRadius: 20.0, // soften the shadow
                      spreadRadius: 0.0, //extend the shadow
                      offset: Offset(
                        5.0, // Move to right 10  horizontally
                        5.0, // Move to bottom 10 Vertically
                      ),
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.green, shape: BoxShape.circle),
                        child: IconButton(
                          icon: Icon(
                            Icons.save_alt_rounded,
                            size: 30,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            print("save rapport");
                            var doc01 = await _makePdfDocument().then((value) {
                              var message = "rapport bien été créer";
                              Helpers.showFlushBar(context, message);
                            });

                            await Printing.sharePdf(
                                bytes: await doc01.save(),
                                filename: 'my-document.pdf');
                          },
                        ),
                      )
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.blue, shape: BoxShape.circle),
                        child: IconButton(
                          icon: Icon(
                            Icons.print,
                            size: 30,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            print("print rapport");
                            var message = "rapport bien été créer";
                            Helpers.showFlushBar(context, message);
                          },
                        ),
                      )
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void generateSubList(value) {
    switch (value) {
      case 0:
        _subDropdownItems = _venteDropdownItems;
        _selectedSubItem = Statics.rapportVenteItems[0];
        break;
      case 1:
        _subDropdownItems = _achatDropdownItems;
        _selectedSubItem = Statics.rapportAchatItems[0];
        break;
      case 2:
        _subDropdownItems = _stockDropdownItems;
        _selectedSubItem = Statics.rapportStocktockItems[0];
        break;
      case 3:
        _subDropdownItems = _tierDropdownItems;
        _selectedSubItem = Statics.rapportTierItems[0];
        break;
      case 4:
        _subDropdownItems = _generalDropdownItems;
        _selectedSubItem = Statics.rapportGeneralItems[0];
        break;
    }
  }

  void callDatePicker() async {
    DateTime now = new DateTime.now();
    DateTimeRange order = await getDate();

    if (order != null) {
      setState(() {
        _dateRange = new DateTimeRange(start: order.start, end: order.end);
        var start = new DateTime(order.start.year, order.start.month,
            order.start.day, now.hour, now.minute);
        var end = new DateTime(order.end.year, order.end.month, order.end.day,
            now.hour, now.minute);
        _dateControl.text =
            "${Helpers.dateToText(start)} / ${Helpers.dateToText(end)}";
      });
    }
  }

  Future<DateTimeRange> getDate() {
    return showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
  }

  //***************************************************************************************************************************************************************************
  //**************************************************************************get data & make pdf*******************************************************************************
  Future _makePdfDocument() async {
    var data = await rootBundle.load("assets/arial.ttf");
    final ttf = pw.Font.ttf(data);

    final item = await _getData();

    final doc = pw.Document();
    // doc.addPage(
    //   pw.MultiPage(
    //     // textDirection: (directionRtl)?pw.TextDirection.rtl:pw.TextDirection.ltr,
    //     build: (context) => [
    //       pw.Row(children: [
    //         pw.Expanded(
    //             flex: 6,
    //             child: pw.Column(
    //                 crossAxisAlignment: pw.CrossAxisAlignment.start,
    //                 children: [
    //                   pw.Text("${S.current.rs}\t  ${widget.tier.raisonSociale}",
    //                       style: pw.TextStyle(font: ttf)),
    //                   pw.Divider(height: 2),
    //                   pw.Text("${S.current.adresse}\t  ${widget.tier.adresse} ",
    //                       style: pw.TextStyle(font: ttf)),
    //                   pw.Text("${S.current.ville}\t  ${widget.tier.ville}",
    //                       style: pw.TextStyle(font: ttf)),
    //                 ])),
    //         pw.SizedBox(width: 3),
    //         pw.Expanded(
    //             flex: 6,
    //             child: pw.Column(children: [
    //               pw.Text("|||||||||||||||||||||||||||||||"),
    //               pw.Text("${Helpers.getPieceTitle(widget.piece.piece)}",
    //                   style: pw.TextStyle(
    //                       fontWeight: pw.FontWeight.bold, font: ttf)),
    //               pw.Text("${S.current.n}\t  ${widget.piece.num_piece}",
    //                   style: pw.TextStyle(
    //                       fontWeight: pw.FontWeight.bold, font: ttf)),
    //               pw.Text(
    //                   "${S.current.date}\t  ${Helpers.dateToText(widget.piece.date)}",
    //                   style: pw.TextStyle(font: ttf)),
    //             ]))
    //       ]),
    //       pw.SizedBox(height: 20),
    //       pw.Table(children: [
    //         pw.TableRow(
    //             decoration: pw.BoxDecoration(color: PdfColors.grey),
    //             children: [
    //               pw.Text("${S.current.referance}",
    //                   style: pw.TextStyle(
    //                       fontWeight: pw.FontWeight.bold, font: ttf)),
    //               pw.Text("${S.current.designation}",
    //                   style: pw.TextStyle(
    //                       fontWeight: pw.FontWeight.bold, font: ttf)),
    //               pw.Text("${S.current.qte}",
    //                   style: pw.TextStyle(
    //                       fontWeight: pw.FontWeight.bold, font: ttf)),
    //               pw.Text("${S.current.prix}",
    //                   style: pw.TextStyle(
    //                       fontWeight: pw.FontWeight.bold, font: ttf)),
    //               pw.Text("${S.current.montant}",
    //                   style: pw.TextStyle(
    //                       fontWeight: pw.FontWeight.bold, font: ttf))
    //             ]),
    //         for (var e in widget.articles)
    //           pw.TableRow(children: [
    //             pw.Text("${e.ref}",style: pw.TextStyle(font: ttf)),
    //             pw.Text("${e.designation}",style: pw.TextStyle(font: ttf)),
    //             pw.Text("${e.selectedQuantite.toStringAsFixed(2)}",),
    //             pw.Text("${e.selectedPrice.toStringAsFixed(2)}",),
    //             pw.Text("${(e.selectedPrice * e.selectedQuantite).toStringAsFixed(2)}",),
    //           ]),
    //       ]),
    //       pw.SizedBox(height: 10),
    //       pw.Divider(height: 2),
    //       pw.SizedBox(height: 10),
    //       pw.Row(children: [
    //         pw.Expanded(
    //             flex: 6,
    //             child: pw.Column(children: [
    //               pw.Text(
    //                   "${S.current.regler}\t  ${widget.piece.regler.toStringAsFixed(2)}\t  ${S.current.da}",
    //                   style: pw.TextStyle(font: ttf)),
    //               (_controlReste)
    //                   ? pw.Text(
    //                 "${S.current.reste}\t   ${widget.piece.reste.toStringAsFixed(2)}\t  ${S.current.da}",
    //                 style: pw.TextStyle(font: ttf),)
    //                   : pw.SizedBox(),
    //               (_controlCredit)
    //                   ? pw.Text(
    //                 "${S.current.credit}\t  ${widget.tier.credit.toStringAsFixed(2)}\t ${S.current.da}",
    //                 style: pw.TextStyle(font: ttf),)
    //                   : pw.SizedBox(),
    //               pw.Divider(height: 2),
    //               pw.SizedBox(height: 4),
    //               pw.Text("${S.current.msg_visite}",
    //                 style: pw.TextStyle(
    //                     fontWeight: pw.FontWeight.bold, font: ttf),),
    //               pw.Text("****BY Ciratit****",
    //                 style: pw.TextStyle(
    //                     fontWeight: pw.FontWeight.bold, font: ttf),),
    //             ])),
    //         pw.SizedBox(width: 10),
    //         pw.Expanded(
    //             flex: 6,
    //             child: pw.Column(
    //                 crossAxisAlignment: pw.CrossAxisAlignment.start,
    //                 children: [
    //                   (_controlTotalHT)
    //                       ? pw.Text(
    //                     "${S.current.total_ht}\t ${widget.piece.total_ht.toStringAsFixed(2)}\t ${S.current.da}",
    //                     style: pw.TextStyle(font: ttf),
    //                   )
    //                       : pw.SizedBox(),
    //                   (_controlRemise)
    //                       ? pw.Text(
    //                     "${S.current.remise}\t  ${((widget.piece.total_ht*widget.piece.remise)/100).toStringAsFixed(2)} (${widget.piece.remise}\t %)\t ${S.current.da} ",
    //                     style: pw.TextStyle(font: ttf),
    //                   )
    //                       : pw.SizedBox(),
    //                   (_controlNetHt)
    //                       ? pw.Text(
    //                     "${S.current.net_ht}\t ${widget.piece.net_ht.toStringAsFixed(2)}\t ${S.current.da}",
    //                     style: pw.TextStyle(font: ttf),
    //                   )
    //                       : pw.SizedBox(),
    //                   (_controlTotalTva)
    //                       ? pw.Text(
    //                     "${S.current.total_tva}\t ${widget.piece.total_tva.toStringAsFixed(2)}\t ${S.current.da}",
    //                     style: pw.TextStyle(font: ttf),
    //                   )
    //                       : pw.SizedBox(),
    //                   pw.Text(
    //                       "${S.current.total}\t  ${widget.piece.total_ttc.toStringAsFixed(2)}\t  ${S.current.da}",
    //                       style: pw.TextStyle(font: ttf)),
    //                   pw.Divider(height: 2),
    //                   (_controlTimbre)
    //                       ? pw.Text(
    //                       "${S.current.timbre}\t ${(widget.piece.total_ttc < widget.piece.net_a_payer) ? widget.piece.timbre.toStringAsFixed(2) : 0.0}\t ${S.current.da}",
    //                       style: pw.TextStyle(font: ttf))
    //                       : pw.SizedBox(),
    //                   pw.Text(
    //                       "${S.current.net_payer}\t  ${widget.piece.net_a_payer.toStringAsFixed(2)}\t  ${S.current.da}",
    //                       style: pw.TextStyle(font: ttf)),
    //                   pw.Divider(height: 2),
    //                 ])),
    //         pw.SizedBox(width: 3),
    //       ]),
    //     ],
    //   ),
    // );

    return doc;
  }

  Future _getData() async {
    var res;
    switch (Statics.rapportItems.indexOf(_selectedParent)) {
      case 0:
        res = await _queryCtr.rapportVente(
            Statics.rapportVenteItems.indexOf(_selectedSubItem),
            _dateRange.start,
            _dateRange.end);
        break;
      case 1:
        res = await _queryCtr.rapportAchat(
            Statics.rapportAchatItems.indexOf(_selectedSubItem),
            _dateRange.start,
            _dateRange.end);
        break;
      case 2:
        res = await _queryCtr.rapportStock(
            Statics.rapportStocktockItems.indexOf(_selectedSubItem));
        break;
      case 3:
        res = await _queryCtr
            .rapportTier(Statics.rapportTierItems.indexOf(_selectedSubItem));
        break;
      case 4:
        if( Statics.rapportGeneralItems.indexOf(_selectedSubItem) == 1){
          _dateRange = new DateTimeRange(start: DateTime(int.parse(_yearControl.text)), end: DateTime(int.parse(_yearControl.text),12,31));
        }
        res = await _queryCtr.rapportGeneral(
            Statics.rapportGeneralItems.indexOf(_selectedSubItem),
            _dateRange.start,
            _dateRange.end);
        break;
    }

    print(res);
    return res;
  }
}
