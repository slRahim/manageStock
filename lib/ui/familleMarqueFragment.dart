import 'package:flutter/material.dart';
import 'package:gestmob/Widgets/CustomWidgets/search_bar.dart';

class FamilleMarqueFragment extends StatefulWidget {
  @override
  _FamilleMarqueFragmentState createState() => _FamilleMarqueFragmentState();
}

class _FamilleMarqueFragmentState extends State<FamilleMarqueFragment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchBar(
          mainContext: context ,
          title: 'Famille / Marque',
          isFilterOn: false,
      ),
      body: Center(child: Container(
        child: Text('famille marque fragment'),
      )),
    );
  }
}
