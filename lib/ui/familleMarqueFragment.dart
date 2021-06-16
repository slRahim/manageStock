import 'package:flutter/material.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/Widgets/CustomWidgets/bottom_tab_bar.dart';
import 'package:gestmob/Widgets/CustomWidgets/search_bar.dart';
import 'package:gestmob/search/items_sliver_list.dart';
import 'package:gestmob/search/sliver_list_data_source.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:gestmob/models/ArticleFamille.dart';
import 'package:gestmob/models/ArticleTva.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/ArticleMarque.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/models/TiersFamille.dart';
import 'package:gestmob/models/ChargeTresorie.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class FamilleMarqueFragment extends StatefulWidget {
  final QueryCtr _queryCtr = QueryCtr();

  @override
  _FamilleMarqueFragmentState createState() => _FamilleMarqueFragmentState();
}

class _FamilleMarqueFragmentState extends State<FamilleMarqueFragment> {
  bool _finishLoading = false;
  TabController _tabController;
  int _tabSelectedIndex = 0;
  String _tabTitle = S.current.famille_article;

  final TextEditingController searchController = new TextEditingController();
  SliverListDataSource _dataSourceFamilleArticle;
  SliverListDataSource _dataSourceMarqueArticle;
  SliverListDataSource _dataSourceTvaArticle;
  SliverListDataSource _dataSourceFamilleTiers;
  SliverListDataSource _dataSourceCharge;

  TextEditingController _libelleFamilleControl = new TextEditingController();
  TextEditingController _libelleMarqueControl = new TextEditingController();
  TextEditingController _tauxTVAControl = new TextEditingController();
  TextEditingController _libelleFamilleTierControl =
      new TextEditingController();

  @override
  void initState() {
    super.initState();
    futurInit().then((value) {
      setState(() {
        _finishLoading = true;
      });
    });
  }

  Future futurInit() async {
    _dataSourceFamilleArticle =
        await SliverListDataSource(ItemsListTypes.familleArticleList, null);
    _dataSourceMarqueArticle =
        await SliverListDataSource(ItemsListTypes.marqueArticleList, null);
    _dataSourceTvaArticle =
        await SliverListDataSource(ItemsListTypes.tvaArticleList, null);
    _dataSourceFamilleTiers =
        await SliverListDataSource(ItemsListTypes.familleTiersList, null);
    _dataSourceCharge =
        await SliverListDataSource(ItemsListTypes.chargeList, null);
  }

