import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gestmob/models/CompteTresorie.dart';

import 'CustomWidgets/chart_indicator.dart';

class ChartBar extends StatefulWidget {
  final String chartTitle ;
  final data ;
  final backgroundColor ;

  ChartBar({Key key , this.chartTitle ,this.backgroundColor ,this.data}):super(key:key);

  @override
  _ChartBarState createState() => _ChartBarState();
}

class _ChartBarState extends State<ChartBar> {

  final double barWidth = 22;
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
      aspectRatio: 1,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        color: widget.backgroundColor,
        child: Padding(
          padding: const EdgeInsetsDirectional.only(top: 16 , bottom: 16 , start: 10 , end: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              (widget.chartTitle != null)?Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  makeTransactionsIcon(),
                  SizedBox(
                    width: 38,
                  ),
                  Text(
                    'Indice',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    'financiere',
                    style: TextStyle(color: Color(0xff77839a), fontSize: 16),
                  ),
                ],
              )
              : SizedBox(),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal:0),
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.center,
                      groupsSpace: 30,
                      barTouchData: BarTouchData(
                        enabled: true,
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        topTitles: SideTitles(
                          showTitles: true,
                          getTextStyles: (value) =>
                          const TextStyle(color: Colors.white, fontSize: 10),
                          margin: 10,
                          rotateAngle: 0,
                          getTitles: (double value)=>(getTitle(value.toInt()))
                        ),
                        bottomTitles: SideTitles(
                          showTitles: true,
                          getTextStyles: (value) =>
                          const TextStyle(color: Colors.white, fontSize: 10),
                          margin: 10,
                          rotateAngle: 0,
                          getTitles: (double value)=>(getTitle(value.toInt()))
                        ),
                        leftTitles: SideTitles(
                          showTitles: true,
                          getTextStyles: (value) =>
                          const TextStyle(color: Colors.white, fontSize: 10),
                          rotateAngle: 20,
                          interval: 100,
                        ),
                        rightTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        checkToShowHorizontalLine: (value) => value % 5 == 0,
                        getDrawingHorizontalLine: (value) {
                          if (value == 0) {
                            return FlLine(
                                color: const Color(0xff363753), strokeWidth: 3);
                          }
                          return FlLine(
                            color: const Color(0xff2a2747),
                            strokeWidth: 0.8,
                          );
                        },
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      barGroups: showingBars(),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );

  }

  List<BarChartGroupData> showingBars(){
    return List.generate(widget.data.length , (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            y: getYvalue(index),
            width: barWidth,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6)
            ),
            rodStackItems:  [
              // BarChartRodStackItem(0,widget.data[index],colors[index]),
              BarChartRodStackItem(
                  500, 1000, const Color(0xff19bfff)),
              BarChartRodStackItem(
                  200, 400, const Color(0xffff4d94)),
              BarChartRodStackItem(
                  100, 200, const Color(0xffffdd80)),
              BarChartRodStackItem(
                  0, 100, const Color(0xff2bdb90)),
              BarChartRodStackItem(
                  0, -100, const Color(0xff2bdb90)),
              BarChartRodStackItem(
                  -100, -200, const Color(0xffffdd80)),
              BarChartRodStackItem(
                  -200, -400, const Color(0xffff4d94)),
              BarChartRodStackItem(
                  -500, -1000, const Color(0xff19bfff)),
            ],
          ),
        ],
      ) ;
    });
  }
  
  double getYvalue(int index){
    if(widget.data is List<CompteTresorie>){
      return widget.data[index].solde ;
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
    if(widget.data is List<CompteTresorie>){
      return widget.data[index].nomCompte;
    }else{
      if(widget.data[index] is double){
        switch(index){
          case 0:
            return "C.A";
            break;
          case 1:
            return "Reg.Cl";
            break;
          case 2:
            return "Reg.Four";
            break;
          case 3:
            return "Achats";
            break;
          case 4:
            return "Marge";
            break;
        }
      }else{
        return widget.data[index]["Libelle"] ;
      }
    }
    return "" ;
  }

  Widget makeTransactionsIcon() {
    const double width = 4.5;
    const double space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
      ],
    );
  }
}
