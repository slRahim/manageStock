import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/Widgets/CustomWidgets/add_save_bar.dart';
import 'package:gestmob/Widgets/CustomWidgets/bottom_tab_bar.dart';
import 'package:gestmob/Widgets/CustomWidgets/image_picker_widget.dart';
import 'package:gestmob/Widgets/CustomWidgets/list_dropdown.dart';
import 'package:gestmob/Widgets/utils.dart' as utils;
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/Article.dart';
import 'package:gestmob/models/ArticleFamille.dart';
import 'package:gestmob/models/ArticleMarque.dart';
import 'package:gestmob/models/ArticleTva.dart';
import 'package:gestmob/models/MyParams.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:gestmob/Helpers/string_cap_extension.dart';

class AddArticlePage extends StatefulWidget {
  final QueryCtr _queryCtr = QueryCtr();

  Article arguments;

  AddArticlePage({Key key, @required this.arguments}) : super(key: key);

  @override
  _AddArticlePageState createState() => _AddArticlePageState();
}

class _AddArticlePageState extends State<AddArticlePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool editMode = true;
  bool modification = false;

  bool _stockable = true;
  bool finishedLoading = false;
  String appBarTitle = S.current.article_titre;

  List<ArticleMarque> _marqueItems;
  List<ArticleFamille> _familleItems;
  List<ArticleTva> _tvaItems;

  List<DropdownMenuItem<ArticleMarque>> _marqueDropdownItems;
  ArticleMarque _selectedMarque;

  List<DropdownMenuItem<ArticleFamille>> _familleDropdownItems;
  ArticleFamille _selectedFamille;

  List<DropdownMenuItem<ArticleTva>> _tvaDropdownItems;
  ArticleTva _selectedTva;

  bool _price2 = false;
  bool _price3 = false;
  bool _tva = false;

  TextEditingController _designationControl = new TextEditingController();
  TextEditingController _stockInitialControl = new TextEditingController();
  TextEditingController _stockMinimumControl = new TextEditingController();
  TextEditingController _prixAchatControl = new TextEditingController();
  TextEditingController _refControl = new TextEditingController();
  TextEditingController _codeBarControl = new TextEditingController();
  TextEditingController _pmpControl = new TextEditingController();
  TextEditingController _descriptionControl = new TextEditingController();
  TextEditingController _price1Control = new TextEditingController();
  TextEditingController _price2Control = new TextEditingController();
  TextEditingController _price3Control = new TextEditingController();
  TextEditingController _libelleFamilleControl = new TextEditingController();
  TextEditingController _libelleMarqueControl = new TextEditingController();
  TextEditingController _tauxTVAControl = new TextEditingController();
  TextEditingController _colisControl = new TextEditingController();
  TextEditingController _qteColisCotrol = new TextEditingController(text: "1.0");
  TextEditingController _qteCmdCotrol = new TextEditingController();
  bool _controlBloquer = false;

  ArticleFamille _famille = new ArticleFamille.init();
  ArticleMarque _marque = new ArticleMarque.init();
  File _articleImage;

  MyParams _myParams;

  QueryCtr _queryCtr = new QueryCtr();

  final _formKey = GlobalKey<FormState>();

  TabController _tabController;
  int _tabSelectedIndex = 0;

  static const _stream = const EventChannel('pda.flutter.dev/scanEvent');
  StreamSubscription subscription;

  //*************************************************************************************************************************************************************************
  //************************************************************************special init data***********************************************************************************
  void initState() {
    super.initState();

    futureInitState().then((val) {
      setState(() {
        finishedLoading = true;
      });
    });

    _tabController = TabController(length: 3, vsync: this);

    _tabController.addListener(() {
      setState(() {
        _tabSelectedIndex = _tabController.index;
      });
    });

    subscription = _stream.receiveBroadcastStream().listen(_pdaScanner);
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  Future<bool> futureInitState() async {
    _marqueItems = await widget._queryCtr.getAllArticleMarques();
    _marqueItems[0].setLibelle(S.current.no_marque);

    _familleItems = await widget._queryCtr.getAllArticleFamilles();
    _familleItems[0].setLibelle(S.current.no_famille);

    _tvaItems = await widget._queryCtr.getAllArticleTva();

    _selectedMarque = _marqueItems[0];
    _selectedFamille = _familleItems[0];
    _selectedTva = new ArticleTva(0);

    if (widget.arguments is Article &&
        widget.arguments.id != null &&
        widget.arguments.id > -1) {
      editMode = false;
      modification = true;
      await setDataFromArticle(widget.arguments);
    } else {
      editMode = true;
    }

    await getParams();
    _marqueDropdownItems = utils.buildMarqueDropDownMenuItems(_marqueItems);
    _familleDropdownItems = utils.buildDropFamilleArticle(_familleItems);
    _tvaDropdownItems = utils.buildDropTvaDownMenuItems(_tvaItems);

    return Future<bool>.value(editMode);
  }

  Future<void> setDataFromArticle(Article article) async {
    _articleImage = await Helpers.getFileFromUint8List(article.imageUint8List);
    _designationControl.text = article.designation;
    _stockInitialControl.text = article.quantite.toString();
    _stockMinimumControl.text = article.quantiteMinimum.toString();
    _prixAchatControl.text = article.prixAchat.toStringAsFixed(2);
    _refControl.text = article.ref;
    _stockable = article.stockable;
    _codeBarControl.text = article.codeBar;
    _qteColisCotrol.text = article.quantiteColis.toString();
    _qteCmdCotrol.text = article.cmdClient.toString();
    _colisControl.text = article.colis.toInt().toString();
    _controlBloquer = article.bloquer;

    if (_pmpControl.text != null) {
      _pmpControl.text = article.pmp.toStringAsFixed(2);
    }

    _descriptionControl.text = article.description;
    _price1Control.text = article.prixVente1.toStringAsFixed(2);
    _price2Control.text = article.prixVente2.toStringAsFixed(2);
    _price3Control.text = article.prixVente3.toStringAsFixed(2);
    _selectedMarque =
        _marqueItems.firstWhere((element) => element.id == article.idMarque);
    _selectedFamille =
        _familleItems.firstWhere((element) => element.id == article.idFamille);
    _selectedTva = new ArticleTva(article.tva);
  }

  void getParams() async {
    _myParams = await _queryCtr.getAllParams();
    switch (_myParams.tarification) {
      case 1:
        _price2Control.text = "0.0";
        _price3Control.text = "0.0";
        break;
      case 2:
        _price2 = true;
        _price3Control.text = "0.0";
        break;
      case 3:
        _price2 = true;
        _price3 = true;
        break;
    }
    _tva = _myParams.tva;
  }

  //*************************************************************************************************************************************************************************
  //************************************************************************partie daffichage***********************************************************************************
  @override
  Widget build(BuildContext context) {
    if (modification) {
      if (editMode) {
        appBarTitle = S.current.modification_titre;
      } else {
        appBarTitle = S.current.article_titre;
      }
    } else {
      if (editMode) {
        appBarTitle = "${S.current.artcile_titre_ajouter}";
      } else {
        appBarTitle = S.current.article_titre;
      }
    }

    if (!finishedLoading) {
      return Scaffold(body: Helpers.buildLoading());
    } else {
      return WillPopScope(
        onWillPop: _onWillPop,
        child: DefaultTabController(
            length: 3,
            child: Scaffold(
                key: _scaffoldKey,
                backgroundColor: Theme.of(context).backgroundColor,
                appBar: AddEditBar(
                  editMode: editMode,
                  modification: modification,
                  title: appBarTitle,
                  onCancelPressed: _pressCancel,
                  onEditPressed: () {
                    setState(() {
                      editMode = true;
                    });
                  },
                  onSavePressed: _pressSave,
                ),
                bottomNavigationBar: BottomTabBar(
                  selectedIndex: _tabSelectedIndex,
                  controller: _tabController,
                  tabs: [
                    Tab(
                        child: Column(
                      children: [
                        Icon(Icons.insert_drive_file),
                        SizedBox(height: 1),
                        Text(
                          "${S.current.fiche_art}",
                          style: GoogleFonts.lato(),
                        ),
                      ],
                    )),
                    Tab(
                        child: Column(
                      children: [
                        Icon(Icons.image),
                        SizedBox(height: 1),
                        Text(
                          S.current.photo,
                          style: GoogleFonts.lato(),
                        ),
                      ],
                    )),
                    Tab(
                        child: Column(
                      children: [
                        Icon(Icons.description),
                        SizedBox(height: 1),
                        Text(
                          S.current.description,
                          style: GoogleFonts.lato(),
                        ),
                      ],
                    )),
                  ],
                ),
                body: Builder(
                  builder: (context) => TabBarView(
                    controller: _tabController,
                    children: [
                      fichetab(),
                      imageTab(),
                      descriptionTab(),
                    ],
                  ),
                ))),
      );
    }
  }

  Future<bool> _onWillPop() async {
    if (modification) {
      if (editMode) {
        AwesomeDialog(
            context: context,
            title: "",
            desc: "${S.current.msg_retour_no_save}",
            dialogType: DialogType.QUESTION,
            animType: AnimType.BOTTOMSLIDE,
            btnCancelText: S.current.non,
            btnCancelOnPress: () {},
            btnOkText: S.current.oui,
            btnOkOnPress: () async {
              Navigator.of(context).pushReplacementNamed(RoutesKeys.addArticle,
                  arguments: widget.arguments);
            })
          ..show();
        return Future.value(false);
      } else {
        Navigator.pop(context, widget.arguments);
        return Future.value(false);
      }
    } else {
      if (_designationControl.text != '') {
        AwesomeDialog(
            context: context,
            title: "",
            desc: "${S.current.msg_retour_no_save}",
            dialogType: DialogType.QUESTION,
            animType: AnimType.BOTTOMSLIDE,
            btnCancelText: S.current.non,
            btnCancelOnPress: () {},
            btnOkText: S.current.oui,
            btnOkOnPress: () async {
              Navigator.pop(context);
            })
          ..show();
        return Future.value(false);
      } else {
        Navigator.pop(context);
        return Future.value(false);
      }
    }
  }

  _pressCancel() {
    if (modification) {
      if (editMode) {
        AwesomeDialog(
            context: context,
            title: "",
            desc: "${S.current.msg_retour_no_save}",
            dialogType: DialogType.QUESTION,
            animType: AnimType.BOTTOMSLIDE,
            btnCancelText: S.current.non,
            btnCancelOnPress: () {},
            btnOkText: S.current.oui,
            btnOkOnPress: () async {
              Navigator.of(context).pushReplacementNamed(RoutesKeys.addArticle,
                  arguments: widget.arguments);
            })
          ..show();
      } else {
        Navigator.pop(context, widget.arguments);
      }
    } else {
      if (_designationControl.text != '') {
        AwesomeDialog(
            context: context,
            title: "",
            desc: "${S.current.msg_retour_no_save}",
            dialogType: DialogType.QUESTION,
            animType: AnimType.BOTTOMSLIDE,
            btnCancelText: S.current.non,
            btnCancelOnPress: () {},
            btnOkText: S.current.oui,
            btnOkOnPress: () async {
              Navigator.pop(context);
            })
          ..show();
      } else {
        Navigator.pop(context);
      }
    }
  }

  _pressSave() async {
    if (_formKey.currentState != null) {
      if (_formKey.currentState.validate()) {
        int id = await addArticleToDb();
        if (id > -1) {
          setState(() {
            modification = true;
            editMode = false;
          });
        }
      } else {
        Helpers.showToast("${S.current.msg_champs_obg}");
      }
    } else {
      setState(() {
        _tabSelectedIndex = 0;
        _tabController.index = _tabSelectedIndex;
      });
    }
  }

  Widget fichetab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(15, 25, 15, 15),
      child: Form(
        key: _formKey,
        child: Wrap(
          spacing: 13,
          runSpacing: 13,
          children: [
            TextFormField(
              enabled: editMode,
              controller: _designationControl,
              // onTap: () => _designationControl.selection = TextSelection(baseOffset: 0, extentOffset: _designationControl.value.text.length),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value.isEmpty) {
                  return S.current.msg_champ_oblg;
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: S.current.designation,

                labelStyle: GoogleFonts.lato(
                  textStyle: TextStyle(color: Colors.green),
                ),
                hintText: S.current.msg_entre_design,
                hintStyle: GoogleFonts.lato(),
                prefixIcon: Icon(
                  Icons.assignment,
                  color: Colors.green,
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.circular(5)),
                enabledBorder: OutlineInputBorder(
                  gapPadding: 3.3,
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.green),
                ),
                errorBorder: OutlineInputBorder(
                  gapPadding: 3.3,
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
            ),
            TextFormField(
              enabled: editMode,
              controller: _refControl,
              // onTap: () => _refControl.selection = TextSelection(baseOffset: 0, extentOffset: _refControl.value.text.length),
              keyboardType: TextInputType.text,
              // validator: (value) {
              //   if (value.isEmpty) {
              //     return S.current.msg_champ_oblg;
              //   }
              //   return null;
              // },
              decoration: InputDecoration(
                labelText: S.current.referance,
                labelStyle: GoogleFonts.lato(
                    textStyle: TextStyle(color: Theme.of(context).hintColor)),
                prefixIcon: Icon(
                  Icons.archive,
                  color: Colors.blue,
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(5)),
                enabledBorder: OutlineInputBorder(
                  gapPadding: 3.3,
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                errorBorder: OutlineInputBorder(
                  gapPadding: 3.3,
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
            ),
            InkWell(
              onDoubleTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                await scanBarCode();
              },
              child: TextFormField(
                enabled: editMode,
                controller: _codeBarControl,

                onTap: () => _codeBarControl.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: _codeBarControl.value.text.length),
                keyboardType: TextInputType.text,
                // validator: (value) {
                //   if (value.isEmpty) {
                //     return S.current.msg_champ_oblg;
                //   }
                //   return null;
                // },
                decoration: InputDecoration(
                  labelText: S.current.msg_scan_barcode,
                  labelStyle: GoogleFonts.lato(
                      textStyle: TextStyle(color: Theme.of(context).hintColor)),
                  prefixIcon: Icon(
                    MdiIcons.barcode,
                    color: Colors.blue,
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(5)),
                  enabledBorder: OutlineInputBorder(
                    gapPadding: 3.3,
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  errorBorder: OutlineInputBorder(
                    gapPadding: 3.3,
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Flexible(
                  flex: 5,
                  child: TextFormField(
                    enabled: editMode,
                    controller: _prixAchatControl,
                    onTap: () => _prixAchatControl.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: _prixAchatControl.value.text.length),
                    onChanged: (value) {
                      setState(() {
                        _pmpControl.text = value;
                      });
                    },
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (!value.isNumericUsingRegularExpression) {
                        return S.current.msg_val_valide;
                      }
                      if (value.isNotEmpty && double.parse(value) < 0) {
                        return S.current.msg_prix_supp_zero;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: S.current.prix_achat,
                        labelStyle: GoogleFonts.lato(
                            textStyle:
                                TextStyle(color: Theme.of(context).hintColor)),
                        prefixIcon: Icon(
                          Icons.attach_money,
                          color: Colors.blue,
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(5)),
                        enabledBorder: OutlineInputBorder(
                          gapPadding: 3.3,
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        errorBorder: OutlineInputBorder(
                          gapPadding: 3.3,
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Colors.red),
                        )),
                  ),
                ),
                Padding(padding: EdgeInsets.fromLTRB(8, 0, 0, 0)),
                Flexible(
                  flex: 5,
                  child: Container(
                    decoration: editMode
                        ? new BoxDecoration(
                            border: Border.all(
                              color: Colors.blueAccent,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          )
                        : null,
                    child: CheckboxListTile(
                      activeColor: Theme.of(context).primaryColor,
                      title: Text(S.current.stockable,
                          maxLines: 1,
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                color: Theme.of(context).primaryColorDark),
                          )),
                      value: _stockable,
                      onChanged: editMode
                          ? (bool value) {
                              setState(() {
                                _stockable = value;
                              });
                            }
                          : (bool value) {},
                    ),
                  ),
                )
              ],
            ),
            TextFormField(
              enabled: editMode,
              controller: _pmpControl,
              onTap: () => _pmpControl.selection = TextSelection(
                  baseOffset: 0, extentOffset: _pmpControl.value.text.length),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (!value.isNumericUsingRegularExpression) {
                  return S.current.msg_val_valide;
                }
                if (value.isNotEmpty && double.parse(value) < 0) {
                  return S.current.msg_prix_supp_zero;
                }
                return null;
              },
              decoration: InputDecoration(
                  labelText: (modification)
                      ? S.current.pmp
                      : "${S.current.pmp} ${S.current.init}",
                  labelStyle: GoogleFonts.lato(
                    textStyle: TextStyle(color: Theme.of(context).hintColor),
                  ),
                  prefixIcon: Icon(
                    Icons.archive,
                    color: Colors.blue,
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(5)),
                  enabledBorder: OutlineInputBorder(
                    gapPadding: 3.3,
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  errorBorder: OutlineInputBorder(
                    gapPadding: 3.3,
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.red),
                  )),
            ),
            Row(
              children: [
                Visibility(
                  visible: _stockable,
                  child: Flexible(
                    flex: 5,
                    child: TextFormField(
                      enabled: editMode,
                      controller: _qteColisCotrol,
                      onTap: () => _qteColisCotrol.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: _qteColisCotrol.value.text.length),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (!value.isNumericUsingRegularExpression) {
                          return S.current.msg_val_valide;
                        }
                        if (value.isNotEmpty && double.parse(value) <= 0) {
                          return S.current.msg_prix_supp_zero;
                        }
                        return null;
                      },
                      onChanged: (value){
                        if(value.trim() != ''){
                          _colisControl.text =
                              (double.parse(_stockInitialControl.text)/double.parse(_qteColisCotrol.text)).toInt().toString();
                        }else{
                          _colisControl.text = '';
                        }

                      },
                      decoration: InputDecoration(
                        labelText: S.current.qte_colis,
                        labelStyle: GoogleFonts.lato(
                          textStyle:
                              TextStyle(color: Theme.of(context).hintColor),
                        ),
                        prefixIcon: Icon(
                          Icons.shopping_bag_rounded,
                          color: Colors.blue[700],
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(5)),
                        enabledBorder: OutlineInputBorder(
                          gapPadding: 3.3,
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        errorBorder: OutlineInputBorder(
                          gapPadding: 3.3,
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Visibility(
                  visible: modification,
                  child: Flexible(
                    flex: 5,
                    child: TextFormField(
                      enabled: editMode,
                      readOnly: true,
                      controller: _qteCmdCotrol,
                      onTap: () => _qteCmdCotrol.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: _qteCmdCotrol.value.text.length),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (!value.isNumericUsingRegularExpression) {
                          return S.current.msg_val_valide;
                        }
                        if (value.isNotEmpty && double.parse(value) < 0) {
                          return S.current.msg_prix_supp_zero;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.apps_outlined,
                          color: Colors.blue,
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(5)),
                        labelText: S.current.qte_cmd,
                        labelStyle: GoogleFonts.lato(
                          textStyle:
                              TextStyle(color: Theme.of(context).hintColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          gapPadding: 3.3,
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        errorBorder: OutlineInputBorder(
                          gapPadding: 3.3,
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: _stockable,
              child: TextFormField(
                enabled: editMode,
                controller: _colisControl,
                onTap: () => _colisControl.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: _colisControl.value.text.length),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (!value.isNumericUsingRegularExpression) {
                    return S.current.msg_val_valide;
                  }
                  if (value.isNotEmpty && double.parse(value) < 0) {
                    return S.current.msg_prix_supp_zero;
                  }
                  return null;
                },
                onChanged: (value){
                  if(value.trim() != ''){
                    _stockInitialControl.text = (double.parse(value) * double.parse(_qteColisCotrol.text)).toString();
                  }else{
                    _stockInitialControl.text = '' ;
                  }
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.archive,
                    color: Colors.blue,
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(5)),
                  labelText: S.current.colis,
                  labelStyle: GoogleFonts.lato(
                    textStyle: TextStyle(color: Theme.of(context).hintColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    gapPadding: 3.3,
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  errorBorder: OutlineInputBorder(
                    gapPadding: 3.3,
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: _stockable,
              child: Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      enabled: editMode,
                      controller: _stockInitialControl,
                      onTap: () => _stockInitialControl.selection =
                          TextSelection(
                              baseOffset: 0,
                              extentOffset:
                              _stockInitialControl.value.text.length),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (!value.isNumericUsingRegularExpression) {
                          return S.current.msg_val_valide;
                        }
                        if (!modification &&
                            value.isNotEmpty &&
                            double.parse(value) < 0) {
                          return S.current.msg_prix_supp_zero;
                        }
                        return null;
                      },
                      onChanged: (value){
                        if(value.trim() != ''){
                          _colisControl.text = ((double.parse(value) / double.parse(_qteColisCotrol.text)).toInt()).toString() ;
                        }else{
                          _colisControl.text = '' ;
                        }
                      },
                      decoration: InputDecoration(
                        labelText: modification
                            ? S.current.quantit
                            : S.current.stock_init,
                        labelStyle: GoogleFonts.lato(
                          textStyle:
                          TextStyle(color: Theme.of(context).hintColor),
                        ),
                        prefixIcon: Icon(
                          Icons.apps,
                          color: Colors.blue,
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(5)),
                        enabledBorder: OutlineInputBorder(
                          gapPadding: 3.3,
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        errorBorder: OutlineInputBorder(
                          gapPadding: 3.3,
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  Flexible(
                    child: TextFormField(
                      enabled: editMode,
                      controller: _stockMinimumControl,
                      onTap: () => _stockMinimumControl.selection =
                          TextSelection(
                              baseOffset: 0,
                              extentOffset:
                              _stockMinimumControl.value.text.length),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (!value.isNumericUsingRegularExpression) {
                          return S.current.msg_val_valide;
                        }
                        if (value.isNotEmpty && double.parse(value) < 0) {
                          return S.current.msg_prix_supp_zero;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: S.current.stock_min,
                        labelStyle: GoogleFonts.lato(
                          textStyle:
                          TextStyle(color: Theme.of(context).hintColor),
                        ),
                        prefixIcon: Icon(
                          Icons.apps,
                          color: Colors.blue,
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(5)),
                        enabledBorder: OutlineInputBorder(
                          gapPadding: 3.3,
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        errorBorder: OutlineInputBorder(
                          gapPadding: 3.3,
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            TextFormField(
              enabled: editMode,
              controller: _price1Control,
              onTap: () => _price1Control.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: _price1Control.value.text.length),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (!value.isNumericUsingRegularExpression) {
                  return S.current.msg_val_valide;
                }
                if (value.isNotEmpty && double.parse(value) < 0) {
                  return S.current.msg_prix_supp_zero;
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: S.current.prix_v1,
                labelStyle: GoogleFonts.lato(
                  textStyle: TextStyle(color: Theme.of(context).hintColor),
                ),
                prefixIcon: Icon(
                  Icons.monetization_on,
                  color: Colors.blue,
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(5)),
                enabledBorder: OutlineInputBorder(
                  gapPadding: 3.3,
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                errorBorder: OutlineInputBorder(
                  gapPadding: 3.3,
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
            ),
            Visibility(
              visible: _price2,
              child: TextFormField(
                enabled: editMode,
                controller: _price2Control,
                onTap: () => _price2Control.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: _price2Control.value.text.length),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (!value.isNumericUsingRegularExpression) {
                    return S.current.msg_val_valide;
                  }
                  if (value.isNotEmpty && double.parse(value) < 0) {
                    return S.current.msg_prix_supp_zero;
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: S.current.prix_v2,
                  labelStyle: GoogleFonts.lato(
                    textStyle: TextStyle(color: Theme.of(context).hintColor),
                  ),
                  prefixIcon: Icon(
                    Icons.monetization_on,
                    color: Colors.blueGrey[700],
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(5)),
                  enabledBorder: OutlineInputBorder(
                    gapPadding: 3.3,
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  errorBorder: OutlineInputBorder(
                    gapPadding: 3.3,
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: _price3,
              child: TextFormField(
                enabled: editMode,
                controller: _price3Control,
                onTap: () => _price3Control.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: _price3Control.value.text.length),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (!value.isNumericUsingRegularExpression) {
                    return S.current.msg_val_valide;
                  }
                  if (value.isNotEmpty && double.parse(value) < 0) {
                    return S.current.msg_prix_supp_zero;
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: S.current.prix_v3,
                  labelStyle: GoogleFonts.lato(
                    textStyle: TextStyle(color: Theme.of(context).hintColor),
                  ),
                  prefixIcon: Icon(
                    Icons.monetization_on,
                    color: Colors.blueGrey[500],
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(5)),
                  enabledBorder: OutlineInputBorder(
                    gapPadding: 3.3,
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  errorBorder: OutlineInputBorder(
                    gapPadding: 3.3,
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
              ),
            ),
            dropdowns(),
            Visibility(
              visible: modification,
              child: Container(
                  decoration: editMode
                      ? new BoxDecoration(
                          border: Border.all(
                            color: Colors.blueAccent,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        )
                      : null,
                  child: SwitchListTile(
                    title: Text(
                      S.current.bloquer,
                      style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              color: Theme.of(context).primaryColorDark)),
                    ),
                    value: _controlBloquer,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: editMode
                        ? (bool value) {
                            setState(() {
                              _controlBloquer = value;
                            });
                          }
                        : (bool value) {},
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget imageTab() {
    return SingleChildScrollView(
      child: ImagePickerWidget(
          imageFile: _articleImage,
          editMode: editMode,
          onImageChange: (File imageFile) {
            setState(() {
              _articleImage = imageFile;
            });
          }),
    );
  }

  Widget descriptionTab() {
    return SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Padding(
        padding: EdgeInsets.all(20),
        child: Center(
            child: TextField(
          enabled: editMode,
          maxLines: 20,
          controller: _descriptionControl,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
                borderRadius: BorderRadius.circular(5)),
            contentPadding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
            labelText: S.current.description,
            labelStyle: GoogleFonts.lato(
              textStyle: TextStyle(color: Theme.of(context).hintColor),
            ),
            alignLabelWithHint: true,
            hintText: S.current.msg_description,
            hintStyle: GoogleFonts.lato(),
            enabledBorder: OutlineInputBorder(
              gapPadding: 3.3,
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
        )),
      ),
      Padding(padding: EdgeInsets.all(10)),
    ]));
  }

  Widget dropdowns() {
    return Center(
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        direction: Axis.horizontal,
        children: [
          Visibility(
            visible: _tva,
            child: ListDropDown(
              editMode: editMode,
              libelle:
                  ("${S.current.taux_tva}: ${_selectedTva.tva.toStringAsFixed(2)} %"),
              value: _selectedTva,
              items: _tvaDropdownItems,
              onChanged: (value) {
                setState(() {
                  _selectedTva = value;
                });
              },
              onAddPressed: () async {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.NO_HEADER,
                  animType: AnimType.BOTTOMSLIDE,
                  title: S.current.supp,
                  body: addTVAdialogue(),
                )..show().then((value) => setState(() {}));
              },
            ),
          ),
          ListDropDown(
            editMode: editMode,
            value: _selectedMarque,
            items: _marqueDropdownItems,
            libelle: _selectedMarque.libelle,
            onChanged: (value) {
              setState(() {
                _selectedMarque = value;
              });
            },
            onAddPressed: () async {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.NO_HEADER,
                animType: AnimType.BOTTOMSLIDE,
                title: S.current.supp,
                body: addMarquedialogue(),
              )..show().then((value) => setState(() {}));
            },
          ),
          ListDropDown(
            editMode: editMode,
            value: _selectedFamille,
            items: _familleDropdownItems,
            libelle: _selectedFamille.libelle,
            onChanged: (value) {
              setState(() {
                _selectedFamille = value;
              });
            },
            onAddPressed: () async {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.NO_HEADER,
                animType: AnimType.BOTTOMSLIDE,
                title: S.current.supp,
                body: addFamilledialogue(),
              )..show().then((value) => setState(() {}));
            },
          ),
        ],
      ),
    );
  }

  Widget addMarquedialogue() {
    _marque = new ArticleMarque.init();
    var _formKey = GlobalKey<FormState>();
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Builder(
        builder: (context) => SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "${S.current.ajouter} ${S.current.marque}",
                style: GoogleFonts.lato(
                    textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
              ),
              // ImagePickerWidget(
              //     editMode: editMode,
              //     scallFactor: 1,
              //     onImageChange: (File imageFile) {
              //       _marque.setpic(imageFile) ;
              //     }
              // ),
              Padding(
                padding:
                    EdgeInsets.only(left: 5, right: 5, bottom: 20, top: 20),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _libelleMarqueControl,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) {
                        return S.current.msg_champ_oblg;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.label,
                        color: Colors.blue,
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(5)),
                      contentPadding: EdgeInsets.only(left: 10),
                      labelText: S.current.marque,
                      labelStyle: GoogleFonts.lato(
                        textStyle:
                            TextStyle(color: Theme.of(context).hintColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        gapPadding: 3.3,
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 150,
                child: Padding(
                  padding: EdgeInsets.only(right: 0, left: 0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          _marque.setLibelle(_libelleMarqueControl.text.trim());
                          _libelleMarqueControl.text = "";
                        });

                        await addMarqueIfNotExist(_marque);
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      "+ ${S.current.ajouter}",
                      style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                    ),
                    color: Colors.green,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  Future<void> addMarqueIfNotExist(ArticleMarque marque) async {
    int marqueIndex = _marqueItems.indexOf(marque);
    if (marqueIndex > -1) {
      _selectedMarque = _marqueItems[marqueIndex];
    } else {
      int id = await widget._queryCtr
          .addItemToTable(DbTablesNames.articlesMarques, marque);
      marque.id = id;

      _marqueItems.add(marque);
      _marqueDropdownItems = utils.buildMarqueDropDownMenuItems(_marqueItems);
      _selectedMarque = _marqueItems.last;
    }
  }

  Widget addFamilledialogue() {
    _famille = ArticleFamille.init();
    var _formKey = GlobalKey<FormState>();
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Builder(
        builder: (context) => SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "${S.current.ajouter} ${S.current.famile}",
                style: GoogleFonts.lato(
                    textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
              ),
              // ImagePickerWidget(
              //     editMode: editMode,
              //     scallFactor: 1,
              //     onImageChange: (File imageFile) =>
              //         {_famille.setpic(imageFile)}),
              Padding(
                padding:
                    EdgeInsets.only(left: 5, right: 5, bottom: 20, top: 20),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _libelleFamilleControl,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) {
                        return S.current.msg_champ_oblg;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.view_agenda,
                        color: Colors.blue,
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(5)),
                      contentPadding: EdgeInsets.only(left: 10),
                      labelText: S.current.famile,
                      labelStyle: GoogleFonts.lato(
                        textStyle:
                            TextStyle(color: Theme.of(context).hintColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        gapPadding: 3.3,
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 150.0,
                child: Padding(
                  padding: EdgeInsets.only(right: 0, left: 0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          _famille
                              .setLibelle(_libelleFamilleControl.text.trim());
                          _libelleFamilleControl.text = "";
                        });
                        await addFamilleIfNotExist(_famille);
                        Navigator.pop(context);
                      }
                    },
                    child: Text("+ ${S.current.ajouter}",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        )),
                    color: Colors.green,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  Future<void> addFamilleIfNotExist(ArticleFamille famille) async {
    int familleIndex = _familleItems.indexOf(famille);
    if (familleIndex > -1) {
      _selectedFamille = _familleItems[familleIndex];
    } else {
      int id = await widget._queryCtr
          .addItemToTable(DbTablesNames.articlesFamilles, famille);
      famille.id = id;

      _familleItems.add(famille);
      _familleDropdownItems = utils.buildDropFamilleArticle(_familleItems);
      _selectedFamille = _familleItems.last;
    }
  }

  Widget addTVAdialogue() {
    var _formKey = GlobalKey<FormState>();
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Builder(
        builder: (context) => SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("${S.current.ajouter} ${S.current.tva}",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
              Padding(
                padding:
                    EdgeInsets.only(left: 5, right: 5, bottom: 20, top: 20),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _tauxTVAControl,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value.isEmpty) {
                        return S.current.msg_champ_oblg;
                      }
                      if (!value.isNumericUsingRegularExpression) {
                        return S.current.msg_val_valide;
                      }
                      if (value.isNotEmpty && double.parse(value) < 0) {
                        return S.current.msg_prix_supp_zero;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        MdiIcons.percent,
                        color: Colors.blue,
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(5)),
                      contentPadding: EdgeInsets.only(left: 10),
                      labelText: S.current.taux_tva,
                      labelStyle: GoogleFonts.lato(
                        textStyle:
                            TextStyle(color: Theme.of(context).hintColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        gapPadding: 3.3,
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 150.0,
                child: Padding(
                  padding: EdgeInsets.only(right: 0, left: 0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        double _taux =
                            double.parse(_tauxTVAControl.text.trim());
                        _tauxTVAControl.text = "";
                        await addTvaIfNotExist(_taux);
                        Navigator.pop(context);
                      }
                    },
                    child: Text("+ ${S.current.ajouter}",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        )),
                    color: Colors.green,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  Future<void> addTvaIfNotExist(double tvaDouble) async {
    ArticleTva tvaItem = new ArticleTva(tvaDouble);
    int tvaIndex = _tvaItems.indexOf(tvaItem);
    if (tvaIndex > -1) {
      _selectedTva = _tvaItems[tvaIndex];
    } else {
      await widget._queryCtr
          .addItemToTable(DbTablesNames.articlesTva, new ArticleTva(tvaDouble));

      _tvaItems.add(tvaItem);
      _tvaItems.sort((a, b) => a.tva.compareTo(b.tva));
      _tvaDropdownItems = utils.buildDropTvaDownMenuItems(_tvaItems);
      _selectedTva = _tvaItems[_tvaItems.indexOf(tvaItem)];
    }
  }

  //*************************************************************************************************************************************************************************
  //************************************************************************partie de save***********************************************************************************
  Future<int> addArticleToDb() async {
    int id = -1;
    String message;
    try {
      if (widget.arguments.id != null) {
        var item = await makeArticle();
        id =
            await widget._queryCtr.updateItemInDb(DbTablesNames.articles, item);
        if (id > -1) {
          widget.arguments = item;
          message = S.current.msg_update_item;
        } else {
          message = S.current.msg_update_err;
        }
      } else {
        Article article = await makeArticle();
        article.cmdClient = 0;
        id = await widget._queryCtr
            .addItemToTable(DbTablesNames.articles, article);
        if (id > -1) {
          widget.arguments = article;
          widget.arguments.setId(id);
          message = S.current.msg_ajout_item;
        } else {
          message = S.current.msg_ajout_err;
        }
      }
      if (!modification && editMode) {
        Navigator.pop(context);
      }
      Helpers.showToast(message);
      return Future.value(id);
    } catch (e) {
      Helpers.showToast(S.current.msg_ereure);
      return Future.value(-1);
    }
  }

  Future<Article> makeArticle() async {
    Article article = new Article.init();
    article.setId(widget.arguments.id);

    article.setdesignation(_designationControl.text.trim());
    article.setref(_refControl.text.trim());
    article.setCodeBar(_codeBarControl.text.trim());

    (_prixAchatControl.text.trim() != "")
        ? article.setprixAchat(double.parse(_prixAchatControl.text.trim()))
        : article.setprixAchat(0.0);

    if (!modification && editMode) {
      (_stockInitialControl.text.trim() != "")
          ? article.setQteInit(double.parse(_stockInitialControl.text.trim()))
          : article.setQteInit(0.0);
    } else if (modification) {
      article.setQteInit(widget.arguments.qteInit);
    }

    (_stockInitialControl.text.trim() != "")
        ? article.setquantite(double.parse(_stockInitialControl.text.trim()))
        : article.setquantite(0.0);
    (_stockMinimumControl.text.trim() != "")
        ? article.setQteMin(double.parse(_stockMinimumControl.text.trim()))
        : article.setQteMin(0.0);
    (_qteCmdCotrol.text.trim() != "")
        ? article.cmdClient = double.parse(_qteCmdCotrol.text.trim())
        : article.cmdClient = 0.0;

    (_pmpControl.text.trim() != "")
        ? article.setPmp(double.parse(_pmpControl.text.trim()))
        : article.setPmp(0.0);

    if (!modification && editMode) {
      article.setPmpInit(article.pmp);
    } else if (modification) {
      article.setPmpInit(widget.arguments.pmpInit);
    }

    (_qteColisCotrol.text.trim() != "")
        ? article.setQteColis(double.parse(_qteColisCotrol.text.trim()))
        : article.setQteColis(1.0);

    if (_stockInitialControl.text.trim() != "" &&
        _qteColisCotrol.text.trim() != "" &&
        article.quantite > 0) {
      double colis = double.parse(_stockInitialControl.text.trim()) /
          double.parse(_qteColisCotrol.text.trim());
      article.setColis(colis);
    } else {
      article.setColis(0.0);
    }

    (_price1Control.text.trim() != "")
        ? article.setprixVente1(double.parse(_price1Control.text.trim()))
        : article.setprixVente1(0.0);
    (_price2Control.text.trim() != "")
        ? article.setprixVente2(double.parse(_price2Control.text.trim()))
        : article.setprixVente2(0.0);
    (_price3Control.text.trim() != "")
        ? article.setprixVente3(double.parse(_price3Control.text.trim()))
        : article.setprixVente3(0.0);

    article.setIdFamille(_selectedFamille.id);
    article.setIdMarque(_selectedMarque.id);
    article.setTva(_selectedTva.tva);

    double ttc1 =
        (article.prixVente1 * _selectedTva.tva) / 100 + article.prixVente1;
    double ttc2 =
        (article.prixVente2 * _selectedTva.tva) / 100 + article.prixVente2;
    double ttc3 =
        (article.prixVente3 * _selectedTva.tva) / 100 + article.prixVente3;
    article.setprixVente1TTC(ttc1);
    article.setprixVente2TTC(ttc2);
    article.setprixVente3TTC(ttc3);

    article.setDescription(_descriptionControl.text.trim());
    article.setbloquer(_controlBloquer);
    article.setStockable(_stockable);

    if (_articleImage != null) {
      article
          .setImageUint8List(await Helpers.getUint8ListFromFile(_articleImage));
    } else {
      Uint8List image = await Helpers.getDefaultImageUint8List(from: "article");
      article.setImageUint8List(image);
    }

    return article;
  }

  //**********************************************************************************************************************************************************************
  //**************************************************************************partie pecial qr code************************************************************************
  Future scanBarCode() async {
    try {
      var options = ScanOptions(
        strings: {
          "cancel": S.current.annuler,
          "flash_on": S.current.flash_on,
          "flash_off": S.current.flash_off,
        },
      );

      var result = await BarcodeScanner.scan(options: options);
      if (result.rawContent.isNotEmpty) {
        setState(() {
          _codeBarControl.text = result.rawContent;
          FocusScope.of(context).requestFocus(null);
        });
      }
    } catch (e) {
      var result = ScanResult(
        type: ResultType.Error,
        format: BarcodeFormat.unknown,
      );
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          result.rawContent = S.current.msg_cam_permission;
        });
      } else {
        result.rawContent = '${S.current.msg_ereure}: ($e)';
      }
      Helpers.showToast(result.rawContent);
    }
  }

  void _pdaScanner(data) {
    setState(() {
      _codeBarControl.text = data;
      FocusScope.of(context).requestFocus(null);
    });
  }

}