  @override
  Widget build(BuildContext context) {
    if (!_finishLoading) {
      return Scaffold(body: Helpers.buildLoading());
    }
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: SearchBar(
          searchController: searchController,
          mainContext: context,
          title: _tabTitle,
          isFilterOn: false,
          onSearchChanged: (String search) {
            switch (_tabSelectedIndex) {
              case 0:
                _dataSourceFamilleArticle.updateSearchTerm(search);
                break;
              case 1:
                _dataSourceMarqueArticle.updateSearchTerm(search);
                break;
              case 2:
                _dataSourceTvaArticle.updateSearchTerm(search);
                break;
              case 3:
                _dataSourceFamilleTiers.updateSearchTerm(search);
                break;
              case 4:
                _dataSourceCharge.updateSearchTerm(search);
                break;
            }
          },
        ),
        bottomNavigationBar: BottomTabBar(
          selectedIndex: _tabSelectedIndex,
          controller: _tabController,
          onItemSelected: (index) {
            setState(() {
              _tabSelectedIndex = index;
              searchController.clear();
              switch (index) {
                case 0:
                  _tabTitle = S.current.famille_article;
                  break;
                case 1:
                  _tabTitle = S.current.marque_article;
                  break;
                case 2:
                  _tabTitle = S.current.tva_article;
                  break;
                case 3:
                  _tabTitle = S.current.famille_tiers;
                  break;
                case 4:
                  _tabTitle = S.current.cat_charge;
                  break;
              }
            });
          },
          tabs: [
            Tab(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.category),
              ],
            )),
            Tab(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(MdiIcons.copyright),
              ],
            )),
            Tab(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(MdiIcons.percent),
              ],
            )),
            Tab(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people),
              ],
            )),
            Tab(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(MdiIcons.truck),
              ],
            )),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            switch (_tabSelectedIndex) {
              case 0:
                AwesomeDialog(
                    context: context,
                    dialogType: DialogType.NO_HEADER,
                    animType: AnimType.BOTTOMSLIDE,
                    title: S.current.supp,
                    body: addFamilleArticleDialogue(),
                )..show();
                break;
              case 1:
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.NO_HEADER,
                  animType: AnimType.BOTTOMSLIDE,
                  title: S.current.supp,
                  body: addMarquedialogue(),
                )..show();
                break;
              case 2:
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.NO_HEADER,
                  animType: AnimType.BOTTOMSLIDE,
                  title: S.current.supp,
                  body: addTVAdialogue(),
                )..show();
                break;
              case 3:
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.NO_HEADER,
                  animType: AnimType.BOTTOMSLIDE,
                  title: S.current.supp,
                  body: addFamilleTiersdialogue(),
                )..show();
                break;
              case 4:
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.NO_HEADER,
                  animType: AnimType.BOTTOMSLIDE,
                  title: S.current.supp,
                  body: addChargeDialog(),
                )..show();
                break;
            }
          },
          child: Icon(
            Icons.add,
          ),
        ),
        body: Builder(
          builder: (context) => TabBarView(
            controller: _tabController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              ItemsSliverList(dataSource: _dataSourceFamilleArticle),
              ItemsSliverList(dataSource: _dataSourceMarqueArticle),
              ItemsSliverList(dataSource: _dataSourceTvaArticle),
              ItemsSliverList(dataSource: _dataSourceFamilleTiers),
              ItemsSliverList(dataSource: _dataSourceCharge)
            ],
          ),
        ),
      ),
    );
  }

  //***********************************************************************************************************************************************************
  //*************************************************************************add/edit Famille article************************************************************
  Widget addFamilleArticleDialogue() {
    var _famille = ArticleFamille.init();
    var _formKey = GlobalKey<FormState>();
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Builder(
        builder: (context) => SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${S.current.ajouter} ${S.current.famile}",
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  // ImagePickerWidget(
                  //     editMode: editMode,
                  //     scallFactor: 1,
                  //     onImageChange: (File imageFile) =>
                  //         {_famille.setpic(imageFile)}),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 5, right: 5, bottom: 20, top: 20),
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _libelleFamilleControl,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value.isEmpty) {
                            return S.current.msg_champ_oblg;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.view_agenda,
                            color: Colors.blue,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(20)),
                          contentPadding: EdgeInsets.only(left: 10),
                          labelText: S.current.famile,
                          labelStyle: GoogleFonts.lato(
                            textStyle:
                                TextStyle(color: Theme.of(context).hintColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            gapPadding: 3.3,
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 150.0,
                    child: Padding(
                      padding: EdgeInsets.only(right: 0, left: 0),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              _famille.setLibelle(_libelleFamilleControl.text);
                              _libelleFamilleControl.text = "";
                            });
                            await addFamilleArticleIfNotExist(_famille);
                            Navigator.pop(context);
                          }
                        },
                        child: Text("+ ${S.current.ajouter}",
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(color: Colors.white , fontWeight: FontWeight.bold , fontSize: 15),
                            )),
                        color: Colors.green,
                      ),
                    ),
                  )
                ],
              ),
            ),
      );
    });
  }

  Future<void> addFamilleArticleIfNotExist(ArticleFamille famille) async {
    var allFamily = await widget._queryCtr.getAllArticleFamilles();
    int familleIndex = allFamily.indexOf(famille);
    if (familleIndex > -1) {
      Helpers.showToast("Élément existe déja");
    } else {
      int id = await widget._queryCtr
          .addItemToTable(DbTablesNames.articlesFamilles, famille);

      if (id > 0) {
        _dataSourceFamilleArticle.refresh();
      }
    }
  }

