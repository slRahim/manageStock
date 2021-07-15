import 'dart:typed_data';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:google_fonts/google_fonts.dart';

import 'CustomWidgets/chart_badge.dart';
import 'CustomWidgets/chart_indicator.dart';

class ChartPie extends StatefulWidget {
  final data;
  final typeData;
  final Color backgroundColor;
  final Color textColor;

  ChartPie(
      {Key key, this.data, this.typeData, this.backgroundColor, this.textColor})
      : super(key: key);

  @override
  _ChartPieState createState() => _ChartPieState();
}

class _ChartPieState extends State<ChartPie> {
  int touchedIndex;
  double _totalSum = 0;
  List<Color> colors = [
    Color(0xff0293ee),
    Color(0xfff8b250),
    Color(0xff845bef),
    Color(0xff13d38e),
    Colors.pinkAccent,
    Colors.cyan,
    Colors.purple,
    Colors.red,
    Colors.amberAccent,
    Colors.deepOrange
  ];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.data.length; i++) {
      _totalSum = _totalSum + getYvalue(i);
    }
    if (_totalSum.isNaN) {
      _totalSum = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        color: widget.backgroundColor,
        elevation: 1,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.waterfall_chart,
                    color: widget.textColor,
                    size: 30,
                  ),
                  SizedBox(
                    width: 38,
                  ),
                  Text(
                    '${S.current.best_5}',
                    style: GoogleFonts.lato(
                        textStyle:
                            TextStyle(color: widget.textColor, fontSize: 22)),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    '${S.current.item}',
                    style: GoogleFonts.lato(
                        textStyle:
                            TextStyle(color: Color(0xff77839a), fontSize: 16)),
                  ),
                ],
              ),
              (widget.data.isNotEmpty)
                  ? Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: PieChart(
                          PieChartData(
                              pieTouchData: PieTouchData(
                                  touchCallback: (pieTouchResponse) {
                                setState(() {
                                  if (pieTouchResponse.touchInput
                                          is FlLongPressEnd ||
                                      pieTouchResponse.touchInput is FlPanEnd) {
                                    touchedIndex = -1;
                                  } else {
                                    touchedIndex =
                                        pieTouchResponse.touchedSectionIndex;
                                  }
                                });
                              }),
                              borderData: FlBorderData(
                                show: false,
                              ),
                              sectionsSpace: 5,
                              centerSpaceRadius: 15,
                              centerSpaceColor: Colors.white,
                              sections: showingSections()),
                        ),
                      ),
                    )
                  : SizedBox(),
              (widget.data.isNotEmpty)
                  ? Container(
                      height: 30,
                      child: ListView(
                        padding: EdgeInsets.all(2),
                        scrollDirection: Axis.horizontal,
                        children: getIndicator(),
                      ),
                    )
                  : SizedBox(),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> getIndicator() {
    List<Widget> indicators = new List<Widget>();
    for (int i = 0; i < widget.data.length; i++) {
      indicators.add(Indicator(
        color: colors[i],
        text: getTitle(i),
        isSquare: false,
        textColor: widget.textColor,
      ));
      indicators.add(SizedBox(
        width: 6,
      ));
    }

    return indicators;
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(widget.data.length, (index) {
      final isTouched = index == touchedIndex;
      final double fontSize = isTouched ? 20 : 16;
      final double radius = isTouched ? 130 : 110;
      final double widgetSize = isTouched ? 55 : 40;

      return PieChartSectionData(
        color: colors[index],
        value: (getYvalue(index) == 0 && widget.data.length == 1)
            ? 1
            : getYvalue(index),
        title: (!(getYvalue(index) * 100 / _totalSum).isNaN)
            ? '${(getYvalue(index) * 100 / _totalSum).toStringAsFixed(2)} %'
                .toString()
            : "0.0 %",
        radius: radius,
        titleStyle: GoogleFonts.lato(
          textStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff)),
        ),
        badgeWidget:
            (widget.typeData != "charge" && widget.typeData != "famille")
                ? Badge(
                    getImage(index),
                    size: widgetSize,
                    borderColor: Colors.yellow[700],
                  )
                : null,
        badgePositionPercentageOffset: .98,
      );
    });
  }

  double getYvalue(int index) {
    switch (widget.typeData) {
      case ("article"):
        return widget.data[index]["Sum(Journaux.Qte*Journaux.Net_ht)"];
        break;
      case ("tiers"):
        return widget.data[index].chiffre_affaires;
        break;
      case ("famille"):
        return widget.data[index]["Sum(Journaux.Qte*Journaux.Net_ht)"];
        break;
      case ("charge"):
        return widget.data[index]["Sum(Montant)"];
        break;
    }
    ;
  }

  String getTitle(index) {
    switch (widget.typeData) {
      case ("article"):
        return widget.data[index]["Designation"];
        break;
      case ("tiers"):
        return widget.data[index].raisonSociale;
        break;
      case ("famille"):
        if(widget.data[index]["Libelle"] == 'No Famille'){
          return S.current.no_defenie ;
        }
        return widget.data[index]["Libelle"];
        break;
      case ("charge"):
        if(widget.data[index]["Libelle"] == 'No Categorie'){
          return S.current.no_defenie ;
        }
        return widget.data[index]["Libelle"];
        break;
    }
  }

  Uint8List getImage(index) {
    switch (widget.typeData) {
      case ("article"):
        return Helpers.getUint8ListFromByteString(
            widget.data[index]["BytesImageString"]);
        break;
      case ("tiers"):
        return widget.data[index].imageUint8List;
        break;
    }
  }
}
