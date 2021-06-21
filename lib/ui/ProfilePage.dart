import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/Widgets/CustomWidgets/add_save_bar.dart';
import 'package:gestmob/Widgets/CustomWidgets/bottom_tab_bar.dart';
import 'package:gestmob/Widgets/CustomWidgets/enterPin.dart';
import 'package:gestmob/Widgets/CustomWidgets/image_picker_widget.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/Profile.dart';
import 'package:gestmob/search/sliver_list_data_source.dart';
import 'package:gestmob/services/push_notifications.dart';
import 'package:gestmob/Widgets/utils.dart' as utils;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:gestmob/Helpers/country_utils.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:gestmob/models/MyParams.dart';

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

  List<CountryModel> _countries =[CountryModel.init(name: "${S.current.selec_pays}")];
  String  _selectedCountry = S.current.selec_pays ;

  List<String> _cities = ["${S.current.choix_city}"];
  String _selectedCity = S.current.choix_city;

  List<String> _states = ["${S.current.choix_province}"];
  String _selectedState = S.current.choix_province;

  File _itemImage;

  SliverListDataSource _dataSource;
  QueryCtr _queryCtr;
  MyParams _myParams;

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
  void didChangeDependencies() {
    PushNotificationsManagerState data = PushNotificationsManager.of(context);
    _myParams = data.myParams;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  //****************************************************************************************************************************************************************************
  //*************************************************************************partie special pour l'initialisation********************************************************************

  Future futureInitState() async {
    _statutDropdownItems = utils.buildDropStatutTier(Statics.statutItems);
    _selectedStatut = Statics.statutItems[0];
    await getCounty();
    arguments = await _queryCtr.getProfileById(1);
    if(arguments.pays != ''){
      _selectedCountry = arguments.pays ;
      getStates() ;
    }
    if(arguments.departement != ''){
      _selectedState = arguments.departement ;
      getCity() ;
    }
    if(arguments.ville != ''){
      _selectedCity =arguments.ville ;
    }

    editMode = false;
    modification = true;
    await setDataFromItem(arguments);
  }

  Future<void> setDataFromItem(Profile item) async {
    //read image
    _itemImage = await Helpers.getFileFromUint8List(item.imageUint8List);
    _raisonSocialeControl.text = item.raisonSociale;
    _selectedStatut = Statics.statutItems[item.statut];
    _activiteControl.text = item.activite;
    _adresseControl.text = item.adresse;
    _selectedState = (item.departement != '')?item.departement : _selectedState ;
    _selectedCity = (item.ville != '')? item.ville : _selectedCity;
    _selectedCountry = (item.pays != '')? item.pays : _selectedCountry;
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
    _capitalsocialControl.text = item.capital.toStringAsFixed(2);

  }

  Future getResponse() async {
    var res = await rootBundle.loadString(
        'assets/data/country.json');
    return jsonDecode(res);
  }

  Future getCounty() async {
    var countryres = await getResponse() as List;
    countryres.forEach((data) {
      var model = CountryModel.fromJson(data);
      if (!mounted) return;
      switch(Localizations.localeOf(context).languageCode){
        case "fr" :
          model.name = model.translations.fr ;
          break;
        case "ar" :
          model.name = model.translations.fa ;
          break;
      }
      setState(() {
        _countries.add(model);
      });
    });

    return _countries;
  }

  Future getStates() async {
    var takeState = _countries
        .where((item) => item.name == _selectedCountry)
        .map((item) => item.states)
        .toList();

    var states = takeState ;
    states.forEach((f) {
      if (!mounted) return;
      setState(() {
        var listStateName = f.map((item) => item.name).toList();
        for (String statename in listStateName) {
          _states.add(statename);
        }
      });
    });

    return _states;
  }

  Future getCity() async {
    var takestate = _countries
        .where((item) => item.name == _selectedCountry)
        .map((item) => item.states)
        .toList();

    var states = takestate ;
    states.forEach((f) {
      var stateName = f.where((item) => item.name == _selectedState);
      var cities = stateName.map((item) => item.cities).toList();
      cities.forEach((ci) {
        if (!mounted) return;
        setState(() {
          var citiesname = ci.map((item) => item.name).toList();
          for (var citynames in citiesname) {
            _cities.add(citynames.toString());
          }
        });
      });
    });
    return _cities;
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
        appBarTitle =  S.current.profile_titre;
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
              backgroundColor: Theme.of(context).backgroundColor,
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
                  Tab(child: Column( children: [ Icon(Icons.insert_drive_file),SizedBox(height: 1), Text( S.current.fiche,style: GoogleFonts.lato(),), ], )),
                  Tab(child: Column( children: [ Icon(Icons.image), SizedBox(height: 1), Text( S.current.logo,style: GoogleFonts.lato(),), ], )),
                  Tab(child: Column( children: [ Icon(Icons.fingerprint), SizedBox(height: 1), Text( S.current.securite,style: GoogleFonts.lato(),), ], )),
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
                    // onTap: () => _raisonSocialeControl.selection = TextSelection(baseOffset: 0, extentOffset: _raisonSocialeControl.value.text.length),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) {
                        return S.current.msg_champ_oblg;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText:  S.current.rs,
                      labelStyle: GoogleFonts.lato(textStyle: TextStyle(color: Colors.green)),
                      prefixIcon: Icon(
                        MdiIcons.idCard,
                        color: Colors.green,
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
              // onTap: () => _activiteControl.selection = TextSelection(baseOffset: 0, extentOffset: _activiteControl.value.text.length),
              keyboardType: TextInputType.text,
              // validator: (value) {
              //   if (value.isEmpty) {
              //     return S.current.msg_champ_oblg;
              //   }
              //   return null;
              // },
              decoration: InputDecoration(
                labelText:  S.current.activite,
                labelStyle: GoogleFonts.lato(textStyle: TextStyle(color: Theme.of(context).hintColor)),
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
              // onTap: () => _adresseControl.selection = TextSelection(baseOffset: 0, extentOffset: _adresseControl.value.text.length),
              keyboardType: TextInputType.text,
              // validator: (value) {
              //   if (value.isEmpty) {
              //     return S.current.msg_champ_oblg;
              //   }
              //   return null;
              // },
              decoration: InputDecoration(
                labelText:  S.current.adresse,
                labelStyle: GoogleFonts.lato(textStyle: TextStyle(color: Theme.of(context).hintColor)),
                prefixIcon: Icon(
                  Icons.home_outlined,
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
            Container(
              padding: const EdgeInsetsDirectional.only(start: 12 , end: 0 , top: 5 ,bottom: 5),
              decoration:editMode ? BoxDecoration(
                border: Border.all(
                  color: Colors.blueAccent,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ):null,
              child:  Row(
                children: [
                  Icon(
                    Icons.pin_drop,
                    color: Colors.blue,
                  ),
                  SizedBox(width: 15,),
                  Container(
                    width: 200,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child:  DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          disabledHint: Text(_selectedCountry),
                          value: _selectedCountry,
                          items: _countries.map((item) {
                            return DropdownMenuItem<String>(
                              value: item.name,
                              child: Text(item.name, style: GoogleFonts.lato(),),
                            );
                          }).toList(),
                          onChanged: editMode ? (value) {
                            if (!mounted) return;
                            setState(() {
                              _selectedCountry = value;
                              _selectedState = S.current.choix_province;
                              _states = ["${S.current.choix_province}"];
                              _cities = ["${S.current.choix_city}"];
                              _selectedCity = S.current.choix_city;
                              getStates();
                            });

                          }:null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsetsDirectional.only(start: 12 , end: 0 , top: 5 ,bottom: 5),
              decoration:editMode ? BoxDecoration(
                border: Border.all(
                  color: Colors.blueAccent,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ):null,
              child:  Row(
                children: [
                  Icon(
                    Icons.pin_drop,
                    color: Colors.blue,
                  ),
                  SizedBox(width: 15,),
                  Container(
                    width: 200,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedState,
                          disabledHint: Text(_selectedState),
                          items: _states.map((String dropDownStringItem) {
                            return DropdownMenuItem<String>(
                              value: dropDownStringItem,
                              child: Text(dropDownStringItem, style: GoogleFonts.lato(),),
                            );
                          }).toList(),
                          onChanged:editMode ? (value){
                            if (!mounted) return;
                            setState(() {
                              _selectedState = value;
                              _cities = ["${S.current.choix_city}"];
                              _selectedCity = "${S.current.choix_city}" ;
                              getCity();
                            });
                          }:null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsetsDirectional.only(start: 12 , end: 0 , top: 5 ,bottom: 5),
              decoration:editMode ? BoxDecoration(
                border: Border.all(
                  color: Colors.blueAccent,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ):null,
              child:  Row(
                children: [
                  Icon(
                    Icons.pin_drop,
                    color: Colors.blue,
                  ),
                  SizedBox(width: 15,),
                  Container(
                    width: 200,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child:DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCity,
                          disabledHint: Text(_selectedCity),
                          items: _cities.map((String dropDownStringItem) {
                            return DropdownMenuItem<String>(
                              value: dropDownStringItem,
                              child: Text(dropDownStringItem, style:GoogleFonts.lato() ,),
                            );
                          }).toList(),
                          onChanged:editMode? (value) {
                            if (!mounted) return;
                            setState(() {
                              _selectedCity = value;
                            });
                          }:null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            TextFormField(
              enabled: editMode,
              controller: _telephoneControl,
              onTap: () => _telephoneControl.selection = TextSelection(baseOffset: 0, extentOffset: _telephoneControl.value.text.length),
              keyboardType: TextInputType.phone,
              // validator: (value) {
              //   if (value.isEmpty) {
              //     return S.current.msg_champ_oblg;
              //   }
              //   return null;
              // },
              decoration: InputDecoration(
                labelText:  S.current.telephone,
                labelStyle: GoogleFonts.lato(textStyle: TextStyle(color: Theme.of(context).hintColor)),
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
              onTap: () => _telephone2Control.selection = TextSelection(baseOffset: 0, extentOffset: _telephone2Control.value.text.length),
              keyboardType: TextInputType.phone,
              // validator: (value) {
              //   if (value.isEmpty) {
              //     return S.current.msg_champ_oblg;
              //   }
              //   return null;
              // },
              decoration: InputDecoration(
                labelText:  S.current.telephone2,
                labelStyle: GoogleFonts.lato(textStyle: TextStyle(color: Theme.of(context).hintColor)),
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
              onTap: () => _mobileControl.selection = TextSelection(baseOffset: 0, extentOffset: _mobileControl.value.text.length),
              keyboardType: TextInputType.phone,
              // validator: (value) {
              //   if (value.isEmpty) {
              //     return S.current.msg_champ_oblg;
              //   }
              //   return null;
              // },
              decoration: InputDecoration(
                labelText:  S.current.mobile,
                labelStyle: GoogleFonts.lato(textStyle: TextStyle(color: Theme.of(context).hintColor)),
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
              onTap: () => _mobile2Control.selection = TextSelection(baseOffset: 0, extentOffset: _mobile2Control.value.text.length),
              keyboardType: TextInputType.phone,
              // validator: (value) {
              //   if (value.isEmpty) {
              //     return S.current.msg_champ_oblg;
              //   }
              //   return null;
              // },
              decoration: InputDecoration(
                labelText:  S.current.mobile2,
                labelStyle: GoogleFonts.lato(textStyle: TextStyle(color: Theme.of(context).hintColor)),
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
              onTap: () => _faxControl.selection = TextSelection(baseOffset: 0, extentOffset: _faxControl.value.text.length),
              keyboardType: TextInputType.phone,
              // validator: (value) {
              //   if (value.isEmpty) {
              //     return S.current.msg_champ_oblg;
              //   }
              //   return null;
              // },
              decoration: InputDecoration(
                labelText:  S.current.fax,
                labelStyle: GoogleFonts.lato(textStyle: TextStyle(color: Theme.of(context).hintColor)),
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
              // onTap: () => _emailControl.selection = TextSelection(baseOffset: 0, extentOffset: _emailControl.value.text.length),
              keyboardType: TextInputType.text,
              // validator: (value) {
              //   if (value.isEmpty) {
              //     return S.current.msg_champ_oblg;
              //   }
              //   return null;
              // },
              decoration: InputDecoration(
                labelText:  S.current.mail,
                labelStyle: GoogleFonts.lato(textStyle: TextStyle(color: Theme.of(context).hintColor)),
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
              // onTap: () => _addresseWebControl.selection = TextSelection(baseOffset: 0, extentOffset: _addresseWebControl.value.text.length),
              keyboardType: TextInputType.text,
              // validator: (value) {
              //   if (value.isEmpty) {
              //     return S.current.msg_champ_oblg;
              //   }
              //   return null;
              // },
              decoration: InputDecoration(
                labelText:  S.current.adresse_web,
                labelStyle: GoogleFonts.lato(textStyle: TextStyle(color: Theme.of(context).hintColor)),
                prefixIcon: Icon(
                  MdiIcons.searchWeb,
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
              controller: _rcControl,
              onTap: () => _rcControl.selection = TextSelection(baseOffset: 0, extentOffset: _rcControl.value.text.length),
              keyboardType: TextInputType.text,
              // validator: (value) {
              //   if (value.isEmpty) {
              //     return S.current.msg_champ_oblg;
              //   }
              //   return null;
              // },
              decoration: InputDecoration(
                labelText:  S.current.n_rc,
                labelStyle: GoogleFonts.lato(textStyle: TextStyle(color: Theme.of(context).hintColor)),
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
                errorBorder:  OutlineInputBorder(
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
                onTap: () => _aiControl.selection = TextSelection(baseOffset: 0, extentOffset: _aiControl.value.text.length),
                keyboardType: TextInputType.text,
                // validator: (value) {
                //   if (value.isEmpty) {
                //     return S.current.msg_champ_oblg;
                //   }
                //   return null;
                // },
                decoration: InputDecoration(
                  labelText:  S.current.art_imp,
                  labelStyle: GoogleFonts.lato(textStyle: TextStyle(color: Theme.of(context).hintColor)),
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
                  errorBorder:  OutlineInputBorder(
                    gapPadding: 3.3,
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
              ),
            ),
            TextFormField(
              enabled: editMode,
              controller: _nifControl,
              onTap: () => _nifControl.selection = TextSelection(baseOffset: 0, extentOffset: _nifControl.value.text.length),
              keyboardType: TextInputType.text,
              // validator: (value) {
              //   if (value.isEmpty) {
              //     return S.current.msg_champ_oblg;
              //   }
              //   return null;
              // },
              decoration: InputDecoration(
                labelText:  S.current.nif,
                labelStyle: GoogleFonts.lato(textStyle: TextStyle(color: Theme.of(context).hintColor)),
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
              onTap: () => _nisControl.selection = TextSelection(baseOffset: 0, extentOffset: _nisControl.value.text.length),
              keyboardType: TextInputType.text,
              // validator: (value) {
              //   if (value.isEmpty) {
              //     return S.current.msg_champ_oblg;
              //   }
              //   return null;
              // },
              decoration: InputDecoration(
                labelText:  S.current.nis,
                labelStyle: GoogleFonts.lato(textStyle: TextStyle(color: Theme.of(context).hintColor)),
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
              onTap: () => _capitalsocialControl.selection = TextSelection(baseOffset: 0, extentOffset: _capitalsocialControl.value.text.length),
              keyboardType: TextInputType.number,
              // validator: (value) {
              //   if (value.isEmpty) {
              //     return S.current.msg_champ_oblg;
              //   }
              //   return null;
              // },
              decoration: InputDecoration(
                labelText:  S.current.capitale_sociale,
                labelStyle: GoogleFonts.lato(textStyle: TextStyle(color: Theme.of(context).hintColor)),
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
                    Icons.security, color: Colors.blue,),
                  SizedBox(width: 13),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        arguments.codePinEnabled = !arguments.codePinEnabled;
                      },
                      child: Text( S.current.code_pin,
                        style:GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: 16,
                              color:
                              editMode ? Theme.of(context).primaryColorDark : Theme.of(context).tabBarTheme.unselectedLabelColor)
                        )
                      ),
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
          onImageChange: (File imageFile) {
            setState(() {
              _itemImage = imageFile ;
            });
          }
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
      arguments.codePinEnabled = true ;
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
          PushNotificationsManager.of(context).onProfileChange(item);
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
          PushNotificationsManager.of(context).onProfileChange(item);
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

    item.raisonSociale = _raisonSocialeControl.text.trim();
    item.statut = Statics.statutItems.indexOf(_selectedStatut);
    item.activite = (_activiteControl.text.trim() != '')? _activiteControl.text.trim() : '';
    item.adresse = (_adresseControl.text.trim() != '')?_adresseControl.text.trim() : '';
    item.departement = (_states.indexOf(_selectedState)==0)? '' : _selectedState ;
    item.ville = (_cities.indexOf(_selectedCity) == 0) ? '' :_selectedCity ;
    item.pays =( _countries.first.name == _selectedCountry) ? '' : _selectedCountry;
    item.telephone = _telephoneControl.text.trim();
    item.telephone2 = _telephone2Control.text.trim();
    item.mobile = _mobileControl.text.trim();
    item.mobile2 = _mobile2Control.text.trim();
    item.fax = _faxControl.text.trim();
    item.email = _emailControl.text.trim();
    item.addressWeb = _addresseWebControl.text.trim();
    if (_itemImage != null) {
      item.imageUint8List = await Helpers.getUint8ListFromFile(_itemImage);
    } else {
      Uint8List image = await Helpers.getDefaultImageUint8List(from: "profile");
      item.imageUint8List = image;
    }
    item.rc = (_rcControl.text.trim() != '')?_rcControl.text.trim():'';
    item.ai = _aiControl.text.trim();
    item.nif = _nifControl.text.trim();
    item.nis = _nisControl.text.trim();
    item.capital =(_capitalsocialControl.text.trim() != "")? double.tryParse(_capitalsocialControl.text.trim()):0.0;

    return item;
  }
}
