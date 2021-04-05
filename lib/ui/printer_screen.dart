import 'dart:typed_data';
import 'package:connectivity/connectivity.dart';
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
import 'package:ping_discover_network/ping_discover_network.dart';
import 'package:wifi/wifi.dart';
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

  // String _localIp = '';
  // List<String> _wifidevices = [];
  // String _wifidevicesMsg;
  // bool _isDiscovering = false;
  // int _found = -1;
  // var _subscription ;

  QueryCtr _queryCtr = new QueryCtr();
  DefaultPrinter defaultPrinter = new DefaultPrinter.init();

  ScrollController _controller = new ScrollController();
  ScrollController _controller1 = new ScrollController();


  @override
  void initState() {
    if (Platform.isAndroid) {
      // _subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      //   if(result.index == ConnectivityResult.wifi.index){
      //     initWifiPrinter();
      //   }else{
      //     setState(() {
      //       _wifidevicesMsg= "Please turn wifi on";
      //     });
      //   }
      //
      // });
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
      // initWifiPrinter();
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

  // void initWifiPrinter() async {
  //   setState(() {
  //     _isDiscovering = true;
  //     _wifidevices.clear();
  //     _found = -1;
  //   });
  //
  //   String ip;
  //   try {
  //     ip = await Wifi.ip;
  //   } catch (e) {
  //     setState(() {
  //       _wifidevicesMsg = 'Please connect to network' ;
  //     });
  //     return;
  //   }
  //   setState(() {
  //     _localIp = ip;
  //   });
  //
  //   final String subnet = ip.substring(0, ip.lastIndexOf('.'));
  //   int port = 9100;
  //   print('subnet:\t$subnet, port:\t$port');
  //
  //   final stream = NetworkAnalyzer.discover2(subnet, port);
  //
  //   stream.listen((NetworkAddress addr) {
  //     if (addr.exists) {
  //       print('Found device: ${addr.ip}');
  //       setState(() {
  //         _wifidevices.add(addr.ip);
  //         _found = _wifidevices.length;
  //       });
  //     }
  //   })
  //     ..onDone(() {
  //       setState(() {
  //         _isDiscovering = false;
  //         _found = _wifidevices.length;
  //       });
  //       if(_found < 1){
  //         setState(() {
  //           _wifidevicesMsg = 'No Device is found' ;
  //         });
  //         return;
  //       }
  //     })
  //     ..onError((dynamic e) {
  //       setState(() {
  //         _wifidevicesMsg = 'No Device is found' ;
  //       });
  //       return;
  //     });
  // }

  @override
  void dispose() {
    _printerManager.stopScan();
    // _subscription.cancel();
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
        title: Text(S.current.printer_titre, style: GoogleFonts.lato(fontWeight: FontWeight.bold),),
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
              style: GoogleFonts.lato(textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              )),
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 5 , bottom: 5),
              padding: EdgeInsets.all(5),
              height: 600,
              child: (_devices.isEmpty)
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          (_devicesMsg != null )?Icon(Icons.warning , color: Colors.yellow[700], size: 60,):SizedBox(),
                          SizedBox(height: 5,),
                          Text(_devicesMsg ?? '' , style: GoogleFonts.lato(textStyle: TextStyle(fontWeight: FontWeight.bold)),),
                        ],
                      )
                  )
                  : Scrollbar(
                      isAlwaysShown: true,
                      controller: _controller,
                      child: ListView.builder(
                        controller: _controller,
                        itemCount: _devices.length,
                        itemBuilder: (c, i) {
                          return ListTile(
                            leading: Icon(Icons.print),
                            title: Text(_devices[i].name , style: GoogleFonts.lato(),),
                            subtitle: Text(_devices[i].address, style: GoogleFonts.lato(),),
                            onTap: () async {
                              await printTicket(context, _devices[i]);
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    )),
          // Container(
          //   padding: EdgeInsets.all(5),
          //   child: Text(
          //     "Wifi Devices",
          //     style: TextStyle(
          //       fontWeight: FontWeight.bold,
          //       fontSize: 16,
          //     ),
          //   ),
          // ),
          // Container(
          //     margin: EdgeInsets.only(bottom: 10 , top : 5),
          //     height: 300,
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //     ),
          //     padding: EdgeInsets.all(5),
          //     child: (_wifidevices.isEmpty)
          //         ? Center(
          //           child: Column(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               (_wifidevicesMsg != null)?Icon(Icons.warning , color: Colors.yellow[700], size: 60,)
          //                   :CircularProgressIndicator(),
          //               SizedBox(height: 5,),
          //               Text(_wifidevicesMsg ?? '' , style: TextStyle(fontWeight: FontWeight.bold),),
          //             ],
          //           )
          //         )
          //         : Scrollbar(
          //             isAlwaysShown: true,
          //             controller: _controller1,
          //             child: ListView.builder(
          //               controller: _controller1,
          //               itemCount: _wifidevices.length,
          //               itemBuilder: (c, i) {
          //                 return ListTile(
          //                   leading: Icon(Icons.print),
          //                   title: Text(_wifidevices[i]),
          //                   subtitle: Text("9100"),
          //                   onTap: () async {
          //                     // await printTicket(context, _devices[i]);
          //                     Navigator.pop(context);
          //                   },
          //                 );
          //               },
          //             ),
          //           )),
        ],
      ),
    );
  }
}
