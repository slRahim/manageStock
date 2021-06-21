import 'dart:io' show Platform;

import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/DefaultPrinter.dart';
import 'package:google_fonts/google_fonts.dart';

class Print extends StatefulWidget {
  final Ticket data;

  Print(this.data);

  @override
  _PrintState createState() => _PrintState();
}

class _PrintState extends State<Print> {
  PrinterBluetoothManager _printerManager = PrinterBluetoothManager();
  List<PrinterBluetooth> _devices = [];
  String _devicesMsg;
  BluetoothManager bluetoothManager = BluetoothManager.instance;

  QueryCtr _queryCtr = new QueryCtr();
  DefaultPrinter defaultPrinter = new DefaultPrinter.init();

  ScrollController _controller = new ScrollController();
  ScrollController _controller1 = new ScrollController();

  @override
  void initState() {
    if (Platform.isAndroid) {
      bluetoothManager.state.listen((val) {
        if (!mounted) return;
        if (val == 12) {
          initBlPrinter();
        } else if (val == 10) {
          setState(() => _devicesMsg = S.current.blue_off);
        }
      });
    } else {
      initBlPrinter();
    }

    super.initState();
  }

  void initBlPrinter() {
    _printerManager.startScan(Duration(seconds: 2));
    _printerManager.scanResults.listen((val) {
      if (!mounted) return;
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
          Container(
              margin: EdgeInsets.only(top: 5, bottom: 5),
              padding: EdgeInsets.all(5),
              height: 600,
              child: (_devices.isEmpty)
                  ? Center(
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
                    ))
                  : Scrollbar(
                      isAlwaysShown: true,
                      controller: _controller,
                      child: ListView.builder(
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
                      ),
                    )),
        ],
      ),
    );
  }
}
