import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/Widgets/CustomWidgets/add_save_bar.dart';
import 'package:gestmob/Widgets/CustomWidgets/bottom_tab_bar.dart';
import 'package:gestmob/Widgets/CustomWidgets/enterPin.dart';
import 'package:gestmob/Widgets/CustomWidgets/image_picker_widget.dart';
import 'package:gestmob/Widgets/CustomWidgets/list_dropdown.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/Article.dart';
import 'package:gestmob/models/Piece.dart';
import 'package:gestmob/models/Profile.dart';
import 'package:gestmob/models/Tiers.dart';
import 'package:gestmob/models/TiersFamille.dart';
import 'package:gestmob/search/items_sliver_list.dart';
import 'package:gestmob/search/sliver_list_data_source.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gestmob/Widgets/utils.dart' as utils;
import 'package:map_launcher/map_launcher.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  
  var arguments;

  TabController _tabController;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool editMode = true;
  bool modification = false;
  bool finishedLoading = false;
  String appBarTitle = "Tiers";

  List<DropdownMenuItem<String>> _statutDropdownItems;
  String _selectedStatut;



  TextEditingController _raisonSocialeControl = new TextEditingController();
  TextEditingController _activiteControl = new TextEditingController();
  TextEditingController _adresseControl = new TextEditingController();
  TextEditingController _villeControl = new TextEditingController();
  TextEditingController _paysControl = new TextEditingController();
  TextEditingController _telephoneControl = new TextEditingController();
  TextEditingController _telephone2Control = new TextEditingController();
  TextEditingController _faxControl = new TextEditingController();
  TextEditingController _mobileControl = new TextEditingController();
  TextEditingController _mobile2Control = new TextEditingController();
  TextEditingController _emailControl = new TextEditingController();
  TextEditingController _addresseWebControl = new TextEditingController();
  TextEditingController _rcControl = new TextEditingController();
  TextEditingController _aiControl = new TextEditingController();
  TextEditingController _nifControl = new TextEditingController();
  TextEditingController _nisControl = new TextEditingController();
  TextEditingController _capitalsocialControl = new TextEditingController();

  File _itemImage;

  SliverListDataSource _dataSource;
  QueryCtr _queryCtr;

  final _formKey = GlobalKey<FormState>();
  
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

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
    _tabController.dispose();
    super.dispose();
  }
  //****************************************************************************************************************************************************************************
  //*************************************************************************partie special pour l'initialisation********************************************************************

  Future<bool> futureInitState() async {
    _statutDropdownItems = utils.buildDropStatutTier(Statics.statutItems);

    _selectedStatut = Statics.statutItems[0];

    arguments = await _queryCtr.getProfileById(1);
    editMode = false;
    modification = true;
    await setDataFromItem(arguments);

    return Future<bool>.value(editMode);
  }

  Future<void> setDataFromItem(Profile item) async {
    //read image
    _itemImage = await Helpers.getFileFromUint8List(item.imageUint8List);
    _raisonSocialeControl.text = item.raisonSociale;
    _selectedStatut = Statics.statutItems[item.statut];
    _activiteControl.text = item.activite;
    _adresseControl.text = item.adresse;
    _villeControl.text = item.ville;
    _paysControl.text = item.pays;
    _telephoneControl.text = item.telephone;
    _telephone2Control.text = item.telephone2;
    _mobileControl.text = item.mobile;
    _mobile2Control.text = item.mobile2;
    _faxControl.text = item.fax;
    _emailControl.text = item.email;
    _addresseWebControl.text = item.addressWeb;
    _rcControl.text = item.rc;
    _aiControl.text = item.ai;
    _nifControl.text = item.nif;
    _nisControl.text = item.nis;
    _capitalsocialControl.text = item.capital.toString();

  }

  //****************************************************************************************************************************************************************************
  //*************************************************************************partie special pour l'affichage********************************************************************

  @override
  Widget build(BuildContext context) {
    if (modification) {
      if (editMode) {
        appBarTitle =  S.current.modification_titre;
      } else {
        appBarTitle =  S.current.profile_titre;
      }
    } else {
      if (editMode) {
        appBarTitle =  S.current.profile_ajouter;
      } else {
        appBarTitle =  S.current.profile_titre;
      }
    }

    if (!finishedLoading) {
      return Scaffold(body: Helpers.buildLoading());
    } else {
      return DefaultTabController(
          length: 3,
          child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: Color(0xFFF1F8FA),
              appBar: AddEditBar(
                editMode: editMode,
                modification: modification,
                title: appBarTitle,
                onCancelPressed: () => {
                  if(modification){
                    if(editMode){
                      Navigator.of(context)
                          .pushReplacementNamed(RoutesKeys.profilePage, arguments: arguments)
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
                    } else {
                      Helpers.showFlushBar(context, "${S.current.msg_champs_obg}");
                    }
                  }else{
                    setState(() {
                      _tabController.index = 0 ;
                    });
                  }

                },
              ),
              bottomNavigationBar: BottomTabBar(
                controller: _tabController,
                tabs: [
                  Tab(child: Column( children: [ Icon(Icons.insert_drive_file),SizedBox(height: 1), Text( S.current.fiche), ], )),
                  Tab(child: Column( children: [ Icon(Icons.image), SizedBox(height: 1), Text( S.current.logo), ], )),
                  Tab(child: Column( children: [ Icon(Icons.fingerprint), SizedBox(height: 1), Text( S.current.securite), ], )),
                ],
              ),
              body: Builder(
                builder: (context) => TabBarView(
                  controller: _tabController,
                  children: [
                    fichetab(),
                    imageTab(),
                    securityTab(),
                  ],
                ),
              )));
    }
  }

  Widget fichetab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(15, 25, 15, 15),
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
                      labelText:  S.current.rs,
                      labelStyle: TextStyle(color: Colors.green),
                      prefixIcon: Icon(
                        MdiIcons.idCard,
                        color: Colors.blue[700],
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.circular(20)),
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
                Padding(padding: EdgeInsets.fromLTRB(5, 5, 5, 5)),
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
              controller: _activiteControl,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value.isEmpty) {
                  return S.current.msg_champ_oblg;
                }
                return null;
              },
              decoration: InputDecoration(
                labelText:  S.current.activite,
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
              controller: _adresseControl,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value.isEmpty) {
                  return S.current.msg_champ_oblg;
                }
                return null;
              },
              decoration: InputDecoration(
                labelText:  S.current.adresse,
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
                labelText:  S.current.ville,
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
              controller: _paysControl,
              keyboardType: TextInputType.text,
              // validator: (value) {
              //   if (value.isEmpty) {
              //     return S.current.msg_champ_oblg;
              //   }
              //   return null;
              // },
              decoration: InputDecoration(
                labelText:  S.current.pays,
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
              keyboardType: TextInputType.number,
              // validator: (value) {
              //   if (value.isEmpty) {
              //     return S.current.msg_champ_oblg;
              //   }
              //   return null;
              // },
              decoration: InputDecoration(
                labelText:  S.current.telephone,
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
              controller: _telephone2Control,
              keyboardType: TextInputType.number,
              // validator: (value) {
              //   if (value.isEmpty) {
              //     return S.current.msg_champ_oblg;
              //   }
              //   return null;
              // },
              decoration: InputDecoration(
                labelText:  S.current.telephone2,
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
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.isEmpty) {
                  return S.current.msg_champ_oblg;
                }
                return null;
              },
              decoration: InputDecoration(
                labelText:  S.current.mobile,
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
              controller: _mobile2Control,
              keyboardType: TextInputType.number,
              // validator: (value) {
              //   if (value.isEmpty) {
              //     return S.current.msg_champ_oblg;
              //   }
              //   return null;
              // },
              decoration: InputDecoration(
                labelText:  S.current.mobile2,
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
              keyboardType: TextInputType.number,
              // validator: (value) {
              //   if (value.isEmpty) {
              //     return S.current.msg_champ_oblg;
              //   }
              //   return null;
              // },
              decoration: InputDecoration(
                labelText:  S.current.fax,
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
              keyboardType: TextInputType.text,
              // validator: (value) {
              //   if (value.isEmpty) {
              //     return S.current.msg_champ_oblg;
              //   }
              //   return null;
              // },
              decoration: InputDecoration(
                labelText:  S.current.mail,
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
              enabled: editMode,
              controller: _addresseWebControl,
              keyboardType: TextInputType.text,
              // validator: (value) {
              //   if (value.isEmpty) {
              //     return S.current.msg_champ_oblg;
              //   }
              //   return null;
              // },
              decoration: InputDecoration(
                labelText:  S.current.adresse_web,
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
              enabled: editMode,
              controller: _rcControl,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value.isEmpty) {
                  return S.current.msg_champ_oblg;
                }
                return null;
              },
              decoration: InputDecoration(
                labelText:  S.current.n_rc,
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
              enabled: editMode,
              controller: _aiControl,
              keyboardType: TextInputType.text,
              // validator: (value) {
              //   if (value.isEmpty) {
              //     return S.current.msg_champ_oblg;
              //   }
              //   return null;
              // },
              decoration: InputDecoration(
                labelText:  S.current.art_imp,
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
              enabled: editMode,
              controller: _nifControl,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value.isEmpty) {
                  return S.current.msg_champ_oblg;
                }
                return null;
              },
              decoration: InputDecoration(
                labelText:  S.current.nif,
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
              enabled: editMode,
              controller: _nisControl,
              keyboardType: TextInputType.text,
              // validator: (value) {
              //   if (value.isEmpty) {
              //     return S.current.msg_champ_oblg;
              //   }
              //   return null;
              // },
              decoration: InputDecoration(
                labelText:  S.current.nis,
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
              enabled: editMode,
              controller: _capitalsocialControl,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.isEmpty) {
                  return S.current.msg_champ_oblg;
                }
                return null;
              },
              decoration: InputDecoration(
                labelText:  S.current.capitale_sociale,
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              decoration: editMode
                  ? new BoxDecoration(
                border: Border.all(
                  color: Colors.blueAccent,
                ),
                borderRadius: BorderRadius.circular(20.0),
              )
                  : null,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(width: 6),
                  Icon(
                    Icons.security, color: Colors.blue[700],),
                  SizedBox(width: 13),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        arguments.codePinEnabled = !arguments.codePinEnabled;
                      },
                      child: new Text( S.current.code_pin,
                        style: TextStyle(
                            fontSize: 16,
                            color:
                            editMode ? Colors.black : Colors.black54)),
                    ),
                  ),

                  Switch(
                    value: arguments.codePinEnabled,
                    onChanged: editMode?(bool isOn) {
                      setState(() {
                        arguments.codePinEnabled = isOn;
                        if(isOn){
                          setState(() {
                            _tabController.index = 2;
                          });
                        }
                      });
                    }: null,
                    activeColor: Colors.blue,
                    inactiveTrackColor: Colors.grey,
                    inactiveThumbColor: editMode? Colors.blue:Colors.grey,
                  )
                ],
              ),
            )

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
          onImageChange: (File imageFile) => {_itemImage = imageFile}
          ),
    );
  }

  Widget securityTab() {
    return EnterPin(editMode?onCodePinChanged:null, arguments.codepin);
  }

  onCodePinChanged (String newCodePin){
    arguments.codepin = newCodePin;
    setState(() {
      _tabController.index = 0;
    });
  }

  //****************************************************************************************************************************************************************************
  //*************************************************************************partie du sauvgarde********************************************************************************

  Future<int> addItemToDb() async {
    int id = -1;
    String message;
    try {
      if (arguments.id != null) {
        var item = await makeItem();
        id = await _queryCtr.updateItemInDb(DbTablesNames.profile, item);
        if (id > -1) {
          arguments = item;
          arguments.id = id;
          message = S.current.msg_update_item;
        } else {
          message = S.current.msg_update_err;
        }
      } else {
        var item = await makeItem();
        id = await _queryCtr.addItemToTable(DbTablesNames.profile, item);
        if (id > -1) {
          arguments = item;
          arguments.id = id;
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
    var item = new Profile.empty();
    item.id = arguments.id;

    item.codepin = arguments.codepin;
    item.codePinEnabled = arguments.codePinEnabled;

    item.raisonSociale = _raisonSocialeControl.text;
    item.statut = Statics.statutItems.indexOf(_selectedStatut);
    item.activite = _activiteControl.text;
    item.adresse = _adresseControl.text;
    item.ville = _villeControl.text;
    item.pays = _paysControl.text;
    item.telephone = _telephoneControl.text;
    item.telephone2 = _telephone2Control.text;
    item.mobile = _mobileControl.text;
    item.mobile2 = _mobile2Control.text;
    item.fax = _faxControl.text;
    item.email = _emailControl.text;
    item.addressWeb = _addresseWebControl.text;
    if (_itemImage != null) {
      item.imageUint8List = await Helpers.getUint8ListFromFile(_itemImage);
    } else {
      Uint8List image = await Helpers.getDefaultImageUint8List(from: "profile");
      item.imageUint8List = image;
    }
    item.rc = _rcControl.text;
    item.ai = _aiControl.text;
    item.nif = _nifControl.text;
    item.nis = _nisControl.text;
    item.capital = double.tryParse(_capitalsocialControl.text);

    return item;
  }
}
