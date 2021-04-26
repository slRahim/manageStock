import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/Helpers/curency/country.dart';
import 'package:gestmob/Helpers/curency/currency_picker_dialog.dart';
import 'package:gestmob/Helpers/curency/utils/utils.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/Article.dart';
import 'package:gestmob/models/HomeItem.dart';
import 'package:gestmob/models/MyParams.dart';
import 'package:gestmob/search/search_input_sliver.dart';
import 'package:gestmob/services/local_notification.dart';
import 'package:gestmob/services/push_notifications.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AddArticlePage.dart';
import 'home.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _finishedLoading = false;
  SharedPreferences _prefs;

  int _tarification;
  bool _tva;
  bool _timbre;
  bool _credit ;
  String _formatPrintDisplay ;
  String _language;
  String _themStyle ;
  bool _notifications;
  String _dayTime;
  String _countryname;
  String _currencycode;

  String _repeateNotification;
  int _echeance;

  QueryCtr _queryCtr = new QueryCtr();
  MyParams _myParams;


  @override
  Future<void> initState() {
    super.initState();
    _language = Statics.languages[0];
    futureInit().then((value) {
      setState(() {
        _finishedLoading = true;
      });
    });
  }

  Future<void> futureInit() async {
    Statics.themeStyle[0] = S.current.light_theme ;
    Statics.themeStyle[1] = S.current.dark_them ;
    Statics.themeStyle[2] = S.current.sys_theme ;

    Statics.repeateNotifications[0] = S.current.ev_day ;
    Statics.repeateNotifications[1] = S.current.ev_sun ;
    Statics.repeateNotifications[2] = S.current.ev_mon ;
    Statics.repeateNotifications[3] = S.current.ev_tue ;
    Statics.repeateNotifications[4] = S.current.ev_wedn ;
    Statics.repeateNotifications[5] = S.current.ev_thur ;
    Statics.repeateNotifications[6] = S.current.ev_fri ;
    Statics.repeateNotifications[7] = S.current.ev_sat ;

    Statics.printDisplayItems[0] = S.current.referance ;
    Statics.printDisplayItems[1] = S.current.designation ;

    _myParams = await _queryCtr.getAllParams();
    _prefs = await SharedPreferences.getInstance();
    switch (_prefs.getString("myLocale")) {
      case ("en"):
        setState(() {
          _language = Statics.languages[0];
        });
        break;
      case ("fr"):
        setState(() {
          _language = Statics.languages[1];
        });
        break;
      case ("ar"):
        setState(() {
          _language = Statics.languages[2];
        });
        break;
      default:
        setState(() {
          _language = Statics.languages[0];
        });
        break;
    }
    switch (_prefs.getString("myStyle")) {
      case ("light"):
        setState(() {
          _themStyle = Statics.themeStyle[0];
        });
        break;
      case ("dark"):
        setState(() {
          _themStyle = Statics.themeStyle[1];
        });
        break;
      case ("system"):
        setState(() {
          _themStyle = Statics.themeStyle[2];
        });
        break;
      default:
        setState(() {
          _themStyle = Statics.themeStyle[2];
        });
        break;
    }

    await setDataFromItem(_myParams);
  }

  setDataFromItem(MyParams item) async {
    _tarification = item.tarification ;
    _tva = item.tva;
    _timbre = item.timbre;
    _credit = item.creditTier ;
    _formatPrintDisplay = Statics.printDisplayItems[item.printDisplay] ;
    _notifications = item.notifications;
    _dayTime = item.notificationTime;
    _repeateNotification = Statics.repeateNotifications[item.notificationDay];
    _echeance = Statics.echeances[item.echeance];
    _countryname = item.pays ;
    _currencycode = item.devise ;
  }

  @override
  Widget build(BuildContext context) {
    if (!_finishedLoading) {
      return Scaffold(body: Helpers.buildLoading());
    } else {
      return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(S.current.settings , style: GoogleFonts.lato(fontWeight: FontWeight.bold),),
            backgroundColor: Theme.of(context).appBarTheme.color,
            centerTitle: true,
            actions: [
              IconButton(
                  icon: Icon(Icons.save, size: 25),
                  onPressed: () {
                    AwesomeDialog(
                        context: context,
                        title: "${S.current.param_save}",
                        desc: "${S.current.param_msg_save}",
                        dialogType: DialogType.QUESTION,
                        animType: AnimType.BOTTOMSLIDE,
                        btnCancelText: S.current.non,
                        btnCancelOnPress: () {
                          Navigator.pop(context);
                        },
                        btnOkText: S.current.oui,
                        btnOkOnPress: () async {
                          await _updateItem();
                        })
                      ..show();
                  }),
            ],
          ),
          body: SettingsList(
            sections: [
              SettingsSection(
                title: '${S.current.param_general}',
                titleTextStyle: GoogleFonts.lato(
                    textStyle: TextStyle(
                        color: Theme.of(context).accentColor,fontWeight: FontWeight.bold
                    )
                ),
                tiles: [
                  SettingsTile(
                    title: '${S.current.param_lang}',
                    subtitle: _language,
                    titleTextStyle:  GoogleFonts.lato(),
                    subtitleTextStyle:  GoogleFonts.lato(),
                    leading: Icon(Icons.language, color: Theme.of(context).primaryColorDark ,),
                    onTap: () async {
                      AwesomeDialog(
                          context: context,
                          dialogType: DialogType.QUESTION,
                          animType: AnimType.BOTTOMSLIDE,
                          title: "${S.current.param_lang_title}",
                          body: _languageDialog(),
                          btnCancelText: S.current.non,
                          btnCancelOnPress: () {},
                          btnOkText: S.current.oui,
                          btnOkOnPress: () async {
                            await _savelocale();
                            setState(() {
                              _language;
                              // switch (_language) {
                              //   case ("English (ENG)"):
                              //     S.load(Locale("en"));
                              //     break;
                              //   case ("French (FR)"):
                              //     S.load(Locale("fr"));
                              //     break;
                              //
                              //   case ("Arabic (AR)"):
                              //     S.load(Locale("ar"));
                              //     break;
                              // }
                            });
                          })
                        ..show();
                    },
                  ),
                  SettingsTile(
                    title: '${S.current.app_theme}',
                    subtitle: _themStyle,
                    titleTextStyle:  GoogleFonts.lato(),
                    subtitleTextStyle:  GoogleFonts.lato(),
                    leading: Icon(Icons.style_sharp, color: Theme.of(context).primaryColorDark),
                    onTap: () async {
                      AwesomeDialog(
                          context: context,
                          dialogType: DialogType.QUESTION,
                          animType: AnimType.BOTTOMSLIDE,
                          title: "${S.current.param_lang_title}",
                          body: _themStyleDialog(),
                          btnCancelText: S.current.non,
                          btnCancelOnPress: () {},
                          btnOkText: S.current.oui,
                          btnOkOnPress: () async {
                            setState(() {
                              _themStyle;
                            });
                          })
                        ..show();
                    },
                  ),
                  SettingsTile(
                    title: S.current.devise,
                    subtitle: "($_currencycode) $_countryname",
                    titleTextStyle:  GoogleFonts.lato(),
                    subtitleTextStyle:  GoogleFonts.lato(),
                    leading: Icon(Icons.monetization_on, color: Theme.of(context).primaryColorDark),
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (context) => CurrencyPickerDialog(
                                titlePadding: EdgeInsets.all(10.0),
                                searchInputDecoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.blue[600]),
                                      borderRadius: BorderRadius.circular(20)),
                                  contentPadding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
                                  labelText: S.current.devise,
                                  labelStyle: TextStyle(color: Colors.blue[600]),
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
                                    _currencycode = country.currencyCode ;
                                  });
                                },
                        ),
                      );
                    },
                  ),
                  SettingsTile(
                    title: '${S.current.tarification}',
                    subtitle:("${S.current.use} : "+_tarification.toString()),
                    titleTextStyle:  GoogleFonts.lato(),
                    subtitleTextStyle:  GoogleFonts.lato(),
                    leading: Icon(Icons.attach_money, color: Theme.of(context).primaryColorDark),
                    onTap: () async {
                      AwesomeDialog(
                          context: context,
                          dialogType: DialogType.QUESTION,
                          animType: AnimType.BOTTOMSLIDE,
                          title: "${S.current.param_lang_tarif_title}",
                          body: _tarificationDialog(),
                          btnCancelText: S.current.non,
                          btnCancelOnPress: () {},
                          btnOkText: S.current.oui,
                          btnOkOnPress: () async {
                            setState(() {
                              _tarification ;
                            });
                          })
                        ..show();
                    },
                  ),
                  SettingsTile.switchTile(
                    title: '${S.current.param_tva}',
                    titleTextStyle:  GoogleFonts.lato(),
                    subtitleTextStyle:  GoogleFonts.lato(),
                    leading: Icon(Icons.money_outlined, color: Theme.of(context).primaryColorDark),
                    switchValue: _tva,
                    onToggle: (bool value) {
                      setState(() {
                        _tva = value;
                      });
                    },
                  ),
                  SettingsTile.switchTile(
                    title: '${S.current.param_timbre}',
                    titleTextStyle:  GoogleFonts.lato(),
                    subtitleTextStyle:  GoogleFonts.lato(),
                    leading: Icon(Icons.fact_check, color: Theme.of(context).primaryColorDark),
                    switchValue: _timbre,
                    onToggle: (bool value) {
                      setState(() {
                        _timbre = value;
                      });
                    },
                  ),
                ],
              ),
              SettingsSection(
                title: '${S.current.impression_titre}',
                titleTextStyle:  GoogleFonts.lato(
                    textStyle: TextStyle(
                        color: Theme.of(context).accentColor,fontWeight: FontWeight.bold
                    )
                ),
                tiles: [
                  SettingsTile(
                    title: '${S.current.imp_affichage}',
                    subtitle:("${_formatPrintDisplay}"),
                    titleTextStyle:  GoogleFonts.lato(),
                    subtitleTextStyle:  GoogleFonts.lato(),
                    leading: Icon(Icons.list_alt_outlined, color: Theme.of(context).primaryColorDark),
                    onTap: () async {
                      AwesomeDialog(
                          context: context,
                          dialogType: DialogType.QUESTION,
                          animType: AnimType.BOTTOMSLIDE,
                          title: "${S.current.format_ticket}",
                          body: _formatPrintDialog(),
                          btnCancelText: S.current.non,
                          btnCancelOnPress: () {},
                          btnOkText: S.current.oui,
                          btnOkOnPress: () async {
                            setState(() {
                               _formatPrintDisplay;
                            });
                          })
                        ..show();
                    },
                  ),
                  SettingsTile.switchTile(
                    title: '${S.current.credit_tier}',
                    titleTextStyle:  GoogleFonts.lato(),
                    subtitleTextStyle:  GoogleFonts.lato(),
                    leading: Icon(Icons.person_sharp, color: Theme.of(context).primaryColorDark),
                    switchValue: _credit,
                    onToggle: (bool value) {
                      setState(() {
                        _credit = value;
                      });
                    },
                  ),
                ],
              ),
              SettingsSection(
                title: '${S.current.param_notif_title}',
                titleTextStyle:  GoogleFonts.lato(
                    textStyle: TextStyle(
                        color: Theme.of(context).accentColor,fontWeight: FontWeight.bold
                    )
                ),
                tiles: [
                  SettingsTile.switchTile(
                    title: '${S.current.param_notif}',
                    titleTextStyle:  GoogleFonts.lato(),
                    subtitleTextStyle:  GoogleFonts.lato(),
                    leading: Icon(Icons.notifications_active, color: Theme.of(context).primaryColorDark),
                    switchValue: _notifications,
                    onToggle: (bool value) {
                      setState(() {
                        _notifications = value;
                      });
                    },
                  ),
                  SettingsTile(
                    title: '${S.current.param_notif_time}',
                    titleTextStyle:  GoogleFonts.lato(
                        textStyle: TextStyle(
                            color: (!_notifications)
                                ? Theme.of(context).tabBarTheme.unselectedLabelColor
                                : null
                        )
                    ),
                    subtitleTextStyle:  GoogleFonts.lato(),
                    leading: Icon(Icons.access_time_outlined, color: Theme.of(context).primaryColorDark),
                    subtitle: _dayTime,
                    onTap: () async {
                      if(_notifications){
                        await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        ).then((value) {
                          setState(() {
                            _dayTime = "${value.hour}:${value.minute}";
                          });
                        });
                      }
                    },
                  ),
                  SettingsTile(
                    title: '${S.current.param_notif_repeat}',
                    subtitle: _repeateNotification,
                    titleTextStyle:  GoogleFonts.lato(
                        textStyle: TextStyle(
                            color: (!_notifications)
                                ? Theme.of(context).tabBarTheme.unselectedLabelColor
                                : null
                        )
                    ),
                    subtitleTextStyle:  GoogleFonts.lato(),
                    leading: Icon(Icons.today_outlined, color: Theme.of(context).primaryColorDark),
                    onTap: () async {
                      if(_notifications){
                        AwesomeDialog(
                            context: context,
                            dialogType: DialogType.QUESTION,
                            animType: AnimType.BOTTOMSLIDE,
                            body: _dayofWeekDialog(),
                            btnCancelText: S.current.non,
                            btnCancelOnPress: () {},
                            btnOkText: S.current.oui,
                            btnOkOnPress: () async {
                              setState(() {
                                _repeateNotification;
                              });
                            })
                          ..show();
                      }
                    },
                  ),
                  SettingsTile(
                    title: '${S.current.param_echeance}',
                    subtitle: "$_echeance ${S.current.day}",
                    titleTextStyle: GoogleFonts.lato(
                        textStyle: TextStyle(
                            color: (!_notifications)
                                ? Theme.of(context).tabBarTheme.unselectedLabelColor
                                : null
                        )
                    ),
                    subtitleTextStyle: GoogleFonts.lato(),
                    leading: Icon(Icons.calendar_today, color: Theme.of(context).primaryColorDark),
                    onTap: () async {
                      if(_notifications){
                        AwesomeDialog(
                            context: context,
                            dialogType: DialogType.QUESTION,
                            animType: AnimType.BOTTOMSLIDE,
                            body: _echeanceDialog(),
                            btnCancelText: S.current.non,
                            btnCancelOnPress: () {},
                            btnOkText: S.current.oui,
                            btnOkOnPress: () async {
                              setState(() {
                                _echeance;
                              });
                            })
                          ..show();
                      }

                    },
                  ),
                ],
              ),
              SettingsSection(
                title: '${S.current.param_back_title}',
                titleTextStyle: GoogleFonts.lato(
                    textStyle: TextStyle(
                        color: Theme.of(context).accentColor,fontWeight: FontWeight.bold
                    )
                ),
                tiles: [
                  SettingsTile(
                    title: '${S.current.param_backup}',
                    titleTextStyle: GoogleFonts.lato(
                        textStyle: TextStyle(
                          color: (_myParams.versionType == "demo")
                              ? Theme.of(context).tabBarTheme.unselectedLabelColor
                              : null
                        )
                    ),
                    leading: Icon(Icons.backup, color: Theme.of(context).primaryColorDark),
                    onTap: () async{
                      if(_myParams.versionType != "demo"){
                        await showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => FutureProgressDialog(
                                _queryCtr.createBackup()
                                    .then((value){
                                  Navigator.pop(context);
                                  if(value["name"] != null){
                                    Helpers.showFlushBar(context, "${S.current.msg_back_suce}");
                                  }else{
                                    Helpers.showFlushBar(context, "${S.current.msg_back_err}");
                                  }
                                }).catchError((e)=>Navigator.pop(context)),
                                message:Text('${S.current.chargement}...'),
                                progress: CircularProgressIndicator(),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                              )
                        );
                      }else{
                        Helpers.showFlushBar(context, S.current.msg_demo_option);
                      }
                    },
                  ),
                  SettingsTile(
                    title: '${S.current.param_resto_data}',
                    titleTextStyle: GoogleFonts.lato(
                        textStyle: TextStyle(
                            color: (_myParams.versionType == "demo")
                                ? Theme.of(context).tabBarTheme.unselectedLabelColor
                                : null
                        )
                    ),
                    leading: Icon(Icons.restore, color: Theme.of(context).primaryColorDark),
                    onTap: () async {
                      if(_myParams.versionType != "demo") {
                        Navigator.pushNamed(context, RoutesKeys.driveListing);
                      }else{
                        Helpers.showFlushBar(context, S.current.msg_demo_option);
                      }
                    },
                  ),
                ],
              ),
            ],
          ));
    }
  }

  //************************************************************************************************************************************************
  //***********************************************************************dialogs***************************************************************
  _languageDialog() {
    return StatefulBuilder(
        builder: (context, setState) => Wrap(
              children: [
                Container(
                  height: 180,
                  child: Column(
                    children: [
                      RadioListTile(
                        value: Statics.languages[0],
                        groupValue: _language,
                        title: Text('English (ENG)' , style: GoogleFonts.lato(),),
                        onChanged: (value) {
                          setState(() {
                            _language = value;
                          });
                        },
                      ),
                      RadioListTile(
                        value: Statics.languages[1],
                        groupValue: _language,
                        title: Text('Français (FR)' , style: GoogleFonts.lato(),),
                        onChanged: (value) {
                          setState(() {
                            _language = value;
                          });
                        },
                      ),
                      RadioListTile(
                        value: Statics.languages[2],
                        groupValue: _language,
                        title: Text('عربي (AR)' , style: GoogleFonts.lato(),),
                        onChanged: (value) {
                          setState(() {
                            _language = value;
                          });
                        },
                      )
                    ],
                  ),
                ),
              ],
            ));
  }

  _themStyleDialog() {
    return StatefulBuilder(
        builder: (context, setState) => Wrap(
          children: [
            Container(
              height: 180,
              child: Column(
                children: [
                  RadioListTile(
                    value: Statics.themeStyle[0],
                    groupValue: _themStyle,
                    title: Text(Statics.themeStyle[0] , style: GoogleFonts.lato(),),
                    onChanged: (value) {
                      setState(() {
                        _themStyle = value;
                      });
                    },
                  ),
                  RadioListTile(
                    value: Statics.themeStyle[1],
                    groupValue: _themStyle,
                    title: Text(Statics.themeStyle[1], style: GoogleFonts.lato(),),
                    onChanged: (value) {
                      setState(() {
                        _themStyle = value;
                      });
                    },
                  ),
                  RadioListTile(
                    value: Statics.themeStyle[2],
                    groupValue: _themStyle,
                    title: Text(Statics.themeStyle[2], style: GoogleFonts.lato(),),
                    onChanged: (value) {
                      setState(() {
                        _themStyle = value;
                      });
                    },
                  )
                ],
              ),
            ),
          ],
        ));
  }

  Widget _countryDialog(Country country) => Row(
    children: <Widget>[
      CurrencyPickerUtils.getDefaultFlagImage(country),
      SizedBox(width: 8.0),
      Text("(${country.currencyCode})", style: GoogleFonts.lato(),),
      SizedBox(width: 8.0),
      Flexible(child: Text(country.name, style: GoogleFonts.lato(),))
    ],
  );

  _tarificationDialog() {
    ScrollController _controller = new ScrollController();
    return StatefulBuilder(
        builder: (context, setState) => Wrap(
          children: [
            Container(
              height: 220,
              child: Scrollbar(
                isAlwaysShown: true,
                controller: _controller,
                child: ListView(
                  controller: _controller,
                  children: [
                    SizedBox(height: 20,),
                    Text(S.current.titre_dialog_tarification,textAlign: TextAlign.center, style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 18)),),
                    SizedBox(height: 5,),
                    RadioListTile(
                      value: Statics.tarificationItems[0],
                      groupValue: _tarification,
                      title: Text('1 ${S.current.tarif_s}', style: GoogleFonts.lato(),),
                      onChanged: (value) {
                        setState(() {
                          _tarification = value;
                        });
                      },
                    ),
                    RadioListTile(
                      value: Statics.tarificationItems[1],
                      groupValue: _tarification,
                      title: Text('2 ${S.current.tarif_s}', style: GoogleFonts.lato(),),
                      onChanged: (value) {
                        setState(() {
                          _tarification = value;
                        });
                      },
                    ),
                    RadioListTile(
                      value: Statics.tarificationItems[2],
                      groupValue: _tarification,
                      title: Text('3 ${S.current.tarif_s}' , style: GoogleFonts.lato(),),
                      onChanged: (value) {
                        setState(() {
                          _tarification = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  _formatPrintDialog() {
    ScrollController _controller = new ScrollController();
    return StatefulBuilder(
        builder: (context, setState) => Wrap(
          children: [
            Container(
              height: 100,
              child: Scrollbar(
                isAlwaysShown: true,
                controller: _controller,
                child: ListView(
                  controller: _controller,
                  children: [
                    RadioListTile(
                      value: Statics.printDisplayItems[0],
                      groupValue: _formatPrintDisplay,
                      title: Text('${S.current.referance}',style: GoogleFonts.lato(),),
                      onChanged: (value) {
                        setState(() {
                          _formatPrintDisplay = value;
                        });
                      },
                    ),
                    RadioListTile(
                      value: Statics.printDisplayItems[1],
                      groupValue: _formatPrintDisplay,
                      title: Text('${S.current.designation}',style: GoogleFonts.lato(),),
                      onChanged: (value) {
                        setState(() {
                          _formatPrintDisplay = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  _dayofWeekDialog() {
    ScrollController _controller = new ScrollController();
    return StatefulBuilder(
        builder: (context, setState) => Wrap(
              children: [
                Container(
                  height: 220,
                  child: Scrollbar(
                    isAlwaysShown: true,
                    controller: _controller,
                    child: ListView(
                      controller: _controller,
                      children: [
                        RadioListTile(
                          value: Statics.repeateNotifications[0],
                          groupValue: _repeateNotification,
                          title: Text('${S.current.ev_day}',style: GoogleFonts.lato(),),
                          onChanged: (value) {
                            setState(() {
                              _repeateNotification = value;
                            });
                          },
                        ),
                        RadioListTile(
                          value: Statics.repeateNotifications[1],
                          groupValue: _repeateNotification,
                          title: Text('${S.current.ev_sun}',style: GoogleFonts.lato(),),
                          onChanged: (value) {
                            setState(() {
                              _repeateNotification = value;
                            });
                          },
                        ),
                        RadioListTile(
                          value: Statics.repeateNotifications[2],
                          groupValue: _repeateNotification,
                          title: Text('${S.current.ev_mon}',style: GoogleFonts.lato(),),
                          onChanged: (value) {
                            setState(() {
                              _repeateNotification = value;
                            });
                          },
                        ),
                        RadioListTile(
                          value: Statics.repeateNotifications[3],
                          groupValue: _repeateNotification,
                          title: Text('${S.current.ev_tue}', style: GoogleFonts.lato(),),
                          onChanged: (value) {
                            setState(() {
                              _repeateNotification = value;
                            });
                          },
                        ),
                        RadioListTile(
                          value: Statics.repeateNotifications[4],
                          groupValue: _repeateNotification,
                          title: Text('${S.current.ev_wedn}', style: GoogleFonts.lato(),),
                          onChanged: (value) {
                            setState(() {
                              _repeateNotification = value;
                            });
                          },
                        ),
                        RadioListTile(
                          value: Statics.repeateNotifications[5],
                          groupValue: _repeateNotification,
                          title: Text('${S.current.ev_thur}', style: GoogleFonts.lato(),),
                          onChanged: (value) {
                            setState(() {
                              _repeateNotification = value;
                            });
                          },
                        ),
                        RadioListTile(
                          value: Statics.repeateNotifications[6],
                          groupValue: _repeateNotification,
                          title: Text('${S.current.ev_fri}', style: GoogleFonts.lato(),),
                          onChanged: (value) {
                            setState(() {
                              _repeateNotification = value;
                            });
                          },
                        ),
                        RadioListTile(
                          value: Statics.repeateNotifications[7],
                          groupValue: _repeateNotification,
                          title: Text('${S.current.ev_sat}', style: GoogleFonts.lato(),),
                          onChanged: (value) {
                            setState(() {
                              _repeateNotification = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ));
  }

  _echeanceDialog() {
    ScrollController _controller = new ScrollController();
    return StatefulBuilder(
        builder: (context, setState) => Wrap(
          children: [
            Container(
              height: 220,
              child: Scrollbar(
                isAlwaysShown: true,
                controller: _controller,
                child: ListView(
                  controller: _controller,
                  children: [
                    RadioListTile(
                      value: Statics.echeances[0],
                      groupValue: _echeance,
                      title: Text('1 ${S.current.day}', style: GoogleFonts.lato(),),
                      onChanged: (value) {
                        setState(() {
                          _echeance = value;
                        });
                      },
                    ),
                    RadioListTile(
                      value: Statics.echeances[1],
                      groupValue: _echeance,
                      title: Text('3 ${S.current.day} (s)', style: GoogleFonts.lato(),),
                      onChanged: (value) {
                        setState(() {
                          _echeance = value;
                        });
                      },
                    ),
                    RadioListTile(
                      value: Statics.echeances[2],
                      groupValue: _echeance,
                      title: Text('7 ${S.current.day} (s)', style: GoogleFonts.lato(),),
                      onChanged: (value) {
                        setState(() {
                          _echeance = value;
                        });
                      },
                    ),
                    RadioListTile(
                      value: Statics.echeances[3],
                      groupValue: _echeance,
                      title: Text('15 ${S.current.day} (s)', style: GoogleFonts.lato(),),
                      onChanged: (value) {
                        setState(() {
                          _echeance = value;
                        });
                      },
                    ),
                    RadioListTile(
                      value: Statics.echeances[4],
                      groupValue: _echeance,
                      title: Text('21 ${S.current.day} (s)', style: GoogleFonts.lato(),),
                      onChanged: (value) {
                        setState(() {
                          _echeance = value;
                        });
                      },
                    ),
                    RadioListTile(
                      value: Statics.echeances[5],
                      groupValue: _echeance,
                      title: Text('30 ${S.current.day} (s)', style: GoogleFonts.lato(),),
                      onChanged: (value) {
                        setState(() {
                          _echeance = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  //************************************************************************************************************************************************
  //***********************************************************************save data ***************************************************************

  _savelocale() async {
    switch (_language) {
      case ("English (ENG)"):
        _prefs.setString("myLocale", "en");
        break;
      case ("Français (FR)"):
        _prefs.setString("myLocale", "fr");
        break;

      case ("عربي (AR)"):
        _prefs.setString("myLocale", "ar");
        break;
    }

    _prefs.setString("myDevise", "${_currencycode}");
  }

  _saveStyle() async {
    switch (Statics.themeStyle.indexOf(_themStyle)) {
      case (0):
        _prefs.setString("myStyle", "light");
        break;
      case (1):
        _prefs.setString("myStyle", "dark");
        break;

      case (2):
        _prefs.setString("myStyle", "system");
        break;
    }
  }

  Future<void> _updateItem() async {
    _myParams.tarification = _tarification ;
    _myParams.tva = _tva;
    _myParams.timbre = _timbre;
    _myParams.printDisplay = Statics.printDisplayItems.indexOf(_formatPrintDisplay);
    _myParams.creditTier = _credit ;
    _myParams.notificationDay = Statics.repeateNotifications.indexOf(_repeateNotification);
    _myParams.notifications = _notifications;
    _myParams.notificationTime = _dayTime;
    _myParams.echeance = Statics.echeances.indexOf(_echeance);
    _myParams.pays = _countryname ;
    _myParams.devise = _currencycode ;

    int id = -1;
    await _savelocale();
    await _saveStyle();
    id = await _queryCtr.updateItemInDb(DbTablesNames.myparams, _myParams);
    // await showNotification();
    var message = "";
    if (id > -1) {
      PushNotificationsManager.of(context).onMyParamsChange(_myParams);
      message = "${S.current.msg_upd_param}";
    } else {
      message = "${S.current.msg_err_upd_param}";
    }

    Navigator.pop(context);
    Helpers.showFlushBar(context, message);
  }


}
