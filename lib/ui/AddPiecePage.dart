import 'dart:typed_data';
import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:charset_converter/charset_converter.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:floating_action_row/floating_action_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import "package:gestmob/Helpers/string_cap_extension.dart";
import 'package:gestmob/Widgets/CustomWidgets/add_save_bar.dart';
import 'package:gestmob/Widgets/CustomWidgets/list_dropdown.dart';
import 'package:gestmob/Widgets/CustomWidgets/selectable_list_item.dart';
import 'package:gestmob/Widgets/total_devis.dart';
import 'package:gestmob/Widgets/utils.dart' as utils;
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/Article.dart';
import 'package:gestmob/models/DefaultPrinter.dart';
import 'package:gestmob/models/FormatPiece.dart';
import 'package:gestmob/models/Journaux.dart';
import 'package:gestmob/models/MyParams.dart';
import 'package:gestmob/models/Piece.dart';
import 'package:gestmob/models/Profile.dart';
import 'package:gestmob/models/ReglementTresorie.dart';
import 'package:gestmob/models/Tiers.dart';
import 'package:gestmob/models/Transformer.dart';
import 'package:gestmob/models/Tresorie.dart';
import 'package:gestmob/search/sliver_list_data_source.dart';
import 'package:gestmob/ui/ArticlesFragment.dart';
import 'package:gestmob/ui/ClientFourFragment.dart';
import 'package:gestmob/ui/JournalFragment.dart';
import 'package:gestmob/ui/preview_piece.dart';
import 'package:gestmob/ui/printer_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:collection/collection.dart';

class AddPiecePage extends StatefulWidget {
  var arguments;

  AddPiecePage({Key key, @required this.arguments}) : super(key: key);

  @override
  _AddPiecePageState createState() => _AddPiecePageState();
}

