import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';
import 'package:floating_action_row/floating_action_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/Widgets/CustomWidgets/add_save_bar.dart';
import 'package:gestmob/Widgets/CustomWidgets/bottom_tab_bar.dart';
import 'package:gestmob/Widgets/CustomWidgets/image_picker_widget.dart';
import 'package:gestmob/Widgets/CustomWidgets/list_dropdown.dart';
import 'package:gestmob/Widgets/CustomWidgets/selectable_list_item.dart';
import 'package:gestmob/Widgets/article_list_item.dart';
import 'package:gestmob/Widgets/total_devis.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/Article.dart';
import 'package:gestmob/models/FormatPiece.dart';
import 'package:gestmob/models/FormatPrint.dart';
import 'package:gestmob/models/Journaux.dart';
import 'package:gestmob/models/MyParams.dart';
import 'package:gestmob/models/Piece.dart';
import 'package:gestmob/models/ReglementTresorie.dart';
import 'package:gestmob/models/Tiers.dart';
import 'package:gestmob/models/TiersFamille.dart';
import 'package:gestmob/models/Transformer.dart';
import 'package:gestmob/models/Tresorie.dart';
import 'package:gestmob/search/items_sliver_list.dart';
import 'package:gestmob/search/sliver_list_data_source.dart';
import 'package:gestmob/ui/ClientFourFragment.dart';
import 'package:gestmob/ui/JournalFragment.dart';
import 'package:gestmob/ui/preview_piece.dart';
import 'package:gestmob/ui/printer_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gestmob/Widgets/utils.dart' as utils;
import 'package:map_launcher/map_launcher.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
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
  bool _islisting = false;

  bool finishedLoading = false;

  String appBarTitle = S.current.devis;

  List<Article> _selectedItems = new List<Article>();
  List<Article> _desSelectedItems = new List<Article>();
  Tiers _selectedClient;

  List<int> _tarificationItems = Statics.tarificationItems;
  List<DropdownMenuItem<int>> _tarificationDropdownItems;
  int _selectedTarification;

  bool _validateRaison = false;

  TextEditingController _numeroControl = new TextEditingController();
  TextEditingController _dateControl = new TextEditingController();
  TextEditingController _clientControl = new TextEditingController();
  TextEditingController _verssementControler = new TextEditingController();
  TextEditingController _resteControler = new TextEditingController();
  TextEditingController _remisepieceControler = new TextEditingController();
  TextEditingController _pourcentremiseControler = new TextEditingController();
  String _validateVerssemntError;

  double _restepiece;
  double _verssementpiece;
  double _total_ht;
  double _net_ht;
  double _total_tva;
  double _total_ttc;
  double _net_a_payer;

  double _remisepiece;
  double _pourcentremise;

  int _oldMov;

  SliverListDataSource _dataSource;
  QueryCtr _queryCtr;

  BottomBarController bottomBarControler;

  Ticket _ticket;

  MyParams _myParams ;

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

  //**************************************************************************************************************************************
  //*********************************************** init le screen **********************************************************************
  Future<bool> futureInitState() async {
    _tarificationDropdownItems = utils.buildDropTarificationTier(_tarificationItems);
    _selectedTarification = _tarificationItems[0];

    if (widget.arguments is Piece &&
        widget.arguments.id != null &&
        widget.arguments.id > -1) {
      editMode = false;
      modification = true;
      await setDataFromItem(widget.arguments);
    } else {
      await setDataFromItem(null);
      await getNumPiece(widget.arguments);
      _piece.date = DateTime.now();
      _dateControl.text = Helpers.dateToText(DateTime.now());
      editMode = true;
    }
    _myParams = await _queryCtr.getAllParams();
    return Future<bool>.value(editMode);
  }

  Future<void> setDataFromItem(Piece item) async {
    if (item != null) {
      _piece = item;
      _numeroControl.text = _piece.num_piece;
      DateTime time = _piece.date ?? new DateTime.now();
      _piece.date = time;
      _dateControl.text = Helpers.dateToText(time);
      _selectedClient = await _queryCtr.getTierById(_piece.tier_id);
      _clientControl.text = _selectedClient.raisonSociale;
      _selectedTarification = _tarificationItems[_selectedClient.tarification];
      _selectedItems = await _queryCtr.getJournalPiece(item, local: false);
      _verssementControler.text = "0.0";
      _resteControler.text = _piece.reste.toString();

      _oldMov = _piece.mov;
      _restepiece = _piece.reste;
      _verssementpiece = 0;

      _total_ht = _piece.total_ht;
      _net_ht = _piece.net_ht;
      _total_tva = _piece.total_tva;
      _total_ttc =
          (_piece.total_ttc < 0) ? _piece.total_ttc * -1 : _piece.total_ttc;
      _net_a_payer = _piece.net_a_payer;
      _remisepiece = (_piece.remise * _total_ht) / 100;
      _pourcentremise = _piece.remise;

      _remisepieceControler.text = _remisepiece.toString();
      _pourcentremiseControler.text = _pourcentremise.toString();
    } else {
      _piece.piece = widget.arguments.piece;
      if(_piece.piece == PieceType.devis || _piece.piece == PieceType.retourClient ||
          _piece.piece == PieceType.avoirClient || _piece.piece == PieceType.commandeClient ||
          _piece.piece == PieceType.bonLivraison ||  _piece.piece == PieceType.factureClient){

        _selectedClient = await _queryCtr.getTierById(1);
      }else{
        _selectedClient = await _queryCtr.getTierById(2);
      }

      _clientControl.text = _selectedClient.raisonSociale;
      _selectedTarification = _tarificationItems[_selectedClient.tarification];
      _verssementControler.text = "0.0";
      _resteControler.text = "0.0";
      _remisepieceControler.text = "0.0";
      _pourcentremiseControler.text = "0.0";

      _restepiece = 0.0;
      _verssementpiece = 0.0;
      _total_ht = 0.0;
      _net_ht = 0.0;
      _total_tva = 0.0;
      _total_ttc = 0.0;
      _net_a_payer = _total_ttc ;
      _remisepiece = 0;
      _pourcentremise = 0;
    }
  }

  Future<void> getNumPiece(item) async {
    _piece.piece = item.piece;
    List<FormatPiece> list = await _queryCtr.getFormatPiece(_piece.piece);
    setState(() {
      _numeroControl.text = Helpers.generateNumPiece(list.first);
    });
  }

  //************************************************************************************************************************************
  // ***************************************** partie affichage et build *****************************************************************
  @override
  Widget build(BuildContext context) {
    if (modification) {
      if (editMode) {
        appBarTitle = S.current.modification_titre;
        _islisting = false;
      } else {
        appBarTitle = Helpers.getPieceTitle(_piece.piece);
        _islisting = true;
      }
    } else {
      if (editMode) {
        appBarTitle = S.current.ajouter + Helpers.getPieceTitle(_piece.piece);
        _islisting = false;
      } else {
        appBarTitle = Helpers.getPieceTitle(_piece.piece);
        _islisting = true;
      }
    }

    if (!finishedLoading) {
      return Scaffold(body: Helpers.buildLoading());
    } else {
      return Scaffold(
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
                          RoutesKeys.addPiece,
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
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.SUCCES,
                  animType: AnimType.BOTTOMSLIDE,
                  title: S.current.supp,
                  body: addChoicesDialog(),
                  closeIcon: Icon(
                    Icons.remove_circle_outline_sharp,
                    color: Colors.red,
                    size: 26,
                  ),
                  showCloseIcon: true,
                )..show();
              } else {
                Helpers.showFlushBar(context, S.current.msg_select_art);
                setState(() {
                  _validateRaison = true;
                });
              }
            },
            onTrensferPressed: (_piece.etat == 0 &&
                    _piece.piece != PieceType.retourClient &&
                    _piece.piece != PieceType.avoirClient &&
                    _piece.piece != PieceType.retourFournisseur &&
                    _piece.piece != PieceType.avoirFournisseur)
                ? () async {
                    if (_piece.mov == 2) {
                      var message = S.current.msg_err_transfer;
                      Helpers.showFlushBar(context, message);
                    } else {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.QUESTION,
                        animType: AnimType.BOTTOMSLIDE,
                        title: S.current.supp,
                        body: transferPieceDialog(),
                        closeIcon: Icon(
                          Icons.remove_circle_outline_sharp,
                          color: Colors.red,
                          size: 26,
                        ),
                        showCloseIcon: true,
                      )..show();
                    }
                  }
                : null,
          ),
          // extendBody: true,
          bottomNavigationBar: BottomExpandableAppBar(
            expandedHeight: 180,
            controller: bottomBarControler,
            horizontalMargin: 15,
            shape: AutomaticNotchedShape(
                RoundedRectangleBorder(), StadiumBorder(side: BorderSide())),
            expandedBackColor: Colors.lightBlueAccent,
            expandedBody: TotalDevis(
              total_ht: _total_ht,
              total_tva: _total_tva,
              total_ttc: _total_ttc,
              net_ht: _net_ht,
              net_payer:(_myParams.timbre)? _total_ttc + _piece.timbre : _total_ttc,
              remise: _pourcentremise,
              timbre: _piece.timbre,
              myParams: _myParams,
            ),
            bottomAppBarBody: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        if (editMode && _selectedItems.isNotEmpty) {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.INFO,
                            animType: AnimType.BOTTOMSLIDE,
                            title: S.current.supp,
                            body: addRemisedialogue(),
                            btnCancelText: S.current.annuler,
                            btnCancelOnPress: (){},
                            btnOkText:S.current.confirme,
                            btnOkOnPress: (){
                              setState(() {
                                _pourcentremise =
                                    double.parse(_pourcentremiseControler.text);
                                _remisepiece =
                                    double.parse(_remisepieceControler.text);
                              });
                              calculPiece();
                            }
                          )..show();

                        }else{
                          Helpers.showFlushBar(context,  S.current.msg_select_art);
                        }
                      },
                      child: Text(
                        '${S.current.total}: ' +
                            _net_a_payer.toString() +
                            " ${S.current.da}",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold , color: Colors.blue),
                      ),
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  InkWell(
                    onTap: () async {
                      if (editMode) {
                        if (_piece.piece != PieceType.devis &&
                            _piece.piece != PieceType.bonCommande &&
                            _piece.piece != PieceType.retourClient &&
                            _piece.piece != PieceType.avoirClient &&
                            _piece.piece != PieceType.retourFournisseur &&
                            _piece.piece != PieceType.avoirFournisseur ) {

                          if(_selectedItems.isNotEmpty){
                            AwesomeDialog(
                                context: context,
                                dialogType: DialogType.INFO,
                                animType: AnimType.BOTTOMSLIDE,
                                title: S.current.supp,
                                body: addVerssementdialogue(),
                                btnCancelText: S.current.annuler,
                                btnCancelOnPress: (){},
                                btnOkText:S.current.confirme,
                                btnOkOnPress: (){
                                  setState(() {
                                    _restepiece =
                                        double.parse(_resteControler.text);
                                    _verssementpiece =
                                        double.parse(_verssementControler.text);
                                  });
                                }
                            )..show();
                          }else{
                            Helpers.showFlushBar(context,  S.current.msg_select_art);
                          }

                        }else{
                          Helpers.showFlushBar(context, S.current.msg_no_dispo);
                        }
                      }
                    },
                    child: Container(
                        padding: EdgeInsetsDirectional.only(end: 30),
                        child: Text(
                          "${S.current.reste} : " + _restepiece.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: (_piece.piece != PieceType.devis &&
                                      _piece.piece != PieceType.bonCommande &&
                                      _piece.piece != PieceType.retourClient &&
                                      _piece.piece != PieceType.avoirClient &&
                                      _piece.piece !=
                                          PieceType.retourFournisseur &&
                                      _piece.piece !=
                                          PieceType.avoirFournisseur)
                                  ? Colors.blue
                                  : Colors.black54),
                        )),
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
            child: FloatingActionRow(
              children: [
                FloatingActionRowButton(
                    icon: (editMode)
                        ? Icon(
                            Icons.add,
                            color: Colors.white,
                          )
                        : Icon(
                            Icons.print,
                            color: Colors.white,
                          ),
                    color: editMode ? Colors.blue : Colors.redAccent,
                    foregroundColor: Colors.white,
                    //Set onPressed event to swap state of bottom bar
                    onTap: editMode
                        ? () async {
                            if (_piece.piece == PieceType.avoirClient ||
                                _piece.piece == PieceType.retourClient ||
                                _piece.piece == PieceType.retourFournisseur ||
                                _piece.piece == PieceType.avoirFournisseur) {
                              var message = S.current.msg_info_article;
                              Helpers.showFlushBar(context, message);
                            }
                            Future.delayed(Duration(seconds: 1), () async {
                              await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return addArticleDialog();
                                  }).then((val) {
                                calculPiece();
                              });
                            });
                          }
                        : () async {
                            await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return previewItem(_piece);
                                });
                            if (_ticket != null) {
                              await printItem(_ticket);
                              setState(() {
                                _ticket = null;
                              });
                            }
                          }),
                (editMode &&
                        (_piece.piece == PieceType.avoirClient ||
                            _piece.piece == PieceType.retourClient ||
                            _piece.piece == PieceType.retourFournisseur ||
                            _piece.piece == PieceType.avoirFournisseur))
                    ? FloatingActionRowButton(
                        icon: Icon(Icons.insert_drive_file_outlined),
                        color: Colors.redAccent,
                        onTap: () async {
                          await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return addJournauxDialog();
                              }).then((val) {
                            calculPiece();
                          });
                        })
                    : SizedBox(
                        height: 0,
                      ),
              ],
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
        padding: const EdgeInsetsDirectional.fromSTEB(15, 25, 15, 40),
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
                          labelText: S.current.date,
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
                      editMode: editMode,
                      value: _selectedTarification,
                      items: _tarificationDropdownItems,
                      libelle: "${S.current.tarif }",
                      onChanged: (value) {
                        setState(() {
                          _selectedTarification = value;
                        });
                      },
                    ),
                  ),
                  Flexible(
                    flex: 6,
                    child: GestureDetector(
                      onTap: editMode
                          ? () {
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
                          labelText: S.current.client_titre,
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
                                if (editMode) {
                                  return new ArticleListItemSelected(
                                    article: _selectedItems[index],
                                    onItemSelected: (selectedItem) => ({
                                      removeItemfromPiece(selectedItem),
                                      calculPiece()
                                    }),
                                  );
                                } else {
                                  return new ArticleListItemSelected(
                                    article: _selectedItems[index],
                                    fromListing: _islisting,
                                  );
                                }
                              })
                        ],
                      ))
                  : SizedBox(
                      height: 5,
                    ))
        ]));
  }

  //afficher le fragment des artciles
  Widget addArticleDialog() {
    return new ArticlesFragment(
      tarification: _selectedTarification,
      onConfirmSelectedItems: (selectedItem) {
        selectedItem.forEach((item) {
          if (_selectedItems.contains(item)) {
            _selectedItems
                .elementAt(_selectedItems.indexOf(item))
                .selectedQuantite += item.selectedQuantite;
          } else {
            _selectedItems.add(item);
            if (_desSelectedItems.contains(item)) {
              _desSelectedItems.remove(item);
            }
          }
        });
      },
    );
  }

  Widget addJournauxDialog() {
    return new JournalFragment(
      tier: _selectedClient,
      pieceType: _piece.piece,
      onConfirmSelectedItems: (selectedItem) {
        selectedItem.forEach((item) {
          if (_selectedItems.contains(item)) {
            _selectedItems
                .elementAt(_selectedItems.indexOf(item))
                .selectedQuantite += item.selectedQuantite;
          } else {
            _selectedItems.add(item);
            if (_desSelectedItems.contains(item)) {
              _desSelectedItems.remove(item);
            }
          }
        });
      },
    );
  }

  //afficher le fragement des clients
  Widget chooseClientDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new ClientFourFragment(
          clientFourn: (_piece.piece == "CC" ||
                  _piece.piece == "FC" ||
                  _piece.piece == "BL")
              ? 0
              : 2,
          onConfirmSelectedItem: (selectedItem) {
            setState(() {
              _selectedClient = selectedItem;
              _piece.tier_id = _selectedClient.id;
              _piece.raisonSociale = _selectedClient.raisonSociale;
              _clientControl.text = _selectedClient.raisonSociale;
              _selectedTarification =
                  _tarificationItems[_selectedClient.tarification];
            });
          },
        );
      },
    );
  }

  //afficher un dialog pour versseemnt
  Widget addVerssementdialogue() {
    return Wrap(children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      "${S.current.modification_titre} ${S.current.verssement}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
              )),
              Padding(
                padding:
                    EdgeInsetsDirectional.only(start: 5, end: 5, bottom: 20),
                child: TextField(
                  controller: _verssementControler,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (_piece.id != null) {
                      if (_verssementpiece == 0) {
                        double _reste =
                            _total_ttc - (_piece.regler + double.parse(value));
                        _resteControler.text = _reste.toString();
                      } else {
                        double _reste =
                            _total_ttc - (_piece.regler + double.parse(value));
                        _resteControler.text = _reste.toString();
                      }
                    } else {
                      double _reste = _total_ttc - double.parse(value);
                      _resteControler.text = _reste.toString();
                    }
                  },
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
                    labelText: "${S.current.total} ${S.current.verssement}",
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
                  padding: EdgeInsetsDirectional.only(end: 0, start: 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.only(
                            start: 5, end: 5, bottom: 5),
                        child: TextField(
                          controller: _resteControler,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.money,
                              color: Colors.orange[900],
                            ),
                            disabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.orange[900]),
                                borderRadius: BorderRadius.circular(20)),
                            contentPadding:
                                EdgeInsetsDirectional.only(start: 10),
                            labelText: S.current.reste,
                            labelStyle: TextStyle(color: Colors.orange[900]),
                            enabled: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ]
    );
  }

  //afficher un dialog pour la remise
  Widget addRemisedialogue() {
    return Wrap(children: [
      Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  "${S.current.modification_titre} ${S.current.remise}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
            )),
            Padding(
              padding: EdgeInsetsDirectional.only(start: 5, end: 5, bottom: 20),
              child: TextField(
                controller: _remisepieceControler,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _remisepiece = double.parse(value);
                  _pourcentremise = (_remisepiece * 100) / _total_ht;
                  _pourcentremiseControler.text = _pourcentremise.toString();
                },
                decoration: InputDecoration(
                  errorText: _validateVerssemntError ?? null,
                  prefixIcon: Icon(
                    Icons.monetization_on,
                    color: Colors.green,
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green[600]),
                      borderRadius: BorderRadius.circular(20)),
                  contentPadding: EdgeInsets.only(left: 10),
                  labelText: "${S.current.montant}",
                  labelStyle: TextStyle(color: Colors.green[400]),
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
                padding: EdgeInsetsDirectional.only(end: 0, start: 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                          start: 5, end: 5, bottom: 5),
                      child: TextField(
                        controller: _pourcentremiseControler,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          _pourcentremise = double.parse(value);
                          _remisepiece = (_total_ht * _pourcentremise) / 100;
                          _remisepieceControler.text = _remisepiece.toString();
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            MdiIcons.percent,
                            color: Colors.orange[900],
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange[900]),
                              borderRadius: BorderRadius.circular(20)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange[600]),
                              borderRadius: BorderRadius.circular(20)),
                          contentPadding: EdgeInsetsDirectional.only(start: 10),
                          labelText: S.current.pourcentage,
                          labelStyle: TextStyle(color: Colors.orange[900]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ]);
  }

  //remove item from piece in update mode
  void removeItemfromPiece(selectedItem) {
    if (selectedItem != null) {
      if (_selectedItems.contains(selectedItem)) {
        _selectedItems.remove(selectedItem);
        _desSelectedItems.add(selectedItem);
      }
    }
  }

  //calcule le montant total
  // le total_ttc = net_a_payer le timbre = 0
  void calculPiece() {
    double sum = 0;
    double totalTva = 0;
    setState(() {
      _selectedItems.forEach((item) {
        sum += (item.selectedQuantite * item.selectedPrice);
        totalTva += item.selectedQuantite * item.tva;
      });
      _total_ht = sum;
      _total_tva =(_myParams.tva)? totalTva : 0.0;
      _net_ht = _total_ht - ((_total_ht * _pourcentremise) / 100);
      _total_ttc = _net_ht + _total_tva;
      _net_a_payer =(_myParams.timbre)? _total_ttc + _piece.timbre : _total_ttc + 0.0;

      if (_piece.id != null) {
        if (_net_a_payer <= _piece.net_a_payer) {
          _verssementpiece = 0.0;
          _verssementControler.text = _verssementpiece.toString();
          _restepiece = _net_a_payer - _piece.regler;
          _resteControler.text = _restepiece.toString();
        } else {
          // le verssement est 0 tjr tq l'utilisateur ne le modifie pas
          // _verssementpiece = _net_a_payer - _piece.regler;
          // if(_piece.piece == PieceType.commandeClient){
          //   _verssementpiece = 0.0 ;
          // }
          _verssementpiece = 0.0;
          _verssementControler.text = _verssementpiece.toString();
          _restepiece = _net_a_payer - _piece.regler;
          _resteControler.text = "0.0";
        }
      } else {
        // le verssement est 0 tjr tq l'utilisateur ne le modifie pas
        // _verssementpiece = _net_a_payer;
        // if(_piece.piece == PieceType.commandeClient){
        //   _verssementpiece = 0.0 ;
        // }
        _verssementpiece = 0.0;
        _verssementControler.text = _verssementpiece.toString();
        _restepiece = _net_a_payer - _verssementpiece;
      }
    });
  }

  //*********************************************************************************************************************************************************************************
  //********************************************************************** partie de la date ****************************************************************************************
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

  //********************************************************************************************************************************************************************************
  //*************************************************************************** partie de save dialog et options ***********************************************************************************

  //dialog de save
  Widget addChoicesDialog() {
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Builder(
          builder: (context) => SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Wrap(spacing: 13, runSpacing: 13, children: [
                    Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Text(
                            "${S.current.choisir_action}: ",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                    )),
                    SizedBox(
                      width: 320.0,
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(end: 0, start: 0),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          onPressed: () async {
                            int mov = getMovForPiece();
                            await saveItem(mov);
                            await quikPrintTicket();
                          },
                          child: Text(
                            S.current.imp_rapide_btn,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 320.0,
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(end: 0, start: 0),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          onPressed: () async {
                            int mov = getMovForPiece();
                            await saveItem(mov);
                            Navigator.pop(context);
                            await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return previewItem(_piece);
                                });
                            if (_ticket != null) {
                              await printItem(_ticket);
                              setState(() {
                                _ticket = null;
                              });
                            }
                          },
                          child: Text(
                            S.current.save_imp_btn,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          color: Colors.green,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 320.0,
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(end: 0, start: 0),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          onPressed: () async {
                            int mov = getMovForPiece();
                            await saveItem(mov);
                          },
                          child: Text(
                            S.current.save_btn,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          color: Colors.deepOrange,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: (_piece.mov != 1 && _piece.mov != 0),
                      child: SizedBox(
                        width: 320.0,
                        child: Padding(
                          padding: EdgeInsetsDirectional.only(end: 0, start: 0),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            onPressed: () async {
                              await saveItemAsDraft();
                            },
                            child: Text(
                              S.current.broullion_btn,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ));
    });
  }

  int getMovForPiece() {
    switch (_piece.piece) {
      case (PieceType.devis):
        return 0;
        break;

      case (PieceType.bonCommande):
        return 0;
        break;

      default:
        return 1;
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
        _verssementpiece = 0.0;
      });
    }
  }

  saveItemAsDraft() async {
    saveItem(2);
  }

  previewItem(item) {
    return PreviewPiece(
      piece: item,
      articles: _selectedItems,
      tier: _selectedClient,
      ticket: (ticket) {
        setState(() {
          _ticket = ticket;
        });
      },
    );
  }

  printItem(ticket) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Print(ticket);
      },
    );
  }

  //**********************************************************************************************************************************************
  //************************************************add or update item *************************************************************************
  Future<int> addItemToDb() async {
    int id = -1;
    String message;
    try {
      if (widget.arguments.id != null) {
        //edit piece
        var item = await makePiece();
        id = await _queryCtr.updateItemInDb(DbTablesNames.pieces, item);
        _selectedItems.forEach((article) async {
          Journaux journaux = Journaux.fromPiece(item, article);
          await _queryCtr.updateJournaux(DbTablesNames.journaux, journaux);
        });
        _desSelectedItems.forEach((article) async {
          Journaux journaux = Journaux.fromPiece(item, article);
          journaux.mov = -2;
          await _queryCtr.updateJournaux(DbTablesNames.journaux, journaux);
        });

        if (_oldMov != null && _piece.mov != _oldMov) {
          //ds le cas de modification de mov de piece
          // update tresorie mov
          await _queryCtr.updateItemByForeignKey(
              DbTablesNames.tresorie, "Mov", _piece.mov, "Piece_id", _piece.id);
        }

        if (_piece.piece != PieceType.devis &&
            _piece.piece != PieceType.retourClient &&
            _piece.piece != PieceType.avoirClient &&
            _piece.piece != PieceType.retourFournisseur &&
            _piece.piece != PieceType.avoirFournisseur) {
          await addTresorie(_piece, transferer: false);
        }

        if (id > -1) {
          widget.arguments = item;
          widget.arguments.id = _piece.id;
          message = S.current.msg_update_item;
        } else {
          message = S.current.msg_update_err;
        }
      } else {
        //add new piece
        Piece piece = await makePiece();
        piece.etat = 0;
        id = await _queryCtr.addItemToTable(DbTablesNames.pieces, piece);
        if (id > -1) {
          piece.id = await _queryCtr.getLastId(DbTablesNames.pieces);
        }
        _selectedItems.forEach((article) async {
          Journaux journaux = Journaux.fromPiece(piece, article);
          await _queryCtr.addItemToTable(DbTablesNames.journaux, journaux);
        });

        if (_piece.piece != PieceType.devis &&
            _piece.piece != PieceType.retourClient &&
            _piece.piece != PieceType.avoirClient &&
            _piece.piece != PieceType.retourFournisseur &&
            _piece.piece != PieceType.avoirFournisseur) {
          await addTresorie(_piece, transferer: false);
        }

        if (id > -1) {
          widget.arguments = piece;
          widget.arguments.id = id;
          message = S.current.msg_ajout_item;
        } else {
          message = S.current.msg_ajout_err;
        }
      }

      Navigator.pop(context);
      Helpers.showFlushBar(context, message);
      return Future.value(id);
    } catch (error) {
      Helpers.showFlushBar(context, S.current.msg_ereure);
      return Future.value(-1);
    }
  }

  Future<Object> makePiece() async {
    var tiers = _selectedClient;
    _piece.num_piece = _numeroControl.text;
    _piece.tier_id = tiers.id;
    _piece.raisonSociale = tiers.raisonSociale;
    _piece.tarification = _selectedTarification;

    _piece.total_ht = _total_ht;
    _piece.net_ht = _net_ht;
    _piece.total_tva = _total_tva;
    _piece.total_ttc = _total_ttc;
    _piece.net_a_payer = _net_a_payer;
    _piece.remise = _pourcentremise;

    if (_piece.transformer == null) {
      _piece.transformer = 0;
    }

    if (_piece.id == null) {
      _piece.regler = _verssementpiece;
    } else {
      _piece.regler = _piece.regler + _verssementpiece;
    }
    _piece.reste = _piece.net_a_payer - _piece.regler;

    if (_piece.piece == PieceType.retourClient ||
        _piece.piece == PieceType.avoirClient ||
        _piece.piece == PieceType.retourFournisseur ||
        _piece.piece == PieceType.avoirFournisseur) {
      _piece.net_a_payer = _piece.net_a_payer * -1;
    }

    var res = await _queryCtr.getPieceByNum(_piece.num_piece, _piece.piece);
    if (res.length >= 1 && !modification) {
      var message = S.current.msg_num_existe;
      Helpers.showFlushBar(context, message);
      await getNumPiece(_piece);
      _piece.num_piece = _numeroControl.text;
    }

    return _piece;
  }

  Future<void> addTresorie(item, {transferer}) async {
    Tresorie tresorie = new Tresorie.init();
    tresorie.montant = _verssementpiece;
    tresorie.compte = 1 ;
    tresorie.charge=null ;
    if (transferer) {
      tresorie.montant = 0;
    }

    //special pour l'etat de la tresorie
    tresorie.mov = item.mov;

    tresorie.objet =
        "${S.current.reglement_piece} ${item.piece} ${item.num_piece}";
    tresorie.modalite = S.current.espece;
    tresorie.tierId = item.tier_id;
    tresorie.tierRS = item.raisonSociale;
    tresorie.pieceId = item.id;
    tresorie.date = new DateTime.now();
    if (item.piece == PieceType.bonLivraison ||
        item.piece == PieceType.factureClient ||
        item.piece == PieceType.commandeClient) {
      tresorie.categorie = 2;
    } else {
      if (item.piece == PieceType.bonReception ||
          item.piece == PieceType.factureFournisseur) {
        tresorie.categorie = 3;
      } else {
        if (item.piece == PieceType.retourClient ||
            item.piece == PieceType.avoirClient) {
          tresorie.categorie = 6;
          tresorie.montant = tresorie.montant * -1;
        } else {
          if (item.piece == PieceType.retourFournisseur ||
              item.piece == PieceType.avoirFournisseur) {
            tresorie.categorie = 7;
            tresorie.montant = tresorie.montant * -1;
          }
        }
      }
    }
    List<FormatPiece> list = await _queryCtr.getFormatPiece(PieceType.tresorie);
    tresorie.numTresorie = Helpers.generateNumPiece(list.first);

    await _queryCtr.addItemToTable(DbTablesNames.tresorie, tresorie);

    ReglementTresorie reglementTresorie = new ReglementTresorie.init();
    reglementTresorie.tresorie_id =
        await _queryCtr.getLastId(DbTablesNames.tresorie);
    reglementTresorie.piece_id =
        await _queryCtr.getLastId(DbTablesNames.pieces);
    reglementTresorie.regler = tresorie.montant;
    await _queryCtr.addItemToTable(
        DbTablesNames.reglementTresorie, reglementTresorie);
  }

  //******************************************************************************************************************************************
  //***********************************special pour la transformation de la piece*************************************************************

  Widget transferPieceDialog() {
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Builder(
          builder: (context) => SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Wrap(spacing: 13, runSpacing: 13, children: [
                    Center(
                        child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        "${S.current.choisir_action}: ",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )),
                    Visibility(
                      visible: (_piece.piece == PieceType.devis),
                      child: SizedBox(
                        width: 320.0,
                        child: Padding(
                          padding: EdgeInsetsDirectional.only(end: 0, start: 0),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            onPressed: () async {
                              var msg =
                                  await transfererPiece(context, "toCommande");
                              Helpers.showFlushBar(context, msg);
                            },
                            child: Text(
                              S.current.to_commande,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            color: Colors.purple,
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: (_piece.piece == PieceType.devis ||
                          _piece.piece == PieceType.commandeClient ||
                          _piece.piece == PieceType.bonCommande),
                      child: SizedBox(
                        width: 320.0,
                        child: Padding(
                          padding: EdgeInsetsDirectional.only(end: 0, start: 0),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            onPressed: () async {
                              var msg = await transfererPiece(context, "toBon");
                              Helpers.showFlushBar(context, msg);
                            },
                            child: Text(
                              S.current.to_bon,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: (_piece.piece != PieceType.factureClient &&
                          _piece.piece != PieceType.factureFournisseur),
                      child: SizedBox(
                        width: 320.0,
                        child: Padding(
                          padding: EdgeInsetsDirectional.only(end: 0, start: 0),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            onPressed: () async {
                              var msg =
                                  await transfererPiece(context, "toFacture");
                              Helpers.showFlushBar(context, msg);
                            },
                            child: Text(
                              S.current.to_facture,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: ((_piece.piece == PieceType.bonReception ||
                          _piece.piece == PieceType.bonLivraison ||
                          _piece.piece == PieceType.factureClient ||
                          _piece.piece == PieceType.factureFournisseur)),
                      child: SizedBox(
                        width: 320.0,
                        child: Padding(
                          padding: EdgeInsets.only(right: 0, left: 0),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            onPressed: () async {
                              var msg =
                                  await transfererPiece(context, "toRetour");
                              Helpers.showFlushBar(context, msg);
                            },
                            child: Text(
                              S.current.to_retour,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ));
    });
  }

  Future<String> transfererPiece(context, String to) async {
    try {
      int id = -1;
      Piece _newPiece = new Piece.init();
      _newPiece.tier_id = _piece.tier_id;
      _newPiece.raisonSociale = _piece.raisonSociale;
      _newPiece.piece = typePieceTransformer(_piece.piece, to);

      _newPiece.mov = 1;
      _newPiece.transformer = 1;
      _newPiece.etat = 0;
      _newPiece.tarification = _piece.tarification;

      var res = await _queryCtr.getFormatPiece(_newPiece.piece);
      _newPiece.num_piece = Helpers.generateNumPiece(res.first);

      _newPiece.total_ttc = _piece.total_ttc;
      _newPiece.total_tva = _piece.total_tva;
      _newPiece.total_ht = _piece.total_ht;
      _newPiece.net_ht = _piece.net_ht;
      _newPiece.date = _piece.date;
      _newPiece.net_a_payer = _piece.net_a_payer;
      _newPiece.reste = _piece.reste;
      _newPiece.regler = _piece.regler;
      _newPiece.remise = _piece.remise;
      _newPiece.marge = _piece.marge;

      if (_newPiece.piece == PieceType.retourClient ||
          _newPiece.piece == PieceType.avoirClient ||
          _newPiece.piece == PieceType.retourFournisseur ||
          _newPiece.piece == PieceType.avoirFournisseur) {
        _newPiece.net_a_payer = _newPiece.net_a_payer * -1;
      }

      id = await _queryCtr.addItemToTable(DbTablesNames.pieces, _newPiece);
      if (id > -1) {
        _newPiece.id = await _queryCtr.getLastId(DbTablesNames.pieces);
      }
      _selectedItems.forEach((article) async {
        Journaux journaux = Journaux.fromPiece(_newPiece, article);
        await _queryCtr.addItemToTable(DbTablesNames.journaux, journaux);
      });

      int _oldMov = _piece.mov;

      //  add la transformation à la table transformer (oldPiece_id newPiece_id , oldMov)
      // update tresorie with triggers
      Transformer transformer = new Transformer.init();
      transformer.oldMov = _oldMov;
      transformer.newPieceId = _newPiece.id;
      transformer.oldPieceId = _piece.id;
      transformer.type_piece = _newPiece.piece;
      await _queryCtr.addItemToTable(DbTablesNames.transformer, transformer);

      // devis vers bl ou FC
      if (_oldMov == 0) {
        await addTresorie(_newPiece, transferer: true);
      }

      var message = S.current.msg_piece_transfere;

      _piece.etat = 1;

      if (_newPiece.piece == PieceType.retourClient ||
          _newPiece.piece == PieceType.avoirClient ||
          _newPiece.piece == PieceType.retourFournisseur ||
          _newPiece.piece == PieceType.avoirFournisseur) {
        await saveItem(1);
      } else {
        await saveItem(0);
      }

      Navigator.pop(context);
      return message;
    } catch (e) {
      var message = S.current.msg_transfere_err;
      return message;
    }
  }

  String typePieceTransformer(pi, to) {
    switch (pi) {
      case PieceType.devis:
        if (to == "toCommande") {
          return PieceType.commandeClient;
        } else {
          if (to == "toBon") {
            return PieceType.bonLivraison;
          } else {
            if (to == "toFacture") {
              return PieceType.factureClient;
            }
          }
        }
        break;
      case PieceType.commandeClient:
        if (to == "toBon") {
          return PieceType.bonLivraison;
        } else {
          if (to == "toFacture") {
            return PieceType.factureClient;
          }
        }
        break;
      case PieceType.bonLivraison:
        if (to == "toFacture") {
          return PieceType.factureClient;
        } else {
          if (to == "toRetour") {
            return PieceType.retourClient;
          }
        }
        break;
      case PieceType.factureClient:
        return PieceType.avoirClient;
        break;
      case PieceType.bonCommande:
        if (to == "toBon") {
          return PieceType.bonReception;
        } else {
          if (to == "toFacture") {
            return PieceType.factureFournisseur;
          }
        }
        break;
      case PieceType.bonReception:
        if (to == "toFacture") {
          return PieceType.factureFournisseur;
        } else {
          if (to == "toRetour") {
            return PieceType.retourFournisseur;
          }
        }
        break;
      case PieceType.factureFournisseur:
        return PieceType.avoirClient;
        break;
    }
  }

  //******************************************************************************************************************************************
  //****************************************quik print****************************************************************************************
  quikPrintTicket() async {
    var defaultPrinter = await _queryCtr.getPrinter();

    if (defaultPrinter != null) {
      PrinterBluetoothManager _printerManager = PrinterBluetoothManager();
      BluetoothDevice device = new BluetoothDevice();
      device.name = defaultPrinter.name;
      device.type = defaultPrinter.type;
      device.address = defaultPrinter.adress;
      device.connected = true;

      PrinterBluetooth _device = new PrinterBluetooth(device);

      _printerManager.selectPrinter(_device);
      var formatPrint = await _queryCtr.getFormatPrint();
      Ticket ticket = await _maketicket(formatPrint);
      _printerManager.printTicket(ticket).then((result) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Text(result.msg),
          ),
        );
        dispose();
      }).catchError((error) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Text(error.toString()),
          ),
        );
      });
    } else {
      var message = S.current.msg_imp_err;
      Helpers.showFlushBar(context, message);
    }
  }

  Future<Ticket> _maketicket(FormatPrint formatPrint) async {
    final ticket = Ticket(formatPrint.default_format);

    ticket.text("N° ${_piece.piece}: ${_piece.num_piece}",
        styles: PosStyles(
            align: (formatPrint.default_format == PaperSize.mm80)
                ? PosAlign.center
                : PosAlign.left));
    ticket.text("Date : ${Helpers.dateToText(_piece.date)}",
        styles: PosStyles(
            align: (formatPrint.default_format == PaperSize.mm80)
                ? PosAlign.center
                : PosAlign.left));
    ticket.text("Tier : ${_piece.raisonSociale}",
        styles: PosStyles(
            align: (formatPrint.default_format == PaperSize.mm80)
                ? PosAlign.center
                : PosAlign.left));
    ticket.hr(ch: '-');
    ticket.row([
      PosColumn(text: 'Item', width: 6, styles: PosStyles(bold: true)),
      PosColumn(text: 'QTE', width: 2, styles: PosStyles(bold: true)),
      PosColumn(text: 'Prix', width: 2, styles: PosStyles(bold: true)),
      PosColumn(text: 'Montant', width: 2, styles: PosStyles(bold: true)),
    ]);
    _selectedItems.forEach((element) {
      ticket.row([
        (formatPrint.default_display == "Referance")
            ? PosColumn(text: '${element.ref}', width: 6)
            : PosColumn(text: '${element.designation}', width: 6),
        PosColumn(text: '${element.selectedQuantite}', width: 2),
        PosColumn(text: '${element.selectedPrice}', width: 2),
        PosColumn(
            text: '${element.selectedPrice * element.selectedQuantite}',
            width: 2),
      ]);
    });
    ticket.hr(ch: '-');
    if (formatPrint.totalHt == 1) {
      ticket.text("Total HT : ${_piece.total_ht}",
          styles: PosStyles(
              align: (formatPrint.default_format == PaperSize.mm80)
                  ? PosAlign.center
                  : PosAlign.left));
    }
    if (formatPrint.totalTva == 1) {
      ticket.text("Total TVA : ${_piece.total_tva}",
          styles: PosStyles(
              align: (formatPrint.default_format == PaperSize.mm80)
                  ? PosAlign.center
                  : PosAlign.left));
    }

    ticket.text("Regler : ${_piece.regler}",
        styles: PosStyles(
            align: (formatPrint.default_format == PaperSize.mm80)
                ? PosAlign.center
                : PosAlign.left));

    if (formatPrint.reste == 1) {
      ticket.text("Reste : ${_piece.reste}",
          styles: PosStyles(
              align: (formatPrint.default_format == PaperSize.mm80)
                  ? PosAlign.center
                  : PosAlign.left));
    }
    if (formatPrint.credit == 1) {
      ticket.text("Total Credit : ${_selectedClient.credit}",
          styles: PosStyles(
              align: (formatPrint.default_format == PaperSize.mm80)
                  ? PosAlign.center
                  : PosAlign.left));
    }
    ticket.hr(ch: '=');
    ticket.text("TOTAL TTC : ${_piece.total_ttc}",
        styles: PosStyles(
          align: (formatPrint.default_format == PaperSize.mm80)
              ? PosAlign.center
              : PosAlign.left,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));
    ticket.hr(ch: '=');
    ticket.feed(1);
    ticket.text('***BY CIRTA IT***',
        styles: PosStyles(
            align: (formatPrint.default_format == PaperSize.mm80)
                ? PosAlign.center
                : PosAlign.left,
            bold: true));
    ticket.feed(1);
    ticket.cut();

    return ticket;
  }
}
