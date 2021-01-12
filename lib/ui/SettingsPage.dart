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
  List<String> _languages = ["English (ENG)", "French (FR)", "Arabic (AR)"];
  bool _prices3;
  bool _tva;
  bool _timbre;
  String _language;
  bool _notifications;
  String _dayTime;
  List<String> _repeateNotifications = [
    "Dailly",
    "Every Sunday",
    "Every Monday",
    "Every Tuesday",
    "Every Wednesday",
    "Every Thursday",
    "Every Friday",
    "Every Saturday"
  ];
  String _repeateNotification;

  QueryCtr _queryCtr = new QueryCtr();
  MyParams _myParams;

  @override
  Future<void> initState() {
    super.initState();
    _language = _languages[0];
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
          _language = _languages[0];
        });
        break;
      case ("fr"):
        setState(() {
          _language = _languages[1];
        });
        break;
      case ("ar"):
        setState(() {
          _language = _languages[2];
        });
        break;
      default:
        setState(() {
          _language = _languages[0];
        });
        break;
    }

    await setDataFromItem(_myParams);
  }

  setDataFromItem(item) async {
    _prices3 = (item.tarification > 2);
    _tva = item.tva;
    _timbre = item.timbre;
    _notifications = item.notifications;
    _dayTime = item.notificationTime;
    _repeateNotification = _repeateNotifications[item.notificationDay];
  }

  @override
  Widget build(BuildContext context) {
    if (!_finishedLoading) {
      return Scaffold(body: Helpers.buildLoading());
    } else {
      return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back, size: 25),
                onPressed: () {
                  AwesomeDialog(
                      context: context,
                      title: "Save Changes",
                      desc: "Do you want to save last changes ...",
                      dialogType: DialogType.QUESTION,
                      animType: AnimType.BOTTOMSLIDE,
                      btnCancelText: S.current.non,
                      btnCancelOnPress: () {
                        Navigator.pop(context);
                      },
                      btnOkText: S.current.oui,
                      btnOkOnPress: () async {
                        await updateItem();
                      })
                    ..show();
                }),
            title: Text(S.current.settings),
            backgroundColor: Theme.of(context).appBarTheme.color,
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(
                  Icons.help,
                ),
                onPressed: () {
                  Helpers.handleIdClick(context, drawerItemHelpId);
                },
              ),
            ],
          ),
          body: SettingsList(
            sections: [
              SettingsSection(
                title: 'General',
                tiles: [
                  SettingsTile(
                    title: 'Language',
                    subtitle: _language,
                    leading: Icon(Icons.language),
                    onTap: () async {
                      AwesomeDialog(
                          context: context,
                          dialogType: DialogType.QUESTION,
                          animType: AnimType.BOTTOMSLIDE,
                          title: "Choose a language",
                          body: languageDialog(),
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
                  SettingsTile.switchTile(
                    title: 'Use 3 prices',
                    leading: Icon(Icons.attach_money),
                    switchValue: _prices3,
                    onToggle: (bool value) {
                      setState(() {
                        _prices3 = value;
                      });
                    },
                  ),
                  SettingsTile.switchTile(
                    title: 'Enable Tva',
                    leading: Icon(Icons.money_outlined),
                    switchValue: _tva,
                    onToggle: (bool value) {
                      setState(() {
                        _tva = value;
                      });
                    },
                  ),
                  SettingsTile.switchTile(
                    title: 'Enable timbre',
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
                title: 'Notifications',
                tiles: [
                  SettingsTile.switchTile(
                    title: 'Accept Notification',
                    leading: Icon(Icons.notifications_active),
                    switchValue: _notifications,
                    onToggle: (bool value) {
                      setState(() {
                        _notifications = value;
                      });
                    },
                  ),
                  SettingsTile(
                    title: 'Notification Time',
                    leading: Icon(Icons.access_time_outlined),
                    subtitle: _dayTime,
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
                    title: 'Repeat Notification',
                    subtitle: _repeateNotification,
                    leading: Icon(Icons.today_outlined),
                    onTap: () async {
                      AwesomeDialog(
                          context: context,
                          dialogType: DialogType.QUESTION,
                          animType: AnimType.BOTTOMSLIDE,
                          body: dayofWeekDialog(),
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
                ],
              ),
            ],
          ));
    }
  }

  languageDialog() {
    return StatefulBuilder(
        builder: (context, setState) => Wrap(
              children: [
                Container(
                  height: 180,
                  child: Column(
                    children: [
                      RadioListTile(
                        value: _languages[0],
                        groupValue: _language,
                        title: Text('English (ENG)'),
                        onChanged: (value) {
                          setState(() {
                            _language = value;
                          });
                        },
                      ),
                      RadioListTile(
                        value: _languages[1],
                        groupValue: _language,
                        title: Text('French (FR)'),
                        onChanged: (value) {
                          setState(() {
                            _language = value;
                          });
                        },
                      ),
                      RadioListTile(
                        value: _languages[2],
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

  dayofWeekDialog() {
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
                          value: _repeateNotifications[0],
                          groupValue: _repeateNotification,
                          title: Text('Dailly'),
                          onChanged: (value) {
                            setState(() {
                              _repeateNotification = value;
                            });
                          },
                        ),
                        RadioListTile(
                          value: _repeateNotifications[1],
                          groupValue: _repeateNotification,
                          title: Text('Every Sunday'),
                          onChanged: (value) {
                            setState(() {
                              _repeateNotification = value;
                            });
                          },
                        ),
                        RadioListTile(
                          value: _repeateNotifications[2],
                          groupValue: _repeateNotification,
                          title: Text('Every Monday'),
                          onChanged: (value) {
                            setState(() {
                              _repeateNotification = value;
                            });
                          },
                        ),
                        RadioListTile(
                          value: _repeateNotifications[3],
                          groupValue: _repeateNotification,
                          title: Text('Every Tuesday'),
                          onChanged: (value) {
                            setState(() {
                              _repeateNotification = value;
                            });
                          },
                        ),
                        RadioListTile(
                          value: _repeateNotifications[4],
                          groupValue: _repeateNotification,
                          title: Text('Every Wednesday'),
                          onChanged: (value) {
                            setState(() {
                              _repeateNotification = value;
                            });
                          },
                        ),
                        RadioListTile(
                          value: _repeateNotifications[5],
                          groupValue: _repeateNotification,
                          title: Text('Every Thursday'),
                          onChanged: (value) {
                            setState(() {
                              _repeateNotification = value;
                            });
                          },
                        ),
                        RadioListTile(
                          value: _repeateNotifications[6],
                          groupValue: _repeateNotification,
                          title: Text('Every Friday'),
                          onChanged: (value) {
                            setState(() {
                              _repeateNotification = value;
                            });
                          },
                        ),
                        RadioListTile(
                          value: _repeateNotifications[7],
                          groupValue: _repeateNotification,
                          title: Text('Every Saturday'),
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

  Future<void> updateItem() async {
    _myParams.tarification = (_prices3) ? 3 : 2;
    _myParams.tva = _tva;
    _myParams.timbre = _timbre;
    _myParams.notificationDay =
        _repeateNotifications.indexOf(_repeateNotification);
    _myParams.notifications = _notifications;
    _myParams.notificationTime = _dayTime;

    int id = -1;
    id = await _queryCtr.updateItemInDb(DbTablesNames.myparams, _myParams);
    await showNotification();
    var message = "";
    if (id > -1) {
      message = "Settings has succesfuly updated";
    } else {
      message = "Error on updating settings";
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
