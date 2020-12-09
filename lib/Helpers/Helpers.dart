import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gestmob/cubit/home_cubit.dart';
import 'package:gestmob/models/Article.dart';
import 'package:gestmob/models/FormatPiece.dart';
import 'package:gestmob/models/HomeItem.dart';
import 'package:gestmob/models/Piece.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'Statics.dart';

class Helpers {

  static Widget buildLoading() {
    return Center(child: CircularProgressIndicator());
  }

  static void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1);
  }

  static Future<File> getFileFromByteString(String byteString) async {
    Uint8List tempImg = Base64Decoder().convert(byteString);
    File file;
    if (tempImg != null) {
      final tempDir = await getTemporaryDirectory();
      // int time = DateTime.now().millisecondsSinceEpoch;
      String fileName = "temp_image.png";
      file = await new File('${tempDir.path}/$fileName').create();
      file.writeAsBytesSync(tempImg);
    }
    return file;
  }

  static Future<File> getFileFromUint8List(Uint8List uint8list) async {
    File file;
    if (uint8list != null) {
      final tempDir = await getTemporaryDirectory();
      // int time = DateTime.now().millisecondsSinceEpoch;
      String fileName = "temp_image.png";

      File imageExist = new File('${tempDir.path}/$fileName');
      if(await imageExist.exists()) {
        imageExist.delete();
        imageCache.clear();
      }

      file = await new File('${tempDir.path}/$fileName').create();
      file.writeAsBytesSync(uint8list);
    }
    return file;
  }

  static Uint8List getUint8ListFromByteString(String byteString) {
    return Base64Decoder().convert(byteString);
  }

  static getEncodedByteStringFromFile(File file) {
    Uint8List imageBytes = getUint8ListFromFile(file);
    return base64Encode(imageBytes);
  }

  static Uint8List getUint8ListFromFile(File file) {
    return file.readAsBytesSync();
  }

  static handleIdClick(context, id) {
    switch (id) {
      case drawerItemExitId:
        exit(0);
        break;

      case homeItemParametresId:
        Navigator.of(context).pushNamed(
          RoutesKeys.settingsPage,
        );
        break;

      case drawerItemHelpId:
        Navigator.of(context).pushNamed(
          RoutesKeys.helpPage,
        );
        break;

      default:
        BlocProvider.of<HomeCubit>(context).getHomeData(id);
        break;
    }
  }

  static void showFlushBar(BuildContext context, String message) {
    // showToast(message);
    Flushbar(
      isDismissible: false,
      message: message,
      icon: Icon(
        Icons.info_outline,
        size: 28.0,
        color: Colors.blue[300],
      ),
      duration: Duration(seconds: 5),
      leftBarIndicatorColor: Colors.blue[300],
      margin: EdgeInsets.all(0),
      borderRadius: 8,
    )..show(context);
  }

  static Future<Uint8List> getDefaultImageUint8List() async {
    var bytes = await rootBundle.load('assets/article.png');
    Uint8List image = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    return image;
  }

  static openMapsSheet(context, final Coords coords) async {
    try {
      final title = "Ocean Beach";
      final availableMaps = await MapLauncher.installedMaps;

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    for (var map in availableMaps)
                      ListTile(
                        onTap: () => map.showMarker(
                          coords: coords,
                          title: title,
                        ),
                        title: Text(map.mapName),
                        leading: Image(
                          image: map.icon,
                          height: 30.0,
                          width: 30.0,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  static String dateToText(DateTime dateTime){
    var month = dateTime.month.toString().padLeft(2, '0');
    var day = dateTime.day.toString().padLeft(2, '0');
    var dateText = '${dateTime.year}-$month-$day ${dateTime.hour}:${dateTime.minute}';
    return dateText;
  }

  static void quitApp() {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  static String generateNumPiece(FormatPiece piece){
    switch (piece.format) {
      case NumPieceFormat.format1:
        var now = new DateTime.now();
        String year = now.year.toString();
         int index = piece.currentindex+1 ;
        return "$index/$year" ;
        break;

      case NumPieceFormat.format2:
        var now = new DateTime.now();
        String year = now.year.toString();
        String month= now.month.toString();
        int index = piece.currentindex+1 ;
        return "$index/$month/$year" ;
        break;

      default:
        var now = new DateTime.now();
        String year = now.year.toString();
        int index = piece.currentindex+1;
        return "$index/$year" ;
        break;
    }
  }

  static String getPieceTitle(String piece){
    switch (piece){
      case PieceType.devis :
        return "Devis";
        break;
      case PieceType.avoirClient :
        return "Avoir Client";
        break;
      case PieceType.avoirFournisseur :
        return "Avoir Fournisseur";
        break;
      case PieceType.bonCommande :
        return "Bon de Commande";
        break;
      case PieceType.bonLivraison :
        return "Bon de Livraison";
        break;
      case PieceType.bonReception :
        return "Bon de Reception";
        break;
      case PieceType.commandeClient :
        return "Commande Client";
        break;
      case PieceType.factureClient :
        return "Facture de Vente";
        break;
      case PieceType.factureFournisseur :
        return "Facture d'Achat";
        break;
      case PieceType.retourClient :
        return "Retour Client";
        break;
      case PieceType.retourFournisseur :
        return "Retour Fournisseur";
        break;
    }
  }

}
