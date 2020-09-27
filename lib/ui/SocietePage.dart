import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
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

class SocietePage extends StatefulWidget {
  var arguments;
  SocietePage({Key key, @required this.arguments}) : super(key: key);

  @override
  _SocietePageState createState() => _SocietePageState();
}

class _SocietePageState extends State<SocietePage>
    with TickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool editMode = true;
  bool modification = false;

  bool _clientFournBool = false;

  bool finishedLoading = false;

  String appBarTitle = "Tiers";

  List<String> _statutItems = [
    "M.",
    "Mlle.",
    "Mme.",
    "Dr.",
    "Pr.",
    "EURL.",
    "SARL.",
    "SPA.",
    "EPIC.",
    "ETP."
  ];
  List<DropdownMenuItem<String>> _statutDropdownItems;
  String _selectedStatut;

  List<int> _tarificationItems = [1, 2, 3];
  List<DropdownMenuItem<int>> _tarificationDropdownItems;
  int _selectedTarification;

  List<Object> _familleItems;
  List<DropdownMenuItem<Object>> _familleDropdownItems;
  var _selectedFamille;

  bool price2 = Prefs.PriceCount > 1;
  bool price3 = Prefs.PriceCount > 2;
  bool _validateRaison = false;

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

  var _famille = new TiersFamille.init();

  File _itemImage;

  final picker = ImagePicker();

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
    _familleItems = await _queryCtr.getAllTierFamilles();
    _familleDropdownItems = utils.buildDropFamilleTier(_familleItems);
    _statutDropdownItems = utils.buildDropStatutTier(_statutItems);
    _tarificationDropdownItems = utils.buildDropTarificationTier(_tarificationItems);

    _selectedStatut = _statutItems[0];
    _selectedTarification = _tarificationItems[0];
    _selectedFamille = _familleItems[0];

    if (widget.arguments.id != null && widget.arguments.id > -1) {
      editMode = false;
      modification = true;
      await setDataFromItem(widget.arguments);
    } else {
      await setDataFromItem(await _queryCtr.getTestTier());
      editMode = true;
    }

    return Future<bool>.value(editMode);
  }

  Future choiceImageCam(String type, setState) async {
    var pickedImage = await picker.getImage(source: ImageSource.camera);
    switch (type) {
      case "mainImage":
        setState(() {
          if (pickedImage != null) {
            _itemImage = File(pickedImage.path);
          } else {
            _itemImage = null;
          }
        });
        break;
      default:
    }
  }

  Future choiceImageGal(String type, setState) async {
    var pickedImage = await picker.getImage(source: ImageSource.gallery);
    switch (type) {
      case "mainImage":
        setState(() {
          if (pickedImage != null) {
            _itemImage = File(pickedImage.path);
          } else {
            _itemImage = null;
          }
        });
        break;
      default:
    }
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
      return DefaultTabController(
          length: 2,
          child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: Color(0xFFF1F8FA),
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(editMode && modification? Icons.cancel: Icons.arrow_back, size: 25),
                  onPressed: () => {
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
                ),
                title: Text(appBarTitle),
                backgroundColor: editMode ? Colors.green : Colors.blue,
                centerTitle: true,
                bottom: TabBar(
                  tabs: [
                    Tab(
                      icon: Icon(Icons.insert_drive_file),
                      text: 'Fiche',
                    ),
                    Tab(
                      icon: Icon(Icons.image),
                      text: 'Photo',
                    ),
                  ],
                ),
                actions: [
                  editMode
                      ? IconButton(
                      icon: Icon(Icons.save),
                      onPressed: () async {
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
                              context, "Please enter Tier Raison sociale");

                          setState(() {
                            _validateRaison = true;
                          });
                        }
                      })
                      : IconButton(
                      icon: Icon(Icons.mode_edit),
                      onPressed: () {
                        setState(() {
                          editMode = true;
                        });
                      })
                ],
              ),
              body: Builder(
                builder: (context) => TabBarView(
                  children: [
                    fichetab(),
                    imageTab(),
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
            controller: _qrCodeControl,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              prefixIcon: Icon(
                MdiIcons.qrcode,
                color: Colors.blue[700],
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[700]),
                  borderRadius: BorderRadius.circular(20)),
              labelText: "QR Code",
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
            keyboardType: TextInputType.number,
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
            keyboardType: TextInputType.number,
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
            keyboardType: TextInputType.number,
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
            controller: _villeControl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.add_location,
                color: Colors.blue[700],
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[700]),
                  borderRadius: BorderRadius.circular(20)),
              labelText: "Code postal",
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
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.add_location,
                color: Colors.blue[700],
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[700]),
                  borderRadius: BorderRadius.circular(20)),
              labelText: "Wilaya",
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
            keyboardType: TextInputType.number,
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
            keyboardType: TextInputType.number,
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
            controller: _emailControl,
            keyboardType: TextInputType.number,
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
            controller: _emailControl,
            keyboardType: TextInputType.number,
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
            controller: _emailControl,
            keyboardType: TextInputType.number,
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
            controller: _emailControl,
            keyboardType: TextInputType.number,
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
            controller: _emailControl,
            keyboardType: TextInputType.number,
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
            controller: _emailControl,
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
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(padding: EdgeInsets.all(20)),
          Container(
            height: 400.0,
            width: 400.0,
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: _itemImage == null
                ? Center(child: Text("Ajouter une image"))
                : Image.file(
              _itemImage,
              fit: BoxFit.contain,
              height: 200,
            ),
          ),
          editMode
              ? Container(
            padding: const EdgeInsets.fromLTRB(5, 10, 10, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new IconButton(
                  color: Colors.black,
                  icon: new Icon(
                    Icons.photo_camera,
                    size: 30,
                    color: Colors.blue[700],
                  ),
                  onPressed: editMode
                      ? () {
                    choiceImageCam("mainImage", setState);
                  }
                      : null,
                ),
                new IconButton(
                  color: Colors.black,
                  icon: new Icon(
                    Icons.photo_library,
                    size: 30,
                    color: Colors.blueGrey,
                  ),
                  onPressed: editMode
                      ? () {
                    choiceImageGal("mainImage", setState);
                  }
                      : null,
                ),
              ],
            ),
          )
              : SizedBox(
            width: 5,
          ),

          //Padding(padding: EdgeInsets.all(10)),
        ]),
      ),
    );
  }

  Widget dropdowns() {
    return Center(
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        direction: Axis.horizontal,
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: editMode? new BoxDecoration(
              border: Border.all(color: Colors.blueAccent,),
              borderRadius: BorderRadius.circular(20.0),
            ) : null,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Object>(
                  disabledHint: Text(_selectedFamille.libelle),
                  icon: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: editMode
                          ? () async {
                        await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return addArticleDialog();
                            }).then((val) {
                          setState(() {});
                        });
                      }
                          : null),
                  value: _selectedFamille,
                  items: _familleDropdownItems,
                  onChanged: editMode
                      ? (value) {
                    setState(() {
                      _selectedFamille = value;
                    });
                  }
                      : null),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(3),
            decoration: editMode? new BoxDecoration(
              border: Border.all(color: Colors.blueAccent,),
              borderRadius: BorderRadius.circular(20.0),
            ) : null,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Tarification:  ",style: TextStyle(fontSize: 16, color: editMode? Colors.black: Colors.black54)),
                DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                      disabledHint: Text(_selectedTarification.toString()),
                      value: _selectedTarification,
                      items: _tarificationDropdownItems,
                      onChanged: editMode
                          ? (value) {
                        setState(() {
                          _selectedTarification = value;
                        });
                      }
                          : null),),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget addArticleDialog(){
    return ItemsSliverList(dataSource: _dataSource);
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
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Text(
                              "Ajouter une famille",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 5, right: 5, bottom: 20, top: 20),
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
                          padding: EdgeInsets.only(right: 0, left: 0),
                          child: RaisedButton(
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
                                  'Famille Ajoutée',
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
                              "Ajouter",
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
    _raisonSocialeControl.text = item.raisonSociale;
    _qrCodeControl.text = item.qrCode;

    _adresseControl.text = item.adresse;

    _villeControl.text = item.ville;
    _telephoneControl.text = item.telephone;
    _mobileControl.text = item.mobile;
    _faxControl.text = item.fax;
    _emailControl.text = item.email;
    _solde_departControl.text = item.solde_depart.toString();
    _chiffre_affairesControl.text = item.chiffre_affaires.toString();
    _reglerControl.text = item.regler.toString();
    _creditControl.text = item.credit.toString();

    _itemImage = await Helpers.getFileFromUint8List(item.imageUint8List);

    _selectedFamille = _familleItems[item.id_famille];
    _selectedStatut = _statutItems[item.statut];
    _selectedTarification = _tarificationItems[item.tarification];
  }

  Future<void> addFamilleIfNotExist(famille) async {
    int familleIndex = _familleItems.indexOf(famille);
    if (familleIndex > -1) {
      _selectedFamille = _familleItems[familleIndex];
    } else {
      int id = await _queryCtr
          .addItemToTable(DbTablesNames.tiersFamille, famille);
      famille.id = id;

      _familleItems.add(famille);
      _familleDropdownItems = utils.buildDropFamilleTier(_familleItems);
      _selectedFamille = _familleItems[_familleItems.length];
    }
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
}