//  ************************************************************************************************************************************************************
//***************************************************************************add/edit marque article********************************************************************
  Widget addMarquedialogue() {
    var _marque = new ArticleMarque.init();
    var _formKey = GlobalKey<FormState>();
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Builder(
        builder: (context)=>SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "${S.current.ajouter} ${S.current.marque}",
                style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              // ImagePickerWidget(
              //     editMode: editMode,
              //     scallFactor: 1,
              //     onImageChange: (File imageFile) {
              //       _marque.setpic(imageFile) ;
              //     }
              // ),
              Padding(
                padding: EdgeInsets.only(left: 5, right: 5, bottom: 20, top: 20),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _libelleMarqueControl,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) {
                        return S.current.msg_champ_oblg;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.label,
                        color: Colors.blue,
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(20)),
                      contentPadding: EdgeInsets.only(left: 10),
                      labelText: S.current.marque,
                      labelStyle: GoogleFonts.lato(
                        textStyle:
                        TextStyle(color: Theme.of(context).hintColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        gapPadding: 3.3,
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 150,
                child: Padding(
                  padding: EdgeInsets.only(right: 0, left: 0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          _marque.setLibelle(_libelleMarqueControl.text);
                          _libelleMarqueControl.text = "";
                        });

                        await addMarqueIfNotExist(_marque);
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      "+ ${S.current.ajouter}",
                      style: GoogleFonts.lato(
                          textStyle: TextStyle(color: Colors.white , fontSize: 15 , fontWeight: FontWeight.bold)),
                    ),
                    color: Colors.green,
                  ),
                ),
              )
            ],
          ),
        ),
      ) ;
    });
  }

  Future<void> addMarqueIfNotExist(ArticleMarque marque) async {
    var marques = await widget._queryCtr.getAllArticleMarques();
    int marqueIndex = marques.indexOf(marque);
    if (marqueIndex > -1) {
      Helpers.showToast("Élément existe déja");
    } else {
      int id = await widget._queryCtr
          .addItemToTable(DbTablesNames.articlesMarques, marque);
      if (id > 0) {
        _dataSourceMarqueArticle.refresh();
      }
    }
  }

