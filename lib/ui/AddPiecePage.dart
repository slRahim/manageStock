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

  bool finishedLoading = false;

  String appBarTitle = "Devis";

  List<Article> _selectedItems = new List<Article>();
  Tiers _selectedClient;

  List<int> _tarificationItems = Statics.tarificationItems ;
  List<DropdownMenuItem<int>> _tarificationDropdownItems;
  int _selectedTarification;

  bool _validateRaison = false;

  TextEditingController _numeroControl = new TextEditingController();
  TextEditingController _dateControl = new TextEditingController();
  TextEditingController _clientControl = new TextEditingController();
  TextEditingController _verssementControl = new TextEditingController();

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

  Future<void> setDataFromItem(item) async {
    if(item != null){
      _piece = item;
      _numeroControl.text = _piece.num_piece;
      DateTime time = _piece.date ?? new DateTime.now();
      _piece.date = time;
      _dateControl.text = Helpers.dateToText(time);
      _selectedClient = await _queryCtr.getTierById(_piece.tier_id);
      _clientControl.text = _selectedClient.raisonSociale;
      _selectedTarification = _selectedClient.tarification;
    }else{
      _selectedClient = await _queryCtr.getTierById(1);
      _clientControl.text = _selectedClient.raisonSociale;
      _selectedTarification = _selectedClient.tarification;
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
      } else {
        appBarTitle = "Devis";
      }
    } else {
      if (editMode) {
        appBarTitle = "Ajouter un devis";
      } else {
        appBarTitle = "Devis";
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
                  Container(
                      padding: EdgeInsets.only(right: 30),
                      child: Text(
                        "Régler",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
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
                              return new ArticleListItem(
                                article: _selectedItems[index],
                                onItemSelected: (selectedItem) => ({
                                  if (selectedItem != null){
                                      if (_selectedItems.contains(selectedItem)){
                                        _selectedItems.remove(selectedItem)
                                      }
                                  },
                                  calculPiece()
                                }),
                              );
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
      _verssementControl.text = _piece.total_ttc.toString() ;
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
                              await saveItem(1);
                              printItem(_piece);
                              Navigator.pop(context);
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
                              await saveItem(1);
                              Navigator.pop(context);
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
                              await saveItemToTrash();
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Save to Trash",
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

  saveItemToTrash() async {
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
          await _queryCtr.updateItemInDb(DbTablesNames.journaux, journaux);
        });

        if (id > -1) {
          widget.arguments = item;
          widget.arguments.id = id;
          message = "Tier has been updated successfully";
        } else {
          message = "Error when updating Tier in db";
        }
      } else {
        var piece = await makePiece();
        id = await _queryCtr.addItemToTable(DbTablesNames.pieces, piece);
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

    var res = await _queryCtr.getPieceByNum(_piece.num_piece);
    if(res == 1){
      var message = "Num Piece is alearydy exist";
      Helpers.showFlushBar(context, message);
      await getNumPiece(_piece);
      _piece.num_piece = _numeroControl.text ;
    }

    return _piece ;
  }





}
