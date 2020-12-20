// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `GestMob`
  String get app_name {
    return Intl.message(
      'GestMob',
      name: 'app_name',
      desc: '',
      args: [],
    );
  }

  /// `Exit`
  String get quitter {
    return Intl.message(
      'Exit',
      name: 'quitter',
      desc: '',
      args: [],
    );
  }

  /// `Help`
  String get aide {
    return Intl.message(
      'Help',
      name: 'aide',
      desc: '',
      args: [],
    );
  }

  /// `Items`
  String get articles {
    return Intl.message(
      'Items',
      name: 'articles',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Reports`
  String get rapports {
    return Intl.message(
      'Reports',
      name: 'rapports',
      desc: '',
      args: [],
    );
  }

  /// `Treasuries`
  String get tresories {
    return Intl.message(
      'Treasuries',
      name: 'tresories',
      desc: '',
      args: [],
    );
  }

  /// `Purchase Invoice`
  String get facture_achat {
    return Intl.message(
      'Purchase Invoice',
      name: 'facture_achat',
      desc: '',
      args: [],
    );
  }

  /// `Sales Invoice`
  String get facture_vente {
    return Intl.message(
      'Sales Invoice',
      name: 'facture_vente',
      desc: '',
      args: [],
    );
  }

  /// `Receipts`
  String get bon_reception {
    return Intl.message(
      'Receipts',
      name: 'bon_reception',
      desc: '',
      args: [],
    );
  }

  /// `Providers`
  String get fournisseur {
    return Intl.message(
      'Providers',
      name: 'fournisseur',
      desc: '',
      args: [],
    );
  }

  /// `Customers`
  String get client {
    return Intl.message(
      'Customers',
      name: 'client',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Forms`
  String get bon_livraison {
    return Intl.message(
      'Delivery Forms',
      name: 'bon_livraison',
      desc: '',
      args: [],
    );
  }

  /// `Customer Orders`
  String get commande_client {
    return Intl.message(
      'Customer Orders',
      name: 'commande_client',
      desc: '',
      args: [],
    );
  }

  /// `Quotes`
  String get devis {
    return Intl.message(
      'Quotes',
      name: 'devis',
      desc: '',
      args: [],
    );
  }

  /// `Dashbord`
  String get tableau_bord {
    return Intl.message(
      'Dashbord',
      name: 'tableau_bord',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get accueil {
    return Intl.message(
      'Home',
      name: 'accueil',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile_titre {
    return Intl.message(
      'Profile',
      name: 'profile_titre',
      desc: '',
      args: [],
    );
  }

  /// `Edit `
  String get modification_titre {
    return Intl.message(
      'Edit ',
      name: 'modification_titre',
      desc: '',
      args: [],
    );
  }

  /// `New Profile`
  String get profile_ajouter {
    return Intl.message(
      'New Profile',
      name: 'profile_ajouter',
      desc: '',
      args: [],
    );
  }

  /// `Veulliez entrez un raison social`
  String get msg_entre_rs {
    return Intl.message(
      'Veulliez entrez un raison social',
      name: 'msg_entre_rs',
      desc: '',
      args: [],
    );
  }

  /// `Info`
  String get fiche {
    return Intl.message(
      'Info',
      name: 'fiche',
      desc: '',
      args: [],
    );
  }

  /// `Logo`
  String get logo {
    return Intl.message(
      'Logo',
      name: 'logo',
      desc: '',
      args: [],
    );
  }

  /// `Security`
  String get securite {
    return Intl.message(
      'Security',
      name: 'securite',
      desc: '',
      args: [],
    );
  }

  /// `Social Code`
  String get rs {
    return Intl.message(
      'Social Code',
      name: 'rs',
      desc: '',
      args: [],
    );
  }

  /// `Activity`
  String get activite {
    return Intl.message(
      'Activity',
      name: 'activite',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get adresse {
    return Intl.message(
      'Address',
      name: 'adresse',
      desc: '',
      args: [],
    );
  }

  /// `City`
  String get ville {
    return Intl.message(
      'City',
      name: 'ville',
      desc: '',
      args: [],
    );
  }

  /// `Contry`
  String get pays {
    return Intl.message(
      'Contry',
      name: 'pays',
      desc: '',
      args: [],
    );
  }

  /// `Telephone`
  String get telephone {
    return Intl.message(
      'Telephone',
      name: 'telephone',
      desc: '',
      args: [],
    );
  }

  /// `Telephone 2`
  String get telephone2 {
    return Intl.message(
      'Telephone 2',
      name: 'telephone2',
      desc: '',
      args: [],
    );
  }

  /// `Mobile`
  String get mobile {
    return Intl.message(
      'Mobile',
      name: 'mobile',
      desc: '',
      args: [],
    );
  }

  /// `Mobile 2`
  String get mobile2 {
    return Intl.message(
      'Mobile 2',
      name: 'mobile2',
      desc: '',
      args: [],
    );
  }

  /// `Fax`
  String get fax {
    return Intl.message(
      'Fax',
      name: 'fax',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get mail {
    return Intl.message(
      'Email',
      name: 'mail',
      desc: '',
      args: [],
    );
  }

  /// `Web Address`
  String get adresse_web {
    return Intl.message(
      'Web Address',
      name: 'adresse_web',
      desc: '',
      args: [],
    );
  }

  /// `N°RC`
  String get n_rc {
    return Intl.message(
      'N°RC',
      name: 'n_rc',
      desc: '',
      args: [],
    );
  }

  /// `ART.IMP`
  String get art_imp {
    return Intl.message(
      'ART.IMP',
      name: 'art_imp',
      desc: '',
      args: [],
    );
  }

  /// `NIF`
  String get nif {
    return Intl.message(
      'NIF',
      name: 'nif',
      desc: '',
      args: [],
    );
  }

  /// `NIS`
  String get nis {
    return Intl.message(
      'NIS',
      name: 'nis',
      desc: '',
      args: [],
    );
  }

  /// `Social Capital`
  String get capitale_sociale {
    return Intl.message(
      'Social Capital',
      name: 'capitale_sociale',
      desc: '',
      args: [],
    );
  }

  /// `Enable Code Pin`
  String get code_pin {
    return Intl.message(
      'Enable Code Pin',
      name: 'code_pin',
      desc: '',
      args: [],
    );
  }

  /// `You didn't set password yet`
  String get msg_no_pass {
    return Intl.message(
      'You didn\'t set password yet',
      name: 'msg_no_pass',
      desc: '',
      args: [],
    );
  }

  /// `Your password is ***`
  String get msg_pass {
    return Intl.message(
      'Your password is ***',
      name: 'msg_pass',
      desc: '',
      args: [],
    );
  }

  /// `Click edit to set your password`
  String get msg_edit_pass {
    return Intl.message(
      'Click edit to set your password',
      name: 'msg_edit_pass',
      desc: '',
      args: [],
    );
  }

  /// `Click edit to change your password`
  String get msg_edit_pass1 {
    return Intl.message(
      'Click edit to change your password',
      name: 'msg_edit_pass1',
      desc: '',
      args: [],
    );
  }

  /// `Click save to store your password`
  String get msg_save_pass {
    return Intl.message(
      'Click save to store your password',
      name: 'msg_save_pass',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect Pin`
  String get msg_pass_incorrecte {
    return Intl.message(
      'Incorrect Pin',
      name: 'msg_pass_incorrecte',
      desc: '',
      args: [],
    );
  }

  /// `Choose PinCode`
  String get msg_choix_pin {
    return Intl.message(
      'Choose PinCode',
      name: 'msg_choix_pin',
      desc: '',
      args: [],
    );
  }

  /// `Confirm PinCode`
  String get msg_confirm_pin {
    return Intl.message(
      'Confirm PinCode',
      name: 'msg_confirm_pin',
      desc: '',
      args: [],
    );
  }

  /// `Add PinCode To Protect Data`
  String get msg_entre_pin {
    return Intl.message(
      'Add PinCode To Protect Data',
      name: 'msg_entre_pin',
      desc: '',
      args: [],
    );
  }

  /// `Confirm PinCode To Protect Data`
  String get msg_confirm_pin1 {
    return Intl.message(
      'Confirm PinCode To Protect Data',
      name: 'msg_confirm_pin1',
      desc: '',
      args: [],
    );
  }

  /// `Mys.`
  String get statut_m {
    return Intl.message(
      'Mys.',
      name: 'statut_m',
      desc: '',
      args: [],
    );
  }

  /// `Mlle.`
  String get statut_mlle {
    return Intl.message(
      'Mlle.',
      name: 'statut_mlle',
      desc: '',
      args: [],
    );
  }

  /// `Mme.`
  String get statut_mme {
    return Intl.message(
      'Mme.',
      name: 'statut_mme',
      desc: '',
      args: [],
    );
  }

  /// `Dr.`
  String get statut_dr {
    return Intl.message(
      'Dr.',
      name: 'statut_dr',
      desc: '',
      args: [],
    );
  }

  /// `Pr.`
  String get statut_pr {
    return Intl.message(
      'Pr.',
      name: 'statut_pr',
      desc: '',
      args: [],
    );
  }

  /// `Eurl.`
  String get statut_eurl {
    return Intl.message(
      'Eurl.',
      name: 'statut_eurl',
      desc: '',
      args: [],
    );
  }

  /// `Sarl.`
  String get statut_sarl {
    return Intl.message(
      'Sarl.',
      name: 'statut_sarl',
      desc: '',
      args: [],
    );
  }

  /// `Spa.`
  String get statut_spa {
    return Intl.message(
      'Spa.',
      name: 'statut_spa',
      desc: '',
      args: [],
    );
  }

  /// `Epic.`
  String get statut_epic {
    return Intl.message(
      'Epic.',
      name: 'statut_epic',
      desc: '',
      args: [],
    );
  }

  /// `Etp.`
  String get statut_etp {
    return Intl.message(
      'Etp.',
      name: 'statut_etp',
      desc: '',
      args: [],
    );
  }

  /// `Familly`
  String get famile {
    return Intl.message(
      'Familly',
      name: 'famile',
      desc: '',
      args: [],
    );
  }

  /// `Filer`
  String get filtrer_btn {
    return Intl.message(
      'Filer',
      name: 'filtrer_btn',
      desc: '',
      args: [],
    );
  }

  /// `Add `
  String get ajouter {
    return Intl.message(
      'Add ',
      name: 'ajouter',
      desc: '',
      args: [],
    );
  }

  /// `Scan QR`
  String get scan_qr {
    return Intl.message(
      'Scan QR',
      name: 'scan_qr',
      desc: '',
      args: [],
    );
  }

  /// `Customer (s)`
  String get client_titre {
    return Intl.message(
      'Customer (s)',
      name: 'client_titre',
      desc: '',
      args: [],
    );
  }

  /// `Provider (s)`
  String get fournisseur_titre {
    return Intl.message(
      'Provider (s)',
      name: 'fournisseur_titre',
      desc: '',
      args: [],
    );
  }

  /// `Has Credit`
  String get a_credit {
    return Intl.message(
      'Has Credit',
      name: 'a_credit',
      desc: '',
      args: [],
    );
  }

  /// `Show Bloqued`
  String get aff_bloquer {
    return Intl.message(
      'Show Bloqued',
      name: 'aff_bloquer',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get annuler {
    return Intl.message(
      'Cancel',
      name: 'annuler',
      desc: '',
      args: [],
    );
  }

  /// `Flash ON`
  String get flash_on {
    return Intl.message(
      'Flash ON',
      name: 'flash_on',
      desc: '',
      args: [],
    );
  }

  /// `Flash Off`
  String get flash_off {
    return Intl.message(
      'Flash Off',
      name: 'flash_off',
      desc: '',
      args: [],
    );
  }

  /// `The user did not grant the camera permission!`
  String get msg_cam_permission {
    return Intl.message(
      'The user did not grant the camera permission!',
      name: 'msg_cam_permission',
      desc: '',
      args: [],
    );
  }

  /// `Error : Unknown Error`
  String get msg_ereure {
    return Intl.message(
      'Error : Unknown Error',
      name: 'msg_ereure',
      desc: '',
      args: [],
    );
  }

  /// `Photo`
  String get photo {
    return Intl.message(
      'Photo',
      name: 'photo',
      desc: '',
      args: [],
    );
  }

  /// `Map`
  String get map {
    return Intl.message(
      'Map',
      name: 'map',
      desc: '',
      args: [],
    );
  }

  /// `QRCode`
  String get qr_code {
    return Intl.message(
      'QRCode',
      name: 'qr_code',
      desc: '',
      args: [],
    );
  }

  /// `Required Field`
  String get msg_champ_oblg {
    return Intl.message(
      'Required Field',
      name: 'msg_champ_oblg',
      desc: '',
      args: [],
    );
  }

  /// `Double tap to scan qr`
  String get msg_scan_qr {
    return Intl.message(
      'Double tap to scan qr',
      name: 'msg_scan_qr',
      desc: '',
      args: [],
    );
  }

  /// `Starting Balance`
  String get solde_depart {
    return Intl.message(
      'Starting Balance',
      name: 'solde_depart',
      desc: '',
      args: [],
    );
  }

  /// `Sales Number `
  String get chifre_affaire {
    return Intl.message(
      'Sales Number ',
      name: 'chifre_affaire',
      desc: '',
      args: [],
    );
  }

  /// `Pay`
  String get regler {
    return Intl.message(
      'Pay',
      name: 'regler',
      desc: '',
      args: [],
    );
  }

  /// `Crédit`
  String get credit {
    return Intl.message(
      'Crédit',
      name: 'credit',
      desc: '',
      args: [],
    );
  }

  /// `Customer/Provider`
  String get client_four {
    return Intl.message(
      'Customer/Provider',
      name: 'client_four',
      desc: '',
      args: [],
    );
  }

  /// `Bloqued`
  String get bloquer {
    return Intl.message(
      'Bloqued',
      name: 'bloquer',
      desc: '',
      args: [],
    );
  }

  /// `No QrCode was associate to the tier `
  String get msg_no_qr {
    return Intl.message(
      'No QrCode was associate to the tier ',
      name: 'msg_no_qr',
      desc: '',
      args: [],
    );
  }

  /// `Please add at least raison social et mobile`
  String get msg_gen_qr {
    return Intl.message(
      'Please add at least raison social et mobile',
      name: 'msg_gen_qr',
      desc: '',
      args: [],
    );
  }

  /// `Hide`
  String get masquer {
    return Intl.message(
      'Hide',
      name: 'masquer',
      desc: '',
      args: [],
    );
  }

  /// `Pricing: `
  String get tarification {
    return Intl.message(
      'Pricing: ',
      name: 'tarification',
      desc: '',
      args: [],
    );
  }

  /// `Familly added`
  String get msg_fam_ajout {
    return Intl.message(
      'Familly added',
      name: 'msg_fam_ajout',
      desc: '',
      args: [],
    );
  }

  /// `Element has been added successfully`
  String get msg_ajout_item {
    return Intl.message(
      'Element has been added successfully',
      name: 'msg_ajout_item',
      desc: '',
      args: [],
    );
  }

  /// `Element has been updated successfully`
  String get msg_update_item {
    return Intl.message(
      'Element has been updated successfully',
      name: 'msg_update_item',
      desc: '',
      args: [],
    );
  }

  /// `Error when adding element to db`
  String get msg_ajout_err {
    return Intl.message(
      'Error when adding element to db',
      name: 'msg_ajout_err',
      desc: '',
      args: [],
    );
  }

  /// `Error when updating element`
  String get msg_update_err {
    return Intl.message(
      'Error when updating element',
      name: 'msg_update_err',
      desc: '',
      args: [],
    );
  }

  /// `Delete ?`
  String get supp {
    return Intl.message(
      'Delete ?',
      name: 'supp',
      desc: '',
      args: [],
    );
  }

  /// `Do you wont to delete the element'`
  String get msg_supp {
    return Intl.message(
      'Do you wont to delete the element\'',
      name: 'msg_supp',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get oui {
    return Intl.message(
      'Yes',
      name: 'oui',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get non {
    return Intl.message(
      'No',
      name: 'non',
      desc: '',
      args: [],
    );
  }

  /// `You can't dell a default element`
  String get msg_supp_err1 {
    return Intl.message(
      'You can\'t dell a default element',
      name: 'msg_supp_err1',
      desc: '',
      args: [],
    );
  }

  /// `Element has been deleted successfully`
  String get msg_supp_ok {
    return Intl.message(
      'Element has been deleted successfully',
      name: 'msg_supp_ok',
      desc: '',
      args: [],
    );
  }

  /// `You can't dell element. others items are associated`
  String get msg_supp_err2 {
    return Intl.message(
      'You can\'t dell element. others items are associated',
      name: 'msg_supp_err2',
      desc: '',
      args: [],
    );
  }

  /// `Call`
  String get appeler {
    return Intl.message(
      'Call',
      name: 'appeler',
      desc: '',
      args: [],
    );
  }

  /// `Add image`
  String get ajout_image {
    return Intl.message(
      'Add image',
      name: 'ajout_image',
      desc: '',
      args: [],
    );
  }

  /// `Filter is not available`
  String get filtre_non_dispo {
    return Intl.message(
      'Filter is not available',
      name: 'filtre_non_dispo',
      desc: '',
      args: [],
    );
  }

  /// `Invoice (s)`
  String get piece_titre {
    return Intl.message(
      'Invoice (s)',
      name: 'piece_titre',
      desc: '',
      args: [],
    );
  }

  /// `Only Draft`
  String get aff_draft {
    return Intl.message(
      'Only Draft',
      name: 'aff_draft',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}