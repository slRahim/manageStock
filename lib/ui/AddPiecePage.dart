import 'dart:io';
import 'dart:typed_data';

import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';
import 'package:flutter/material.dart';
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
import 'package:gestmob/models/Piece.dart';
import 'package:gestmob/models/Tiers.dart';
import 'package:gestmob/models/TiersFamille.dart';
import 'package:gestmob/search/items_sliver_list.dart';
import 'package:gestmob/search/sliver_list_data_source.dart';
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

class _AddPiecePageState extends State<AddPiecePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Piece _piece = new Piece.init();

  bool editMode = true;
  bool modification = false;

  bool finishedLoading = false;

  String appBarTitle = "Devis";

  List<Article> _selectedItems = new List<Article>();

  List<DropdownMenuItem<Tiers>> _clientsDropdownItems;
  Tiers _selectedClients;
  List<Object> _clientsItems;

  bool _validateRaison = false;

  TextEditingController _numeroControl = new TextEditingController();
  TextEditingController _dateControl = new TextEditingController();
  TextEditingController _clientControl = new TextEditingController();

  SliverListDataSource _dataSource;
  QueryCtr _queryCtr;

  BottomBarController bottomBarControler;

  void initState() {
    super.initState();
    bottomBarControler =
        BottomBarController(vsync: this, dragLength: 450, snap: true);

    _dataSource = SliverListDataSource(
        ItemsListTypes.articlesList, new Map<String, dynamic>());
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
    _clientsItems = await _queryCtr.getAllTiers();
    _clientsDropdownItems = utils.buildDropClients(_clientsItems);
    _selectedClients = _clientsItems[0];

    if (widget.arguments.id != null && widget.arguments.id > -1) {
      editMode = false;
      modification = true;
      await setDataFromItem(widget.arguments);
    } else {
      await setDataFromItem(await _queryCtr.getTestPiece());
      editMode = true;
    }

    return Future<bool>.value(editMode);
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
              if (modification)
                {
                  if (editMode)
                    {
                      Navigator.of(context).pushReplacementNamed(
                          RoutesKeys.addTier,
                          arguments: widget.arguments)
                    }
                  else
                    {Navigator.pop(context)}
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
                      "Net a payer = " + _piece.net_a_payer.toString(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 30),
                    child: Text(
                      "Print",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: GestureDetector(
            // Set onVerticalDrag event to drag handlers of controller for swipe effect
            onVerticalDragUpdate: bottomBarControler.onDrag,
            onVerticalDragEnd: bottomBarControler.onDragEnd,
            child: FloatingActionButton.extended(
              label: Text("+ Add"),
              elevation: 2,
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,

              //Set onPressed event to swap state of bottom bar
              onPressed: () async => await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return addArticleDialog();
                  }).then((val) {
                calculPiece(setState);
              }),
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
                    flex: 6,
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
                      enabled: false,
                      controller: _numeroControl,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(5, 5, 5, 5)),
                  Flexible(
                    flex: 8,
                    child: GestureDetector(
                      onTap: () {callDatePicker();},
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
              ListDropDown(
                leftIcon: Icons.people,
                editMode: editMode,
                value: _selectedClients,
                items: _clientsDropdownItems,
                onChanged: (value) {
                  setState(() {
                    _selectedClients = value;
                  });
                },
                onAddPressed: null,
              ),

            ],
          ),
          SizedBox(height: 15),
          Center(
            child: _selectedItems.length > 0
                ? Container(
                    padding: EdgeInsets.all(10),
                    decoration: new BoxDecoration(
                      border: Border.all(
                        color: Colors.blueAccent,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Articles List",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 15),
                        new ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _selectedItems.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return new ArticleListItem(
                                article: _selectedItems[index],
                                onItemSelected: (selectedItem) => ({
                                    if(selectedItem != null){
                                      if (_selectedItems.contains(selectedItem)) {
                                        _selectedItems.remove(selectedItem)
                                      }
                                    },
                                  calculPiece(setState)
                                }),
                              );
                            })
                      ],
                    ))
                : SizedBox(
                    height: 5,
                  ),
          )
        ]));
  }

  Widget addArticleDialog() {
    return new ArticlesFragment(
      onConfirmSelectedItems: (selectedItem) {
        selectedItem.forEach((item) {
          if (_selectedItems.contains(item)) {
            _selectedItems[_selectedItems.indexOf(item)].selectedQuantite +=
                item.selectedQuantite;
          } else {
            _selectedItems.add(item);
          }
        });
      },
    );
  }

  Future<Object> makeItem() async {
    /*var item = new Tiers.empty();
    item.id = widget.arguments.id;

    if(_clientFournBool){
      item.clientFour = 1;
    } else if (widget.arguments.originClientOrFourn != null){
      item.clientFour = widget.arguments.originClientOrFourn;
    } else{
      item.clientFour = _clientFourn;
    }
    item.raisonSociale = _raisonSocialeControl.text;
    item.qrCode = _qrCodeControl.text;

    item.adresse = _adresseControl.text;

    item.latitude = _latitude;
    item.longitude = _longitude;
    item.ville = _villeControl.text;
    item.telephone = _telephoneControl.text;
    item.mobile = _mobileControl.text;
    item.fax = _faxControl.text;
    item.email = _emailControl.text;
    item.solde_depart = double.tryParse(_solde_departControl.text);
    item.chiffre_affaires = double.tryParse(_chiffre_affairesControl.text);
    item.regler = double.tryParse(_reglerControl.text);

    item.id_famille = _selectedFamille.id;
    item.statut = _statutItems.indexOf(_selectedStatut);
    item.tarification = _tarificationItems.indexOf(_selectedTarification);

    item.bloquer = false;

    if (_itemImage != null) {
      item.imageUint8List = Helpers.getUint8ListFromFile(_itemImage);
    } else {
      Uint8List image = await Helpers.getDefaultImageUint8List();
      item.imageUint8List = image;
    }
    return item;*/

    return await _queryCtr.getTestPiece();
  }

  Future<void> setDataFromItem(item) async {
    _piece = item;
    _numeroControl.text = item.num_piece;
    _dateControl.text = Helpers.dateToText(item.date)?? Helpers.dateToText(new DateTime.now());

    _selectedClients = _clientsItems[0];
  }

  Future<int> addItemToDb() async {
    int id = -1;
    String message;
    try {
      if (widget.arguments.id != null) {
        var item = await makeItem();
        id = await _queryCtr.updateItemInDb(DbTablesNames.pieces, item);
        if (id > -1) {
          widget.arguments = item;
          widget.arguments.id = id;
          message = "Tier has been updated successfully";
        } else {
          message = "Error when updating Tier in db";
        }
      } else {
        var item = await makeItem();
        id = await _queryCtr.addItemToTable(DbTablesNames.pieces, item);
        if (id > -1) {
          widget.arguments = item;
          widget.arguments.id = id;
          message = "Tier has been added successfully";
        } else {
          message = "Error when adding Tier to db";
        }
      }
      Helpers.showFlushBar(context, message);
      return Future.value(id);
    } catch (error) {
      Helpers.showFlushBar(context, "Error: something went wrong");
      return Future.value(-1);
    }
  }

  void calculPiece(setState) {
    setState(() {
      _piece = Piece.fromArticlesList(_selectedItems);
    });
  }

  void callDatePicker() async {
    DateTime now = new DateTime.now();

    DateTime order = await getDate(_piece.date?? now);
    if(order != null){
      DateTime time = new DateTime(order.year, order.month, order.day, now.hour, now.minute);
      _piece.date = time;
      setState(() {
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

  Future<Widget> saveItem() async {
    int id = await addItemToDb();
    if (id > -1) {
      setState(() {
        modification = true;
        editMode = false;
      });
    }
  }

  Future<Widget> saveItemToTrash() async {
    _piece.mov = -1;
    saveItem();
  }

  void printItem(item){

  }


  Widget addChoicesDialog() {
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Builder(
          builder: (context) => Dialog(
            //this right here
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Wrap(
                    spacing: 13,
                    runSpacing: 13,
                    children: [
                  Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          "Choose action",
                          style: TextStyle(
                            fontSize: 18,
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
                          await saveItem();
                          printItem(_piece);
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Save and print",
                          style: TextStyle(color: Colors.white),
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
                          await saveItem();
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Save only",
                          style: TextStyle(color: Colors.white),
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
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.red,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ));
    });
  }
}
