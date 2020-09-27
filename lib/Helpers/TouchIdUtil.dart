import 'package:flutter/material.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';

class TouchIdUtil {
  BuildContext context;

  TouchIdUtil(this.context);

  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> isActive() async {
    bool canCheckBiometrics = await _auth.canCheckBiometrics;
    if (!canCheckBiometrics) {
      return false;
    }

    List<BiometricType> availableBiometrics =
    await _auth.getAvailableBiometrics();
    return availableBiometrics.contains(BiometricType.fingerprint);
  }

  Future<bool> auth() async {
    try {
      return await _auth.authenticateWithBiometrics(localizedReason:
        "locaization.ScannezVotreEmpreinteDigitalePourVousAuthentifier",
        useErrorDialogs: true,
        stickyAuth: true,
        androidAuthStrings: AndroidAuthMessages(
            cancelButton: "locaization.Annuler",
            fingerprintRequiredTitle: "locaization.EmpreinteDigitaleRequise",
            fingerprintHint: "locaization.TouchezLeCapteur",
            signInTitle: "locaization.AuthentificationDEmpreinteDigitale",
            fingerprintSuccess: "locaization.EmpreinteDigitaleReconnue",
            fingerprintNotRecognized:
            "locaization.EmpreinteDigitaleNonReconnueReessayer",
            goToSettingsButton: "locaization.AllerAuxParametres",
            goToSettingsDescription: "locaization.AllerAuxParametresDescription"),
        iOSAuthStrings: IOSAuthMessages(
            lockOut: "locaization.LAuthentificationBiometriqueEstDesactivee",
            cancelButton: "locaization.Annuler",
            goToSettingsButton: "locaization.AllerAuxParametres",
            goToSettingsDescription:
            "locaization.LAuthentificationDiometriqueNEstPasConfiguree"),
      );
    } on Exception catch (e) {
      return false;
    }
  }
}
