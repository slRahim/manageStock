import 'dart:typed_data';

import 'package:currency_pickers/country.dart';
import 'package:currency_pickers/currency_picker_dialog.dart';
import 'package:currency_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/models/MyParams.dart';
import 'package:gestmob/models/Profile.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:gestmob/Widgets/utils.dart' as utils;
import 'package:gestmob/generated/l10n.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ntp/ntp.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  String _selectedLanguage;
  List<DropdownMenuItem<String>> _languages;

  String _countryname;
  String _currencycode;

  TextEditingController _raisonSocialeControl = new TextEditingController();
  TextEditingController _mobileControl = new TextEditingController();
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
    _selectedLanguage = Statics.languages[0];
    _countryname = "Algeria";
    _currencycode = "DZD";
    _statutDropdownItems = utils.buildDropStatutTier(Statics.statutItems);
    _selectedStatut = Statics.statutItems[0];
    _prefs = await SharedPreferences.getInstance();
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
                S.current.intro_select_lang,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        bodyWidget: Container(
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
              SizedBox(
                width: 20,
              ),
              DropdownButtonHideUnderline(
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
            ],
          ),
        ),
      ),
      PageViewModel(
        titleWidget: Container(
          margin: EdgeInsets.only(top: 100),
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
        bodyWidget: InkWell(
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
                  labelText: S.current.pays,
                  alignLabelWithHint: true,
                  hintText: S.current.msg_search,
                  enabledBorder: OutlineInputBorder(
                    gapPadding: 3.3,
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.blue[600]),
                  ),
                ),
                isSearchable: true,
                title: Text('${S.current.selec_pays}'),
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
                  width: 20,
                ),
                Text(
                  "${_countryname}",
                  style: TextStyle(fontSize: 18),
                )
              ],
            ),
          ),
        ),
      ),
      PageViewModel(
          titleWidget: Container(
            margin: EdgeInsets.only(top: 100),
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
                TextFormField(
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
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsetsDirectional.only(
                      start: 8, end: 8, top: 4, bottom: 4),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.home_work_outlined,
                        color: Theme.of(context).accentColor,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                              disabledHint: Text(_selectedStatut),
                              value: _selectedStatut,
                              items: _statutDropdownItems,
                              onChanged: (value) {
                                setState(() {
                                  _selectedStatut = value;
                                });
                              })),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _mobileControl,
                  keyboardType: TextInputType.number,
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
          _countryname,
          _currencycode,
          "beta",
          startDate,
          'illimit');
      _profile = new Profile(
          1,
          image01,
          "_codepin",
          _raisonSocialeControl.text,
          Statics.statutItems.indexOf(_selectedStatut),
          "_adresse",
          "_addressWeb",
          "_ville",
          "_departement",
          "_pays",
          "_cp",
          "_telephone",
          "_telephone2",
          "_fax",
          _mobileControl.text,
          "_mobile2",
          "_email",
          "_site",
          "_rc",
          "_nif",
          "_ai",
          0.0,
          "_activite",
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
