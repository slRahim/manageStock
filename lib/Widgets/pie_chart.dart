import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gestmob/models/Tiers.dart';

import 'CustomWidgets/chart_badge.dart';
import 'CustomWidgets/chart_indicator.dart';

class ChartPie extends StatefulWidget {
  final data;
  final typeData ;
  final Color backgroundColor;
  final Color textColor;

  ChartPie({Key key, this.data, this.typeData ,this.backgroundColor, this.textColor})
      : super(key: key);

  @override
  _ChartPieState createState() => _ChartPieState();
}

class _ChartPieState extends State<ChartPie> {
  int touchedIndex;
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
                  Icon(Icons.waterfall_chart , color: widget.textColor , size: 30,),
                  SizedBox(
                    width: 38,
                  ),
                  Text(
                    'Best Five',
                    style: TextStyle(color: widget.textColor, fontSize: 22),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    'items',
                    style: TextStyle(color: Color(0xff77839a), fontSize: 16),
                  ),
                ],
              ),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                        pieTouchData:
                            PieTouchData(touchCallback: (pieTouchResponse) {
                          setState(() {
                            if (pieTouchResponse.touchInput is FlLongPressEnd ||
                                pieTouchResponse.touchInput is FlPanEnd) {
                              touchedIndex = -1;
                            } else {
                              touchedIndex = pieTouchResponse.touchedSectionIndex;
                            }
                          });
                        }),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 5,
                        centerSpaceRadius: 25,
                        centerSpaceColor: Colors.lightGreen[300],
                        sections: showingSections()),
                  ),
                ),
              ),
              Container(
                height: 30,
                child: ListView(
                  padding: EdgeInsets.all(2),
                  scrollDirection: Axis.horizontal,
                  children: getIndicator(),
                ),
              ),
              SizedBox(height: 10,)

            ],
          ),
        ),
      ),
    );
  }

  List <Widget> getIndicator(){
    List<Widget> indicators = new List<Widget>();
    for(int i=0 ; i < widget.data.length; i++){
      indicators.add( Indicator(
        color: colors[i],
        text: getTitle(i),
        isSquare: false,
        textColor: widget.textColor,
      ));
      indicators.add(SizedBox(width: 6,));
    }

    return indicators ;
  }

  List<PieChartSectionData> showingSections() {

    return List.generate(widget.data.length , (index) {
      final isTouched = index == touchedIndex;
      final double fontSize = isTouched ? 20 : 16;
      final double radius = isTouched ? 110 : 100;
      final double widgetSize = isTouched ? 55 : 40;

      return PieChartSectionData(
        color: colors[index],
        value: (index.toDouble() + 1),
        title: '${(index)*10}%',
        radius: radius,
        titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff)),
        badgeWidget: Badge(
          'assets/worker-svgrepo-com.svg',
          size: widgetSize,
          borderColor: const Color(0xff0293ee),
        ),
        badgePositionPercentageOffset: .98,
      );
    });
  }

  double getYvalue(int index){
    if(widget.data is List<Tiers>){
      return widget.data[index].raisonSociale ;
    }else{
      if(widget.data[index] is double){
        return widget.data[index] ;
      }else{
        return widget.data[index]["Sum(Montant)"] ;
      }
    }
    return 0.0 ;
  }

  String getTitle(index){
    switch(widget.typeData){
      case ("article"):
        return widget.data[index]["Designation"];
        break ;
      case ("tiers"):
        return widget.data[index].raisonSociale;
        break ;
      case ("famille"):
        return  widget.data[index]["Libelle"] ;
        break ;
    }

  }
}
