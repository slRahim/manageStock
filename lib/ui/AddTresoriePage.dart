
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/Widgets/CustomWidgets/add_save_bar.dart';
import 'package:gestmob/Widgets/CustomWidgets/bottom_tab_bar.dart';
import 'package:gestmob/Widgets/CustomWidgets/list_dropdown.dart';
import 'package:gestmob/Widgets/CustomWidgets/list_tile_card.dart';
import 'package:gestmob/Widgets/article_list_item.dart';
import 'package:gestmob/Widgets/piece_list_item.dart';
import 'package:gestmob/Widgets/total_devis.dart';
import 'package:gestmob/models/Article.dart';
import 'package:gestmob/models/FormatPiece.dart';
import 'package:gestmob/models/Piece.dart';
import 'package:gestmob/models/Tiers.dart';
import 'package:gestmob/models/Tresorie.dart';
import 'package:gestmob/models/TresorieCategories.dart';
import 'package:gestmob/search/items_sliver_list.dart';
import 'package:gestmob/search/sliver_list_data_source.dart';
import 'package:gestmob/ui/ClientFourFragment.dart';
import 'package:gestmob/ui/PiecesFragment.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gestmob/Widgets/utils.dart' as utils;
import 'package:map_launcher/map_launcher.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'ArticlesFragment.dart';

class AddTresoriePage extends StatefulWidget {
  var arguments;
  AddTresoriePage({Key key, @required this.arguments}) : super(key: key);

  @override
  _AddTresoriePageState createState() => _AddTresoriePageState();
}

