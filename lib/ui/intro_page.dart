import 'dart:convert';
import 'dart:typed_data';

import 'package:currency_pickers/country.dart';
import 'package:currency_pickers/currency_picker_dialog.dart';
import 'package:currency_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/Helpers/country_utils.dart';
import 'package:gestmob/models/MyParams.dart';
import 'package:gestmob/models/Profile.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:gestmob/Widgets/utils.dart' as utils;
import 'package:gestmob/generated/l10n.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ntp/ntp.dart';
import 'dart:io';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  String _selectedLanguage;
  List<DropdownMenuItem<String>> _languages;

  List<String> _countries = ["${S.current.selec_pays}"];
  String _selectedCountry = S.current.selec_pays ;
  String _countryname ;
  String _currencycode;

  List<String> _cities = ["${S.current.choix_city}"];
  String _selectedCity = S.current.choix_city;

  List<String> _provinces = ["${S.current.choix_province}"];
  String _selectedProvince =S.current.choix_province;

  String defaultLocale = Platform.localeName;

  TextEditingController _raisonSocialeControl = new TextEditingController();
  TextEditingController _mobileControl = new TextEditingController();
  TextEditingController _activiteControl = new TextEditingController();
  TextEditingController _adresseControl = new TextEditingController();
  TextEditingController _rcControl = new TextEditingController();
  TextEditingController _nifControl = new TextEditingController();

  List<DropdownMenuItem<String>> _statutDropdownItems;
  String _selectedStatut;

  MyParams _myParams;
  Profile _profile;
  QueryCtr _queryCtr = new QueryCtr();

  SharedPreferences _prefs;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    futureInit();
  }


  Future futureInit() async {
    _languages = utils.buildDropLanguageDownMenuItems(Statics.languages);
    switch(defaultLocale.substring(0,(2))){
      case "en":
        _selectedLanguage = Statics.languages[0];
        break;
      case "fr":
        _selectedLanguage = Statics.languages[1];
        break;
      case "ar":
        _selectedLanguage = Statics.languages[2];
        break;
      default :
        _selectedLanguage = Statics.languages[0];
        break;
    }
    getCounty();
    _countryname = "United States" ;
    _currencycode = "USD";
    _prefs = await SharedPreferences.getInstance();
  }

  Future getResponse() async {
    var res = await rootBundle.loadString(
        'assets/data/country.json');
    return jsonDecode(res);
  }

  Future getCounty() async {
    var countryres = await getResponse() as List;
    countryres.forEach((data) {
      var model = CountryModel();
      model.name = data['name'];
      if (!mounted) return;
      setState(() {
        _countries.add(model.name);
      });
    });

    return _countries;
  }

  Future getProvince() async {
    var response = await getResponse();

    var takeProvince = response
        .map((map) => CountryModel.fromJson(map))
        .where((item) => item.name == _selectedCountry)
        .map((item) => item.province)
        .toList();

    var provinces = takeProvince as List;
    provinces.forEach((f) {
      if (!mounted) return;
      setState(() {
        var name = f.map((item) => item.name).toList();
        for (var statename in name) {
          _provinces.add(statename.toString());
        }
      });
    });

    return _provinces;
  }

  Future getCity() async {
    var response = await getResponse();
    var takestate = response
        .map((map) => CountryModel.fromJson(map))
        .where((item) => item.name == _selectedCountry)
        .map((item) => item.province)
        .toList();
    var states = takestate as List;
    states.forEach((f) {
      var name = f.where((item) => item.name == _selectedProvince);
      var cityname = name.map((item) => item.city).toList();
      cityname.forEach((ci) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        pages: _getPageViews(context),
        next: const Icon(Icons.navigate_next),
        done: Text(S.current.start , style: TextStyle(fontWeight: FontWeight.w600)),
        onDone: () async {
          if(_formKey.currentState.validate()){
            await saveConfig().then((value) => Phoenix.rebirth(context));
          } else {
            Helpers.showFlushBar(context, "${S.current.msg_champs_obg}");
          }
        },
        dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            color: Colors.black26,
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0))),
      ),
    );
  }

  List<PageViewModel> _getPageViews(context) {
    return <PageViewModel>[
      PageViewModel(
        titleWidget: Container(
          margin: EdgeInsets.only(top: 100),
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Image.asset("assets/planet.png", height: 150),
              SizedBox(
                height: 30,
              ),
              Text(
                S.current.intro_select_lang ,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        bodyWidget: Container(
          margin: EdgeInsetsDirectional.only(start: 25 , end: 25),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.blueAccent,
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Row(
            children: [
              Icon(
                Icons.language,
                color: Theme.of(context).accentColor,
              ),
              Expanded(
                child: Center(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                        disabledHint: Text(S.current.param_lang_title),
                        value: _selectedLanguage,
                        items: _languages,
                        onChanged: (value) {
                          setState(() {
                            _selectedLanguage = value;
                            switch (_selectedLanguage) {
                              case ("English (ENG)"):
                                S.load(Locale("en"));
                                break;
                              case ("French (FR)"):
                                S.load(Locale("fr"));
                                break;

                              case ("Arabic (AR)"):
                                S.load(Locale("ar"));
                                break;
                            }
                          });
                        }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      PageViewModel(
        titleWidget: Container(
          margin: EdgeInsets.only(top: 50),
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    "assets/map_pin.png",
                    height: 150,
                  )),
              SizedBox(
                height: 30,
              ),
              Text(
                S.current.intro_select_region,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        bodyWidget: Column(
          children: [
            Container(
              margin: EdgeInsetsDirectional.only(start: 25 , end: 25),
              width: 300,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blueAccent,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child:  Row(
                  children: [
                    Icon(
                      Icons.pin_drop,
                      color: Theme.of(context).accentColor,
                    ),
                    SizedBox(width: 5,),
                    Container(
                      width: 200,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child:  DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              items: _countries.map((String dropDownStringItem) {
                                return DropdownMenuItem<String>(
                                  value: dropDownStringItem,
                                  child: Text(dropDownStringItem,),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (!mounted) return;
                                setState(() {
                                  _selectedProvince = S.current.choix_province;
                                  _provinces = ["${S.current.choix_province}"];
                                  _selectedCountry = value;
                                  getProvince();
                                });
                              },
                              value: _selectedCountry,
                            ),
                          ),
                        ),
                    ),
                  ],
                ),
            ),
            SizedBox(height: 10,),
            Container(
              margin: EdgeInsetsDirectional.only(start: 25 , end: 25),
              padding: const EdgeInsets.all(8),
              width: 300,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blueAccent,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                  children: [
                    Icon(
                      Icons.pin_drop,
                      color: Theme.of(context).accentColor,
                    ),
                     SizedBox(width: 5,),
                     Container(
                        width: 200,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                items: _provinces.map((String dropDownStringItem) {
                                  return DropdownMenuItem<String>(
                                    value: dropDownStringItem,
                                    child: Text(dropDownStringItem,),
                                  );
                                }).toList(),
                                onChanged: (value){
                                  if (!mounted) return;
                                  setState(() {
                                    _selectedProvince = value;
                                    _cities = ["${S.current.choix_city}"];
                                    _selectedCity = "${S.current.choix_city}" ;
                                    getCity();
                                  });
                                },
                                value: _selectedProvince,
                              ),
                            ),
                          ),
                      ),

                  ],
                ),
            ),
            SizedBox(height: 10,),
            Container(
              margin: EdgeInsetsDirectional.only(start: 25 , end: 25),
              padding: const EdgeInsets.all(8),
              width: 300,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blueAccent,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.pin_drop,
                    color: Theme.of(context).accentColor,
                  ),
                  SizedBox(width: 5,),
                  Container(
                    width: 200,
                    child: SingleChildScrollView(
                      child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            items: _cities.map((String dropDownStringItem) {
                              return DropdownMenuItem<String>(
                                value: dropDownStringItem,
                                child: Text(dropDownStringItem),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (!mounted) return;
                              setState(() {
                                _selectedCity = value;
                              });
                            },
                            value: _selectedCity,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            InkWell(
              onTap: () async {
                await showDialog(
                  context: context,
                  builder: (context) => CurrencyPickerDialog(
                    titlePadding: EdgeInsets.all(10.0),
                    searchInputDecoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(20)),
                      contentPadding:
                      EdgeInsets.only(left: 20, top: 20, bottom: 20),
                      labelText: S.current.devise,
                      alignLabelWithHint: true,
                      hintText: S.current.msg_search,
                      enabledBorder: OutlineInputBorder(
                        gapPadding: 3.3,
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.blue[600]),
                      ),
                    ),
                    isSearchable: true,
                    title: Text('${S.current.select_devise}'),
                    itemBuilder: _countryDialog,
                    onValuePicked: (Country country) {
                      setState(() {
                        _countryname = country.name ;
                        _currencycode = country.currencyCode;
                      });
                    },
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsetsDirectional.only(
                    start: 8, end: 8, top: 20.5, bottom: 20.5),
                margin: EdgeInsetsDirectional.only(start: 25 , end: 25),
                width: 300,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blueAccent,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.monetization_on,
                      color: Theme.of(context).accentColor,
                    ),
                    SizedBox(width: 5,),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                            "${_currencycode} (${_countryname})",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      PageViewModel(
          titleWidget: Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Image.asset("assets/edit_pen.png", height: 150),
                SizedBox(
                  height: 30,
                ),
                Text(
                  S.current.intro_infor,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          bodyWidget: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsetsDirectional.only(start:25 ,end: 25),
                  child: TextFormField(
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
                        color: Theme.of(context).accentColor,
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(20)),
                      enabledBorder: OutlineInputBorder(
                        gapPadding: 3.3,
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsetsDirectional.only(start: 25 ,end: 25),
                  child: TextFormField(
                    controller: _activiteControl,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: S.current.activite,
                      prefixIcon: Icon(
                        Icons.local_activity,
                        color: Theme.of(context).accentColor,
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(20)),
                      enabledBorder: OutlineInputBorder(
                        gapPadding: 3.3,
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsetsDirectional.only(start: 25 ,end: 25),
                  child: TextFormField(
                    controller: _mobileControl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: S.current.telephone,
                      prefixIcon: Icon(
                        Icons.phone_enabled,
                        color: Theme.of(context).accentColor,
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(20)),
                      enabledBorder: OutlineInputBorder(
                        gapPadding: 3.3,
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsetsDirectional.only(start: 25 ,end: 25),
                  child: TextFormField(
                    controller: _adresseControl,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: S.current.adresse,
                      prefixIcon: Icon(
                        Icons.map,
                        color: Theme.of(context).accentColor,
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(20)),
                      enabledBorder: OutlineInputBorder(
                        gapPadding: 3.3,
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsetsDirectional.only(start: 25 ,end: 25),
                  child: TextFormField(
                    controller: _rcControl,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: S.current.rc,
                      prefixIcon: Icon(
                        Icons.backup_table_outlined,
                        color: Theme.of(context).accentColor,
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(20)),
                      enabledBorder: OutlineInputBorder(
                        gapPadding: 3.3,
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsetsDirectional.only(start: 25 ,end: 25),
                  child: TextFormField(
                    controller: _nifControl,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: S.current.nif,
                      prefixIcon: Icon(
                        Icons.list_alt_outlined,
                        color: Theme.of(context).accentColor,
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(20)),
                      enabledBorder: OutlineInputBorder(
                        gapPadding: 3.3,
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    ];
  }

  Widget _countryDialog(Country country) {
    return Row(
      children: <Widget>[
        CurrencyPickerUtils.getDefaultFlagImage(country),
        SizedBox(width: 8.0),
        Text("(${country.currencyCode})"),
        SizedBox(width: 8.0),
        Flexible(child: Text(country.name))
      ],
    );
  }

//  *******************************************************************************************************************************************************************************
//****************************************************************************save config*******************************************************************************************

  Future saveConfig() async {

    try{
      DateTime startDate = await getDateFromServer();
      Uint8List image01 = await Helpers.getDefaultImageUint8List(from: "profile");
      var country = (_countries.indexOf(_selectedCountry) == 0)? _countryname : _selectedCountry ;
      var province = (_provinces.indexOf(_selectedProvince) == 0)? null : _selectedProvince ;
      var city = (_cities.indexOf(_selectedCity) == 0)? null : _selectedCity ;

      _myParams = new MyParams(
          1,
          2,
          false,
          false,
          1,
          true,
          PaperSize.mm80,
          true,
          "9:01",
          0,
          0,
          country,
          _currencycode,
          "beta",
          startDate,
          'illimit');


      _profile = new Profile(
          1,
          image01,
          "_codepin",
          _raisonSocialeControl.text,
          5,
          _adresseControl.text,
          "_addressWeb",
          "${province.split(' ').first}",
          "${city}",
          "${_countryname}",
          "_cp",
          _mobileControl.text,
          "_telephone2",
          "_fax",
          "_mobile1",
          "_mobile2",
          "_email",
          "_site",
          _rcControl.text,
          _nifControl.text,
          "_ai",
          0.0,
          _activiteControl.text,
          "_nis",
          "_codedouane",
          "_maposition",
          false);
      _prefs.setInt("intro", 0);

      switch (_selectedLanguage) {
        case ("English (ENG)"):
          _prefs.setString("myLocale", "en");
          break;
        case ("French (FR)"):
          _prefs.setString("myLocale", "fr");
          break;

        case ("Arabic (AR)"):
          _prefs.setString("myLocale", "ar");
          break;
      }

      await _queryCtr.updateItemInDb(DbTablesNames.myparams, _myParams);
      await _queryCtr.updateItemInDb(DbTablesNames.profile, _profile);
      
    }catch(error){
      print('error network');
      var message = "Error, Verify network connexion or system date" ;
      Helpers.showToast(message);
    }
    
  }

  Future getDateFromServer()async {
    DateTime startDate = await NTP.now();
    return startDate ;
  }
}
