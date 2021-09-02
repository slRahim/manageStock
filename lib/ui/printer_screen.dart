import 'dart:io' show Platform;

import 'package:app_settings/app_settings.dart';
import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
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
  BluetoothManager bluetoothManager = BluetoothManager.instance;

  QueryCtr _queryCtr = new QueryCtr();
  DefaultPrinter defaultPrinter = new DefaultPrinter.init();

  ScrollController _controller = new ScrollController();

  List<dynamic> _devices = [];
  bool connected = false;
  String _devicesMsg;

  @override
  void initState() {
    if (Platform.isIOS) {
      initBlPrinter();
    } else {
      bluetoothManager.state.listen((val) {
        print("state = $val");
        if (!mounted) return;
        if (val == 12) {
          getBluetooth();
        } else if (val == 10) {
          setState(() {
            _devicesMsg = S.current.blue_off;
          });
        }
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _printerManager.stopScan();
    super.dispose();
  }

  //*******************************************************************************************************************************************************************************
  //************************************************************************* for ios devices ******************************************************************************************************
  //special esc_pos_blue
  void initBlPrinter() {
    _printerManager.startScan(Duration(seconds: 10));
    _printerManager.scanResults.listen((val) {
      if (!mounted) return;
      print(val);
      setState(() => _devices = val);
      if (_devices.isEmpty) setState(() => _devicesMsg = S.current.no_device);
    });
  }

  //special package esc_pos_blue
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

  //********************************************************************************************************************************************************************************
  //************************************************************************** for android devices ******************************************************************************************
  //special package bluetooth_thermal_printer
  Future<void> getBluetooth() async {
    final List bluetooths = await BluetoothThermalPrinter.getBluetooths;
    print("Print $bluetooths");
    setState(() {
      _devices = bluetooths;
    });
  }

  //special package bluetooth_thermal_printer
  Future<void> printTicket2(context, {name, mac, type}) async {
    final String result = await BluetoothThermalPrinter.connect(mac);

    defaultPrinter.name = name;
    defaultPrinter.adress = mac;
    defaultPrinter.type = type;
    await _queryCtr.addItemToTable(
        DbTablesNames.defaultPrinter, defaultPrinter);

    String isConnected = await BluetoothThermalPrinter.connectionStatus;
    if (isConnected == "true") {
      Ticket ticket = widget.data;
      List<int> bytes = ticket.bytes;
      final result = await BluetoothThermalPrinter.writeBytes(bytes);
      print("Print $result");
    } else {
      //Hadnle Not Connected Senario
    }
  }

  //**************************************************************************************************************************************************************
  //************************************************************************** display **********************************************************************

  Widget printerListItem(device) {
    if (Platform.isAndroid) {
      return ListTile(
        onTap: () async{
          await printTicket2(context,
              name: device.split('#').first,
              mac: device.split('#').last,
              type: 1);
          Navigator.pop(context);
        },
        leading: Icon(Icons.print),
        title: Text('${device.split('#').first}'),
        subtitle: Text("${device.split('#').last}"),
      );
    }

    return ListTile(
      leading: Icon(Icons.print),
      title: Text(
        device.name,
        style: GoogleFonts.lato(),
      ),
      subtitle: Text(
        device.address,
        style: GoogleFonts.lato(),
      ),
      onTap: () async {
        await printTicket(context, device);
        Navigator.pop(context);
      },
    );
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
          (Platform.isAndroid)?IconButton(
            icon: Icon(
              Icons.bluetooth_connected,
              color: Colors.white,
            ),
            onPressed: () => AppSettings.openBluetoothSettings(),
          ):SizedBox(),
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
          (_devices.isEmpty)
              ? Container(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    (Platform.isAndroid)? S.current.imp_bl_android :S.current.msg_bl_localisation,
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.red)),
                  ),
                )
              : SizedBox(),
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
                        onPressed: () {
                          getBluetooth();
                        },
                      )
                    ],
                  ),
                  (_devices.isNotEmpty)
                      ? Container(
                          height: 200,
                          child: ListView.builder(
                            itemCount:
                                _devices.length > 0 ? _devices.length : 0,
                            itemBuilder: (context, index) {
                              return printerListItem(_devices[index]);
                            },
                          ),
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
              )),
        ],
      ),
    );
  }
}
