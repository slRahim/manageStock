import 'package:flutter/material.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/Widgets/CustomWidgets/search_bar.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/Widgets/utils.dart' as utils;

class Rapport extends StatefulWidget {
  @override
  _RapportState createState() => _RapportState();
}

class _RapportState extends State<Rapport> {
  TextEditingController _dateControl = new TextEditingController();
  DateTimeRange _dateRange ;

  List<DropdownMenuItem<String>> _parentDropdownItems;
  String _selectedParent;

  List<DropdownMenuItem<String>> _achatDropdownItems;
  String _selectedAchatItem;

  List<DropdownMenuItem<String>> _venteDropdownItems;
  String _selectedVenteItem;

  List<DropdownMenuItem<String>> _stockDropdownItems;
  String _selectedStockItem;

  List<DropdownMenuItem<String>> _tierDropdownItems;
  String _selectedTierItem;

  List<DropdownMenuItem<String>> _generalDropdownItems;
  String _selectedGeneralItem;

  @override
  void initState() {
    super.initState();
    _parentDropdownItems = utils.buildDropStatutTier(Statics.rapporItems);
    _selectedParent = Statics.rapporItems[0];
    setState(() {
      _dateRange = new DateTimeRange(start: DateTime.now(), end: DateTime.now().add(Duration(days: 30)));
      _dateControl.text = "${Helpers.dateToText(DateTime.now())} / ${Helpers.dateToText(DateTime.now().add(Duration(days: 30)))}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchBar(
        title: "Rapport",
        isFilterOn: false,
        mainContext: context,
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(10),
          height: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(.5),
                blurRadius: 20.0, // soften the shadow
                spreadRadius: 0.0, //extend the shadow
                offset: Offset(
                  5.0, // Move to right 10  horizontally
                  5.0, // Move to bottom 10 Vertically
                ),
              )
            ],
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsetsDirectional.only(start: 20 ,bottom: 8),
                        child: Text("Fammille Rapport :"))
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                          margin:
                              EdgeInsetsDirectional.only(start: 10, end: 10),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blueAccent,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                                disabledHint: Text(_selectedParent),
                                value: _selectedParent,
                                items: _parentDropdownItems,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedParent = value;
                                  });
                                }),
                          )),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsetsDirectional.only(start: 20 ,bottom: 8),
                        child: Text("Sub Fammille Rapport :"))
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                          margin:
                              EdgeInsetsDirectional.only(start: 10, end: 10),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blueAccent,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                                disabledHint: Text("_selectedStatut"),
                                value: "_selectedStatut",
                                items: [],
                                onChanged: (value) {}),
                          )),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsetsDirectional.only(start: 20 ,bottom: 8),
                        child: Text("Date range :"))
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          callDatePicker();
                        },
                        child: Container(
                          margin:
                              EdgeInsetsDirectional.only(start: 10, end: 10),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blueAccent,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: TextField(
                            controller: _dateControl,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.date_range,
                                color: Colors.blue,
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(20)),

                            ),
                            enabled: false,
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.green, shape: BoxShape.circle),
                      child: IconButton(
                        icon: Icon(
                          Icons.save_alt_rounded,
                          size: 30,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    )),
                    Expanded(
                        child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.blue, shape: BoxShape.circle),
                      child: IconButton(
                        icon: Icon(
                          Icons.print,
                          size: 30,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    )),
                  ],
                )
              ]),
        ),
      ),
    );
  }

  void callDatePicker() async {
    DateTime now = new DateTime.now();
    DateTimeRange order = await getDate();

    if (order != null) {
      setState(() {
         _dateRange = new DateTimeRange(start: order.start, end: order.end);
         var start = new DateTime( order.start.year, order.start.month, order.start.day ,now.hour, now.minute);
         var end = new DateTime( order.end.year, order.end.month, order.end.day ,now.hour, now.minute);
        _dateControl.text = "${Helpers.dateToText(start)} / ${Helpers.dateToText(end)}";
      });
    }
  }

  Future<DateTimeRange> getDate() {
    return showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
  }
}
