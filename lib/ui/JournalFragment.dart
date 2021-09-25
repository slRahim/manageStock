import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/Widgets/CustomWidgets/search_bar.dart';
import 'package:gestmob/Widgets/CustomWidgets/select_items_bar.dart';
import 'package:gestmob/Widgets/utils.dart' as utils;
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/ArticleFamille.dart';
import 'package:gestmob/models/ArticleMarque.dart';
import 'package:gestmob/models/Tiers.dart';
import 'package:gestmob/search/items_sliver_list.dart';
import 'package:gestmob/search/sliver_list_data_source.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/src/services/platform_channel.dart';
import 'dart:async';

class JournalFragment extends StatefulWidget {
  final Function(List<dynamic>) onConfirmSelectedItems;
  final Tiers tier;
  final String pieceType;

  const JournalFragment(
      {Key key, this.onConfirmSelectedItems, this.tier, this.pieceType})
      : super(key: key);
  @override
  _JournalFragmentState createState() => _JournalFragmentState();
}

class _JournalFragmentState extends State<JournalFragment> {
  bool isFilterOn = false;
  final TextEditingController searchController = new TextEditingController();
  List<dynamic> _selectedItems = new List<Object>();

  var _filterMap = new Map<String, dynamic>();
  var _emptyFilterMap = new Map<String, dynamic>();

  List<ArticleMarque> _marqueItems;
  List<DropdownMenuItem<ArticleMarque>> _marqueDropdownItems;

  List<ArticleFamille> _familleItems;
  List<DropdownMenuItem<ArticleFamille>> _familleDropdownItems;

  ArticleMarque _selectedMarque;
  ArticleFamille _selectedFamille;

  int _savedSelectedMarque = 0;
  int _savedSelectedFamille = 0;

  DateTime _firstDate = DateTime(2020);
  TextEditingController _startDateControl = new TextEditingController();
  DateTime _filterStartDate;
  DateTime _savedFilterStartDate;

  TextEditingController _endDateControl = new TextEditingController();
  DateTime _filterEndDate;
  DateTime _savedFilterEndDate;

  SliverListDataSource _dataSource;

  static const _stream = const EventChannel('pda.flutter.dev/scanEvent');
  StreamSubscription subscription;


