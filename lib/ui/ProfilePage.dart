import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/Widgets/CustomWidgets/add_save_bar.dart';
import 'package:gestmob/Widgets/CustomWidgets/bottom_tab_bar.dart';
import 'package:gestmob/Widgets/CustomWidgets/image_picker_widget.dart';
import 'package:gestmob/Widgets/CustomWidgets/list_dropdown.dart';
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

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  
  var arguments;
  
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool editMode = true;
  bool modification = false;

  bool finishedLoading = false;

  String appBarTitle = "Tiers";

  List<DropdownMenuItem<String>> _statutDropdownItems;
  String _selectedStatut;

  bool _validateRaison = false;

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
  
  void initState() {
    super.initState();
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
    _statutDropdownItems = utils.buildDropStatutTier(Statics.statutItems);

    _selectedStatut = Statics.statutItems[0];

    arguments = await _queryCtr.getProfileById(1);
    editMode = false;
    modification = true;
    await setDataFromItem(arguments);

    return Future<bool>.value(editMode);
  }

  @override
  Widget build(BuildContext context) {
    if (modification) {
      if (editMode) {
        appBarTitle = "Modification";
      } else {
        appBarTitle = "Profile";
      }
    } else {
      if (editMode) {
        appBarTitle = "Ajouter une profile";
      } else {
        appBarTitle = "Profile";
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
                  if (_raisonSocialeControl.text.isNotEmpty) {
                    int id = await addItemToDb();
                    if (id > -1) {
                      setState(() {
                        modification = true;
                        editMode = false;
                      });
                    }
                  } else {
                    Helpers.showFlushBar(
                        context, "Please enter Raison sociale");

                    setState(() {
                      _validateRaison = true;
                    });
                  }
                },
              ),
              bottomNavigationBar: BottomTabBar(
                tabs: [
                  Tab(
                    icon: Icon(Icons.insert_drive_file),
                    text: 'Fiche',
                  ),
                  Tab(
                    icon: Icon(Icons.image),
                    text: 'Logo',
                  ),
                  Tab(
                    icon: Icon(Icons.fingerprint),
                    text: 'Security',
                  ),
                ],
              ),
              body: Builder(
                builder: (context) => TabBarView(
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
      child: Wrap(
        spacing: 13,
        runSpacing: 13,
        children: [
          Row(
            children: [
              Flexible(
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      MdiIcons.idCard,
                      color: Colors.orange[900],
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange[900]),
                        borderRadius: BorderRadius.circular(20)),
                    labelText: "Raison Sociale",
                    errorText: _validateRaison ? 'Champ obligatoire' : null,
                    labelStyle: TextStyle(color: Colors.orange[900]),
                    enabledBorder: OutlineInputBorder(
                      gapPadding: 3.3,
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.orange[900]),
                    ),
                  ),
                  enabled: editMode,
                  controller: _raisonSocialeControl,
                  keyboardType: TextInputType.text,
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
          TextField(
            enabled: editMode,
            controller: _activiteControl,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              prefixIcon: Icon(
                MdiIcons.homeCityOutline,
                color: Colors.blue[700],
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[700]),
                  borderRadius: BorderRadius.circular(20)),
              labelText: "Activité",
              enabledBorder: OutlineInputBorder(
                gapPadding: 3.3,
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.blue[700]),
              ),
            ),
          ),
          TextField(
            enabled: editMode,
            controller: _adresseControl,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              prefixIcon: Icon(
                MdiIcons.homeCityOutline,
                color: Colors.blue[700],
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[700]),
                  borderRadius: BorderRadius.circular(20)),
              labelText: "Adresse",
              enabledBorder: OutlineInputBorder(
                gapPadding: 3.3,
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.blue[700]),
              ),
            ),
          ),
          TextField(
            enabled: editMode,
            controller: _villeControl,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.add_location,
                color: Colors.blue[700],
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[700]),
                  borderRadius: BorderRadius.circular(20)),
              labelText: "Ville",
              enabledBorder: OutlineInputBorder(
                gapPadding: 3.3,
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.blue[700]),
              ),
            ),
          ),
          TextField(
            enabled: editMode,
            controller: _paysControl,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.add_location,
                color: Colors.blue[700],
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[700]),
                  borderRadius: BorderRadius.circular(20)),
              labelText: "Pays",
              enabledBorder: OutlineInputBorder(
                gapPadding: 3.3,
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.blue[700]),
              ),
            ),
          ),
          TextField(
            enabled: editMode,
            controller: _telephoneControl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.phone,
                color: Colors.blue[700],
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[700]),
                  borderRadius: BorderRadius.circular(20)),
              labelText: "Telephone",
              enabledBorder: OutlineInputBorder(
                gapPadding: 3.3,
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.blue[700]),
              ),
            ),
          ),
          TextField(
            enabled: editMode,
            controller: _telephone2Control,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.phone,
                color: Colors.blue[700],
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[700]),
                  borderRadius: BorderRadius.circular(20)),
              labelText: "Telephone 2",
              enabledBorder: OutlineInputBorder(
                gapPadding: 3.3,
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.blue[700]),
              ),
            ),
          ),
          TextField(
            enabled: editMode,
            controller: _mobileControl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.phone_android,
                color: Colors.blue[700],
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[700]),
                  borderRadius: BorderRadius.circular(20)),
              labelText: "Mobile",
              enabledBorder: OutlineInputBorder(
                gapPadding: 3.3,
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.blue[700]),
              ),
            ),
          ),
          TextField(
            enabled: editMode,
            controller: _mobile2Control,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.phone_android,
                color: Colors.blue[700],
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[700]),
                  borderRadius: BorderRadius.circular(20)),
              labelText: "Mobile 2",
              enabledBorder: OutlineInputBorder(
                gapPadding: 3.3,
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.blue[700]),
              ),
            ),
          ),
          TextField(
            enabled: editMode,
            controller: _faxControl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixIcon: Icon(
                MdiIcons.fax,
                color: Colors.blue[700],
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[700]),
                  borderRadius: BorderRadius.circular(20)),
              labelText: "Fax",
              enabledBorder: OutlineInputBorder(
                gapPadding: 3.3,
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.blue[700]),
              ),
            ),
          ),
          TextField(
            enabled: editMode,
            controller: _emailControl,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.email,
                color: Colors.blue[700],
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[700]),
                  borderRadius: BorderRadius.circular(20)),
              labelText: "Email",
              enabledBorder: OutlineInputBorder(
                gapPadding: 3.3,
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.blue[700]),
              ),
            ),
          ),
          TextField(
            enabled: editMode,
            controller: _addresseWebControl,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.email,
                color: Colors.blue[700],
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[700]),
                  borderRadius: BorderRadius.circular(20)),
              labelText: "Adresse web",
              enabledBorder: OutlineInputBorder(
                gapPadding: 3.3,
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.blue[700]),
              ),
            ),
          ),
          TextField(
            enabled: editMode,
            controller: _rcControl,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.email,
                color: Colors.blue[700],
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[700]),
                  borderRadius: BorderRadius.circular(20)),
              labelText: "N° RC",
              enabledBorder: OutlineInputBorder(
                gapPadding: 3.3,
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.blue[700]),
              ),
            ),
          ),
          TextField(
            enabled: editMode,
            controller: _aiControl,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.email,
                color: Colors.blue[700],
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[700]),
                  borderRadius: BorderRadius.circular(20)),
              labelText: "ART.IMP",
              enabledBorder: OutlineInputBorder(
                gapPadding: 3.3,
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.blue[700]),
              ),
            ),
          ),
          TextField(
            enabled: editMode,
            controller: _nifControl,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.email,
                color: Colors.blue[700],
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[700]),
                  borderRadius: BorderRadius.circular(20)),
              labelText: "NIF",
              enabledBorder: OutlineInputBorder(
                gapPadding: 3.3,
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.blue[700]),
              ),
            ),
          ),
          TextField(
            enabled: editMode,
            controller: _nisControl,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.email,
                color: Colors.blue[700],
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[700]),
                  borderRadius: BorderRadius.circular(20)),
              labelText: "NIS",
              enabledBorder: OutlineInputBorder(
                gapPadding: 3.3,
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.blue[700]),
              ),
            ),
          ),
          TextField(
            enabled: editMode,
            controller: _capitalsocialControl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.monetization_on,
                color: Colors.blue[700],
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[700]),
                  borderRadius: BorderRadius.circular(20)),
              labelText: "Capital social",
              enabledBorder: OutlineInputBorder(
                gapPadding: 3.3,
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.blue[700]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget imageTab() {
    return SingleChildScrollView(
      child: ImagePickerWidget(
          editMode: editMode, onImageChange: (File imageFile) =>
      {
        _itemImage = imageFile
      }),
    );
  }

  Widget securityTab() {
    return SingleChildScrollView(
      child: ImagePickerWidget(
          editMode: editMode, onImageChange: (File imageFile) =>
      {
        _itemImage = imageFile
      }),
    );
  }

  Future<Object> makeItem() async {
    var item = new Profile.empty();
    item.id = arguments.id;

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
   item.rc = _rcControl.text;
   item.ai = _aiControl.text;
   item.nif = _nifControl.text;
   item.nis = _nisControl.text;
   item.capital = double.tryParse(_capitalsocialControl.text);

    if (_itemImage != null) {
      item.imageUint8List = Helpers.getUint8ListFromFile(_itemImage);
    } else {
      Uint8List image = await Helpers.getDefaultImageUint8List();
      item.imageUint8List = image;
    }
    return item;

    return await _queryCtr.getProfileById(1);
  }

  Future<void> setDataFromItem(Profile item) async {
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

    _itemImage = await Helpers.getFileFromUint8List(item.imageUint8List);

  }

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
          message = "Profile has been updated successfully";
        } else {
          message = "Error when updating Profile in db";
        }
      } else {
        var item = await makeItem();
        id = await _queryCtr.addItemToTable(DbTablesNames.profile, item);
        if (id > -1) {
          arguments = item;
          arguments.id = id;
          message = "Profile has been added successfully";
        } else {
          message = "Error when adding Profile to db";
        }
      }
      Helpers.showFlushBar(context, message);
      return Future.value(id);
    } catch (error) {
      Helpers.showFlushBar(context, "Error: something went wrong");
      return Future.value(-1);
    }
  }
}