class _AddPiecePageState extends State<AddPiecePage>
    with TickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Piece _piece = new Piece.init();

  bool editMode = true;
  bool modification = false;
  bool _islisting = false;
  bool finishedLoading = false;

  String appBarTitle = S.current.devis;

  List<Article> _originalItems = new List<Article>();
  List<Article> _selectedItems = new List<Article>();
  List<Article> _desSelectedItems = new List<Article>();
  Tiers _selectedClient;

  List<int> _tarificationItems = Statics.tarificationItems;
  List<DropdownMenuItem<int>> _tarificationDropdownItems;
  int _selectedTarification;
  bool _validateRaison = false;

  TextEditingController _numeroControl = new TextEditingController();
  TextEditingController _dateControl = new TextEditingController();
  TextEditingController _clientControl = new TextEditingController();
  TextEditingController _verssementControler = new TextEditingController();
  TextEditingController _resteControler = new TextEditingController();
  TextEditingController _remisepieceControler = new TextEditingController();
  TextEditingController _pourcentremiseControler = new TextEditingController();
  String _validateVerssemntError;

  double _restepiece;
  double _verssementpiece;
  double _total_ht;
  double _net_ht;
  double _total_tva;
  double _total_ttc;
  double _timbre;

  double _net_a_payer;
  double _remisepiece;
  double _pourcentremise;

  int _oldMov;

  SliverListDataSource _dataSource;
  QueryCtr _queryCtr;

  BottomBarController bottomBarControler;
  Ticket _ticket;
  MyParams _myParams;
  Profile _profile;

  String _devise;
  bool directionRtl = false;
  DefaultPrinter defaultPrinter = new DefaultPrinter.init();

  String feature1 = 'feature1';
  String feature2 = 'feature2';
  String feature3 = 'feature3';
  String feature4 = 'feature4';
  String feature12 = 'feature12';

  Piece _pieceFrom;
  Piece _pieceTo;
  Transformer _trasformers;

  final _formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      FeatureDiscovery.discoverFeatures(
        context,
        <String>{
          // Feature ids for every feature that you want to showcase in order.
          feature1,
          feature2,
          feature3,
          feature4,
          feature12
        },
      );
    });
    bottomBarControler =
        BottomBarController(vsync: this, dragLength: 450, snap: true);
    _dataSource = SliverListDataSource(
        ItemsListTypes.articlesList, new Map<String, dynamic>());
    _queryCtr = _dataSource.queryCtr;
    futureInitState().then((val) {
      setState(() {
        finishedLoading = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  //**************************************************************************************************************************************
  //*********************************************** init le screen **********************************************************************
  Future<bool> futureInitState() async {
    _profile = await _queryCtr.getProfileById(1);
    _myParams = await _queryCtr.getAllParams();
    _devise = Helpers.getDeviseTranslate(_myParams.devise);

    buildTarification(_myParams.tarification);
    _tarificationDropdownItems =
        utils.buildDropTarificationTier(_tarificationItems);

    if (widget.arguments is Piece &&
        widget.arguments.id != null &&
        widget.arguments.id > -1) {
      // le cas d'une nouvel piece
      editMode = false;
      modification = true;
      await setDataFromItem(widget.arguments);
      if (_piece.etat == 1) {
        _trasformers = await _queryCtr.getTransformer(_piece, "old");
        _pieceTo = await _queryCtr.getPieceById(_trasformers.newPieceId);
      }
      if (_piece.transformer == 1) {
        _trasformers = await _queryCtr.getTransformer(_piece, "new");
        _pieceFrom = await _queryCtr.getPieceById(_trasformers.oldPieceId);
      }
      _selectedTarification = _piece.tarification;
    } else {
      // modification de la piece
      await setDataFromItem(null);
      _selectedTarification = _selectedClient.tarification;
      await getNumPiece(widget.arguments);
      _piece.date = DateTime.now();
      _dateControl.text = Helpers.dateToText(DateTime.now());
      editMode = true;
    }

    return Future<bool>.value(editMode);
  }

  Future<void> setDataFromItem(Piece item) async {
    if (item != null) {
      _piece = item;
      _numeroControl.text = _piece.num_piece;
      DateTime time = _piece.date ?? new DateTime.now();
      _piece.date = time;
      _dateControl.text = Helpers.dateToText(time);
      _selectedClient = await _queryCtr.getTierById(_piece.tier_id);
      _clientControl.text = _selectedClient.raisonSociale;
      _selectedTarification = _selectedClient.tarification;
      _originalItems = await _queryCtr.getJournalPiece(item, local: false);
      _selectedItems = List.from(_originalItems);
      _verssementControler.text = "0.0";
      _resteControler.text = _piece.reste.toStringAsFixed(2);

      _oldMov = _piece.mov;
      _restepiece = _piece.reste;
      _verssementpiece = 0;

      _total_ht = _piece.total_ht;
      _net_ht = _piece.net_ht;
      _total_tva = _piece.total_tva;
      _total_ttc = _piece.total_ttc;
      _timbre = _piece.timbre;
      _net_a_payer = (_piece.net_a_payer < 0)
          ? _piece.net_a_payer * -1
          : _piece.net_a_payer;
      if (_piece.regler < 0) {
        _piece.regler = _piece.regler * -1;
      }
      if (_piece.reste < 0) {
        _piece.reste = _piece.reste * -1;
      }
      _remisepiece = (_piece.remise * _total_ht) / 100;
      _pourcentremise = _piece.remise;

      _remisepieceControler.text = _remisepiece.toStringAsFixed(2);
      _pourcentremiseControler.text = _pourcentremise.toStringAsFixed(2);
    } else {
      _piece.piece = widget.arguments.piece;

      if (_piece.piece == PieceType.devis ||
          _piece.piece == PieceType.retourClient ||
          _piece.piece == PieceType.avoirClient ||
          _piece.piece == PieceType.commandeClient ||
          _piece.piece == PieceType.bonLivraison ||
          _piece.piece == PieceType.factureClient) {
        _selectedClient = await _queryCtr.getTierById(1);
      } else {
        _selectedClient = await _queryCtr.getTierById(2);
      }

      _clientControl.text = _selectedClient.raisonSociale;
      _selectedTarification = _selectedClient.tarification;
      _verssementControler.text = "0.0";
      _resteControler.text = "0.0";
      _remisepieceControler.text = "0.0";
      _pourcentremiseControler.text = "0.0";

      _restepiece = 0.0;
      _verssementpiece = 0.0;
      _total_ht = 0.0;
      _net_ht = 0.0;
      _total_tva = 0.0;
      _total_ttc = 0.0;
      _timbre = 0.0;
      _net_a_payer = 0.0;
      _remisepiece = 0;
      _pourcentremise = 0;
    }
  }

  Future<void> getNumPiece(item) async {
    _piece.piece = item.piece;
    List<FormatPiece> list = await _queryCtr.getFormatPiece(_piece.piece);
    setState(() {
      _numeroControl.text = Helpers.generateNumPiece(list.first);
    });
  }

  void buildTarification(tarification) {
    setState(() {
      switch (tarification) {
        case 1:
          _tarificationItems = Statics.tarificationItems.sublist(0, 1);
          break;
        case 2:
          _tarificationItems = Statics.tarificationItems.sublist(0, 2);
          break;
        case 3:
          _tarificationItems = Statics.tarificationItems;
          break;
        default:
          _tarificationItems = Statics.tarificationItems;
          break;
      }
    });
  }

  //************************************************************************************************************************************
  // ***************************************** partie affichage et build *****************************************************************
  @override
  Widget build(BuildContext context) {
    directionRtl = Helpers.isDirectionRTL(context);
    if (modification) {
      if (editMode) {
        appBarTitle = S.current.modification_titre;
        _islisting = false;
      } else {
        appBarTitle = Helpers.getPieceTitle(_piece.piece);
        _islisting = true;
      }
    } else {
      if (editMode) {
        appBarTitle = Helpers.getPieceTitle(_piece.piece);
        _islisting = false;
      } else {
        appBarTitle = Helpers.getPieceTitle(_piece.piece);
        _islisting = true;
      }
    }

    if (!finishedLoading) {
      return Scaffold(body: Helpers.buildLoading());
    } else {
      return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AddEditBar(
              editMode: editMode,
              modification: modification,
              title: appBarTitle,
              onCancelPressed: _pressCancel,
              onEditPressed: (_piece.etat == 0)
                  ? _pressEdit
                  : () {
                      Helpers.showToast(S.current.msg_no_edit_transformer);
                    },
              onSavePressed: _pressSave,
              onTrensferPressed: (_piece.etat == 0 &&
                      _piece.piece != PieceType.retourClient &&
                      _piece.piece != PieceType.avoirClient &&
                      _piece.piece != PieceType.retourFournisseur &&
                      _piece.piece != PieceType.avoirFournisseur)
                  ? _pressTransfer
                  : null,
            ),
            // extendBody: true,
            bottomNavigationBar: BottomExpandableAppBar(
              appBarHeight: 70,
              expandedHeight:(directionRtl)? 250 : 200,
              controller: bottomBarControler,
              horizontalMargin: 10,
              shape: AutomaticNotchedShape(
                  RoundedRectangleBorder(), StadiumBorder(side: BorderSide())),
              expandedBackColor: Colors.blue,
              expandedBody: TotalDevis(
                total_ht: _total_ht,
                total_tva: _total_tva,
                total_ttc: _total_ttc,
                net_ht: _net_ht,
                net_payer: (_myParams.timbre) ? _total_ttc + _timbre : _total_ttc,
                remise: double.parse(_pourcentremise.toStringAsFixed(2)),
                timbre: _timbre,
                myParams: _myParams,
              ),
              bottomAppBarBody: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: DescribedFeatureOverlay(
                      featureId: feature1,
                      tapTarget: Icon(
                        MdiIcons.sigma,
                        color: Colors.black,
                      ),
                      backgroundColor: Colors.blue,
                      contentLocation: ContentLocation.above,
                      title: Text(
                        '${S.current.ajout_remise}',
                        style: GoogleFonts.lato(fontWeight: FontWeight.bold),
                      ),
                      description: Container(
                        width: 150,
                        child: Text(
                          '${S.current.msg_ajout_remise}',
                          style: GoogleFonts.lato(),
                        ),
                      ),
                      onBackgroundTap: () async {
                        await FeatureDiscovery.completeCurrentStep(context);
                        return true;
                      },
                      child: InkWell(
                        onTap: () async {
                          if (editMode) {
                            if (_selectedItems.isNotEmpty) {
                              AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.INFO,
                                  animType: AnimType.BOTTOMSLIDE,
                                  title: S.current.supp,
                                  body: addRemisedialogue(),
                                  btnCancelText: S.current.annuler,
                                  btnCancelOnPress: () {
                                    setState(() {
                                      _pourcentremiseControler.text =
                                          _pourcentremise.toStringAsFixed(2);
                                      _remisepieceControler.text =
                                          _remisepiece.toStringAsFixed(2);
                                    });
                                  },
                                  btnOkText: S.current.confirme,
                                  btnOkOnPress: () {
                                    if(_pourcentremiseControler.text.trim() == ''){
                                      _pourcentremiseControler.text = '0.0';
                                      _remisepieceControler.text = '0.0';
                                    }else{
                                      if(!_pourcentremiseControler.text.trim().isNumericUsingRegularExpression){
                                        _pourcentremiseControler.text = '0.0';
                                        _remisepieceControler.text = "0.0" ;
                                        Helpers.showToast(S.current.msg_val_valide);
                                      }
                                      if(double.parse(_pourcentremiseControler.text.trim()) < 0){
                                        _pourcentremiseControler.text = '0.0';
                                        _remisepieceControler.text = '0.0' ;
                                        Helpers.showToast(S.current.msg_prix_supp_zero);
                                      }
                                    }
                                    if(_remisepieceControler.text.trim() == ''){
                                      _remisepieceControler.text = '0.0' ;
                                      _pourcentremiseControler.text = '0.0';
                                    }else{
                                      if(!_remisepieceControler.text.trim().isNumericUsingRegularExpression){
                                        _remisepieceControler.text = '0.0';
                                        _pourcentremiseControler.text = '0.0';
                                        Helpers.showToast(S.current.msg_val_valide);
                                      }
                                      if(double.parse(_remisepieceControler.text.trim()) < 0){
                                        _remisepieceControler.text = '0.0';
                                        _pourcentremiseControler.text = '0.0';
                                        Helpers.showToast(S.current.msg_val_valide);
                                      }
                                    }
                                    setState(() {
                                      _pourcentremise = double.parse(
                                          _pourcentremiseControler.text.trim());
                                      _remisepiece = double.parse(
                                          _remisepieceControler.text.trim());
                                    });
                                    calculPiece();
                                  })
                                ..show();
                            } else {
                              Helpers.showToast(S.current.msg_select_art);
                            }
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: (editMode)
                                  ? Border(
                                      bottom: BorderSide(
                                          color: Colors.blue, width: 1))
                                  : null),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(
                                    MdiIcons.sigma,
                                    color: (editMode)
                                        ? Colors.blue
                                        : Theme.of(context).primaryColorDark,
                                    size: 18,
                                  ),
                                  Text(
                                    "$_devise",
                                    style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                Helpers.numberFormat(_net_a_payer).toString(),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Expanded(
                    flex: 4,
                    child: DescribedFeatureOverlay(
                      featureId: feature2,
                      tapTarget: Icon(
                        MdiIcons.cashMultiple,
                        color: Colors.black,
                      ),
                      backgroundColor: Colors.green,
                      contentLocation: ContentLocation.above,
                      title: Text(
                        '${S.current.ajout_verssement}',
                        style: GoogleFonts.lato(fontWeight: FontWeight.bold),
                      ),
                      description: Container(
                        width: 150,
                        child: Text(
                          '${S.current.msg_ajout_verssement}',
                          style: GoogleFonts.lato(),
                        ),
                      ),
                      onBackgroundTap: () async {
                        await FeatureDiscovery.completeCurrentStep(context);
                        return true;
                      },
                      child: InkWell(
                        onTap: () async {
                          if (editMode) {
                            if (_piece.piece != PieceType.devis &&
                                _piece.piece != PieceType.bonCommande) {
                              if (_selectedItems.isNotEmpty) {
                                if (_net_a_payer > _piece.regler) {
                                  setState(() {
                                    double _reste = _net_a_payer -
                                        (_piece.regler + _verssementpiece);
                                    _resteControler.text = _reste.toString();
                                  });
                                  AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.INFO,
                                      animType: AnimType.BOTTOMSLIDE,
                                      title: S.current.supp,
                                      body: addVerssementdialogue(),
                                      btnCancelText: S.current.annuler,
                                      btnCancelOnPress: () {
                                        _verssementControler.text = _verssementpiece.toString();
                                        _resteControler.text = _restepiece.toString();
                                      },
                                      btnOkText: S.current.confirme,
                                      btnOkOnPress: () {
                                        if(_verssementControler.text.trim()  == ''){
                                          _verssementControler.text = "0.0" ;
                                        }else{
                                          if(!_verssementControler.text.trim().isNumericUsingRegularExpression){
                                            _verssementControler.text = "0.0" ;
                                            Helpers.showToast(S.current.msg_val_valide);
                                          }
                                          if(double.parse(_verssementControler.text.trim()) < 0){
                                            _verssementControler.text = "0.0" ;
                                            Helpers.showToast(S.current.msg_prix_supp_zero);
                                          }
                                        }
                                        setState(() {
                                          _restepiece = double.parse(
                                              _resteControler.text.trim());
                                          _verssementpiece = double.parse(
                                              _verssementControler.text.trim());
                                        });
                                      })
                                    ..show();
                                } else {
                                  Helpers.showToast(S.current.msg_versement_err);
                                }
                              } else {
                                Helpers.showToast(S.current.msg_select_art);
                              }
                            } else {
                              Helpers.showToast(S.current.msg_no_dispo);
                            }
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: (editMode &&
                                      _piece.piece != PieceType.devis &&
                                      _piece.piece != PieceType.bonCommande)
                                  ? Border(
                                      bottom: BorderSide(
                                          color: Colors.blue, width: 1))
                                  : null),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(MdiIcons.cashMultiple,
                                      size: 20,
                                      color: (_piece.piece != PieceType.devis &&
                                              _piece.piece !=
                                                  PieceType.bonCommande &&
                                              editMode)
                                          ? Colors.blue
                                          : Theme.of(context).primaryColorDark),
                                  Text(
                                    "${_devise}",
                                    style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                Helpers.numberFormat(
                                        _verssementpiece + _piece.regler)
                                    .toString(),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: _floationButtonWidget(),
            body: Builder(
              builder: (context) => fichetab(),
            )),
      );
    }
  }

  Future<bool> _onWillPop() async {
    Function eqal =  ListEquality().equals;
    if (modification) {
      if (editMode) {
        if(eqal(_originalItems , _selectedItems)){
          Navigator.of(context).pushReplacementNamed(
              RoutesKeys.addPiece,
              arguments: widget.arguments);
          return Future.value(false);
        }else{
          AwesomeDialog(
              context: context,
              title: "",
              desc: "${S.current.msg_retour_no_save} ?",
              dialogType: DialogType.QUESTION,
              animType: AnimType.BOTTOMSLIDE,
              btnCancelText: S.current.non,
              btnCancelOnPress: () {},
              btnOkText: S.current.oui,
              btnOkOnPress: () async {
                Navigator.of(context).pushReplacementNamed(
                    RoutesKeys.addPiece,
                    arguments: widget.arguments);
              })
            ..show();
          return Future.value(true);
        }

      } else {
        Navigator.pop(context , widget.arguments);
        return Future.value(false);
      }

    } else {
      if (_selectedItems.isNotEmpty) {
        AwesomeDialog(
            context: context,
            title: "",
            desc: "${S.current.msg_retour_no_save} ?",
            dialogType: DialogType.QUESTION,
            animType: AnimType.BOTTOMSLIDE,
            btnCancelText: S.current.non,
            btnCancelOnPress: () {},
            btnOkText: S.current.oui,
            btnOkOnPress: () async {
              Navigator.pop(context);
            })
          ..show();
        return Future.value(true);
      } else {
        Navigator.pop(context);
        return Future.value(false);
      }
    }

  }

  _pressCancel(){
    Function eqal =  ListEquality().equals;
    if (modification) {
      if (editMode) {
        if(eqal(_originalItems , _selectedItems)){
          Navigator.of(context).pushReplacementNamed(
              RoutesKeys.addPiece,
              arguments: widget.arguments);

        }else{
          AwesomeDialog(
              context: context,
              title: "",
              desc: "${S.current.msg_retour_no_save} ?",
              dialogType: DialogType.QUESTION,
              animType: AnimType.BOTTOMSLIDE,
              btnCancelText: S.current.non,
              btnCancelOnPress: () {},
              btnOkText: S.current.oui,
              btnOkOnPress: () async {
                Navigator.of(context).pushReplacementNamed(
                    RoutesKeys.addPiece,
                    arguments: widget.arguments);

              })
            ..show();
        }

      } else {
        Navigator.pop(context , widget.arguments);
      }

    } else {
      if (_selectedItems.isNotEmpty)
      {
        AwesomeDialog(
            context: context,
            title: "",
            desc: "${S.current.msg_retour_no_save} ?",
            dialogType: DialogType.QUESTION,
            animType: AnimType.BOTTOMSLIDE,
            btnCancelText: S.current.non,
            btnCancelOnPress: () {},
            btnOkText: S.current.oui,
            btnOkOnPress: () async {
              Navigator.pop(context);
            })
          ..show();
      }
      else
      {
        Navigator.pop(context);
      }
    }
  }

  _pressSave(){
    if (_formKey.currentState.validate()) {
      if (_selectedItems.length > 0) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.SUCCES,
          animType: AnimType.BOTTOMSLIDE,
          title: S.current.supp,
          body: addChoicesDialog(),
          closeIcon: Icon(
            Icons.cancel_sharp,
            color: Colors.red,
            size: 26,
          ),
          showCloseIcon: true,
        )..show();
      } else {
        Helpers.showToast(S.current.msg_select_art);
      }
    } else {
      Helpers.showToast("${S.current.msg_champs_obg}");
    }
  }

  _pressEdit(){
    if (_myParams.versionType == "demo") {
      setState(() {
        editMode = true;
      });
    } else {
      if (DateTime.now()
          .isBefore(Helpers.getDateExpiration(_myParams))) {
        setState(() {
          editMode = true;
        });
      } else {
        Navigator.pushNamed(context, RoutesKeys.appPurchase);
        var message = S.current.msg_premium_exp;
        Helpers.showToast(message);
      }
    }
  }

  _pressTransfer(){
    if (_piece.mov == 2) {
      var message = S.current.msg_err_transfer;
      Helpers.showToast(message);
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.QUESTION,
        animType: AnimType.BOTTOMSLIDE,
        title: S.current.supp,
        body: transferPieceDialog(),
        closeIcon: Icon(
          Icons.cancel_sharp,
          color: Colors.red,
          size: 26,
        ),
        showCloseIcon: true,
      )..show();
    }
  }

  Widget _floationButtonWidget(){
    return GestureDetector(
      // Set onVerticalDrag event to drag handlers of controller for swipe effect
      onVerticalDragUpdate: bottomBarControler.onDrag,
      onVerticalDragEnd: bottomBarControler.onDragEnd,
      child: DescribedFeatureOverlay(
        featureId: feature3,
        tapTarget: Icon(
          MdiIcons.arrowExpandUp,
          color: Colors.black,
        ),
        backgroundColor: Colors.blue,
        contentLocation: ContentLocation.above,
        title: Text('${S.current.swipe_top}',
            style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
        description: Container(
          width: 150,
          child: Text(
            '${S.current.msg_swipe_top}',
            style: GoogleFonts.lato(),
          ),
        ),
        onBackgroundTap: () async {
          await FeatureDiscovery.completeCurrentStep(context);
          return true;
        },
        child: FloatingActionRow(
          children: [
            FloatingActionRowButton(
                icon: (editMode)
                    ? Icon(
                  Icons.add,
                  color: Colors.white,
                )
                    : Icon(
                  Icons.print,
                  color: Colors.white,
                ),
                color: editMode ? Colors.blue : Colors.redAccent,
                foregroundColor: Colors.white,
                //Set onPressed event to swap state of bottom bar
                onTap: editMode
                    ? () async {
                  await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return addArticleDialog();
                      }).then((val) {
                    if (_piece.piece == PieceType.avoirClient ||
                        _piece.piece == PieceType.retourClient ||
                        _piece.piece ==
                            PieceType.retourFournisseur ||
                        _piece.piece ==
                            PieceType.avoirFournisseur) {
                      var message = S.current.msg_info_article;
                      Helpers.showToast(message);
                    }
                    calculPiece();
                  });
                }
                    : () async {
                  if (_myParams.versionType == "demo") {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.QUESTION,
                      animType: AnimType.BOTTOMSLIDE,
                      body: printChoicesDialog(),
                      closeIcon: Icon(
                        Icons.cancel_sharp,
                        color: Colors.red,
                        size: 26,
                      ),
                      showCloseIcon: true,
                    )..show();
                  } else {
                    if (DateTime.now().isBefore(
                        Helpers.getDateExpiration(_myParams))) {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.QUESTION,
                        animType: AnimType.BOTTOMSLIDE,
                        body: printChoicesDialog(),
                        closeIcon: Icon(
                          Icons.cancel_sharp,
                          color: Colors.red,
                          size: 26,
                        ),
                        showCloseIcon: true,
                      )..show();
                    } else {
                      Navigator.pushNamed(
                          context, RoutesKeys.appPurchase);
                      var message = S.current.msg_premium_exp;
                      Helpers.showToast(message);
                    }
                  }
                }),
            (editMode &&
                (_piece.piece == PieceType.avoirClient ||
                    _piece.piece == PieceType.retourClient ||
                    _piece.piece == PieceType.retourFournisseur ||
                    _piece.piece == PieceType.avoirFournisseur))
                ? FloatingActionRowButton(
                icon: Icon(
                  Icons.insert_drive_file_outlined,
                  color: Colors.white,
                ),
                color: Colors.redAccent,
                onTap: () async {
                  await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return addJournauxDialog();
                      }).then((val) {
                    calculPiece();
                  });
                })
                : SizedBox(
              height: 0,
            ),
          ],
        ),
      ),
    );
  }

  Widget fichetab() {
    return SingleChildScrollView(
        physics: ScrollPhysics(),
        padding: const EdgeInsets.all(10),
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          Card(
            elevation: 1,
            child: Container(
              padding: EdgeInsets.all(15),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  (_piece.etat == 1 && _pieceTo != null)
                      ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 12,
                                color: Colors.green,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                  "${S.current.msg_piece_transformer_to} ${getPiecetype(_pieceTo)} ${_pieceTo.num_piece}",
                                  style: GoogleFonts.lato(
                                      textStyle: TextStyle(fontSize: 13)))
                            ],
                          ),
                        )
                      : SizedBox(
                          height: 0,
                        ),
                  (_piece.transformer == 1 && _pieceFrom != null)
                      ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 12,
                                color: Colors.green,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                  "${S.current.msg_piece_transformer_from} ${getPiecetype(_pieceFrom)} ${_pieceFrom.num_piece}",
                                  style: GoogleFonts.lato(
                                      textStyle: TextStyle(fontSize: 13)))
                            ],
                          ),
                        )
                      : SizedBox(
                          height: 0,
                        ),
                  Form(
                    key: _formKey,
                    child: Row(
                      children: [
                        Flexible(
                          flex: 4,
                          child: TextFormField(
                            enabled: editMode,
                            controller: _numeroControl,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value.isEmpty) {
                                return S.current.msg_champ_oblg;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "#/YYYY",
                              prefixIcon: Icon(
                                MdiIcons.idCard,
                                color: Colors.orange[900],
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.orange[900]),
                                  borderRadius: BorderRadius.circular(20)),
                              labelText: "${S.current.n}",
                              labelStyle: GoogleFonts.lato(
                                  textStyle:
                                      TextStyle(color: Colors.orange[900])),
                              enabledBorder: OutlineInputBorder(
                                gapPadding: 3.3,
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    BorderSide(color: Colors.orange[900]),
                              ),
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.fromLTRB(5, 5, 5, 5)),
                        Flexible(
                          flex: 6,
                          child: GestureDetector(
                            onTap: editMode
                                ? () {
                                    callDatePicker();
                                  }
                                : null,
                            child: TextField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.date_range,
                                  color: Colors.blue,
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(20)),
                                labelText: S.current.date,
                                labelStyle: GoogleFonts.lato(
                                    textStyle: TextStyle(color: Colors.blue)),
                                enabledBorder: OutlineInputBorder(
                                  gapPadding: 3.3,
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                              ),
                              enabled: false,
                              controller: _dateControl,
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Visibility(
                        visible: (_piece.piece == PieceType.devis ||
                            _piece.piece == PieceType.retourClient ||
                            _piece.piece == PieceType.avoirClient ||
                            _piece.piece == PieceType.commandeClient ||
                            _piece.piece == PieceType.bonLivraison ||
                            _piece.piece == PieceType.factureClient),
                        child: Flexible(
                          flex: 4,
                          child: ListDropDown(
                            editMode: editMode,
                            value: _selectedTarification,
                            items: _tarificationDropdownItems,
                            libelle: "${S.current.tarif}",
                            onChanged: (value) {
                              setState(() {
                                _selectedTarification = value;
                              });
                              if (_selectedItems.isNotEmpty)
                                dialogChangeTarif(fromClientDialog: false);
                            },
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 6,
                        child: GestureDetector(
                          onTap: editMode
                              ? () {
                                  chooseClientDialog();
                                }
                              : null,
                          child: TextField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.people,
                                color: Colors.blue,
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(20)),
                              labelText: (_piece.piece == PieceType.devis ||
                                      _piece.piece == PieceType.retourClient ||
                                      _piece.piece == PieceType.avoirClient ||
                                      _piece.piece ==
                                          PieceType.commandeClient ||
                                      _piece.piece == PieceType.bonLivraison ||
                                      _piece.piece == PieceType.factureClient)
                                  ? S.current.client_titre
                                  : S.current.fournisseur_titre,
                              labelStyle: GoogleFonts.lato(
                                  textStyle: TextStyle(color: Colors.blue)),
                              enabledBorder: OutlineInputBorder(
                                gapPadding: 3.3,
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ),
                            enabled: false,
                            controller: _clientControl,
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 5),
          Center(
              child: _selectedItems.length > 0
                  ? Container(
                      child: Column(
                      children: [
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _selectedItems.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              if (editMode) {
                                return DescribedFeatureOverlay(
                                  featureId: feature12,
                                  tapTarget: Icon(
                                    MdiIcons.arrowExpandRight,
                                    color: Colors.black,
                                  ),
                                  backgroundColor: Colors.blue,
                                  contentLocation: ContentLocation.above,
                                  title: Text('${S.current.swipe}',
                                      style: GoogleFonts.lato(
                                          fontWeight: FontWeight.bold)),
                                  description: Container(
                                    width: 100,
                                    child: Text(
                                      '${S.current.msg_swipe_start}',
                                      style: GoogleFonts.lato(),
                                    ),
                                  ),
                                  onBackgroundTap: () async {
                                    await FeatureDiscovery.completeCurrentStep(
                                        context);
                                    return true;
                                  },
                                  child: ArticleListItemSelected(
                                    article: _selectedItems[index],
                                    pieceOrigin: _piece.piece,
                                    onItemSelected: (selectedItem) => ({
                                      removeItemfromPiece(selectedItem),
                                      calculPiece(),
                                      setState(() {
                                        if (_pourcentremise > 0) {
                                          _remisepiece =
                                              (_total_ht * _pourcentremise) /
                                                  100;
                                          _remisepieceControler.text =
                                              _remisepiece.toStringAsFixed(2);
                                        }
                                      })
                                    }),
                                  ),
                                );
                              } else {
                                return ArticleListItemSelected(
                                  article: _selectedItems[index],
                                  pieceOrigin: _piece.piece,
                                  fromListing: _islisting,
                                );
                              }
                            })
                      ],
                    ))
                  : SizedBox(
                      height: 5,
                    ))
        ]));
  }

  //afficher le fragment des artciles
  Widget addArticleDialog() {
    return new ArticlesFragment(
      tarification: _selectedTarification,
      pieceOrigin: _piece.piece,
      articleSelected: _selectedItems,
      onConfirmSelectedItems: (selectedItem) {
        selectedItem.forEach((item) {
          if (_selectedItems.contains(item)) {
            _selectedItems
                .elementAt(_selectedItems.indexOf(item))
                .selectedQuantite += item.selectedQuantite;
          } else {
            _selectedItems.add(item);
            if (_desSelectedItems.contains(item)) {
              _desSelectedItems.remove(item);
            }
          }
        });
      },
    );
  }

  Widget addJournauxDialog() {
    return JournalFragment(
      tier: _selectedClient,
      pieceType: _piece.piece,
      onConfirmSelectedItems: (selectedItem) {
        selectedItem.forEach((item) {
          if (_selectedItems.contains(item)) {
            _selectedItems
                .elementAt(_selectedItems.indexOf(item))
                .selectedQuantite += item.selectedQuantite;
          } else {
            _selectedItems.add(item);
            if (_desSelectedItems.contains(item)) {
              _desSelectedItems.remove(item);
            }
          }
        });
      },
    );
  }

  //afficher le fragement des clients
  Widget chooseClientDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new ClientFourFragment(
          clientFourn: (_piece.piece == PieceType.devis ||
                  _piece.piece == PieceType.retourClient ||
                  _piece.piece == PieceType.avoirClient ||
                  _piece.piece == PieceType.commandeClient ||
                  _piece.piece == PieceType.bonLivraison ||
                  _piece.piece == PieceType.factureClient)
              ? 0
              : 2,
          onConfirmSelectedItem: (selectedItem) {
            setState(() {
              _selectedClient = selectedItem;
              _clientControl.text = _selectedClient.raisonSociale;

              if (selectedItem.tarification > _myParams.tarification) {
                buildTarification(selectedItem.tarification);
                _tarificationDropdownItems =
                    utils.buildDropTarificationTier(_tarificationItems);
              } else {
                buildTarification(_myParams.tarification);
                _tarificationDropdownItems =
                    utils.buildDropTarificationTier(_tarificationItems);
              }
            });
          },
        );
      },
    ).then((value) {
      if (_piece.piece == PieceType.devis ||
          _piece.piece == PieceType.retourClient ||
          _piece.piece == PieceType.avoirClient ||
          _piece.piece == PieceType.commandeClient ||
          _piece.piece == PieceType.bonLivraison ||
          _piece.piece == PieceType.factureClient) {

        if(_selectedItems.isNotEmpty)
          dialogChangeTarif(fromClientDialog: true);
      }
    });
  }

  Widget dialogChangeTarif({bool fromClientDialog}) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      animType: AnimType.BOTTOMSLIDE,
      title: '',
      desc: S.current.msg_change_tarif,
      btnCancelText: S.current.non,
      btnCancelOnPress: () {},
      btnOkText: S.current.oui,
      btnOkOnPress: () {
        setState(() {
          if (fromClientDialog) {
            _selectedTarification = _selectedClient.tarification;
          }
          _selectedItems.forEach((element) {
            switch (_selectedTarification) {
              case 1:
                element.selectedPrice = element.prixVente1;
                element.selectedPriceTTC = element.prixVente1TTC;
                break;
              case 2:
                element.selectedPrice = element.prixVente2;
                element.selectedPriceTTC = element.prixVente2TTC;
                break;
              case 3:
                element.selectedPrice = element.prixVente3;
                element.selectedPriceTTC = element.prixVente3TTC;
                break;
            }
          });
        });
        calculPiece();
      },
    )..show();
  }

  //afficher un dialog pour versseemnt
  Widget addVerssementdialogue() {
    return Wrap(children: [
      Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                (_piece.piece == 'RC' || _piece.piece == 'AC')
                    ? "${S.current.rembourcement_client}"
                    : (_piece.piece == 'RF' || _piece.piece == 'AF')
                        ? "${S.current.rembourcement_four}"
                        : "${S.current.modification_titre} ${S.current.verssement}",
                style: GoogleFonts.lato(
                    textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
              ),
            )),
            Padding(
              padding: EdgeInsetsDirectional.only(start: 5, end: 5, bottom: 20),
              child: TextField(
                controller: _verssementControler,
                keyboardType: TextInputType.number,
                onTap: () => {
                  _verssementControler.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: _verssementControler.value.text.length),
                },
                onChanged: (value) {
                  if(value.trim() == ''){
                    _resteControler.text = (_net_a_payer - _piece.regler).toString();
                  }else{

                      if (_piece.id != null) {
                        if (_verssementpiece == 0) {
                          double _reste = _net_a_payer -
                              (_piece.regler + double.parse(value.trim()));
                          _resteControler.text = _reste.toStringAsFixed(2);
                        } else {
                          double _reste = _net_a_payer -
                              (_piece.regler + double.parse(value.trim()));
                          _resteControler.text = _reste.toStringAsFixed(2);
                        }
                      } else {
                        double _reste = _net_a_payer - double.parse(value.trim());
                        _resteControler.text = _reste.toStringAsFixed(2);
                      }
                  }


                },
                decoration: InputDecoration(
                  errorText: _validateVerssemntError ?? null,
                  prefixIcon: Icon(
                    Icons.monetization_on,
                    color: Colors.green,
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.greenAccent),
                      borderRadius: BorderRadius.circular(20)),
                  contentPadding: EdgeInsets.only(left: 10),
                  labelText: (_piece.piece == PieceType.retourClient ||
                          _piece.piece == PieceType.avoirClient ||
                          _piece.piece == PieceType.retourFournisseur ||
                          _piece.piece == PieceType.avoirFournisseur)
                      ? S.current.rembourcement
                      : "${S.current.verssement}",
                  labelStyle: GoogleFonts.lato(
                      textStyle: TextStyle(color: Colors.green)),
                  enabledBorder: OutlineInputBorder(
                    gapPadding: 3.3,
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 320.0,
              child: Padding(
                padding: EdgeInsetsDirectional.only(end: 0, start: 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                          start: 5, end: 5, bottom: 5),
                      child: TextField(
                        controller: _resteControler,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.money,
                            color: Colors.orange[900],
                          ),
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange[900]),
                              borderRadius: BorderRadius.circular(20)),
                          contentPadding: EdgeInsetsDirectional.only(start: 10),
                          labelText: S.current.reste,
                          labelStyle: GoogleFonts.lato(
                              textStyle: TextStyle(color: Colors.orange[900])),
                          enabled: false,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ]);
  }

  //afficher un dialog pour la remise
  Widget addRemisedialogue() {
    return Wrap(children: [
      Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                "${S.current.modification_titre} ${S.current.remise}",
                style: GoogleFonts.lato(
                    textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
              ),
            )),
            Padding(
              padding: EdgeInsetsDirectional.only(start: 5, end: 5, bottom: 20),
              child: TextField(
                controller: _remisepieceControler,
                keyboardType: TextInputType.number,
                onTap: () => {
                  _remisepieceControler.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: _remisepieceControler.value.text.length),
                },
                onChanged: (value) {
                  if (value.trim() != '') {
                    double res = (double.parse(value.trim()) * 100) / _total_ht;
                    _pourcentremiseControler.text = res.toString();
                  } else {
                    _pourcentremiseControler.text = '0.0';
                  }
                },
                decoration: InputDecoration(
                  errorText: _validateVerssemntError ?? null,
                  prefixIcon: Icon(
                    Icons.monetization_on,
                    color: Colors.green,
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green[600]),
                      borderRadius: BorderRadius.circular(20)),
                  contentPadding: EdgeInsets.only(left: 10),
                  labelText: "${S.current.montant}",
                  labelStyle: GoogleFonts.lato(
                      textStyle: TextStyle(color: Colors.green[400])),
                  enabledBorder: OutlineInputBorder(
                    gapPadding: 3.3,
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 320.0,
              child: Padding(
                padding: EdgeInsetsDirectional.only(end: 0, start: 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                          start: 5, end: 5, bottom: 5),
                      child: TextField(
                        controller: _pourcentremiseControler,
                        keyboardType: TextInputType.number,
                        onTap: () => {
                          _pourcentremiseControler.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset:
                                  _pourcentremiseControler.value.text.length),
                        },
                        onChanged: (value) {
                          if (value.trim() != '') {
                            double res =
                                (_total_ht * double.parse(value.trim())) / 100;
                            _remisepieceControler.text = res.toStringAsFixed(2);
                          } else {
                            _remisepieceControler.text = '0.0';
                          }
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            MdiIcons.percent,
                            color: Colors.orange[900],
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange[900]),
                              borderRadius: BorderRadius.circular(20)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange[600]),
                              borderRadius: BorderRadius.circular(20)),
                          contentPadding: EdgeInsetsDirectional.only(start: 10),
                          labelText: S.current.pourcentage,
                          labelStyle: GoogleFonts.lato(
                              textStyle: TextStyle(color: Colors.orange[900])),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ]);
  }

  //dialog dimpression
  Widget printChoicesDialog() {
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Builder(
          builder: (context) => SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Wrap(spacing: 13, runSpacing: 13, children: [
                    Center(
                        child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        "${S.current.choisir_action}: ",
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        )),
                      ),
                    )),
                    SizedBox(
                      width: 320.0,
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(end: 0, start: 0),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          onPressed: () async {
                            Navigator.pop(context);
                            await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return previewItem(_piece, 80, null);
                                });
                            if (_ticket != null) {
                              await printItem(_ticket);
                            }
                          },
                          child: Text(
                            S.current.format_80,
                            style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500)),
                          ),
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 320.0,
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(end: 0, start: 0),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          onPressed: () async {
                            Navigator.pop(context);
                            await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return previewItem(_piece, 58, null);
                                });
                            if (_ticket != null) {
                              await printItem(_ticket);
                              setState(() {
                                _ticket = null;
                              });
                            }
                          },
                          child: Text(
                            S.current.format_58,
                            style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500)),
                          ),
                          color: Colors.green,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 320.0,
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(end: 0, start: 0),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          onPressed: () async {
                            Navigator.pop(context);
                            if (_myParams.versionType != "demo") {
                              await _saveLanPrinter();
                              final doc = await _makePdfDocument();
                              await Printing.layoutPdf(
                                  onLayout: (PdfPageFormat format) async =>
                                      doc.save());
                            } else {
                              final doc = await _makePdfDocument();
                              await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return previewItem(_piece, 0, doc);
                                  });
                            }
                          },
                          child: Text(
                            S.current.lan_print,
                            style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500)),
                          ),
                          color: Colors.deepOrange,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 320.0,
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(end: 0, start: 0),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          onPressed: () async {
                            Navigator.pop(context);
                            final doc = await _makePdfDocument();
                            await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return previewItem(_piece, 45, doc);
                                });
                          },
                          child: Text(
                            S.current.export_pdf,
                            style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500)),
                          ),
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ]),
                ),
              ));
    });
  }

  //remove item from piece in update mode
  void removeItemfromPiece(selectedItem) {
    if (selectedItem != null) {
      if (_selectedItems.contains(selectedItem)) {
        _selectedItems.remove(selectedItem);
        _desSelectedItems.add(selectedItem);
      }
    }
  }

  //calcule le montant total
  void calculPiece() {
    double sum = 0;
    double totalTva = 0;
    setState(() {
      _selectedItems.forEach((item) {
        sum += (item.selectedQuantite * item.selectedPrice);
        totalTva += item.selectedQuantite *
            ((item.tva *
                    (item.selectedPrice -
                        ((item.selectedPrice * _pourcentremise) / 100))) /
                100);
      });
      _total_ht = sum;
      _total_tva = (_myParams.tva) ? totalTva : 0.0;
      _net_ht = _total_ht - ((_total_ht * _pourcentremise) / 100);
      _total_ttc = _net_ht + _total_tva;
      _timbre = Helpers.calcTimber(_total_ttc, _myParams);
      _net_a_payer = _total_ttc + _timbre;

      if (_piece.id != null) {
        if (_net_a_payer <= _piece.net_a_payer) {
          _verssementpiece = 0.0;
          _verssementControler.text = _verssementpiece.toStringAsFixed(2);
          _restepiece = _net_a_payer - (_piece.regler + _verssementpiece);
          _resteControler.text = _restepiece.toStringAsFixed(2);
        } else {
          // le verssement est 0 tjr tq l'utilisateur ne le modifie pas
          // _verssementpiece = _net_a_payer - _piece.regler;
          // if(_piece.piece == PieceType.commandeClient){
          //   _verssementpiece = 0.0 ;
          // }
          _verssementpiece = 0.0;
          _verssementControler.text = _verssementpiece.toStringAsFixed(2);
          _restepiece = _net_a_payer - (_piece.regler + _verssementpiece);
          _resteControler.text = "0.0";
        }
      } else {
        // cet else est pour le cas de creation modification = false
        // le verssement est 0 tjr tq l'utilisateur ne le modifie pas
        _verssementpiece = 0.0;
        if((_myParams.autoverssement) &&
            (_piece.piece == PieceType.bonLivraison ||
            _piece.piece == PieceType.factureClient ||
            _piece.piece == PieceType.bonReception ||
            _piece.piece == PieceType.factureFournisseur)){
          _verssementpiece = _net_a_payer;
        }
        _verssementControler.text = _verssementpiece.toStringAsFixed(2);
        _restepiece = _net_a_payer - _verssementpiece;
      }
    });
  }

  //*********************************************************************************************************************************************************************************
  //********************************************************************** partie de la date ****************************************************************************************
  void callDatePicker() async {
    DateTime now = new DateTime.now();

    DateTime order = await getDate(_piece.date ?? now);
    if (order != null) {
      DateTime time = new DateTime(
          order.year, order.month, order.day, now.hour, now.minute);
      setState(() {
        _piece.date = time;
        _dateControl.text = Helpers.dateToText(time);
      });
    }
  }

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

  //********************************************************************************************************************************************************************************
  //*************************************************************************** partie de save dialog et options ***********************************************************************************

  //dialog de save
  Widget addChoicesDialog() {
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Builder(
          builder: (context) => SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Wrap(spacing: 13, runSpacing: 13, children: [
                    Center(
                        child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        "${S.current.choisir_action}: ",
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        )),
                      ),
                    )),
                    SizedBox(
                      width: 320.0,
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(end: 0, start: 0),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          onPressed: () async {
                            int mov = getMovForPiece();
                            await saveItem(mov, isFromTransfer: false);
                            await quikPrintTicket();
                          },
                          child: Text(
                            S.current.imp_rapide_btn,
                            style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500)),
                          ),
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 320.0,
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(end: 0, start: 0),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          onPressed: () async {
                            int mov = getMovForPiece();
                            await saveItem(mov, isFromTransfer: false);
                            Navigator.pop(context);
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.QUESTION,
                              animType: AnimType.BOTTOMSLIDE,
                              body: printChoicesDialog(),
                              closeIcon: Icon(
                                Icons.cancel_sharp,
                                color: Colors.red,
                                size: 26,
                              ),
                              showCloseIcon: true,
                            )..show();
                          },
                          child: Text(
                            S.current.save_imp_btn,
                            style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500)),
                          ),
                          color: Colors.green,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 320.0,
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(end: 0, start: 0),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          onPressed: () async {
                            int mov = getMovForPiece();
                            await saveItem(mov, isFromTransfer: false);
                          },
                          child: Text(
                            S.current.save_btn,
                            style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500)),
                          ),
                          color: Colors.deepOrange,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: (_piece.mov != 1 && _piece.mov != 0),
                      child: SizedBox(
                        width: 320.0,
                        child: Padding(
                          padding: EdgeInsetsDirectional.only(end: 0, start: 0),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            onPressed: () async {
                              await saveItemAsDraft();
                            },
                            child: Text(
                              S.current.broullion_btn,
                              style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                            ),
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ));
    });
  }

  int getMovForPiece() {
    switch (_piece.piece) {
      case (PieceType.devis):
        return 0;
        break;

      case (PieceType.bonCommande):
        return 0;
        break;

      default:
        return 1;
        break;
    }
  }

  saveItem(int move, {@required bool isFromTransfer}) async {
    _piece.mov = move;
    int id = await addItemToDb(isFromTransfer: isFromTransfer);
    if (id > -1) {
      _selectedClient = await _queryCtr.getTierById(_selectedClient.id);
      setState(() {
        _originalItems = List.from(_selectedItems);
        modification = true;
        editMode = false;
        _verssementpiece = 0.0;
      });
    }
  }

  saveItemAsDraft() async {
    saveItem(2, isFromTransfer: false);
  }

  previewItem(item, int format, doc) {
    return PreviewPiece(
        piece: item,
        articles: _selectedItems,
        tier: _selectedClient,
        ticket: (ticket) {
          setState(() {
            _ticket = ticket;
          });
        },
        format: format,
        pdfDoc: doc);
  }

  printItem(ticket) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Print(ticket);
      },
    ).then((value) {
      setState(() {
        _ticket = null;
      });
    });
  }

  //**********************************************************************************************************************************************
  //************************************************add or update item *************************************************************************
  Future<int> addItemToDb({@required bool isFromTransfer}) async {
    int id = -1;
    String message;
    try {
      if (widget.arguments.id != null) {
        //edit piece
        var item = await makePiece(isFromTransfer: isFromTransfer);
        if (item != null) {
          id = await _queryCtr.updateItemInDb(DbTablesNames.pieces, item);
          _selectedItems.forEach((article) async {
            Journaux journaux = Journaux.fromPiece(item, article);
            if (_originalItems.contains(article)) {
              await _queryCtr.updateJournaux(DbTablesNames.journaux, journaux);
            } else {
              await _queryCtr.addItemToTable(DbTablesNames.journaux, journaux);
            }
          });
          _desSelectedItems.forEach((article) async {
            Journaux journaux = Journaux.fromPiece(item, article);
            journaux.mov = -2;
            await _queryCtr.updateJournaux(DbTablesNames.journaux, journaux);
          });

          if (_oldMov != null && _piece.mov != _oldMov) {
            //ds le cas de modification de mov de piece
            // update tresorie mov
            await _queryCtr.updateItemByForeignKey(DbTablesNames.tresorie,
                "Mov", _piece.mov, "Piece_id", _piece.id);
          }

          if (_piece.piece != PieceType.devis &&
              _piece.piece != PieceType.bonCommande &&
          _verssementpiece != 0) {
            await addTresorie(_piece, transferer: false);
          }

          if (id > -1) {
            widget.arguments = item;
            widget.arguments.id = _piece.id;
            message = S.current.msg_update_item;
          } else {
            message = S.current.msg_update_err;
          }
        } else {
          Navigator.pop(context);
          var message = S.current.msg_num_existe;
          Helpers.showToast(message);
          return Future.value(id);
        }
      } else {
        //add new piece
        Piece piece = await makePiece(isFromTransfer: isFromTransfer);
        if (piece != null) {
          piece.etat = 0;
          id = await _queryCtr.addItemToTable(DbTablesNames.pieces, piece);
          if (id > -1) {
            piece.id = id;
          }
          _selectedItems.forEach((article) async {
            Journaux journaux = Journaux.fromPiece(piece, article);
            await _queryCtr.addItemToTable(DbTablesNames.journaux, journaux);
          });

          if (_piece.piece != PieceType.devis &&
              _piece.piece != PieceType.bonCommande &&
          _verssementpiece != 0) {
            await addTresorie(_piece, transferer: false);
          }

          if (id > -1) {
            widget.arguments = piece;
            widget.arguments.id = id;
            message = S.current.msg_ajout_item;
          } else {
            message = S.current.msg_ajout_err;
          }
        } else {
          Navigator.pop(context);
          var message = S.current.msg_num_existe;
          Helpers.showToast(message);
          return Future.value(id);
        }
      }

      Navigator.pop(context);
      if(!modification && editMode){
        Navigator.pop(context);
      }
      Helpers.showToast(message);
      return Future.value(id);
    } catch (error) {
      Helpers.showToast(S.current.msg_ereure);
      return Future.value(-1);
    }
  }

  Future<Object> makePiece({@required bool isFromTransfer}) async {
    var tiers = _selectedClient;
    var _old_num_piece = _piece.num_piece;

    _piece.num_piece = _numeroControl.text.trim();
    _piece.tier_id = tiers.id;
    _piece.raisonSociale = tiers.raisonSociale;
    _piece.tarification = _selectedTarification;

    _piece.total_ht = double.parse((_total_ht).toStringAsFixed(2));
    _piece.remise = _pourcentremise;
    _piece.net_ht = double.parse((_net_ht).toStringAsFixed(2));
    _piece.total_tva = double.parse((_total_tva).toStringAsFixed(2));
    _piece.total_ttc = double.parse((_total_ttc).toStringAsFixed(2));
    _piece.timbre =
        (_timbre != null) ? double.parse((_timbre).toStringAsFixed(2)) : 0.0;
    _piece.net_a_payer = double.parse((_net_a_payer).toStringAsFixed(2));

    if (_piece.transformer == null) {
      _piece.transformer = 0;
    }

    if (_piece.id == null) {
      _piece.regler = double.parse((_verssementpiece).toStringAsFixed(2));
    } else {
      _piece.regler =
          double.parse((_piece.regler + _verssementpiece).toStringAsFixed(2));
    }
    _piece.reste =
        double.parse((_piece.net_a_payer - _piece.regler).toStringAsFixed(2));

    if (_piece.piece == PieceType.retourClient ||
        _piece.piece == PieceType.avoirClient ||
        _piece.piece == PieceType.retourFournisseur ||
        _piece.piece == PieceType.avoirFournisseur) {
      _piece.net_a_payer = _piece.net_a_payer * -1;
      _piece.regler = _piece.regler * -1;
      _piece.reste = _piece.reste * -1;
    }

    if (!modification) {
      var res = await _queryCtr.getPieceByNum(_piece.num_piece, _piece.piece);
      if (res.length >= 1 && !isFromTransfer) {
        await getNumPiece(_piece);
        return null;
      }
    } else {
      if (_piece.num_piece != _old_num_piece) {
        var res = await _queryCtr.getPieceByNum(_piece.num_piece, _piece.piece);
        if (res.length >= 1 && !isFromTransfer) {
          _piece.num_piece = _old_num_piece;
          await getNumPiece(_piece);
          return null;
        }
      }
    }

    return _piece;
  }

  Future<void> addTresorie(item, {transferer}) async {
    Tresorie tresorie = new Tresorie.init();
    tresorie.montant = double.parse((_verssementpiece).toStringAsFixed(2));
    tresorie.compte = 1;
    tresorie.charge = null;
    if (transferer) {
      tresorie.montant = 0;
    }

    //special pour l'etat de la tresorie
    tresorie.mov = item.mov;
    tresorie.modalite = 0;
    tresorie.numCheque = '';
    tresorie.tierId = item.tier_id;
    tresorie.tierRS = item.raisonSociale;
    tresorie.pieceId = item.id;
    tresorie.date = new DateTime.now();
    if (item.piece == PieceType.bonLivraison ||
        item.piece == PieceType.factureClient ||
        item.piece == PieceType.commandeClient) {
      tresorie.categorie = 2;
      tresorie.objet = "${S.current.reglemnt_client} ${getPiecetype(_piece)} ${_piece.num_piece}";
    } else {
      if (item.piece == PieceType.bonReception ||
          item.piece == PieceType.factureFournisseur) {
        tresorie.categorie = 3;
        tresorie.objet = "${S.current.reglement_fournisseur} ${getPiecetype(_piece)} ${_piece.num_piece}";
      } else {
        if (item.piece == PieceType.retourClient ||
            item.piece == PieceType.avoirClient) {
          tresorie.categorie = 6;
          tresorie.objet = "${S.current.rembourcement_client}";
          tresorie.montant = tresorie.montant * -1;
        } else {
          if (item.piece == PieceType.retourFournisseur ||
              item.piece == PieceType.avoirFournisseur) {
            tresorie.categorie = 7;
            tresorie.objet = "${S.current.rembourcement_four}";
            tresorie.montant = tresorie.montant * -1;
          }
        }
      }
    }
    List<FormatPiece> list = await _queryCtr.getFormatPiece(PieceType.tresorie);
    tresorie.numTresorie = Helpers.generateNumPiece(list.first);

    int id_tresorie = await _queryCtr.addItemToTable(DbTablesNames.tresorie, tresorie);

    if (tresorie.categorie == 2 || tresorie.categorie == 3 ||
        tresorie.categorie == 6 || tresorie.categorie == 7) {
      ReglementTresorie reglementTresorie = new ReglementTresorie.init();
      reglementTresorie.tresorie_id = id_tresorie;
      reglementTresorie.piece_id = tresorie.pieceId;
      reglementTresorie.regler = double.parse((tresorie.montant).toStringAsFixed(2));

      await _queryCtr.addItemToTable(DbTablesNames.reglementTresorie, reglementTresorie);
    }

  }

  //******************************************************************************************************************************************
  //***********************************special pour la transformation de la piece*************************************************************

  Widget transferPieceDialog() {
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Builder(
          builder: (context) => SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Wrap(spacing: 13, runSpacing: 13, children: [
                    Center(
                        child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        "${S.current.transformer_title}: ",
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        )),
                      ),
                    )),
                    Visibility(
                      visible: (_piece.piece == PieceType.devis),
                      child: SizedBox(
                        width: 320.0,
                        child: Padding(
                          padding: EdgeInsetsDirectional.only(end: 0, start: 0),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            onPressed: () async {
                              var msg =
                                  await transfererPiece(context, "toCommande");
                              Helpers.showToast(msg);
                            },
                            child: Text(
                              S.current.to_commande,
                              style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                            ),
                            color: Colors.purple,
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: (_piece.piece == PieceType.devis ||
                          _piece.piece == PieceType.commandeClient ||
                          _piece.piece == PieceType.bonCommande),
                      child: SizedBox(
                        width: 320.0,
                        child: Padding(
                          padding: EdgeInsetsDirectional.only(end: 0, start: 0),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            onPressed: () async {
                              var msg = await transfererPiece(context, "toBon");
                              Helpers.showToast(msg);
                            },
                            child: (_piece.piece == PieceType.bonCommande)
                                ? Text(
                                    S.current.bon_reception,
                                    style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500)),
                                  )
                                : Text(
                                    S.current.bon_livraison,
                                    style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500)),
                                  ),
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: (_piece.piece != PieceType.factureClient &&
                          _piece.piece != PieceType.factureFournisseur),
                      child: SizedBox(
                        width: 320.0,
                        child: Padding(
                          padding: EdgeInsetsDirectional.only(end: 0, start: 0),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            onPressed: () async {
                              var msg =
                                  await transfererPiece(context, "toFacture");
                              Helpers.showToast(msg);
                            },
                            child: (_piece.piece == PieceType.devis ||
                                    _piece.piece == PieceType.commandeClient ||
                                    _piece.piece == PieceType.bonLivraison)
                                ? Text(
                                    S.current.facture_vente,
                                    style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500)),
                                  )
                                : Text(
                                    S.current.facture_achat,
                                    style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500)),
                                  ),
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: ((_piece.piece == PieceType.bonReception ||
                          _piece.piece == PieceType.bonLivraison ||
                          _piece.piece == PieceType.factureClient ||
                          _piece.piece == PieceType.factureFournisseur)),
                      child: SizedBox(
                        width: 320.0,
                        child: Padding(
                          padding: EdgeInsets.only(right: 0, left: 0),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            onPressed: () async {
                              var msg =
                                  await transfererPiece(context, "toRetour");
                              Helpers.showToast(msg);
                            },
                            color: Colors.redAccent,
                            child: Text(
                              _textBtnTransfereRetour(),
                              style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ));
    });
  }

  String _textBtnTransfereRetour() {
    switch (_piece.piece) {
      case (PieceType.bonLivraison):
        return S.current.retour_client;
        break;
      case (PieceType.factureClient):
        return S.current.avoir_client;
        break;
      case (PieceType.bonReception):
        return S.current.retour_fournisseur;
        break;
      case (PieceType.factureFournisseur):
        return S.current.avoir_fournisseur;
        break;
      default:
        return 'test';
        break;
    }
  }

  Future<String> transfererPiece(context, String to) async {
    try {
      int id = -1;
      Piece _newPiece = new Piece.init();

      _newPiece.piece = typePieceTransformer(_piece.piece, to);
      var res = await _queryCtr.getFormatPiece(_newPiece.piece);
      _newPiece.num_piece = Helpers.generateNumPiece(res.first);
      _newPiece.date = DateTime.now();
      _newPiece.mov = 1;
      _newPiece.transformer = 1;
      _newPiece.etat = 0;
      _newPiece.tarification = _piece.tarification;
      _newPiece.tier_id = _piece.tier_id;
      _newPiece.raisonSociale = _piece.raisonSociale;

      _newPiece.total_ht = double.parse((_piece.total_ht).toStringAsFixed(2));
      _newPiece.remise = _piece.remise;
      _newPiece.net_ht = double.parse((_piece.net_ht).toStringAsFixed(2));
      _newPiece.total_tva = double.parse((_piece.total_tva).toStringAsFixed(2));
      _newPiece.total_ttc = double.parse((_piece.total_ttc).toStringAsFixed(2));
      _newPiece.timbre = double.parse((_piece.timbre).toStringAsFixed(2));
      _newPiece.net_a_payer =
          double.parse((_piece.net_a_payer).toStringAsFixed(2));
      _newPiece.regler = double.parse((_piece.regler).toStringAsFixed(2));
      _newPiece.reste = double.parse((_piece.reste).toStringAsFixed(2));
      _newPiece.marge = double.parse((_piece.marge).toStringAsFixed(2));

      if (_newPiece.piece == PieceType.retourClient ||
          _newPiece.piece == PieceType.avoirClient ||
          _newPiece.piece == PieceType.retourFournisseur ||
          _newPiece.piece == PieceType.avoirFournisseur) {
        _newPiece.net_a_payer = _newPiece.net_a_payer * -1;
        _newPiece.regler = 0.0;

        //(val negative)
        _newPiece.reste = _newPiece.net_a_payer;
      }

      id = await _queryCtr.addItemToTable(DbTablesNames.pieces, _newPiece);
      if (id > -1) {
        _newPiece.id = id;
      }
      _selectedItems.forEach((article) async {
        Journaux journaux = Journaux.fromPiece(_newPiece, article);
        await _queryCtr.addItemToTable(DbTablesNames.journaux, journaux);
      });

      int _oldMov = _piece.mov;

      if(_newPiece.piece != PieceType.retourClient &&
          _newPiece.piece != PieceType.avoirClient &&
          _newPiece.piece != PieceType.retourFournisseur &&
          _newPiece.piece != PieceType.avoirFournisseur){

        await updateObjetTresorie(_newPiece) ;
      }


      //  add la transformation à la table transformer (oldPiece_id newPiece_id , oldMov)
      // update tresorie with triggers
      Transformer transformer = new Transformer.init();
      transformer.oldMov = _oldMov;
      transformer.oldPieceId = _piece.id;
      transformer.newPieceId = _newPiece.id;
      transformer.type_piece = _newPiece.piece;
      var resTrans = await _queryCtr.addItemToTable(DbTablesNames.transformer, transformer);

      // FP ou BC vers bl/Fc ou BR/FF
      // if (_oldMov == 0) {
      //   await addTresorie(_newPiece, transferer: true);
      // }

      var message = S.current.msg_transfere_err;
      if (resTrans > 0) {
        message = S.current.msg_piece_transfere;
      }

      setState(() {
        _piece.etat = 1;
      });

      if (_newPiece.piece == PieceType.retourClient ||
          _newPiece.piece == PieceType.avoirClient ||
          _newPiece.piece == PieceType.retourFournisseur ||
          _newPiece.piece == PieceType.avoirFournisseur) {
        await saveItem(1, isFromTransfer: true);
      } else {
        await saveItem(0, isFromTransfer: true);
      }

      Navigator.pop(context);
      return message;
    } catch (e) {
      var message = S.current.msg_transfere_err;
      return message;
    }
  }

  String typePieceTransformer(pi, to) {
    switch (pi) {
      case PieceType.devis:
        if (to == "toCommande") {
          return PieceType.commandeClient;
        } else {
          if (to == "toBon") {
            return PieceType.bonLivraison;
          } else {
            if (to == "toFacture") {
              return PieceType.factureClient;
            }
          }
        }
        break;
      case PieceType.commandeClient:
        if (to == "toBon") {
          return PieceType.bonLivraison;
        } else {
          if (to == "toFacture") {
            return PieceType.factureClient;
          }
        }
        break;
      case PieceType.bonLivraison:
        if (to == "toFacture") {
          return PieceType.factureClient;
        } else {
          if (to == "toRetour") {
            return PieceType.retourClient;
          }
        }
        break;
      case PieceType.factureClient:
        return PieceType.avoirClient;
        break;
      case PieceType.bonCommande:
        if (to == "toBon") {
          return PieceType.bonReception;
        } else {
          if (to == "toFacture") {
            return PieceType.factureFournisseur;
          }
        }
        break;
      case PieceType.bonReception:
        if (to == "toFacture") {
          return PieceType.factureFournisseur;
        } else {
          if (to == "toRetour") {
            return PieceType.retourFournisseur;
          }
        }
        break;
      case PieceType.factureFournisseur:
        return PieceType.avoirFournisseur;
        break;
    }
  }

  updateObjetTresorie(pieceTransfere) async{
    String objet = '';
    if (pieceTransfere.piece == PieceType.bonLivraison ||
        pieceTransfere.piece == PieceType.factureClient ||
        pieceTransfere.piece == PieceType.commandeClient) {
      objet = "${S.current.reglemnt_client} ${getPiecetype(pieceTransfere)} ${pieceTransfere.num_piece}";
    } else {
      if (pieceTransfere.piece == PieceType.bonReception ||
          pieceTransfere.piece == PieceType.factureFournisseur) {

        objet = "${S.current.reglement_fournisseur} ${getPiecetype(pieceTransfere)} ${pieceTransfere.num_piece}";
      }
    }
    await _queryCtr.updateObjetTresorie(oldPiece : _piece , objet : objet);
  }

  //******************************************************************************************************************************************
  //****************************************quik print****************************************************************************************
  quikPrintTicket() async {
    var defaultPrinter = await _queryCtr.getPrinter();

    if (defaultPrinter != null) {
      if (defaultPrinter.adress == "192.168.1.1" && defaultPrinter.type == 0) {
        final doc = await _makePdfDocument();
        await Printing.layoutPdf(
            onLayout: (PdfPageFormat format) async => doc.save());
      } else {
        PrinterBluetoothManager _printerManager = PrinterBluetoothManager();
        BluetoothDevice device = new BluetoothDevice();
        device.name = defaultPrinter.name;
        device.type = defaultPrinter.type;
        device.address = defaultPrinter.adress;
        device.connected = true;

        PrinterBluetooth _device = new PrinterBluetooth(device);

        _printerManager.selectPrinter(_device);

        Ticket ticket = await _maketicket(_myParams.defaultFormatPrint);
        _printerManager.printTicket(ticket).then((result) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              content: Text(
                result.msg,
                style: GoogleFonts.lato(),
              ),
            ),
          );
          dispose();
        }).catchError((error) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              content: Text(error.toString(), style: GoogleFonts.lato()),
            ),
          );
        });
      }
    } else {
      var message = S.current.msg_imp_err;
      Helpers.showToast(message);
    }
  }

  Future<Ticket> _maketicket(formatPrint) async {
    final ticket = Ticket(formatPrint);

    if (directionRtl) {
      var input = "${_profile.raisonSociale}";
      Uint8List encArabic = await CharsetConverter.encode(
          "ISO-8859-6", "${input.split('').reversed.join()}");
      ticket.textEncoded(encArabic,
          styles: PosStyles(
              codeTable: PosCodeTable.arabic,
              align: (formatPrint == PaperSize.mm80)
                  ? PosAlign.center
                  : PosAlign.left));
      if (_profile.activite != "") {
        input = "${_profile.activite}";
        encArabic = await CharsetConverter.encode(
            "ISO-8859-6", "${input.split('').reversed.join()}");
        ticket.textEncoded(encArabic,
            styles: PosStyles(
                codeTable: PosCodeTable.arabic,
                align: (formatPrint == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }
      if (_profile.adresse != "") {
        input = "${_profile.adresse}";
        encArabic = await CharsetConverter.encode(
            "ISO-8859-6", "${input.split('').reversed.join()}");
        ticket.textEncoded(encArabic,
            styles: PosStyles(
                codeTable: PosCodeTable.arabic,
                align: (formatPrint == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }
      if (_profile.ville != "") {
        input = "${_profile.ville}";
        encArabic = await CharsetConverter.encode(
            "ISO-8859-6", "${input.split('').reversed.join()}");
        ticket.textEncoded(encArabic,
            styles: PosStyles(
                codeTable: PosCodeTable.arabic,
                align: (formatPrint == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }
      if (_profile.telephone != "") {
        input = "${_profile.telephone}";
        encArabic = await CharsetConverter.encode(
            "ISO-8859-6", "${input.split('').reversed.join()}");
        ticket.textEncoded(encArabic,
            styles: PosStyles(
                codeTable: PosCodeTable.arabic,
                align: (formatPrint == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }
      if (_profile.rc != "") {
        input = "${_profile.rc}";
        encArabic = await CharsetConverter.encode(
            "ISO-8859-6", "${input.split('').reversed.join()}");
        ticket.textEncoded(encArabic,
            styles: PosStyles(
                codeTable: PosCodeTable.arabic,
                align: (formatPrint == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }
      if (_profile.nif != "") {
        input = "${_profile.nif}";
        encArabic = await CharsetConverter.encode(
            "ISO-8859-6", "${input.split('').reversed.join()}");
        ticket.textEncoded(encArabic,
            styles: PosStyles(
                codeTable: PosCodeTable.arabic,
                align: (formatPrint == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }
      if (_profile.nis != "") {
        input = "${_profile.nis}";
        encArabic = await CharsetConverter.encode(
            "ISO-8859-6", "${input.split('').reversed.join()}");
        ticket.textEncoded(encArabic,
            styles: PosStyles(
                codeTable: PosCodeTable.arabic,
                align: (formatPrint == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }
      if (_profile.ai != "") {
        input = "${_profile.ai}";
        encArabic = await CharsetConverter.encode(
            "ISO-8859-6", "${input.split('').reversed.join()}");
        ticket.textEncoded(encArabic,
            styles: PosStyles(
                codeTable: PosCodeTable.arabic,
                align: (formatPrint == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }
      ticket.hr(ch: '=');

      input = "${S.current.n} ${getPiecetype(_piece)}";
      encArabic = await CharsetConverter.encode("ISO-8859-6",
          "${_piece.num_piece}: ${input.split('').reversed.join()}");
      ticket.textEncoded(encArabic,
          styles: PosStyles(
              codeTable: PosCodeTable.arabic,
              align: (formatPrint == PaperSize.mm80)
                  ? PosAlign.center
                  : PosAlign.left));

      input = "${S.current.date}";
      encArabic = await CharsetConverter.encode("ISO-8859-6",
          "${Helpers.dateToText(_piece.date)}: ${input.split('').reversed.join()}");
      ticket.textEncoded(encArabic,
          styles: PosStyles(
              codeTable: PosCodeTable.arabic,
              align: (formatPrint == PaperSize.mm80)
                  ? PosAlign.center
                  : PosAlign.left));

      input = "${S.current.client_titre}";
      encArabic = await CharsetConverter.encode("ISO-8859-6",
          "${_piece.raisonSociale}: ${input.split('').reversed.join()}");
      ticket.textEncoded(encArabic,
          styles: PosStyles(
              codeTable: PosCodeTable.arabic,
              align: (formatPrint == PaperSize.mm80)
                  ? PosAlign.center
                  : PosAlign.left));

      if (_selectedClient.rc != "" &&
          (_piece.piece == PieceType.factureClient ||
              _piece.piece == PieceType.factureFournisseur ||
              _piece.piece == PieceType.avoirClient ||
              _piece.piece == PieceType.avoirFournisseur)) {
        input = "${_selectedClient.rc}";
        encArabic = await CharsetConverter.encode(
            "ISO-8859-6", "${input.split('').reversed.join()}");
        ticket.textEncoded(encArabic,
            styles: PosStyles(
                codeTable: PosCodeTable.arabic,
                align: (formatPrint == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }
      if (_selectedClient.nif != "" &&
          (_piece.piece == PieceType.factureClient ||
              _piece.piece == PieceType.factureFournisseur ||
              _piece.piece == PieceType.avoirClient ||
              _piece.piece == PieceType.avoirFournisseur)) {
        input = "${_selectedClient.nif}";
        encArabic = await CharsetConverter.encode(
            "ISO-8859-6", "${input.split('').reversed.join()}");
        ticket.textEncoded(encArabic,
            styles: PosStyles(
                codeTable: PosCodeTable.arabic,
                align: (formatPrint == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }
      if (_selectedClient.nis != "" &&
          (_piece.piece == PieceType.factureClient ||
              _piece.piece == PieceType.factureFournisseur ||
              _piece.piece == PieceType.avoirClient ||
              _piece.piece == PieceType.avoirFournisseur)) {
        input = "${_selectedClient.nis}";
        encArabic = await CharsetConverter.encode(
            "ISO-8859-6", "${input.split('').reversed.join()}");
        ticket.textEncoded(encArabic,
            styles: PosStyles(
                codeTable: PosCodeTable.arabic,
                align: (formatPrint == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }
      if (_selectedClient.ai != "" &&
          (_piece.piece == PieceType.factureClient ||
              _piece.piece == PieceType.factureFournisseur ||
              _piece.piece == PieceType.avoirClient ||
              _piece.piece == PieceType.avoirFournisseur)) {
        input = "${_selectedClient.ai}";
        encArabic = await CharsetConverter.encode(
            "ISO-8859-6", "${input.split('').reversed.join()}");
        ticket.textEncoded(encArabic,
            styles: PosStyles(
                codeTable: PosCodeTable.arabic,
                align: (formatPrint == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }

      ticket.hr(ch: '-');
      ticket.row([
        PosColumn(
            textEncoded: await CharsetConverter.encode("ISO-8859-6",
                "${S.current.articles.split('').reversed.join()}"),
            width: 6,
            styles: PosStyles(
              bold: true,
              codeTable: PosCodeTable.arabic,
            )),
        PosColumn(
            textEncoded: await CharsetConverter.encode(
                "ISO-8859-6", "${S.current.qte.split('').reversed.join()}"),
            width: 2,
            styles: PosStyles(
              bold: true,
              codeTable: PosCodeTable.arabic,
            )),
        PosColumn(
            textEncoded: await CharsetConverter.encode(
                "ISO-8859-6", "${S.current.prix.split('').reversed.join()}"),
            width: 2,
            styles: PosStyles(
              bold: true,
              codeTable: PosCodeTable.arabic,
            )),
        PosColumn(
            textEncoded: await CharsetConverter.encode(
                "ISO-8859-6", "${S.current.montant.split('').reversed.join()}"),
            width: 2,
            styles: PosStyles(
              bold: true,
              codeTable: PosCodeTable.arabic,
            )),
      ]);
      for (int i = 0; i < _selectedItems.length; i++) {
        var element = _selectedItems[i];
        ticket.row([
          (_myParams.printDisplay == 0)
              ? PosColumn(
                  textEncoded: await CharsetConverter.encode("ISO-8859-6",
                      "${element.ref.substring(0, (element.ref.length < 8 ? element.ref.length : 8))}"),
                  width: 6)
              : PosColumn(
                  textEncoded: await CharsetConverter.encode("ISO-8859-6",
                      "${element.designation.substring(0, (element.designation.length < 8 ? element.designation.length : 8))}"),
                  width: 6),
          ((element.selectedQuantite/element.quantiteColis) - (element.selectedQuantite/element.quantiteColis).truncate() > 0)?
          PosColumn(
              text:
              '${Helpers.numberFormat(element.selectedQuantite)} [${(element.selectedQuantite/element.quantiteColis).toInt()}+ ${S.current.colis_abr}]',
              width: 2)
          :PosColumn(
              text:
                  '${Helpers.numberFormat(element.selectedQuantite)} [${(element.selectedQuantite/element.quantiteColis).toInt()} ${S.current.colis_abr}]',
              width: 2),
          PosColumn(
              text: '${Helpers.numberFormat(element.selectedPrice).toString()}',
              width: 2),
          PosColumn(
              text:
                  '${Helpers.numberFormat((element.selectedPrice * element.selectedQuantite)).toString()}',
              width: 2),
        ]);
      }
      ticket.hr(ch: '-');
      if ((_piece.total_tva > 0 && _myParams.tva) || _piece.remise > 0) {
        input = "${S.current.total_ht}";
        encArabic = await CharsetConverter.encode("ISO-8859-6",
            "${Helpers.numberFormat(_piece.total_ht).toString()}: ${input.split('').reversed.join()}");
        ticket.textEncoded(encArabic,
            styles: PosStyles(
                codeTable: PosCodeTable.arabic,
                align: (formatPrint == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }
      if (_piece.remise > 0) {
        input = "${S.current.remise}";
        encArabic = await CharsetConverter.encode("ISO-8859-6",
            "(% ${Helpers.numberFormat(_piece.remise).toString()}) ${Helpers.numberFormat((_piece.total_ht * _piece.remise) / 100).toString()}: ${input.split('').reversed.join()}");
        ticket.textEncoded(encArabic,
            styles: PosStyles(
                codeTable: PosCodeTable.arabic,
                align: (formatPrint == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));

        input = "${S.current.net_ht}";
        encArabic = await CharsetConverter.encode("ISO-8859-6",
            "${Helpers.numberFormat(_piece.net_ht).toString()}: ${input.split('').reversed.join()}");
        ticket.textEncoded(encArabic,
            styles: PosStyles(
                codeTable: PosCodeTable.arabic,
                align: (formatPrint == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }
      if (_piece.total_tva > 0 && _myParams.tva) {
        input = "${S.current.total_tva}";
        encArabic = await CharsetConverter.encode("ISO-8859-6",
            "${Helpers.numberFormat(_piece.total_tva).toString()}: ${input.split('').reversed.join()}");
        ticket.textEncoded(encArabic,
            styles: PosStyles(
                codeTable: PosCodeTable.arabic,
                align: (formatPrint == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));

        input = "${S.current.total_ttc}";
        encArabic = await CharsetConverter.encode("ISO-8859-6",
            "${Helpers.numberFormat(_piece.total_ttc).toString()}: ${input.split('').reversed.join()}");
        ticket.textEncoded(encArabic,
            styles: PosStyles(
                codeTable: PosCodeTable.arabic,
                align: (formatPrint == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }

      if (_myParams.timbre) {
        input = "${S.current.timbre}";
        encArabic = await CharsetConverter.encode("ISO-8859-6",
            "${(_piece.total_ttc < _piece.net_a_payer) ? Helpers.numberFormat(_piece.timbre).toString() : Helpers.numberFormat(0.0).toString()}: ${input.split('').reversed.join()}");
        ticket.textEncoded(encArabic,
            styles: PosStyles(
                codeTable: PosCodeTable.arabic,
                align: (formatPrint == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }

      ticket.hr(ch: '=');
      input = "${S.current.net_payer}";
      encArabic = (_piece.net_a_payer >= 0)
          ? await CharsetConverter.encode("ISO-8859-6",
              "$_devise ${Helpers.numberFormat(_piece.net_a_payer).toString()}: ${input.split('').reversed.join()}")
          : await CharsetConverter.encode("ISO-8859-6",
              "$_devise ${Helpers.numberFormat((_piece.net_a_payer * -1)).toString()}: ${input.split('').reversed.join()}");
      ticket.textEncoded(encArabic,
          styles: PosStyles(
            codeTable: PosCodeTable.arabic,
            align: (formatPrint == PaperSize.mm80)
                ? PosAlign.center
                : PosAlign.left,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          ));

      ticket.hr(ch: '=');
      ticket.row([
        (_piece.piece != PieceType.bonCommande &&
                _piece.piece != PieceType.devis)
            ? PosColumn(
                textEncoded: (_piece.regler >= 0)
                    ? await CharsetConverter.encode("ISO-8859-6",
                        "${Helpers.numberFormat(_piece.regler).toString()}: ${S.current.regler.split('').reversed.join()}")
                    : await CharsetConverter.encode("ISO-8859-6",
                        "${Helpers.numberFormat((_piece.regler * -1)).toString()}: ${S.current.regler.split('').reversed.join()}"),
                width: 6)
            : PosColumn(width: 6),
        (_piece.reste != 0 &&
                (_piece.piece != PieceType.bonCommande &&
                    _piece.piece != PieceType.devis))
            ? PosColumn(
                textEncoded: (_piece.reste >= 0)
                    ? await CharsetConverter.encode("ISO-8859-6",
                        "${Helpers.numberFormat(_piece.reste).toString()}: ${S.current.reste.split('').reversed.join()}")
                    : await CharsetConverter.encode("ISO-8859-6",
                        "${Helpers.numberFormat(_piece.reste * -1).toString()}: ${S.current.reste.split('').reversed.join()}"),
                width: 6)
            : PosColumn(width: 6),
      ]);
      if (_myParams.creditTier && _piece.piece != PieceType.devis) {
        input = "${S.current.credit}";
        encArabic = await CharsetConverter.encode("ISO-8859-6",
            "${Helpers.numberFormat(_selectedClient.credit).toString()}: ${input.split('').reversed.join()}");
        ticket.textEncoded(encArabic,
            styles: PosStyles(codeTable: PosCodeTable.arabic));
      }

      ticket.feed(1);
      ticket.cut();
    } else {
      ticket.text("${_profile.raisonSociale}",
          styles: PosStyles(
              align: (formatPrint == PaperSize.mm80)
                  ? PosAlign.center
                  : PosAlign.left));
      if (_profile.activite != "") {
        ticket.text("${_profile.activite}",
            styles: PosStyles(
                align: (formatPrint == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }
      if (_profile.adresse != "") {
        ticket.text("${_profile.adresse}",
            styles: PosStyles(
                align: (formatPrint == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }
      if (_profile.ville != "") {
        ticket.text("${_profile.ville}",
            styles: PosStyles(
                align: (formatPrint == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }
      if (_profile.telephone != "") {
        ticket.text("${_profile.telephone}",
            styles: PosStyles(
                align: (formatPrint == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }
      if (_profile.rc != "") {
        ticket.text("${_profile.rc}",
            styles: PosStyles(
                align: (formatPrint == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }
      if (_profile.nif != "") {
        ticket.text("${_profile.nif}",
            styles: PosStyles(
                align: (formatPrint == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }
      if (_profile.nis != "") {
        ticket.text("${_profile.nis}",
            styles: PosStyles(
                align: (formatPrint == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }
      if (_profile.ai != "") {
        ticket.text("${_profile.ai}",
            styles: PosStyles(
                align: (formatPrint == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }
      ticket.hr(ch: '=');
      ticket.text("${S.current.n} ${_piece.piece}: ${_piece.num_piece}",
          styles: PosStyles(
              align: (formatPrint == PaperSize.mm80)
                  ? PosAlign.center
                  : PosAlign.left));
      ticket.text("${S.current.date} : ${Helpers.dateToText(_piece.date)}",
          styles: PosStyles(
              align: (formatPrint == PaperSize.mm80)
                  ? PosAlign.center
                  : PosAlign.left));
      ticket.text("${S.current.client_titre} : ${_piece.raisonSociale}",
          styles: PosStyles(
              align: (formatPrint == PaperSize.mm80)
                  ? PosAlign.center
                  : PosAlign.left));

      if (_selectedClient.rc != "" &&
          (_piece.piece == PieceType.factureClient ||
              _piece.piece == PieceType.factureFournisseur ||
              _piece.piece == PieceType.avoirClient ||
              _piece.piece == PieceType.avoirFournisseur)) {
        ticket.text("${S.current.rc} : ${_selectedClient.rc}",
            styles: PosStyles(
                align: (formatPrint == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }
      if (_selectedClient.nif != "" &&
          (_piece.piece == PieceType.factureClient ||
              _piece.piece == PieceType.factureFournisseur ||
              _piece.piece == PieceType.avoirClient ||
              _piece.piece == PieceType.avoirFournisseur)) {
        ticket.text("${S.current.nif} : ${_selectedClient.nif}",
            styles: PosStyles(
                align: (formatPrint == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }
      if (_selectedClient.nis != "" &&
          (_piece.piece == PieceType.factureClient ||
              _piece.piece == PieceType.factureFournisseur ||
              _piece.piece == PieceType.avoirClient ||
              _piece.piece == PieceType.avoirFournisseur)) {
        ticket.text("${S.current.nis} : ${_selectedClient.nis}",
            styles: PosStyles(
                align: (formatPrint == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }
      if (_selectedClient.ai != "" &&
          (_piece.piece == PieceType.factureClient ||
              _piece.piece == PieceType.factureFournisseur ||
              _piece.piece == PieceType.avoirClient ||
              _piece.piece == PieceType.avoirFournisseur)) {
        ticket.text("${S.current.art_imp} : ${_selectedClient.ai}",
            styles: PosStyles(
                align: (formatPrint == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }
      ticket.hr(ch: '-');
      ticket.row([
        PosColumn(
            text: '${S.current.articles}',
            width: 6,
            styles: PosStyles(bold: true)),
        PosColumn(
            text: '${S.current.qte}', width: 2, styles: PosStyles(bold: true)),
        PosColumn(
            text: '${S.current.prix}', width: 2, styles: PosStyles(bold: true)),
        PosColumn(
            text: '${S.current.montant}',
            width: 2,
            styles: PosStyles(bold: true)),
      ]);
      _selectedItems.forEach((element) async {
        ticket.row([
          (_myParams.printDisplay == 0)
              ? PosColumn(
                  text:
                      '${element.ref.substring(0, (element.ref.length < 8 ? element.ref.length : 8))}',
                  width: 6)
              : PosColumn(
                  text:
                      '${element.designation.substring(0, (element.designation.length < 8 ? element.designation.length : 8))}',
                  width: 6),
          ((element.selectedQuantite/element.quantiteColis) - (element.selectedQuantite/element.quantiteColis).truncate() > 0)?
          PosColumn(
              textEncoded: await CharsetConverter.encode("ISO-8859-6",
                  '${Helpers.numberFormat(element.selectedQuantite).toString()} [${(element.selectedQuantite/element.quantiteColis).toInt()}+ ${S.current.colis_abr}]'),
              width: 2)
          :PosColumn(
              textEncoded: await CharsetConverter.encode("ISO-8859-6",
                  '${Helpers.numberFormat(element.selectedQuantite).toString()} [${(element.selectedQuantite/element.quantiteColis).toInt()} ${S.current.colis_abr}]'),
              width: 2),
          PosColumn(
              textEncoded: await CharsetConverter.encode("ISO-8859-6",
                  '${Helpers.numberFormat(element.selectedPrice).toString()}'),
              width: 2),
          PosColumn(
              textEncoded: await CharsetConverter.encode("ISO-8859-6",
                  '${Helpers.numberFormat((element.selectedPrice * element.selectedQuantite)).toString()}'),
              width: 2),
        ]);
      });
      ticket.hr(ch: '-');
      var encode;
      if ((_piece.total_tva > 0 && _myParams.tva) || _piece.remise > 0) {
        encode = await CharsetConverter.encode("ISO-8859-6",
            "${S.current.total_ht} : ${Helpers.numberFormat(_piece.total_ht).toString()}");
        ticket.textEncoded(encode,
            styles: PosStyles(
                align: (formatPrint == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }
      if (_piece.remise > 0) {
        encode = await CharsetConverter.encode("ISO-8859-6",
            "${S.current.remise} : ${Helpers.numberFormat((_piece.total_ht * _piece.remise) / 100).toString()} (${Helpers.numberFormat(_piece.remise).toString()} %)");
        ticket.textEncoded(encode,
            styles: PosStyles(
                align: (formatPrint == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));

        encode = await CharsetConverter.encode("ISO-8859-6",
            "${S.current.net_ht} : ${Helpers.numberFormat(_piece.net_ht).toString()}");
        ticket.textEncoded(encode,
            styles: PosStyles(
                align: (formatPrint == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }
      if (_piece.total_tva > 0 && _myParams.tva) {
        encode = await CharsetConverter.encode("ISO-8859-6",
            "${S.current.total_tva} : ${Helpers.numberFormat(_piece.total_tva).toString()}");
        ticket.textEncoded(encode,
            styles: PosStyles(
                align: (formatPrint == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));

        encode = await CharsetConverter.encode("ISO-8859-6",
            "${S.current.total_ttc} : ${Helpers.numberFormat(_piece.total_ttc).toString()}");
        ticket.textEncoded(encode,
            styles: PosStyles(
                align: (formatPrint == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }

      if (_myParams.timbre) {
        encode = await CharsetConverter.encode("ISO-8859-6",
            "${S.current.timbre} : ${(_piece.total_ttc < _piece.net_a_payer) ? Helpers.numberFormat(_piece.timbre).toString() : Helpers.numberFormat(0.0).toString()}");
        ticket.textEncoded(encode,
            styles: PosStyles(
                align: (formatPrint == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }

      ticket.hr(ch: '=');
      encode = (_piece.net_a_payer >= 0)
          ? await CharsetConverter.encode("ISO-8859-6",
              "${S.current.net_payer} : ${Helpers.numberFormat(_piece.net_a_payer).toString()} ${_devise}")
          : await CharsetConverter.encode("ISO-8859-6",
              "${S.current.net_payer} : ${Helpers.numberFormat(_piece.net_a_payer * -1).toString()} ${_devise}");
      ticket.textEncoded(encode,
          styles: PosStyles(
            align: (formatPrint == PaperSize.mm80)
                ? PosAlign.center
                : PosAlign.left,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          ));
      ticket.hr(ch: '=');

      ticket.row([
        (_piece.piece != PieceType.bonCommande &&
                _piece.piece != PieceType.devis)
            ? PosColumn(
                textEncoded: (_piece.regler >= 0)
                    ? await CharsetConverter.encode("ISO-8859-6",
                        "${S.current.regler} : ${Helpers.numberFormat(_piece.regler).toString()}")
                    : await CharsetConverter.encode("ISO-8859-6",
                        "${S.current.regler} : ${Helpers.numberFormat(_piece.regler * -1).toString()}"),
                width: 6)
            : PosColumn(width: 6),
        (_piece.reste != 0 &&
                (_piece.piece != PieceType.bonCommande &&
                    _piece.piece != PieceType.devis))
            ? PosColumn(
                textEncoded: (_piece.reste > 0)
                    ? await CharsetConverter.encode("ISO-8859-6",
                        "${S.current.reste} : ${Helpers.numberFormat(_piece.reste).toString()}")
                    : await CharsetConverter.encode("ISO-8859-6",
                        "${S.current.reste} : ${Helpers.numberFormat(_piece.reste * -1).toString()}"),
                width: 6)
            : PosColumn(width: 6),
      ]);
      if (_myParams.creditTier && _piece.piece != PieceType.devis) {
        encode = await CharsetConverter.encode("ISO-8859-6",
            "${S.current.credit} : ${Helpers.numberFormat(_selectedClient.credit).toString()}");
        ticket.textEncoded(encode);
      }
      ticket.feed(1);
      ticket.cut();
    }

    return ticket;
  }

  Future _makePdfDocument() async {
    var data = await rootBundle.load("assets/arial.ttf");
    final arial = pw.Font.ttf(data);

    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        textDirection:
            (directionRtl) ? pw.TextDirection.rtl : pw.TextDirection.ltr,
        build: (context) => [
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Container(
                  width: 200,
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        (_profile.raisonSociale != null)
                            ? pw.Text("${_profile.raisonSociale} ",
                                style: pw.TextStyle(
                                    font: arial,
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 20))
                            : pw.SizedBox(),
                        (_profile.activite != "")
                            ? pw.Text("${_profile.activite} ",
                                style: pw.TextStyle(
                                    font: arial, fontWeight: pw.FontWeight.bold))
                            : pw.SizedBox(),
                        (_profile.adresse != "")
                            ? pw.Text(
                                "${_profile.adresse} ${_profile.departement} ${_profile.ville} ${_profile.pays}",
                                style: pw.TextStyle(
                                    font: arial, fontWeight: pw.FontWeight.bold))
                            : pw.SizedBox(),
                        (_profile.telephone != "")
                            ? pw.Text(
                                "${S.current.telephone}\t: ${_profile.telephone}",
                                style: pw.TextStyle(
                                    font: arial, fontWeight: pw.FontWeight.bold))
                            : pw.SizedBox(),
                        (_profile.fax != "")
                            ? pw.Text("${S.current.fax}\t: ${_profile.fax}",
                                style: pw.TextStyle(
                                    font: arial, fontWeight: pw.FontWeight.bold))
                            : pw.SizedBox(),
                        (_profile.mobile != "")
                            ? pw.Text(
                                "${S.current.mobile}\t: ${_profile.mobile}",
                                style: pw.TextStyle(
                                    font: arial, fontWeight: pw.FontWeight.bold))
                            : pw.SizedBox(),
                        (_profile.email != "")
                            ? pw.Text("${S.current.mail}\t: ${_profile.email}",
                                style: pw.TextStyle(
                                    font: arial, fontWeight: pw.FontWeight.bold))
                            : pw.SizedBox(),
                        (_profile.rc != "")
                            ? pw.Text("${S.current.rc}\t: ${_profile.rc}",
                                style: pw.TextStyle(
                                    font: arial, fontWeight: pw.FontWeight.bold))
                            : pw.SizedBox(),
                        (_profile.nif != "")
                            ? pw.Text("${S.current.nif}\t: ${_profile.nif}",
                                style: pw.TextStyle(
                                    font: arial, fontWeight: pw.FontWeight.bold))
                            : pw.SizedBox(),
                        (_profile.nis != "")
                            ? pw.Text("${S.current.nis}\t: ${_profile.nis}",
                                style: pw.TextStyle(
                                    font: arial, fontWeight: pw.FontWeight.bold))
                            : pw.SizedBox(),
                        (_profile.ai != "")
                            ? pw.Text("${S.current.art_imp}\t: ${_profile.ai}",
                                style: pw.TextStyle(
                                    font: arial, fontWeight: pw.FontWeight.bold))
                            : pw.SizedBox(),
                        (_profile.capital > 0)
                            ? pw.Text(
                                "${S.current.capitale_sociale}\t: ${Helpers.numberFormat(_profile.capital)} ${Helpers.getDeviseTranslate(_myParams.devise)}",
                                style: pw.TextStyle(
                                    font: arial, fontWeight: pw.FontWeight.bold))
                            : pw.SizedBox(),
                      ]),
                ),
                pw.SizedBox(width: 10),
                (_profile.imageUint8List != "")
                    ? pw.Container(
                        width: 200,
                        height: 200,
                        child: pw.Image(
                          pw.MemoryImage(
                            _profile.imageUint8List,
                          ),
                          height: 100,
                          width: 100,
                        ))
                    : pw.SizedBox(),
              ]),
          pw.SizedBox(height: 10),
          pw.Row(children: [
            pw.Expanded(
                flex: 6,
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                          (_piece.piece == PieceType.devis ||
                                  _piece.piece == PieceType.bonLivraison ||
                                  _piece.piece == PieceType.factureClient ||
                                  _piece.piece == PieceType.commandeClient ||
                                  _piece.piece == PieceType.retourClient ||
                                  _piece.piece == PieceType.avoirClient)
                              ? "${S.current.client_titre}\t ${_selectedClient.raisonSociale} "
                              : "${S.current.fournisseur_imp}\t ${_selectedClient.raisonSociale} ",
                          style: pw.TextStyle(font: arial)),
                      pw.Divider(height: 2),
                      (_selectedClient.adresse != "")
                          ? pw.Text(
                              "${S.current.adresse}\t  ${_selectedClient.adresse} ",
                              style: pw.TextStyle(font: arial))
                          : pw.SizedBox(),
                      (_selectedClient.ville != "")
                          ? pw.Text(
                              "${S.current.ville}\t  ${_selectedClient.ville}",
                              style: pw.TextStyle(font: arial))
                          : pw.SizedBox(),
                      ((_piece.piece == PieceType.factureClient ||
                                  _piece.piece ==
                                      PieceType.factureFournisseur ||
                                  _piece.piece == PieceType.avoirClient ||
                                  _piece.piece == PieceType.avoirFournisseur) &&
                              (_selectedClient.rc != ""))
                          ? pw.Text("${S.current.rc}\t  ${_selectedClient.rc}",
                              style: pw.TextStyle(font: arial))
                          : pw.SizedBox(),
                      ((_piece.piece == PieceType.factureClient ||
                                  _piece.piece ==
                                      PieceType.factureFournisseur ||
                                  _piece.piece == PieceType.avoirClient ||
                                  _piece.piece == PieceType.avoirFournisseur) &&
                              (_selectedClient.nif != ""))
                          ? pw.Text(
                              "${S.current.nif}\t  ${_selectedClient.nif}",
                              style: pw.TextStyle(font: arial))
                          : pw.SizedBox(),
                      ((_piece.piece == PieceType.factureClient ||
                                  _piece.piece ==
                                      PieceType.factureFournisseur ||
                                  _piece.piece == PieceType.avoirClient ||
                                  _piece.piece == PieceType.avoirFournisseur) &&
                              (_selectedClient.nis != ""))
                          ? pw.Text(
                              "${S.current.nis}\t  ${_selectedClient.nis}",
                              style: pw.TextStyle(font: arial))
                          : pw.SizedBox(),
                      ((_piece.piece == PieceType.factureClient ||
                                  _piece.piece ==
                                      PieceType.factureFournisseur ||
                                  _piece.piece == PieceType.avoirClient ||
                                  _piece.piece == PieceType.avoirFournisseur) &&
                              (_selectedClient.ai != ""))
                          ? pw.Text(
                              "${S.current.art_imp}\t  ${_selectedClient.ai}",
                              style: pw.TextStyle(font: arial))
                          : pw.SizedBox(),
                    ])),
            pw.SizedBox(width: 3),
            pw.Expanded(
                flex: 6,
                child: pw.Column(children: [
                  pw.Text("${Helpers.getPieceTitle(_piece.piece)}",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          font: arial,
                          fontSize: 20)),
                  pw.Text("${S.current.n}\t  ${_piece.num_piece}",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          font: arial,
                          fontSize: 16)),
                  pw.Text(
                      "${S.current.date}\t  ${Helpers.dateToText(_piece.date).split(' ').first}",
                      style: pw.TextStyle(font: arial)),
                ]))
          ]),
          pw.SizedBox(height: 20),
          pw.Table(children: [
            pw.TableRow(
                decoration: pw.BoxDecoration(
                    border: pw.Border(bottom: pw.BorderSide(width: 2))),
                children: [
                  pw.Container(
                    padding: pw.EdgeInsets.only(left: 5, right: 5, bottom: 2),
                    child: pw.Text("${S.current.referance}",
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            font: arial,
                            fontSize: 10)),
                  ),
                  pw.Container(
                    padding: pw.EdgeInsets.only(left: 5, right: 5, bottom: 2),
                    child: pw.Text("${S.current.designation}",
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            font: arial,
                            fontSize: 10)),
                  ),
                  pw.Container(
                    padding: pw.EdgeInsets.only(left: 5, right: 5, bottom: 2),
                    child: pw.Text("${S.current.qte}",
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            font: arial,
                            fontSize: 10)),
                  ),
                  pw.Container(
                    padding: pw.EdgeInsets.only(left: 5, right: 5, bottom: 2),
                    child: pw.Text("${S.current.colis}",
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            font: arial,
                            fontSize: 10)),
                  ),
                  pw.Container(
                    padding: pw.EdgeInsets.only(left: 5, right: 5, bottom: 2),
                    child: pw.Text("${S.current.prix}",
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            font: arial,
                            fontSize: 10)),
                  ),
                  pw.Container(
                    padding: pw.EdgeInsets.only(left: 5, right: 5, bottom: 2),
                    child: pw.Text("${S.current.tva}",
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            font: arial,
                            fontSize: 10)),
                  ),
                  pw.Container(
                      padding: pw.EdgeInsets.only(left: 5, right: 5, bottom: 2),
                      child: pw.Text("${S.current.montant_ht}",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              font: arial,
                              fontSize: 10))),
                ]),
            for (var e in _selectedItems)
              pw.TableRow(
                  decoration: pw.BoxDecoration(
                      border: pw.Border(
                          top: pw.BorderSide(
                              width: 0.5, color: PdfColors.grey))),
                  children: [
                    pw.Container(
                      padding: pw.EdgeInsets.only(left: 5, right: 5),
                      child: pw.Text((e.ref != '') ? "${e.ref}" : "##",
                          style: pw.TextStyle(font: arial, fontSize: 9)),
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.only(left: 5, right: 5),
                      child: pw.Text("${e.designation}",
                          style: pw.TextStyle(font: arial, fontSize: 9)),
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.only(left: 5, right: 5),
                      child: pw.Text(
                          "${Helpers.numberFormat(e.selectedQuantite)}",
                          style: pw.TextStyle(fontSize: 9)),
                    ),
                    ((e.selectedQuantite/e.quantiteColis) - (e.selectedQuantite/e.quantiteColis).truncate() > 0)?
                    pw.Container(
                      padding: pw.EdgeInsets.only(left: 5, right: 5),
                      child: pw.Text(
                          "${(e.selectedQuantite/e.quantiteColis).toInt()}+",
                          style: pw.TextStyle(fontSize: 9)),
                    )
                    :pw.Container(
                      padding: pw.EdgeInsets.only(left: 5, right: 5),
                      child: pw.Text(
                          "${(e.selectedQuantite/e.quantiteColis).toInt()}",
                          style: pw.TextStyle(fontSize: 9)),
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.only(left: 5, right: 5),
                      child: pw.Text("${Helpers.numberFormat(e.selectedPrice)}",
                          style: pw.TextStyle(fontSize: 9)),
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.only(left: 5, right: 5),
                      child: pw.Text("${Helpers.numberFormat(e.tva)}",
                          style: pw.TextStyle(fontSize: 9)),
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.only(left: 5, right: 5),
                      child: pw.Text(
                          "${Helpers.numberFormat((e.selectedPrice * e.selectedQuantite))}",
                          style: pw.TextStyle(fontSize: 9)),
                    ),
                  ]),
          ]),
          pw.SizedBox(height: 5),
          pw.Divider(height: 2),
          pw.SizedBox(height: 10),
          pw.Row(children: [
            pw.Expanded(
                flex: 6,
                child: pw.Column(
                    crossAxisAlignment: (Intl.getCurrentLocale() == "ar")
                        ? pw.CrossAxisAlignment.end
                        : pw.CrossAxisAlignment.start,
                    children: [
                      (_piece.piece != PieceType.bonCommande &&
                              _piece.piece != PieceType.devis)
                          ? pw.Text(
                              (_piece.regler >= 0)
                                  ? "${S.current.regler}\t ${Helpers.numberFormat(_piece.regler)} ${_devise}"
                                  : "${S.current.regler}\t ${Helpers.numberFormat(_piece.regler * -1)} ${_devise}",
                              style: pw.TextStyle(font: arial))
                          : pw.SizedBox(),
                      (_piece.reste != 0 &&
                              (_piece.piece != PieceType.bonCommande &&
                                  _piece.piece != PieceType.devis))
                          ? pw.Text(
                              (_piece.reste > 0)
                                  ? "${S.current.reste}\t ${Helpers.numberFormat(_piece.reste)} ${_devise}"
                                  : "${S.current.reste}\t ${Helpers.numberFormat(_piece.reste * -1)} ${_devise}",
                              style: pw.TextStyle(font: arial))
                          : pw.SizedBox(),
                      (_myParams.creditTier && _piece.piece != PieceType.devis)
                          ? pw.Text(
                              "${S.current.credit}\t ${Helpers.numberFormat(_selectedClient.credit)} ${_devise}",
                              style: pw.TextStyle(font: arial))
                          : pw.SizedBox(),
                      pw.Divider(height: 2),
                      pw.Text(S.current.msg_arret_somme,
                      style: pw.TextStyle(font: arial , fontSize: 10)),
                      pw.Text(getPieceSuminLetters(),
                          style: pw.TextStyle(
                              font: arial, fontWeight:pw.FontWeight.bold)),
                    ])),
            pw.SizedBox(width: 10),
            pw.Expanded(
                flex: 6,
                child: pw.Column(
                    crossAxisAlignment: (Intl.getCurrentLocale() == "ar")
                        ? pw.CrossAxisAlignment.end
                        : pw.CrossAxisAlignment.start,
                    children: [
                      ((_piece.total_tva > 0 && _myParams.tva) ||
                              _piece.remise > 0)
                          ? pw.Text(
                              "${S.current.total_ht}\t  ${Helpers.numberFormat(_piece.total_ht)}\t ${_devise}",
                              style: pw.TextStyle(font: arial))
                          : pw.SizedBox(),
                      (_piece.remise > 0)
                          ? pw.Text(
                              "${S.current.remise}\t  ${Helpers.numberFormat((_piece.total_ht * _piece.remise) / 100)}\t ${_devise}\t (${_piece.remise.toStringAsFixed(2)}\t %)",
                              style: pw.TextStyle(font: arial))
                          : pw.SizedBox(),
                      (_piece.remise > 0)
                          ? pw.Text(
                              "${S.current.net_ht}\t  ${Helpers.numberFormat(_piece.net_ht)}\t ${_devise}",
                              style: pw.TextStyle(font: arial))
                          : pw.SizedBox(),
                      (_piece.total_tva > 0 && _myParams.tva)
                          ? pw.Text(
                              "${S.current.total_tva}\t  ${Helpers.numberFormat(_piece.total_tva)}\t  ${_devise}",
                              style: pw.TextStyle(font: arial))
                          : pw.SizedBox(),
                      (_piece.total_tva > 0 && _myParams.tva)
                          ? pw.Text(
                              "${S.current.total_ttc}\t  ${Helpers.numberFormat(_piece.total_ttc)}\t  ${_devise}",
                              style: pw.TextStyle(font: arial))
                          : pw.SizedBox(),
                      pw.Divider(height: 2),
                      (_myParams.timbre)
                          ? pw.Text(
                              "${S.current.timbre}\t  ${(_piece.total_ttc < _piece.net_a_payer) ? Helpers.numberFormat(_piece.timbre) : Helpers.numberFormat(0.0)}\t  ${_devise}",
                              style: pw.TextStyle(font: arial))
                          : pw.SizedBox(),
                      pw.RichText(
                        text: pw.TextSpan(
                          children: [
                            pw.TextSpan(
                              text: "${S.current.net_payer}\t ",
                              style: pw.TextStyle(font: arial)
                            ),
                            pw.TextSpan(
                                text: (_piece.net_a_payer >= 0)
                                    ? "${Helpers.numberFormat(_piece.net_a_payer)}\t"
                                    : "${Helpers.numberFormat(_piece.net_a_payer * -1)}\t",
                                style: pw.TextStyle(fontWeight: pw.FontWeight.bold , fontSize: 15),
                            ),
                            pw.TextSpan(
                              text:  " $_devise",
                              style: pw.TextStyle(font: arial , fontSize: 15)
                            )
                          ]
                        )
                      ),
                      pw.Divider(height: 2),
                    ])),
            pw.SizedBox(width: 3),
          ]),
        ],
      ),
    );

    return doc;
  }

  Future _saveLanPrinter() async {
    defaultPrinter.name = "lan printer";
    defaultPrinter.adress = "192.168.1.1";
    defaultPrinter.type = 0;
    await _queryCtr.addItemToTable(
        DbTablesNames.defaultPrinter, defaultPrinter);
  }

  String getPiecetype(item) {
    switch (item.piece) {
      case "FP":
        return S.current.fp;
        break;
      case "CC":
        return S.current.cc;
        break;
      case "BL":
        return S.current.bl;
        break;
      case "FC":
        return S.current.fc;
        break;
      case "RC":
        return S.current.rc;
        break;
      case "AC":
        return S.current.ac;
        break;
      case "BC":
        return S.current.bc;
        break;
      case "BR":
        return S.current.br;
        break;
      case "FF":
        return S.current.ff;
        break;
      case "RF":
        return S.current.rf;
        break;
      case "AF":
        return S.current.af;
        break;
    }
  }

  String getPieceSuminLetters() {
    String res = '';
    res = res +
        "${Helpers.numberToWords((_piece.net_a_payer.toInt()).toString()).capitalizeFirstofEach} ${Helpers.currencyName(_myParams.devise)} ";

    int a = (_piece.net_a_payer % 1 * 100).roundToDouble().toInt();
    if (a > 0) {
      res = res +
          "${Helpers.numberToWords(a.toString()).capitalizeFirstofEach} ${S.current.centime}";
    }

    return res;
  }
}
