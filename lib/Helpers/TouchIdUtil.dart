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
        localizedReason: S.current.msg_scaner_empreinte,
        useErrorDialogs: true,
        stickyAuth: true,
        androidAuthStrings: AndroidAuthMessages(
            cancelButton: S.current.annuler,
            fingerprintHint: '',
            signInTitle: S.current.titre_auth_empreinte,
            fingerprintSuccess: S.current.msg_auth_success,
            fingerprintNotRecognized: S.current.msg_auth_fail,
            goToSettingsButton: S.current.msg_config_auth
        ),
        iOSAuthStrings: IOSAuthMessages(
            lockOut: S.current.msg_aut_lockout,
            cancelButton: S.current.annuler,
            goToSettingsButton: S.current.msg_config_auth,
        ),
      );

      return res ;
    } on Exception catch (e) {
      return false;
    }
  }
}
