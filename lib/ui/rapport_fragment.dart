import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/Widgets/CustomWidgets/search_bar.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/Widgets/utils.dart' as utils;
import 'package:gestmob/models/Piece.dart';
import 'package:gestmob/ui/preview_piece.dart';
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
  bool directionRtl = false;

  @override
  void initState() {
    super.initState();
    futurInit();
  }

  futurInit() {
    Statics.rapportItems[0] = S.current.vente;
    Statics.rapportItems[1] = S.current.achat ;
    Statics.rapportItems[2] = S.current.stock;
    Statics.rapportItems[3] = S.current.cl_four ;
    Statics.rapportItems[4] = S.current.generale ;

    Statics.rapportVenteItems[0] = S.current.recap_vente_article;
    Statics.rapportVenteItems[1] = S.current.recap_cmd_article ;
    Statics.rapportVenteItems[2] = S.current.jour_vente;
    Statics.rapportVenteItems[3] = S.current.jour_cmd ;

    Statics.rapportAchatItems[0] = S.current.recap_achat_article;
    Statics.rapportAchatItems[1] = S.current.recap_cmd_article ;
    Statics.rapportAchatItems[2] = S.current.jour_achat;
    Statics.rapportAchatItems[3] = S.current.jour_cmd ;

    Statics.rapportStocktockItems[0] = S.current.inventaire;
    Statics.rapportStocktockItems[1] = S.current.prod_repture ;
    Statics.rapportStocktockItems[2] = S.current.zakat;

    Statics.rapportTierItems[0] = S.current.creance_cl;
    Statics.rapportTierItems[1] = S.current.creance_four ;

    Statics.rapportGeneralItems[0] = S.current.etat_jour;
    Statics.rapportGeneralItems[1] = S.current.etat_mensu ;
    Statics.rapportGeneralItems[2] = S.current.etat_annuel;

    _parentDropdownItems = utils.buildDropStatutTier(Statics.rapportItems);
    _selectedParent = Statics.rapportItems[0];
    print(_selectedParent);
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
    directionRtl = Helpers.isDirectionRTL(context);
    return Scaffold(
      appBar: SearchBar(
        title: S.current.rapports,
        isFilterOn: false,
        mainContext: context,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                height: 400,
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
                              child: Icon(Icons.category , color:Colors.blue)),
                          Container(
                              margin: EdgeInsetsDirectional.only(
                                  start: 20, bottom: 8),
                              child: Text("${S.current.cat_rapport}"))
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
                              child: Icon(Icons.list , color:Colors.blue)),
                          Container(
                              margin: EdgeInsetsDirectional.only(
                                  start: 20, bottom: 8),
                              child: Text("${S.current.type_rapport}"))
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
                                child: Icon(Icons.date_range , color:Colors.blue)),
                            Container(
                                margin: EdgeInsetsDirectional.only(
                                    start: 20, bottom: 8),
                                child:(Statics.rapportItems.indexOf(_selectedParent) ==
                                    4 &&
                                    Statics.rapportGeneralItems
                                        .indexOf(_selectedSubItem) ==
                                        1)
                                    ?Text("${S.current.annee}"):Text("${S.current.date_d_f}")
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
                height: 40,
              ),
              Row(
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
                            var doc01 = await _makePdfDocument();
                            if(doc01 != null){
                              await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return previewItem(45, doc01);
                                  });
                            }else{
                              var message = "${S.current.msg_rapport_vide}";
                              Helpers.showFlushBar(context, message);
                            }

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
                          onPressed: () async{
                            var doc = await _makePdfDocument();
                            if(doc != null){
                              await Printing.layoutPdf(
                                  onLayout: (PdfPageFormat format) async => doc.save());
                            }else{
                              var message = "${S.current.msg_rapport_vide}";
                              Helpers.showFlushBar(context, message);
                            }
                          },
                        ),
                      )
                  ),
                ],
              ),
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

  previewItem(int format , doc) {
    return PreviewPiece(
        piece: null,
        format: format,
        pdfDoc : doc
    );
  }
  //***************************************************************************************************************************************************************************
  //**************************************************************************get data & make pdf*******************************************************************************
  Future _makePdfDocument() async {
    var data = await rootBundle.load("assets/arial.ttf");
    final ttf = pw.Font.ttf(data);

    final _resultList = await _getData();
    if(_resultList.length < 1){
      return ;
    }

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
                      pw.Text("${_selectedSubItem}",
                          style: pw.TextStyle(font: ttf , fontWeight: pw.FontWeight.bold)),
                      pw.Divider(height: 2),
                      pw.Text("${S.current.demonstration}\t  ${Helpers.dateToText(DateTime.now())}",
                          style: pw.TextStyle(font: ttf)),
                    ])),
            pw.SizedBox(width: 3),
            pw.Expanded(
                flex: 6,
                child: pw.Column(children: [
                  pw.Text("${S.current.rapport_date}",
                      style: pw.TextStyle(font: ttf , fontWeight: pw.FontWeight.bold)),
                  pw.Text("${_dateControl.text}",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, font: ttf)),
                ]))
          ]),
          pw.SizedBox(height: 20),
          pw.Table(children: [
            pw.TableRow(
                decoration: pw.BoxDecoration(
                    border: pw.Border(bottom: pw.BorderSide(width: 2))
                ),
                children: [
                  for(var key in _resultList.first.keys)
                    pw.Container(
                      padding: pw.EdgeInsets.only(left: 5 , right: 5),
                      child: pw.Text("${getTitle(key)}",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, font: ttf ,fontSize: 10)),
                    )

                ]
            ),
            for(var map in _resultList)
              pw.TableRow(
                  decoration: pw.BoxDecoration(
                      border: pw.Border(top: pw.BorderSide(width: 0.5 , color: PdfColors.grey))
                  ),
                  children: [
                    for(var value in map.values)
                      pw.Container(
                        padding: pw.EdgeInsets.only(left: 5 , right: 5),
                        child: (value is double )
                            ?pw.Text("${Helpers.numberFormat(value)}",
                            style: pw.TextStyle(font: ttf , fontSize: 9))
                            :pw.Text("${getValue(value)}",
                            style: pw.TextStyle(font: ttf ,fontSize: 9)
                        ),
                      )

                  ]
              ),

          ]
          ),

        ],
      ),
    );

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

