import 'package:flutter/material.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Widgets/CustomWidgets/bottom_tab_bar.dart';
import 'package:gestmob/Widgets/CustomWidgets/search_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gestmob/Widgets/bar_chart.dart';
import 'package:gestmob/Widgets/pie_chart.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/CompteTresorie.dart';
import 'package:gestmob/models/Tiers.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool finishedLoading = false;
  TabController _tabController;
  int _tabSelectedIndex = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  QueryCtr _queryCtr = new QueryCtr();

  Map<int, dynamic> _indiceFinanciere;
  List<CompteTresorie> _soldeCompte;

  var _statCharge;

  var _caArticle;

  List<Tiers> _caClient;

  var _caFamilleArticle;
  List<Tiers> _caFournisseur;
  var _achatArticle;

  @override
  void initState() {
    super.initState();
    futurinit().then((value) {
      setState(() {
        finishedLoading = true;
      });
    });
  }

  Future<bool> futurinit() async {
    _indiceFinanciere = await _queryCtr.statIndiceFinanciere();
    _soldeCompte = await _queryCtr.statSoldeCompte();
    _statCharge = await _queryCtr.statCharge();
    _caArticle = await _queryCtr.statVenteArticle();
    _caClient = await _queryCtr.statVenteClient();
    _caFournisseur = await _queryCtr.statAchatFournisseur();
    _caFamilleArticle = await _queryCtr.statVenteFamille();
    _achatArticle = await _queryCtr.statAchatArticle();
  }

  @override
  Widget build(BuildContext context) {
    if (!finishedLoading) {
      return Scaffold(body: Helpers.buildLoading());
    } else {
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
                    Text("Generale"),
                  ],
                )),
                Tab(
                    child: Column(
                  children: [
                    Icon(MdiIcons.basketUnfill),
                    SizedBox(height: 1),
                    Text("Ventes"),
                  ],
                )),
                Tab(
                    child: Column(
                  children: [
                    Icon(MdiIcons.basketFill),
                    SizedBox(height: 1),
                    Text("Achats"),
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
  }

  //*****************************************************************************************************************************************************************************
  //*************************************************************************les tabs du screen**********************************************************************************

  Widget generalCharts() {
    return ListView(
      padding: EdgeInsets.only(bottom: 10),
      children: [
        Container(
          height: 400,
          child: ChartBar(
            backgroundColor: Color(0xff2c4260),
            chartTitle: "indiceFinanciere",
            data: _indiceFinanciere,
          ),
        ),
        Container(
            padding: EdgeInsets.all(10),
            child: Text(
              "Mes Comptes",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )),
        Container(
          height: 400,
          child: ChartBar(
            backgroundColor: Color(0xff2c4230),
            data: _soldeCompte,
          ),
        ),
        Container(
            padding: EdgeInsets.all(10),
            child: Text(
              "Repartition des charges",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )),
        Container(
          height: 400,
          child: ChartBar(
            backgroundColor: Color(0xff020227),
            data: _statCharge,
          ),
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
              data: _caArticle,
              typeData: "article",
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
              backgroundColor: Color(0xff2c4230),
              textColor: Colors.white,
              data: _caClient,
              typeData: "tiers",
          ),
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
            backgroundColor: Colors.white54,
            textColor: Colors.black,
            data: _caFamilleArticle,
            typeData: "famille",
          ),
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
            data: _achatArticle,
            typeData: "article",
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
            backgroundColor: Colors.white30,
            textColor: Colors.black,
            data: _caFournisseur,
            typeData: "tiers",
          ),
        ),
      ],
    );
  }
}
