import 'package:flutter/material.dart';
import 'package:gestmob/Widgets/CustomWidgets/bottom_tab_bar.dart';
import 'package:gestmob/Widgets/CustomWidgets/search_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gestmob/Widgets/bar_chart.dart';
import 'package:gestmob/Widgets/pie_chart.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  TabController _tabController;
  int _tabSelectedIndex = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: SearchBar(
            mainContext: context,
            title: "Dashboard",
            isFilterOn: false,
          ),
          bottomNavigationBar: BottomTabBar(
            selectedIndex: _tabSelectedIndex,
            controller: _tabController,
            tabs: [
              Tab(
                  child: Column(
                children: [
                  Icon(MdiIcons.scaleBalance),
                  SizedBox(height: 1),
                  Text("General"),
                ],
              )),
              Tab(
                  child: Column(
                children: [
                  Icon(MdiIcons.basketUnfill),
                  SizedBox(height: 1),
                  Text("Vente"),
                ],
              )),
              Tab(
                  child: Column(
                children: [
                  Icon(MdiIcons.basketFill),
                  SizedBox(height: 1),
                  Text("Achat"),
                ],
              )),
            ],
          ),
          body: Builder(
            builder: (context) => TabBarView(
              controller: _tabController,
              children: [
                generalCharts(),
                chartDeVente(),
                chartDachat(),
              ],
            ),
          )),
    );
  }

  //*****************************************************************************************************************************************************************************
  //*************************************************************************les tabs du screen**********************************************************************************

  Widget generalCharts() {
    return ListView(
      padding: EdgeInsets.only(bottom: 10),
      children: [
        Container(
          height: 400,
          child: ChartBar(backgroundColor: Color(0xff2c4260) , chartTitle: "indiceFinanciere", data: null,),
        ),
        Container(
            padding: EdgeInsets.all(10),
            child: Text(
              "Mes Comptes",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )
        ),
        Container(
          height: 400,
          child: ChartBar(backgroundColor: Color(0xff2c4230) , data: null,),
        ),
        Container(
            padding: EdgeInsets.all(10),
            child: Text(
              "Repartition des charges",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )
        ),
        Container(
          height: 400,
          child: ChartBar(backgroundColor: Color(0xff020227) , data: null,),
        ),
      ],
    );
  }

  Widget chartDeVente() {
    return ListView(
      padding: EdgeInsets.only(bottom: 10),
      children: [
        Container(
            padding: EdgeInsets.all(10),
            child: Text(
              "Classement des Ventes par article",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )),
        Container(
          height: 400,
          child: ChartPie(
            backgroundColor: Color(0xff2c4260),
            textColor: Colors.white,
          ),
        ),
        Container(
            padding: EdgeInsets.all(10),
            child: Text(
              "Classement des Ventes par client",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )),
        Container(
          height: 400,
          child: ChartPie(
              backgroundColor: Color(0xff2c4230) , textColor: Colors.white),
        ),
        Container(
            padding: EdgeInsets.all(10),
            child: Text(
              "Classement des Ventes par famille",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )),
        Container(
          height: 400,
          child: ChartPie(
              backgroundColor: Colors.white54, textColor: Colors.black),
        )
      ],
    );
  }

  Widget chartDachat() {
    return ListView(
      padding: EdgeInsets.only(bottom: 10),
      children: [
        Container(
            padding: EdgeInsets.all(10),
            child: Text(
              "Classement des Achats par article",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )),
        Container(
          height: 400,
          child: ChartPie(
            backgroundColor: Color(0xff2c4260),
            textColor: Colors.white70,
          ),
        ),
        Container(
            padding: EdgeInsets.all(10),
            child: Text(
              "Classement des Achats par fournisseur",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )),
        Container(
          height: 400,
          child: ChartPie(
              backgroundColor: Colors.white30, textColor: Colors.black),
        ),
      ],
    );
  }
}
