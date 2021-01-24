import 'package:flutter/material.dart';
import 'package:gestmob/Widgets/CustomWidgets/search_bar.dart';

class Rapport extends StatefulWidget {
  @override
  _RapportState createState() => _RapportState();
}

class _RapportState extends State<Rapport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchBar(
        title: "Rapport",
        isFilterOn: false,
        mainContext: context,
      ),
      body: Center(
          child: Text("Rapport")
      ),
    );
  }
}
