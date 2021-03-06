import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/Widgets/CustomWidgets/search_bar.dart';
import 'package:gestmob/Widgets/utils.dart' as utils;
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/MyParams.dart';
import 'package:gestmob/models/Tresorie.dart';
import 'package:gestmob/models/TresorieCategories.dart';
import 'package:gestmob/search/items_sliver_list.dart';
import 'package:gestmob/search/sliver_list_data_source.dart';
import 'package:gestmob/services/push_notifications.dart';
import 'package:google_fonts/google_fonts.dart';

class TresorieFragment extends StatefulWidget {
  @override
  _TresorieFragmentState createState() => _TresorieFragmentState();
}

class _TresorieFragmentState extends State<TresorieFragment> {
  bool isFilterOn = false;
  final TextEditingController searchController = new TextEditingController();

  var _filterMap = new Map<String, dynamic>();
  var _emptyFilterMap = new Map<String, dynamic>();

  List<TresorieCategories> _categorieItems;
  List<DropdownMenuItem<TresorieCategories>> _categorieDropdownItems;

  TresorieCategories _selectedCategorie;
  int _savedSelectedCategorie = 0;

  DateTime _firstDate = DateTime(2020);
  TextEditingController _startDateControl = new TextEditingController();
  DateTime _filterStartDate;
  DateTime _savedFilterStartDate;

  TextEditingController _endDateControl = new TextEditingController();
  DateTime _filterEndDate;
  DateTime _savedFilterEndDate;

  SliverListDataSource _dataSource;
  MyParams _myParams;
  String feature6 = 'feature6';

