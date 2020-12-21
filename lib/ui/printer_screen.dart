import 'dart:typed_data';
import 'package:flutter/material.dart' hide Image;
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/DefaultPrinter.dart';
import 'dart:io' show Platform;
import 'package:image/image.dart';

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

  QueryCtr _queryCtr = new QueryCtr() ;
  DefaultPrinter defaultPrinter = new DefaultPrinter.init();

  @override
  void initState() {
    if (Platform.isAndroid) {
      bluetoothManager.state.listen((val) {
        print('state = $val');
        if (!mounted) return;
        if (val == 12) {
          print('on');
          initPrinter();
        } else if (val == 10) {
          print('off');
          setState(() => _devicesMsg = S.current.blue_off);
        }
      });
    } else {
      initPrinter();
    }

    super.initState();
  }

  void initPrinter() {
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

  printTicket(context , device) async {
    _printerManager.selectPrinter(device);
    Ticket ticket=widget.data ;

    defaultPrinter.name = device.name ;
    defaultPrinter.adress = device.address ;
    defaultPrinter.type = device.type ;
    await _queryCtr.addItemToTable(DbTablesNames.defaultPrinter, defaultPrinter);

    _printerManager.printTicket(ticket).then((result) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Text(result.msg),
        ),
      );
      dispose();
    }).catchError((error){
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
        title: Text(S.current.printer_titre),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: _devices.isEmpty
          ? Center(child: Text(_devicesMsg ?? ''))
          : ListView.builder(
          itemCount: _devices.length,
          itemBuilder: (c, i) {
          return ListTile(
            leading: Icon(Icons.print),
            title: Text(_devices[i].name),
            subtitle: Text(_devices[i].address),
            onTap: () async{
              await printTicket(context , _devices[i]);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }



}
