import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/Widgets/CustomWidgets/add_save_bar.dart';
import 'package:gestmob/Widgets/CustomWidgets/list_dropdown.dart';
import 'package:gestmob/Widgets/piece_list_item.dart';
import 'package:gestmob/Widgets/utils.dart' as utils;
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/ChargeTresorie.dart';
import 'package:gestmob/models/CompteTresorie.dart';
import 'package:gestmob/models/FormatPiece.dart';
import 'package:gestmob/models/Piece.dart';
import 'package:gestmob/models/ReglementTresorie.dart';
import 'package:gestmob/models/Tiers.dart';
import 'package:gestmob/models/Tresorie.dart';
import 'package:gestmob/models/TresorieCategories.dart';
import 'package:gestmob/services/push_notifications.dart';
import 'package:gestmob/ui/ClientFourFragment.dart';
import 'package:gestmob/ui/PiecesFragment.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:gestmob/Helpers/string_cap_extension.dart';

class AddTresoriePage extends StatefulWidget {
  var arguments;

  AddTresoriePage({Key key, @required this.arguments}) : super(key: key);

  @override
  _AddTresoriePageState createState() => _AddTresoriePageState();
}

class _AddTresoriePageState extends State<AddTresoriePage>
    with TickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Tresorie _tresorie = new Tresorie.init();

  bool editMode = true;
  bool modification = false;
  bool finishedLoading = false;
  bool _showTierController = true;
  String appBarTitle = S.current.tresorie_titre;
  List<Piece> _selectedPieces = new List<Piece>();
  Tiers _selectedClient;

  TextEditingController _numeroControl = new TextEditingController();
  TextEditingController _dateControl = new TextEditingController();
  TextEditingController _clientControl = new TextEditingController();
  TextEditingController _objetControl = new TextEditingController();
  TextEditingController _numchequeControl = new TextEditingController();
  TextEditingController _montantControl = new TextEditingController();

  double _restepiece = 0.0;
  double _verssementpiece;

  List<DropdownMenuItem<String>> _tiersDropdownItems;
  String _selectedTypeTiers;

  List<TresorieCategories> _categorieItems;
  List<DropdownMenuItem<TresorieCategories>> _categorieDropdownItems;
  TresorieCategories _selectedCategorie;

  List<CompteTresorie> _compteItems;
  List<DropdownMenuItem<CompteTresorie>> _compteDropdownItems;
  CompteTresorie _selectedCompte;

  List<ChargeTresorie> _chargeItems;
  List<DropdownMenuItem<ChargeTresorie>> _chargeDropdownItems;
  ChargeTresorie _selectedCharge;

  QueryCtr _queryCtr = new QueryCtr();
  BottomBarController bottomBarControler;
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  String _devise;

  List<DropdownMenuItem<String>> _modaliteDropdownItems;
  String _selectedmodalite;

  void initState() {
    super.initState();
    bottomBarControler =
        BottomBarController(vsync: this, dragLength: 450, snap: true);
    futureInitState().then((val) {
      setState(() {
        finishedLoading = true;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    PushNotificationsManagerState data = PushNotificationsManager.of(context);
    _devise = Helpers.getDeviseTranslate(data.myParams.devise);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> futureInitState() async {
    _tiersDropdownItems = utils.buildDropTypeTier(Statics.tiersItems);
    _selectedTypeTiers = Statics.tiersItems[0];

    _categorieItems = await _queryCtr.getAllTresorieCategorie();
    _categorieItems[0].libelle = '';
    _categorieItems[1].libelle = S.current.reglemnt_client;
    _categorieItems[2].libelle = S.current.reglement_fournisseur;
    _categorieItems[3].libelle = S.current.encaissement;
    _categorieItems[4].libelle = S.current.charge;
    _categorieItems[5].libelle = S.current.rembourcement_client;
    _categorieItems[6].libelle = S.current.rembourcement_four;
    _categorieItems[7].libelle = S.current.decaissement;
    _categorieDropdownItems =
        utils.buildDropTresorieCategoriesDownMenuItems(_categorieItems);
    _selectedCategorie = _categorieItems[0];

    Statics.modaliteList[0] = S.current.espece;
    Statics.modaliteList[1] = S.current.cheque;
    Statics.modaliteList[2] = S.current.virement;
    Statics.modaliteList[3] = S.current.verssement;
    Statics.modaliteList[4] = S.current.carte_bancaire;
    Statics.modaliteList[5] = S.current.traite_bancaire;
    _modaliteDropdownItems = utils.buildDropStatutTier(Statics.modaliteList);
    _selectedmodalite = Statics.modaliteList[0];

    _compteItems = await _queryCtr.getAllCompteTresorie();
    _compteDropdownItems =
        utils.buildDropCompteTresorieDownMenuItems(_compteItems);
    _selectedCompte = _compteItems[0];

    _chargeItems = await _queryCtr.getAllChargeTresorie();
    _chargeItems[0].libelle = S.current.choisir;
    _chargeDropdownItems =
        utils.buildDropChargeTresorieDownMenuItems(_chargeItems);
    _selectedCharge = _chargeItems[0];

    if (widget.arguments is Tresorie &&
        widget.arguments.id != null &&
        widget.arguments.id > -1) {
      editMode = false;
      modification = true;
      await setDataFromItem(widget.arguments);
    } else {
      await setDataFromItem(null);
      await getNumPiece();
      _tresorie.date = DateTime.now();
      _dateControl.text = Helpers.dateToText(DateTime.now());
      _selectedPieces = new List<Piece>();
      editMode = true;
    }
    return Future<bool>.value(editMode);
  }

  Future<void> setDataFromItem(item) async {
    if (item != null) {
      _tresorie = item;
      _numeroControl.text = _tresorie.numTresorie;
      DateTime time = _tresorie.date ?? new DateTime.now();
      _tresorie.date = time;
      _dateControl.text = Helpers.dateToText(time);
      if (_tresorie.tierId != null) {
        _selectedClient = await _queryCtr.getTierById(_tresorie.tierId);
        _clientControl.text = _selectedClient.raisonSociale;
        _selectedTypeTiers = Statics.tiersItems[_selectedClient.clientFour];
      }
      if (_tresorie.pieceId != null) {
        Piece res = await _queryCtr.getPieceById(_tresorie.pieceId);
        _selectedPieces.add(res);
        _restepiece = res.reste;
        _verssementpiece = res.regler;
      } else {
        _selectedPieces = new List<Piece>();
      }
      _selectedCategorie = _categorieItems[_tresorie.categorie - 1];
      _selectedCompte = _compteItems[_tresorie.compte - 1];
      _selectedCharge = (_tresorie.charge != null)
          ? _chargeItems[_tresorie.charge - 1]
          : _chargeItems[0];

      if (_selectedCategorie.id == 2 ||
          _selectedCategorie.id == 3 ||
          _selectedCategorie.id == 6 ||
          _selectedCategorie.id == 7) {
        _showTierController = true;
      } else {
        _showTierController = false;
      }
      _objetControl.text = _tresorie.objet;
      _selectedmodalite = Statics.modaliteList[_tresorie.modalite];
      _numchequeControl.text = _tresorie.numCheque;
      _montantControl.text = (_tresorie.montant < 0)
          ? ((_tresorie.montant * -1)).toStringAsFixed(2)
          : (_tresorie.montant).toStringAsFixed(2);
    } else {
      _selectedTypeTiers = Statics.tiersItems[0];
      _selectedCategorie = _categorieItems[1];
      _selectedmodalite = Statics.modaliteList[0];
      _selectedCompte = _compteItems[0];
      _selectedCharge = _chargeItems[0];
      _objetControl.text = _selectedCategorie.libelle;
    }
  }

  Future<void> getNumPiece() async {
    List<FormatPiece> list = await _queryCtr.getFormatPiece(PieceType.tresorie);
    setState(() {
      _numeroControl.text = Helpers.generateNumPiece(list.first);
    });
  }

  //****************************************************************************************************************************************************************
  //***********************************************************************build de l'affichage***************************************************************************
  @override
  Widget build(BuildContext context) {
    if (modification) {
      if (editMode) {
        appBarTitle = S.current.modification_titre;
      } else {
        appBarTitle = S.current.tresorie_titre;
      }
    } else {
      if (editMode) {
        appBarTitle = "${S.current.tresorie_titre}";
      } else {
        appBarTitle = S.current.tresorie_titre;
      }
    }

    if (!finishedLoading) {
      return Scaffold(body: Helpers.buildLoading());
    } else {
      return WillPopScope(
        onWillPop: _onWillPop,
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
            // extendBody: true,
            bottomNavigationBar: ((_selectedCategorie.id == 2 ||
                        _selectedCategorie.id == 3 ||
                        _selectedCategorie.id == 6 ||
                        _selectedCategorie.id == 7) &&
                    !modification)
                ? BottomExpandableAppBar(
                    controller: bottomBarControler,
                    horizontalMargin: 10,
                    shape: AutomaticNotchedShape(RoundedRectangleBorder(),
                        StadiumBorder(side: BorderSide())),
                    expandedBackColor: Colors.blue,
                    expandedBody: Container(),
                    appBarHeight: 60,
                    bottomAppBarBody: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: (_selectedClient != null)
                                ? Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Icon(
                                              Icons.person_sharp,
                                              color: (editMode)
                                                  ? Colors.blue
                                                  : Theme.of(context)
                                                      .primaryColorDark,
                                              size: 18,
                                            ),
                                            Text(
                                              "($_devise)",
                                              style: GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          '${Helpers.numberFormat(_selectedClient.credit).toString()}',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14)),
                                        ),
                                      ],
                                    ),
                                  )
                                : SizedBox(),
                          ),
                          Spacer(
                            flex: 1,
                          ),
                          Expanded(
                            flex: 4,
                            child: Container(
                                child: (_selectedPieces.isNotEmpty)
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Icon(Icons.attach_money,
                                                  size: 20,
                                                  color: Theme.of(context)
                                                      .primaryColorDark),
                                              Text(
                                                "($_devise)",
                                                style: GoogleFonts.lato(
                                                    textStyle: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "${Helpers.numberFormat(_restepiece).toString()}",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ],
                                      )
                                    : null),
                          ),
                        ],
                      ),
                    ),
                  )
                : null,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: ((_selectedCategorie.id == 2 ||
                        _selectedCategorie.id == 3 ||
                        _selectedCategorie.id == 6 ||
                        _selectedCategorie.id == 7) &&
                    !modification)
                ? FloatingActionButton(
                    child: Icon(Icons.add),
                    elevation: 2,
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    onPressed: _pressAddPiece,
                  )
                : null,
            body: Builder(
              builder: (context) => fichetab(),
            )),
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
              Navigator.of(context).pushReplacementNamed(RoutesKeys.addTresorie,
                  arguments: widget.arguments);
            })
          ..show();
        return Future.value(false);
      } else {
        Navigator.pop(context, widget.arguments);
        return Future.value(false);
      }
    } else {
      if (_montantControl.text != '') {
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
              Navigator.of(context).pushReplacementNamed(RoutesKeys.addTresorie,
                  arguments: widget.arguments);
            })
          ..show();
      } else {
        Navigator.pop(context, widget.arguments);
      }
    } else {
      if (_montantControl.text != '') {
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
    if (_formKey.currentState.validate() && _formKey1.currentState.validate()) {
      int id = await addItemToDb();
      if (id > -1) {
        setState(() {
          modification = true;
          editMode = false;
        });
      }
    } else {
      Helpers.showToast("${S.current.msg_champs_obg}");
    }
  }

  _pressAddPiece() async {
    if (editMode && !modification) {
      if (_selectedClient != null) {
        await showDialog(
            context: context,
            builder: (BuildContext context) {
              return choosePieceDialog();
            });
      } else {
        var message = S.current.msg_select_tier;
        Helpers.showToast(message);
      }
    }
  }

  Widget fichetab() {
    return SingleChildScrollView(
        physics: ScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 60),
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          Wrap(
            spacing: 13,
            runSpacing: 13,
            children: [
              Form(
                key: _formKey1,
                child: Row(
                  children: [
                    Flexible(
                      flex: 4,
                      child: TextFormField(
                        enabled: editMode && !modification,
                        controller: _numeroControl,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value.isEmpty) {
                            return S.current.msg_champ_oblg;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "#/YYYY",
                          prefixIcon: Icon(
                            MdiIcons.idCard,
                            color: Colors.orange[900],
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange[900]),
                              borderRadius: BorderRadius.circular(5)),
                          labelText: "${S.current.n}",
                          labelStyle: GoogleFonts.lato(
                              textStyle: TextStyle(color: Colors.orange[900])),
                          enabledBorder: OutlineInputBorder(
                            gapPadding: 3.3,
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Colors.orange[900]),
                          ),
                        ),
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
                                borderRadius: BorderRadius.circular(5)),
                            labelText: S.current.date,
                            labelStyle: GoogleFonts.lato(
                                textStyle: TextStyle(color: Colors.blue)),
                            enabledBorder: OutlineInputBorder(
                              gapPadding: 3.3,
                              borderRadius: BorderRadius.circular(5),
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
              ),
              Visibility(
                visible: editMode && !modification,
                child: ListDropDown(
                  editMode: editMode,
                  value: _selectedCategorie,
                  items: _categorieDropdownItems,
                  libelle: _selectedCategorie.libelle,
                  onChanged: (value) {
                    setState(() {
                      _selectedCategorie = value;
                      if (_selectedCategorie.id == 1) {
                        _selectedCategorie = _categorieItems.elementAt(1);
                      }
                      _objetControl.text = _selectedCategorie.libelle;
                      _selectedPieces.clear();
                      _montantControl.text = "0.0";

                      if (_selectedCategorie.id == 2 ||
                          _selectedCategorie.id == 3 ||
                          _selectedCategorie.id == 6 ||
                          _selectedCategorie.id == 7) {
                        _clientControl.text = "";
                        _selectedClient = null;
                        _showTierController = true;
                      } else {
                        _showTierController = false;
                      }

                      if (_selectedCategorie.id == 2 ||
                          _selectedCategorie.id == 6) {
                        _selectedTypeTiers = Statics.tiersItems[0];
                      } else if (_selectedCategorie.id == 3 ||
                          _selectedCategorie.id == 7) {
                        _selectedTypeTiers = Statics.tiersItems[2];
                      }
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Visibility(
            visible: (_selectedCategorie.id == 2 ||
                _selectedCategorie.id == 3 ||
                _selectedCategorie.id == 6 ||
                _selectedCategorie.id == 7),
            child: Center(
                child: _selectedPieces.isNotEmpty
                    ? Container(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          children: [
                            SizedBox(height: 5),
                            new ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: _selectedPieces.length,
                                itemBuilder: (BuildContext ctxt, int index) {
                                  return PieceListItem(
                                    piece: _selectedPieces[index],
                                    fromTresory: true,
                                  );
                                })
                          ],
                        ))
                    : Card(
                        color: Theme.of(context).backgroundColor,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                              color: Theme.of(context).backgroundColor,
                              borderRadius: BorderRadius.circular(5)),
                          child: ListTile(
                              title: Text(
                                S.current.msg_credit_total,
                                style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green)),
                              ),
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue,
                                radius: 25,
                                child: CircleAvatar(
                                  radius: 22,
                                  backgroundColor: Colors.white,
                                  child: Text(
                                    "TR",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              )),
                        ),
                      )),
          ),
          SizedBox(
            height: 5,
          ),
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Wrap(
                spacing: 13,
                runSpacing: 13,
                children: [
                  Visibility(
                    visible: _showTierController,
                    child: TextFormField(
                      readOnly: true,
                      enabled: editMode,
                      controller: _clientControl,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty &&
                            (_selectedCategorie.id == 2 ||
                                _selectedCategorie.id == 3 ||
                                _selectedCategorie.id == 6 ||
                                _selectedCategorie.id == 7)) {
                          return S.current.msg_select_tier;
                        }
                        return null;
                      },
                      onTap: editMode && !modification
                          ? () {
                              chooseClientDialog();
                            }
                          : null,
                      decoration: InputDecoration(
                        labelText: S.current.select_tier,
                        labelStyle: GoogleFonts.lato(
                            textStyle:
                                TextStyle(color: Theme.of(context).hintColor)),
                        prefixIcon: Icon(
                          Icons.people,
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
                  Visibility(
                    visible: (_selectedCategorie.id == 5),
                    child: ListDropDown(
                      editMode: editMode,
                      value: _selectedCharge,
                      items: _chargeDropdownItems,
                      libelle: _selectedCharge.libelle,
                      onChanged: (value) {
                        setState(() {
                          _selectedCharge = value;
                        });
                      },
                      onAddPressed: () async {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.NO_HEADER,
                          animType: AnimType.BOTTOMSLIDE,
                          title: S.current.supp,
                          body: addCharge(),
                        )..show().then((value) => setState(() {}));
                      },
                    ),
                  ),
                  TextFormField(
                    enabled: editMode,
                    controller: _objetControl,
                    onTap: () => _objetControl.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: _objetControl.value.text.length),
                    keyboardType: TextInputType.text,
                    // validator: (value) {
                    //   if (value.isEmpty) {
                    //     return S.current.msg_champ_oblg;
                    //   }
                    //   return null;
                    // },
                    decoration: InputDecoration(
                      labelText: S.current.objet,
                      labelStyle: GoogleFonts.lato(
                          textStyle:
                              TextStyle(color: Theme.of(context).hintColor)),
                      prefixIcon: Icon(
                        Icons.subject,
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
                  Container(
                    padding: EdgeInsetsDirectional.fromSTEB(10, 3, 10, 3),
                    decoration: editMode
                        ? new BoxDecoration(
                            border: Border.all(
                              color: Colors.blueAccent,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          )
                        : null,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          MdiIcons.creditCardSettingsOutline,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 13),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                                disabledHint: Text(_selectedmodalite),
                                value: _selectedmodalite,
                                items: _modaliteDropdownItems,
                                onChanged: editMode
                                    ? (value) {
                                        setState(() {
                                          _selectedmodalite = value;
                                        });
                                      }
                                    : null),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible:
                        (Statics.modaliteList.indexOf(_selectedmodalite) == 1),
                    child: TextFormField(
                      enabled: editMode,
                      controller: _numchequeControl,
                      onTap: () => _numchequeControl.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: _montantControl.value.text.length),
                      keyboardType: TextInputType.text,
                      // validator: (value) {
                      //   if (value.isEmpty) {
                      //     return S.current.msg_champ_oblg;
                      //   }
                      //   return null;
                      // },
                      decoration: InputDecoration(
                        labelText: S.current.num_cheque,
                        labelStyle: GoogleFonts.lato(
                            textStyle:
                                TextStyle(color: Theme.of(context).hintColor)),
                        prefixIcon: Icon(
                          MdiIcons.idCard,
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
                  ListDropDown(
                    editMode: editMode,
                    value: _selectedCompte,
                    items: _compteDropdownItems,
                    libelle: (_selectedCompte.nomCompte),
                    leftIcon: MdiIcons.cashRegister,
                    onChanged: (value) {
                      setState(() {
                        _selectedCompte = value;
                      });
                    },
                    onAddPressed: () async {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.NO_HEADER,
                        animType: AnimType.BOTTOMSLIDE,
                        title: S.current.supp,
                        body: addCompte(),
                      )..show().then((value) => setState(() {}));
                    },
                  ),
                  TextFormField(
                    enabled: editMode,
                    controller: _montantControl,
                    onTap: () => _montantControl.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: _montantControl.value.text.length),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (!value.isNumericUsingRegularExpression) {
                        return S.current.msg_val_valide;
                      }
                      if (value.isNotEmpty && double.parse(value) <= 0) {
                        return S.current.msg_prix_supp_zero;
                      }
                      if (value.isEmpty) {
                        return S.current.msg_champ_oblg;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: S.current.montant,
                      labelStyle: GoogleFonts.lato(
                          textStyle:
                              TextStyle(color: Theme.of(context).hintColor)),
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
                ],
              ),
            ),
          )
        ]));
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
              _tresorie.tierRS = _selectedClient.raisonSociale;
              _clientControl.text = _selectedClient.raisonSociale;
              _selectedPieces.clear();
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
      peaceType: (_selectedCategorie.id == 2 || _selectedCategorie.id == 3)
          ? "TR"
          : "TRRemb",
      onConfirmSelectedItem: (selectedItem) {
        setState(() {
          _selectedPieces.clear();
          _selectedPieces.add(selectedItem);
          print(_selectedPieces.first);
          _restepiece = _selectedPieces.first.reste;
          _objetControl.text = '';
          _objetControl.text = _selectedCategorie.libelle +
              " ${selectedItem.piece} ${selectedItem.num_piece}";
        });
        setState(() {});
      },
    );
  }

  //***************************************************************************************************************************************************************************
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
    return showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
      builder: (BuildContext context, Widget child) {
        return child;
      },
    );
  }

  //*************************************************************************************************************************************************************************
  //************************************************************************************************************************************

  Widget addCompte() {
    TextEditingController _libelleCompteControl = new TextEditingController();
    TextEditingController _numCompteControl = new TextEditingController();
    TextEditingController _soldeCompteControl = new TextEditingController();
    CompteTresorie _compteTresorie = new CompteTresorie.init();
    ScrollController _controller = new ScrollController();
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
                      "${S.current.ajouter} ${S.current.compte}",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                          textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 5, right: 5, bottom: 20, top: 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextFormField(
                              controller: _libelleCompteControl,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return S.current.msg_champ_oblg;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.text_snippet,
                                  color: Colors.blue,
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(5)),
                                contentPadding: EdgeInsets.only(left: 10),
                                labelText: S.current.compte_designation,
                                labelStyle: GoogleFonts.lato(),
                                enabledBorder: OutlineInputBorder(
                                  gapPadding: 3.3,
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _numCompteControl,
                              keyboardType: TextInputType.text,
                              // validator: (value) {
                              //   if (value.isEmpty) {
                              //     return S.current.msg_champ_oblg;
                              //   }
                              //   return null;
                              // },
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.confirmation_number_outlined,
                                  color: Colors.blue,
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(5)),
                                contentPadding: EdgeInsets.only(left: 10),
                                labelText: S.current.n,
                                labelStyle: GoogleFonts.lato(),
                                enabledBorder: OutlineInputBorder(
                                  gapPadding: 3.3,
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _soldeCompteControl,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (!value.isNumericUsingRegularExpression) {
                                  return S.current.msg_val_valide;
                                }
                                if (value.isNotEmpty &&
                                    double.parse(value) < 0) {
                                  return S.current.msg_prix_supp_zero;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.monetization_on,
                                  color: Colors.blue,
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(5)),
                                contentPadding: EdgeInsets.only(left: 10),
                                labelText: S.current.solde_depart,
                                labelStyle: GoogleFonts.lato(),
                                enabledBorder: OutlineInputBorder(
                                  gapPadding: 3.3,
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
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
                                        _compteTresorie.numCompte =
                                            _numCompteControl.text.trim();
                                        _numCompteControl.text = "";
                                        _compteTresorie.nomCompte =
                                            _libelleCompteControl.text.trim();
                                        _libelleCompteControl.text = "";
                                        _compteTresorie.codeCompte = "";
                                        _compteTresorie.soldeDepart =
                                            (_soldeCompteControl.text.trim() !=
                                                    '')
                                                ? double.parse(
                                                    _soldeCompteControl.text
                                                        .trim())
                                                : 0.0;
                                        _soldeCompteControl.text = "";
                                        _compteTresorie.solde = 0.0;
                                      });
                                      await addCompteIfNotExist(
                                          _compteTresorie);
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
                    ),
                  ],
                ),
              ));
    });
  }

  Future<void> addCompteIfNotExist(CompteTresorie item) async {
    int compteIndex = _compteItems.indexOf(item);
    if (compteIndex > -1) {
      _selectedCompte = _compteItems[compteIndex];
    } else {
      int id =
          await _queryCtr.addItemToTable(DbTablesNames.compteTresorie, item);
      item.id = id;

      _compteItems.add(item);
      _compteDropdownItems =
          utils.buildDropCompteTresorieDownMenuItems(_compteItems);
      _selectedCompte = _compteItems[_compteItems.length - 1];
    }
  }

  Widget addCharge() {
    TextEditingController _libelleChargeControl = new TextEditingController();
    var _formKey = GlobalKey<FormState>();
    ChargeTresorie _chargeTresorie = new ChargeTresorie.init();
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Builder(
        builder: (context) => SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${S.current.ajouter} ${S.current.charge}",
                  style: GoogleFonts.lato(
                      textStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: 5, right: 5, bottom: 20, top: 20),
                  child: TextFormField(
                    controller: _libelleChargeControl,
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
                        borderRadius: BorderRadius.circular(5),
                      ),
                      contentPadding: EdgeInsets.only(left: 10),
                      labelText: S.current.categorie,
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
                            _chargeTresorie.libelle =
                                _libelleChargeControl.text.trim();
                            _libelleChargeControl.text = "";
                          });
                          await addChargeIfNotExist(_chargeTresorie);
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        "+ ${S.current.ajouter}",
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      ),
                      color: Colors.green,
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

  Future<void> addChargeIfNotExist(ChargeTresorie item) async {
    int chargeIndex = _chargeItems.indexOf(item);
    if (chargeIndex > -1) {
      _selectedCharge = _chargeItems[chargeIndex];
    } else {
      int id =
          await _queryCtr.addItemToTable(DbTablesNames.chargeTresorie, item);
      item.id = id;
      _chargeItems.add(item);
      _chargeDropdownItems =
          utils.buildDropChargeTresorieDownMenuItems(_chargeItems);
      _selectedCharge = _chargeItems[_chargeItems.length - 1];
    }
  }

  //*******************************************************************************************************************************************************************************
  //*************************************************************************** partie de save ***********************************************************************************

  Future<int> addItemToDb() async {
    int id = -1;
    String message;
    try {
      if (widget.arguments.id != null) {
        //update tresorie
        Tresorie tresorie = await makeItem();
        if (tresorie != null) {
          id = await _queryCtr.updateItemInDb(DbTablesNames.tresorie, tresorie);
          if (tresorie.categorie == 2 || tresorie.categorie == 3) {
            await _queryCtr.removeItemWithForeignKey(
                DbTablesNames.reglementTresorie, tresorie.id, 'Tresorie_id');
            bool _haspiece = true;
            double verssementSolde = 0;
            if (tresorie.pieceId == null) {
              _haspiece = false;
              _selectedPieces =
                  await _queryCtr.getAllPiecesByTierId(_selectedClient.id);

              double _montant =
                  double.parse((tresorie.montant).toStringAsFixed(2));
              while (_montant > 0) {
                // recuperer la some des verssement pour le solde
                verssementSolde =
                    await _queryCtr.getVerssementSolde(_selectedClient);
                if ((_selectedClient.solde_depart - verssementSolde) > 0 &&
                    _haspiece == false) {
                  ReglementTresorie item = new ReglementTresorie.init();
                  item.piece_id = 0;
                  item.tresorie_id = tresorie.id;
                  if (_montant <=
                      (_selectedClient.solde_depart - verssementSolde)) {
                    item.regler = _montant;
                    _montant = 0;
                  } else {
                    item.regler =
                        (_selectedClient.solde_depart - verssementSolde);
                    _montant = _montant -
                        (_selectedClient.solde_depart - verssementSolde);
                  }
                  await _queryCtr.addItemToTable(
                      DbTablesNames.reglementTresorie, item);
                } else {
                  // le solde de depart est regl??
                  if(_selectedPieces.isNotEmpty){
                    _selectedPieces.forEach((piece) async {
                      ReglementTresorie item = new ReglementTresorie.init();
                      item.piece_id = piece.id;
                      item.tresorie_id = widget.arguments.id;

                      if (_montant >= piece.reste) {
                        item.regler = piece.reste;
                        _montant = _montant - piece.reste;
                      } else if (_montant != 0) {
                        item.regler = _montant;
                        _montant = 0;
                      } else {
                        return;
                      }
                      await _queryCtr.addItemToTable(
                          DbTablesNames.reglementTresorie, item);
                    });
                  }else{
                    _montant = 0 ;
                  }

                }
              }
              if (_haspiece == false) {
                setState(() {
                  _selectedPieces = new List<Piece>();
                });
              }
            } else {
              // m??j montant verss d'une piece
              double _montant =
                  double.parse((tresorie.montant).toStringAsFixed(2));
              _selectedPieces.forEach((piece) async {
                ReglementTresorie item = new ReglementTresorie.init();
                item.piece_id = piece.id;
                item.tresorie_id = widget.arguments.id;
                item.regler = _montant;
                await _queryCtr.addItemToTable(
                    DbTablesNames.reglementTresorie, item);
              });
            }
          } else if (_selectedCategorie.id == 6 || _selectedCategorie.id == 7) {
            await _queryCtr.removeItemWithForeignKey(
                DbTablesNames.reglementTresorie, tresorie.id, 'Tresorie_id');
            double _montant =
                double.parse((tresorie.montant).toStringAsFixed(2));
            _selectedPieces.forEach((piece) async {
              ReglementTresorie item = new ReglementTresorie.init();
              item.piece_id = piece.id;
              item.tresorie_id = widget.arguments.id;
              item.regler = _montant;
              await _queryCtr.addItemToTable(
                  DbTablesNames.reglementTresorie, item);
            });
          }

          if (id > -1) {
            widget.arguments = tresorie;
            widget.arguments.id = id;
            message = S.current.msg_update_item;
          } else {
            message = S.current.msg_update_err;
          }
        } else {
          var message = S.current.msg_num_existe;
          Helpers.showToast(message);
          return Future.value(id);
        }
      }
      //add new tresories
      else {
        // add new tresorie
        Tresorie tresorie = await makeItem();
        if (tresorie != null) {
          id = await _queryCtr.addItemToTable(DbTablesNames.tresorie, tresorie);
          if (id > -1) {
            tresorie.id = id;
          }
          if (tresorie.categorie == 2 || tresorie.categorie == 3) {
            bool _haspiece = true;
            double verssementSolde = 0;
            if (tresorie.pieceId == null) {
              _haspiece = false;
              _selectedPieces =
                  await _queryCtr.getAllPiecesByTierId(_selectedClient.id);
            }
            double _montant =
                double.parse((tresorie.montant).toStringAsFixed(2));
            while (_montant > 0) {
              // recuperer la some des verssement pour le solde
              verssementSolde =
                  await _queryCtr.getVerssementSolde(_selectedClient);
              if ((_selectedClient.solde_depart - verssementSolde) > 0 &&
                  !_haspiece) {
                ReglementTresorie item = new ReglementTresorie.init();
                item.piece_id = 0;
                item.tresorie_id = tresorie.id;
                if (_montant <=
                    (_selectedClient.solde_depart - verssementSolde)) {
                  item.regler = _montant;
                  _montant = 0;
                } else {
                  item.regler =
                      (_selectedClient.solde_depart - verssementSolde);
                  _montant = _montant - item.regler;
                }
                await _queryCtr.addItemToTable(
                    DbTablesNames.reglementTresorie, item);
              } else {
                // le solde de depart est regl??
                if(_selectedPieces.isNotEmpty){
                  _selectedPieces.forEach((piece) async {
                    ReglementTresorie item = new ReglementTresorie.init();
                    item.piece_id = piece.id;
                    item.tresorie_id = tresorie.id;

                    if (_montant >= piece.reste) {
                      item.regler = piece.reste;
                      _montant = _montant - piece.reste;
                    } else if (_montant != 0) {
                      item.regler = _montant;
                      _montant = 0;
                    } else {
                      return;
                    }
                    await _queryCtr.addItemToTable(
                        DbTablesNames.reglementTresorie, item);
                  });
                }else{
                  _montant = 0 ;
                }
              }
            }
            if (_haspiece == false) {
              setState(() {
                _selectedPieces = new List<Piece>();
              });
            }
          } else if (tresorie.categorie == 6 || tresorie.categorie == 7) {
            double _montant =
                double.parse((tresorie.montant).toStringAsFixed(2)) * -1;
            _selectedPieces.forEach((piece) async {
              ReglementTresorie item = new ReglementTresorie.init();
              item.piece_id = piece.id;
              item.tresorie_id = tresorie.id;

              if (_montant >= _restepiece) {
                item.regler = _restepiece;
                _montant = _montant - _restepiece;
              } else if (_montant != 0) {
                item.regler = _montant;
                _montant = 0;
              } else {
                return;
              }

              item.regler = item.regler * -1;
              await _queryCtr.addItemToTable(
                  DbTablesNames.reglementTresorie, item);
            });
          }
          if (id > -1) {
            widget.arguments = tresorie;
            widget.arguments.id = id;
            message = S.current.msg_ajout_item;
          } else {
            message = S.current.msg_ajout_err;
          }
        } else {
          var message = S.current.msg_num_existe;
          Helpers.showToast(message);
          return Future.value(id);
        }
      }
      if (!modification && editMode) {
        Navigator.pop(context);
      }
      Helpers.showToast(message);
      return Future.value(id);
    } catch (error) {
      Helpers.showToast(S.current.msg_ereure);
      return Future.value(-1);
    }
  }

  Future<Object> makeItem() async {
    var tiers = _selectedClient;
    var _old_num_tresorie = _tresorie.numTresorie;
    if (tiers != null) {
      _tresorie.tierId = tiers.id;
      _tresorie.tierRS = tiers.raisonSociale;
    }
    _tresorie.numTresorie = _numeroControl.text.trim();
    _tresorie.categorie = _selectedCategorie.id;
    _tresorie.compte = _selectedCompte.id;

    if (modification) {
      _tresorie.mov = _tresorie.mov;
    } else {
      // mov de tresorie tjr 1 on new tresorie
      _tresorie.mov = 1;
    }
    _tresorie.objet = _objetControl.text.trim();
    _tresorie.modalite = Statics.modaliteList.indexOf(_selectedmodalite);
    _tresorie.numCheque = (Statics.modaliteList.indexOf(_selectedmodalite) == 1)
        ? _numchequeControl.text.trim()
        : '';
    _tresorie.montant = double.parse(_montantControl.text.trim());
    _tresorie.montant = double.parse((_tresorie.montant).toStringAsFixed(2));

    if (_selectedCategorie.id == 6 || _selectedCategorie.id == 7) {
      _tresorie.montant =
          double.parse((_tresorie.montant * -1).toStringAsFixed(2));
    }
    if (_selectedCategorie.id == 5) {
      _tresorie.charge = _selectedCharge.id;
    }
    if (_selectedPieces.isNotEmpty) {
      _tresorie.pieceId = _selectedPieces.first.id;
    }

    if (!modification) {
      var res = await _queryCtr.getTresorieByNum(_tresorie.numTresorie);
      if (res.isNotEmpty) {
        await getNumPiece();
        return null;
      }
    } else {
      if (_tresorie.numTresorie != _old_num_tresorie) {
        var res = await _queryCtr.getTresorieByNum(_tresorie.numTresorie);
        if (res.isNotEmpty) {
          _tresorie.numTresorie = _old_num_tresorie;
          await getNumPiece();
          return null;
        }
      }
    }

    return _tresorie;
  }
}
