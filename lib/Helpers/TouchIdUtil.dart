import 'package:flutter/material.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:gestmob/generated/l10n.dart';

class TouchIdUtil {
  BuildContext context;

  TouchIdUtil(this.context);

  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> isActive() async {
    bool canCheckBiometrics = await _auth.canCheckBiometrics;
    if (!canCheckBiometrics) {
      return false;
    }

    List<BiometricType> availableBiometrics = await _auth.getAvailableBiometrics();

    return availableBiometrics.isNotEmpty ;
  }

  Future<bool> auth() async {
    try {
      var res =  await _auth.authenticateWithBiometrics(
        localizedReason: "Scannez Votre Empreinte Digitale Pour Vous Authentifier",
        useErrorDialogs: true,
        stickyAuth: true,
        androidAuthStrings: AndroidAuthMessages(
            cancelButton: S.current.annuler,
            fingerprintRequiredTitle: "Empreinte Digitale Requise",
            fingerprintHint: "Touchez Le Capteur",
            signInTitle: "Authentification empreinte digitale",
            fingerprintSuccess: "Empreinte Digitale Reconnue",
            fingerprintNotRecognized: "Empreinte Digitale Non Reconnue Reessayer",
            goToSettingsButton: "Aller Aux Parametres",
            goToSettingsDescription: "Aller Aux Parametres Description"),
        iOSAuthStrings: IOSAuthMessages(
            lockOut: "L Authentification Biometrique Est Desactivee",
            cancelButton: S.current.annuler,
            goToSettingsButton: "Aller Aux Parametres",
            goToSettingsDescription: "L Authentification Biometrique NEst Pas Configuree"),
      );

      return res ;
    } on Exception catch (e) {
      return false;
    }
  }
}
