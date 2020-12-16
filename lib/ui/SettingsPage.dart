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

import 'AddArticlePage.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  List<String> languages = ["English (ENG)" , "French (FR)" , "Arabic (AR)"];
  String language  ;

  @override
  Future<void> initState() {
    super.initState();
    language= languages[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 25),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(S.current.settings),
        backgroundColor: Colors.blue,
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
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return  languageDialog();
                    },
                  ).then((value) {
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
                  });
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
        builder: (context, setState) {
          return AlertDialog(
            title: Text("Choose a language"),
            content: Container(
              height: 180,
              child: Column(
                children: [
                  RadioListTile(
                    value: languages[0],
                    groupValue: language,
                    title: Text('Anglais (ENG)'),
                    onChanged: (value){
                      setState(() {
                        language= value ;
                      });
                    },
                  ),
                  RadioListTile(
                    value: languages[1],
                    groupValue: language,
                    title: Text('Français (FR)'),
                    onChanged: (value){
                      setState(() {
                        language= value ;
                      });
                    },
                  ),
                  RadioListTile(
                    value: languages[2],
                    groupValue: language,
                    title: Text('Arabe (AR)'),
                    onChanged: (value){
                      setState(() {
                        language= value ;
                      });
                    },
                  )
                ],
              ),
            ),
          );
        },
      );
  }

}

