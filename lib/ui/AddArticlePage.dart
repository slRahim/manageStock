import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/Widgets/CustomWidgets/add_save_bar.dart';
import 'package:gestmob/Widgets/CustomWidgets/bottom_tab_bar.dart';
import 'package:gestmob/Widgets/CustomWidgets/image_picker_widget.dart';
import 'package:gestmob/Widgets/CustomWidgets/list_dropdown.dart';
import 'package:gestmob/models/Article.dart';
import 'package:gestmob/models/ArticleFamille.dart';
import 'package:gestmob/models/ArticleMarque.dart';
import 'package:gestmob/models/ArticleTva.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gestmob/Widgets/utils.dart' as utils;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AddArticlePage extends StatefulWidget {
  /*final QueryCtr queryCtr;
  addArticle({
    Key key,
    @required this.queryCtr,
  }) : super(key: key);*/

  final QueryCtr _queryCtr = QueryCtr();

  Article arguments;
  AddArticlePage({Key key, @required this.arguments}) : super(key: key);

  @override
  _AddArticlePageState createState() => _AddArticlePageState();
}

class _AddArticlePageState extends State<AddArticlePage>  with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool editMode = true;
  bool modification = false;

  bool _stockable = true;

  bool finishedLoading = false;

  String appBarTitle = "Article";

  List<ArticleMarque> _marqueItems;
  List<ArticleFamille> _familleItems;
  List<ArticleTva> _tvaItems;

  List<DropdownMenuItem<ArticleMarque>> _marqueDropdownItems;
  ArticleMarque _selectedMarque;

  List<DropdownMenuItem<ArticleFamille>> _familleDropdownItems;
  ArticleFamille _selectedFamille;

  List<DropdownMenuItem<ArticleTva>> _tvaDropdownItems;
  ArticleTva _selectedTva;

  void initState() {
    super.initState();

    futureInitState().then((val) {
      setState(() {
        finishedLoading = true;
      });
    });
  }

  Future<bool> futureInitState() async {
    _marqueItems = await widget._queryCtr.getAllArticleMarques();
    _familleItems = await widget._queryCtr.getAllArticleFamilles();
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
      await setDataFromArticle(await widget._queryCtr.getTestArticle());

      editMode = true;
    }

    _marqueDropdownItems = utils.buildMarqueDropDownMenuItems(_marqueItems);
    _familleDropdownItems = utils.buildDropFamilleArticle(_familleItems);
    _tvaDropdownItems = utils.buildDropTvaDownMenuItems(_tvaItems);

    return Future<bool>.value(editMode);
  }

  bool price2 = Prefs.PriceCount > 1;
  bool price3 = Prefs.PriceCount > 2;
  bool _validateDes = false;

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

  ArticleFamille _famille = new ArticleFamille.init();
  ArticleMarque _marque = new ArticleMarque.init();
  File _articleImage;

  @override
  Widget build(BuildContext context) {
    if (modification) {
      if (editMode) {
        appBarTitle = "Modification";
      } else {
        appBarTitle = "Article";
      }
    } else {
      if (editMode) {
        appBarTitle = "Ajouter un article";
      } else {
        appBarTitle = "Article";
      }
    }

    if (!finishedLoading) {
      return Scaffold(body: Helpers.buildLoading());
    } else {
      return DefaultTabController(
          length: 3,
          child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: Color(0xFFF1F8FA),
              appBar: AddEditBar(
                editMode: editMode,
                modification: modification,
                title: appBarTitle,
                onCancelPressed: () => {
                  if(modification){
                    if(editMode){
                      Navigator.of(context)
                          .pushReplacementNamed(RoutesKeys.addArticle, arguments: widget.arguments)
                    } else{
                      Navigator.pop(context)
                    }
                  } else{
                    Navigator.pop(context),
                  }
                },
                onEditPressed: () {
                  setState(() {
                    editMode = true;
                  });
                },
                onSavePressed: () async {
                  if (_designationControl.text.isNotEmpty) {
                    int id = await addArticleToDb();
                    if (id > -1) {
                      setState(() {
                        modification = true;
                        editMode = false;
                      });
                    }
                  } else {
                    Helpers.showFlushBar(context, "Please enter désignation");

                    setState(() {
                      _validateDes = true;
                    });
                  }
                },
              ),
              bottomNavigationBar: BottomTabBar(
                tabs: [
                  Tab(child: Column( children: [ Icon(Icons.insert_drive_file),SizedBox(height: 2), Text("Fiche d\'article"), ], )),
                  Tab(child: Column( children: [ Icon(Icons.image), SizedBox(height: 2), Text("Photo"), ], )),
                  Tab(child: Column( children: [ Icon(Icons.description), SizedBox(height: 2), Text("Description"), ], )),
                ],
              ),
              body: Builder(
                builder: (context) => TabBarView(
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
      child: Wrap(
        spacing: 13,
        runSpacing: 13,
        children: [
          TextField(
            enabled: editMode,
            controller: _designationControl,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: 'Entrez la désignation ',
              prefixIcon: Icon(
                Icons.assignment,
                color: Colors.orange[900],
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange[900]),
                  borderRadius: BorderRadius.circular(20)),
              labelText: "Désignation",
              labelStyle: TextStyle(color: Colors.orange[900]),
              errorText: _validateDes ? 'Champ obligatoire' : null,
              enabledBorder: OutlineInputBorder(
                gapPadding: 3.3,
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.orange[900]),
              ),
            ),
          ),
          TextField(
            enabled: editMode,
            controller: _refControl,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.archive,
                color: Colors.blue[700],
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[700]),
                  borderRadius: BorderRadius.circular(20)),
              labelText: "Référence",
              labelStyle: TextStyle(color: Colors.blue[700]),
              enabledBorder: OutlineInputBorder(
                gapPadding: 3.3,
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.blue[700]),
              ),
            ),
          ),

          TextField(
            enabled: editMode,
            controller: _codeBarControl,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              prefixIcon: Icon(
                MdiIcons.barcode,
                color: Colors.blue[700],
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[700]),
                  borderRadius: BorderRadius.circular(20)),
              labelText: "Code à barres",
              labelStyle: TextStyle(color: Colors.blue[700]),
              enabledBorder: OutlineInputBorder(
                gapPadding: 3.3,
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.blue[700]),
              ),
            ),
          ),
          Row(
            children: [
              Visibility(
                visible: _stockable,
                child: Flexible(
                  flex: 10,
                  child: TextField(
                    enabled: editMode && _stockable,
                    controller: _prixAchatControl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.attach_money,
                        color: Colors.blue[700],
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue[700]),
                          borderRadius: BorderRadius.circular(20)),
                      labelText: "Prix d'achat",
                      labelStyle: TextStyle(color: Colors.blue[700]),
                      enabledBorder: OutlineInputBorder(
                        gapPadding: 3.3,
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.blue[700]),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.fromLTRB(_stockable?8:0, 0, 0, 0)),
              Flexible(
                flex: 10,
                child: Container(
                  decoration: editMode? new BoxDecoration(
                    border: Border.all(color: Colors.blueAccent,),
                    borderRadius: BorderRadius.circular(20.0),
                  ) : null,
                  child: CheckboxListTile(
                    title: Text("Stockable", maxLines: 1,),
                    value: _stockable,
                    onChanged: editMode? (bool value) {
                      setState(() {
                        _stockable = value;
                        if(!_stockable){
                          _prixAchatControl.text = "";
                        }
                      });
                    } : null,
                  ),
                ),
              )
            ],
          ),

          Visibility(
            visible: modification && _stockable,
            child: TextField(
              enabled: false,
              controller: _pmpControl,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.archive,
                  color: Colors.blue[700],
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[700]),
                    borderRadius: BorderRadius.circular(20)),
                labelText: "PMP",
                labelStyle: TextStyle(color: Colors.blue[700]),
                enabledBorder: OutlineInputBorder(
                  gapPadding: 3.3,
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.blue[700]),
                ),
              ),
            ),
          ),

          Row(
            children: [
              Flexible(
                child: TextField(
                  enabled: editMode,
                  controller: _stockInitialControl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.apps,
                      color: Colors.blue[700],
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue[700]),
                        borderRadius: BorderRadius.circular(20)),
                    labelText: modification? "Quantité":"Stock initial",
                    labelStyle: TextStyle(color: Colors.blue[700]),
                    enabledBorder: OutlineInputBorder(
                      gapPadding: 3.3,
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.blue[700]),
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(4)),
              Visibility(
                visible: !modification,
                child: Flexible(
                  child: TextField(
                    enabled: editMode,
                    controller: _stockMinimumControl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.apps,
                        color: Colors.blue[700],
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue[700]),
                          borderRadius: BorderRadius.circular(20)),
                      labelText: "Stock minimum",
                      labelStyle: TextStyle(color: Colors.blue[700]),
                      enabledBorder: OutlineInputBorder(
                        gapPadding: 3.3,
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.blue[700]),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          TextField(
            enabled: editMode,
            controller: _price1Control,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.monetization_on,
                color: Colors.blue[700],
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[700]),
                  borderRadius: BorderRadius.circular(20)),
              labelText: "Prix de vente 1",
              labelStyle: TextStyle(color: Colors.blue[700]),
              enabledBorder: OutlineInputBorder(
                gapPadding: 3.3,
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.blue[700]),
              ),
            ),
          ),
          !price2 && !price3
              ? dropdowns()
              : !price2
                  ? Padding(padding: EdgeInsets.zero)
                  : TextField(
                      enabled: editMode,
                      controller: _price2Control,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.monetization_on,
                          color: Colors.blueGrey[700],
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue[700]),
                            borderRadius: BorderRadius.circular(20)),
                        labelText: "Prix de vente 2",
                        labelStyle: TextStyle(color: Colors.blue[700]),
                        enabledBorder: OutlineInputBorder(
                          gapPadding: 3.3,
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.blue[700]),
                        ),
                      ),
                    ),
          !price3
              ? Padding(padding: EdgeInsets.zero)
              : TextField(
                  enabled: editMode,
                  controller: _price3Control,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.monetization_on,
                      color: Colors.blueGrey[500],
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue[700]),
                        borderRadius: BorderRadius.circular(20)),
                    labelText: "Prix de vente 3",
                    labelStyle: TextStyle(color: Colors.blue[700]),
                    enabledBorder: OutlineInputBorder(
                      gapPadding: 3.3,
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.blue[700]),
                    ),
                  ),
                ),
          !price2 && !price3 ? Padding(padding: EdgeInsets.zero) : dropdowns(),
        ],
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////////////

  Widget imageTab() {
    return SingleChildScrollView(
      child: ImagePickerWidget(
        imageFile: _articleImage,
          editMode: editMode, onImageChange: (File imageFile) => {
        _articleImage = imageFile
      }),
    );
  }

  ////////////////////////////////////////////////////////////////////////////////////

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
                borderSide: BorderSide(color: Colors.blue[700]),
                borderRadius: BorderRadius.circular(20)),
            contentPadding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
            labelText: "Description",
            labelStyle: TextStyle(color: Colors.blue[700]),
            alignLabelWithHint: true,
            hintText: "Entrez une description d'article ajouté",
            enabledBorder: OutlineInputBorder(
              gapPadding: 3.3,
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.blue[700]),
            ),
          ),
        )),
      ),
      Padding(padding: EdgeInsets.all(10)),
    ]));
  }

  //////////////////////////////////////////////////////////////////////////////////

  Widget dropdowns() {
    return Center(
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        direction: Axis.horizontal,
        children: [
          ListDropDown(
            leftIcon: Icons.attach_money,
            editMode: editMode,
            libelle: "TVA  ",
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
          ListDropDown(
            editMode: editMode,
            value: _selectedMarque,
            items: _marqueDropdownItems,
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

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Widget addMarquedialogue() {
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Dialog(
          //this right here
          child: SingleChildScrollView(
        child: Container(
          height: 500,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImagePickerWidget(editMode: editMode, scallFactor: 1, onImageChange: (File imageFile) => {
                _marque.setpic(imageFile)
                }),

                Padding(
                  padding: EdgeInsets.only(left: 5, right: 5, bottom: 20),
                  child: TextField(
                    controller: _libelleMarqueControl,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.label,
                        color: Colors.orange[900],
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange[900]),
                          borderRadius: BorderRadius.circular(20)),
                      contentPadding: EdgeInsets.only(left: 10),
                      labelText: "Marque",
                      labelStyle: TextStyle(color: Colors.orange[900]),
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
                    child: RaisedButton(
                      onPressed: () async {
                          setState(() {
                            _marque.setLibelle(_libelleMarqueControl.text);
                            _libelleMarqueControl.text = "";
                          });

                          await addMarqueIfNotExist(_marque);

                          Navigator.pop(context);
                          final snackBar = SnackBar(
                            content: Text(
                              'Marque Ajoutée',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                            ),
                            backgroundColor: Colors.blue,
                            duration: Duration(seconds: 1),
                          );
                          _scaffoldKey.currentState.showSnackBar(snackBar);
                          print(_marque.libelle);
                        }
                      ,
                      child: Text(
                        "Ajouter",
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
      ));
    });
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////
  Widget addFamilledialogue() {
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Builder(
          builder: (context) => Dialog(
                //this right here
                child: SingleChildScrollView(
                  child: Container(
                    height: 500,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ImagePickerWidget(editMode: editMode, scallFactor: 1, onImageChange: (File imageFile) => {
                            _famille.setpic(imageFile)
                          }),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 5, right: 5, bottom: 20, top: 20),
                            child: TextField(
                              controller: _libelleFamilleControl,
                              keyboardType: TextInputType.text,
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
                                labelText: "Famille",
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
                          SizedBox(
                            width: 320.0,
                            child: Padding(
                              padding: EdgeInsets.only(right: 0, left: 0),
                              child: RaisedButton(
                                onPressed: () async {
                                    setState(() {
                                      _famille.setLibelle(
                                          _libelleFamilleControl.text);
                                      _libelleFamilleControl.text = "";
                                    });

                                    await addFamilleIfNotExist(_famille);

                                    Navigator.pop(context);
                                    final snackBar = SnackBar(
                                      content: Text(
                                        'Famille Ajoutée',
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
                                    print(_famille.libelle);
                                  }
                                ,
                                child: Text(
                                  "Ajouter",
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
              ));
    });
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Widget addTVAdialogue() {
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Dialog(
        //this right here
        child: Container(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    "Ajouter une TVA",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )),
                Padding(
                  padding: EdgeInsets.only(left: 5, right: 5, bottom: 20),
                  child: TextField(
                    controller: _tauxTVAControl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        FontAwesome.percent,
                        color: Colors.orange[900],
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange[900]),
                          borderRadius: BorderRadius.circular(20)),
                      contentPadding: EdgeInsets.only(left: 10),
                      labelText: "Taux TVA",
                      labelStyle: TextStyle(color: Colors.orange[900]),
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
                    child: RaisedButton(
                      onPressed: () async {
                          double _taux = double.parse(_tauxTVAControl.text);
                          _tauxTVAControl.text = "";
                          await addTvaIfNotExist(_taux);

                          Navigator.pop(context);
                          final snackBar = SnackBar(
                            content: Text(
                              'TVA ' + _taux.toString() + '% Ajoutée',
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
                      ,
                      child: Text(
                        "Ajouter",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.green[900],
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

  Future<Article> makeArticle() async {
    Article article = new Article.init();
    article.setId(widget.arguments.id);
    article.setdesignation(_designationControl.text);
    article.setQteInit(double.parse(_stockInitialControl.text));
    article.setquantite(double.parse(_stockInitialControl.text));
    article.setQteMin(double.parse(_stockMinimumControl.text));
    if(_stockable){
      article.setprixAchat(double.parse(_prixAchatControl.text));
    }

    article.setref(_refControl.text);
    article.setCodeBar(_codeBarControl.text);
    article.setDescription(_descriptionControl.text);
    article.setprixVente1(double.parse(_price1Control.text));
    article.setprixVente2(double.parse(_price2Control.text));
    article.setprixVente3(double.parse(_price3Control.text));
    // article.setIdFamille(int.parse(_libelleFamilleControl.text));
    // article.setIdMarque(int.parse(_libelleMarqueControl.text));
    article.setIdFamille(_familleItems.indexOf(_selectedFamille));
    article.setIdMarque(_marqueItems.indexOf(_selectedMarque));
    article.setTva(_selectedTva.tva);

    article.setbloquer(false);
    article.setStockable(_stockable);

    if (_articleImage != null) {
      article.setImageUint8List(Helpers.getUint8ListFromFile(_articleImage));
    } else{
      Uint8List image = await Helpers.getDefaultImageUint8List();
      article.setImageUint8List(image);
    }
    return article;
  }

  Future<void> setDataFromArticle(Article article) async {
    _designationControl.text = article.designation;
    _stockInitialControl.text = article.quantiteInit.toString();
    _stockMinimumControl.text = article.quantite.toString();
    _prixAchatControl.text = article.prixAchat.toString();
    _refControl.text = article.ref;
    _stockable = article.stockable;
    _codeBarControl.text = article.codeBar;
    if(_pmpControl.text != null){
      _pmpControl.text = article.pmp.toString();
    }

    _descriptionControl.text = article.description;
    _price1Control.text = article.prixVente1.toString();
    _price2Control.text = article.prixVente2.toString();
    _price3Control.text = article.prixVente3.toString();
    // _tauxTVAControl.text = article.tva.toString();
    _articleImage = await Helpers.getFileFromUint8List(article.imageUint8List);

    _selectedMarque = _marqueItems[article.idMarque];
    _selectedFamille = _familleItems[article.idFamille];
    _selectedTva = new ArticleTva(article.tva);

    // addTvaIfNotExist(article.tva);

    // article = new Article(_image, "_designation", "_ref", 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, false);
  }

  Future<void> addTvaIfNotExist(double tvaDouble) async {
    ArticleTva tvaItem = new ArticleTva(tvaDouble);
    int tvaIndex = _tvaItems.indexOf(tvaItem);
    if (tvaIndex > -1) {
      _selectedTva = _tvaItems[tvaIndex];
    } else {
      await widget._queryCtr.addItemToTable(DbTablesNames.articlesTva, new ArticleTva(tvaDouble));

      _tvaItems.add(tvaItem);
      _tvaItems.sort((a, b) => a.tva.compareTo(b.tva));
      _tvaDropdownItems = utils.buildDropTvaDownMenuItems(_tvaItems);
      _selectedTva = _tvaItems[_tvaItems.indexOf(tvaItem)];
    }
  }

  Future<void> addMarqueIfNotExist(ArticleMarque marque) async {
    int marqueIndex = _marqueItems.indexOf(marque);
    if (marqueIndex > -1) {
      _selectedMarque = _marqueItems[marqueIndex];
    } else {
      int id = await widget._queryCtr.addItemToTable(DbTablesNames.articlesMarques, marque);
      marque.id = id;

      _marqueItems.add(marque);
      _marqueDropdownItems = utils.buildMarqueDropDownMenuItems(_marqueItems);
      _selectedMarque = _marqueItems[_marqueItems.length];
    }
  }

  Future<void> addFamilleIfNotExist(ArticleFamille famille) async {
    int familleIndex = _familleItems.indexOf(famille);
    if (familleIndex > -1) {
      _selectedFamille = _familleItems[familleIndex];
    } else {
      int id = await widget._queryCtr.addItemToTable(DbTablesNames.articlesTva, famille);
      famille.id = id;

      _familleItems.add(famille);
      _familleDropdownItems =
          utils.buildDropFamilleArticle(_familleItems);
      _selectedFamille = _familleItems[_familleItems.length];
    }
  }

  Future<int> addArticleToDb() async {
    int id = -1;
    String message;
    try {
      if (widget.arguments.id != null) {
        id = await widget._queryCtr.updateItemInDb(DbTablesNames.articles, await makeArticle());
        if (id > -1) {
          message = "Article has been updated successfully";
        } else {
          message = "Error when updating article in db";
        }
      } else {
        Article article = await makeArticle();
        id = await widget._queryCtr.addItemToTable(DbTablesNames.articles, article);
        if (id > -1) {
          widget.arguments = article;
          widget.arguments.setId(id);
          message = "Article has been added successfully";
        } else {
          message = "Error when adding article to db";
        }
      }
      Helpers.showFlushBar(context, message);
      return Future.value(id);
    } catch (e) {
      Helpers.showFlushBar(context, "Error: something went wrong");
      return Future.value(-1);
    }

    // widget._queryCtr.saveTestArticle();
  }


}
