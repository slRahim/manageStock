import 'package:flutter/material.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/TouchIdUtil.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:vibration/vibration.dart';

// special pour l'ajout et modification de pin d'auth ds le screen profile
class EnterPin extends StatefulWidget {
  final Function(String newCodePin) onCodePinChanged;
  final String codePin;
  EnterPin(this.onCodePinChanged, this.codePin);

  @override
  _EnterPinState createState() => _EnterPinState();
}

class _EnterPinState extends State<EnterPin> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            // colors: [Color(0xFF088787), Color(0xFF1FC877)],
              colors: [Colors.indigo[300], Colors.indigo[600]],
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomRight,
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp)
      ),
      child: widget.onCodePinChanged == null? buildNotEditMode()
          : Column(
        children: <Widget>[
          Expanded(
            child: OtpSceern(widget.onCodePinChanged),
          ),
        ],
      ),
    );
  }

  Widget buildNotEditMode() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.lock,
              color: Colors.white,
              size: 100,
            ),
            SizedBox(height: 20),
            Text(
              widget.codePin.isEmpty
                  ?  S.current.msg_no_pass
                  :  S.current.msg_pass + widget.codePin.substring(3, 4),
              style: TextStyle(
                color: Colors.white70,
                fontSize: 21.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(widget.codePin.isEmpty
                ?  S.current.msg_edit_pass
                :  S.current.msg_edit_pass1,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OtpSceern extends StatefulWidget {
  final Function(String newCodePin) onCodePinChanged;
  OtpSceern(this.onCodePinChanged);
  @override
  _OtpSceernState createState() => _OtpSceernState();
}

class _OtpSceernState extends State<OtpSceern> {
  List<String> currentPin = ["", "", "", ""];
  TextEditingController pinOneController = TextEditingController();
  TextEditingController pinTwoController = TextEditingController();
  TextEditingController pinThreeController = TextEditingController();
  TextEditingController pinFourController = TextEditingController();
  String fisrt;
  var outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(color: Colors.white30),
  );
  int pinIndex = 0;

  @override
  void initState() {
    super.initState();
    fisrt = "";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          SizedBox(height: 20),
          Icon(
            Icons.lock,
            color: Colors.white,
            size: 80,
          ),
          Expanded(
            child: Container(
              alignment: Alignment(0, 0.4),
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  buildSecuritytext(),
                  SizedBox(
                    height: 40,
                  ),
                  buildPinRow(),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
          buildNumberPad(),
        ],
      ),
    );
  }

  buildNumberPad() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                KeyboardNumber(
                    n: 1,
                    onPressed: () {
                      pinIndexSetup("1");
                    }),
                KeyboardNumber(
                    n: 2,
                    onPressed: () {
                      pinIndexSetup("2");
                    }),
                KeyboardNumber(
                    n: 3,
                    onPressed: () {
                      pinIndexSetup("3");
                    })
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                KeyboardNumber(
                    n: 4,
                    onPressed: () {
                      pinIndexSetup("4");
                    }),
                KeyboardNumber(
                    n: 5,
                    onPressed: () {
                      pinIndexSetup("5");
                    }),
                KeyboardNumber(
                    n: 6,
                    onPressed: () {
                      pinIndexSetup("6");
                    })
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                KeyboardNumber(
                    n: 7,
                    onPressed: () {
                      pinIndexSetup("7");
                    }),
                KeyboardNumber(
                    n: 8,
                    onPressed: () {
                      pinIndexSetup("8");
                    }),
                KeyboardNumber(
                    n: 9,
                    onPressed: () {
                      pinIndexSetup("9");
                    })
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: 60.0,
                  child: MaterialButton(
                    onPressed: null,
                    child: SizedBox(),
                  ),
                ),
                KeyboardNumber(
                    n: 0,
                    onPressed: () {
                      pinIndexSetup("0");
                    }),
                Container(
                  width: 60,
                  child: MaterialButton(
                    height: 60.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60.0)),
                    onPressed: () {
                      clearPin();
                    },
                    child: Icon(
                      Icons.backspace,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  pinIndexSetup(String text) async {
    if (pinIndex == 0) {
      pinIndex = 1;
    } else if (pinIndex < 4) {
      pinIndex++;
    }
    setPin(pinIndex, text);
    currentPin[pinIndex - 1] = text;
    String strPin = "";
    currentPin.forEach((e) {
      strPin += e;
    });
    if (pinIndex == 4) {
      if (fisrt == "") {
        fisrt = strPin;
        pinIndex = 0;
        pinOneController.clear();
        pinTwoController.clear();
        pinThreeController.clear();
        pinFourController.clear();
      } else {
        String message;
        if (fisrt == strPin) {
          widget.onCodePinChanged(strPin);
          message =  S.current.msg_save_pass;
        } else {
          message =  S.current.msg_pass_incorrecte;
          Vibration.vibrate(duration: 200);
        }
        Helpers.showToast(message);

        fisrt = "";
        pinIndex = 0;
        pinOneController.clear();
        pinTwoController.clear();
        pinThreeController.clear();
        pinFourController.clear();
      }
    }
    setState(() {});
  }

  setPin(int n, String text) {
    switch (n) {
      case 1:
        pinOneController.text = text;
        break;
      case 2:
        pinTwoController.text = text;
        break;
      case 3:
        pinThreeController.text = text;
        break;
      case 4:
        pinFourController.text = text;
        break;
    }
  }

  clearPin() {
    if (pinIndex == 0) {
      pinIndex = 0;
    } else if (pinIndex == 4) {
      setPin(pinIndex, "");
      currentPin[pinIndex - 1] = "";
      pinIndex--;
    } else {
      setPin(pinIndex, "");
      currentPin[pinIndex - 1] = "";
      pinIndex--;
    }
  }

  buildPinRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        PinNumber(
          outlineInputBorder: outlineInputBorder,
          textEditController: pinOneController,
        ),
        PinNumber(
          outlineInputBorder: outlineInputBorder,
          textEditController: pinTwoController,
        ),
        PinNumber(
          outlineInputBorder: outlineInputBorder,
          textEditController: pinThreeController,
        ),
        PinNumber(
          outlineInputBorder: outlineInputBorder,
          textEditController: pinFourController,
        ),
      ],
    );
  }

  Widget buildSecuritytext() {
    return Column(
      children: <Widget>[
        Text(
          fisrt == ""
              ?  S.current.msg_choix_pin
              :  S.current.msg_confirm_pin,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 21.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          fisrt == ""
              ? S.current.msg_entre_pin
              : S.current.msg_confirm_pin1,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12.0,
          ),
        ),
      ],
    );
  }

}

class PinNumber extends StatelessWidget {
  final TextEditingController textEditController;
  final OutlineInputBorder outlineInputBorder;

  PinNumber({this.outlineInputBorder, this.textEditController});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.0,
      child: TextField(
        controller: textEditController,
        enabled: false,
        obscureText: true,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(16.0),
          disabledBorder: outlineInputBorder,
          filled: true,
          fillColor: Colors.transparent,
        ),
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 21.0, color: Colors.white),
      ),
    );
  }
}

class KeyboardNumber extends StatelessWidget {
  final int n;
  final Function() onPressed;

  KeyboardNumber({this.n, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.0,
      height: 60.0,
      decoration:
      BoxDecoration(shape: BoxShape.circle, color: Colors.transparent),
      alignment: Alignment.center,
      child: MaterialButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
            side: BorderSide(color: Colors.white30)),
        height: 60.0,
        child: Text(
          "$n",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24 * MediaQuery.of(context).textScaleFactor,
            color: Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}