//  **********************************************************************************************************************************************************************
//****************************************************************************traduction**********************************************************************************

  String getTitle(value){
    switch(value){
      case "referance":
        return S.current.referance ;
        break ;
      case "designation":
        return S.current.designation ;
        break ;
      case "qte":
        return S.current.qte ;
        break ;
      case "marge":
        return S.current.marge ;
        break ;
      case "total":
        return S.current.total ;
        break ;
      case "prix":
        return S.current.prix ;
        break ;
      case "n":
        return S.current.n ;
        break ;
      case "date":
        return S.current.date ;
        break ;
      case "client":
        return S.current.client ;
        break ;
      case "montant":
        return S.current.montant ;
        break ;
      case "piece_titre":
        return S.current.piece_titre ;
        break ;
      case "fournisseur":
        return S.current.fournisseur ;
        break ;
      case "qte_min":
        return S.current.qte_min ;
        break ;
      case "pmp":
        return S.current.pmp ;
        break ;
      case "rs":
        return S.current.rs ;
        break ;
      case "mobile":
        return S.current.mobile ;
        break ;
      case "chifre_affaire":
        return S.current.chifre_affaire ;
        break ;
      case "regler":
        return S.current.regler ;
        break ;
      case "vente":
        return S.current.vente ;
        break ;
      case "reg_cl":
        return S.current.reg_cl ;
        break ;
      case "achat":
        return S.current.achat ;
        break ;
      case "reg_four":
        return S.current.reg_four ;
        break ;
      case "dette":
        return S.current.dette ;
        break ;
      case "charge":
        return S.current.charge ;
        break ;
    }
  }

  String getValue(value){
    switch(value){
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
      default:
        return value ;
        break ;
    }
  }
}