  @override
  Future<void> initState() {
    super.initState();

    fillFilter(_filterMap);
    fillFilter(_emptyFilterMap);
    _dataSource = SliverListDataSource(ItemsListTypes.journalList, _filterMap);

    subscription = _stream.receiveBroadcastStream().listen(_pdaScanner);

  }


  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  //***************************************************partie speciale pour le filtre de recherche***************************************
  Future<Widget> futureInitState() async {
    _marqueItems = await _dataSource.queryCtr.getAllArticleMarques();
    _marqueItems[0].setLibelle(S.current.no_marque);

    _familleItems = await _dataSource.queryCtr.getAllArticleFamilles();
    _familleItems[0].setLibelle(S.current.no_famille);

    _marqueDropdownItems = utils.buildMarqueDropDownMenuItems(_marqueItems);
    _familleDropdownItems = utils.buildDropFamilleArticle(_familleItems);

    _selectedMarque = _marqueItems[_savedSelectedMarque];
    _selectedFamille = _familleItems[_savedSelectedFamille];

    _filterStartDate = _savedFilterEndDate;
    _filterEndDate = _savedFilterEndDate;

    final tile = StatefulBuilder(builder: (context, StateSetter _setState) {
      return Builder(
        builder: (context) => Column(
          children: [
            startDate(_setState),
            endDate(_setState),
            ListTile(
              title: new Text(
                S.current.marque,
                style: GoogleFonts.lato(),
              ),
              trailing: marquesDropDown(_setState),
            ),
            ListTile(
              title: new Text(
                S.current.famile,
                style: GoogleFonts.lato(),
              ),
              trailing: famillesDropDown(_setState),
            ),
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
        DateTime order = await getDate(DateTime.now(), DateTime(2020));
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
        DateTime order = await getDate(DateTime.now(),_firstDate);
        if (order != null) {
          DateTime time = new DateTime(order.year, order.month, order.day);
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

  Widget marquesDropDown(StateSetter _setState) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<ArticleMarque>(
          value: _selectedMarque,
          items: _marqueDropdownItems,
          onChanged: (value) {
            _setState(() {
              _selectedMarque = value;
            });
          }),
    );
  }

  Widget famillesDropDown(StateSetter _setState) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<ArticleFamille>(
          value: _selectedFamille,
          items: _familleDropdownItems,
          onChanged: (value) {
            _setState(() {
              _selectedFamille = value;
            });
          }),
    );
  }

  void fillFilter(Map<String, dynamic> filter) {
    filter["idTier"] = widget.tier;
    switch (widget.pieceType) {
      case PieceType.retourClient:
        filter["pieceType"] = PieceType.bonLivraison;
        break;
      case PieceType.avoirClient:
        filter["pieceType"] = PieceType.factureClient;
        break;
      case PieceType.retourFournisseur:
        filter["pieceType"] = PieceType.bonReception;
        break;
      case PieceType.avoirFournisseur:
        filter["pieceType"] = PieceType.factureFournisseur;
        break;
    }
    filter["Id_Marque"] = _savedSelectedMarque;
    filter["Id_Famille"] = _savedSelectedFamille;
    filter["Start_date"] = _savedFilterStartDate;
    filter["End_date"] = _savedFilterEndDate;
  }

  //*********************************************************************************************************************************************************************************
  //********************************************************************** partie de la date ****************************************************************************************

  Future<DateTime> getDate(DateTime dateTime ,DateTime firsDate) {
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

  //********************************************listing des pieces**********************************************************************
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getAppBar(setState),
        floatingActionButton: FloatingActionButton(
          onPressed: () => scanBarCode(),
          child: Icon(MdiIcons.barcode),
          tooltip: S.current.scan_qr,
        ),
        body: ItemsSliverList(
            dataSource: _dataSource,
            canRefresh: _selectedItems.length <= 0,
            articleOriginalList: [],
            onItemSelected: widget.onConfirmSelectedItems != null
                ? (selectedItem) {
                    onItemSelected(setState, selectedItem);
                  }
                : null));
  }

  onItemSelected(setState, selectedItem) {
    setState(() {
      if (selectedItem != null) {
        if (_selectedItems.contains(selectedItem)) {
          _selectedItems.remove(selectedItem);
        } else {
          _selectedItems.add(selectedItem);
        }
      }
    });
  }

  Widget getAppBar(setState) {
    if (_selectedItems.length > 0) {
      return SelectItemsBar(
        itemsCount: _selectedItems.length,
        onConfirm: () => {
          widget.onConfirmSelectedItems(_selectedItems),
          Navigator.pop(context)
        },
        onCancel: () => {
          setState(() {
            _selectedItems.forEach((item) {
              item.selectedQuantite = 0.0;
            });
            _selectedItems = new List<Object>();
          })
        },
      );
    } else {
      return SearchBar(
        searchController: searchController,
        mainContext: widget.onConfirmSelectedItems != null ? null : context,
        title: S.current.journaux,
        isFilterOn: isFilterOn,
        onSearchChanged: (String search) => _dataSource.updateSearchTerm(search.trim()),
        onFilterPressed: _pressFilter,
      );
    }
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
            _savedSelectedMarque = _marqueItems.indexOf(_selectedMarque);
            _savedSelectedFamille =
                _familleItems.indexOf(_selectedFamille);
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

  Future scanBarCode() async {
    try {
      var options = ScanOptions(
        strings: {
          "cancel": S.current.annuler,
          "flash_on": S.current.flash_on,
          "flash_off": S.current.flash_off,
        },
      );

      var result = await BarcodeScanner.scan(options: options);
      if (result.rawContent.isNotEmpty) {
        setState(() {
          searchController.text = result.rawContent;
          _dataSource.updateSearchTerm(result.rawContent);
          FocusScope.of(context).requestFocus(null);
        });
      }
    } catch (e) {
      var result = ScanResult(
        type: ResultType.Error,
        format: BarcodeFormat.unknown,
      );

      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          result.rawContent = S.current.msg_cam_permission;
        });
      } else {
        result.rawContent = '${S.current.msg_ereure}: ($e)';
      }
      Helpers.showToast(result.rawContent);
    }
  }

  void _pdaScanner(data) {
    setState(() {
      searchController.text = data;
      _dataSource.updateSearchTerm(data);
      FocusScope.of(context).requestFocus(null);
    });
  }
}
