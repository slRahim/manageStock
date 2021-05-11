import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/Widgets/CustomWidgets/search_bar.dart';
import 'package:gestmob/Widgets/article_list_item.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/Article.dart';
import 'package:gestmob/models/ArticleFamille.dart';
import 'package:gestmob/models/ArticleMarque.dart';
import 'package:gestmob/models/Piece.dart';
import 'package:gestmob/search/items_sliver_list.dart';
import 'package:gestmob/search/search_input_sliver.dart';
import 'package:gestmob/search/sliver_list_data_source.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:gestmob/Widgets/utils.dart' as utils;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'AddArticlePage.dart';
import 'package:gestmob/services/push_notifications.dart';
import 'package:gestmob/models/MyParams.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';

class PiecesFragment extends StatefulWidget {
  final int clientFourn;
  final String peaceType ;
  final int tierId ;

  final Function(dynamic) onConfirmSelectedItem;

  const PiecesFragment ({Key key, this.clientFourn , this.peaceType,this.tierId,this.onConfirmSelectedItem}): super(key: key);

  @override
  _PiecesFragmentState createState() => _PiecesFragmentState();
}

class _PiecesFragmentState extends State<PiecesFragment> {
  bool isFilterOn = false;
  final TextEditingController searchController = new TextEditingController();

  var _filterMap = new Map<String, dynamic>();
  var _emptyFilterMap = new Map<String, dynamic>();
  var _tier_id ;

  bool _filterInHasCredit = false;
  bool _savedFilterHasCredit = false;

  bool _filterIsDraft = false;
  bool _savedFilterIsDraft = false;

  TextEditingController _startDateControl = new TextEditingController();
  DateTime _filterStartDate ;
  DateTime _savedFilterStartDate ;

  TextEditingController _endDateControl = new TextEditingController();
  DateTime _filterEndDate ;
  DateTime _savedFilterEndDate ;

  SliverListDataSource _dataSource;
  MyParams _myParams;
  String feature5 = 'feature5';

