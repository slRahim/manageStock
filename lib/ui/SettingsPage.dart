import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/Article.dart';
import 'package:gestmob/models/HomeItem.dart';
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
  String language  ;

  @override
  Future<void> initState() {
    super.initState();
    language= languages[0];
    futureInit ();
  }

  Future<void> futureInit()async{
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
                switchValue: true,
                onToggle: (bool value) {},
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

}

