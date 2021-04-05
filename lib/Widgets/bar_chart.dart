import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/CompteTresorie.dart';
import 'CustomWidgets/chart_indicator.dart';
import 'package:google_fonts/google_fonts.dart';


class ChartBar extends StatefulWidget {
  final String chartTitle ;
  final data ;
  final backgroundColor ;
  final textColor ;

  ChartBar({Key key , this.chartTitle ,this.backgroundColor ,this.textColor,this.data}):super(key:key);

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
                    '${S.current.indice}',
                    style: GoogleFonts.lato(textStyle : GoogleFonts.lato(textStyle: TextStyle(color: widget.textColor, fontSize: 22))),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    '${S.current.financiere}',
                    style: GoogleFonts.lato(textStyle: TextStyle(color: widget.textColor, fontSize: 16)),
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
                      groupsSpace: 20,
                      barTouchData: BarTouchData(
                        enabled: true,
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        topTitles: SideTitles(
                          showTitles: true,
                          getTextStyles: (value) => GoogleFonts.lato(textStyle: TextStyle(color: widget.textColor, fontSize: 10)),
                          margin: 10,
                          rotateAngle: 0,
                          getTitles: (double value)=>(getTitle(value.toInt()))
                        ),
                        bottomTitles: SideTitles(
                          showTitles: true,
                          getTextStyles: (value) => GoogleFonts.lato(textStyle: TextStyle(color: widget.textColor, fontSize: 10)),
                          margin: 10,
                          rotateAngle: 0,
                          getTitles: (double value)=>(getTitle(value.toInt()))
                        ),
                        leftTitles: SideTitles(
                          showTitles: true,
                          getTextStyles: (value) => GoogleFonts.lato(textStyle: TextStyle(color: widget.textColor, fontSize: 10)),
                          rotateAngle: 0,
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
              BarChartRodStackItem(0,getYvalue(index),colors[index]),
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
        return (widget.data[index] == null)?0.0:widget.data[index] ;
      }else{
        return (widget.data[index]== null )? 0.0 : widget.data[index]["Sum(Montant)"] ;
      }
    }
    return 0.0 ;
  }

  String getTitle(index){
    if(widget.data is List<CompteTresorie>){
      return widget.data[index].nomCompte;
    }else{
      if(widget.data[0] is double){
        switch(index){
          case 0:
            return "${S.current.ca}";
            break;
          case 1:
            return "${S.current.reg_cl}";
            break;
          case 2:
            return "${S.current.reg_four}";
            break;
          case 3:
            return "${S.current.achat}";
            break;
          case 4:
            return "${S.current.marge}";
            break;
        }
      }else{
        return (widget.data[index] == null)?"":widget.data[index]["Libelle"] ;
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
          color: Theme.of(context).primaryColorDark.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Theme.of(context).primaryColorDark.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Theme.of(context).primaryColorDark.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Theme.of(context).primaryColorDark.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Theme.of(context).primaryColorDark.withOpacity(0.4),
        ),
      ],
    );
  }
}
