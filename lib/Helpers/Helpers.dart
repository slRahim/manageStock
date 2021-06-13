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
import 'package:gestmob/Helpers/curency/countries.dart';
import 'package:gestmob/Helpers/curency/country.dart';
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
import 'package:google_fonts/google_fonts.dart';

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
    var bytes;
    switch (from) {
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
    Uint8List image =
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
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
      if (await imageExist.exists()) {
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
      if (await imageExist.exists()) {
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
  static Future<Uint8List> getUint8ListFromFile(File file) async {
    final filePath = file.absolute.path;
    final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    final compressedImage = await FlutterImageCompress.compressAndGetFile(
        filePath, outPath,
        minWidth: 600, minHeight: 600, quality: 95);

    return compressedImage.readAsBytesSync();
  }

  //Uint8List to base64
  static getEncodedByteStringFromUint8List(Uint8List image) {
    return base64Encode(image);
  }

  // file to byteString (complete)
  static getEncodedByteStringFromFile(File file) async {
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
        Navigator.of(context)
            .pushNamed(
              RoutesKeys.settingsPage,
            )
            .then((value) => Phoenix.rebirth(context));
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
      messageText: Text(message , style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.white)),),
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

  static String dateToText(DateTime dateTime) {
    var month = dateTime.month.toString().padLeft(2, '0');
    var day = dateTime.day.toString().padLeft(2, '0');
    var hour = dateTime.hour.toString().padLeft(2, '0') ;
    var minute = dateTime.minute.toString().padLeft(2, '0') ;

    var dateText = '${dateTime.year}-$month-$day $hour:$minute';
    return dateText;
  }

  static void quitApp() {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  static String generateNumPiece(FormatPiece formatPiece) {
    switch (formatPiece.format) {
      case NumPieceFormat.format1:
        String year = formatPiece.year;
        int index = formatPiece.currentindex + 1;
        return "$index/$year";
        break;

      case NumPieceFormat.format2:
        var now = new DateTime.now();
        String year = formatPiece.year ;
        String month = now.month.toString();
        int index = formatPiece.currentindex + 1;
        return "$index/$month/$year";
        break;

      default:
        String year =formatPiece.year;
        int index = formatPiece.currentindex + 1;
        return "$index/$year";
        break;
    }
  }

  static String getPieceTitle(String piece) {
    switch (piece) {
      case PieceType.devis:
        return S.current.devis;
        break;
      case PieceType.avoirClient:
        return S.current.avoir_client;
        break;
      case PieceType.avoirFournisseur:
        return S.current.avoir_fournisseur;
        break;
      case PieceType.bonCommande:
        return S.current.bon_commande;
        break;
      case PieceType.bonLivraison:
        return S.current.bon_livraison;
        break;
      case PieceType.bonReception:
        return S.current.bon_reception;
        break;
      case PieceType.commandeClient:
        return S.current.commande_client;
        break;
      case PieceType.factureClient:
        return S.current.facture_vente;
        break;
      case PieceType.factureFournisseur:
        return S.current.facture_achat;
        break;
      case PieceType.retourClient:
        return S.current.retour_client;
        break;
      case PieceType.retourFournisseur:
        return S.current.retour_fournisseur;
        break;
    }
  }

  static bool isDirectionRTL(context) {
    if (Localizations.localeOf(context).languageCode == "ar") {
      return true;
    }
    return false;
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

  static double calcTimber(ttc, myparams) {
    return (ttc >= 1000000) ? 2500 : ttc * 0.01;
  }

  static DateTime getDateExpiration(MyParams myParam) {
    switch (myParam.codeAbonnement) {
      case ('mensuel'):
        return myParam.startDate.add(Duration(days: 30));
        break;
      case ('annuel'):
        return myParam.startDate.add(Duration(days: 365));
        break;
      case ('illimit'):
        return DateTime(2100, 1, 1);
        break;
    }
  }

  static String numberToWords(String pnumber) {
    int number = int.parse(pnumber);
// 0 to 999 999 999 999
    if (number == 0) {
      return "zero";
    }
// pad with "0"
    String mask = "000000000000";
    final df = new NumberFormat(mask);
    String snumber = df.format(number);
// XXXnnnnnnnnn
    int billions = int.parse(snumber.substring(0, 3));
// nnnXXXnnnnnn
    int millions = int.parse(snumber.substring(3, 6));
// nnnnnnXXXnnn
    int thousands = int.parse(snumber.substring(6, 9));
// nnnnnnnnnXXX
    int handreds = int.parse(snumber.substring(9, 12));

    String locale = Intl.getCurrentLocale();
    switch (locale) {
      case "en":
        String tradBillions;
        switch (billions) {
          case 0:
            tradBillions = "";
            break;
          case 1:
            tradBillions = _convertLessThanOneThousand(billions) + " billion ";
            break;
          default:
            tradBillions = _convertLessThanOneThousand(billions) + " billion ";
        }
        String result = tradBillions;

        String tradMillions;
        switch (millions) {
          case 0:
            tradMillions = "";
            break;
          case 1:
            tradMillions = _convertLessThanOneThousand(millions) + " million ";
            break;
          default:
            tradMillions = _convertLessThanOneThousand(millions) + " million ";
        }
        result = result + tradMillions;

        String tradThousands;
        switch (thousands) {
          case 0:
            tradThousands = "";
            break;
          case 1:
            tradThousands = "one thousand ";
            break;
          default:
            tradThousands =
                _convertLessThanOneThousand(thousands) + " thousand ";
        }
        result = result + tradThousands;

        String tradhandreds;
        tradhandreds = _convertLessThanOneThousand(handreds);
        result = result + tradhandreds;
        return result;
        break;

      case "fr":
        String tradBillions;

        switch (billions) {
          case 0:
            tradBillions = "";
            break;
          case 1:
            tradBillions = _convertLessThanOneThousand(billions) + " milliard";
            break;
          default:
            if(millions > 0 || thousands > 0 || handreds > 0){
              tradBillions = _convertLessThanOneThousand(billions) + " milliard";
            }else{
              tradBillions = _convertLessThanOneThousand(billions) + " milliards";
            }
            break ;
        }
        String result = tradBillions;

        String tradMillions;

        switch (millions) {
          case 0:
            tradMillions = "";
            break;
          case 1:
            tradMillions = _convertLessThanOneThousand(millions) + " million";
            break;
          default:
            if(thousands > 0 || handreds > 0){
              tradMillions = _convertLessThanOneThousand(millions) + " million";
            }else{
              tradMillions = _convertLessThanOneThousand(millions) + " millions";
            }

        }
        result = result + tradMillions;

        String tradThousands;
        switch (thousands) {
          case 0:
            tradThousands = "";
            break;
          case 1:
            tradThousands = "mille";
            break;
          default:
            if(handreds > 0){
              tradThousands = _convertLessThanOneThousand(thousands) + " mille";
            }else{
              tradThousands = _convertLessThanOneThousand(thousands) + " milles";
            }
        }
        result = result + tradThousands;

        String tradhandreds;
        tradhandreds = _convertLessThanOneThousand(handreds);
        result = result + tradhandreds;
        return result;
        break;

      case "ar":
        String tradBillions;

        switch (billions) {
          case 0:
            tradBillions = "";
            break;
          case 1:
            tradBillions = " مليار ";
            break;
          case 2:
            tradBillions = " ملياران ";
            break;
          default:
            if (billions < 11) {
              tradBillions =
                  _convertLessThanOneThousand(billions) + " مليارات ";
            } else {
              tradBillions = _convertLessThanOneThousand(billions) + " مليار ";
            }
            break;
        }

        String result = tradBillions;

        String tradMillions;

        switch (millions) {
          case 0:
            tradMillions = "";
            break;
          case 1:
            tradMillions = " مليون ";
            break;
          case 2:
            tradMillions = " مليونين ";
            break;
          default:
            if (millions < 11) {
              tradMillions = _convertLessThanOneThousand(millions) + " ملايين ";
            } else {
              tradMillions = _convertLessThanOneThousand(millions) + " مليون ";
            }
            break;
        }
        if (tradMillions.trim().length != 0) {
          if (result.trim().length == 0) {
            result = result + ' ' + tradMillions;
          } else {
            result = result + ' و ' + tradMillions;
          }
        }
        String tradThousands;
        switch (thousands) {
          case 0:
            tradThousands = "";
            break;
          case 1:
            tradThousands = "ألف";
            break;
          case 2:
            tradThousands = "ألفان";
            break;
          default:
            if (thousands < 11) {
              tradThousands = _convertLessThanOneThousand(thousands) + "الآف";
            } else {
              tradThousands = _convertLessThanOneThousand(thousands) + " ألف ";
            }
            break;
        }
        if (tradThousands.trim().length != 0) {
          if (result.trim().length == 0) {
            result = result + ' ' + tradThousands;
          } else {
            result = result + ' و ' + tradThousands;
          }
        }
        String tradhandreds;
        tradhandreds = _convertLessThanOneThousand(handreds);
        if (tradhandreds.trim().length != 0) {
          if (result.trim().length == 0) {
            result = result + ' ' + tradhandreds;
          } else {
            result = result + ' و ' + tradhandreds;
          }
        }

        return result.replaceAll("  ", " ");
        break;

      default:
        String tradBillions;
        switch (billions) {
          case 0:
            tradBillions = "";
            break;
          case 1:
            tradBillions = _convertLessThanOneThousand(billions) + " billion ";
            break;
          default:
            tradBillions = _convertLessThanOneThousand(billions) + " billion ";
        }
        String result = tradBillions;

        String tradMillions;
        switch (millions) {
          case 0:
            tradMillions = "";
            break;
          case 1:
            tradMillions = _convertLessThanOneThousand(millions) + " million ";
            break;
          default:
            tradMillions = _convertLessThanOneThousand(millions) + " million ";
        }
        result = result + tradMillions;

        String tradThousands;
        switch (thousands) {
          case 0:
            tradThousands = "";
            break;
          case 1:
            tradThousands = "one thousand ";
            break;
          default:
            tradThousands =
                _convertLessThanOneThousand(thousands) + " thousand ";
        }
        result = result + tradThousands;

        String tradhandreds;
        tradhandreds = _convertLessThanOneThousand(handreds);
        result = result + tradhandreds;
        return result;
        break;
    }
  }

  static String _convertLessThanOneThousand(int number) {
    String locale = Intl.getCurrentLocale();
    switch (locale) {
      case 'en':
        List<String> tensNames = [
          "",
          " ten",
          " twenty",
          " thirty",
          " forty",
          " fifty",
          " sixty",
          " seventy",
          " eighty",
          " ninety"
        ];

        List<String> numNames = [
          "",
          " one",
          " two",
          " three",
          " four",
          " five",
          " six",
          " seven",
          " eight",
          " nine",
          " ten",
          " eleven",
          " twelve",
          " thirteen",
          " fourteen",
          " fifteen",
          " sixteen",
          " seventeen",
          " eighteen",
          " nineteen"
        ];
        String soFar;
        if (number % 100 < 20) {
          soFar = numNames[number % 100];
          number = number ~/ 100;
        } else {
          soFar = numNames[number % 10];
          number = number ~/ 10;
          soFar = tensNames[number % 10] + soFar;
          number = number ~/ 10;
        }
        if (number == 0) return soFar;
        return numNames[number] + " hundred" + soFar;
        break;
      case 'fr':
        List<String> tensNames = [
          "",
          " dix",
          " vingt",
          " trente",
          " quarante",
          " cinquante",
          " soixante",
          "", // soixante-dix
          " quatre-vingts",
          "" //quatre-vingts-dix
        ];

        List<String> numNames = [
          "",
          " un",
          " deux",
          " Trois",
          " quatre",
          " cinq",
          " six",
          " Sept",
          " huit",
          " neuf",
          " dix",
          " onze",
          " douze",
          " treize",
          " quatorze",
          " quinze",
          " seize",
          " dix-sept",
          " dix-huit",
          " dix-neuf"
        ];
        String soFar;
        if (number % 100 < 20) {
          soFar = numNames[number % 100];
          number = number ~/ 100;
        } else {
          int tensval;
          tensval = (number ~/ 10) % 10;
          if (tensval != 7 && tensval != 9) {
            if (number % 10 == 1) {
              soFar = ' et' + numNames[number % 10];
            } else {
              soFar = numNames[number % 10];
            }
            number = number ~/ 10;
            soFar = tensNames[number % 10] + soFar;
            number = number ~/ 10;
          }
          if (tensval == 7 || tensval == 9) {
            if ((number % 10) + 10 == 11) {
              soFar = ' et' + numNames[(number % 10) + 10];
            } else {
              soFar = numNames[(number % 10) + 10];
            }
            number = number ~/ 10;
            soFar = tensNames[(number % 10) - 1] + soFar;
            number = number ~/ 10;
          }
        }
        if (number == 0) return soFar;
        return number > 1
            ? ("${numNames[number]} cents$soFar")
            : (" cent$soFar");
        break;
      case 'ar':
        List<String> tensNames = [
          "",
          "عشرة ",
          "عشرين ",
          "ثلاثون ",
          " أربعين ",
          "خمسون ",
          "ستون ",
          "سبعون ",
          "ثمانون ",
          "تسعون "
        ];

        List<String> numNames = [
          "",
          "واحد ",
          "اثنان ",
          "ثلاثة ",
          "أربعة ",
          "خمسة ",
          "ستة ",
          " سبعة ",
          "ثمانية ",
          " تسعة ",
          "عشرة ",
          " أحد عشر ",
          " اثني عشر ",
          " ثلاثة عشر ",
          " أربعة عشر ",
          " خمسة عشر ",
          " السادس عشر ",
          " سبعة عشر ",
          " الثامنة عشر ",
          " تسعة عشر "
        ];
        List<String> numNamesforcent = [
          "",
          "واحد ",
          "اثنان ",
          "ثلاث ",
          "أربع ",
          "خمس ",
          "ست ",
          " سبع ",
          "ثماني ",
          " تسع ",
        ];
        String soFar;
        if (number % 100 < 20) {
          soFar = numNames[number % 100];
          number = number ~/ 100;
        } else {
          soFar = numNames[number % 10];
          number = number ~/ 10;
          if (soFar.trim().length == 0) {
            soFar = tensNames[number % 10];
          } else {
            soFar = soFar + 'و ' + tensNames[number % 10];
          }

          number = number ~/ 10;
        }
        if (number == 0) return soFar;
        if (number == 1) {
          if(soFar.trim().length == 0){
            return " مائة " ;
          }
          return " مائة " + ' و ' + soFar;
        } else if (number == 2) {
          if(soFar.trim().length == 0){
            return " مائتان " ;
          }
          return " مائتان " + ' و ' + soFar;
        } else if (number < 11) {
          if (soFar.trim().length == 0) {
            return numNamesforcent[number] + " مائة ";
          } else {
            return numNamesforcent[number] + " مائة " + ' و ' + soFar;
          }
        } else {
          if (soFar.trim().length == 0) {
            return numNamesforcent[number] + " مائة ";
          } else {
            return numNamesforcent[number] + " مائة " + ' و ' + soFar;
          }
        }
        break;
      default:
        List<String> tensNames = [
          "",
          " ten",
          " twenty",
          " thirty",
          " forty",
          " fifty",
          " sixty",
          " seventy",
          " eighty",
          " ninety"
        ];

        List<String> numNames = [
          "",
          " one",
          " two",
          " three",
          " four",
          " five",
          " six",
          " seven",
          " eight",
          " nine",
          " ten",
          " eleven",
          " twelve",
          " thirteen",
          " fourteen",
          " fifteen",
          " sixteen",
          " seventeen",
          " eighteen",
          " nineteen"
        ];
        String soFar;
        if (number % 100 < 20) {
          soFar = numNames[number % 100];
          number = number ~/ 100;
        } else {
          soFar = numNames[number % 10];
          number = number ~/ 10;
          soFar = tensNames[number % 10] + soFar;
          number = number ~/ 10;
        }
        if (number == 0) return soFar;
        return numNames[number] + " hundred" + soFar;
        break;
    }
  }
  
  static String currencyName(String currencyCode){
    Country res = countryList.where((element) => element.currencyCode == currencyCode).first ;

    return res.currencyName ;
  }
}
