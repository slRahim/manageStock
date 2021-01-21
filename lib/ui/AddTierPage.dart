import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/Widgets/CustomWidgets/add_save_bar.dart';
import 'package:gestmob/Widgets/CustomWidgets/bottom_tab_bar.dart';
import 'package:gestmob/Widgets/CustomWidgets/image_picker_widget.dart';
import 'package:gestmob/Widgets/CustomWidgets/list_dropdown.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/Article.dart';
import 'package:gestmob/models/MyParams.dart';
import 'package:gestmob/models/Tiers.dart';
import 'package:gestmob/models/TiersFamille.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gestmob/Widgets/utils.dart' as utils;
import 'package:map_launcher/map_launcher.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/rendering.dart';
import 'package:share/share.dart';

class AddTierPage extends StatefulWidget {

  final QueryCtr _queryCtr = QueryCtr();

  var arguments;
  AddTierPage({Key key, @required this.arguments}) : super(key: key);

  @override
  _AddTierPageState createState() => _AddTierPageState();
}

class _AddTierPageState extends State<AddTierPage>
    with TickerProviderStateMixin , AutomaticKeepAliveClientMixin {

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

  List<int> _tarificationItems = Statics.tarificationItems ;
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
  TextEditingController _solde_departControl = new TextEditingController();
  TextEditingController _chiffre_affairesControl = new TextEditingController();
  TextEditingController _reglerControl = new TextEditingController();
  TextEditingController _creditControl = new TextEditingController();
  bool _controlBloquer = false ;

  var _famille = new TiersFamille.init();

  File _itemImage;

  QueryCtr _queryCtr = new QueryCtr() ;
  MyParams _myParams ;

  GlobalKey globalKey = new GlobalKey();
  final _formKey = GlobalKey<FormState>();


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  void didChangeDependencies() {
    Statics.statutItems[0] = S.current.statut_m ;
    Statics.statutItems[1] = S.current.statut_mlle ;
    Statics.statutItems[2] = S.current.statut_mme;
    Statics.statutItems[3] = S.current.statut_dr ;
    Statics.statutItems[4] = S.current.statut_pr ;
    Statics.statutItems[5] = S.current.statut_eurl ;
    Statics.statutItems[6] = S.current.statut_sarl ;
    Statics.statutItems[7] = S.current.statut_spa ;
    Statics.statutItems[8] = S.current.statut_epic ;
    Statics.statutItems[9] = S.current.statut_etp ;
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
      // print("Selected Index: " + _tabController.index.toString());
    });
  }

  Future<bool> futureInitState() async {
    _familleItems = await widget._queryCtr.getAllTierFamilles();
    _familleItems[0].libelle = S.current.no_famille ;

    _familleDropdownItems = utils.buildDropFamilleTier(_familleItems);
    _statutDropdownItems = utils.buildDropStatutTier(Statics.statutItems);
    await getParams() ;
    _tarificationDropdownItems = utils.buildDropTarificationTier(_tarificationItems);

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

  Future<void> setDataFromItem(item) async {
    _raisonSocialeControl.text = item.raisonSociale;
    _qrCodeControl.text = item.qrCode;
    _adresseControl.text = item.adresse;
    _clientFournBool = _clientFourn == 1;

    if(item.latitude != null && item.longitude != null){
      _latitude = item.latitude;
      _longitude = item.longitude;
    }

    _itemImage = await Helpers.getFileFromUint8List(item.imageUint8List);
    _villeControl.text = item.ville;
    _telephoneControl.text = item.telephone;
    _mobileControl.text = item.mobile;
    _faxControl.text = item.fax;
    _emailControl.text = item.email;
    _solde_departControl.text = item.solde_depart.toString();
    _chiffre_affairesControl.text = item.chiffre_affaires.toString();
    _reglerControl.text = item.regler.toString();
    _creditControl.text = item.credit.toString();
    _selectedFamille = _familleItems[item.id_famille-1];
    _selectedStatut = Statics.statutItems[item.statut];
    _selectedTarification = _tarificationItems[item.tarification];
    _controlBloquer = item.bloquer ;
  }

  void getParams () async {
      _myParams = await _queryCtr.getAllParams() ;
      switch(_myParams.tarification){
        case 1 :
          _tarificationItems = _tarificationItems.sublist(0,1);
          break;
        case 2 :
          _tarificationItems = _tarificationItems.sublist(0,2);
          break;
        case 3 :
          _tarificationItems = _tarificationItems.sublist(0,3);
          break;
        default:
          _tarificationItems = _tarificationItems.sublist(0,1);
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
        if(_clientFourn == 0){
          appBarTitle = S.current.client_titre;
        } else if(_clientFourn == 1){
          appBarTitle = S.current.client_titre + S.current.fournisseur_titre;
        } else{
          appBarTitle = S.current.fournisseur_titre;
        }
      }
    } else {
      if (editMode) {
        if(_clientFourn == 0){
          appBarTitle = "${S.current.ajouter} ${S.current.client_titre}";
        } else{
          appBarTitle ="${S.current.ajouter} ${S.current.fournisseur_titre}";
        }
      } else {
        if(_clientFourn == 0){
          appBarTitle = S.current.client_titre;
        } else if(_clientFourn == 1){
          appBarTitle = S.current.client_titre + S.current.fournisseur_titre;;
        } else{
          appBarTitle = S.current.client_titre;
        }
      }
    }

    if (!finishedLoading) {
      return Scaffold(body: Helpers.buildLoading());
    } else {
      return DefaultTabController(
            length: 4,
            child: Scaffold(
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
                          backgroundColor: Colors.green,
                          onPressed: () async {
                            GeoPoint geoPoint = await osmKey.currentState.selectPosition();
                            if(geoPoint != null){
                              _latitude = geoPoint.latitude;
                              _longitude = geoPoint.longitude;
                            }
                          },
                          child: Icon(Icons.add_location),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Visibility(
                            visible: _tabSelectedIndex == 2 && !editMode,
                            child: FloatingActionButton(
                              backgroundColor: Colors.blueAccent,
                              onPressed: () async {
                                Helpers.openMapsSheet(context, new Coords(_latitude, _longitude));
                              },
                              child: Icon(Icons.directions),
                            ),
                          ),
                          Visibility(
                            visible: _tabSelectedIndex == 2 && editMode,
                            child: FloatingActionButton(
                              onPressed: () async {
                                await osmKey.currentState.currentLocation();
                              },
                              child: Icon(Icons.my_location),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                key: _scaffoldKey,
                backgroundColor: Theme.of(context).backgroundColor,
                appBar: AddEditBar(
                  editMode: editMode,
                  modification: modification,
                  title: appBarTitle,
                  onCancelPressed: () => {
                    if(modification){
                      if(editMode){
                        Navigator.of(context)
                            .pushReplacementNamed(RoutesKeys.addTier, arguments: widget.arguments)
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
                    if(_formKey.currentState != null){
                      if(_formKey.currentState.validate()){
                        int id = await addItemToDb();
                        if (id > -1) {
                          setState(() {
                            modification = true;
                            editMode = false;
                          });
                        }
                      }else{
                        Helpers.showFlushBar(context, "Veuillez remplir les champs obligatoire");
                      }
                    }else{
                      setState(() {
                        _tabSelectedIndex = 0 ;
                        _tabController.index = _tabSelectedIndex ;
                      });
                    }

                  },
                ),
                bottomNavigationBar: BottomTabBar(
                  selectedIndex: _tabSelectedIndex,
                  controller: _tabController,
                  tabs: [
                    Tab(child: Column( children: [ Icon(Icons.insert_drive_file),SizedBox(height: 1), Text(S.current.fiche), ], )),
                    Tab(child: Column( children: [ Icon(Icons.image), SizedBox(height: 1), Text(S.current.photo), ], )),
                    Tab(child: Column( children: [ Icon(Icons.map), SizedBox(height: 1), Text(S.current.map), ], )),
                    Tab(child: Column( children: [ Icon(MdiIcons.qrcode), SizedBox(height: 1), Text(S.current.qr_code), ], )),
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
      );
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
                        color: Colors.blue[700],
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.circular(20)),
                      labelStyle: TextStyle(color: Colors.green),
                      enabledBorder: OutlineInputBorder(
                        gapPadding: 3.3,
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      errorBorder:  OutlineInputBorder(
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
                  decoration: editMode? new BoxDecoration(
                    border: Border.all(color: Colors.blueAccent,),
                    borderRadius: BorderRadius.circular(20.0),
                  ) : null,
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
                            : null),),
                ),
              ],
            ),
            TextFormField(
              enabled: editMode,
              controller: _adresseControl,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value.isEmpty) {
                  return S.current.msg_champ_oblg;
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: S.current.adresse,
                prefixIcon: Icon(
                  MdiIcons.homeCityOutline,
                  color: Colors.blue[700],
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[700]),
                    borderRadius: BorderRadius.circular(20)),
                enabledBorder: OutlineInputBorder(
                  gapPadding: 3.3,
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.blue[700]),
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
              controller: _villeControl,
              keyboardType: TextInputType.text,
              // validator: (value) {
              //   if (value.isEmpty) {
              //     return S.current.msg_champ_oblg;
              //   }
              //   return null;
              // },
              decoration: InputDecoration(
                labelText: S.current.ville,
                prefixIcon: Icon(
                  Icons.add_location,
                  color: Colors.blue[700],
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[700]),
                    borderRadius: BorderRadius.circular(20)),
                enabledBorder: OutlineInputBorder(
                  gapPadding: 3.3,
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.blue[700]),
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
              controller: _telephoneControl,
              keyboardType: TextInputType.phone,
              // validator: (value) {
              //   if (value.isEmpty) {
              //     return S.current.msg_champ_oblg;
              //   }
              //   return null;
              // },
              decoration: InputDecoration(
                labelText: S.current.telephone,
                prefixIcon: Icon(
                  Icons.phone,
                  color: Colors.blue[700],
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[700]),
                    borderRadius: BorderRadius.circular(20)),
                enabledBorder: OutlineInputBorder(
                  gapPadding: 3.3,
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.blue[700]),
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
              controller: _mobileControl,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value.isEmpty) {
                  return S.current.msg_champ_oblg;
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: S.current.mobile,
                prefixIcon: Icon(
                  Icons.phone_android,
                  color: Colors.blue[700],
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[700]),
                    borderRadius: BorderRadius.circular(20)),
                enabledBorder: OutlineInputBorder(
                  gapPadding: 3.3,
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.blue[700]),
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
              controller: _faxControl,
              keyboardType: TextInputType.phone,
              // validator: (value) {
              //   if (value.isEmpty) {
              //     return S.current.msg_champ_oblg;
              //   }
              //   return null;
              // },
              decoration: InputDecoration(
                labelText: S.current.fax,
                prefixIcon: Icon(
                  MdiIcons.fax,
                  color: Colors.blue[700],
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[700]),
                    borderRadius: BorderRadius.circular(20)),
                enabledBorder: OutlineInputBorder(
                  gapPadding: 3.3,
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.blue[700]),
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
              controller: _emailControl,
              keyboardType: TextInputType.emailAddress,
              // validator: (value) {
              //   if (value.isEmpty) {
              //     return S.current.msg_champ_oblg;
              //   }
              //   return null;
              // },
              decoration: InputDecoration(
                labelText: S.current.mail,
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.blue[700],
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[700]),
                    borderRadius: BorderRadius.circular(20)),
                enabledBorder: OutlineInputBorder(
                  gapPadding: 3.3,
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.blue[700]),
                ),
                errorBorder:  OutlineInputBorder(
                  gapPadding: 3.3,
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
            ),
            TextFormField(
              enabled: editMode && !modification,
              controller: _solde_departControl,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.isEmpty) {
                  return S.current.msg_champ_oblg;
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: S.current.solde_depart,
                prefixIcon: Icon(
                  Icons.monetization_on,
                  color: Colors.blue[700],
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[700]),
                    borderRadius: BorderRadius.circular(20)),
                enabledBorder: OutlineInputBorder(
                  gapPadding: 3.3,
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.blue[700]),
                ),
                errorBorder:  OutlineInputBorder(
                  gapPadding: 3.3,
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
            ),
            TextFormField(
              enabled: editMode && !modification,
              controller: _chiffre_affairesControl,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.isEmpty) {
                  return S.current.msg_champ_oblg;
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: S.current.chifre_affaire,
                prefixIcon: Icon(
                  Icons.monetization_on,
                  color: Colors.blue[700],
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[700]),
                    borderRadius: BorderRadius.circular(20)),
                enabledBorder: OutlineInputBorder(
                  gapPadding: 3.3,
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.blue[700]),
                ),
                errorBorder:  OutlineInputBorder(
                  gapPadding: 3.3,
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
            ),
            TextFormField(
              enabled: editMode && !modification,
              controller: _reglerControl,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.isEmpty) {
                  return S.current.msg_champ_oblg;
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: S.current.regler,
                prefixIcon: Icon(
                  Icons.monetization_on,
                  color: Colors.blue[700],
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[700]),
                    borderRadius: BorderRadius.circular(20)),
                enabledBorder: OutlineInputBorder(
                  gapPadding: 3.3,
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.blue[700]),
                ),
                errorBorder:  OutlineInputBorder(
                  gapPadding: 3.3,
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
            ),
            Visibility(
              visible: modification,
              child: TextFormField(
                enabled: false,
                controller: _creditControl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.account_balance_wallet,
                    color: Colors.blue[700],
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue[700]),
                      borderRadius: BorderRadius.circular(20)),
                  labelText: S.current.credit,
                  enabledBorder: OutlineInputBorder(
                    gapPadding: 3.3,
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.blue[700]),
                  ),
                ),
              ),
            ),
            dropdowns() ,
            Container(
              decoration: editMode? new BoxDecoration(
                border: Border.all(color: Colors.blueAccent,),
                borderRadius: BorderRadius.circular(20.0),
              ) : null,
              child: CheckboxListTile(
                title: Text(S.current.client_four),
                value: _clientFournBool,
                onChanged: editMode? (bool value) {
                  setState(() {
                    _clientFournBool = value;
                  });
                } : null,
              ),
            ),
             Container(
                decoration: editMode? new BoxDecoration(
                  border: Border.all(color: Colors.blueAccent,),
                  borderRadius: BorderRadius.circular(20.0),
                ) : null,
                child: SwitchListTile(
                  title: Text(S.current.bloquer),
                  value: _controlBloquer,
                  onChanged: (bool value){
                    setState(() {
                      if(widget.arguments.id != null){
                        if(widget.arguments.id < 2){
                          _controlBloquer =false ;
                        }else{
                          _controlBloquer = value ;
                        }
                      }else{
                        _controlBloquer = value ;
                      }

                    });
                  },
                )
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
          onImageChange: (File imageFile) => {
              _itemImage = imageFile
          }
        ),
    );
  }

  Widget qrCodeTab() {
    final bodyHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom;
    return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            RepaintBoundary(
              key : globalKey,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset:
                      Offset(0, 2), // changes position of shadow
                    ),
                  ],
                ),
                width: 300,
                height: 300,
                child:(_qrCodeControl.text != "")? QrImage(
                  data: _qrCodeControl.text,
                    size: 0.5 * bodyHeight,
                  )
                : Center(
                  child: Text(S.current.msg_no_qr ,style: TextStyle(fontSize: 16 )),
                ),

              ),
            ),
            SizedBox(height: 25,),
            (editMode) ? Row(
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
                        offset:
                        Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: new IconButton(
                    color: Colors.black,
                    icon: new Icon(
                      MdiIcons.qrcodeScan,
                      size: 30,
                      color: Colors.blue[700],
                    ),
                    onPressed: editMode
                        ? () async{
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
                        offset:
                        Offset(0, 2), // changes position of shadow
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
                        if(_raisonSocialeControl.text != "" && _mobileControl.text != ""){
                          setState(() {
                            _qrCodeControl.text = "Tier://"+_raisonSocialeControl.text+"/"+_mobileControl.text;
                          });
                        }else{
                          var message = S.current.msg_gen_qr;
                          Helpers.showFlushBar(context, message);
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
                        offset:
                        Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: new IconButton(
                    color: Colors.black,
                    icon: new Icon(
                      Icons.save_alt,
                      size: 30,
                      color: Colors.blue[700],
                    ),
                    onPressed: () async{
                      await _captureAndSharePng();
                    }
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
                        offset:
                        Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: new IconButton(
                      color: Colors.black,
                      icon: new Icon(
                        Icons.print,
                        size: 30,
                        color: Colors.blue[700],
                      ),
                      onPressed: () async{
                      //  print qr code with thermel printer
                      }
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
        currentLocation: false,
        onGeoPointClicked: (geoPoint) {
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text(
                "lat:${geoPoint.latitude},lon${geoPoint.longitude}",
              ),
              action: SnackBarAction(
                onPressed: () =>
                    _scaffoldKey.currentState.hideCurrentSnackBar(),
                label: S.current.masquer,
              ),
            ),
          );
        },
        road: Road(
          startIcon: MarkerIcon(
            icon: Icon(
              Icons.person,
              size: 64,
              color: Colors.brown,
            ),
          ),
          roadColor: Colors.yellowAccent,
        ),
        markerIcon: MarkerIcon(
          icon: Icon(
            Icons.person_pin_circle,
            color: Colors.blue,
            size: 56,
          ),
        ),
        initPosition:
            GeoPoint(latitude: _latitude, longitude: _longitude),
        showZoomController: false,
        useSecureURL: false);
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
            await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return addFamilledialogue();
                }).then((val) {
              setState(() {});
            });
          },
        ),
        Padding(padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),),
        ListDropDown(
          libelle: "${S.current.tarif }",
          editMode: editMode,
          value: _selectedTarification,
          items: _tarificationDropdownItems,
          onChanged: (value) {
            setState(() {
              _selectedTarification = value;
            });
          },),
      ],
    );
  }

  Widget addFamilledialogue() {
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Builder(
          builder: (context) => Dialog(
                //this right here
                child: SingleChildScrollView(
                  child: Wrap(children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                              child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Text(
                              "${S.current.ajouter} ${S.current.famile}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(5, 20, 5, 20),
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
                              padding: EdgeInsetsDirectional.only(start: 0, end: 0),
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                onPressed: () async {
                                  setState(() {
                                    _famille.libelle =
                                        _libelleFamilleControl.text;
                                    _libelleFamilleControl.text = "";
                                  });
                                  await addFamilleIfNotExist(_famille);

                                  Navigator.pop(context);
                                  final snackBar = SnackBar(
                                    content: Text(
                                      S.current.msg_fam_ajout,
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
                  ]),
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
      _selectedFamille = _familleItems[_familleItems.length];
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
      Helpers.showFlushBar(context, message);
      return Future.value(id);
    } catch (e) {
      Helpers.showFlushBar(context, S.current.msg_ereure);
      return Future.value(-1);
    }
  }

  Future<Object> makeItem() async {
    var item = new Tiers.empty();
    item.id = widget.arguments.id;

    if(_clientFournBool){
      item.clientFour = 1;
    } else if (widget.arguments.originClientOrFourn != null){
      item.clientFour = widget.arguments.originClientOrFourn;
    } else{
      item.clientFour = _clientFourn;
    }

    item.raisonSociale = _raisonSocialeControl.text;

    if(_qrCodeControl.text != null){
      item.qrCode = _qrCodeControl.text;
    }

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
    if (_itemImage != null) {
      item.imageUint8List =  await Helpers.getUint8ListFromFile(_itemImage);
    } else {
      Uint8List image = await Helpers.getDefaultImageUint8List(from: "tier");
      item.imageUint8List = image;
    }
    item.id_famille = _selectedFamille.id;
    item.statut = Statics.statutItems.indexOf(_selectedStatut);
    item.tarification = _tarificationItems.indexOf(_selectedTarification);
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
      if(result.rawContent.isNotEmpty){
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
      RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await new File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes);

      final RenderBox box = context.findRenderObject();
      List<String> paths =new List<String>();
      paths.add('${tempDir.path}/image.png');
      await Share.shareFiles(paths,
          subject: 'Share',
          text: 'Hey, check it out the sharefiles repo!',
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size ,
      );
    } catch(e) {
      print(e.toString());
    }
  }




}
