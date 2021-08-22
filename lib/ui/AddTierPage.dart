import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/Widgets/CustomWidgets/add_save_bar.dart';
import 'package:gestmob/Widgets/CustomWidgets/bottom_tab_bar.dart';
import 'package:gestmob/Widgets/CustomWidgets/image_picker_widget.dart';
import 'package:gestmob/Widgets/CustomWidgets/list_dropdown.dart';
import 'package:gestmob/Widgets/utils.dart' as utils;
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/MyParams.dart';
import 'package:gestmob/models/Tiers.dart';
import 'package:gestmob/models/TiersFamille.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';
import 'package:gestmob/Helpers/string_cap_extension.dart';

class AddTierPage extends StatefulWidget {
  final QueryCtr _queryCtr = QueryCtr();

  var arguments;

  AddTierPage({Key key, @required this.arguments}) : super(key: key);

  @override
  _AddTierPageState createState() => _AddTierPageState();
}

class _AddTierPageState extends State<AddTierPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<OSMFlutterState> osmKey = GlobalKey<OSMFlutterState>();

  TabController _tabController;
  int _tabSelectedIndex = 0;

  bool editMode = true;
  bool modification = false;

  bool _stockable = true;

  int _clientFourn = 0;
  bool _clientFournBool = false;

  double _latitude = 36.2568015016388;
  double _longitude = 6.592226028442384;

  bool finishedLoading = false;

  String appBarTitle = "Tiers";

  List<DropdownMenuItem<String>> _statutDropdownItems;
  String _selectedStatut;

  List<int> _tarificationItems = Statics.tarificationItems;

  List<DropdownMenuItem<int>> _tarificationDropdownItems;
  int _selectedTarification;

  List<TiersFamille> _familleItems;
  List<DropdownMenuItem<Object>> _familleDropdownItems;
  TiersFamille _selectedFamille;

  TextEditingController _raisonSocialeControl = new TextEditingController();
  TextEditingController _qrCodeControl = new TextEditingController();
  TextEditingController _adresseControl = new TextEditingController();
  TextEditingController _libelleFamilleControl = new TextEditingController();
  TextEditingController _villeControl = new TextEditingController();
  TextEditingController _telephoneControl = new TextEditingController();
  TextEditingController _mobileControl = new TextEditingController();
  TextEditingController _faxControl = new TextEditingController();
  TextEditingController _emailControl = new TextEditingController();
  TextEditingController _rcControl = new TextEditingController();
  TextEditingController _aiControl = new TextEditingController();
  TextEditingController _nifControl = new TextEditingController();
  TextEditingController _nisControl = new TextEditingController();
  TextEditingController _solde_departControl = new TextEditingController();
  TextEditingController _chiffre_affairesControl = new TextEditingController();
  TextEditingController _reglerControl = new TextEditingController();
  TextEditingController _creditControl = new TextEditingController();
  bool _controlBloquer = false;

  var _famille = new TiersFamille.init();

  File _itemImage;

  QueryCtr _queryCtr = new QueryCtr();

  MyParams _myParams;

  GlobalKey globalKey = new GlobalKey();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    Statics.statutItems[0] = S.current.statut_m;
    Statics.statutItems[1] = S.current.statut_mlle;
    Statics.statutItems[2] = S.current.statut_mme;
    Statics.statutItems[3] = S.current.statut_dr;
    Statics.statutItems[4] = S.current.statut_pr;
    Statics.statutItems[5] = S.current.statut_eurl;
  }

  //**********************************************************************************************************************************************************************
  //**************************************************************************partie special init data************************************************************************
  void initState() {
    super.initState();

    futureInitState().then((val) {
      setState(() {
        finishedLoading = true;
      });
    });

    _tabController = TabController(length: 4, vsync: this);

    _tabController.addListener(() {
      setState(() {
        _tabSelectedIndex = _tabController.index;
      });
    });
  }

  Future<bool> futureInitState() async {
    _familleItems = await widget._queryCtr.getAllTierFamilles();
    _familleItems[0].libelle = S.current.no_famille;

    _familleDropdownItems = utils.buildDropFamilleTier(_familleItems);
    _statutDropdownItems = utils.buildDropStatutTier(Statics.statutItems);
    await buildTarification();
    _tarificationDropdownItems =
        utils.buildDropTarificationTier(_tarificationItems);

    _selectedStatut = Statics.statutItems[0];
    _selectedTarification = _tarificationItems[0];
    _selectedFamille = _familleItems[0];

    _clientFourn = widget.arguments.clientFour;

    if (widget.arguments.id != null && widget.arguments.id > -1) {
      editMode = false;
      modification = true;
      await setDataFromItem(widget.arguments);
    } else {
      editMode = true;
    }

    return Future<bool>.value(editMode);
  }

  Future<void> setDataFromItem(Tiers item) async {
    _raisonSocialeControl.text = item.raisonSociale;
    _qrCodeControl.text = (item.qrCode == null) ? '' : item.qrCode;
    _adresseControl.text = item.adresse;
    _clientFournBool = _clientFourn == 1;

    if (item.latitude != null && item.longitude != null) {
      _latitude = item.latitude;
      _longitude = item.longitude;
    }

    _itemImage = await Helpers.getFileFromUint8List(item.imageUint8List);
    _villeControl.text = item.ville;
    _telephoneControl.text = item.telephone;
    _mobileControl.text = item.mobile;
    _faxControl.text = item.fax;
    _emailControl.text = item.email;
    _rcControl.text = item.rc;
    _aiControl.text = item.ai;
    _nifControl.text = item.nif;
    _nisControl.text = item.nis;
    _solde_departControl.text = item.solde_depart.toStringAsFixed(2);
    _chiffre_affairesControl.text = item.chiffre_affaires.toStringAsFixed(2);
    _reglerControl.text = item.regler.toStringAsFixed(2);
    _creditControl.text = item.credit.toStringAsFixed(2);
    _selectedFamille =
        _familleItems.firstWhere((element) => element.id == item.id_famille);
    _selectedStatut = Statics.statutItems[item.statut];
    _selectedTarification = item.tarification;
    _controlBloquer = item.bloquer;
  }

  void buildTarification() async {
    _myParams = await _queryCtr.getAllParams();
    switch (_myParams.tarification) {
      case 1:
        _tarificationItems = _tarificationItems.sublist(0, 1);
        break;
      case 2:
        _tarificationItems = _tarificationItems.sublist(0, 2);
        break;
      case 3:
        _tarificationItems = _tarificationItems.sublist(0, 3);
        break;
      default:
        _tarificationItems = _tarificationItems.sublist(0, 3);
        break;
    }
  }

  //**********************************************************************************************************************************************************************
  //**************************************************************************partie special affichage************************************************************************
  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (modification) {
      if (editMode) {
        appBarTitle = S.current.modification_titre;
      } else {
        if (_clientFourn == 0) {
          appBarTitle = S.current.client_titre;
        } else if (_clientFourn == 1) {
          appBarTitle = S.current.client_four;
        } else {
          appBarTitle = S.current.fournisseur_titre;
        }
      }
    } else {
      if (editMode) {
        if (_clientFourn == 0) {
          appBarTitle = "${S.current.client_titre}";
        } else {
          appBarTitle = "${S.current.fournisseur_titre}";
        }
      } else {
        if (_clientFourn == 0) {
          appBarTitle = S.current.client_titre;
        } else if (_clientFourn == 1) {
          appBarTitle = S.current.client_four;
        } else {
          appBarTitle = S.current.fournisseur_titre;
        }
      }
    }

    if (!finishedLoading) {
      return Scaffold(body: Helpers.buildLoading());
    } else {
      return WillPopScope(
        onWillPop: _onWillPop,
        child: DefaultTabController(
          length: 4,
          child: Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              floatingActionButton: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(40, 10, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Visibility(
                      visible: _tabSelectedIndex == 2 && editMode,
                      child: FloatingActionButton(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                        onPressed: () async {
                          Helpers.showToast(S.current.msg_map_add_position);
                          GeoPoint geoPoint =
                              await osmKey.currentState.selectPosition();
                          if (geoPoint != null) {
                            osmKey.currentState.changeLocation(geoPoint);
                            setState(() {
                              _latitude = geoPoint.latitude;
                              _longitude = geoPoint.longitude;
                            });
                          }
                        },
                        child: Icon(
                          Icons.add_location_alt,
                          size: 28,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    (_tabSelectedIndex == 2 && !editMode)
                        ? FloatingActionButton(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blueAccent,
                            onPressed: () async {
                              Helpers.openMapsSheet(
                                  context, new Coords(_latitude, _longitude));
                            },
                            child: Icon(Icons.directions),
                          )
                        : (_tabSelectedIndex == 2 && editMode)
                            ? FloatingActionButton(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blueAccent,
                                onPressed: () async {
                                  await osmKey.currentState.currentLocation();
                                },
                                child: Icon(Icons.my_location),
                              )
                            : SizedBox(),
                  ],
                ),
              ),
              key: _scaffoldKey,
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
              bottomNavigationBar: BottomTabBar(
                selectedIndex: _tabSelectedIndex,
                controller: _tabController,
                tabs: [
                  Tab(
                      child: Column(
                    children: [
                      Icon(Icons.insert_drive_file),
                      SizedBox(height: 1),
                      Text(
                        S.current.fiche,
                        style: GoogleFonts.lato(),
                      ),
                    ],
                  )),
                  Tab(
                      child: Column(
                    children: [
                      Icon(Icons.image),
                      SizedBox(height: 1),
                      Text(
                        S.current.photo,
                        style: GoogleFonts.lato(),
                      ),
                    ],
                  )),
                  Tab(
                      child: Column(
                    children: [
                      Icon(Icons.map),
                      SizedBox(height: 1),
                      Text(
                        S.current.map,
                        style: GoogleFonts.lato(),
                      ),
                    ],
                  )),
                  Tab(
                      child: Column(
                    children: [
                      Icon(MdiIcons.qrcode),
                      SizedBox(height: 1),
                      Text(
                        S.current.qr_code,
                        style: GoogleFonts.lato(),
                      ),
                    ],
                  )),
                ],
              ),
              body: Builder(
                builder: (context) => TabBarView(
                  controller: _tabController,
                  physics: _tabSelectedIndex == 2
                      ? NeverScrollableScrollPhysics()
                      : ClampingScrollPhysics(),
                  children: [
                    fichetab(),
                    imageTab(),
                    mapTab(),
                    qrCodeTab(),
                  ],
                ),
              )),
        ),
      );
    }
  }

  Future<bool> _onWillPop() async {
    if (modification) {
      if (editMode) {
        AwesomeDialog(
            context: context,
            title: "",
            desc: "${S.current.msg_retour_no_save} ?",
            dialogType: DialogType.QUESTION,
            animType: AnimType.BOTTOMSLIDE,
            btnCancelText: S.current.non,
            btnCancelOnPress: () {},
            btnOkText: S.current.oui,
            btnOkOnPress: () async {
              Navigator.of(context).pushReplacementNamed(RoutesKeys.addTier,
                  arguments: widget.arguments);
            })
          ..show();
        return Future.value(false);
      } else {
        Navigator.pop(context, widget.arguments);
        return Future.value(false);
      }
    } else {
      if (_raisonSocialeControl.text != '') {
        AwesomeDialog(
            context: context,
            title: "",
            desc: "${S.current.msg_retour_no_save} ?",
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
            desc: "${S.current.msg_retour_no_save} ?",
            dialogType: DialogType.QUESTION,
            animType: AnimType.BOTTOMSLIDE,
            btnCancelText: S.current.non,
            btnCancelOnPress: () {},
            btnOkText: S.current.oui,
            btnOkOnPress: () async {
              Navigator.of(context).pushReplacementNamed(RoutesKeys.addTier,
                  arguments: widget.arguments);
            })
          ..show();
      } else {
        Navigator.pop(context, widget.arguments);
      }
    } else {
      if (_raisonSocialeControl.text != '') {
        AwesomeDialog(
            context: context,
            title: "",
            desc: "${S.current.msg_retour_no_save} ?",
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
    if (_formKey.currentState != null) {
      if (_formKey.currentState.validate()) {
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
    } else {
      setState(() {
        _tabSelectedIndex = 0;
        _tabController.index = _tabSelectedIndex;
      });
    }
  }

  Widget fichetab() {
    return SingleChildScrollView(
      padding: const EdgeInsetsDirectional.fromSTEB(15, 25, 15, 15),
      child: Form(
        key: _formKey,
        child: Wrap(
          spacing: 13,
          runSpacing: 13,
          children: [
            Row(
              children: [
                Flexible(
                  child: TextFormField(
                    enabled: editMode,
                    controller: _raisonSocialeControl,
                    // onTap: () => _raisonSocialeControl.selection = TextSelection(baseOffset: 0, extentOffset: _raisonSocialeControl.value.text.length),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) {
                        return S.current.msg_champ_oblg;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: S.current.rs,
                      prefixIcon: Icon(
                        MdiIcons.idCard,
                        color: Colors.green,
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.circular(20)),
                      labelStyle: GoogleFonts.lato(
                          textStyle: TextStyle(color: Colors.green)),
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
                ),
                Padding(padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5)),
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: editMode
                      ? new BoxDecoration(
                          border: Border.all(
                            color: Colors.blueAccent,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        )
                      : null,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                        disabledHint: Text(_selectedStatut),
                        value: _selectedStatut,
                        items: _statutDropdownItems,
                        onChanged: editMode
                            ? (value) {
                                setState(() {
                                  _selectedStatut = value;
                                });
                              }
                            : null),
                  ),
                ),
              ],
            ),
            TextFormField(
              enabled: editMode,
              controller: _adresseControl,
              // onTap: () => _controller.selection = TextSelection(baseOffset: 0, extentOffset: _controller.value.text.length),
              keyboardType: TextInputType.text,
              // validator: (value) {
              //   if (value.isEmpty) {
              //     return S.current.msg_champ_oblg;
              //   }
              //   return null;
              // },
              decoration: InputDecoration(
                labelText: S.current.adresse,
                labelStyle: GoogleFonts.lato(
                    textStyle: TextStyle(color: Theme.of(context).hintColor)),
                prefixIcon: Icon(
                  MdiIcons.homeCityOutline,
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
            TextFormField(
              enabled: editMode,
              controller: _villeControl,
              // onTap: () => _controller.selection = TextSelection(baseOffset: 0, extentOffset: _controller.value.text.length),
              keyboardType: TextInputType.text,
              // validator: (value) {
              //   if (value.isEmpty) {
              //     return S.current.msg_champ_oblg;
              //   }
              //   return null;
              // },
              decoration: InputDecoration(
                labelText: S.current.ville,
                labelStyle: GoogleFonts.lato(
                    textStyle: TextStyle(color: Theme.of(context).hintColor)),
                prefixIcon: Icon(
                  Icons.add_location,
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
            TextFormField(
              enabled: editMode,
              controller: _telephoneControl,
              onTap: () => _telephoneControl.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: _telephoneControl.value.text.length),
              keyboardType: TextInputType.phone,
              // validator: (value) {
              //   if (value.isEmpty) {
              //     return S.current.msg_champ_oblg;
              //   }
              //   return null;
              // },
              decoration: InputDecoration(
                labelText: S.current.telephone,
                labelStyle: GoogleFonts.lato(
                    textStyle: TextStyle(color: Theme.of(context).hintColor)),
                prefixIcon: Icon(
                  Icons.phone,
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
            TextFormField(
              enabled: editMode,
              controller: _mobileControl,
              onTap: () => _mobileControl.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: _mobileControl.value.text.length),
              keyboardType: TextInputType.phone,
              // validator: (value) {
              //   if (value.isEmpty) {
              //     return S.current.msg_champ_oblg;
              //   }
              //   return null;
              // },
              decoration: InputDecoration(
                labelText: S.current.mobile,
                labelStyle: GoogleFonts.lato(
                    textStyle: TextStyle(color: Theme.of(context).hintColor)),
                prefixIcon: Icon(
                  Icons.phone_android,
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
            TextFormField(
              enabled: editMode,
              controller: _faxControl,
              onTap: () => _faxControl.selection = TextSelection(
                  baseOffset: 0, extentOffset: _faxControl.value.text.length),
              keyboardType: TextInputType.phone,
              // validator: (value) {
              //   if (value.isEmpty) {
              //     return S.current.msg_champ_oblg;
              //   }
              //   return null;
              // },
              decoration: InputDecoration(
                labelText: S.current.fax,
                labelStyle: GoogleFonts.lato(
                    textStyle: TextStyle(color: Theme.of(context).hintColor)),
                prefixIcon: Icon(
                  MdiIcons.fax,
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
            TextFormField(
              enabled: editMode,
              controller: _emailControl,
              // onTap: () => _emailControl.selection = TextSelection(baseOffset: 0, extentOffset: _emailControl.value.text.length),
              keyboardType: TextInputType.emailAddress,
              // validator: (value) {
              //   if (value.isEmpty) {
              //     return S.current.msg_champ_oblg;
              //   }
              //   return null;
              // },
              decoration: InputDecoration(
                labelText: S.current.mail,
                labelStyle: GoogleFonts.lato(
                    textStyle: TextStyle(color: Theme.of(context).hintColor)),
                prefixIcon: Icon(
                  Icons.email,
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
            TextFormField(
              enabled: editMode,
              controller: _rcControl,
              onTap: () => _rcControl.selection = TextSelection(
                  baseOffset: 0, extentOffset: _rcControl.value.text.length),
              keyboardType: TextInputType.text,
              // validator: (value) {
              //   if (value.isEmpty) {
              //     return S.current.msg_champ_oblg;
              //   }
              //   return null;
              // },
              decoration: InputDecoration(
                labelText: S.current.n_rc,
                labelStyle: GoogleFonts.lato(
                    textStyle: TextStyle(color: Theme.of(context).hintColor)),
                prefixIcon: Icon(
                  MdiIcons.cardAccountDetails,
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
            TextFormField(
              enabled: editMode,
              controller: _nifControl,
              onTap: () => _nifControl.selection = TextSelection(
                  baseOffset: 0, extentOffset: _nifControl.value.text.length),
              keyboardType: TextInputType.text,
              // validator: (value) {
              //   if (value.isEmpty) {
              //     return S.current.msg_champ_oblg;
              //   }
              //   return null;
              // },
              decoration: InputDecoration(
                labelText: S.current.nif,
                labelStyle: GoogleFonts.lato(
                    textStyle: TextStyle(color: Theme.of(context).hintColor)),
                prefixIcon: Icon(
                  MdiIcons.cardAccountDetails,
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
            TextFormField(
              enabled: editMode,
              controller: _nisControl,
              onTap: () => _nisControl.selection = TextSelection(
                  baseOffset: 0, extentOffset: _nisControl.value.text.length),
              keyboardType: TextInputType.text,
              // validator: (value) {
              //   if (value.isEmpty) {
              //     return S.current.msg_champ_oblg;
              //   }
              //   return null;
              // },
              decoration: InputDecoration(
                labelText: S.current.nis,
                labelStyle: GoogleFonts.lato(
                    textStyle: TextStyle(color: Theme.of(context).hintColor)),
                prefixIcon: Icon(
                  MdiIcons.cardAccountDetails,
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
              visible: (_myParams.pays == "Algeria"),
              child: TextFormField(
                enabled: editMode,
                controller: _aiControl,
                onTap: () => _aiControl.selection = TextSelection(
                    baseOffset: 0, extentOffset: _aiControl.value.text.length),
                keyboardType: TextInputType.text,
                // validator: (value) {
                //   if (value.isEmpty) {
                //     return S.current.msg_champ_oblg;
                //   }
                //   return null;
                // },
                decoration: InputDecoration(
                  labelText: S.current.art_imp,
                  labelStyle: GoogleFonts.lato(
                      textStyle: TextStyle(color: Theme.of(context).hintColor)),
                  prefixIcon: Icon(
                    MdiIcons.cardAccountDetails,
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
            TextFormField(
              enabled: editMode,
              controller: _solde_departControl,
              onTap: () => _solde_departControl.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: _solde_departControl.value.text.length),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (!value.isNumericUsingRegularExpression) {
                  return S.current.msg_val_valide;
                }
                if (value.isNotEmpty && double.parse(value) < 0) {
                  return S.current.msg_prix_supp_zero;
                }
                return null;
              },
              onChanged: (value) {
                var ch_affaire = (_chiffre_affairesControl.text != '')
                    ? double.parse(_chiffre_affairesControl.text)
                    : 0.0;
                var regle = (_reglerControl.text != '')
                    ? double.parse(_reglerControl.text)
                    : 0.0;

                _creditControl.text =
                    ((double.parse(value) + ch_affaire) - regle)
                        .toStringAsFixed(2);
              },
              decoration: InputDecoration(
                labelText: S.current.solde_depart,
                labelStyle: GoogleFonts.lato(
                    textStyle: TextStyle(color: Theme.of(context).hintColor)),
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
              visible: modification,
              child: TextFormField(
                enabled: editMode,
                readOnly: true,
                controller: _chiffre_affairesControl,
                onTap: () => _chiffre_affairesControl.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: _chiffre_affairesControl.value.text.length),
                keyboardType: TextInputType.number,
                // validator: (value) {
                //   if (value.isEmpty) {
                //     return S.current.msg_champ_oblg;
                //   }
                //   return null;
                // },
                decoration: InputDecoration(
                  labelText: S.current.chifre_affaire,
                  labelStyle: GoogleFonts.lato(
                      textStyle: TextStyle(color: Theme.of(context).hintColor)),
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
            ),
            Visibility(
              visible: modification,
              child: TextFormField(
                enabled: editMode,
                readOnly: true,
                controller: _reglerControl,
                onTap: () => _reglerControl.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: _reglerControl.value.text.length),
                keyboardType: TextInputType.number,
                // validator: (value) {
                //   if (value.isEmpty) {
                //     return S.current.msg_champ_oblg;
                //   }
                //   return null;
                // },
                decoration: InputDecoration(
                  labelText: S.current.regler,
                  labelStyle: GoogleFonts.lato(
                      textStyle: TextStyle(color: Theme.of(context).hintColor)),
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
            ),
            Visibility(
              visible: modification,
              child: TextFormField(
                enabled: editMode,
                readOnly: true,
                controller: _creditControl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.account_balance_wallet,
                    color: Colors.blue,
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(20)),
                  labelText: S.current.credit,
                  labelStyle: GoogleFonts.lato(
                      textStyle: TextStyle(color: Theme.of(context).hintColor)),
                  enabledBorder: OutlineInputBorder(
                    gapPadding: 3.3,
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
            ),
            dropdowns(),
            Visibility(
              visible: false,
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
                  title: Text(S.current.client_four,
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            color: editMode
                                ? Theme.of(context).primaryColorDark
                                : Theme.of(context)
                                    .tabBarTheme
                                    .unselectedLabelColor),
                      )),
                  value: _clientFournBool,
                  onChanged: editMode
                      ? (bool value) {
                          setState(() {
                            _clientFournBool = value;
                          });
                        }
                      : null,
                ),
              ),
            ),
            Visibility(
              visible: (widget.arguments.id != null &&
                  (widget.arguments.id != 1 && widget.arguments.id != 2)),
              child: Container(
                  decoration: editMode
                      ? new BoxDecoration(
                          border: Border.all(
                            color: Colors.blueAccent,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        )
                      : null,
                  child: SwitchListTile(
                    title: Text(
                      S.current.bloquer,
                      style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              color: Theme.of(context).primaryColorDark)),
                    ),
                    value: _controlBloquer,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: editMode
                        ? (bool value) {
                            setState(() {
                              _controlBloquer = value;
                            });
                          }
                        : (bool value) {},
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget imageTab() {
    return SingleChildScrollView(
      child: ImagePickerWidget(
          imageFile: _itemImage,
          editMode: editMode,
          onImageChange: (File imageFile) {
            setState(() {
              _itemImage = imageFile;
            });
          }),
    );
  }

  Widget qrCodeTab() {
    final bodyHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewInsets.bottom;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        RepaintBoundary(
          key: globalKey,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            width: 300,
            height: 300,
            child: (_qrCodeControl.text != "")
                ? QrImage(
                    data: _qrCodeControl.text,
                    size: 0.5 * bodyHeight,
                  )
                : Center(
                    child: Text(S.current.msg_no_qr,
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold))),
                  ),
          ),
        ),
        SizedBox(
          height: 25,
        ),
        (editMode)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    child: new IconButton(
                      color: Colors.black,
                      icon: new Icon(
                        MdiIcons.qrcodeScan,
                        size: 30,
                        color: Colors.blue,
                      ),
                      onPressed: editMode
                          ? () async {
                              await scanQRCode();
                            }
                          : null,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    child: new IconButton(
                      color: Colors.black,
                      icon: new Icon(
                        Icons.autorenew_outlined,
                        size: 30,
                        color: Colors.blueGrey,
                      ),
                      onPressed: editMode
                          ? () {
                              if (_raisonSocialeControl.text != "" &&
                                  _mobileControl.text != "") {
                                setState(() {
                                  _qrCodeControl.text = "Tier://" +
                                      _raisonSocialeControl.text +
                                      "/" +
                                      _mobileControl.text;
                                });
                              } else {
                                var message = S.current.msg_gen_qr;
                                Helpers.showToast(message);
                              }
                            }
                          : null,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    child: IconButton(
                        icon: new Icon(
                          Icons.share,
                          size: 30,
                          color: Colors.blue,
                        ),
                        onPressed: () async {
                          if (_qrCodeControl.text != "") {
                            if (_myParams.versionType != "demo") {
                              await _captureAndSharePng();
                            } else {
                              var message = S.current.msg_demo_option;
                              Helpers.showToast(message);
                            }
                          } else {
                            var message = S.current.msg_no_qr;
                            Helpers.showToast(message);
                          }
                        }),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: new Icon(
                        Icons.print_rounded,
                        size: 30,
                        color: Colors.green,
                      ),
                      onPressed: () async {
                        if (_qrCodeControl.text != "") {
                          if (_myParams.versionType != "demo") {
                            await _printQr();
                          } else {
                            var message = S.current.msg_demo_option;
                            Helpers.showToast(message);
                          }
                        } else {
                          var message = S.current.msg_no_qr;
                          Helpers.showToast(message);
                        }
                      },
                    ),
                  ),
                ],
              )
      ],
    );
  }

  Widget mapTab() {
    return OSMFlutter(
      key: osmKey,
      trackMyPosition: false,
      useSecureURL: false,
      currentLocation: false,
      onGeoPointClicked: (value) {},
      initPosition: GeoPoint(latitude: _latitude, longitude: _longitude),
      road: Road(
        startIcon: MarkerIcon(
          icon: Icon(
            Icons.person,
            size: 80,
            color: Colors.blue,
          ),
        ),
        roadColor: Colors.lightGreenAccent,
      ),
      markerIcon: MarkerIcon(
        icon: Icon(
          Icons.location_pin,
          color: Colors.red[700],
          size: 120,
        ),
      ),
    );
  }

  Widget dropdowns() {
    return Column(
      children: [
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
            AwesomeDialog(
              context: context,
              dialogType: DialogType.NO_HEADER,
              animType: AnimType.BOTTOMSLIDE,
              title: S.current.supp,
              body: addFamilledialogue(),
            )..show().then((value) => setState(() {}));
          },
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
        ),
        Visibility(
          visible: (_clientFourn != 2),
          child: ListDropDown(
            libelle: "${S.current.tarif}",
            editMode: editMode,
            value: _selectedTarification,
            items: _tarificationDropdownItems,
            onChanged: (value) {
              setState(() {
                _selectedTarification = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget addFamilledialogue() {
    _famille = TiersFamille.init();
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Builder(
          builder: (context) => SingleChildScrollView(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "${S.current.ajouter} ${S.current.famile}",
                      style: GoogleFonts.lato(
                          textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      )),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(5, 20, 5, 20),
                      child: TextField(
                        controller: _libelleFamilleControl,
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
                          labelText: S.current.famile,
                          labelStyle: GoogleFonts.lato(
                            textStyle:
                                TextStyle(color: Theme.of(context).hintColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            gapPadding: 3.3,
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 150.0,
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(start: 0, end: 0),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          onPressed: () async {
                            setState(() {
                              _famille.libelle =
                                  _libelleFamilleControl.text.trim();
                              _libelleFamilleControl.text = "";
                            });
                            await addFamilleIfNotExist(_famille);
                            Navigator.pop(context);
                          },
                          child: Text(
                            "+ ${S.current.ajouter}",
                            style: GoogleFonts.lato(
                                textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            )),
                          ),
                          color: Colors.green,
                        ),
                      ),
                    )
                  ],
                ),
              ));
    });
  }

  Future<void> addFamilleIfNotExist(famille) async {
    int familleIndex = _familleItems.indexOf(famille);
    if (familleIndex > -1) {
      _selectedFamille = _familleItems[familleIndex];
    } else {
      int id = await widget._queryCtr
          .addItemToTable(DbTablesNames.tiersFamille, famille);
      famille.id = id;

      _familleItems.add(famille);
      _familleDropdownItems = utils.buildDropFamilleTier(_familleItems);
      _selectedFamille = _familleItems.last;
    }
  }

  //*************************************************************************************************************************************************************************
  //************************************************************************partie de save***********************************************************************************
  Future<int> addItemToDb() async {
    int id = -1;
    String message;
    try {
      if (widget.arguments.id != null) {
        var item = await makeItem();
        id = await widget._queryCtr.updateItemInDb(DbTablesNames.tiers, item);
        if (id > -1) {
          widget.arguments = item;
          widget.arguments.id = id;
          message = S.current.msg_update_item;
        } else {
          message = S.current.msg_update_err;
        }
      } else {
        var item = await makeItem();
        id = await widget._queryCtr.addItemToTable(DbTablesNames.tiers, item);
        if (id > -1) {
          widget.arguments = item;
          widget.arguments.id = id;
          message = S.current.msg_ajout_item;
        } else {
          message = S.current.msg_ajout_err;
        }
      }
      if (!modification && editMode) {
        Navigator.pop(context);
      }
      Helpers.showToast(message);
      return Future.value(id);
    } catch (e) {
      Helpers.showToast(S.current.msg_ereure);
      return Future.value(-1);
    }
  }

  Future<Object> makeItem() async {
    var item = new Tiers.empty();
    item.id = widget.arguments.id;

    if (_clientFournBool) {
      item.clientFour = 1;
    } else {
      item.clientFour = _clientFourn;
    }

    item.raisonSociale = _raisonSocialeControl.text.trim();

    if (_qrCodeControl.text.trim() != "") {
      item.qrCode = _qrCodeControl.text.trim();
    }

    item.adresse = _adresseControl.text.trim();

    item.latitude = _latitude;
    item.longitude = _longitude;
    item.ville = _villeControl.text.trim();
    item.telephone = _telephoneControl.text.trim();
    item.mobile =
        (_mobileControl.text.trim() != '') ? _mobileControl.text.trim() : '';
    item.fax = _faxControl.text.trim();
    item.email = _emailControl.text.trim();
    item.rc = _rcControl.text.trim();
    item.ai = _aiControl.text.trim();
    item.nif = _nifControl.text.trim();
    item.nis = _nisControl.text.trim();

    item.solde_depart = (_solde_departControl.text.trim() != "")
        ? double.tryParse(_solde_departControl.text.trim())
        : 0.0;
    item.chiffre_affaires = (_chiffre_affairesControl.text.trim() != "")
        ? double.tryParse(_chiffre_affairesControl.text.trim())
        : 0.0;
    item.regler = (_reglerControl.text.trim() != "")
        ? double.tryParse(_reglerControl.text.trim())
        : 0.0;
    item.credit = (_creditControl.text.trim() != '')
        ? double.parse(_creditControl.text.trim())
        : 0.0;

    if (_itemImage != null) {
      item.imageUint8List = await Helpers.getUint8ListFromFile(_itemImage);
    } else {
      Uint8List image = await Helpers.getDefaultImageUint8List(from: "tier");
      item.imageUint8List = image;
    }
    item.id_famille = _selectedFamille.id;
    item.statut = Statics.statutItems.indexOf(_selectedStatut);
    item.tarification = _selectedTarification;
    item.bloquer = _controlBloquer;

    return item;
  }

  //**********************************************************************************************************************************************************************
  //**************************************************************************partie pecial qr code************************************************************************
  Future scanQRCode() async {
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
          _qrCodeControl.text = result.rawContent;
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
        result.rawContent = '${S.current.msg_ereure}($e)';
      }
      Helpers.showToast(result.rawContent);
    }
  }

  Future<void> _captureAndSharePng() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await new File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes);

      final RenderBox box = context.findRenderObject();
      List<String> paths = new List<String>();
      paths.add('${tempDir.path}/image.png');
      await Share.shareFiles(
        paths,
        subject: 'Share',
        text: 'Hey, check it out the sharefiles repo!',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future _printQr() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await new File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes);

      final doc = pw.Document();
      final image01 = pw.MemoryImage(
        file.readAsBytesSync(),
      );

      doc.addPage(pw.Page(build: (pw.Context context) {
        return pw.Center(
          child: pw.Image(image01),
        ); // Center
      }));

      await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => doc.save());
    } catch (e) {
      print(e.toString());
    }
  }
}