class _AddTresoriePageState extends State<AddTresoriePage> with TickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Tresorie _tresorie = new Tresorie.init();

  bool editMode = true;
  bool modification = false;

  bool finishedLoading = false;

  String appBarTitle = "Tresorie";

  List <Piece> _selectedPieces ;

  Tiers _selectedClient ;

  bool _validateRaison = false;

  TextEditingController _numeroControl = new TextEditingController();
  TextEditingController _dateControl = new TextEditingController();
  TextEditingController _clientControl = new TextEditingController();
  TextEditingController _objetControl = new TextEditingController();
  TextEditingController _modaliteControl = new TextEditingController();
  TextEditingController _montantControl = new TextEditingController();

  double _restepiece = 0.0 ;
  double _verssementpiece ;


  List<DropdownMenuItem<String>> _tiersDropdownItems;
  String _selectedTypeTiers;

  List<TresorieCategories> _categorieItems;
  List<DropdownMenuItem<TresorieCategories>> _categorieDropdownItems;
  TresorieCategories _selectedCategorie;

  QueryCtr _queryCtr = new QueryCtr();

  BottomBarController bottomBarControler;

  void initState() {
    super.initState();
    bottomBarControler = BottomBarController(vsync: this, dragLength: 450, snap: true);
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
    _tiersDropdownItems = utils.buildDropTypeTier(Statics.tiersItems);
    _selectedTypeTiers = Statics.tiersItems[0];

    _categorieItems = await _queryCtr.getAllTresorieCategorie();
    _categorieDropdownItems = utils.buildDropTresorieCategoriesDownMenuItems(_categorieItems);
    _selectedCategorie= _categorieItems[0];

    if (widget.arguments is Tresorie && widget.arguments.id != null && widget.arguments.id > -1) {
      editMode = false;
      modification = true;
      await setDataFromItem(widget.arguments);
    } else {
      await setDataFromItem(null);
      await getNumPiece();
      _tresorie.date = DateTime.now() ;
      _dateControl.text = Helpers.dateToText(DateTime.now());
      _selectedPieces = new List<Piece>();
      editMode = true;
    }
    return Future<bool>.value(editMode);
  }

  Future<void> setDataFromItem( item) async {
    if(item != null){
      _tresorie = item;
      _numeroControl.text = _tresorie.numTresorie;
      DateTime time = _tresorie.date ?? new DateTime.now();
      _tresorie.date = time;
      _dateControl.text = Helpers.dateToText(time);
      if(_tresorie.tierId != null){
        _selectedClient = await _queryCtr.getTierById(_tresorie.tierId);
        _clientControl.text = _selectedClient.raisonSociale;
        _selectedTypeTiers =  Statics.tiersItems[_selectedClient.clientFour];
      }
      if(_tresorie.pieceId != null){
        var res = await _queryCtr.getPieceById(_tresorie.pieceId);
        _selectedPieces.add(res);
        _restepiece=_selectedPieces.first.reste;
        _verssementpiece=_selectedPieces.first.regler;
      }else{
        _selectedPieces = new List<Piece> ();
      }
      _selectedCategorie = _categorieItems[item.categorie];
      _objetControl.text = _tresorie.objet;
      _modaliteControl.text= _tresorie.modalite ;
      _montantControl.text = _tresorie.montant.toString() ;


    }else{
      _selectedTypeTiers =  Statics.tiersItems[0];
    }

  }

  Future<void> getNumPiece() async{
    List<FormatPiece> list = await _queryCtr.getFormatPiece(PieceType.tresorie);
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
        appBarTitle = "Verssement";
      }
    } else {
      if (editMode) {
        appBarTitle = "Ajouter Verssement";
      } else {
        appBarTitle = "Verssement";
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
              if(modification){
                if(editMode){
                  Navigator.of(context).pushReplacementNamed(RoutesKeys.addTresorie, arguments: widget.arguments)
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
              if ( (_selectedCategorie.id == 2 ||_selectedCategorie.id == 3 ||
                  _selectedCategorie.id == 6 || _selectedCategorie.id == 7)  ) {
                if(_selectedClient !=null ){
                  int id = await addItemToDb();
                  if (id > -1) {
                    setState(() {
                      modification = true;
                      editMode = false;
                    });
                  }
                }else{
                  Helpers.showFlushBar(
                      context, "Please select Tiers");

                  setState(() {
                    _validateRaison = true;
                  });
                }
              } else {
                int id = await addItemToDb();
                if (id > -1) {
                  setState(() {
                    modification = true;
                    editMode = false;
                  });
                }
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
            expandedBody: Container(),
            bottomAppBarBody: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: (_selectedClient !=null)? Text(
                      'Cred : '+_selectedClient.credit.toString()+" DA",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),
                    ):
                    Text(
                      'Cred : 0.0 DA',
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
                        child:Text("Reste : "+_restepiece.toString(), textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold
                          ),
                        )
                   ),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton:FloatingActionButton.extended(
              label: Text("+ Add"),
              elevation: 2,
              backgroundColor: (editMode && !modification) ? Colors.blue : Colors.grey,
              foregroundColor: Colors.white,
              onPressed: () async {
                  if(editMode && !modification){
                    if(_selectedClient !=null){
                      await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return choosePieceDialog();
                          });
                    }else{
                      var message = "Please select tiers";
                       Helpers.showFlushBar(context, message);
                    }
                  }
              },
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
                      enabled: editMode && !modification,
                      controller: _numeroControl,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(5, 5, 5, 5)),
                  Flexible(
                    flex: 6,
                    child: GestureDetector(
                      onTap: editMode && !modification
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
                    child :ListDropDown(
                      editMode: editMode && !modification,
                      value: _selectedTypeTiers,
                      items: _tiersDropdownItems,
                      onChanged: (value) {
                        setState(() {
                          _selectedTypeTiers = value;

                        });
                      },),
                  ),
                  Flexible(
                    flex: 6,
                    child: GestureDetector(
                      onTap: editMode && !modification
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
                          labelText: "Select Tiers",
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
              child: _selectedPieces.isNotEmpty
                  ? Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      new ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _selectedPieces.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            if(editMode && !modification){
                              return new PieceListItem(
                                piece: _selectedPieces[index],
                                onItemSelected: (selectedItem){
                                  if(_selectedPieces.contains(selectedItem)){
                                    setState(() {
                                      _selectedPieces.remove(selectedItem);
                                    });
                                  }
                                }
                              );
                            }else{
                              return new PieceListItem(
                                  piece: _selectedPieces[index],
                              );
                            }
                            })
                    ],
                  ))
                  :Container(
                    margin: EdgeInsets.symmetric(vertical: 20 , horizontal: 20),
                    padding: EdgeInsets.symmetric(vertical: 10 , horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.green[200],
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: ListTile(
                        title: Text(
                           "Appliquer sur le credit totals",
                           style: TextStyle(
                             fontSize: 16 ,
                           ),
                        ),
                      leading: Container(
                        child: Center(child: Text("TR"),),
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            width: 3,
                            color: Colors.blue,
                          ),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
            child: Wrap(
              spacing: 13,
              runSpacing: 13,
              children: [
                Visibility(
                  visible: editMode && !modification ,
                  child: ListDropDown(
                    editMode: editMode ,
                    value: _selectedCategorie,
                    items: _categorieDropdownItems,
                    onChanged: (value) {
                      setState(() {
                        _selectedCategorie = value;
                      });
                    },
                    onAddPressed: () async {
                      await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return addTresoreCategorie();
                          }).then((val) {
                        setState(() {});
                      });
                    },
                  ),
                ),
                TextField(
                  enabled: editMode,
                  controller: _objetControl,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.subject,
                      color: Colors.blue[700],
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue[700]),
                        borderRadius: BorderRadius.circular(20)),
                    labelText: "Objet",
                    enabledBorder: OutlineInputBorder(
                      gapPadding: 3.3,
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.blue[700]),
                    ),
                  ),
                ),
                TextField(
                  enabled: editMode,
                  controller: _modaliteControl,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.merge_type,
                      color: Colors.blue[700],
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue[700]),
                        borderRadius: BorderRadius.circular(20)),
                    labelText: "Modalite",
                    enabledBorder: OutlineInputBorder(
                      gapPadding: 3.3,
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.blue[700]),
                    ),
                  ),
                ),
                TextField(
                  enabled: editMode,
                  controller: _montantControl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.monetization_on,
                      color: Colors.blue[700],
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue[700]),
                        borderRadius: BorderRadius.circular(20)),
                    labelText: "Montant",
                    enabledBorder: OutlineInputBorder(
                      gapPadding: 3.3,
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.blue[700]),
                    ),
                  ),
                ),
              ],
            ),
          )
        ])
    );
  }

  //afficher le fragement des clients
  chooseClientDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new ClientFourFragment(
          clientFourn: Statics.tiersItems.indexOf(_selectedTypeTiers),
          onConfirmSelectedItem: (selectedItem) {
            setState(() {
              _selectedClient = selectedItem;
              _tresorie.tierId = _selectedClient.id;
              _tresorie.tierRS= _selectedClient.raisonSociale ;
              _clientControl.text = _selectedClient.raisonSociale;
            });
          },
        );
      },

    );
  }

  //afficher le fragement des clients
  choosePieceDialog() {
    return PiecesFragment(
      tierId: _selectedClient.id,
      onConfirmSelectedItem: (selectedItem) {
        setState(() {
          _selectedPieces.add(selectedItem);
          _restepiece=_selectedPieces.first.reste;
        });
      },
    );

  }



  //********************************************************************** partie de date ****************************************************************************************
  void callDatePicker() async {
    DateTime now = new DateTime.now();

    DateTime order = await getDate(_tresorie.date ?? now);
    if (order != null) {
      DateTime time = new DateTime(
          order.year, order.month, order.day, now.hour, now.minute);
      setState(() {
        _tresorie.date = time;
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

  //************************************************************************partie de l'ajout d'une nouvelle categorie************************************************************

  Widget addTresoreCategorie() {

  }

  Future<void> addTresoreCategorieIfNotExist()async{

  }

  //*************************************************************************** partie de save ***********************************************************************************

  Future<int> addItemToDb() async {
    int id = -1;
    String message;
    try {
      if (widget.arguments.id != null) {
        Tresorie tresorie = await makeItem();
        id = await _queryCtr.updateItemInDb(DbTablesNames.tresorie, tresorie);
        if(_selectedCategorie.id == 2 || _selectedCategorie.id == 3){
          if(_selectedPieces.isEmpty){
            _selectedPieces = await _queryCtr.getAllPiecesByTierId(_selectedClient.id);
          }
          double _montant = tresorie.montant ;
          _selectedPieces.forEach((piece) async{
            if(_montant >= piece.reste){
              piece.regler = piece.regler + piece.reste;
              _montant = _montant - piece.reste ;
              piece.reste = piece.total_ttc - piece.regler ;
            }else if(_montant != 0){
              piece.regler = piece.regler + _montant;
              piece.reste = piece.total_ttc - piece.regler ;
            }else{
              return ;
            }
            await _queryCtr.updateItemInDb(DbTablesNames.pieces, piece);
          });
          if(_selectedPieces.length > 1){
            setState(() {
              _selectedPieces= new List<Piece> ();
            });
          }
        }
        if (id > -1) {
          widget.arguments = tresorie;
          widget.arguments.id = id;
          message = "Tresorie has been updated successfully";
        } else {
          message = "Error when updating Tresorie in db";
        }
      } else {
        Tresorie tresorie = await makeItem();
        id = await _queryCtr.addItemToTable(DbTablesNames.tresorie, tresorie);
        if(_selectedCategorie.id == 2 || _selectedCategorie.id == 3){
          if(_selectedPieces.isEmpty){
            _selectedPieces = await _queryCtr.getAllPiecesByTierId(_selectedClient.id);
          }
          double _montant = tresorie.montant ;
          _selectedPieces.forEach((piece) async{
            if(_montant >= piece.reste){
              piece.regler = piece.regler + piece.reste;
              _montant = _montant - piece.reste ;
              piece.reste = piece.total_ttc - piece.regler ;
            }else if(_montant != 0){
              piece.regler = piece.regler + _montant;
              piece.reste = piece.total_ttc - piece.regler ;
            }else{
              return ;
            }
            await _queryCtr.updateItemInDb(DbTablesNames.pieces, piece);
          });
          if(_selectedPieces.length > 1){
            setState(() {
              _selectedPieces= new List<Piece> ();
            });
          }
        }
        if (id > -1) {
          widget.arguments = tresorie;
          widget.arguments.id = id;
          setState(() {
            modification = true;
            editMode = false;
          });
          message = "Tresorie has been added successfully";
        } else {
          message = "Error when adding Tresorie to db";
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

  Future<Object> makeItem() async {
    var tiers = _selectedClient ;
    if(tiers != null){
      print(tiers.id);
      _tresorie.tierId= tiers.id ;
      _tresorie.tierRS = tiers.raisonSociale ;
    }
    _tresorie.numTresorie=_numeroControl.text ;
    _tresorie.categorie = _selectedCategorie.id ;
    _tresorie.objet = _objetControl.text;
    _tresorie.modalite=_modaliteControl.text;
    _tresorie.montant= double.parse(_montantControl.text);
    if(_selectedPieces.isNotEmpty){
      _tresorie.pieceId = _selectedPieces.first.id ;
    }

    var res = await _queryCtr.getTresorieByNum(_numeroControl.text);
    if(res.length >= 1 && !modification){
      var message = "Num tresorie is alearydy exist";
      Helpers.showFlushBar(context, message);
      await getNumPiece();
      _tresorie.numTresorie = _numeroControl.text ;
    }

    return _tresorie ;
  }










}
