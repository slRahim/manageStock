
// import 'dart:html';
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
import 'package:gestmob/Widgets/article_list_item.dart';
import 'package:gestmob/Widgets/total_devis.dart';
import 'package:gestmob/models/Article.dart';
import 'package:gestmob/models/FormatPiece.dart';
import 'package:gestmob/models/Piece.dart';
import 'package:gestmob/models/Tiers.dart';
import 'package:gestmob/models/Tresorie.dart';
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

  Piece _selectedPiece;

  Tiers _selectedClient ;

  bool _validateRaison = false;

  TextEditingController _numeroControl = new TextEditingController();
  TextEditingController _dateControl = new TextEditingController();
  TextEditingController _clientControl = new TextEditingController();
  TextEditingController _verssementControler = new TextEditingController();
  TextEditingController _resteControler = new TextEditingController();
  String _validateVerssemntError;
  double _restepiece ;
  double _verssementpiece ;

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
    if (widget.arguments is Tresorie && widget.arguments.id != null && widget.arguments.id > -1) {
      editMode = false;
      modification = true;
      await setDataFromItem(widget.arguments);
    } else {
      await getNumPiece(widget.arguments);
      _tresorie.date = DateTime.now() ;
      _dateControl.text = Helpers.dateToText(DateTime.now());
      editMode = true;
    }
    return Future<bool>.value(editMode);
  }

  Future<void> setDataFromItem( item) async {
    // if(item != null){
    //   _piece = item;
    //   _numeroControl.text = _piece.num_piece;
    //   DateTime time = _piece.date ?? new DateTime.now();
    //   _piece.date = time;
    //   _dateControl.text = Helpers.dateToText(time);
    //   _selectedClient = await _queryCtr.getTierById(_piece.tier_id);
    //   _clientControl.text = _selectedClient.raisonSociale;
    //   _selectedTarification =  _tarificationItems[_selectedClient.tarification];
    //   _selectedItems= await _queryCtr.getJournalPiece(item);
    //   _verssementControler.text = _piece.regler.toString();
    //   _resteControler.text = _piece.reste.toString();
    //   _restepiece=_piece.reste ;
    //   _verssementpiece=_piece.regler;
    // }else{
    //   _piece.piece = widget.arguments.piece ;
    //   _selectedClient = await _queryCtr.getTierById(1);
    //   _clientControl.text = _selectedClient.raisonSociale;
    //   _selectedTarification = _tarificationItems[_selectedClient.tarification];
    //   _verssementControler.text = "0.0";
    //   _resteControler.text ="0.0";
    //   _restepiece = 0 ;
    //   _verssementpiece = 0 ;
    // }

  }

  Future<void> getNumPiece(item) async{
    _tresorie.numTresorie = item.numTresorie ;
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
              // if (_raisonSocialeControl.text.isNotEmpty) {
              //   int id = await addItemToDb();
              //   if (id > -1) {
              //     setState(() {
              //       modification = true;
              //       editMode = false;
              //     });
              //   }
              // } else {
              //   Helpers.showFlushBar(
              //       context, "Please enter Raison sociale");
              //
              //   setState(() {
              //     _validateRaison = true;
              //   });
              // }
            },
          ),
          // extendBody: true,
          bottomNavigationBar: BottomExpandableAppBar(
            controller: bottomBarControler,
            horizontalMargin: 15,
            shape: AutomaticNotchedShape(
                RoundedRectangleBorder(), StadiumBorder(side: BorderSide())),
            expandedBackColor: Colors.lightBlueAccent,
            // expandedBody: TotalDevis(piece: _piece),
            bottomAppBarBody: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'TTC : '+
                          _tresorie.montant.toString()+" DA",
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
              backgroundColor: editMode ? Colors.blue : Colors.grey,
              foregroundColor: Colors.white,
              //Set onPressed event to swap state of bottom bar
              onPressed: editMode
                  ? () async => await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return choosePieceDialog();
                  }).then((val) {calculPiece();})
                  : null,
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
                    child :TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.money_outlined,
                          color: Colors.blue,
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(20)),
                        labelText: "Credit",
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
          // PieceListItem(
          //   piece: _selectedPiece,
          // ),
        ])
    );
  }

  //afficher le fragement des clients
  chooseClientDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new ClientFourFragment(
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new PiecesFragment(
          // tierId: _selectedClient.id,
          // onConfirmSelectedItem: (selectedItem) {
          //   setState(() {
          //     _selectedPiece= selectedItem;
          //   });
          // },
        );
      },

    );
  }


  //calcule le montant total
  void calculPiece() {
    // double sum = 0;
    // double totalTva = 0;
    // setState(() {
    //   _selectedItems.forEach((item) {
    //     sum += item.selectedQuantite * item.selectedPrice;
    //     totalTva += item.selectedQuantite * item.tva ;
    //   });
    //   _piece.total_ht =sum ;
    //   _piece.total_tva = totalTva ;
    //   _piece.total_ttc = _piece.total_ht + _piece.total_tva ;
    //   _verssementControler.text = _piece.total_ttc.toString() ;
    //   _piece.regler = _piece.total_ttc ;
    //   _piece.reste = _piece.total_ttc - _piece.regler ;
    // });
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

  //*************************************************************************** partie de save ***********************************************************************************

  Future<int> addItemToDb() async {
    // int id = -1;
    // String message;
    // try {
    //   if (widget.arguments.id != null) {
    //     var item = await makePiece();
    //     id = await _queryCtr.updateItemInDb(DbTablesNames.pieces, item);
    //     _selectedItems.forEach((article) async {
    //       Journaux journaux = Journaux.fromPiece(item, article);
    //       await _queryCtr.updateJournaux(DbTablesNames.journaux, journaux);
    //     });
    //     _desSelectedItems.forEach((article) async {
    //       Journaux journaux = Journaux.fromPiece(item, article);
    //       journaux.mov=-2 ;
    //       await _queryCtr.updateJournaux(DbTablesNames.journaux, journaux);
    //     });
    //
    //     if (id > -1) {
    //       widget.arguments = item;
    //       widget.arguments.id = id;
    //       message = "Piece has been updated successfully";
    //     } else {
    //       message = "Error when updating Piece in db";
    //     }
    //   } else {
    //     Piece piece = await makePiece();
    //     id = await _queryCtr.addItemToTable(DbTablesNames.pieces, piece);
    //     var res = await _queryCtr.getPieceByNum(piece.num_piece , piece.piece);
    //     piece.id= res[0].id ;
    //     _selectedItems.forEach((article) async {
    //       Journaux journaux = Journaux.fromPiece(piece, article);
    //       await _queryCtr.addItemToTable(DbTablesNames.journaux, journaux);
    //     });
    //     if (id > -1) {
    //       widget.arguments = piece;
    //       widget.arguments.id = id;
    //       message = "Piece has been added successfully";
    //     } else {
    //       message = "Error when adding Piece to db";
    //     }
    //   }
    //   Navigator.pop(context);
    //   Helpers.showFlushBar(context, message);
    //   return Future.value(id);
    // } catch (error) {
    //   Helpers.showFlushBar(context, "Error: something went wrong");
    //   return Future.value(-1);
    // }
  }

  Future<Object> makePiece() async {
    // var tiers = _selectedClient ;
    // _piece.num_piece=_numeroControl.text ;
    // _piece.tier_id= tiers.id ;
    // _piece.raisonSociale = tiers.raisonSociale ;
    // _piece.tarification = _selectedTarification ;
    // _piece.transformer = 0 ;
    // _piece.regler=_verssementpiece ;
    // _piece.reste=_restepiece;
    //
    // var res = await _queryCtr.getPieceByNum(_piece.num_piece , _piece.piece);
    // if(res.length >= 1 && !modification){
    //   var message = "Num Piece is alearydy exist";
    //   Helpers.showFlushBar(context, message);
    //   await getNumPiece(_piece);
    //   _piece.num_piece = _numeroControl.text ;
    // }
    //
    // return _piece ;
  }








}
