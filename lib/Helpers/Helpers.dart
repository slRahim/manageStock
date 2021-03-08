import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gestmob/Helpers/route_generator.dart';
import 'package:gestmob/cubit/home_cubit.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/Article.dart';
import 'package:gestmob/models/FormatPiece.dart';
import 'package:gestmob/models/HomeItem.dart';
import 'package:gestmob/models/Piece.dart';
import 'package:gestmob/ui/home.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'Statics.dart';
import 'package:intl/intl.dart' as intl;
import 'package:archive/archive.dart';
import 'package:gestmob/models/MyParams.dart';



class Helpers {

  static Widget buildLoading() {
    return Center(child: CircularProgressIndicator());
  }

  static void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1);
  }

  static Future<Uint8List> getDefaultImageUint8List({String from}) async {
    var bytes ;
    switch(from){
      case "article":
        bytes = await rootBundle.load('assets/article.png');
        break;
      case "tier":
        bytes = await rootBundle.load('assets/client.png');
        break;
      case "profile":
        bytes = await rootBundle.load('assets/festival.png');
        break;
    }
    Uint8List image = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    return image;
  }


  //*************************************************************************to read from db**************************************************************************************
  // base64 to Uint8List
  static Uint8List getUint8ListFromByteString(String byteString) {
    return Base64Decoder().convert(byteString);
  }

  //Uint8List to file
  static Future<File> getFileFromUint8List(Uint8List uint8list) async {
    File file;
    if (uint8list != null) {
      final tempDir = await getTemporaryDirectory();
      String fileName = "temp_image.jpg";

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

  //file from base64 to file  (base64 -> file complete)
  static Future<File> getFileFromByteString(String byteString) async {
    Uint8List tempImg = getUint8ListFromByteString(byteString);
    File file;
    if (tempImg != null) {
      final tempDir = await getTemporaryDirectory();
      String fileName = "temp_image.jpg";

      File imageExist = new File('${tempDir.path}/$fileName');
      if(await imageExist.exists()) {
        imageExist.delete();
        imageCache.clear();
      }

      file = await new File('${tempDir.path}/$fileName').create();
      file.writeAsBytesSync(tempImg);
    }
    return file;
  }
  //*************************************************************************fin/to read from db/***********************************************************************************

  //********************************************************************to save image into db***************************************************************************************
  // file to Uint8List
  static Future<Uint8List> getUint8ListFromFile(File file)async{
    final filePath = file.absolute.path;
    final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    final compressedImage = await FlutterImageCompress.compressAndGetFile(
        filePath,
        outPath,
        minWidth: 600,
        minHeight: 600,
        quality: 95);

    return compressedImage.readAsBytesSync();
  }

  //Uint8List to base64
  static getEncodedByteStringFromUint8List(Uint8List image) {
    return base64Encode(image);
  }

  // file to byteString (complete)
  static getEncodedByteStringFromFile(File file) async{
    Uint8List imageBytes = await getUint8ListFromFile(file);
    return getEncodedByteStringFromUint8List(imageBytes);
  }
  //********************************************************************fin/to save image into db/***************************************************************************************

  static handleIdClick(context, id) {
    switch (id) {
      case drawerItemExitId:
        exit(0);
        break;
      case homeItemParametresId:
        Navigator.of(context).pushNamed(
          RoutesKeys.settingsPage,
        ).then((value) => Phoenix.rebirth(context));
        break;
      case drawerItemAchatId:
        break;
      case drawerItemVenteId:
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
        return S.current.devis;
        break;
      case PieceType.avoirClient :
        return  S.current.avoir_client;
        break;
      case PieceType.avoirFournisseur :
        return  S.current.avoir_fournisseur;
        break;
      case PieceType.bonCommande :
        return  S.current.bon_commande;
        break;
      case PieceType.bonLivraison :
        return S.current.bon_livraison;
        break;
      case PieceType.bonReception :
        return S.current.bon_reception;
        break;
      case PieceType.commandeClient :
        return S.current.commande_client;
        break;
      case PieceType.factureClient :
        return S.current.facture_vente;
        break;
      case PieceType.factureFournisseur :
        return S.current.facture_achat;
        break;
      case PieceType.retourClient :
        return  S.current.retour_client;
        break;
      case PieceType.retourFournisseur :
        return  S.current.retour_fournisseur;
        break;
    }
  }

  static bool isDirectionRTL(context){
    if( Localizations.localeOf(context).languageCode == "ar"){
      return true ;
    }
    return false ;

  }

//  *********************************************************************************************************************************************************************
//**************************************************************************number format****************************************************************************************
 static dynamic numberFormat(dynamic number) {
   var f = new NumberFormat("#,##0.00");
   return f.format(number);

 }

  static String getDeviseTranslate(devise) {
    switch (devise) {
      case "DZD":
        return S.current.da;
        break;
      case "EUR":
        return "€";
        break;
      case "USD":
        return '\$';
        break;
      case "GBP":
        return '£';
        break;
      default:
        return devise;
        break;
    }
  }
 
 static double calcTimber (ttc , myparams){
    return (ttc >= 1000000) ? 2500 : ttc * 0.01 ;
 }

 static DateTime getDateExpiration(MyParams myParam){
    switch (myParam.codeAbonnement) {
      case ('mensuel'):
        return myParam.startDate.add(Duration(days: 30));
        break;
      case('annuel'):
        return myParam.startDate.add(Duration(days: 180));
        break;
      case('illimit'):
        return DateTime(2100, 1, 1);
        break;
    }
 }


}
