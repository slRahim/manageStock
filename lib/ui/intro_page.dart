import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/Helpers/country_utils.dart';
import 'package:gestmob/Helpers/curency/countries.dart';
import 'package:gestmob/Helpers/curency/country.dart';
import 'package:gestmob/Helpers/curency/currency_picker_dialog.dart';
import 'package:gestmob/Helpers/curency/utils/utils.dart';
import 'package:gestmob/Widgets/utils.dart' as utils;
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/ArticleTva.dart';
import 'package:gestmob/models/ChargeTresorie.dart';
import 'package:gestmob/models/CompteTresorie.dart';
import 'package:gestmob/models/MyParams.dart';
import 'package:gestmob/models/Profile.dart';
import 'package:gestmob/services/push_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gestmob/models/Tiers.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  String _selectedLanguage;
  List<DropdownMenuItem<String>> _languages;

  List<CountryModel> _countries = [
    CountryModel.init(name: "${S.current.selec_pays}")
  ];
  String _selectedCountry = S.current.selec_pays;
  String _countryname;
  String _currencycode;

  List<String> _cities = ["${S.current.choix_city}"];
  String _selectedCity = S.current.choix_city;

  List<String> _states = ["${S.current.choix_province}"];
  String _selectedState = S.current.choix_province;

  String defaultLocale = Platform.localeName;

  TextEditingController _raisonSocialeControl = new TextEditingController();
  TextEditingController _telephoneControl = new TextEditingController();
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
    switch (defaultLocale.substring(0, (2))) {
      case "en":
        _selectedLanguage = Statics.languages[0];
        S.load(Locale("en")).then((value) {
          _countries[0].name = "${S.current.selec_pays}";
          _selectedCountry = "${S.current.selec_pays}";
          _cities[0] = "${S.current.choix_city}";
          _selectedCity = S.current.choix_city;
          _states[0] = "${S.current.choix_province}";
          _selectedState = S.current.choix_province;
        });
        break;
      case "fr":
        _selectedLanguage = Statics.languages[1];
        S.load(Locale("fr")).then((value) {
          _countries[0].name = "${S.current.selec_pays}";
          _selectedCountry = S.current.selec_pays;
          _cities[0] = "${S.current.choix_city}";
          _selectedCity = S.current.choix_city;
          _states[0] = "${S.current.choix_province}";
          _selectedState = S.current.choix_province;
        });

        break;
      case "ar":
        S.load(Locale("ar")).then((value) {
          _selectedLanguage = Statics.languages[2];
          _countries[0].name = "${S.current.selec_pays}";
          _selectedCountry = S.current.selec_pays;
          _cities[0] = "${S.current.choix_city}";
          _selectedCity = S.current.choix_city;
          _states[0] = "${S.current.choix_province}";
          _selectedState = S.current.choix_province;
        });

        break;
      default:
        _selectedLanguage = Statics.languages[0];
        S.load(Locale("en"));
        break;
    }
    getCounty();
    _countryname = "United States of America";
    _currencycode = "USD";
    _prefs = await SharedPreferences.getInstance();
  }

  Future getResponse() async {
    var res = await rootBundle.loadString('assets/data/country.json');
    return jsonDecode(res);
  }

  Future getCounty() async {
    var countryres = await getResponse() as List;
    countryres.forEach((data) {
      var model = CountryModel.fromJson(data);
      if (!mounted) return;

      switch (_selectedLanguage) {
        case "Français (FR)":
          model.name = model.translations.fr;
          break;
        case "عربية (AR)":
          model.name = model.translations.fa;
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

    var states = takeState;
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

    var states = takestate;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        pages: _getPageViews(context),
        next: const Icon(Icons.navigate_next),
        done: Text(S.current.start,
            style: GoogleFonts.lato(
                textStyle: TextStyle(fontWeight: FontWeight.w600))),
        onDone: () async {
          if (_formKey.currentState.validate()) {
            await saveConfig().then((value) => Phoenix.rebirth(context));
          } else {
            Helpers.showToast("${S.current.msg_champs_obg}");
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
                S.current.intro_select_lang,
                style: GoogleFonts.lato(
                    textStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
        bodyWidget: Container(
          margin: EdgeInsetsDirectional.only(start: 25, end: 25),
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
                        disabledHint: Text(
                          S.current.param_lang_title,
                          style: GoogleFonts.lato(),
                        ),
                        value: _selectedLanguage,
                        items: _languages,
                        onChanged: (value) {
                          setState(() {
                            _selectedLanguage = value;
                            switch (_selectedLanguage) {
                              case ("English (ENG)"):
                                S.load(Locale("en")).then((value) {
                                  _countries.clear();
                                  _countries.add(CountryModel.init(
                                      name: "${S.current.selec_pays}"));
                                  _selectedCountry = S.current.selec_pays;
                                  getCounty();

                                  _cities.clear();
                                  _cities.add("${S.current.choix_city}");
                                  _selectedCity = S.current.choix_city;

                                  _states.clear();
                                  _states.add("${S.current.choix_province}");
                                  _selectedState = S.current.choix_province;
                                });
                                break;
                              case ("Français (FR)"):
                                S.load(Locale("fr")).then((value) {
                                  _countries.clear();
                                  _countries.add(CountryModel.init(
                                      name: "${S.current.selec_pays}"));
                                  _selectedCountry = S.current.selec_pays;
                                  getCounty();

                                  _cities.clear();
                                  _cities.add("${S.current.choix_city}");
                                  _selectedCity = S.current.choix_city;

                                  _states.clear();
                                  _states.add("${S.current.choix_province}");
                                  _selectedState = S.current.choix_province;
                                });
                                break;

                              case ("عربية (AR)"):
                                S.load(Locale("ar")).then((value) {
                                  _countries.clear();
                                  _countries.add(CountryModel.init(
                                      name: "${S.current.selec_pays}"));
                                  _selectedCountry = S.current.selec_pays;
                                  getCounty();

                                  _cities.clear();
                                  _cities.add("${S.current.choix_city}");
                                  _selectedCity = S.current.choix_city;

                                  _states.clear();
                                  _states.add("${S.current.choix_province}");
                                  _selectedState = S.current.choix_province;
                                });
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
                style: GoogleFonts.lato(
                    textStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
        bodyWidget: Column(
          children: [
            Container(
              margin: EdgeInsetsDirectional.only(start: 25, end: 25),
              width: 300,
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
                    Icons.pin_drop,
                    color: Theme.of(context).accentColor,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: 200,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCountry,
                          items: _countries.map((item) {
                            return DropdownMenuItem<String>(
                              value: item.name,
                              child: Text(
                                "${item.name}",
                                style: GoogleFonts.lato(),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (!mounted) return;
                            setState(() {
                              _selectedCountry = value;
                              _selectedState = S.current.choix_province;
                              _states = ["${S.current.choix_province}"];
                              _cities = ["${S.current.choix_city}"];
                              _selectedCity = S.current.choix_city;
                              getStates();
                              String iso3Code = _countries
                                  .where(
                                      (item) => item.name == _selectedCountry)
                                  .toList()
                                  .first
                                  .iso3;
                              var country = countryList
                                  .where(
                                      (element) => element.iso3Code == iso3Code)
                                  .toList();
                              _countryname = country.first.name;
                              _currencycode = country.first.currencyCode;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsetsDirectional.only(start: 25, end: 25),
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
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: 200,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          items: _states.map((String dropDownStringItem) {
                            return DropdownMenuItem<String>(
                              value: dropDownStringItem,
                              child: Text(
                                dropDownStringItem,
                                style: GoogleFonts.lato(),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (!mounted) return;
                            setState(() {
                              _selectedState = value;
                              _cities = ["${S.current.choix_city}"];
                              _selectedCity = "${S.current.choix_city}";
                              getCity();
                            });
                          },
                          value: _selectedState,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsetsDirectional.only(start: 25, end: 25),
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
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: 200,
                    child: SingleChildScrollView(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          items: _cities.map((String dropDownStringItem) {
                            return DropdownMenuItem<String>(
                              value: dropDownStringItem,
                              child: Text(
                                dropDownStringItem,
                                style: GoogleFonts.lato(),
                              ),
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
            SizedBox(
              height: 10,
            ),
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
                      labelStyle: GoogleFonts.lato(),
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
                        _countryname = country.name;
                        _currencycode = country.currencyCode;
                      });
                    },
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsetsDirectional.only(
                    start: 8, end: 8, top: 20.5, bottom: 20.5),
                margin: EdgeInsetsDirectional.only(start: 25, end: 25),
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
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          "$_currencycode ($_countryname)",
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(fontSize: 18)),
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
                  style: GoogleFonts.lato(
                      textStyle:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
          bodyWidget: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsetsDirectional.only(start: 25, end: 25),
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
                      labelStyle: GoogleFonts.lato(),
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
                  margin: EdgeInsetsDirectional.only(start: 25, end: 25),
                  child: TextFormField(
                    controller: _activiteControl,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: S.current.activite,
                      labelStyle: GoogleFonts.lato(),
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
                  margin: EdgeInsetsDirectional.only(start: 25, end: 25),
                  child: TextFormField(
                    controller: _telephoneControl,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: S.current.telephone,
                      labelStyle: GoogleFonts.lato(),
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
                  margin: EdgeInsetsDirectional.only(start: 25, end: 25),
                  child: TextFormField(
                    controller: _adresseControl,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelStyle: GoogleFonts.lato(),
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
                  margin: EdgeInsetsDirectional.only(start: 25, end: 25),
                  child: TextFormField(
                    controller: _rcControl,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelStyle: GoogleFonts.lato(),
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
                  margin: EdgeInsetsDirectional.only(start: 25, end: 25),
                  child: TextFormField(
                    controller: _nifControl,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: S.current.nif,
                      labelStyle: GoogleFonts.lato(),
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
        Text(
          "(${country.currencyCode})",
          style: GoogleFonts.lato(),
        ),
        SizedBox(width: 8.0),
        Flexible(
            child: Text(
          country.name,
          style: GoogleFonts.lato(),
        ))
      ],
    );
  }

//  *******************************************************************************************************************************************************************************
//****************************************************************************save config*******************************************************************************************

  Future saveConfig() async {
    Uint8List image01 = await Helpers.getDefaultImageUint8List(from: "profile");
    var country =
        (_countries.first.name == _selectedCountry) ? '' : _selectedCountry;
    var province = (_states.indexOf(_selectedState) == 0) ? '' : _selectedState;
    var city = (_cities.indexOf(_selectedCity) == 0) ? '' : _selectedCity;

    _myParams = new MyParams(
        1,
        2,
        false,
        false,
        true,
        1,
        true,
        PaperSize.mm80,
        true,
        "9:01",
        0,
        0,
        _countryname,
        _currencycode,
        "demo",
        DateTime.now(),
        'mensuel');

    _profile = new Profile(
        1,
        image01,
        "",
        _raisonSocialeControl.text.trim(),
        5,
        _adresseControl.text.trim(),
        "",
        city,
        province,
        country,
        "",
        _telephoneControl.text.trim(),
        "",
        "",
        "",
        "",
        "",
        "",
        _rcControl.text.trim(),
        _nifControl.text.trim(),
        "",
        0.0,
        _activiteControl.text.trim(),
        "",
        "",
        "",
        false);

    _prefs.setInt("intro", 0);
    PushNotificationsManager.of(context).onMyParamsChange(_myParams);
    PushNotificationsManager.of(context).onProfileChange(_profile);
    switch (_selectedLanguage) {
      case ("English (ENG)"):
        _prefs.setString("myLocale", "en");
        break;
      case ("Français (FR)"):
        _prefs.setString("myLocale", "fr");
        break;

      case ("عربية (AR)"):
        _prefs.setString("myLocale", "ar");
        break;
    }

    await _queryCtr.updateItemInDb(DbTablesNames.myparams, _myParams);
    await _queryCtr.updateItemInDb(DbTablesNames.profile, _profile);
    await configTva();
    await initData();
  }

  Future configTva() async {
    List<ArticleTva> list = new List<ArticleTva>();
    switch (_countryname) {
      case 'Algeria':
        list.add(ArticleTva(0.0));
        list.add(ArticleTva(9.0));
        list.add(ArticleTva(19.0));
        break;
      case 'France':
        list.add(ArticleTva(0.0));
        list.add(ArticleTva(2.1));
        list.add(ArticleTva(5.5));
        list.add(ArticleTva(10.0));
        list.add(ArticleTva(20.0));
        break;
      case 'United State of America':
        list.add(ArticleTva(0.0));
        list.add(ArticleTva(4.35));
        list.add(ArticleTva(5.43));
        list.add(ArticleTva(5.47));
        list.add(ArticleTva(5.5));
        list.add(ArticleTva(7.0));
        list.add(ArticleTva(8.91));
        list.add(ArticleTva(9.26));
        list.add(ArticleTva(9.45));
        break;
      case 'Tunisia':
        list.add(ArticleTva(0.0));
        list.add(ArticleTva(6.0));
        list.add(ArticleTva(12.0));
        list.add(ArticleTva(18.0));
        list.add(ArticleTva(29.0));
        break;
      default:
        list.add(ArticleTva(0.0));
        list.add(ArticleTva(19.0));
        break;
    }

    list.forEach((element) async {
      await _queryCtr.addItemToTable(DbTablesNames.articlesTva, element);
    });
  }

  Future initData() async{
    Uint8List image = await Helpers.getDefaultImageUint8List(from: "tier");
    Tiers tier0 = new Tiers(image, "Unknown customer", null, 1, 0, 1, "", "","", "", "",
        "", "", "", "", "", 0.0, 0, 0, false);
    tier0.clientFour = 0;

    Tiers tier2 = new Tiers(image, "Unknown provider", null, 1, 0, 1, "", "","", "", "", "",
        "", "", "", "", 0.0, 0, 0, false);
    tier2.clientFour = 2;

    List<ChargeTresorie> charges = new List<ChargeTresorie>();
    List<CompteTresorie> comptes = new List<CompteTresorie> ();

    switch (_selectedLanguage) {
      case("English (ENG)"):
        charges.add(new ChargeTresorie(null,"Electricity"));
        charges.add(new ChargeTresorie(null,"Rent"));
        charges.add(new ChargeTresorie(null,"Salary"));
        comptes.add(new CompteTresorie(null, "00001", "Till", "0000", 0.0, 0.0));
        break;
      case ("Français (FR)"):
        charges.add(new ChargeTresorie(null,"Electricité"));
        charges.add(new ChargeTresorie(null,"Loyer"));
        charges.add(new ChargeTresorie(null,"Salaire"));
        comptes.add(new CompteTresorie(null, "00001", "Caisse", "0000", 0.0, 0.0));
        tier0.raisonSociale = "Client inconnu";
        tier2.raisonSociale = "Fournisseur inconnu";
        break;

      case ("عربية (AR)"):
        charges.add(new ChargeTresorie(null,"الكهرباء"));
        charges.add(new ChargeTresorie(null,"الإيجار"));
        charges.add(new ChargeTresorie(null,"المرتب"));
        comptes.add(new CompteTresorie(null, "00001", "الصندوق", "0000", 0.0, 0.0));
        tier0.raisonSociale = "زبون غير معرف";
        tier2.raisonSociale = "مورد غير معرف";
        break;
    }

    charges.forEach((element) async {
      await _queryCtr.addItemToTable(DbTablesNames.chargeTresorie, element);
    });
    comptes.forEach((element) async{
      await _queryCtr.addItemToTable(DbTablesNames.compteTresorie, element);
    });
    await _queryCtr.addItemToTable(DbTablesNames.tiers, tier0);
    await _queryCtr.addItemToTable(DbTablesNames.tiers, tier2);
  }


}


