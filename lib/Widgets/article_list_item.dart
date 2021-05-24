import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/Article.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sliding_card/sliding_card.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'CustomWidgets/list_tile_card.dart';
import 'package:gestmob/services/push_notifications.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:google_fonts/google_fonts.dart';

// element à afficher lors de listing des articles
class ArticleListItem extends StatefulWidget {
  ArticleListItem(
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
  _ArticleListItemState createState() => _ArticleListItemState();
}

class _ArticleListItemState extends State<ArticleListItem> {
  TextEditingController _quntiteControler = new TextEditingController();
  TextEditingController _priceControler = new TextEditingController();
  String _validateQteError;
  String _validatePriceError;
  SlidingCardController controller;

  String _devise;

  bool _visible = true;
  QueryCtr _queryCtr = new QueryCtr();
  bool _confirmDell = false;

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
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Visibility(
      visible: _visible,
      child: DescribedFeatureOverlay(
        featureId: (widget.onItemSelected != null) ? feature9 : '',
        tapTarget: Icon(
          MdiIcons.gestureTapHold,
          color: Colors.black,
        ),
        backgroundColor: Colors.green,
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
              onLongPress: () {
                if (widget.onItemSelected != null &&
                    widget.article.selectedQuantite > 0) {
                  widget.article.selectedQuantite = -1;
                  widget.onItemSelected(widget.article);
                }
              },
              onTap: () async {
                if (widget.fromListing == false) {
                  if (widget.onItemSelected == null) {
                    Navigator.of(context).pushNamed(RoutesKeys.addArticle,
                        arguments: widget.article);
                  } else {
                    if (widget.article.selectedQuantite >= 0) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return addQtedialogue();
                          }).then((val) {
                        if (widget.pieceOrigin == 'BL' ||
                            widget.pieceOrigin == 'FC') {
                          if ((widget.article.quantite -
                                  widget.article.cmdClient) <
                              widget.article.selectedQuantite) {
                            AwesomeDialog(
                                context: context,
                                dialogType: DialogType.WARNING,
                                dismissOnBackKeyPress: false,
                                dismissOnTouchOutside: false,
                                animType: AnimType.BOTTOMSLIDE,
                                title: "",
                                desc: S.current.msg_qte_select_sup,
                                btnCancelText: S.current.confirme,
                                btnCancelOnPress: () {},
                                btnOkText: S.current.annuler,
                                btnOkOnPress: () {
                                  setState(() {
                                    widget.article.selectedQuantite = 1;
                                  });
                                })
                              ..show();
                            // Helpers.showToast(S.current.msg_qte_select_sup);
                          }
                        }

                        setState(() {});
                      });
                    } else {
                      selectThisItem() ;
                      if (widget.pieceOrigin == 'BL' ||
                          widget.pieceOrigin == 'FC') {
                        if ((widget.article.quantite -
                                widget.article.cmdClient) < widget.article.selectedQuantite) {

                              // AwesomeDialog(
                              //     context: context,
                              //     dialogType: DialogType.WARNING,
                              //     animType: AnimType.BOTTOMSLIDE,
                              //     title: "",
                              //     desc: S.current.msg_qte_zero,
                              //     btnCancelText: S.current.confirme,
                              //     btnCancelOnPress: () {},
                              //     btnOkText: S.current.annuler,
                              //     btnOkOnPress: () {
                              //       setState(() {
                              //         widget.article.selectedQuantite = 0;
                              //       });
                              //     })
                              //   ..show();

                          Helpers.showToast(S.current.msg_qte_zero);
                        }
                      }
                    }
                  }
                }
              },
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
                  MdiIcons.gestureTap,
                  color: Colors.black,
                ),
                backgroundColor: Colors.yellow[700],
                contentLocation: ContentLocation.below,
                title: Text(
                  S.current.tap_element,
                  style: GoogleFonts.lato(fontWeight: FontWeight.bold),
                ),
                description: Container(
                    width: 150,
                    child: Text(
                      S.current.msg_tap,
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
                          Text("${widget.article.selectedQuantite.toString()}",
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(fontSize: 16.0),
                              )),
                        ],
                      ),
                      Text(
                        "${Helpers.numberFormat(widget.article.selectedQuantite * widget.article.selectedPrice).toString()} ${_devise}",
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
                          Text(
                            "${(widget.article.quantite - widget.article.cmdClient).toString()}",
                            style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    color: widget.article.quantite <=
                                            widget.article.quantiteMinimum
                                        ? Colors.redAccent
                                        : Theme.of(context).primaryColorDark,
                                    fontSize: 16.0)),
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

  //afficher le prix de vente selon la tarification
  Widget trailingChildrenOnArticleFragment() {
    if (widget.pieceOrigin == 'BR' ||
        widget.pieceOrigin == 'FF' ||
        widget.pieceOrigin == 'RF' ||
        widget.pieceOrigin == 'AF') {
      return Text(
        "${Helpers.numberFormat(widget.article.prixAchat).toString()} ${_devise}",
        style: GoogleFonts.lato(
            textStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
      );
    } else {
      switch (widget.tarification) {
        case 1:
          return Text(
            "${Helpers.numberFormat(widget.article.prixVente1).toString()} ${_devise}",
            style: GoogleFonts.lato(
                textStyle:
                    TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          );
          break;

        case 2:
          return Text(
            "${Helpers.numberFormat(widget.article.prixVente2).toString()} ${_devise}",
            style: GoogleFonts.lato(
                textStyle:
                    TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          );
          break;

        case 3:
          return Text(
            "${Helpers.numberFormat(widget.article.prixVente3).toString()} ${_devise}",
            style: GoogleFonts.lato(
                textStyle:
                    TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          );
          break;

        default:
          if (widget.article.selectedPrice > 0) {
            return Text(
              "${Helpers.numberFormat(widget.article.selectedPrice).toString()} ${_devise}",
              style: GoogleFonts.lato(
                  textStyle:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            );
          }
          return Text(
            "${Helpers.numberFormat(widget.article.prixVente1).toString()} ${_devise}",
            style: GoogleFonts.lato(
                textStyle:
                    TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          );
          break;
      }
    }
  }

  //dialog pour modifier le prix et la quantité
  Widget addQtedialogue() {
    return StatefulBuilder(builder: (context, StateSetter setState) {
      Widget dialog = Dialog(
        //this right here
        child: Container(
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
                      decoration: InputDecoration(
                        errorText: _validateQteError ?? null,
                        prefixIcon: Icon(
                          Icons.add_shopping_cart,
                          color: Colors.orange[900],
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange[900]),
                            borderRadius: BorderRadius.circular(20)),
                        contentPadding: EdgeInsets.only(left: 10),
                        labelText: S.current.quantit,
                        labelStyle: GoogleFonts.lato(
                            textStyle: TextStyle(color: Colors.orange[900])),
                        enabledBorder: OutlineInputBorder(
                          gapPadding: 3.3,
                          borderRadius: BorderRadius.circular(20),
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
                                onPressed: () {
                                  double _qte =
                                      double.parse(_quntiteControler.text) - 1;
                                  _quntiteControler.text =
                                      _qte.toStringAsFixed(2);
                                },
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
                                onPressed: () {
                                  double _qte =
                                      double.parse(_quntiteControler.text) + 1;
                                  _quntiteControler.text =
                                      _qte.toStringAsFixed(2);
                                },
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
                                    borderRadius: BorderRadius.circular(20)),
                                contentPadding: EdgeInsets.only(left: 10),
                                labelText: S.current.prix,
                                labelStyle: GoogleFonts.lato(
                                    textStyle:
                                        TextStyle(color: Colors.orange[900])),
                                enabledBorder: OutlineInputBorder(
                                  gapPadding: 3.3,
                                  borderRadius: BorderRadius.circular(20),
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
                                      _quntiteControler.text = "0";
                                      Navigator.pop(context);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius:BorderRadius.all(Radius.circular(100))
                                  ),
                                  child: Text(
                                    S.current.annuler,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,fontSize: 14),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              InkWell(
                                onTap: () {
                                  try {
                                    double _qte =
                                    double.parse(_quntiteControler.text);
                                    double _price =
                                    double.parse(_priceControler.text);
                                    if (_qte > 0) {
                                      _validateQteError = null;
                                    } else {
                                      _validateQteError = S.current.msg_qte_err;
                                    }
                                    if (_price > 0) {
                                      _validatePriceError = null;
                                    } else {
                                      _validatePriceError =
                                          S.current.msg_prix_err;
                                    }
                                    if (_validateQteError == null &&
                                        _validatePriceError == null) {
                                      widget.article.selectedQuantite = _qte;
                                      widget.article.selectedPrice = _price;
                                      widget.onItemSelected(null);

                                      Navigator.pop(context);
                                    } else {
                                      setState(() {});
                                    }
                                  } catch (e) {
                                    setState(() {
                                      _validateQteError = S.current.msg_num_err;
                                    });
                                    print(e);
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  width: 100,
                                  decoration: BoxDecoration(
                                      color: Color(0xFF00CA71),
                                      borderRadius:BorderRadius.all(Radius.circular(100))
                                  ),
                                  child: Text(
                                    S.current.confirme,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,fontSize: 14),
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
        ),
      );
      _quntiteControler.text = widget.article.selectedQuantite.toString();
      _priceControler.text = widget.article.selectedPrice.toStringAsFixed(2);
      return dialog;
    });
  }

  void selectThisItem(){
    widget.article.selectedQuantite = 1;
    if (widget.pieceOrigin == 'BR' ||
        widget.pieceOrigin == 'FF' ||
        widget.pieceOrigin == 'RF' ||
        widget.pieceOrigin == 'AF') {
      widget.article.selectedPrice = widget.article.prixAchat;
    } else {
      switch (widget.tarification) {
        case 1:
          widget.article.selectedPrice = widget.article.prixVente1;
          break;
        case 2:
          widget.article.selectedPrice = widget.article.prixVente2;
          break;
        case 3:
          widget.article.selectedPrice = widget.article.prixVente3;
          break;
        default:
          if (widget.article.selectedPrice == null) {
            widget.article.selectedPrice = widget.article.prixVente1;
          }
          break;
      }
    }

    widget.onItemSelected(widget.article);
  }

  Widget dellDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      animType: AnimType.BOTTOMSLIDE,
      title: S.current.supp,
      desc: '${S.current.msg_supp} ... ',
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

        Helpers.showFlushBar(context, message);
        if (_confirmDell) {
          setState(() {
            _visible = false;
          });
        }
      },
    )..show();
  }
}
