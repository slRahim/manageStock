import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/Article.dart';
import 'package:gestmob/models/HomeItem.dart';
import 'package:gestmob/models/MyParams.dart';
import 'package:gestmob/search/search_input_sliver.dart';
import 'package:gestmob/services/local_notification.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AddArticlePage.dart';
import 'home.dart';

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
  String _language;
  bool _notifications;
  String _dayTime;

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

    await setDataFromItem(_myParams);
  }

  setDataFromItem(item) async {
    _tarification = item.tarification ;
    _tva = item.tva;
    _timbre = item.timbre;
    _notifications = item.notifications;
    _dayTime = item.notificationTime;
    _repeateNotification = Statics.repeateNotifications[item.notificationDay];
    _echeance = Statics.echeances[item.echeance];

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
                Icons.live_help_sharp,
              ),
              onPressed: () {
                Helpers.handleIdClick(context, drawerItemHelpId);
              },
            ),
            title: Text(S.current.settings),
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
                tiles: [
                  SettingsTile(
                    title: '${S.current.param_lang}',
                    subtitle: _language,
                    leading: Icon(Icons.language),
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
                              switch (_language) {
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
                          })
                        ..show();
                    },
                  ),
                  SettingsTile(
                    title: '${S.current.tarification}',
                    subtitle:("${S.current.use} : "+_tarification.toString()),
                    leading: Icon(Icons.attach_money),
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
                    leading: Icon(Icons.money_outlined),
                    switchValue: _tva,
                    onToggle: (bool value) {
                      setState(() {
                        _tva = value;
                      });
                    },
                  ),
                  SettingsTile.switchTile(
                    title: '${S.current.param_timbre}',
                    leading: Icon(Icons.fact_check),
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
                title: '${S.current.param_notif_title}',
                tiles: [
                  SettingsTile.switchTile(
                    title: '${S.current.param_notif}',
                    leading: Icon(Icons.notifications_active),
                    switchValue: _notifications,
                    onToggle: (bool value) {
                      setState(() {
                        _notifications = value;
                      });
                    },
                  ),
                  SettingsTile(
                    title: '${S.current.param_notif_time}',
                    leading: Icon(Icons.access_time_outlined),
                    subtitle: _dayTime,
                    enabled: _notifications,
                    onTap: () async {
                      await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      ).then((value) {
                        setState(() {
                          _dayTime = "${value.hour}:${value.minute}";
                        });
                      });
                    },
                  ),
                  SettingsTile(
                    title: '${S.current.param_notif_repeat}',
                    subtitle: _repeateNotification,
                    enabled: _notifications,
                    leading: Icon(Icons.today_outlined),
                    onTap: () async {
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
                    },
                  ),
                  SettingsTile(
                    title: '${S.current.param_echeance}',
                    subtitle: "$_echeance ${S.current.day} (s)",
                    enabled: _notifications,
                    leading: Icon(Icons.calendar_today),
                    onTap: () async {
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
                    },
                  ),
                ],
              ),
              SettingsSection(
                title: '${S.current.param_back_title}',
                tiles: [
                  SettingsTile(
                    title: '${S.current.param_backup}',
                    leading: Icon(Icons.backup),
                    onTap: () async{
                      _queryCtr.createBackup()
                          .then((value){
                        if(value["name"] != null){
                          Helpers.showFlushBar(context, "${S.current.msg_back_suce}");
                        }else{
                          Helpers.showFlushBar(context, "${S.current.msg_back_err}");
                        }
                      });
                    },
                  ),
                  SettingsTile(
                    title: '${S.current.param_resto_data}',
                    leading: Icon(Icons.restore),
                    onTap: () async {
                      Navigator.pushNamed(context, RoutesKeys.driveListing);
                    },
                  ),
                ],
              ),
            ],
          ));
    }
  }

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
                        title: Text('English (ENG)'),
                        onChanged: (value) {
                          setState(() {
                            _language = value;
                          });
                        },
                      ),
                      RadioListTile(
                        value: Statics.languages[1],
                        groupValue: _language,
                        title: Text('French (FR)'),
                        onChanged: (value) {
                          setState(() {
                            _language = value;
                          });
                        },
                      ),
                      RadioListTile(
                        value: Statics.languages[2],
                        groupValue: _language,
                        title: Text('Arabic (AR)'),
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

  _savelocale() async {
    switch (_language) {
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
  }

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
                    RadioListTile(
                      value: Statics.tarificationItems[0],
                      groupValue: _tarification,
                      title: Text('${S.current.tarif} 1'),
                      onChanged: (value) {
                        setState(() {
                          _tarification = value;
                        });
                      },
                    ),
                    RadioListTile(
                      value: Statics.tarificationItems[1],
                      groupValue: _tarification,
                      title: Text('${S.current.tarif} 2'),
                      onChanged: (value) {
                        setState(() {
                          _tarification = value;
                        });
                      },
                    ),
                    RadioListTile(
                      value: Statics.tarificationItems[2],
                      groupValue: _tarification,
                      title: Text('${S.current.tarif} 3'),
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
                          title: Text('${S.current.ev_day}'),
                          onChanged: (value) {
                            setState(() {
                              _repeateNotification = value;
                            });
                          },
                        ),
                        RadioListTile(
                          value: Statics.repeateNotifications[1],
                          groupValue: _repeateNotification,
                          title: Text('${S.current.ev_sun}'),
                          onChanged: (value) {
                            setState(() {
                              _repeateNotification = value;
                            });
                          },
                        ),
                        RadioListTile(
                          value: Statics.repeateNotifications[2],
                          groupValue: _repeateNotification,
                          title: Text('${S.current.ev_mon}'),
                          onChanged: (value) {
                            setState(() {
                              _repeateNotification = value;
                            });
                          },
                        ),
                        RadioListTile(
                          value: Statics.repeateNotifications[3],
                          groupValue: _repeateNotification,
                          title: Text('${S.current.ev_tue}'),
                          onChanged: (value) {
                            setState(() {
                              _repeateNotification = value;
                            });
                          },
                        ),
                        RadioListTile(
                          value: Statics.repeateNotifications[4],
                          groupValue: _repeateNotification,
                          title: Text('${S.current.ev_wedn}'),
                          onChanged: (value) {
                            setState(() {
                              _repeateNotification = value;
                            });
                          },
                        ),
                        RadioListTile(
                          value: Statics.repeateNotifications[5],
                          groupValue: _repeateNotification,
                          title: Text('${S.current.ev_thur}'),
                          onChanged: (value) {
                            setState(() {
                              _repeateNotification = value;
                            });
                          },
                        ),
                        RadioListTile(
                          value: Statics.repeateNotifications[6],
                          groupValue: _repeateNotification,
                          title: Text('${S.current.ev_fri}'),
                          onChanged: (value) {
                            setState(() {
                              _repeateNotification = value;
                            });
                          },
                        ),
                        RadioListTile(
                          value: Statics.repeateNotifications[7],
                          groupValue: _repeateNotification,
                          title: Text('${S.current.ev_sat}'),
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
                      title: Text('1 ${S.current.day}'),
                      onChanged: (value) {
                        setState(() {
                          _echeance = value;
                        });
                      },
                    ),
                    RadioListTile(
                      value: Statics.echeances[1],
                      groupValue: _echeance,
                      title: Text('3 ${S.current.day} (s)'),
                      onChanged: (value) {
                        setState(() {
                          _echeance = value;
                        });
                      },
                    ),
                    RadioListTile(
                      value: Statics.echeances[2],
                      groupValue: _echeance,
                      title: Text('7 ${S.current.day} (s)'),
                      onChanged: (value) {
                        setState(() {
                          _echeance = value;
                        });
                      },
                    ),
                    RadioListTile(
                      value: Statics.echeances[3],
                      groupValue: _echeance,
                      title: Text('15 ${S.current.day} (s)'),
                      onChanged: (value) {
                        setState(() {
                          _echeance = value;
                        });
                      },
                    ),
                    RadioListTile(
                      value: Statics.echeances[4],
                      groupValue: _echeance,
                      title: Text('21 ${S.current.day} (s)'),
                      onChanged: (value) {
                        setState(() {
                          _echeance = value;
                        });
                      },
                    ),
                    RadioListTile(
                      value: Statics.echeances[5],
                      groupValue: _echeance,
                      title: Text('30 ${S.current.day} (s)'),
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

  Future<void> _updateItem() async {
    _myParams.tarification = _tarification ;
    _myParams.tva = _tva;
    _myParams.timbre = _timbre;
    _myParams.notificationDay = Statics.repeateNotifications.indexOf(_repeateNotification);
    _myParams.notifications = _notifications;
    _myParams.notificationTime = _dayTime;
    _myParams.echeance = Statics.echeances.indexOf(_echeance);

    int id = -1;
    id = await _queryCtr.updateItemInDb(DbTablesNames.myparams, _myParams);
    // await showNotification();
    var message = "";
    if (id > -1) {
      message = "${S.current.msg_upd_param}";
    } else {
      message = "${S.current.msg_err_upd_param}";
    }

    Navigator.pop(context);
    Helpers.showFlushBar(context, message);
  }

//  *******************************************************************************************************************************************************************
//***********************************************************************notification***********************************************************************************
  Future showNotification() async{
    if(_myParams.notifications){
      switch(_myParams.notificationDay){
        case 0 :
          for(int i=0 ; i<4; i++){
            await notificationPlugin.showDailyAtTime(_myParams.notificationTime);
          }
          break;
        default :
          for(int i=0 ; i<4; i++){
            await notificationPlugin.showWeeklyAtDayTime(_myParams.notificationTime , _myParams.notificationDay);
          }
          break;
      }
    }else{
      await notificationPlugin.cancelAllNotification();
    }
  }

}