//  ************************************************************************************************************************************************************
//***************************************************************************add/edit tva article********************************************************************
  Widget addTVAdialogue() {
    var _formKey = GlobalKey<FormState>();
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Builder(
        builder: (context)=>SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("${S.current.ajouter} ${S.current.tva}",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
              Padding(
                padding: EdgeInsets.only(left: 5, right: 5, bottom: 20, top: 20),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _tauxTVAControl,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value.isEmpty) {
                        return S.current.msg_champ_oblg;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        MdiIcons.percent,
                        color: Colors.blue,
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(20)),
                      contentPadding: EdgeInsets.only(left: 10),
                      labelText: S.current.taux_tva,
                      labelStyle: GoogleFonts.lato(
                        textStyle:
                        TextStyle(color: Theme.of(context).hintColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        gapPadding: 3.3,
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 150.0,
                child: Padding(
                  padding: EdgeInsets.only(right: 0, left: 0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        double _taux = double.parse(_tauxTVAControl.text);
                        _tauxTVAControl.text = "";
                        await addTvaIfNotExist(_taux);
                        Navigator.pop(context);
                      }
                    },
                    child: Text("+ ${S.current.ajouter}",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(color: Colors.white , fontWeight: FontWeight.bold , fontSize: 15),
                        )),
                    color: Colors.green,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  Future<void> addTvaIfNotExist(double tvaDouble) async {
    ArticleTva tvaItem = new ArticleTva(tvaDouble);
    var tvas = await widget._queryCtr.getAllArticleTva();
    int tvaIndex = tvas.indexOf(tvaItem);

    if (tvaIndex > -1) {
      Helpers.showToast("Élément existe déja");
    } else {
      int id = await widget._queryCtr
          .addItemToTable(DbTablesNames.articlesTva, new ArticleTva(tvaDouble));

      if (id > 0) {
        _dataSourceTvaArticle.refresh();
      }
    }
  }

//  *********************************************************************************************************************************************************************
//*****************************************************************************add/edit famille tiers*******************************************************************
  Widget addFamilleTiersdialogue() {
    var _famille = TiersFamille.init();
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Builder(
          builder: (context) => SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                "${S.current.ajouter} ${S.current.famile}",
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                )),
                ),
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(5, 20, 5, 20),
                  child: TextField(
                    controller: _libelleFamilleTierControl,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.view_agenda,
                        color: Colors.blue,
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(20)),
                      contentPadding: EdgeInsets.only(left: 10),
                      labelText: S.current.famile,
                      labelStyle: GoogleFonts.lato(
                        textStyle:
                        TextStyle(color: Theme.of(context).hintColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        gapPadding: 3.3,
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 150.0,
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.only(start: 0, end: 0),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      onPressed: () async {
                        setState(() {
                          _famille.libelle =
                              _libelleFamilleTierControl.text;
                          _libelleFamilleTierControl.text = "";
                        });
                        await addFamilleTiersIfNotExist(_famille);
                        Navigator.pop(context);
                      },
                      child: Text(
                        "+ ${S.current.ajouter}",
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold, fontSize: 15 ,
                            )),
                      ),
                      color: Colors.green,
                    ),
                  ),
                )
              ],
            ),
          ));
    });
  }

  Future<void> addFamilleTiersIfNotExist(famille) async {
    var familleTiers = await widget._queryCtr.getAllTierFamilles();
    int familleIndex = familleTiers.indexOf(famille);
    if (familleIndex > -1) {
      Helpers.showToast("Élément existe déja");
    } else {
      int id = await widget._queryCtr
          .addItemToTable(DbTablesNames.tiersFamille, famille);
      if (id > 0) {
        _dataSourceFamilleTiers.refresh();
      }
    }
  }

//  *******************************************************************************************************************************************************************
//*****************************************************************************add/edit charge*************************************************************************
  Widget addChargeDialog() {
    TextEditingController _libelleChargeControl = new TextEditingController();
    var _formKey = GlobalKey<FormState>();
    ChargeTresorie _chargeTresorie = new ChargeTresorie.init();
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Builder(
        builder: (context) => SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${S.current.ajouter} ${S.current.charge}",
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 5, right: 5, bottom: 20, top: 20),
                  child: TextFormField(
                    controller: _libelleChargeControl,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) {
                        return S.current.msg_champ_oblg;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.view_agenda,
                        color: Colors.blue,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: EdgeInsets.only(left: 10),
                      labelText: S.current.categorie,
                      labelStyle: GoogleFonts.lato(
                        textStyle:
                        TextStyle(color: Theme.of(context).hintColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        gapPadding: 3.3,
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 150.0,
                  child: Padding(
                    padding: EdgeInsets.only(right: 0, left: 0),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            _chargeTresorie.libelle =
                                _libelleChargeControl.text;
                            _libelleChargeControl.text = "";
                          });
                          await addChargeIfNotExist(_chargeTresorie);
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        "+ ${S.current.ajouter}",
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold , fontSize: 15)),
                      ),
                      color: Colors.green,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  Future<void> addChargeIfNotExist(ChargeTresorie item) async {
    var charges = await widget._queryCtr.getAllChargeTresorie();
    int chargeIndex = charges.indexOf(item);
    if (chargeIndex > -1) {
      Helpers.showToast("Élément existe déja");
    } else {
      int id = await widget._queryCtr
          .addItemToTable(DbTablesNames.chargeTresorie, item);
      if (id > 0) {
        _dataSourceCharge.refresh();
      }
    }
  }
}
