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
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/Article.dart';
import 'package:gestmob/models/ChargeTresorie.dart';
import 'package:gestmob/models/CompteTresorie.dart';
import 'package:gestmob/models/FormatPiece.dart';
import 'package:gestmob/models/Piece.dart';
import 'package:gestmob/models/ReglementTresorie.dart';
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
import 'package:gestmob/services/push_notifications.dart';

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
  TextEditingController _modaliteControl =
      new TextEditingController(text: S.current.espece);
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
  String _devise ;

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
    _devise = getDeviseTranslate(data.myParams.devise) ;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> futureInitState() async {
    _tiersDropdownItems = utils.buildDropTypeTier(Statics.tiersItems);
    _selectedTypeTiers = Statics.tiersItems[0];

    _categorieItems = await _queryCtr.getAllTresorieCategorie();

    _categorieItems[0].libelle = S.current.choisir;
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

    _compteItems = await _queryCtr.getAllCompteTresorie();
    _compteDropdownItems =
        utils.buildDropCompteTresorieDownMenuItems(_compteItems);
    _selectedCompte = _compteItems[0];

    _chargeItems = await _queryCtr.getAllChargeTresorie();
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
      _modaliteControl.text = _tresorie.modalite;
      _montantControl.text = (_tresorie.montant < 0)
          ? Helpers.numberFormat((_tresorie.montant * -1)).toString()
          : Helpers.numberFormat(_tresorie.montant).toString();
    } else {
      _selectedTypeTiers = Statics.tiersItems[0];
      _selectedCategorie = _categorieItems[1];
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

  String getDeviseTranslate(devise){
    switch(devise){
      case "DZD" :
        return S.current.da ;
        break;
      default :
        return devise ;
        break ;
    }
  }

  //****************************************************************************************************************************************************************
  //***********************************************************************build de l'affichage***************************************************************************
  @override
  Widget build(BuildContext context) {
    if (modification) {
      if (editMode) {
        appBarTitle = S.current.modification_titre;
      } else {
        appBarTitle = S.current.verssement;
      }
    } else {
      if (editMode) {
        appBarTitle = "${S.current.ajouter} ${S.current.verssement}";
      } else {
        appBarTitle = S.current.verssement;
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
                          RoutesKeys.addTresorie,
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
              if (_formKey.currentState.validate()){
                int id = await addItemToDb();
                if (id > -1) {
                  setState(() {
                    modification = true;
                    editMode = false;
                  });
                }
              }else{
                Helpers.showFlushBar(context, "${S.current.msg_champs_obg}");
              }

            },
          ),
          // extendBody: true,
          bottomNavigationBar: BottomExpandableAppBar(
            controller: bottomBarControler,
            horizontalMargin: 10,
            shape: AutomaticNotchedShape(
                RoundedRectangleBorder(), StadiumBorder(side: BorderSide())),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(
                                    Icons.person_sharp,
                                    color:
                                    (editMode) ? Colors.blue : Theme.of(context).primaryColorDark,
                                    size: 18,
                                  ),
                                  Text(
                                    "(${_devise})",
                                    style: TextStyle(
                                        fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(height: 2,),
                              Text(
                                  '${Helpers.numberFormat(_selectedClient.credit).toString()}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(Icons.attach_money,
                                    size: 20,
                                    color: Theme.of(context).primaryColorDark),
                                Text(
                                  "(${_devise})",
                                  style: TextStyle(
                                      fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Text(
                              "${Helpers.numberFormat(_restepiece).toString()}",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            elevation: 2,
            backgroundColor:
                (editMode && !modification) ? Colors.blue : Colors.grey,
            foregroundColor: Colors.white,
            onPressed: () async {
              if (editMode && !modification) {
                if (_selectedClient != null) {
                  await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return choosePieceDialog();
                      });
                } else {
                  var message = S.current.msg_select_tier;
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
        child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
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
                            labelText: "${S.current.n}",
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
                          if (_selectedCategorie.id == 2 ||
                              _selectedCategorie.id == 3 ||
                              _selectedCategorie.id == 6 ||
                              _selectedCategorie.id == 7) {
                            _showTierController = true;
                          } else {
                            _showTierController = false;
                          }
                          _objetControl.text = _selectedCategorie.libelle;

                          if (_selectedCategorie.id == 2 ||
                              _selectedCategorie.id == 6) {
                            _selectedTypeTiers = Statics.tiersItems[0];
                          } else {
                            _selectedTypeTiers = Statics.tiersItems[2];
                          }
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
                ],
              ),
              SizedBox(height: 15),
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
                                      );
                                    })
                              ],
                            ))
                        : Container(
                            margin:
                                EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                            padding:
                                EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            decoration: BoxDecoration(
                                color: Colors.green[300],
                                borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              title: Text(
                                S.current.msg_credit_total,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              leading: Container(
                                child: Center(
                                  child: Text("TR",style: TextStyle(color: Colors.black),),
                                ),
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
                          )),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                child: Form(
                  key : _formKey,
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
                            if (value.isEmpty && (_selectedCategorie.id == 2 ||
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
                            labelStyle: TextStyle(color: Colors.blue),
                            prefixIcon: Icon(
                              Icons.people,
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
                            errorBorder:  OutlineInputBorder(
                              gapPadding: 3.3,
                              borderRadius: BorderRadius.circular(20),
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
                            await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return addCharge();
                                }).then((val) {
                              setState(() {});
                            });
                          },
                        ),
                      ),
                      TextFormField(
                        enabled: editMode,
                        controller: _objetControl,
                        onTap: () => _objetControl.selection = TextSelection(baseOffset: 0, extentOffset: _objetControl.value.text.length),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value.isEmpty) {
                            return S.current.msg_champ_oblg;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: S.current.objet,
                          labelStyle: TextStyle(color: Colors.blue),
                          prefixIcon: Icon(
                            Icons.subject,
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
                          errorBorder:  OutlineInputBorder(
                            gapPadding: 3.3,
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                      TextFormField(
                        enabled: editMode,
                        controller: _modaliteControl,
                        onTap: () => _modaliteControl.selection = TextSelection(baseOffset: 0, extentOffset: _modaliteControl.value.text.length),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value.isEmpty) {
                            return S.current.msg_champ_oblg;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: S.current.modalite,
                          labelStyle: TextStyle(color: Colors.blue),
                          prefixIcon: Icon(
                            MdiIcons.creditCardSettingsOutline,
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
                          errorBorder:  OutlineInputBorder(
                            gapPadding: 3.3,
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                      ListDropDown(
                        editMode: editMode,
                        value: _selectedCompte,
                        items: _compteDropdownItems,
                        libelle: (_selectedCompte.nomCompte),
                        onChanged: (value) {
                          setState(() {
                            _selectedCompte = value;
                          });
                        },
                        onAddPressed: () async {
                          await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return addCompte();
                              }).then((val) {
                            setState(() {});
                          });
                        },
                      ),
                      TextFormField(
                        enabled: editMode,
                        controller: _montantControl,
                        onTap: () => _montantControl.selection = TextSelection(baseOffset: 0, extentOffset: _montantControl.value.text.length),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value.isEmpty) {
                            return S.current.msg_champ_oblg;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: S.current.montant,
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
                          errorBorder:  OutlineInputBorder(
                            gapPadding: 3.3,
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
        ]
        )
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
              _tresorie.tierRS = _selectedClient.raisonSociale;
              _clientControl.text = _selectedClient.raisonSociale;
              _montantControl.text = Helpers.numberFormat(_selectedClient.credit).toString();
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
          _restepiece = _selectedPieces.first.reste;
          _montantControl.text = Helpers.numberFormat(_restepiece).toString();
          _objetControl.text = _objetControl.text +
              " ${selectedItem.piece} ${selectedItem.num_piece}";
        });
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

  //*************************************************************************************************************************************************************************
  //************************************************************************************************************************************

  Widget addTresoreCategorie() {
    TextEditingController _libelleCategorieControl =
        new TextEditingController();
    TresorieCategories _categorieTresorie = new TresorieCategories.init();
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Builder(
          builder: (context) => Dialog(
                //this right here
                child: SingleChildScrollView(
                  child: Container(
                    height: 250,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 5, right: 5, bottom: 20, top: 20),
                            child: Text(
                              "${S.current.ajouter} ${S.current.categorie}:",
                              style: TextStyle(
                                  fontSize: 20, color: Colors.redAccent),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 5, right: 5, bottom: 20, top: 20),
                            child: TextField(
                              controller: _libelleCategorieControl,
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
                                labelText: S.current.categorie,
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
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                onPressed: () async {
                                  setState(() {
                                    _categorieTresorie.libelle =
                                        _libelleCategorieControl.text;
                                    _libelleCategorieControl.text = "";
                                  });
                                  await addTresoreCategorieIfNotExist(
                                      _categorieTresorie);
                                  Navigator.pop(context);
                                  print(_categorieTresorie.libelle);
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
              ));
    });
  }

  Future<void> addTresoreCategorieIfNotExist(TresorieCategories item) async {
    int categorieIndex = _categorieItems.indexOf(item);
    if (categorieIndex > -1) {
      _selectedCategorie = _categorieItems[categorieIndex];
    } else {
      int id =
          await _queryCtr.addItemToTable(DbTablesNames.categorieTresorie, item);
      item.id = id;

      _categorieItems.add(item);
      _categorieDropdownItems =
          utils.buildDropTresorieCategoriesDownMenuItems(_categorieItems);
      _selectedCategorie = _categorieItems[_categorieItems.length - 1];
    }
  }

  Widget addCompte() {
    TextEditingController _libelleCompteControl = new TextEditingController();
    TextEditingController _numCompteControl = new TextEditingController();
    TextEditingController _codeCompteControl = new TextEditingController();
    TextEditingController _soldeCompteControl = new TextEditingController();
    CompteTresorie _compteTresorie = new CompteTresorie.init();
    ScrollController _controller = new ScrollController();
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Builder(
          builder: (context) => Dialog(
                //this right here
                child: SingleChildScrollView(
                  child: Container(
                    height: 350,
                    child: Scrollbar(
                      isAlwaysShown: true,
                      controller: _controller,
                      child: ListView(
                        controller: _controller,
                        padding: EdgeInsets.all(15),
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 5, right: 5, bottom: 20, top: 10),
                            child: Text(
                              "${S.current.ajouter} ${S.current.compte}:",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          TextField(
                            controller: _numCompteControl,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.view_agenda,
                                color: Colors.blue,
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(20)),
                              contentPadding: EdgeInsets.only(left: 10),
                              labelText: "N°:",
                              enabledBorder: OutlineInputBorder(
                                gapPadding: 3.3,
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextField(
                            controller: _libelleCompteControl,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.description,
                                color: Colors.blue,
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(20)),
                              contentPadding: EdgeInsets.only(left: 10),
                              labelText: S.current.designation,
                              enabledBorder: OutlineInputBorder(
                                gapPadding: 3.3,
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: _codeCompteControl,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.vpn_key,
                                color: Colors.blue,
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(20)),
                              contentPadding: EdgeInsets.only(left: 10),
                              labelText: S.current.code_pin,
                              enabledBorder: OutlineInputBorder(
                                gapPadding: 3.3,
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: _soldeCompteControl,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.monetization_on,
                                color: Colors.blue,
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(20)),
                              contentPadding: EdgeInsets.only(left: 10),
                              labelText: S.current.solde_depart,
                              enabledBorder: OutlineInputBorder(
                                gapPadding: 3.3,
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
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
                                  setState(() {
                                    _compteTresorie.numCompte =
                                        _numCompteControl.text;
                                    _numCompteControl.text = "";
                                    _compteTresorie.nomCompte =
                                        _libelleCompteControl.text;
                                    _libelleCompteControl.text = "";
                                    _compteTresorie.codeCompte =
                                        _codeCompteControl.text;
                                    _codeCompteControl.text = "";
                                    _compteTresorie.soldeDepart =
                                        double.parse(_soldeCompteControl.text);
                                    _soldeCompteControl.text = "";
                                    _compteTresorie.solde = 0.0;
                                  });
                                  await addCompteIfNotExist(_compteTresorie);
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  S.current.ajouter,
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: Colors.green,
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
    ChargeTresorie _chargeTresorie = new ChargeTresorie.init();
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Builder(
          builder: (context) => Dialog(
                child: SingleChildScrollView(
                  child: Container(
                    height: 250,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 8, right: 8, bottom: 10, top: 10),
                            child: Text(
                              "${S.current.ajouter} ${S.current.charge}:",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 5, right: 5, bottom: 20, top: 20),
                            child: TextField(
                              controller: _libelleChargeControl,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.view_agenda,
                                  color: Colors.green,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                contentPadding: EdgeInsets.only(left: 10),
                                labelText: S.current.categorie,
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
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                onPressed: () async {
                                  setState(() {
                                    _chargeTresorie.libelle =
                                        _libelleChargeControl.text;
                                    _libelleChargeControl.text = "";
                                  });
                                  await addChargeIfNotExist(_chargeTresorie);
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  S.current.ajouter,
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: Colors.green,
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
        id = await _queryCtr.updateItemInDb(DbTablesNames.tresorie, tresorie);
        if (tresorie.categorie == 2 || tresorie.categorie == 3) {
          bool _haspiece = true;
          double verssementSolde = 0;
          if (tresorie.pieceId == null) {
            _haspiece = false;
            _selectedPieces =
                await _queryCtr.getAllPiecesByTierId(_selectedClient.id);
          } else {
            var piece = await _queryCtr.getPieceById(_selectedClient.id);
            _selectedPieces = new List<Piece>();
            _selectedPieces.add(piece);
          }
          double _montant = tresorie.montant;
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
                item.regler = (_selectedClient.solde_depart - verssementSolde);
                _montant =
                    _montant - (_selectedClient.solde_depart - verssementSolde);
              }
              await _queryCtr.addItemToTable(
                  DbTablesNames.reglementTresorie, item);
            } else {
              // le solde de depart est reglé
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
            }
          }
          if (_haspiece == false) {
            setState(() {
              _selectedPieces = new List<Piece>();
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
          message = S.current.msg_update_item;
        } else {
          message = S.current.msg_update_err;
        }
      } else {
        // add new tresorie
        Tresorie tresorie = await makeItem();
        id = await _queryCtr.addItemToTable(DbTablesNames.tresorie, tresorie);
        if (id > -1) {
          tresorie.id = await _queryCtr.getLastId(DbTablesNames.tresorie);
        }
        if (tresorie.categorie == 2 || tresorie.categorie == 3) {
          bool _haspiece = true;
          double verssementSolde = 0;
          if (tresorie.pieceId == null) {
            _haspiece = false;
            _selectedPieces =
                await _queryCtr.getAllPiecesByTierId(_selectedClient.id);
          }
          double _montant = tresorie.montant;
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
                item.regler = (_selectedClient.solde_depart - verssementSolde);
                _montant = _montant - item.regler;
              }
              await _queryCtr.addItemToTable(
                  DbTablesNames.reglementTresorie, item);
            } else {
              // le solde de depart est reglé
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
            }
          }
          if (_haspiece == false) {
            setState(() {
              _selectedPieces = new List<Piece>();
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
          message = S.current.msg_ajout_item;
        } else {
          message = S.current.msg_ajout_err;
        }
      }
      Helpers.showFlushBar(context, message);
      return Future.value(id);
    } catch (error) {
      Helpers.showFlushBar(context, S.current.msg_ereure);
      return Future.value(-1);
    }
  }

  Future<Object> makeItem() async {
    var tiers = _selectedClient;
    if (tiers != null) {
      _tresorie.tierId = tiers.id;
      _tresorie.tierRS = tiers.raisonSociale;
    }
    _tresorie.numTresorie = _numeroControl.text;
    _tresorie.categorie = _selectedCategorie.id;
    _tresorie.compte = _selectedCompte.id;

    if (modification) {
      _tresorie.mov = _tresorie.mov;
    } else {
      // mov de tresorie tjr 1 on new tresorie
      _tresorie.mov = 1;
    }
    _tresorie.objet = _objetControl.text;
    _tresorie.modalite = _modaliteControl.text;
    _tresorie.montant = double.parse(_montantControl.text);
    if (_selectedCategorie.id == 6 || _selectedCategorie.id == 7) {
      _tresorie.montant = _tresorie.montant * -1;
    }
    if (_selectedCategorie.id == 5) {
      _tresorie.charge = _selectedCharge.id;
    }
    if (_selectedPieces.isNotEmpty) {
      _tresorie.pieceId = _selectedPieces.first.id;
    }

    var res = await _queryCtr.getTresorieByNum(_numeroControl.text);
    if (res.length >= 1 && !modification) {
      var message = S.current.msg_num_existe;
      Helpers.showFlushBar(context, message);
      await getNumPiece();
      _tresorie.numTresorie = _numeroControl.text;
    }

    return _tresorie;
  }
}
