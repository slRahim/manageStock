import 'dart:io' show Platform;

import 'package:app_settings/app_settings.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/DefaultPrinter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Print extends StatefulWidget {
  final Ticket data;

  Print(this.data);

  @override
  _PrintState createState() => _PrintState();
}

class _PrintState extends State<Print> {
  PrinterBluetoothManager _printerManager = PrinterBluetoothManager();
  List<dynamic> _devices = [];
  String _devicesMsg;
  BluetoothManager bluetoothManager = BluetoothManager.instance;

  QueryCtr _queryCtr = new QueryCtr();
  DefaultPrinter defaultPrinter = new DefaultPrinter.init();

  ScrollController _controller = new ScrollController();
  SharedPreferences _prefs;


  @override
  void initState() {
    if (Platform.isIOS) {
      initBlPrinter();
    } else {
      bluetoothManager.state.listen((val) {
        print("state = $val");
        if (!mounted) return;
        if (val == 12) {
          initBlPrinter();
        } else if (val == 10) {
          setState(() {
            _devicesMsg = S.current.blue_off;
          });
        }
      });
    }
    super.initState();
  }

  void initBlPrinter() {
    _printerManager.startScan(Duration(seconds: 10));
    _printerManager.scanResults.listen((val) {
      if (!mounted) return;
      print(val);
      setState(() => _devices = val);
      if (_devices.isEmpty) setState(() => _devicesMsg = S.current.no_device);
    });
  }


  @override
  void dispose() {
    _printerManager.stopScan();
    super.dispose();
  }

  printTicket(context, device) async {
    _printerManager.selectPrinter(device);
    Ticket ticket = widget.data;

    defaultPrinter.name = device.name;
    defaultPrinter.adress = device.address;
    defaultPrinter.type = device.type;
    await _queryCtr.addItemToTable(
        DbTablesNames.defaultPrinter, defaultPrinter);

    _printerManager.stopScan();
    await _printerManager.printTicket(ticket).then((result) {
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

  _pressHelp() async {
    _prefs = await SharedPreferences.getInstance();
    var url = "https://doc.gestmob.com/";
    String lang = await _prefs.getString("myLocale");
    url = url+'en' ;
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        enableJavaScript: true,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.current.printer_titre,
          style: GoogleFonts.lato(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.settings , color: Colors.white,),
            onPressed: ()=> AppSettings.openAppSettings(),
          ),
          IconButton(
            icon: Icon(Icons.help_outline_outlined),
            onPressed:_pressHelp,
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          Container(
            padding: EdgeInsets.all(5),
            child: Text(
              "${S.current.blue_device}",
              style: GoogleFonts.lato(
                  textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              )),
            ),
          ),
          (_devices.isEmpty)? Container(
            padding: EdgeInsets.all(5),
            child: Text(
              S.current.msg_bl_localisation,
              style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.red
                  )),
            ),
          ) : SizedBox(),
          Container(
              margin: EdgeInsets.only(top: 5, bottom: 5),
              padding: EdgeInsets.all(5),
              height: 600,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: (){
                          _printerManager.stopScan();
                          _printerManager.startScan(Duration(seconds: 10));
                        },
                      )
                    ],
                  ),
              (_devices.isNotEmpty)
                  ? ListView.builder(
                controller: _controller,
                itemCount: _devices.length,
                itemBuilder: (c, i) {
                  return ListTile(
                    leading: Icon(Icons.print),
                    title: Text(
                      _devices[i].name,
                      style: GoogleFonts.lato(),
                    ),
                    subtitle: Text(
                      _devices[i].address,
                      style: GoogleFonts.lato(),
                    ),
                    onTap: () async {
                      await printTicket(context, _devices[i]);
                      Navigator.pop(context);
                    },
                  );
                },
              )
                  : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (_devicesMsg != null)
                          ? Icon(
                        Icons.warning,
                        color: Colors.yellow[700],
                        size: 60,
                      )
                          : SizedBox(),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        _devicesMsg ?? '',
                        style: GoogleFonts.lato(
                            textStyle:
                            TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  )),
                ],
              )
          ),
        ],
      ),
    );
  }
}