  @override
  Future<void> initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      FeatureDiscovery.discoverFeatures(context, <String>{feature5});
    });
    _tier_id = widget.tierId ;
    fillFilter(_filterMap);
    fillFilter(_emptyFilterMap);
    _dataSource = SliverListDataSource(ItemsListTypes.pieceList, _filterMap);
  }

  @override
  void didChangeDependencies() {
    PushNotificationsManagerState data = PushNotificationsManager.of(context);
    _myParams = data.myParams;
  }

  //*************************************************************************************************************************************
  //***************************************************partie speciale pour le filtre de recherche***************************************
  void fillFilter(Map<String, dynamic> filter) {
    filter["Piece"] = widget.peaceType ;
    filter["Mov"] = 0;
    filter["Credit"] = _savedFilterHasCredit ;
    filter["Draft"] = _savedFilterIsDraft ;
    filter["Tierid"] = _tier_id ;
    filter["Start_date"] = _savedFilterStartDate ;
    filter["End_date"] = _savedFilterEndDate ;
  }

  Future<Widget> futureInitState() async {
    _filterInHasCredit = _savedFilterHasCredit;
    _filterIsDraft = _savedFilterIsDraft ;
    _filterStartDate = _savedFilterStartDate ;
    _filterEndDate = _savedFilterEndDate ;

    final tile = StatefulBuilder(builder: (context, StateSetter _setState) {
      return Builder(
        builder: (context) => Column(
          children: [
            startDate(_setState),
            endDate(_setState),
            isDraftCheckBox(_setState),
            hasCreditCheckBox(_setState)
          ],
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
                  )
              ),
            );
          } else {
            return snapshot.data;
          }
        });
  }

  Widget startDate(StateSetter _setState){
      return InkWell(
        onTap: () async {
          DateTime order = await getDate(DateTime.now());
          if (order != null) {
            DateTime time = new DateTime(
                order.year, order.month, order.day);
            _setState(() {
              _startDateControl.text = Helpers.dateToText(time);
              _filterStartDate = order ;
            });
          }
        },
        onLongPress: (){
          _setState(() {
            _startDateControl.text = "";
            _filterStartDate = _emptyFilterMap["Start_date"] ;
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
                borderRadius: BorderRadius.circular(20)),
            labelText: S.current.start_date,
            labelStyle: GoogleFonts.lato(textStyle: TextStyle(color: Colors.blue)),
            enabledBorder: OutlineInputBorder(
              gapPadding: 3.3,
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
          enabled: false,
          controller: _startDateControl,
          keyboardType: TextInputType.text,
        ),
      ) ;
  }

  Widget endDate(StateSetter _setState){
    return InkWell(
      onTap: () async {
        DateTime order = await getDate(DateTime.now());
        if (order != null) {
          DateTime time = new DateTime(
              order.year, order.month, order.day, 23 , 59 , 0 , 0);
          _setState(() {
            _endDateControl.text = Helpers.dateToText(time);
            _filterEndDate = order ;
          });
        }
      },
      onLongPress: (){
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
              borderRadius: BorderRadius.circular(20)),
          labelText: S.current.end_date,
          labelStyle:GoogleFonts.lato(textStyle: TextStyle(color: Colors.blue)),
          enabledBorder: OutlineInputBorder(
            gapPadding: 3.3,
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
        enabled: false,
        controller: _endDateControl,
        keyboardType: TextInputType.text,
      ),
    ) ;
  }

  Widget isDraftCheckBox(StateSetter _setState) {
    return CheckboxListTile(
      title: Text(S.current.aff_draft, style: GoogleFonts.lato(),),
      value: _filterIsDraft,
      onChanged: (bool value){
        _setState(() {
          _filterIsDraft = value;
        });
      },
    );
  }

  Widget hasCreditCheckBox(StateSetter _setState) {
    return CheckboxListTile(
      title: Text(S.current.a_credit, style: GoogleFonts.lato(),),
      value: _filterInHasCredit,
      onChanged: (bool value){
        _setState(() {
          _filterInHasCredit = value;
        });
      },
    );
  }

  //*********************************************************************************************************************************************************************************
  //********************************************************************** partie de la date ****************************************************************************************

  Future<DateTime> getDate(DateTime dateTime) {
    return showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
      builder: (BuildContext context, Widget child) {
        return child;
      },
    );
  }

  //**************************************************************************************************************************************
  //********************************************listing des pieces**********************************************************************
  @override
  Widget build(BuildContext context) {
    setState(() {
      _filterMap ["Piece"] = widget.peaceType ;
    });
    _dataSource.updateFilters(_filterMap);

    return Scaffold(
        floatingActionButton:(widget.onConfirmSelectedItem == null) ? FloatingActionButton(
          backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
          onPressed: () {
              _addNewPiece(context);
          },
          child: Icon(Icons.add),
        ):null,
        appBar: SearchBar(
          searchController: searchController,
          mainContext: widget.onConfirmSelectedItem != null ? null : context,
          title: (widget.peaceType !=null && widget.peaceType != "TR") ? Helpers.getPieceTitle(widget.peaceType) : S.current.piece_titre,
          isFilterOn: isFilterOn,
          onSearchChanged: (String search) => _dataSource.updateSearchTerm(search),
          onFilterPressed: () async {
            if(widget.tierId != null){
              var message = S.current.filtre_non_dispo;
              Helpers.showFlushBar(context, message);
            }else{
              AwesomeDialog(
                  context: context,
                  dialogType: DialogType.INFO,
                  animType: AnimType.BOTTOMSLIDE,
                  body: addFilterdialogue(),
                  btnOkText: S.current.filtrer_btn,
                  closeIcon: Icon(Icons.close , color: Colors.red , size: 26,),
                  showCloseIcon: true,
                  btnOkOnPress: () async{
                    setState(() {
                      _savedFilterIsDraft = _filterIsDraft ;
                      _savedFilterHasCredit = _filterInHasCredit;
                      _savedFilterStartDate = _filterStartDate ;
                      _savedFilterEndDate = _filterEndDate ;

                      fillFilter(_filterMap);

                      if( _filterMap.toString() == _emptyFilterMap.toString()){
                        isFilterOn = false;
                      } else{
                        isFilterOn = true;
                      }
                      _dataSource.updateFilters(_filterMap);
                    });
                  }
              )..show();
            }
          },
        ),
        body: ItemsSliverList(
            dataSource: _dataSource,
            onItemSelected: (widget.onConfirmSelectedItem != null ) ? (selectedItem) {
              widget.onConfirmSelectedItem(selectedItem);
              Navigator.pop(context);
            } : null
        )
    );
  }

  _addNewPiece(context){
    if(_myParams.versionType == "demo"){
      if(_dataSource.itemCount < 10){
        Navigator.of(context).pushNamed(RoutesKeys.addPiece, arguments: new Piece.typePiece(widget.peaceType))
            .then((value){
          _dataSource.refresh();
        });
      }else{
        Navigator.pushNamed(context, RoutesKeys.appPurchase);
        var message = S.current.msg_demo_exp;
        Helpers.showFlushBar(context, message);
      }
    }else{
      if(DateTime.now().isBefore(Helpers.getDateExpiration(_myParams))){
        Navigator.of(context).pushNamed(RoutesKeys.addPiece, arguments: new Piece.typePiece(widget.peaceType))
            .then((value){
          _dataSource.refresh();
        });
      }else{
        Navigator.pushNamed(context, RoutesKeys.appPurchase);
        var message = S.current.msg_premium_exp;
        Helpers.showFlushBar(context, message);
      }
    }
  }


}
