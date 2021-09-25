import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/Article.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:gestmob/Helpers/string_cap_extension.dart';

// article selectionné ds une piece
class ArticleListItemSelected extends StatefulWidget {
  ArticleListItemSelected(
      {@required this.article,
      Key key,
      this.onItemSelected,
      this.tarification,
      this.fromListing = false,
      this.pieceOrigin})
      : assert(article != null),
        super(key: key);

  final Article article;
  final Function(Object) onItemSelected;
  final int tarification;
  final bool fromListing;
  final String pieceOrigin;

  @override
  _ArticleListItemSelectedState createState() =>
      _ArticleListItemSelectedState();
}

class _ArticleListItemSelectedState extends State<ArticleListItemSelected> {
  TextEditingController _quntiteControler = new TextEditingController();
  TextEditingController _colisControler = new TextEditingController();
  TextEditingController _priceControler = new TextEditingController();
  String _validateQteError;
  String _validateColisError;
  String _validatePriceError;

  @override
  Widget build(BuildContext context) {
    return SelectableListItem(
        key_id: Key(widget.article.id.toString()),
        isListing: widget.fromListing,
        onDismiss: (direction) {
          if (widget.onItemSelected != null) {
            widget.article.selectedQuantite = -1;
            widget.onItemSelected(widget.article);
          }
        },
        onTap: () async {
          if (widget.fromListing == false) {
            if (widget.onItemSelected != null &&
                widget.article.selectedQuantite >= 0) {
              AwesomeDialog(
                  context: context,
                  dialogType: DialogType.NO_HEADER,
                  animType: AnimType.BOTTOMSLIDE,
                  title: "",
                  body: addQtedialogue())
                ..show().then((val) {
                if (widget.article.stockable) {
                  if (widget.pieceOrigin == 'BL' ||
                      widget.pieceOrigin == 'FC') {
                    if ((widget.article.quantite - widget.article.cmdClient) <
                        widget.article.selectedQuantite) {
                      AwesomeDialog(
                          context: context,
                          dialogType: DialogType.WARNING,
                          animType: AnimType.BOTTOMSLIDE,
                          dismissOnBackKeyPress: false,
                          dismissOnTouchOutside: false,
                          title: "",
                          desc: S.current.msg_qte_select_sup,
                          btnCancelText: S.current.annuler,
                          btnCancelOnPress: () {
                            setState(() {
                              widget.article.selectedQuantite = 1;
                            });
                          },
                          btnOkText: S.current.confirme,
                          btnOkOnPress: () {})
                        ..show();
                      // Helpers.showFlushBar(context, S.current.msg_qte_select_sup);
                    }
                  }
                }
                setState(() {});
              });
            }
          }
        },
        itemSelected: widget.article.selectedQuantite > 0,
        leading: CircleAvatar(
          radius: 23,
          backgroundColor: Colors.yellow[700],
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            backgroundImage: MemoryImage(widget.article.imageUint8List),
          ),
        ),
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Icon(
                Icons.assignment,
                size: 14,
                color: Theme.of(context).primaryColorDark,
              ),
              SizedBox(
                width: 2,
              ),
              (widget.article.designation != '')
                  ? Text(
                      widget.article.designation,
                      style: GoogleFonts.lato(),
                    )
                  : Text('__'),
            ],
          ),
        ),
        subtitle: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Icon(
                MdiIcons.pound,
                size: 14,
                color: Theme.of(context).primaryColorDark,
              ),
              SizedBox(
                width: 2,
              ),
              (widget.article.ref != '')
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Text(
                            widget.article.ref,
                            style: GoogleFonts.lato(),
                          ),
                        ],
                      ),
                    )
                  : Text('__'),
            ],
          ),
        ),
        trailingChildren: [
          Text(
              "${Helpers.numberFormat((widget.article.selectedQuantite * widget.article.selectedPriceTTC))}",
              style: GoogleFonts.lato(
                textStyle:
                    TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              )),
          SizedBox(height: 5),
          (!widget.article.stockable || widget.article.quantiteColis == 1)
              ? Text("${Helpers.numberFormat(widget.article.selectedQuantite)}",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(fontSize: 16.0),
                  ))
              : ((widget.article.selectedQuantite /
                              widget.article.quantiteColis) -
                          (widget.article.selectedQuantite /
                                  widget.article.quantiteColis)
                              .truncate() >
                      0)
                  ? Text(
                      "${Helpers.numberFormat(widget.article.selectedQuantite)} [${((widget.article.selectedQuantite / widget.article.quantiteColis).toInt()).toString()}+ ${S.current.colis_abr}]",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: 16.0),
                      ))
                  : Text(
                      "${Helpers.numberFormat(widget.article.selectedQuantite)} [${((widget.article.selectedQuantite / widget.article.quantiteColis).toInt()).toString()} ${S.current.colis_abr}]",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: 16.0),
                      )),
        ]);
  }

  //****************************************************************************************************************************************************************************
  //*********************************************************dialog pour modifier le prix et la quantité**************************************************************************
  Widget addQtedialogue() {
    _quntiteControler.text = widget.article.selectedQuantite.toString();
    double res =
        (widget.article.selectedQuantite / widget.article.quantiteColis);
    if (res > 0) {
      _colisControler.text = res.toInt().toString();
      if (res - res.truncate() > 0) {
        var a = ((res - res.truncate()) * widget.article.quantiteColis)
            .round()
            .toInt();
        _colisControler.text += ' +$a';
      }
    } else {
      _colisControler.text = '0';
    }
    _priceControler.text = widget.article.selectedPriceTTC.toStringAsFixed(2);

    return StatefulBuilder(builder: (context, StateSetter _setState) {
      Widget dialog = Container(
        margin: EdgeInsets.all(10),
        child: Wrap(children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    S.current.modification_titre,
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    )),
                  ),
                )),
                Visibility(
                  visible: (widget.article.stockable &&
                      widget.article.quantiteColis > 1),
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(
                        start: 5, end: 5, bottom: 20),
                    child: TextField(
                      controller: _colisControler,
                      keyboardType: TextInputType.number,
                      onTap: () => {
                        _colisControler.selection = TextSelection(
                            baseOffset: 0,
                            extentOffset: _colisControler.value.text.length),
                      },
                      onChanged: (value) {
                        if (value.trim() != '') {
                          _quntiteControler.text = (double.parse(value) *
                                  widget.article.quantiteColis)
                              .toString();
                        } else {
                          _quntiteControler.text = '0.0';
                        }
                      },
                      autofocus: (widget.article.quantiteColis > 1),
                      decoration: InputDecoration(
                        errorText: _validateColisError ?? null,
                        prefixIcon: Icon(
                          Icons.archive,
                          color: Colors.orange[900],
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange[900]),
                            borderRadius: BorderRadius.circular(5)),
                        contentPadding: EdgeInsets.only(left: 10),
                        labelText: "${S.current.colis} +${S.current.unite}",
                        labelStyle: GoogleFonts.lato(
                            textStyle: TextStyle(color: Colors.orange[900])),
                        enabledBorder: OutlineInputBorder(
                          gapPadding: 3.3,
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Colors.orange[900]),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(
                      start: 5, end: 5, bottom: 20),
                  child: TextField(
                    controller: _quntiteControler,
                    keyboardType: TextInputType.number,
                    onTap: () => {
                      _quntiteControler.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: _quntiteControler.value.text.length),
                    },
                    onChanged: (value) {
                      if (value.trim() != '') {
                        double res = (double.parse(value) /
                            widget.article.quantiteColis);
                        _colisControler.text = (res.toInt()).toString();
                        if (res - res.truncate() > 0) {
                          var a = ((res - res.truncate()) *
                                  widget.article.quantiteColis)
                              .round()
                              .toInt();
                          _colisControler.text += ' +$a';
                        }
                      } else {
                        _colisControler.text = '0';
                      }
                    },
                    autofocus: (widget.article.quantiteColis<=1),
                    decoration: InputDecoration(
                      errorText: _validateQteError ?? null,
                      prefixIcon: Icon(
                        Icons.add_shopping_cart,
                        color: Colors.orange[900],
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange[900]),
                          borderRadius: BorderRadius.circular(5)),
                      contentPadding: EdgeInsets.only(left: 10),
                      labelText: S.current.quantit,
                      labelStyle: GoogleFonts.lato(
                          textStyle: TextStyle(color: Colors.orange[900])),
                      enabledBorder: OutlineInputBorder(
                        gapPadding: 3.3,
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.orange[900]),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 320.0,
                  child: Padding(
                    padding: EdgeInsets.only(right: 0, left: 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RawMaterialButton(
                              onPressed: _qteDialogMinusButton,
                              elevation: 2.0,
                              fillColor: Colors.redAccent,
                              child: Icon(
                                Icons.remove,
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.all(15.0),
                              shape: CircleBorder(),
                            ),
                            RawMaterialButton(
                              onPressed: _qteDialogPlusButton,
                              elevation: 2.0,
                              fillColor: Colors.greenAccent[700],
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.all(15.0),
                              shape: CircleBorder(),
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 5, right: 5, bottom: 20),
                          child: TextField(
                            controller: _priceControler,
                            keyboardType: TextInputType.number,
                            onTap: () => {
                              _priceControler.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset:
                                      _priceControler.value.text.length),
                            },
                            decoration: InputDecoration(
                              errorText: _validatePriceError ?? null,
                              prefixIcon: Icon(
                                Icons.attach_money,
                                color: Colors.orange[900],
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.orange[900]),
                                  borderRadius: BorderRadius.circular(5)),
                              contentPadding: EdgeInsets.only(left: 10),
                              labelText: S.current.prix_unite,
                              labelStyle: GoogleFonts.lato(
                                  textStyle:
                                      TextStyle(color: Colors.orange[900])),
                              enabledBorder: OutlineInputBorder(
                                gapPadding: 3.3,
                                borderRadius: BorderRadius.circular(5),
                                borderSide:
                                    BorderSide(color: Colors.orange[900]),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        //buttons
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                _qteDialogCancelButton(context, _setState);
                              },
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                width: 100,
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(100))),
                                child: Text(
                                  S.current.annuler,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                _qteDialogConfirmButton(context, _setState);
                              },
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                width: 100,
                                decoration: BoxDecoration(
                                    color: Color(0xFF00CA71),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(100))),
                                child: Text(
                                  S.current.confirme,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ]),
      );

      return dialog;
    });
  }

  _qteDialogMinusButton() {
    if(widget.article.quantiteColis <= 1){
      double _qte = double.parse(_quntiteControler.text) - 1;
      _quntiteControler.text = _qte.toStringAsFixed(2);
      String value = _qte.toStringAsFixed(2);
      if (value.trim() != '') {
        double res = (double.parse(value) / widget.article.quantiteColis);
        _colisControler.text = (res.toInt()).toString();
        if (res - res.truncate() > 0) {
          var a = ((res - res.truncate()) * widget.article.quantiteColis)
              .round()
              .toInt();
          _colisControler.text += ' +$a';
        }
      } else {
        _colisControler.text = '0';
      }

    }else{
      double _colis = 0 ;
      try{
        _colis = double.parse(_colisControler.text.split("+").first) - 1;
        _colisControler.text = _colis.toString();
      }catch(e){
        _colis = _colis -1 ;
        _colisControler.text = (_colis).toString();
      }
      if(_colisControler.text.trim() != ""){
        double qte = _colis * widget.article.quantiteColis ;
        _quntiteControler.text = qte.toStringAsFixed(2);
      }else{
        _quntiteControler.text = "0";
      }
    }

  }

  _qteDialogPlusButton() {
    if(widget.article.quantiteColis <= 1){
      double _qte = double.parse(_quntiteControler.text) + 1;
      _quntiteControler.text = _qte.toStringAsFixed(2);
      String value = _qte.toStringAsFixed(2);
      if (value.trim() != '') {
        double res = (double.parse(value) / widget.article.quantiteColis);
        _colisControler.text = (res.toInt()).toString();
        if (res - res.truncate() > 0) {
          var a = ((res - res.truncate()) * widget.article.quantiteColis)
              .round()
              .toInt();
          _colisControler.text += ' +$a';
        }
      } else {
        _colisControler.text = '0';
      }

    }else{
      double _colis = 0 ;
      try{
        _colis = double.parse(_colisControler.text.split("+").first) + 1;
        _colisControler.text = _colis.toString();
      }catch(e){
        _colis = _colis +1 ;
        _colisControler.text = (_colis).toString();
      }

      if(_colisControler.text.trim() != ""){
        double qte = _colis * widget.article.quantiteColis ;
        _quntiteControler.text = qte.toStringAsFixed(2);
      }else{
        _quntiteControler.text = "0";
      }
    }

  }

  _qteDialogCancelButton(context, setState) {
    setState(() {
      _quntiteControler.text = widget.article.selectedQuantite.toString();
      double res =
          (widget.article.selectedQuantite / widget.article.quantiteColis);
      if (res > 0) {
        _colisControler.text = res.toInt().toString();
        if (res - res.truncate() > 0) {
          var a = ((res - res.truncate()) * widget.article.quantiteColis)
              .round()
              .toInt();
          _colisControler.text += ' +$a';
        }
      } else {
        _colisControler.text = '0';
      }
      _priceControler.text = widget.article.selectedPriceTTC.toString();
      _validateQteError = null;
      _validateColisError = null;
      _validatePriceError = null;
    });
    Navigator.pop(context);
  }

  _qteDialogConfirmButton(context, _setState) {
    if (_quntiteControler.text.trim() == '') {
      _validateQteError = S.current.msg_champs_obg;
    } else {
      _validateQteError = null;
      if (!_quntiteControler.text.trim().isNumericUsingRegularExpression) {
        _validateQteError = S.current.msg_val_valide;
      }
      if (double.parse(_quntiteControler.text.trim()) <= 0) {
        _validateQteError = S.current.msg_qte_err;
      }
    }

    if (_colisControler.text.trim() == '') {
      // _validateColisError =
      //     S.current.msg_champs_obg;
    } else {
      _validateColisError = null;
      if (!_colisControler.text
          .split('+')
          .first
          .trim()
          .isNumericUsingRegularExpression) {
        _validateColisError = S.current.msg_val_valide;
      }
      if (double.parse(_colisControler.text.split('+').first.trim()) < 0) {
        _validateColisError = S.current.msg_qte_err;
      }
    }

    if (_priceControler.text.trim() == '') {
      _validatePriceError = S.current.msg_champs_obg;
    } else {
      _validatePriceError = null;
      if (!_priceControler.text.trim().isNumericUsingRegularExpression) {
        _validatePriceError = S.current.msg_val_valide;
      }
      if (double.parse(_priceControler.text.trim()) < 0) {
        _validatePriceError = S.current.msg_prix_supp_zero;
      }
    }

    if (_validateQteError == null &&
        _validateColisError == null &&
        _validatePriceError == null) {
      double _qte = double.parse(_quntiteControler.text.trim());
      double _price = double.parse(_priceControler.text.trim());

      widget.article.selectedQuantite = _qte;
      widget.article.selectedPriceTTC = _price;
      widget.article.selectedPrice =
          (_price * 100) / (100 + widget.article.tva);

      widget.onItemSelected(null);

      Navigator.pop(context);
    } else {
      _setState(() {});
    }
  }
}

