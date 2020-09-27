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

class HelpPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, size: 25),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text("Help"),
          backgroundColor: Colors.blue,
          centerTitle: true,

        ),
        body: Center(
            child: Text("How to use")
        )
    );
  }

}
