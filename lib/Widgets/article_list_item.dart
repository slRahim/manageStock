import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/Article.dart';
import 'package:gestmob/services/push_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sliding_card/sliding_card.dart';
import 'package:gestmob/Helpers/string_cap_extension.dart';
import 'CustomWidgets/list_tile_card.dart';

// element à afficher lors de listing des articles
class ArticleListItem extends StatefulWidget {
  ArticleListItem(
      {@required this.article,
      Key key,
      this.onItemSelected,
      this.tarification,
      this.pieceOrigin,
      this.alreadySelected})
      : assert(article != null),
        super(key: key);

  Article article;
  final Function(Object) onItemSelected;
  final int tarification;

  final String pieceOrigin;

  final bool alreadySelected;

  @override
  _ArticleListItemState createState() => _ArticleListItemState();
}

class _ArticleListItemState extends State<ArticleListItem> {
  TextEditingController _quntiteControler = new TextEditingController();
  TextEditingController _colisControler = new TextEditingController();
  TextEditingController _priceControler = new TextEditingController();
  String _validateQteError;
  String _validateColisError;
  String _validatePriceError;
  SlidingCardController controller;

  String _devise;

  bool _visible = true;
  QueryCtr _queryCtr = new QueryCtr();
  bool _confirmDell = false;
  bool _tva = false;

  String feature9 = 'feature9';
  String feature10 = 'feature10';
  String feature13 = 'feature13';

