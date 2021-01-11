
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
  SharedPreferences prefs ;
  List<String> languages = ["English (ENG)" , "French (FR)" , "Arabic (AR)"];
  bool prices3 ;
  bool tva ;
  bool timbre ;
  String language  ;
  bool notifications ;
  String dayTime ;
  List<String> repeateNotifications = ["Dailly" , "Every Sunday" , "Every Monday" ,"Every Tuesday","Every Wednesday","Every Thursday" ,"Every Friday","Every Saturday"];
  String repeateNotification  ;

  QueryCtr _queryCtr = new QueryCtr();
  MyParams _myParams ;

  @override
  Future<void> initState() {
    super.initState();
    language= languages[0];
    futureInit ();
  }

  Future<void> futureInit()async{
    _myParams = await _queryCtr.getAllParams();
    prefs = await SharedPreferences.getInstance();
    switch(prefs.getString("myLocale")){
      case ("en") :
        setState(() {
          language = languages[0] ;
        });
        break ;
      case ("fr") :
        setState(() {
          language = languages[1] ;
        });
        break ;
      case ("ar") :
        setState(() {
          language = languages[2] ;
        });
        break ;
      default:
        setState(() {
          language = languages[0] ;
        });
        break ;
    }

    await setDataFromItem(_myParams) ;
  }

  setDataFromItem(item)async{
    prices3 = false ;
    tva = item.tva ;
    timbre = item.timbre ;
    notifications = item.notifications ;
    dayTime = item.notificationTime ;
    repeateNotification = repeateNotifications[item.notificationDay] ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 25),
          onPressed: () =>Navigator.pop(context),
        ),
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
                subtitle: language ,
                leading: Icon(Icons.language),
                onTap: () async{
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.QUESTION,
                    animType: AnimType.BOTTOMSLIDE,
                    title: "Choose a language",
                    body: languageDialog(),
                    btnCancelText: S.current.non,
                    btnCancelOnPress: (){},
                    btnOkText: S.current.oui,
                    btnOkOnPress: () async{
                        await _savelocale();
                        setState(() {
                          language ;
                          switch(language){
                            case ("English (ENG)"):
                              S.load(Locale("en"));
                              break ;
                            case ("French (FR)"):
                              S.load(Locale("fr"));
                              break ;

                            case ("Arabic (AR)"):
                              S.load(Locale("ar"));
                              break ;
                          }
                        });
                    }
                  )..show();
                },
              ),
              SettingsTile.switchTile(
                title: 'Use 3 prices',
                leading: Icon(Icons.attach_money),
                switchValue: prices3,
                onToggle: (bool value) {
                  setState(() {
                    prices3 =value ;
                  });
                },
              ),
              SettingsTile.switchTile(
                title: 'Enable Tva',
                leading: Icon(Icons.money_outlined),
                switchValue: tva,
                onToggle: (bool value) {
                  setState(() {
                    tva =value ;
                  });
                },
              ),
              SettingsTile.switchTile(
                title: 'Enable timbre',
                leading: Icon(Icons.fact_check),
                switchValue: timbre,
                onToggle: (bool value) {
                  setState(() {
                    timbre =value ;
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
                switchValue: notifications,
                onToggle: (bool value) {
                    setState(() {
                      notifications = value ;
                    });
                },
              ),
              SettingsTile(
                title: 'Notification Time',
                leading: Icon(Icons.access_time_outlined),
                subtitle: dayTime,
                onTap: () async{
                  await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                  ).then((value) {
                      setState(() {
                        dayTime = "${value.hour}:${value.minute}" ;
                      });
                  });
                },
              ),
              SettingsTile(
                title: 'Repeat Notification',
                subtitle: repeateNotification ,
                leading: Icon(Icons.today_outlined),
                onTap: () async{
                  AwesomeDialog(
                      context: context,
                      dialogType: DialogType.QUESTION,
                      animType: AnimType.BOTTOMSLIDE,
                      body: dayofWeekDialog(),
                      btnCancelText: S.current.non,
                      btnCancelOnPress: (){},
                      btnOkText: S.current.oui,
                      btnOkOnPress: () async{
                          setState(() {
                            repeateNotification ;
                          });
                      }
                  )..show();
                },
              ),
            ],
          ),
        ],
      )
    );
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
                      value: languages[0],
                      groupValue: language,
                      title: Text('English (ENG)'),
                      onChanged: (value){
                        setState(() {
                          language= value ;
                        });
                      },
                    ),
                    RadioListTile(
                      value: languages[1],
                      groupValue: language,
                      title: Text('French (FR)'),
                      onChanged: (value){
                        setState(() {
                          language= value ;
                        });
                      },
                    ),
                    RadioListTile(
                      value: languages[2],
                      groupValue: language,
                      title: Text('Arabic (AR)'),
                      onChanged: (value){
                        setState(() {
                          language= value ;
                        });
                      },
                    )
                  ],
                ),
              ),
            ],
          )
      );
  }

  _savelocale() async{
    switch(language){
      case ("English (ENG)"):
        prefs.setString("myLocale", "en");
        break ;
      case ("French (FR)"):
        prefs.setString("myLocale", "fr");
        break ;

      case ("Arabic (AR)"):
        prefs.setString("myLocale", "ar");
        break ;
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
                      value: repeateNotifications[0],
                      groupValue: repeateNotification,
                      title: Text('Dailly'),
                      onChanged: (value){
                        setState(() {
                          repeateNotification= value ;
                        });
                      },
                    ),
                    RadioListTile(
                      value: repeateNotifications[1],
                      groupValue: repeateNotification,
                      title: Text('Every Sunday'),
                      onChanged: (value){
                        setState(() {
                          repeateNotification= value ;
                        });
                      },
                    ),
                    RadioListTile(
                      value: repeateNotifications[2],
                      groupValue: repeateNotification,
                      title: Text('Every Monday'),
                      onChanged: (value){
                        setState(() {
                          repeateNotification= value ;
                        });
                      },
                    ),
                    RadioListTile(
                      value: repeateNotifications[3],
                      groupValue: repeateNotification,
                      title: Text('Every Tuesday'),
                      onChanged: (value){
                        setState(() {
                          repeateNotification= value ;
                        });
                      },
                    ),
                    RadioListTile(
                      value: repeateNotifications[4],
                      groupValue: repeateNotification,
                      title: Text('Every Wednesday'),
                      onChanged: (value){
                        setState(() {
                          repeateNotification= value ;
                        });
                      },
                    ),
                    RadioListTile(
                      value: repeateNotifications[5],
                      groupValue: repeateNotification,
                      title: Text('Every Thursday'),
                      onChanged: (value){
                        setState(() {
                          repeateNotification= value ;
                        });
                      },
                    ),
                    RadioListTile(
                      value: repeateNotifications[6],
                      groupValue: repeateNotification,
                      title: Text('Every Friday'),
                      onChanged: (value){
                        setState(() {
                          repeateNotification= value ;
                        });
                      },
                    ),
                    RadioListTile(
                      value: repeateNotifications[7],
                      groupValue: repeateNotification,
                      title: Text('Every Saturday'),
                      onChanged: (value){
                        setState(() {
                          repeateNotification= value ;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
    );
  }
}

