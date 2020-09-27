import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/Helpers/TouchIdUtil.dart';
import 'package:intl/intl.dart';

class LoginApp extends StatefulWidget {
  @override
  _LoginAppState createState() => _LoginAppState();
}

class _LoginAppState extends State<LoginApp> {
  TouchIdUtil _auth;

  @override
  void initState() {
    super.initState();

    _auth = TouchIdUtil(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  _touchIdAuth() async {
    bool success = await _auth.auth();
    if (success) {
      startTime();
    }
  }

  startTime() async {
    // PatienterPopupwidget(context);
    var _duration = new Duration(milliseconds: 200);
    return new Timer(_duration, navigationStateSideBarLayout);
  }

  void navigationStateSideBarLayout() {
    Navigator.of(context).pushReplacementNamed(RoutesKeys.homePage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xFF088787),
              Color(0xFF1FC877)
            ],
                begin: FractionalOffset.topLeft,
                end: FractionalOffset.bottomRight,
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp
            )),
        child: Column(
          children: <Widget>[
            Expanded(child: OtpSceern(),
            ),
            FutureBuilder<bool>(
              future: _auth.isActive(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data) {
                  return IconButton(
                    icon: Icon(
                      Icons.fingerprint,
                      color: Colors.white,
                    ),
                    iconSize: 80,
                    onPressed: _touchIdAuth,
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class OtpSceern extends StatefulWidget {
  @override
  _OtpSceernState createState() => _OtpSceernState();
}

class _OtpSceernState extends State<OtpSceern> {
  List<String> currentPin = ["", "", "", ""];
  TextEditingController pinOneController = TextEditingController();
  TextEditingController pinTwoController = TextEditingController();
  TextEditingController pinThreeController = TextEditingController();
  TextEditingController pinFourController = TextEditingController();
  var outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(color: Colors.white30),
  );
  int pinIndex = 0;
  // MyLocalization localization;
  @override
  Widget build(BuildContext context) {
        /*localization = new MyLocalization(Provider
        .of<AppStateNotifier>(context, listen: false)
        .language);*/
    return SafeArea(
      child: Column(
        children: <Widget>[
          buildExitButton(),
          Expanded(
            child: Container(
              alignment: Alignment(0, 0.5),
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  buildSecuritytext(),
                  SizedBox(
                    height: 40,
                  ),
                  buildPinRow(),
                ],
              ),
            ),
          ),
          buildNumberPad(),
        ],
      ),
    );
  }
  startTime() async {
    // PatienterPopupwidget(context);
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationSideBarLayout);
  }

  void navigationSideBarLayout() {
    Navigator.of(context).pushReplacementNamed(RoutesKeys.homePage);
  }
  buildNumberPad() {
    return Expanded(
      child: Container(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(bottom: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  keyboardNumber(
                      n: 1,
                      onPressed: () {
                        pinIndexSetup("1");
                      }),
                  keyboardNumber(
                      n: 2,
                      onPressed: () {
                        pinIndexSetup("2");
                      }),
                  keyboardNumber(
                      n: 3,
                      onPressed: () {
                        pinIndexSetup("3");
                      })
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  keyboardNumber(
                      n: 4,
                      onPressed: () {
                        pinIndexSetup("4");
                      }),
                  keyboardNumber(
                      n: 5,
                      onPressed: () {
                        pinIndexSetup("5");
                      }),
                  keyboardNumber(
                      n: 6,
                      onPressed: () {
                        pinIndexSetup("6");
                      })
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  keyboardNumber(
                      n: 7,
                      onPressed: () {
                        pinIndexSetup("7");
                      }),
                  keyboardNumber(
                      n: 8,
                      onPressed: () {
                        pinIndexSetup("8");
                      }),
                  keyboardNumber(
                      n: 9,
                      onPressed: () {
                        pinIndexSetup("9");
                      })
                ],
              ),
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
                  keyboardNumber(
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
      ),
    );
  }

  pinIndexSetup(String text) async{
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
      String pass = "0000";
      if (pass == strPin) {
        await startTime();
      } else {
        // Vibration.vibrate(duration: 200);
        // Toast.show("CodePINIncorrect", context,
        //     backgroundColor:Theme.of(context).errorColor, gravity: Toast.CENTER);
        pinIndex=0;
        pinOneController.clear();
        pinTwoController.clear();
        pinThreeController.clear();
        pinFourController.clear();
      }
    }
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

  buildSecuritytext() {
    return Text(
      "LoginAvecPIN",
      style: TextStyle(
        color: Colors.white70,
        fontSize: 21.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  buildExitButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MaterialButton(
            onPressed: () {
              // quitApp();
            },
            height: 50.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0)),
            child: Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
        )
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

class keyboardNumber extends StatelessWidget {
  final int n;
  final Function() onPressed;

  keyboardNumber({this.n, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.0,
      height: 60.0,
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: Colors.transparent),
      alignment: Alignment.center,
      child: MaterialButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60),side: BorderSide(color: Colors.white30)),
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
