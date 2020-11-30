
// import 'dart:html';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/Widgets/CustomWidgets/add_save_bar.dart';
import 'package:gestmob/Widgets/CustomWidgets/bottom_tab_bar.dart';
import 'package:gestmob/Widgets/CustomWidgets/image_picker_widget.dart';
import 'package:gestmob/Widgets/CustomWidgets/list_dropdown.dart';
import 'package:gestmob/Widgets/article_list_item.dart';
import 'package:gestmob/Widgets/total_devis.dart';
import 'package:gestmob/models/Article.dart';
import 'package:gestmob/models/FormatPiece.dart';
import 'package:gestmob/models/Journaux.dart';
import 'package:gestmob/models/Piece.dart';
import 'package:gestmob/models/Tiers.dart';
import 'package:gestmob/models/TiersFamille.dart';
import 'package:gestmob/search/items_sliver_list.dart';
import 'package:gestmob/search/sliver_list_data_source.dart';
import 'package:gestmob/ui/ClientFourFragment.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gestmob/Widgets/utils.dart' as utils;
import 'package:map_launcher/map_launcher.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'ArticlesFragment.dart';

class AddPiecePage extends StatefulWidget {
  var arguments;
  AddPiecePage({Key key, @required this.arguments}) : super(key: key);

  @override
  _AddPiecePageState createState() => _AddPiecePageState();
}

