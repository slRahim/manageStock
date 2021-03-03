import 'dart:io';
import 'dart:typed_data';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/Widgets/CustomWidgets/add_save_bar.dart';
import 'package:gestmob/Widgets/CustomWidgets/bottom_tab_bar.dart';
import 'package:gestmob/Widgets/CustomWidgets/image_picker_widget.dart';
import 'package:gestmob/Widgets/CustomWidgets/list_dropdown.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/Article.dart';
import 'package:gestmob/models/ArticleFamille.dart';
import 'package:gestmob/models/ArticleMarque.dart';
import 'package:gestmob/models/ArticleTva.dart';
import 'package:gestmob/models/MyParams.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gestmob/Widgets/utils.dart' as utils;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
  TextEditingController _qteColisCotrol = new TextEditingController();
  TextEditingController _qteCmdCotrol = new TextEditingController();

  ArticleFamille _famille = new ArticleFamille.init();
  ArticleMarque _marque = new ArticleMarque.init();
  File _articleImage;

  MyParams _myParams;

  QueryCtr _queryCtr = new QueryCtr();

  final _formKey = GlobalKey<FormState>();

  TabController _tabController;
  int _tabSelectedIndex = 0;

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
    _prixAchatControl.text = article.prixAchat.toString();
    _refControl.text = article.ref;
    _stockable = article.stockable;
    _codeBarControl.text = article.codeBar;
    _qteColisCotrol.text = article.quantiteColis.toString();
    _qteCmdCotrol.text = article.cmdClient.toString();
    _colisControl.text = article.colis.toString();

    if (_pmpControl.text != null) {
      _pmpControl.text = article.pmp.toString();
    }

    _descriptionControl.text = article.description;
    _price1Control.text = article.prixVente1.toString();
    _price2Control.text = article.prixVente2.toString();
    _price3Control.text = article.prixVente3.toString();
    _selectedMarque = _marqueItems[article.idMarque];
    _selectedFamille = _familleItems[article.idFamille];
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
        appBarTitle = "${S.current.ajouter} ${S.current.article_titre}";
      } else {
        appBarTitle = S.current.article_titre;
      }
    }

    if (!finishedLoading) {
      return Scaffold(body: Helpers.buildLoading());
    } else {
      return DefaultTabController(
          length: 3,
          child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: Theme.of(context).backgroundColor,
              appBar: AddEditBar(
                editMode: editMode,
                modification: modification,
                title: appBarTitle,
                onCancelPressed: () => {
                  if (modification)
                    {
                      if (editMode)
                        {
                          Navigator.of(context).pushReplacementNamed(
                              RoutesKeys.addArticle,
                              arguments: widget.arguments)
                        }
                      else
                        {
                          Navigator.pop(context),
                        }
                    }
                  else
                    {
                      Navigator.pop(context),
                    }
                },
                onEditPressed: () {
                  setState(() {
                    editMode = true;
                  });
                },
                onSavePressed: () async {
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
                      Helpers.showFlushBar(
                          context, "${S.current.msg_champs_obg}");
                    }
                  } else {
                    setState(() {
                      _tabSelectedIndex = 0;
                      _tabController.index = _tabSelectedIndex;
                    });
                  }
                },
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
                      Text("${S.current.fiche_art}"),
                    ],
                  )),
                  Tab(
                      child: Column(
                    children: [
                      Icon(Icons.image),
                      SizedBox(height: 1),
                      Text(S.current.photo),
                    ],
                  )),
                  Tab(
                      child: Column(
                    children: [
                      Icon(Icons.description),
                      SizedBox(height: 1),
                      Text(S.current.description),
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
              )));
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
                labelStyle: TextStyle(color: Colors.green),
                hintText: S.current.msg_entre_design,
                prefixIcon: Icon(
                  Icons.assignment,
                  color: Colors.blue,
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.circular(20)),
                enabledBorder: OutlineInputBorder(
                  gapPadding: 3.3,
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.green),
                ),
                errorBorder: OutlineInputBorder(
                  gapPadding: 3.3,
                  borderRadius: BorderRadius.circular(20),
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
                labelStyle: TextStyle(color: Colors.blue),
                prefixIcon: Icon(
                  Icons.archive,
                  color: Colors.blue,
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(20)),
                enabledBorder: OutlineInputBorder(
                  gapPadding: 3.3,
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                errorBorder: OutlineInputBorder(
                  gapPadding: 3.3,
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
            ),
            InkWell(
              onDoubleTap: () async {
                await scanBarCode();
              },
              child: TextFormField(
                enabled: editMode,
                controller: _codeBarControl,
                onTap: () => _codeBarControl.selection = TextSelection(baseOffset: 0, extentOffset: _codeBarControl.value.text.length),
                keyboardType: TextInputType.text,
                // validator: (value) {
                //   if (value.isEmpty) {
                //     return S.current.msg_champ_oblg;
                //   }
                //   return null;
                // },
                decoration: InputDecoration(
                  labelText: S.current.msg_scan_barcode,
                  labelStyle: TextStyle(color: Colors.blue),
                  prefixIcon: Icon(
                    MdiIcons.barcode,
                    color: Colors.blue,
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(20)),
                  enabledBorder: OutlineInputBorder(
                    gapPadding: 3.3,
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  errorBorder: OutlineInputBorder(
                    gapPadding: 3.3,
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Visibility(
                  visible: true,
                  child: Flexible(
                    flex: 5,
                    child: TextFormField(
                      enabled: editMode && _stockable,
                      controller: _prixAchatControl,
                      onTap: () => _prixAchatControl.selection = TextSelection(baseOffset: 0, extentOffset: _prixAchatControl.value.text.length),
                      onChanged: (value){
                        setState(() {
                          _pmpControl.text = value ;
                        });
                      },
                      keyboardType: TextInputType.number,
                      // validator: (value) {
                      //   if (value.isEmpty) {
                      //     return S.current.msg_champ_oblg;
                      //   }
                      //   return null;
                      // },

                      decoration: InputDecoration(
                          labelText: S.current.prix_achat,
                          labelStyle: TextStyle(color: Colors.blue),
                          prefixIcon: Icon(
                            Icons.attach_money,
                            color: Colors.blue,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(20)),
                          enabledBorder: OutlineInputBorder(
                            gapPadding: 3.3,
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          errorBorder: OutlineInputBorder(
                            gapPadding: 3.3,
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.red),
                          )),
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(_stockable ? 8 : 0, 0, 0, 0)),
                Visibility(
                  visible: false,
                  child: Flexible(
                    flex: 5,
                    child: Container(
                      decoration: editMode
                          ? new BoxDecoration(
                              border: Border.all(
                                color: Colors.blueAccent,
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                            )
                          : null,
                      child: CheckboxListTile(
                        title: Text(
                          S.current.stockable,
                          maxLines: 1,
                          style: TextStyle(
                              color: Theme.of(context).primaryColorDark),
                        ),
                        value: _stockable,
                        onChanged: editMode
                            ? (bool value) {
                                setState(() {
                                  _stockable = value;
                                  if (!_stockable) {
                                    _prixAchatControl.text = "";
                                  }
                                });
                              }
                            : null,
                      ),
                    ),
                  ),
                )
              ],
            ),
            Visibility(
              visible: true,
              child: TextFormField(
                enabled: editMode,
                controller: _pmpControl,
                // onTap: () => _pmpControl.selection = TextSelection(baseOffset: 0, extentOffset: _pmpControl.value.text.length),
                keyboardType: TextInputType.number,
                // validator: (value) {
                //   if (value.isEmpty) {
                //     return S.current.msg_champ_oblg;
                //   }
                //   return null;
                // },
                decoration: InputDecoration(
                    labelText: (modification)
                        ? S.current.pmp
                        : "${S.current.pmp} ${S.current.init}",
                    labelStyle: TextStyle(color: Colors.blue),
                    prefixIcon: Icon(
                      Icons.archive,
                      color: Colors.blue,
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(20)),
                    enabledBorder: OutlineInputBorder(
                      gapPadding: 3.3,
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    errorBorder: OutlineInputBorder(
                      gapPadding: 3.3,
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.red),
                    )),
              ),
            ),
            Row(
              children: [
                Flexible(
                  child: TextFormField(
                    enabled: editMode,
                    controller: _stockInitialControl,
                    onTap: () => _stockInitialControl.selection = TextSelection(baseOffset: 0, extentOffset: _stockInitialControl.value.text.length),
                    keyboardType: TextInputType.number,
                    // validator: (value) {
                    //   if (value.isEmpty) {
                    //     return S.current.msg_champ_oblg;
                    //   }
                    //   return null;
                    // },
                    decoration: InputDecoration(
                      labelText: modification
                          ? S.current.quantit
                          : S.current.stock_init,
                      labelStyle: TextStyle(color: Colors.blue),
                      prefixIcon: Icon(
                        Icons.apps,
                        color: Colors.blue,
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(20)),
                      enabledBorder: OutlineInputBorder(
                        gapPadding: 3.3,
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      errorBorder: OutlineInputBorder(
                        gapPadding: 3.3,
                        borderRadius: BorderRadius.circular(20),
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
                    onTap: () => _stockMinimumControl.selection = TextSelection(baseOffset: 0, extentOffset: _stockMinimumControl.value.text.length),
                    keyboardType: TextInputType.number,
                    // validator: (value) {
                    //   if (value.isEmpty) {
                    //     return S.current.msg_champ_oblg;
                    //   }
                    //   return null;
                    // },
                    decoration: InputDecoration(
                      labelText: S.current.stock_min,
                      labelStyle: TextStyle(color: Colors.blue),
                      prefixIcon: Icon(
                        Icons.apps,
                        color: Colors.blue,
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(20)),
                      enabledBorder: OutlineInputBorder(
                        gapPadding: 3.3,
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      errorBorder: OutlineInputBorder(
                        gapPadding: 3.3,
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  flex: 5,
                  child: Visibility(
                    child: TextFormField(
                      enabled: editMode,
                      controller: _qteColisCotrol,
                      onTap: () => _qteColisCotrol.selection = TextSelection(baseOffset: 0, extentOffset: _qteColisCotrol.value.text.length),
                      keyboardType: TextInputType.number,
                      // validator: (value) {
                      //   if (value.isEmpty) {
                      //     return S.current.msg_champ_oblg;
                      //   }
                      //   return null;
                      // },
                      decoration: InputDecoration(
                        labelText: S.current.qte_colis,
                        labelStyle: TextStyle(color: Colors.blue),
                        prefixIcon: Icon(
                          Icons.shopping_bag_rounded,
                          color: Colors.blue[700],
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(20)),
                        enabledBorder: OutlineInputBorder(
                          gapPadding: 3.3,
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        errorBorder: OutlineInputBorder(
                          gapPadding: 3.3,
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5,),
                Flexible(
                  flex: 5,
                  child: TextFormField(
                    enabled: editMode,
                    controller: _qteCmdCotrol,
                    onTap: () => _qteCmdCotrol.selection = TextSelection(baseOffset: 0, extentOffset: _qteCmdCotrol.value.text.length),
                    keyboardType: TextInputType.number,
                    // validator: (value) {
                    //   if (value.isEmpty) {
                    //     return S.current.msg_champ_oblg;
                    //   }
                    //   return null;
                    // },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.apps_outlined,
                        color: Colors.blue,
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(20)),
                      labelText: S.current.qte_cmd,
                      labelStyle: TextStyle(color: Colors.blue),
                      enabledBorder: OutlineInputBorder(
                        gapPadding: 3.3,
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      errorBorder: OutlineInputBorder(
                        gapPadding: 3.3,
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: modification && !editMode,
              child: TextFormField(
                enabled: false,
                controller: _colisControl,
                onTap: () => _colisControl.selection = TextSelection(baseOffset: 0, extentOffset: _colisControl.value.text.length),
                keyboardType: TextInputType.number,
                // validator: (value) {
                //   if (value.isEmpty) {
                //     return S.current.msg_champ_oblg;
                //   }
                //   return null;
                // },
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.archive,
                    color: Colors.blue,
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(20)),
                  labelText: S.current.colis,
                  labelStyle: TextStyle(color: Colors.blue),
                  enabledBorder: OutlineInputBorder(
                    gapPadding: 3.3,
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  errorBorder: OutlineInputBorder(
                    gapPadding: 3.3,
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
              ),
            ),
            TextFormField(
              enabled: editMode,
              controller: _price1Control,
              onTap: () => _price1Control.selection = TextSelection(baseOffset: 0, extentOffset: _price1Control.value.text.length),
              keyboardType: TextInputType.number,
              // validator: (value) {
              //   if (value.isEmpty) {
              //     return S.current.msg_champ_oblg;
              //   }
              //   return null;
              // },
              decoration: InputDecoration(
                labelText: S.current.prix_v1,
                labelStyle: TextStyle(color: Colors.blue),
                prefixIcon: Icon(
                  Icons.monetization_on,
                  color: Colors.blue,
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(20)),
                enabledBorder: OutlineInputBorder(
                  gapPadding: 3.3,
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                errorBorder: OutlineInputBorder(
                  gapPadding: 3.3,
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
            ),
            Visibility(
              visible: _price2,
              child: TextFormField(
                enabled: editMode,
                controller: _price2Control,
                onTap: () => _price2Control.selection = TextSelection(baseOffset: 0, extentOffset: _price2Control.value.text.length),
                keyboardType: TextInputType.number,
                // validator: (value) {
                //   if (value.isEmpty && _price2) {
                //     return S.current.msg_champ_oblg;
                //   }
                //   return null;
                // },
                decoration: InputDecoration(
                  labelText: S.current.prix_v2,
                  labelStyle: TextStyle(color: Colors.blue),
                  prefixIcon: Icon(
                    Icons.monetization_on,
                    color: Colors.blueGrey[700],
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(20)),
                  enabledBorder: OutlineInputBorder(
                    gapPadding: 3.3,
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  errorBorder: OutlineInputBorder(
                    gapPadding: 3.3,
                    borderRadius: BorderRadius.circular(20),
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
                onTap: () => _price3Control.selection = TextSelection(baseOffset: 0, extentOffset: _price3Control.value.text.length),
                keyboardType: TextInputType.number,
                // validator: (value) {
                //   if (value.isEmpty && _price3) {
                //     return S.current.msg_champ_oblg;
                //   }
                //   return null;
                // },
                decoration: InputDecoration(
                  labelText: S.current.prix_v3,
                  labelStyle: TextStyle(color: Colors.blue),
                  prefixIcon: Icon(
                    Icons.monetization_on,
                    color: Colors.blueGrey[500],
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(20)),
                  enabledBorder: OutlineInputBorder(
                    gapPadding: 3.3,
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  errorBorder: OutlineInputBorder(
                    gapPadding: 3.3,
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
              ),
            ),
            dropdowns(),
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
          onImageChange: (File imageFile){
            setState(() {
              _articleImage = imageFile ;
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
                borderRadius: BorderRadius.circular(20)),
            contentPadding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
            labelText: S.current.description,
            labelStyle: TextStyle(color: Colors.blue),
            alignLabelWithHint: true,
            hintText: S.current.msg_description,
            enabledBorder: OutlineInputBorder(
              gapPadding: 3.3,
              borderRadius: BorderRadius.circular(20),
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
                  ("${S.current.taux_tva}: ${_selectedTva.tva.toString()} %"),
              value: _selectedTva,
              items: _tvaDropdownItems,
              onChanged: (value) {
                setState(() {
                  _selectedTva = value;
                });
              },
              onAddPressed: () async {
                await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return addTVAdialogue();
                    }).then((val) {
                  setState(() {});
                });
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
              await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return addMarquedialogue();
                  }).then((val) {
                setState(() {});
              });
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
              await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return addFamilledialogue();
                  }).then((val) {
                setState(() {});
              });
            },
          ),
        ],
      ),
    );
  }

  Widget addMarquedialogue() {
    _marque = new ArticleMarque.init();
    var _formKey = GlobalKey<FormState>() ;
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Dialog(
          //this right here
          child: SingleChildScrollView(
        child: Container(
          height: 200,
          padding: EdgeInsets.all(10),
          child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ImagePickerWidget(
                //     editMode: editMode,
                //     scallFactor: 1,
                //     onImageChange: (File imageFile) {
                //       _marque.setpic(imageFile) ;
                //     }
                // ),
                Padding(
                  padding: EdgeInsets.only(left: 5, right: 5, bottom: 20),
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
                          color: Colors.orange[900],
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange[900]),
                            borderRadius: BorderRadius.circular(20)),
                        contentPadding: EdgeInsets.only(left: 10),
                        labelText: S.current.marque,
                        labelStyle: TextStyle(color: Colors.orange[900]),
                        enabledBorder: OutlineInputBorder(
                          gapPadding: 3.3,
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.orange[900]),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 320.0,
                  child: Padding(
                    padding: EdgeInsets.only(right: 0, left: 0),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      onPressed: () async {
                        if(_formKey.currentState.validate()){
                          setState(() {
                            _marque.setLibelle(_libelleMarqueControl.text);
                            _libelleMarqueControl.text = "";
                          });

                          await addMarqueIfNotExist(_marque);

                          Navigator.pop(context);
                          final snackBar = SnackBar(
                            content: Text(
                              S.current.msg_ajout_item,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                            ),
                            backgroundColor: Colors.blue,
                            duration: Duration(seconds: 1),
                          );
                          _scaffoldKey.currentState.showSnackBar(snackBar);
                        }

                      },
                      child: Text(
                        S.current.ajouter,
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blue,
                    ),
                  ),
                )
              ],
            ),
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
    var _formKey = GlobalKey<FormState>() ;
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Builder(
          builder: (context) => Dialog(
                //this right here
                child: SingleChildScrollView(
                  child: Container(
                    height: 200,
                    padding: EdgeInsets.all(10),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ImagePickerWidget(
                          //     editMode: editMode,
                          //     scallFactor: 1,
                          //     onImageChange: (File imageFile) =>
                          //         {_famille.setpic(imageFile)}),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 5, right: 5, bottom: 20, top: 20),
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
                                    color: Colors.orange[900],
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.orange[900]),
                                      borderRadius: BorderRadius.circular(20)),
                                  contentPadding: EdgeInsets.only(left: 10),
                                  labelText: S.current.famile,
                                  labelStyle:
                                      TextStyle(color: Colors.orange[900]),
                                  enabledBorder: OutlineInputBorder(
                                    gapPadding: 3.3,
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                        BorderSide(color: Colors.orange[900]),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 320.0,
                            child: Padding(
                              padding: EdgeInsets.only(right: 0, left: 0),
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                onPressed: () async {
                                  if(_formKey.currentState.validate()){
                                    setState(() {
                                      _famille.setLibelle(
                                          _libelleFamilleControl.text);
                                      _libelleFamilleControl.text = "";
                                    });

                                    await addFamilleIfNotExist(_famille);

                                    Navigator.pop(context);
                                    final snackBar = SnackBar(
                                      content: Text(
                                        S.current.msg_ajout_item,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      backgroundColor: Colors.red,
                                      duration: Duration(seconds: 1),
                                    );
                                    _scaffoldKey.currentState
                                        .showSnackBar(snackBar);
                                  }
                                },
                                child: Text(
                                  S.current.ajouter,
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: Colors.red,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
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
    var _formKey = GlobalKey<FormState>() ;
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Dialog(
        //this right here
        child: Container(
          height: 200,
          padding: EdgeInsets.all(10),
          child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    "${S.current.ajouter} ${S.current.tva}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )),
                Padding(
                  padding: EdgeInsets.only(left: 5, right: 5, bottom: 20),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _tauxTVAControl,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.isEmpty) {
                          return S.current.msg_champ_oblg;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          FontAwesome.percent,
                          color: Colors.orange[900],
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange[900]),
                            borderRadius: BorderRadius.circular(20)),
                        contentPadding: EdgeInsets.only(left: 10),
                        labelText: S.current.taux_tva,
                        labelStyle: TextStyle(color: Colors.orange[900]),
                        enabledBorder: OutlineInputBorder(
                          gapPadding: 3.3,
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.orange[900]),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 320.0,
                  child: Padding(
                    padding: EdgeInsets.only(right: 0, left: 0),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      onPressed: () async {
                        if(_formKey.currentState.validate()){
                          double _taux = double.parse(_tauxTVAControl.text);
                          _tauxTVAControl.text = "";
                          await addTvaIfNotExist(_taux);
                          Navigator.pop(context);
                          final snackBar = SnackBar(
                            content: Text(
                              '${S.current.tva} ' + _taux.toString() + '%',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                            ),
                            backgroundColor: Colors.green[900],
                            duration: Duration(seconds: 1),
                          );
                          _scaffoldKey.currentState.showSnackBar(snackBar);
                        }

                      },
                      child: Text(
                        S.current.ajouter,
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.green[900],
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
        id = await widget._queryCtr
            .updateItemInDb(DbTablesNames.articles, await makeArticle());
        if (id > -1) {
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
      Helpers.showFlushBar(context, message);
      return Future.value(id);
    } catch (e) {
      Helpers.showFlushBar(context, S.current.msg_ereure);
      return Future.value(-1);
    }
  }

  Future<Article> makeArticle() async {
    Article article = new Article.init();
    article.setId(widget.arguments.id);

    article.setdesignation(_designationControl.text);
    article.setref(_refControl.text);
    article.setCodeBar(_codeBarControl.text);

    //reliere à _stockable
    if (true) {
      (_prixAchatControl.text != "" )?article.setprixAchat(double.parse(_prixAchatControl.text)):article.setprixAchat(0.0);
    }

    (_stockInitialControl.text != "" )?article.setQteInit(double.parse(_stockInitialControl.text)):article.setQteInit(0.0);
    (_stockInitialControl.text != "" )?article.setquantite(double.parse(_stockInitialControl.text)):article.setquantite(0.0);
    (_stockMinimumControl.text != "" )?article.setQteMin(double.parse(_stockMinimumControl.text)):article.setQteMin(0.0);
    (_qteCmdCotrol.text != "" )?article.cmdClient = double.parse(_qteCmdCotrol.text):article.cmdClient =0.0;

    (_pmpControl.text != "" )?article.setPmp(double.parse(_pmpControl.text)):article.setPmp(0.0);
    if (!modification && editMode) {
      (_pmpControl.text != "" )?article.setPmpInit(double.parse(_pmpControl.text)):article.setPmpInit(0.0);
    }

    (_qteColisCotrol.text != "" )?article.setQteColis(double.parse(_qteColisCotrol.text)):article.setQteColis(1.0);
    if(_stockInitialControl.text != "" && _qteColisCotrol.text != ""){
      double colis = double.parse(_stockInitialControl.text) /
          double.parse(_qteColisCotrol.text);
      article.setColis(colis);
    }else{
      article.setColis(0.0);
    }

    (_price1Control.text != "" )?article.setprixVente1(double.parse(_price1Control.text)):article.setprixVente1(0.0);
    (_price2Control.text != "" )?article.setprixVente2(double.parse(_price2Control.text)):article.setprixVente2(0.0);
    (_price3Control.text != "" )?article.setprixVente3(double.parse(_price3Control.text)):article.setprixVente3(0.0);

    article.setIdFamille(_familleItems.indexOf(_selectedFamille));
    article.setIdMarque(_marqueItems.indexOf(_selectedMarque));
    article.setTva(_selectedTva.tva);


    double ttc1 = (article.prixVente1 * _selectedTva.tva) / 100 + article.prixVente1 ;
    double ttc2 = (article.prixVente2  * _selectedTva.tva) / 100 +article.prixVente2 ;
    double ttc3 = (article.prixVente3  * _selectedTva.tva) / 100 +article.prixVente3;
    article.setprixVente1TTC(ttc1);
    article.setprixVente2TTC(ttc2);
    article.setprixVente3TTC(ttc3);


    article.setDescription(_descriptionControl.text);
    article.setbloquer(false);
    article.setStockable(true);

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
}