  @override
  Future<void> initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      FeatureDiscovery.discoverFeatures(context, <String>{feature6});
    });
    fillFilter(_filterMap);
    fillFilter(_emptyFilterMap);
    _dataSource = SliverListDataSource(ItemsListTypes.tresorieList, _filterMap);
  }

  @override
  void didChangeDependencies() {
    PushNotificationsManagerState data = PushNotificationsManager.of(context);
    _myParams = data.myParams;
  }

  //*************************************************************************************************************************************
  //***************************************************partie speciale pour le filtre de recherche***************************************
  void fillFilter(Map<String, dynamic> filter) {
    filter["Categorie"] = _savedSelectedCategorie + 1;
    filter["Start_date"] = _savedFilterStartDate;
    filter["End_date"] = _savedFilterEndDate;
  }

  Future<Widget> futureInitState() async {
    _categorieItems = await _dataSource.queryCtr.getAllTresorieCategorie();

    _categorieItems[0].libelle = S.current.choisir;
    _categorieItems[1].libelle = S.current.reglemnt_client;
    _categorieItems[2].libelle = S.current.reglement_fournisseur;
    _categorieItems[3].libelle = S.current.encaissement;
    _categorieItems[4].libelle = S.current.charge;
    _categorieItems[5].libelle = S.current.rembourcement_client;
    _categorieItems[6].libelle = S.current.rembourcement_four;
    _categorieItems[7].libelle = S.current.decaissement;

    _categorieDropdownItems =
        utils.buildDropTresorieCategoriesDownMenuItems(_categorieItems);
    _selectedCategorie = _categorieItems[_savedSelectedCategorie];
    _filterStartDate = _savedFilterStartDate;
    _filterEndDate = _savedFilterEndDate;

    final tile = StatefulBuilder(builder: (context, StateSetter _setState) {
      return Builder(
        builder: (context) => SingleChildScrollView(
          child: Column(
            children: [
              startDate(_setState),
              endDate(_setState),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: categorieDropDown(_setState),
              )
            ],
          ),
        ),
      );
    });

    return Wrap(children: [
      Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.only(start: 5, end: 5, bottom: 5),
              child: tile,
            ),
          ],
        ),
      ),
    ]);
  }

  Widget addFilterdialogue() {
    return FutureBuilder(
        future: futureInitState(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Dialog(
              child: Container(
                  height: 100.0,
                  width: 100.0,
                  child: Center(
                    child: CircularProgressIndicator(),
                  )),
            );
          } else {
            return snapshot.data;
          }
        });
  }

  Widget startDate(StateSetter _setState) {
    return InkWell(
      onTap: () async {
        DateTime order = await getDate(DateTime.now() , DateTime(2020));
        if (order != null) {
          DateTime time = new DateTime(order.year, order.month, order.day);
          _setState(() {
             _firstDate = time ;
            _startDateControl.text = Helpers.dateToText(time);
            _filterStartDate = order;
          });
        }
      },
      onLongPress: () {
        _setState(() {
          _firstDate = DateTime(2020) ;
          _startDateControl.text = "";
          _filterStartDate = _emptyFilterMap["Start_date"];
        });
      },
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.calendar_today,
            color: Colors.blue,
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.circular(5)),
          labelText: S.current.start_date,
          labelStyle:
              GoogleFonts.lato(textStyle: TextStyle(color: Colors.blue)),
          enabledBorder: OutlineInputBorder(
            gapPadding: 3.3,
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
        enabled: false,
        controller: _startDateControl,
        keyboardType: TextInputType.text,
      ),
    );
  }

  Widget endDate(StateSetter _setState) {
    return InkWell(
      onTap: () async {
        DateTime order = await getDate(DateTime.now() , _firstDate);
        if (order != null) {
          DateTime time =
              new DateTime(order.year, order.month, order.day, 23, 59, 0, 0);
          _setState(() {
            _endDateControl.text = Helpers.dateToText(time);
            _filterEndDate = order;
          });
        }
      },
      onLongPress: () {
        _setState(() {
          _endDateControl.text = "";
          _filterEndDate = _emptyFilterMap["End_date"];
        });
      },
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.calendar_today,
            color: Colors.blue,
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.circular(5)),
          labelText: S.current.end_date,
          labelStyle:
              GoogleFonts.lato(textStyle: TextStyle(color: Colors.blue)),
          enabledBorder: OutlineInputBorder(
            gapPadding: 3.3,
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
        enabled: false,
        controller: _endDateControl,
        keyboardType: TextInputType.text,
      ),
    );
  }

  Widget categorieDropDown(StateSetter _setState) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<TresorieCategories>(
          value: _selectedCategorie,
          items: _categorieDropdownItems,
          onChanged: (value) {
            _setState(() {
              _selectedCategorie = value;
            });
          }),
    );
  }

  //*********************************************************************************************************************************************************************************
  //********************************************************************** partie de la date ****************************************************************************************

  Future<DateTime> getDate(DateTime dateTime , DateTime firsDate) {
    return showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: firsDate,
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget child) {
        return child;
      },
    );
  }

  //**************************************************************************************************************************************
  //********************************************listing des pieces**********************************************************************
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor:
              Theme.of(context).floatingActionButtonTheme.backgroundColor,
          onPressed: ()=>_addNewTresorie(context),
          child: Icon(Icons.add),
        ),
        appBar: SearchBar(
          searchController: searchController,
          mainContext: context,
          title: S.current.tresories,
          isFilterOn: isFilterOn,
          onSearchChanged: (String search) =>
              _dataSource.updateSearchTerm(search.trim()),
          onFilterPressed: _pressFilter,
        ),
        body: ItemsSliverList(
          dataSource: _dataSource,
        ));
  }

  _pressFilter(){
    AwesomeDialog(
        context: context,
        dialogType: DialogType.INFO,
        animType: AnimType.BOTTOMSLIDE,
        title: S.current.supp,
        body: addFilterdialogue(),
        btnOkText: S.current.filtrer_btn,
        closeIcon: Icon(
          Icons.cancel_sharp,
          color: Colors.red,
          size: 26,
        ),
        showCloseIcon: true,
        btnOkOnPress: () async {
          setState(() {
            _savedSelectedCategorie =
                _categorieItems.indexOf(_selectedCategorie);
            _savedFilterStartDate = _filterStartDate;
            _savedFilterEndDate = _filterEndDate;
            fillFilter(_filterMap);

            if (_filterMap.toString() == _emptyFilterMap.toString()) {
              isFilterOn = false;
            } else {
              isFilterOn = true;
            }
            _dataSource.updateFilters(_filterMap);
          });
        })
      ..show();
  }
  _addNewTresorie(context) {
    if (_myParams.versionType == "demo") {
      if (_dataSource.itemCount < 10) {
        Navigator.of(context)
            .pushNamed(RoutesKeys.addTresorie, arguments: new Tresorie.init())
            .then((value) {
          _dataSource.refresh();
        });
      } else {
        Navigator.pushNamed(context, RoutesKeys.appPurchase);
        var message = S.current.msg_demo_exp;
        Helpers.showToast(message);
      }
    } else {
      if (DateTime.now().isBefore(Helpers.getDateExpiration(_myParams))) {
        Navigator.of(context)
            .pushNamed(RoutesKeys.addTresorie, arguments: new Tresorie.init())
            .then((value) {
          _dataSource.refresh();
        });
      } else {
        Navigator.pushNamed(context, RoutesKeys.appPurchase);
        var message = S.current.msg_premium_exp;
        Helpers.showToast(message);
      }
    }
  }
}