//****************************************************************************************************************************************************************
//*********************************************************************card generic style******************************************************************************
class SelectableListItem extends StatelessWidget {
  final key_id;
  final bool isListing;
  final bool itemSelected;
  final Widget leading;
  final Widget title;
  final Widget subtitle;
  final List<Widget> trailingChildren;
  final GestureTapCallback onTap;
  final onDismiss;

  const SelectableListItem(
      {Key key,
      this.key_id,
      this.isListing,
      this.leading,
      this.title,
      this.subtitle,
      this.trailingChildren,
      this.onTap,
      this.itemSelected,
      this.onDismiss})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
        elevation: 4,
        margin: EdgeInsetsDirectional.fromSTEB(3, 0, 3, 5),
        child: Container(child: listTile(context)),
      );

  Widget listTile(context) {
    var tileItem = Container(
      child: ListTile(
        onTap: onTap,
        leading: leading,
        title: title,
        subtitle: subtitle,
        trailing: Container(
            child: Wrap(
          direction: Axis.vertical,
          alignment: WrapAlignment.center,
          runSpacing: 10.0,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: trailingChildren,
        )),
      ),
    );
    if (isListing) {
      return tileItem;
    }
    return Dismissible(
        key: key_id,
        onDismissed: onDismiss,
        direction: DismissDirection.startToEnd,
        background: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Colors.red, borderRadius: BorderRadius.circular(5)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.delete_forever,
                color: Colors.white,
                size: 30,
              ),
            ],
          ),
        ),
        child: tileItem);
  }
}
