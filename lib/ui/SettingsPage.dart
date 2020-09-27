import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/Article.dart';
import 'package:gestmob/models/HomeItem.dart';
import 'package:gestmob/search/search_input_sliver.dart';
import 'file:///E:/AndroidStudio/FlutterProjects/gestionstock/lib/search/items_sliver_list.dart';
import 'file:///E:/AndroidStudio/FlutterProjects/gestionstock/lib/search/sliver_list_data_source.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:settings_ui/settings_ui.dart';

import 'AddArticlePage.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Future<void> initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 25),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Settings"),
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
                subtitle: 'English',
                leading: Icon(Icons.language),
                onTap: () {},
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


  /*Column(
  children: [
  DropdownButton<int>(
  hint: Text("Price count", style: TextStyle(color: Colors.blue[700])),
  value: selectedPriceNumber,
  items: utils.buildPriceDropDownMenuItems([1, 2, 3]),
  onChanged: (value) {
  setState(() {
  selectedPriceNumber = value;
  });
  }),
  ],
  )*/
}
