import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:charset_converter/charset_converter.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';
import 'package:floating_action_row/floating_action_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/Widgets/CustomWidgets/add_save_bar.dart';
import 'package:gestmob/Widgets/CustomWidgets/bottom_tab_bar.dart';
import 'package:gestmob/Widgets/CustomWidgets/image_picker_widget.dart';
import 'package:gestmob/Widgets/CustomWidgets/list_dropdown.dart';
import 'package:gestmob/Widgets/CustomWidgets/selectable_list_item.dart';
import 'package:gestmob/Widgets/article_list_item.dart';
import 'package:gestmob/Widgets/total_devis.dart';
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
import 'package:gestmob/models/TiersFamille.dart';
import 'package:gestmob/models/Transformer.dart';
import 'package:gestmob/models/Tresorie.dart';
import 'package:gestmob/search/items_sliver_list.dart';
import 'package:gestmob/search/sliver_list_data_source.dart';
import 'package:gestmob/ui/ClientFourFragment.dart';
import 'package:gestmob/ui/JournalFragment.dart';
import 'package:gestmob/ui/preview_piece.dart';
import 'package:gestmob/ui/printer_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gestmob/Widgets/utils.dart' as utils;
import 'package:map_launcher/map_launcher.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'ArticlesFragment.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:feature_discovery/feature_discovery.dart';

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

  Piece _pieceFrom ;
  Piece _pieceTo ;
  Transformer _trasformers ;

  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      FeatureDiscovery.discoverFeatures(
        context,
         <String>{ // Feature ids for every feature that you want to showcase in order.
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

    buildTarification(_myParams.tarification) ;
    _tarificationDropdownItems =
        utils.buildDropTarificationTier(_tarificationItems);

    if (widget.arguments is Piece &&
        widget.arguments.id != null &&
        widget.arguments.id > -1) {
      editMode = false;
      modification = true;
      await setDataFromItem(widget.arguments);
      if(_piece.etat == 1){
        _trasformers = await _queryCtr.getTransformer(_piece,"old");
        _pieceTo = await _queryCtr.getPieceById(_trasformers.newPieceId);
      }
      if(_piece.transformer == 1){
        _trasformers = await _queryCtr.getTransformer(_piece,"new");
        _pieceFrom = await _queryCtr.getPieceById(_trasformers.oldPieceId);
      }
      _selectedTarification = _piece.tarification;
    } else {
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
      _selectedItems = await _queryCtr.getJournalPiece(item, local: false);
      _verssementControler.text = "0.0";
      _resteControler.text = _piece.reste.toString();

      _oldMov = _piece.mov;
      _restepiece = _piece.reste;
      _verssementpiece = 0;

      _total_ht = _piece.total_ht;
      _net_ht = _piece.net_ht;
      _total_tva = _piece.total_tva;
      _total_ttc =
          (_piece.total_ttc < 0) ? _piece.total_ttc * -1 : _piece.total_ttc;
      _timbre = _piece.timbre;
      _net_a_payer = _piece.net_a_payer;
      _remisepiece = (_piece.remise * _total_ht) / 100;
      _pourcentremise = _piece.remise;

      _remisepieceControler.text = _remisepiece.toString();
      _pourcentremiseControler.text = _pourcentremise.toString();
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
      _net_a_payer = _total_ttc;
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

  void buildTarification (tarification) {
    setState(() {
      switch(tarification){
        case 1 :
          _tarificationItems = Statics.tarificationItems.sublist(0,1);
          break;
        case 2 :
          _tarificationItems = Statics.tarificationItems.sublist(0,2);
          break;
        case 3 :
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
      return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AddEditBar(
            editMode: editMode,
            modification: modification,
            title: appBarTitle,
            onCancelPressed: () => {
              if (modification)
                {
                  if (editMode)
                    {
                      Navigator.of(context).pushReplacementNamed(
                          RoutesKeys.addPiece,
                          arguments: widget.arguments)
                    }
                  else
                    {Navigator.pop(context)}
                }
              else
                {
                  Navigator.pop(context),
                }
            },
            onEditPressed:(_piece.etat == 0)? () {
              setState(() {
                editMode = true;
              });
            }:(){
              Helpers.showFlushBar(context, S.current.msg_no_edit_transformer);
            },
            onSavePressed: () async {
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
                Helpers.showFlushBar(context, S.current.msg_select_art);
              }
            },
            onTrensferPressed: (_piece.etat == 0 &&
                    _piece.piece != PieceType.retourClient &&
                    _piece.piece != PieceType.avoirClient &&
                    _piece.piece != PieceType.retourFournisseur &&
                    _piece.piece != PieceType.avoirFournisseur)
                ? () async {
                    if (_piece.mov == 2) {
                      var message = S.current.msg_err_transfer;
                      Helpers.showFlushBar(context, message);
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
                : null,
          ),
          // extendBody: true,
          bottomNavigationBar: BottomExpandableAppBar(
            appBarHeight: 70,
            expandedHeight: 180,
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
              remise: _pourcentremise,
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
                    tapTarget: Icon(MdiIcons.sigma , color: Colors.black,),
                    backgroundColor: Colors.blue,
                    contentLocation: ContentLocation.above,
                    title: Text('${S.current.ajout_remise}'),
                    description: Container(
                      width: 150,
                      child: Text(
                          '${S.current.msg_ajout_remise}'),
                    ),
                    onBackgroundTap: () async{
                      await FeatureDiscovery.completeCurrentStep(context);
                      return true ;
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
                                    _pourcentremiseControler.text = _pourcentremise.toString() ;
                                    _remisepieceControler.text = _remisepiece.toString();
                                  });
                                },
                                btnOkText: S.current.confirme,
                                btnOkOnPress: () {
                                  setState(() {
                                    _pourcentremise = double.parse(
                                        _pourcentremiseControler.text);
                                    _remisepiece =
                                        double.parse(_remisepieceControler.text);
                                  });
                                  calculPiece();
                                })
                              ..show();
                          } else {
                            Helpers.showFlushBar(
                                context, S.current.msg_select_art);
                          }
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border:(editMode)
                                ? Border(bottom: BorderSide(color: Colors.blue , width: 1)) : null
                        ),
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
                                  "${_devise}",
                                  style: TextStyle(
                                      fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              Helpers.numberFormat(_net_a_payer).toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
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
                    tapTarget: Icon(MdiIcons.cashMultiple , color: Colors.black,),
                    backgroundColor: Colors.green,
                    contentLocation: ContentLocation.above,
                    title:  Text('${S.current.ajout_verssement}'),
                    description:  Container(
                      width: 150,
                      child: Text(
                          '${S.current.msg_ajout_verssement}'),
                    ),
                    onBackgroundTap: () async{
                      await FeatureDiscovery.completeCurrentStep(context);
                      return true ;
                    },
                    child: InkWell(
                      onTap: () async {
                        if (editMode) {
                          if (_piece.piece != PieceType.devis &&
                              _piece.piece != PieceType.bonCommande &&
                              _piece.piece != PieceType.retourClient &&
                              _piece.piece != PieceType.avoirClient &&
                              _piece.piece != PieceType.retourFournisseur &&
                              _piece.piece != PieceType.avoirFournisseur) {
                            if (_selectedItems.isNotEmpty) {
                              if(_net_a_payer > _piece.regler){
                                setState(() {
                                  double _reste = _total_ttc - (_piece.regler + _verssementpiece);
                                  _resteControler.text = _reste.toString();
                                });
                                AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.INFO,
                                    animType: AnimType.BOTTOMSLIDE,
                                    title: S.current.supp,
                                    body: addVerssementdialogue(),
                                    btnCancelText: S.current.annuler,
                                    btnCancelOnPress: () {},
                                    btnOkText: S.current.confirme,
                                    btnOkOnPress: () {
                                      setState(() {
                                        _restepiece =
                                            double.parse(_resteControler.text);
                                        _verssementpiece =
                                            double.parse(_verssementControler.text);
                                      });
                                    })
                                  ..show();
                              }else{
                                Helpers.showFlushBar(
                                    context, S.current.msg_versement_err);
                              }

                            } else {
                              Helpers.showFlushBar(
                                  context, S.current.msg_select_art);
                            }
                          } else {
                            Helpers.showFlushBar(context, S.current.msg_no_dispo);
                          }
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border:(editMode && _piece.piece != PieceType.devis &&
                              _piece.piece != PieceType.bonCommande &&
                              _piece.piece != PieceType.retourClient &&
                              _piece.piece != PieceType.avoirClient &&
                              _piece.piece != PieceType.retourFournisseur &&
                              _piece.piece != PieceType.avoirFournisseur)
                              ? Border(bottom: BorderSide(color: Colors.blue , width: 1)) : null
                        ),
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
                                            _piece.piece !=
                                                PieceType.retourClient &&
                                            _piece.piece !=
                                                PieceType.avoirClient &&
                                            _piece.piece !=
                                                PieceType.retourFournisseur &&
                                            _piece.piece !=
                                                PieceType.avoirFournisseur &&
                                            editMode)
                                        ? Colors.blue
                                        : Theme.of(context).primaryColorDark),
                                Text(
                                  "${_devise}",
                                  style: TextStyle(
                                      fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              Helpers.numberFormat(_verssementpiece+_piece.regler).toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
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
          floatingActionButton: GestureDetector(
            // Set onVerticalDrag event to drag handlers of controller for swipe effect
            onVerticalDragUpdate: bottomBarControler.onDrag,
            onVerticalDragEnd: bottomBarControler.onDragEnd,
            child: DescribedFeatureOverlay(
              featureId: feature3,
              tapTarget: Icon(MdiIcons.arrowExpandUp , color: Colors.black,),
              backgroundColor: Colors.blue,
              contentLocation: ContentLocation.above,
              title: Text('${S.current.swipe_top}'),
              description: Container(
                width: 150,
                child: Text(
                    '${S.current.msg_swipe_top}'),
              ),
              onBackgroundTap: () async{
                await FeatureDiscovery.completeCurrentStep(context);
                return true ;
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
                                    _piece.piece == PieceType.retourFournisseur ||
                                    _piece.piece == PieceType.avoirFournisseur) {

                                  var message = S.current.msg_info_article;
                                  Helpers.showFlushBar(context, message);
                                }
                                calculPiece();
                              });

                            }
                          : () async {
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
          ),
          body: Builder(
            builder: (context) => fichetab(),
          ));
    }
  }

  Widget fichetab() {
    return SingleChildScrollView(
        physics: ScrollPhysics(),
        padding: const EdgeInsets.all(10),
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          Card(
            elevation: 4,
            child: Container(
              padding: EdgeInsets.all(15),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  (_piece.etat == 1 && _pieceTo != null)
                      ?SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                              Icon(Icons.check_circle , size: 12, color: Colors.green,),
                              SizedBox(width: 5,),
                              Text("${S.current.msg_piece_transformer_to} ${getPiecetype(_pieceTo)} ${_pieceTo.num_piece}", style:TextStyle(fontSize: 13))

                          ],
                        ),
                      ):SizedBox(height: 0,),
                  (_piece.transformer == 1 && _pieceFrom != null)
                      ?SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Icon(Icons.check_circle , size: 12, color: Colors.green,),
                            SizedBox(width: 5,),
                            Text("${S.current.msg_piece_transformer_from} ${getPiecetype(_pieceFrom)} ${_pieceFrom.num_piece}" , style:TextStyle(fontSize: 13))

                          ],
                        ),
                      ):SizedBox(height: 0,),
                  Row(
                    children: [
                      Flexible(
                        flex: 4,
                        child: TextField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              MdiIcons.idCard,
                              color: Colors.orange[900],
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.orange[900]),
                                borderRadius: BorderRadius.circular(20)),
                            labelText: "${S.current.n}",
                            labelStyle: TextStyle(color: Colors.orange[900]),
                            enabledBorder: OutlineInputBorder(
                              gapPadding: 3.3,
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.orange[900]),
                            ),
                          ),
                          enabled: editMode,
                          controller: _numeroControl,
                          keyboardType: TextInputType.text,
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
                              labelStyle: TextStyle(color: Colors.blue),
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
                  Row(
                    children: [
                      Flexible(
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
                            if(_selectedItems.isNotEmpty)
                              dialogChangeTarif() ;
                          },
                        ),
                      ),
                      Flexible(
                        flex: 6,
                        child: GestureDetector(
                          onTap: editMode ? ()  {
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
                              labelText: S.current.client_titre,
                              labelStyle: TextStyle(color: Colors.blue),
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
                                return  DescribedFeatureOverlay(
                                  featureId: feature12,
                                  tapTarget: Icon(MdiIcons.arrowExpandRight , color: Colors.black,),
                                  backgroundColor: Colors.blue,
                                  contentLocation: ContentLocation.above,
                                  title: Text('${S.current.swipe}'),
                                  description: Container(
                                    width: 100,
                                    child: Text(
                                        '${S.current.msg_swipe_start}'),
                                  ),
                                  onBackgroundTap: () async{
                                    await FeatureDiscovery.completeCurrentStep(context);
                                    return true ;
                                  },
                                  child: ArticleListItemSelected(
                                    article: _selectedItems[index],
                                    onItemSelected: (selectedItem) => ({
                                      removeItemfromPiece(selectedItem),
                                      calculPiece()
                                    }),
                                  ),
                                );
                              } else {
                                return ArticleListItemSelected(
                                  article: _selectedItems[index],
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
    return new JournalFragment(
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
  Widget chooseClientDialog()  {
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
              _piece.tier_id = _selectedClient.id;
              _piece.raisonSociale = _selectedClient.raisonSociale;
              _clientControl.text = _selectedClient.raisonSociale;

              if(_tarificationItems.indexOf(selectedItem.tarification) == -1){
                buildTarification(selectedItem.tarification);
                _tarificationDropdownItems =
                    utils.buildDropTarificationTier(_tarificationItems);
              }
              _selectedTarification = _selectedClient.tarification;
            });
          },
        );
      },
    ).then((value) {
      if(_selectedItems.isNotEmpty)
        dialogChangeTarif() ;
    });
  }

  Widget dialogChangeTarif(){
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
          _selectedItems.forEach((element) {
            switch (_selectedTarification){
              case 1 :
                element.selectedPrice = element.prixVente1 ;
                break ;
              case 2 :
                element.selectedPrice = element.prixVente2 ;
                break ;
              case 3 :
                element.selectedPrice = element.prixVente3 ;
                break ;
            }
          });
        });
        calculPiece() ;
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
                "${S.current.modification_titre} ${S.current.verssement}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )),
            Padding(
              padding: EdgeInsetsDirectional.only(start: 5, end: 5, bottom: 20),
              child: TextField(
                controller: _verssementControler,
                keyboardType: TextInputType.number,
                onTap: () =>{
                  _verssementControler.selection = TextSelection(baseOffset: 0, extentOffset: _verssementControler.value.text.length),
                },
                onChanged: (value) {
                  if (_piece.id != null) {
                    if (_verssementpiece == 0) {
                      double _reste =
                          _total_ttc - (_piece.regler + double.parse(value));
                      _resteControler.text = _reste.toString();
                    } else {
                      double _reste =
                          _total_ttc - (_piece.regler + double.parse(value));
                      _resteControler.text = _reste.toString();
                    }
                  } else {
                    double _reste = _total_ttc - double.parse(value);
                    _resteControler.text = _reste.toString();
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
                  labelText: "${S.current.total} ${S.current.verssement}",
                  labelStyle: TextStyle(color: Colors.green),
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
                          labelStyle: TextStyle(color: Colors.orange[900]),
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
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )),
            Padding(
              padding: EdgeInsetsDirectional.only(start: 5, end: 5, bottom: 20),
              child: TextField(
                controller: _remisepieceControler,
                keyboardType: TextInputType.number,
                onTap: () =>{
                  _remisepieceControler.selection = TextSelection(baseOffset: 0, extentOffset: _remisepieceControler.value.text.length),
                },
                onChanged: (value) {
                  double res = (double.parse(value) * 100) / _total_ht ;
                  _pourcentremiseControler.text = res.toString();
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
                  labelStyle: TextStyle(color: Colors.green[400]),
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
                        onTap: () =>{
                          _pourcentremiseControler.selection = TextSelection(baseOffset: 0, extentOffset: _pourcentremiseControler.value.text.length),
                        },
                        onChanged: (value) {
                          double res = (_total_ht * double.parse(value)) / 100;
                          _remisepieceControler.text = res.toString();
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
                          labelStyle: TextStyle(color: Colors.orange[900]),
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

  //dialog de save
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
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                        ),
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
                            style: TextStyle(color: Colors.white, fontSize: 16),
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
                            style: TextStyle(color: Colors.white, fontSize: 16),
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
                              var message = S.current.msg_demo_exp;
                              Helpers.showFlushBar(context, message);
                            }
                          },
                          child: Text(
                            S.current.lan_print,
                            style: TextStyle(color: Colors.white, fontSize: 16),
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
                            style: TextStyle(color: Colors.white, fontSize: 16),
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
  // le total_ttc = net_a_payer le timbre = est calcule par une fct
  void calculPiece() {
    double sum = 0;
    double totalTva = 0;
    setState(() {
      _selectedItems.forEach((item) {
        sum += (item.selectedQuantite * item.selectedPrice);
        totalTva += item.selectedQuantite * item.tva;
      });
      _total_ht = sum;
      _total_tva = (_myParams.tva) ? totalTva : 0.0;
      _net_ht = _total_ht - ((_total_ht * _pourcentremise) / 100);
      _total_ttc = _net_ht + _total_tva;
      _timbre = Helpers.calcTimber(_total_ttc, _myParams);
      _net_a_payer =
          ((_myParams.timbre) ? _total_ttc + _timbre : _total_ttc + 0.0);

      if (_piece.id != null) {
        if (_net_a_payer <= _piece.net_a_payer) {
          _verssementpiece = 0.0;
          _verssementControler.text = _verssementpiece.toString();
          _restepiece = _net_a_payer - _piece.regler;
          _resteControler.text = _restepiece.toString();
        } else {
          // le verssement est 0 tjr tq l'utilisateur ne le modifie pas
          // _verssementpiece = _net_a_payer - _piece.regler;
          // if(_piece.piece == PieceType.commandeClient){
          //   _verssementpiece = 0.0 ;
          // }
          _verssementpiece = 0.0;
          _verssementControler.text = _verssementpiece.toString();
          _restepiece = _net_a_payer - _piece.regler;
          _resteControler.text = "0.0";
        }
      } else {
        // le verssement est 0 tjr tq l'utilisateur ne le modifie pas
        // _verssementpiece = _net_a_payer;
        // if(_piece.piece == PieceType.commandeClient){
        //   _verssementpiece = 0.0 ;
        // }
        _verssementpiece = 0.0;
        _verssementControler.text = _verssementpiece.toString();
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
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                        ),
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
                            await saveItem(mov , isFromTransfer: false);
                            await quikPrintTicket();
                          },
                          child: Text(
                            S.current.imp_rapide_btn,
                            style: TextStyle(color: Colors.white, fontSize: 16),
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
                            await saveItem(mov , isFromTransfer: false);
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
                            style: TextStyle(color: Colors.white, fontSize: 16),
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
                            await saveItem(mov , isFromTransfer: false);
                          },
                          child: Text(
                            S.current.save_btn,
                            style: TextStyle(color: Colors.white, fontSize: 16),
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
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

  saveItem(int move , {@required bool isFromTransfer}) async {
    _piece.mov = move;
    int id = await addItemToDb(isFromTransfer: isFromTransfer);
    if (id > -1) {
      setState(() {
        modification = true;
        editMode = false;
        _verssementpiece = 0.0;
      });
    }
  }

  saveItemAsDraft() async {
    saveItem(2 , isFromTransfer: false);
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
        var item = await makePiece(isFromTransfer:isFromTransfer);
        if(item != null){
          id = await _queryCtr.updateItemInDb(DbTablesNames.pieces, item);
          _selectedItems.forEach((article) async {
            Journaux journaux = Journaux.fromPiece(item, article);
            await _queryCtr.updateJournaux(DbTablesNames.journaux, journaux);
          });
          _desSelectedItems.forEach((article) async {
            Journaux journaux = Journaux.fromPiece(item, article);
            journaux.mov = -2;
            await _queryCtr.updateJournaux(DbTablesNames.journaux, journaux);
          });

          if (_oldMov != null && _piece.mov != _oldMov) {
            //ds le cas de modification de mov de piece
            // update tresorie mov
            await _queryCtr.updateItemByForeignKey(
                DbTablesNames.tresorie, "Mov", _piece.mov, "Piece_id", _piece.id);
          }

          if (_piece.piece != PieceType.devis &&
              _piece.piece != PieceType.retourClient &&
              _piece.piece != PieceType.avoirClient &&
              _piece.piece != PieceType.retourFournisseur &&
              _piece.piece != PieceType.avoirFournisseur) {

            await addTresorie(_piece, transferer: false);
          }

          if (id > -1) {
            widget.arguments = item;
            widget.arguments.id = _piece.id;
            message = S.current.msg_update_item;
          } else {
            message = S.current.msg_update_err;
          }
        }else{
          Navigator.pop(context);
          var message = S.current.msg_num_existe;
          Helpers.showFlushBar(context, message);
          return Future.value(id);
        }

      } else {
        //add new piece
        Piece piece = await makePiece(isFromTransfer:isFromTransfer);
        if(piece != null){
          piece.etat = 0;
          id = await _queryCtr.addItemToTable(DbTablesNames.pieces, piece);
          if (id > -1) {
            piece.id = await _queryCtr.getLastId(DbTablesNames.pieces);
          }
          _selectedItems.forEach((article) async {
            Journaux journaux = Journaux.fromPiece(piece, article);
            await _queryCtr.addItemToTable(DbTablesNames.journaux, journaux);
          });

          if (_piece.piece != PieceType.devis &&
              _piece.piece != PieceType.retourClient &&
              _piece.piece != PieceType.avoirClient &&
              _piece.piece != PieceType.retourFournisseur &&
              _piece.piece != PieceType.avoirFournisseur) {
            await addTresorie(_piece, transferer: false);
          }

          if (id > -1) {
            widget.arguments = piece;
            widget.arguments.id = id;
            message = S.current.msg_ajout_item;
          } else {
            message = S.current.msg_ajout_err;
          }
        }else{
          Navigator.pop(context);
          var message = S.current.msg_num_existe;
          Helpers.showFlushBar(context, message);
          return Future.value(id);
        }

      }

      Navigator.pop(context);
      Helpers.showFlushBar(context, message);
      return Future.value(id);
    } catch (error) {
      Helpers.showFlushBar(context, S.current.msg_ereure);
      return Future.value(-1);
    }
  }

  Future<Object> makePiece({@required bool isFromTransfer}) async {
    var tiers = _selectedClient;
    var _old_num_piece = _piece.num_piece ;

    _piece.num_piece = _numeroControl.text;
    _piece.tier_id = tiers.id;
    _piece.raisonSociale = tiers.raisonSociale;
    _piece.tarification = _selectedTarification;

    _piece.total_ht = _total_ht;
    _piece.net_ht = _net_ht;
    _piece.total_tva = _total_tva;
    _piece.total_ttc = _total_ttc;
    _piece.timbre = _timbre;
    _piece.net_a_payer = _net_a_payer;
    _piece.remise = _pourcentremise;

    if (_piece.transformer == null) {
      _piece.transformer = 0;
    }

    if (_piece.id == null) {
      _piece.regler = _verssementpiece;
    } else {
      _piece.regler = _piece.regler + _verssementpiece;
    }
    _piece.reste = _piece.net_a_payer - _piece.regler;

    if (_piece.piece == PieceType.retourClient ||
        _piece.piece == PieceType.avoirClient ||
        _piece.piece == PieceType.retourFournisseur ||
        _piece.piece == PieceType.avoirFournisseur) {
      _piece.net_a_payer = _piece.net_a_payer * -1;
    }

    if(!modification){
      var res = await _queryCtr.getPieceByNum(_piece.num_piece, _piece.piece);
      if (res.length >= 1 && !isFromTransfer) {
        await getNumPiece(_piece);
        return null;
      }
    }else{
      if(_piece.num_piece != _old_num_piece){
        var res = await _queryCtr.getPieceByNum(_piece.num_piece, _piece.piece);
        if (res.length >= 1 && !isFromTransfer) {
          _piece.num_piece = _old_num_piece ;
          await getNumPiece(_piece);
          return null;
        }
      }
    }

    return _piece;
  }

  Future<void> addTresorie(item, {transferer}) async {
    Tresorie tresorie = new Tresorie.init();
    tresorie.montant = _verssementpiece;
    tresorie.compte = 1;
    tresorie.charge = null;
    if (transferer) {
      tresorie.montant = 0;
    }

    //special pour l'etat de la tresorie
    tresorie.mov = item.mov;

    tresorie.objet =
        "${S.current.reglement_piece} ${item.piece} ${item.num_piece}";
    tresorie.modalite = S.current.espece;
    tresorie.tierId = item.tier_id;
    tresorie.tierRS = item.raisonSociale;
    tresorie.pieceId = item.id;
    tresorie.date = new DateTime.now();
    if (item.piece == PieceType.bonLivraison ||
        item.piece == PieceType.factureClient ||
        item.piece == PieceType.commandeClient) {
      tresorie.categorie = 2;
    } else {
      if (item.piece == PieceType.bonReception ||
          item.piece == PieceType.factureFournisseur) {
        tresorie.categorie = 3;
      } else {
        if (item.piece == PieceType.retourClient ||
            item.piece == PieceType.avoirClient) {
          tresorie.categorie = 6;
          tresorie.montant = tresorie.montant * -1;
        } else {
          if (item.piece == PieceType.retourFournisseur ||
              item.piece == PieceType.avoirFournisseur) {
            tresorie.categorie = 7;
            tresorie.montant = tresorie.montant * -1;
          }
        }
      }
    }
    List<FormatPiece> list = await _queryCtr.getFormatPiece(PieceType.tresorie);
    tresorie.numTresorie = Helpers.generateNumPiece(list.first);

    await _queryCtr.addItemToTable(DbTablesNames.tresorie, tresorie);

    ReglementTresorie reglementTresorie = new ReglementTresorie.init();
    reglementTresorie.tresorie_id =
        await _queryCtr.getLastId(DbTablesNames.tresorie);
    reglementTresorie.piece_id =
        await _queryCtr.getLastId(DbTablesNames.pieces);
    reglementTresorie.regler = tresorie.montant;
    await _queryCtr.addItemToTable(
        DbTablesNames.reglementTresorie, reglementTresorie);
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
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                        ),
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
                              Helpers.showFlushBar(context, msg);
                            },
                            child: Text(
                              S.current.to_commande,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
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
                              Helpers.showFlushBar(context, msg);
                            },
                            child:(_piece.piece == PieceType.bonCommande)? Text(
                              S.current.bon_reception,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ):Text(
                              S.current.bon_livraison,
                              style:
                              TextStyle(color: Colors.white, fontSize: 16),
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
                              Helpers.showFlushBar(context, msg);
                            },
                            child: (_piece.piece == PieceType.devis ||
                                _piece.piece == PieceType.commandeClient ||
                                _piece.piece == PieceType.bonLivraison)? Text(
                              S.current.facture_vente,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ):Text(
                              S.current.facture_achat,
                              style:
                              TextStyle(color: Colors.white, fontSize: 16),
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
                              Helpers.showFlushBar(context, msg);
                            },
                            color: Colors.redAccent,
                            child: Text(
                                  _textBtnTransfereRetour(),
                                  style:
                                    TextStyle(color: Colors.white, fontSize: 16),
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

  String _textBtnTransfereRetour (){
    switch(_piece.piece){
      case (PieceType.bonLivraison):
        return S.current.retour_client ;
        break ;
      case (PieceType.factureClient):
        return S.current.avoir_client ;
        break ;
      case (PieceType.bonReception):
        return S.current.retour_fournisseur ;
        break ;
      case (PieceType.factureFournisseur):
        return S.current.avoir_fournisseur ;
        break ;
      default:
        return 'test' ;
        break ;
    }
  }

  Future<String> transfererPiece(context, String to) async {
    try {
      int id = -1;
      Piece _newPiece = new Piece.init();
      _newPiece.tier_id = _piece.tier_id;
      _newPiece.raisonSociale = _piece.raisonSociale;
      _newPiece.piece = typePieceTransformer(_piece.piece, to);

      _newPiece.mov = 1;
      _newPiece.transformer = 1;
      _newPiece.etat = 0;
      _newPiece.tarification = _piece.tarification;

      var res = await _queryCtr.getFormatPiece(_newPiece.piece);
      _newPiece.num_piece = Helpers.generateNumPiece(res.first);

      _newPiece.total_ttc = _piece.total_ttc;
      _newPiece.total_tva = _piece.total_tva;
      _newPiece.total_ht = _piece.total_ht;
      _newPiece.net_ht = _piece.net_ht;
      _newPiece.date = _piece.date;
      _newPiece.net_a_payer = _piece.net_a_payer;
      _newPiece.reste = _piece.reste;
      _newPiece.regler = _piece.regler;
      _newPiece.remise = _piece.remise;
      _newPiece.marge = _piece.marge;

      if (_newPiece.piece == PieceType.retourClient ||
          _newPiece.piece == PieceType.avoirClient ||
          _newPiece.piece == PieceType.retourFournisseur ||
          _newPiece.piece == PieceType.avoirFournisseur) {
        _newPiece.net_a_payer = _newPiece.net_a_payer * -1;
      }

      id = await _queryCtr.addItemToTable(DbTablesNames.pieces, _newPiece);
      if (id > -1) {
        _newPiece.id = await _queryCtr.getLastId(DbTablesNames.pieces);
      }
      _selectedItems.forEach((article) async {
        Journaux journaux = Journaux.fromPiece(_newPiece, article);
        await _queryCtr.addItemToTable(DbTablesNames.journaux, journaux);
      });

      int _oldMov = _piece.mov;

      //  add la transformation à la table transformer (oldPiece_id newPiece_id , oldMov)
      // update tresorie with triggers
      Transformer transformer = new Transformer.init();
      transformer.oldMov = _oldMov;
      transformer.newPieceId = _newPiece.id;
      transformer.oldPieceId = _piece.id;
      transformer.type_piece = _newPiece.piece;
      await _queryCtr.addItemToTable(DbTablesNames.transformer, transformer);

      // devis vers bl ou FC
      if (_oldMov == 0) {
        await addTresorie(_newPiece, transferer: true);
      }

      var message = S.current.msg_piece_transfere;

      setState(() {
        _piece.etat = 1;
      });


      if (_newPiece.piece == PieceType.retourClient ||
          _newPiece.piece == PieceType.avoirClient ||
          _newPiece.piece == PieceType.retourFournisseur ||
          _newPiece.piece == PieceType.avoirFournisseur) {

        await saveItem(1,isFromTransfer: true);

      } else {
        await saveItem(0 , isFromTransfer: true);
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
        return PieceType.avoirClient;
        break;
    }
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
              content: Text(result.msg),
            ),
          );
          dispose();
        }).catchError((error) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              content: Text(error.toString()),
            ),
          );
        });
      }
    } else {
      var message = S.current.msg_imp_err;
      Helpers.showFlushBar(context, message);
    }
  }

  Future<Ticket> _maketicket(formatPrint) async {
    final ticket = Ticket(formatPrint);

    if (directionRtl) {
      var input = "${_profile.raisonSociale}";
      Uint8List encArabic = await CharsetConverter.encode("ISO-8859-6",
          "${input.split('').reversed.join()}");
      ticket.textEncoded(encArabic,
          styles: PosStyles(
              codeTable: PosCodeTable.arabic,
              align: (formatPrint == PaperSize.mm80)
                  ? PosAlign.center
                  : PosAlign.left));
      if(_profile.activite != null){
        input = "${_profile.activite}";
        encArabic = await CharsetConverter.encode("ISO-8859-6",
            "${input.split('').reversed.join()}");
        ticket.textEncoded(encArabic,
            styles: PosStyles(
                codeTable: PosCodeTable.arabic,
                align: (formatPrint == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }
      if(_profile.adresse != null){
        input = "${_profile.adresse}";
        encArabic = await CharsetConverter.encode("ISO-8859-6",
            "${input.split('').reversed.join()}");
        ticket.textEncoded(encArabic,
            styles: PosStyles(
                codeTable: PosCodeTable.arabic,
                align: (formatPrint == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }
      if(_profile.ville != null){
        input = "${_profile.ville}";
        encArabic = await CharsetConverter.encode("ISO-8859-6",
            "${input.split('').reversed.join()}");
        ticket.textEncoded(encArabic,
            styles: PosStyles(
                codeTable: PosCodeTable.arabic,
                align: (formatPrint == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }
      if(_profile.telephone != null){
        input = "${_profile.telephone}";
        encArabic = await CharsetConverter.encode("ISO-8859-6",
            "${input.split('').reversed.join()}");
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

      input = "${S.current.rs}";
      encArabic = await CharsetConverter.encode("ISO-8859-6",
          "${_piece.raisonSociale}: ${input.split('').reversed.join()}");
      ticket.textEncoded(encArabic,
          styles: PosStyles(
              codeTable: PosCodeTable.arabic,
              align: (formatPrint == PaperSize.mm80)
                  ? PosAlign.center
                  : PosAlign.left));

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
          PosColumn(
              text:
                  '${Helpers.numberFormat(element.selectedQuantite).toString()}',
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
      if (_piece.total_tva > 0 && _myParams.tva) {
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

        input = "${S.current.total}";
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
      encArabic = await CharsetConverter.encode("ISO-8859-6",
          "${_devise} ${Helpers.numberFormat(_piece.net_a_payer).toString()}: ${input.split('').reversed.join()}");
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
        PosColumn(
            textEncoded: await CharsetConverter.encode("ISO-8859-6",
                "${Helpers.numberFormat(_piece.regler).toString()}: ${S.current.regler.split('').reversed.join()}"),
            width: 6),
        (_piece.reste > 0)
            ? PosColumn(
                textEncoded: await CharsetConverter.encode("ISO-8859-6",
                    "${Helpers.numberFormat(_piece.reste).toString()}: ${S.current.reste.split('').reversed.join()}"),
                width: 6)
            : PosColumn(width: 6),
      ]);
      if (_myParams.creditTier) {
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
      if(_profile.activite != null){
        ticket.text("${_profile.activite}",
            styles: PosStyles(
                align: (formatPrint == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }
      if(_profile.adresse != null){
        ticket.text("${_profile.adresse}",
            styles: PosStyles(
                align: (formatPrint == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }
      if(_profile.ville != null){
        ticket.text("${_profile.ville}",
            styles: PosStyles(
                align: (formatPrint == PaperSize.mm80)
                    ? PosAlign.center
                    : PosAlign.left));
      }
      if(_profile.telephone != null){
        ticket.text("${_profile.telephone}",
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
      ticket.text("${S.current.rs} : ${_piece.raisonSociale}",
          styles: PosStyles(
              align: (formatPrint == PaperSize.mm80)
                  ? PosAlign.center
                  : PosAlign.left));
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
          PosColumn(
              textEncoded: await CharsetConverter.encode("ISO-8859-6",
                  '${Helpers.numberFormat(element.selectedQuantite).toString()}'),
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
      if (_piece.total_tva > 0 && _myParams.tva) {
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
            "${S.current.total} : ${Helpers.numberFormat(_piece.total_ttc).toString()}");
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
      encode = await CharsetConverter.encode("ISO-8859-6",
          "${S.current.net_payer} : ${Helpers.numberFormat(_piece.net_a_payer).toString()} ${_devise}");
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
        PosColumn(
            textEncoded: await CharsetConverter.encode("ISO-8859-6",
                "${S.current.regler} : ${Helpers.numberFormat(_piece.regler).toString()}"),
            width: 6),
        (_piece.reste > 0)
            ? PosColumn(
                textEncoded: await CharsetConverter.encode("ISO-8859-6",
                    "${S.current.reste} : ${Helpers.numberFormat(_piece.reste).toString()}"),
                width: 6)
            : PosColumn(width: 6),
      ]);
      if (_myParams.creditTier) {
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
    final ttf = pw.Font.ttf(data);

    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        textDirection:
            (directionRtl) ? pw.TextDirection.rtl : pw.TextDirection.ltr,
        build: (context) => [
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    (_profile.raisonSociale != null)
                        ? pw.Text(
                        "${_profile.raisonSociale} ",
                        style: pw.TextStyle(font: ttf , fontWeight: pw.FontWeight.bold))
                        : pw.SizedBox(),
                    (_profile.activite != null)
                        ? pw.Text(
                        "${_profile.activite} ",
                        style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold))
                        : pw.SizedBox(),
                    (_profile.adresse != null)
                        ? pw.Text(
                        "${_profile.adresse} ${_profile.departement} ${_profile.ville} ${_profile.pays}",
                        style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold))
                        : pw.SizedBox(),
                    (_profile.telephone != null)
                        ? pw.Text(
                        "${S.current.telephone}\t ${_profile.telephone}",
                        style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold))
                        : pw.SizedBox(),
                    (_profile.fax != null)
                        ? pw.Text(
                        "${S.current.fax}\t ${_profile.fax}",
                        style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold))
                        : pw.SizedBox(),
                    (_profile.mobile != null)
                        ? pw.Text(
                        "${S.current.mobile}\t ${_profile.mobile}",
                        style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold))
                        : pw.SizedBox(),
                    (_profile.email != null)
                        ? pw.Text(
                        "${S.current.mail}\t ${_profile.email}",
                        style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold))
                        : pw.SizedBox(),
                    (_profile.rc != null)
                        ? pw.Text(
                        "${S.current.rc}\t ${_profile.rc}",
                        style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold))
                        : pw.SizedBox(),
                    (_profile.nif != null)
                        ? pw.Text(
                        "${S.current.rc}\t ${_profile.nif}",
                        style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold))
                        : pw.SizedBox(),
                    (_profile.capital != null)
                        ? pw.Text(
                        "${S.current.capitale_sociale}\t ${_profile.capital}",
                        style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold))
                        : pw.SizedBox(),
                  ]
                ),
                (_profile.imageUint8List != null)
                    ? pw.Image(pw.MemoryImage(_profile.imageUint8List),height: 100 , width: 100)
                    : pw.SizedBox(),
              ]),
          pw.SizedBox(height: 20),
          pw.Row(children: [
            pw.Expanded(
                flex: 6,
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                          "${S.current.rs}\t ${_selectedClient.raisonSociale} ",
                          style: pw.TextStyle(font: ttf)),
                      pw.Divider(height: 2),
                      pw.Text(
                          "${S.current.adresse}\t  ${_selectedClient.adresse} ",
                          style: pw.TextStyle(font: ttf)),
                      pw.Text("${S.current.ville}\t  ${_selectedClient.ville}",
                          style: pw.TextStyle(font: ttf)),
                    ])),
            pw.SizedBox(width: 3),
            pw.Expanded(
                flex: 6,
                child: pw.Column(children: [
                  pw.Text("|||||||||||||||||||||||||||||||"),
                  pw.Text("${Helpers.getPieceTitle(_piece.piece)}",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, font: ttf)),
                  pw.Text("${S.current.n}\t  ${_piece.num_piece}",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, font: ttf)),
                  pw.Text(
                      "${S.current.date}\t  ${Helpers.dateToText(_piece.date)}",
                      style: pw.TextStyle(font: ttf)),
                ]))
          ]),
          pw.SizedBox(height: 20),
          pw.Table(children: [
            pw.TableRow(
                decoration: pw.BoxDecoration(
                    border: pw.Border(bottom: pw.BorderSide(width: 2))),
                children: [
                  pw.Container(
                    padding: pw.EdgeInsets.only(left: 5, right: 5),
                    child: pw.Text("${S.current.referance}",
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            font: ttf,
                            fontSize: 10)),
                  ),
                  pw.Container(
                    padding: pw.EdgeInsets.only(left: 5, right: 5),
                    child: pw.Text("${S.current.designation}",
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            font: ttf,
                            fontSize: 10)),
                  ),
                  pw.Container(
                    padding: pw.EdgeInsets.only(left: 5, right: 5),
                    child: pw.Text("${S.current.qte}",
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            font: ttf,
                            fontSize: 10)),
                  ),
                  pw.Container(
                    padding: pw.EdgeInsets.only(left: 5, right: 5),
                    child: pw.Text("${S.current.prix}",
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            font: ttf,
                            fontSize: 10)),
                  ),
                  pw.Container(
                      padding: pw.EdgeInsets.only(left: 5, right: 5),
                      child: pw.Text("${S.current.montant}",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              font: ttf,
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
                      child: pw.Text("${e.ref}",
                          style: pw.TextStyle(font: ttf, fontSize: 9)),
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.only(left: 5, right: 5),
                      child: pw.Text("${e.designation}",
                          style: pw.TextStyle(font: ttf, fontSize: 9)),
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.only(left: 5, right: 5),
                      child: pw.Text(
                          "${Helpers.numberFormat(e.selectedQuantite)}",
                          style: pw.TextStyle(fontSize: 9)),
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.only(left: 5, right: 5),
                      child: pw.Text("${Helpers.numberFormat(e.selectedPrice)}",
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
          pw.SizedBox(height: 10),
          pw.Divider(height: 2),
          pw.SizedBox(height: 10),
          pw.Row(children: [
            pw.Expanded(
                flex: 6,
                child: pw.Column(children: [
                  pw.Text(
                      "${S.current.regler}\t ${Helpers.numberFormat(_piece.regler)} ${_devise}",
                      style: pw.TextStyle(font: ttf)),
                  (_piece.reste > 0)
                      ? pw.Text(
                          "${S.current.reste}\t ${Helpers.numberFormat(_piece.reste)} ${_devise}",
                          style: pw.TextStyle(font: ttf))
                      : pw.SizedBox(),
                  (_myParams.creditTier)
                      ? pw.Text(
                          "${S.current.credit}\t ${Helpers.numberFormat(_selectedClient.credit)} ${_devise}",
                          style: pw.TextStyle(font: ttf))
                      : pw.SizedBox(),
                  pw.Divider(height: 2),
                  pw.Text(getPieceSuminLetters(),
                      style: pw.TextStyle(font: ttf , fontWeight: pw.FontWeight.bold)),

                ])),
            pw.SizedBox(width: 10),
            pw.Expanded(
                flex: 6,
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      (_piece.total_tva > 0 && _myParams.tva)
                          ? pw.Text(
                              "${S.current.total_ht}\t  ${Helpers.numberFormat(_piece.total_ht)}\t ${_devise}",
                              style: pw.TextStyle(font: ttf))
                          : pw.SizedBox(),
                      (_piece.remise > 0)
                          ? pw.Text(
                              "${S.current.remise}\t  ${((_piece.total_ht * _piece.remise) / 100).toStringAsFixed(2)}  (${_piece.remise}\t  %)\t ${_devise}",
                              style: pw.TextStyle(font: ttf))
                          : pw.SizedBox(),
                      (_piece.remise > 0)
                          ? pw.Text(
                              "${S.current.net_ht}\t  ${Helpers.numberFormat(_piece.net_ht)}\t  ${_devise}",
                              style: pw.TextStyle(font: ttf))
                          : pw.SizedBox(),
                      (_piece.total_tva > 0 && _myParams.tva)
                          ? pw.Text(
                              "${S.current.total_tva}\t  ${Helpers.numberFormat(_piece.total_tva)}\t  ${_devise}",
                              style: pw.TextStyle(font: ttf))
                          : pw.SizedBox(),
                      (_piece.total_tva > 0 && _myParams.tva)
                          ? pw.Text(
                              "${S.current.total}\t  ${Helpers.numberFormat(_piece.total_ttc)}\t  ${_devise}",
                              style: pw.TextStyle(font: ttf))
                          : pw.SizedBox(),
                      pw.Divider(height: 2),
                      (_myParams.timbre)
                          ? pw.Text(
                              "${S.current.timbre}\t  ${(_piece.total_ttc < _piece.net_a_payer) ? Helpers.numberFormat(_piece.timbre) : Helpers.numberFormat(0.0)}\t  ${_devise}",
                              style: pw.TextStyle(font: ttf))
                          : pw.SizedBox(),
                      pw.Text(
                          "${S.current.net_payer}\t  ${Helpers.numberFormat(_piece.net_a_payer)}\t  ${_devise}",
                          style: pw.TextStyle(font: ttf)),
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

  String getPieceSuminLetters(){
    String res = '' ;
    res = res + "${Helpers.numberToWords((_piece.net_a_payer.toInt()).toString())} ${Helpers.currencyName(_myParams.devise)} " ;

    int a = (_piece.net_a_payer % 1 * 100).roundToDouble().toInt();
    if(a > 0){
      res= res + "${Helpers.numberToWords(a.toString())} ${S.current.centime}" ;
    }

    return res ;
  }
}