class _AddPiecePageState extends State<AddPiecePage> with TickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Piece _piece = new Piece.init();

  bool editMode = true;
  bool modification = false;
  bool _islisting = false ;

  bool finishedLoading = false;

  String appBarTitle = "Devis";

  List<Article> _selectedItems = new List<Article>();
  List<Article> _desSelectedItems = new List<Article>();
  Tiers _selectedClient;

  List<int> _tarificationItems = Statics.tarificationItems ;
  List<DropdownMenuItem<int>> _tarificationDropdownItems;
  int _selectedTarification;

  bool _validateRaison = false;

  TextEditingController _numeroControl = new TextEditingController();
  TextEditingController _dateControl = new TextEditingController();
  TextEditingController _clientControl = new TextEditingController();
  TextEditingController _verssementControler = new TextEditingController();
  TextEditingController _resteControler = new TextEditingController();
  String _validateVerssemntError;
  double _restepiece ;
  double _verssementpiece ;

  SliverListDataSource _dataSource;
  QueryCtr _queryCtr;

  BottomBarController bottomBarControler;

  void initState() {
    super.initState();
    bottomBarControler = BottomBarController(vsync: this, dragLength: 450, snap: true);
    _dataSource = SliverListDataSource(ItemsListTypes.articlesList, new Map<String, dynamic>());
    _queryCtr = _dataSource.queryCtr;
    futureInitState().then((val) {
      setState(() {
        finishedLoading = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> futureInitState() async {
    _tarificationDropdownItems = utils.buildDropTarificationTier(_tarificationItems);
    _selectedTarification = _tarificationItems[0];
    if (widget.arguments is Piece && widget.arguments.id != null && widget.arguments.id > -1) {
      editMode = false;
      modification = true;
      await setDataFromItem(widget.arguments);
    } else {
      await setDataFromItem(null);
      await getNumPiece(widget.arguments);
      _piece.date = DateTime.now() ;
      _dateControl.text = Helpers.dateToText(DateTime.now());
      editMode = true;
    }
    return Future<bool>.value(editMode);
  }

  Future<void> setDataFromItem(Piece item) async {
    if(item != null){
      _piece = item;
      _numeroControl.text = _piece.num_piece;
      DateTime time = _piece.date ?? new DateTime.now();
      _piece.date = time;
      _dateControl.text = Helpers.dateToText(time);
      _selectedClient = await _queryCtr.getTierById(_piece.tier_id);
      _clientControl.text = _selectedClient.raisonSociale;
      _selectedTarification = _selectedClient.tarification;
      _selectedItems= await _queryCtr.getJournalPiece(item);
      _verssementControler.text = _piece.regler.toString();
      _resteControler.text = _piece.reste.toString();
      _restepiece=_piece.reste ;
      _verssementpiece=_piece.regler;
    }else{
      _piece.piece = widget.arguments.piece ;
      _selectedClient = await _queryCtr.getTierById(1);
      _clientControl.text = _selectedClient.raisonSociale;
      _selectedTarification = _selectedClient.tarification;
      _verssementControler.text = "0.0";
      _resteControler.text ="0.0";
      _restepiece = 0 ;
      _verssementpiece = 0 ;
    }

  }

  Future<void> getNumPiece(item) async{
    _piece.piece = item.piece ;
    List<FormatPiece> list = await _queryCtr.getFormatPiece(_piece.piece);
    setState(() {
      _numeroControl.text = Helpers.generateNumPiece(list.first);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (modification) {
      if (editMode) {
        appBarTitle = "Modification";
        _islisting = false ;
      } else {
        appBarTitle = Helpers.getPieceTitle(_piece.piece);
        _islisting = true ;
      }
    } else {
      if (editMode) {
        appBarTitle = "Ajouter "+Helpers.getPieceTitle(_piece.piece);
        _islisting=false ;
      } else {
        appBarTitle = Helpers.getPieceTitle(_piece.piece);
        _islisting = true ;
      }
    }

    if (!finishedLoading) {
      return Scaffold(body: Helpers.buildLoading());
    } else {
      return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Color(0xFFF1F8FA),
          appBar: AddEditBar(
            editMode: editMode,
            modification: modification,
            title: appBarTitle,
            onCancelPressed: () => {
              if (modification){
                  if (editMode){
                      Navigator.of(context).pushReplacementNamed(RoutesKeys.addPiece, arguments: widget.arguments)
                    }
                  else {Navigator.pop(context)}
                }
              else{
                  Navigator.pop(context),
                }
            },
            onEditPressed: () {
              setState(() {
                editMode = true;
              });
            },
            onSavePressed: () async {
              if (_selectedItems.length > 0) {
                await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return addChoicesDialog();
                    });
              } else {
                Helpers.showFlushBar(context, "Please select at least one article");
                setState(() {
                  _validateRaison = true;
                });
              }
            },
          ),
          // extendBody: true,
          bottomNavigationBar: BottomExpandableAppBar(
            controller: bottomBarControler,
            horizontalMargin: 15,
            shape: AutomaticNotchedShape(
                RoundedRectangleBorder(), StadiumBorder(side: BorderSide())),
            expandedBackColor: Colors.lightBlueAccent,
            expandedBody: TotalDevis(piece: _piece),
            bottomAppBarBody: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'TTC : '+
                      _piece.total_ttc.toString()+" DA",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  InkWell(
                    onTap: ()async{
                      if(editMode){
                        if(_piece.piece != PieceType.devis){
                          await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return addVerssementdialogue();
                              });
                        }
                      }
                    },
                    child: Container(
                        padding: EdgeInsets.only(right: 30),
                        child:Text("Reste : "+_restepiece.toString(), textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold
                          ),
                        )
                      ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: GestureDetector(
            // Set onVerticalDrag event to drag handlers of controller for swipe effect
            onVerticalDragUpdate: bottomBarControler.onDrag,
            onVerticalDragEnd: bottomBarControler.onDragEnd,
            child: FloatingActionButton.extended(
              label: Text("+ Add"),
              elevation: 2,
              backgroundColor: editMode ? Colors.blue : Colors.grey,
              foregroundColor: Colors.white,
              //Set onPressed event to swap state of bottom bar
              onPressed: editMode
                  ? () async => await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return addArticleDialog();
                          }).then((val) {calculPiece();})
                  : null,
            ),
          ),
          body: Builder(
            builder: (context) => fichetab(),
          ));
    }
  }

  Widget fichetab() {
    return SingleChildScrollView(
        physics: ScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(15, 25, 15, 40),
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          Wrap(
            spacing: 13,
            runSpacing: 13,
            children: [
              Row(
                children: [
                  Flexible(
                    flex: 4,
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          MdiIcons.idCard,
                          color: Colors.orange[900],
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange[900]),
                            borderRadius: BorderRadius.circular(20)),
                        labelText: "N°",
                        labelStyle: TextStyle(color: Colors.orange[900]),
                        enabledBorder: OutlineInputBorder(
                          gapPadding: 3.3,
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.orange[900]),
                        ),
                      ),
                      enabled: editMode,
                      controller: _numeroControl,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(5, 5, 5, 5)),
                  Flexible(
                    flex: 6,
                    child: GestureDetector(
                      onTap: editMode
                          ? () {
                              callDatePicker();
                            }
                          : null,
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.date_range,
                            color: Colors.blue,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(20)),
                          labelText: "Date",
                          labelStyle: TextStyle(color: Colors.blue),
                          enabledBorder: OutlineInputBorder(
                            gapPadding: 3.3,
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                        enabled: false,
                        controller: _dateControl,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    flex: 4,
                    child: ListDropDown(
                      libelle: "Tarif:  ",
                      editMode: editMode,
                      value: _selectedTarification,
                      items: _tarificationDropdownItems,
                      onChanged: (value) {
                        setState(() {
                          _selectedTarification = value;
                        });
                      },),
                  ),
                  Flexible(
                    flex: 6,
                    child: GestureDetector(
                      onTap: editMode
                          ? ()   {
                        chooseClientDialog();
                      }
                          : null,
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.people,
                            color: Colors.blue,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(20)),
                          labelText: "Client",
                          labelStyle: TextStyle(color: Colors.blue),
                          enabledBorder: OutlineInputBorder(
                            gapPadding: 3.3,
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                        enabled: false,
                        controller: _clientControl,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ),

                ],
              ),
            ],
          ),
          SizedBox(height: 15),
          Center(
            child: _selectedItems.length > 0
                ? Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        new ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _selectedItems.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              if(editMode){
                                return new ArticleListItem(
                                  article: _selectedItems[index],
                                  onItemSelected: (selectedItem) => ({
                                    removeItemfromPiece(selectedItem),
                                    calculPiece()
                                  }),
                                );
                              }else{
                                return new ArticleListItem(
                                    article: _selectedItems[index],
                                    fromListing: _islisting,
                                );
                              }

                            })
                      ],
                    ))
                : SizedBox(
                    height: 5,
                  )
          )
        ])
    );
  }

  //afficher le fragment des artciles
  Widget addArticleDialog() {
    return new ArticlesFragment(
      tarification: _selectedTarification,
      onConfirmSelectedItems: (selectedItem) {
        selectedItem.forEach((item) {
          if (_selectedItems.contains(item)) {
            _selectedItems.elementAt(_selectedItems.indexOf(item)).selectedQuantite += item.selectedQuantite;
          } else {
            _selectedItems.add(item);
            if(_desSelectedItems.contains(item)){
              _desSelectedItems.remove(item);
            }
          }
        });
      },
    );
  }

  //afficher le fragement des clients
  chooseClientDialog() {
     showDialog(
        context: context,
        builder: (BuildContext context) {
          return new ClientFourFragment(
            clientFourn: 0,
            onConfirmSelectedItem: (selectedItem) {
              setState(() {
                _selectedClient = selectedItem;
                _piece.tier_id = _selectedClient.id;
                _piece.raisonSociale= _selectedClient.raisonSociale ;
                _clientControl.text = _selectedClient.raisonSociale;
                _selectedTarification = _tarificationItems[_selectedClient.tarification];
              });
            },
          );
        },

    );
     print(_selectedTarification);
  }

  //afficher un dialog pour versseemnt
  Widget addVerssementdialogue() {
      return Dialog(
        //this right here
        child: Wrap(
            children: [Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          "Edit Verssement",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.only(left: 5, right: 5, bottom: 20),
                    child: TextField(
                      controller: _verssementControler,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        errorText: _validateVerssemntError ?? null,
                        prefixIcon: Icon(
                          Icons.monetization_on,
                          color: Colors.green,
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.greenAccent),
                            borderRadius: BorderRadius.circular(20)),
                        contentPadding: EdgeInsets.only(left: 10),
                        labelText: "Total Verssemnet",
                        labelStyle: TextStyle(color: Colors.green),
                        enabledBorder: OutlineInputBorder(
                          gapPadding: 3.3,
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.green),
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
                                onPressed: () async {
                                  double _verssement = double.parse(_verssementControler.text);
                                  double _reste = double.parse(_resteControler.text);
                                  if(_verssement > 0){
                                    _verssement = double.parse(_verssementControler.text) - 1;
                                    _reste = double.parse(_resteControler.text) + 1;
                                  }
                                  _verssementControler.text = _verssement.toString();
                                  _resteControler.text = _reste.toString();
                                },
                                elevation: 2.0,
                                fillColor: Colors.redAccent,
                                child: Icon(
                                  Icons.remove,
                                ),
                                padding: EdgeInsets.all(15.0),
                                shape: CircleBorder(),
                              ),
                              RawMaterialButton(
                                onPressed: () async {
                                  double _verssement = double.parse(_verssementControler.text);
                                  double _reste = double.parse(_resteControler.text);
                                  if(_verssement < _piece.total_ttc){
                                    _verssement = double.parse(_verssementControler.text) + 1;
                                    _reste = double.parse(_resteControler.text) - 1;
                                  }
                                  _verssementControler.text = _verssement.toString();
                                  _resteControler.text = _reste.toString();
                                },
                                elevation: 2.0,
                                fillColor: Colors.greenAccent,
                                child: Icon(
                                  Icons.add,
                                ),
                                padding: EdgeInsets.all(15.0),
                                shape: CircleBorder(),
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: EdgeInsets.only(left: 5, right: 5, bottom: 20),
                            child: TextField(
                              controller: _resteControler,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.money,
                                  color: Colors.orange[900],
                                ),
                               disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.orange[900]),
                                    borderRadius: BorderRadius.circular(20)),
                                contentPadding: EdgeInsets.only(left: 10),
                                labelText: "Reste",
                                labelStyle: TextStyle(color: Colors.orange[900]),
                                enabled: false ,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RaisedButton(
                                onPressed: () async {
                                  _verssementControler.text = _piece.regler.toString();
                                  _resteControler.text = _piece.reste.toString();
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Annuler",
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: Colors.redAccent,
                              ),
                              SizedBox(width: 10),
                              RaisedButton(
                                onPressed: () {
                                   Navigator.pop(context);
                                   setState(() {
                                     _restepiece=double.parse(_resteControler.text);
                                     _verssementpiece=double.parse(_verssementControler.text);
                                   });
                                },
                                child: Text(
                                  "Confirmé",
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: Colors.green,
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
  }

  //remove item from piece in update mode
  void removeItemfromPiece(selectedItem){
    if (selectedItem != null){
      if (_selectedItems.contains(selectedItem)){
        _selectedItems.remove(selectedItem);
        _desSelectedItems.add(selectedItem);
      }
    }
  }

  //calcule le montant total
  void calculPiece() {
    double sum = 0;
    double totalTva = 0;
     setState(() {
      _selectedItems.forEach((item) {
        sum += item.selectedQuantite * item.selectedPrice;
        totalTva += item.selectedQuantite * item.tva ;
      });
      _piece.total_ht =sum ;
      _piece.total_tva = totalTva ;
      _piece.total_ttc = _piece.total_ht + _piece.total_tva ;
      _verssementControler.text = _piece.total_ttc.toString() ;
      _piece.regler = _piece.total_ttc ;
      _piece.reste = _piece.total_ttc - _piece.regler ;
    });
  }


  //********************************************************************** partie de date ****************************************************************************************
  void callDatePicker() async {
    DateTime now = new DateTime.now();

    DateTime order = await getDate(_piece.date ?? now);
    if (order != null) {
      DateTime time = new DateTime(
          order.year, order.month, order.day, now.hour, now.minute);
      setState(() {
        _piece.date = time;
        _dateControl.text = Helpers.dateToText(time);
      });
    }
  }

  Future<DateTime> getDate(DateTime dateTime) {
    // Imagine that this function is
    // more complex and slow.
    return showDatePicker(
      context: context,
      initialDate: dateTime,
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

  //*************************************************************************** partie de save ***********************************************************************************

  //dialog de save
  Widget addChoicesDialog() {
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Builder(
          builder: (context) => Dialog(
            //this right here
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Wrap(spacing: 13, runSpacing: 13,
                    children: [
                      Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Text(
                              "Choose Action : ",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )),
                      SizedBox(
                        width: 320.0,
                        child: Padding(
                          padding: EdgeInsets.only(right: 0, left: 0),
                          child: RaisedButton(
                            onPressed: () async {
                              int mov = getMovForPiece();
                              await saveItem(mov);
                              printItem(_piece);
                            },
                            child: Text(
                              "Save and print",
                              style: TextStyle(color: Colors.white , fontSize: 16),
                            ),
                            color: Colors.green,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 320.0,
                        child: Padding(
                          padding: EdgeInsets.only(right: 0, left: 0),
                          child: RaisedButton(
                            onPressed: () async {
                              int mov = getMovForPiece();
                              await saveItem(mov);
                            },
                            child: Text(
                              "Save only",
                              style: TextStyle(color: Colors.white  , fontSize: 16),
                            ),
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 320.0,
                        child: Padding(
                          padding: EdgeInsets.only(right: 0, left: 0),
                          child: RaisedButton(
                            onPressed: () async {
                              await saveItemAsDraft();
                            },
                            child: Text(
                              "Save as Draft",
                              style: TextStyle(color: Colors.white  , fontSize: 16),
                            ),
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ]
                ),
              ),
            ),
          ));
    });
  }


  int getMovForPiece() {
    switch(_piece.piece){
      case(PieceType.devis):
        return 0 ;
        break;

      case(PieceType.bonReception):
        return 1 ;
        break;

      case(PieceType.bonLivraison):
        return 1 ;
        break;

      case(PieceType.factureClient):
        return 1 ;
        break;

      case(PieceType.factureFournisseur):
        return 1 ;
        break;

      case(PieceType.commandeClient):
        return 1 ;
        break;
    }
  }

  saveItem(int move) async {
    _piece.mov = move;
    int id = await addItemToDb();
    if (id > -1) {
      setState(() {
        modification = true;
        editMode = false;
      });
    }
  }

  saveItemAsDraft() async {
    saveItem(2);
  }

  void printItem(item) {}

  Future<int> addItemToDb() async {
    int id = -1;
    String message;
    try {
      if (widget.arguments.id != null) {
        var item = await makePiece();
        id = await _queryCtr.updateItemInDb(DbTablesNames.pieces, item);
        _selectedItems.forEach((article) async {
          Journaux journaux = Journaux.fromPiece(item, article);
          await _queryCtr.updateJournaux(DbTablesNames.journaux, journaux);
        });
        _desSelectedItems.forEach((article) async {
          Journaux journaux = Journaux.fromPiece(item, article);
          journaux.mov=-2 ;
          await _queryCtr.updateJournaux(DbTablesNames.journaux, journaux);
        });

        if (id > -1) {
          widget.arguments = item;
          widget.arguments.id = id;
          message = "Piece has been updated successfully";
        } else {
          message = "Error when updating Piece in db";
        }
      } else {
        Piece piece = await makePiece();
        id = await _queryCtr.addItemToTable(DbTablesNames.pieces, piece);
        var res = await _queryCtr.getPieceByNum(piece.num_piece , piece.piece);
        piece.id= res[0].id ;
        _selectedItems.forEach((article) async {
          Journaux journaux = Journaux.fromPiece(piece, article);
          await _queryCtr.addItemToTable(DbTablesNames.journaux, journaux);
        });
        if (id > -1) {
          widget.arguments = piece;
          widget.arguments.id = id;
          message = "Piece has been added successfully";
        } else {
          message = "Error when adding Piece to db";
        }
      }
      Navigator.pop(context);
      Helpers.showFlushBar(context, message);
      return Future.value(id);
    } catch (error) {
      Helpers.showFlushBar(context, "Error: something went wrong");
      return Future.value(-1);
    }
  }

  Future<Object> makePiece() async {
    var tiers = _selectedClient ;
    _piece.num_piece=_numeroControl.text ;
    _piece.tier_id= tiers.id ;
    _piece.raisonSociale = tiers.raisonSociale ;
    _piece.tarification = _selectedTarification ;
    _piece.transformer = 0 ;
    _piece.regler=_verssementpiece ;
    _piece.reste=_restepiece;

    var res = await _queryCtr.getPieceByNum(_piece.num_piece , _piece.piece);
    if(res.length >= 1 && !modification){
      var message = "Num Piece is alearydy exist";
      Helpers.showFlushBar(context, message);
      await getNumPiece(_piece);
      _piece.num_piece = _numeroControl.text ;
    }

    return _piece ;
  }








}