  @override
  void initState() {
    super.initState();
    controller = SlidingCardController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    PushNotificationsManagerState data = PushNotificationsManager.of(context);
    _devise = Helpers.getDeviseTranslate(data.myParams.devise);
    _tva = data.myParams.tva;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Visibility(
      visible: _visible,
      child: DescribedFeatureOverlay(
        featureId: (widget.onItemSelected != null) ? feature9 : '',
        tapTarget: Icon(
          MdiIcons.gestureTap,
          color: Colors.black,
        ),
        backgroundColor: Colors.green,
        contentLocation: ContentLocation.below,
        title: Text(
          S.current.tap_element,
          style: GoogleFonts.lato(fontWeight: FontWeight.bold),
        ),
        description: Container(
            width: 150,
            child: Text(
              "${S.current.msg_tap}",
              style: GoogleFonts.lato(),
            )),
        onBackgroundTap: () async {
          await FeatureDiscovery.completeCurrentStep(context);
          return true;
        },
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: DescribedFeatureOverlay(
            featureId: (widget.onItemSelected == null) ? feature13 : '',
            tapTarget: Icon(
              MdiIcons.arrowExpandRight,
              color: Colors.black,
            ),
            backgroundColor: Colors.red,
            contentLocation: ContentLocation.below,
            title: Text(
              S.current.swipe,
              style: GoogleFonts.lato(fontWeight: FontWeight.bold),
            ),
            description: Container(
                width: 150,
                child: Text(
                  S.current.msg_swipe_start,
                  style: GoogleFonts.lato(),
                )),
            onBackgroundTap: () async {
              await FeatureDiscovery.completeCurrentStep(context);
              return true;
            },
            child: ListTileCard(
              from: widget.article,
              alreadySelected: widget.alreadySelected,
              onLongPress: _longpressItem,
              onTap: _tapItem,
              slidingCardController: controller,
              onCardTapped: () {
                if (controller.isCardSeparated == true) {
                  controller.collapseCard();
                } else {
                  controller.expandCard();
                }
              },
              itemSelected: widget.article.selectedQuantite > 0,
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.yellow[700],
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 23,
                  backgroundImage: MemoryImage(widget.article.imageUint8List),
                ),
              ),
              title: DescribedFeatureOverlay(
                featureId: (widget.onItemSelected != null &&
                        widget.article.selectedQuantite > 0)
                    ? feature10
                    : '',
                tapTarget: Icon(
                  MdiIcons.gestureTapHold,
                  color: Colors.black,
                ),
                backgroundColor: Colors.yellow[700],
                contentLocation: ContentLocation.below,
                title: Text(
                  S.current.long_presse,
                  style: GoogleFonts.lato(fontWeight: FontWeight.bold),
                ),
                description: Container(
                    width: 150,
                    child: Text(
                      S.current.msg_long_press_select,
                      style: GoogleFonts.lato(),
                    )),
                onBackgroundTap: () async {
                  await FeatureDiscovery.completeCurrentStep(context);
                  return true;
                },
                child: (widget.article.designation != '')
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Icon(
                              Icons.assignment,
                              size: 12,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text("${widget.article.designation}",
                                style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                  fontSize: 16.0,
                                ))),
                          ],
                        ),
                      )
                    : null,
              ),
              trailingChildren: widget.article.selectedQuantite > 0
                  ? [
                      Row(
                        children: [
                          Icon(
                            MdiIcons.pound,
                            size: 12,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          (widget.article.ref != '')
                              ? Text("${widget.article.ref}",
                                  style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                    fontSize: 16.0,
                                  )))
                              : Text(
                                  "__",
                                  style: GoogleFonts.lato(),
                                ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.widgets_rounded,
                            size: 12,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          (!widget.article.stockable ||
                                  widget.article.quantiteColis == 1)
                              ? Text(
                                  "${Helpers.numberFormat(widget.article.selectedQuantite)}",
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
                        ],
                      ),
                      Text(
                        "${Helpers.numberFormat(widget.article.selectedQuantite * widget.article.selectedPriceTTC).toString()} ${_devise}",
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold)),
                      ),
                    ]
                  :
                  // listing des articles ds le fragement article
                  [
                      Row(
                        children: [
                          Icon(
                            MdiIcons.pound,
                            size: 12,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          (widget.article.ref != '')
                              ? Text("${widget.article.ref}",
                                  style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                    fontSize: 16.0,
                                  )))
                              : Text(
                                  "__",
                                  style: GoogleFonts.lato(),
                                ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.widgets_rounded,
                            size: 12,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          (widget.article.stockable)
                              ? Text(
                                  "${Helpers.numberFormat(widget.article.quantite - widget.article.cmdClient)}",
                                  style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                          color: widget.article.quantite <=
                                                  widget.article.quantiteMinimum
                                              ? Colors.redAccent
                                              : Theme.of(context)
                                                  .primaryColorDark,
                                          fontSize: 16.0)),
                                )
                              : Text(
                                  S.current.service,
                                  style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                          fontSize: 12.0)),
                                ),
                        ],
                      ),
                      trailingChildrenOnArticleFragment(),
                    ],
            ),
          ),
          actions: (widget.onItemSelected == null)
              ? <Widget>[
                  IconSlideAction(
                      color: Colors.white10,
                      iconWidget: Icon(
                        Icons.delete_forever,
                        size: 50,
                        color: Colors.red,
                      ),
                      onTap: () async {
                        dellDialog(context);
                      }),
                ]
              : null,
        ),
      ),
    );
  }

  _longpressItem() {
    if (widget.onItemSelected != null && widget.article.selectedQuantite >= 0) {
      widget.article.selectedQuantite = -1;
      widget.onItemSelected(widget.article);
    }
  }

  _tapItem() async {

    if (widget.onItemSelected == null) {
      Navigator.of(context)
          .pushNamed(RoutesKeys.addArticle, arguments: widget.article)
          .then((value) {
        if (value is Article) {
          setState(() {
            widget.article = value;
          });
        }
      });
    } else {
      if (widget.article.selectedQuantite == -1) {
        selectThisItem();
      }

       AwesomeDialog(
          context: context,
          dialogType: DialogType.NO_HEADER,
          animType: AnimType.BOTTOMSLIDE,
          title: "",
          body: addQtedialogue())
        ..show().then((value) {

          if (widget.article.stockable &&
              (widget.pieceOrigin == 'BL' || widget.pieceOrigin == 'FC') &&
              ((widget.article.quantite - widget.article.cmdClient) <
                  widget.article.selectedQuantite)) {
            Helpers.showToast(S.current.msg_qte_select_sup);

            // try {
            // AwesomeDialog(
            //     context: context,
            //     dialogType: DialogType.WARNING,
            //     dismissOnBackKeyPress: false,
            //     dismissOnTouchOutside: false,
            //     animType: AnimType.BOTTOMSLIDE,
            //     title: "",
            //     desc: S.current.msg_qte_select_sup,
            //     btnCancelText: S.current.annuler,
            //     btnCancelOnPress: () {
            //       // setState(() {
            //       //   widget.article.selectedQuantite = -1;
            //       //   widget.onItemSelected(widget.article);
            //       // });
            //     },
            //     btnOkText: S.current.confirme,
            //     btnOkOnPress: () {})
            //   ..show();
            // } catch (e) {
            //   Helpers.showToast(S.current.msg_qte_select_sup);
            // }
          }
        });


    }
  }

  //afficher le prix de vente selon la tarification
  Widget trailingChildrenOnArticleFragment() {
    if (widget.pieceOrigin == 'BR' ||
        widget.pieceOrigin == 'BC' ||
        widget.pieceOrigin == 'FF' ||
        widget.pieceOrigin == 'RF' ||
        widget.pieceOrigin == 'AF') {
      return Text(
        "${Helpers.numberFormat(widget.article.prixAchatTTC).toString()} $_devise",
        style: GoogleFonts.lato(
            textStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
      );
    } else {
      switch (widget.tarification) {
        case 1:
          return Text(
            (!_tva)
                ? "${Helpers.numberFormat(widget.article.prixVente1TTC).toString()} $_devise"
                : "${Helpers.numberFormat(widget.article.prixVente1TTC).toString()} $_devise",
            style: GoogleFonts.lato(
                textStyle:
                    TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          );
          break;

        case 2:
          return Text(
            (!_tva)
                ? "${Helpers.numberFormat(widget.article.prixVente2TTC).toString()} $_devise"
                : "${Helpers.numberFormat(widget.article.prixVente2TTC).toString()} $_devise",
            style: GoogleFonts.lato(
                textStyle:
                    TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          );
          break;

        case 3:
          return Text(
            (!_tva)
                ? "${Helpers.numberFormat(widget.article.prixVente3TTC).toString()} $_devise"
                : "${Helpers.numberFormat(widget.article.prixVente3TTC).toString()} $_devise",
            style: GoogleFonts.lato(
                textStyle:
                    TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          );
          break;

        default:
          if (widget.article.selectedPriceTTC > 0) {
            return Text(
              "${Helpers.numberFormat(widget.article.selectedPriceTTC).toString()} $_devise",
              style: GoogleFonts.lato(
                  textStyle:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            );
          }
          return Text(
            (!_tva)
                ? "${Helpers.numberFormat(widget.article.prixVente1TTC).toString()} $_devise"
                : "${Helpers.numberFormat(widget.article.prixVente1TTC).toString()} $_devise",
            style: GoogleFonts.lato(
                textStyle:
                    TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          );
          break;
      }
    }
  }

  void selectThisItem() {
    widget.article.selectedQuantite = 1;
    if (widget.pieceOrigin == 'BC' ||
        widget.pieceOrigin == 'BR' ||
        widget.pieceOrigin == 'FF' ||
        widget.pieceOrigin == 'RF' ||
        widget.pieceOrigin == 'AF') {
      widget.article.selectedPrice = widget.article.prixAchat;
      widget.article.selectedPriceTTC = widget.article.prixAchatTTC;
    } else {
      switch (widget.tarification) {
        case 1:
          widget.article.selectedPrice = widget.article.prixVente1;
          widget.article.selectedPriceTTC = widget.article.prixVente1TTC;
          break;
        case 2:
          widget.article.selectedPrice = widget.article.prixVente2;
          widget.article.selectedPriceTTC = widget.article.prixVente2TTC;
          break;
        case 3:
          widget.article.selectedPrice = widget.article.prixVente3;
          widget.article.selectedPriceTTC = widget.article.prixVente3TTC;
          break;
        default:
          if (widget.article.selectedPrice == null) {
            widget.article.selectedPrice = widget.article.prixVente1;
            widget.article.selectedPriceTTC = widget.article.prixVente1TTC;
          }
          break;
      }
    }

    widget.onItemSelected(widget.article);
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
              padding:
                  EdgeInsetsDirectional.only(start: 5, end: 5, bottom: 20),
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
                autofocus: (widget.article.quantiteColis <= 1),
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
            Padding(
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
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

      widget.article.selectedQuantite = -1;
      widget.onItemSelected(widget.article);
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

  //*********************************************************************************************************************************************************************
  //*********************************************************************************************************************************************************
  Widget dellDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      animType: AnimType.BOTTOMSLIDE,
      title: S.current.supp,
      desc: '${S.current.msg_supp}',
      btnCancelText: S.current.non,
      btnCancelOnPress: () {},
      btnOkText: S.current.oui,
      btnOkOnPress: () async {
        var res = await _queryCtr.getJournalByArticle(widget.article);
        var message = "";
        if (res.isEmpty) {
          int res1 = await _queryCtr.removeItemFromTable(
              DbTablesNames.articles, widget.article);
          if (res1 > 0) {
            message = S.current.msg_supp_ok;
            _confirmDell = true;
          } else {
            message = S.current.msg_ereure;
          }
        } else {
          message = S.current.msg_article_utilise;
        }

        Helpers.showToast(message);
        if (_confirmDell) {
          setState(() {
            _visible = false;
          });
        }
      },
    )..show();
  }
}
