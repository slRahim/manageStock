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

  /// `Customer Feedback`
  String get retour_client {
    return Intl.message(
      'Customer Feedback',
      name: 'retour_client',
      desc: '',
      args: [],
    );
  }

  /// `Provider FeedBack`
  String get retour_fournisseur {
    return Intl.message(
      'Provider FeedBack',
      name: 'retour_fournisseur',
      desc: '',
      args: [],
    );
  }

  /// `Customer Invoice Feedback`
  String get avoir_client {
    return Intl.message(
      'Customer Invoice Feedback',
      name: 'avoir_client',
      desc: '',
      args: [],
    );
  }

  /// `Provider Invoice Feedback`
  String get avoir_fournisseur {
    return Intl.message(
      'Provider Invoice Feedback',
      name: 'avoir_fournisseur',
      desc: '',
      args: [],
    );
  }

  /// `Purchase Order`
  String get bon_commande {
    return Intl.message(
      'Purchase Order',
      name: 'bon_commande',
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

  /// `Total HT`
  String get total_ht {
    return Intl.message(
      'Total HT',
      name: 'total_ht',
      desc: '',
      args: [],
    );
  }

  /// `DA`
  String get da {
    return Intl.message(
      'DA',
      name: 'da',
      desc: '',
      args: [],
    );
  }

  /// `Total TVA`
  String get total_tva {
    return Intl.message(
      'Total TVA',
      name: 'total_tva',
      desc: '',
      args: [],
    );
  }

  /// `Net to pay`
  String get net_payer {
    return Intl.message(
      'Net to pay',
      name: 'net_payer',
      desc: '',
      args: [],
    );
  }

  /// `Veuillez séléctionner au moins un article`
  String get msg_select_art {
    return Intl.message(
      'Veuillez séléctionner au moins un article',
      name: 'msg_select_art',
      desc: '',
      args: [],
    );
  }

  /// `Left`
  String get reste {
    return Intl.message(
      'Left',
      name: 'reste',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message(
      'Date',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `Price: `
  String get tarif {
    return Intl.message(
      'Price: ',
      name: 'tarif',
      desc: '',
      args: [],
    );
  }

  /// `Deposit`
  String get verssement {
    return Intl.message(
      'Deposit',
      name: 'verssement',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get total {
    return Intl.message(
      'Total',
      name: 'total',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirme {
    return Intl.message(
      'Confirm',
      name: 'confirme',
      desc: '',
      args: [],
    );
  }

  /// `Choose Action`
  String get choisir_action {
    return Intl.message(
      'Choose Action',
      name: 'choisir_action',
      desc: '',
      args: [],
    );
  }

  /// `Quick print`
  String get imp_rapide_btn {
    return Intl.message(
      'Quick print',
      name: 'imp_rapide_btn',
      desc: '',
      args: [],
    );
  }

  /// `Save & print`
  String get save_imp_btn {
    return Intl.message(
      'Save & print',
      name: 'save_imp_btn',
      desc: '',
      args: [],
    );
  }

  /// `Save only`
  String get save_btn {
    return Intl.message(
      'Save only',
      name: 'save_btn',
      desc: '',
      args: [],
    );
  }

  /// `Save as draft`
  String get broullion_btn {
    return Intl.message(
      'Save as draft',
      name: 'broullion_btn',
      desc: '',
      args: [],
    );
  }

  /// `Num is already exist!`
  String get msg_num_existe {
    return Intl.message(
      'Num is already exist!',
      name: 'msg_num_existe',
      desc: '',
      args: [],
    );
  }

  /// `Piece has been transferred`
  String get msg_piece_transfere {
    return Intl.message(
      'Piece has been transferred',
      name: 'msg_piece_transfere',
      desc: '',
      args: [],
    );
  }

  /// `Error when transforming piece`
  String get msg_transfere_err {
    return Intl.message(
      'Error when transforming piece',
      name: 'msg_transfere_err',
      desc: '',
      args: [],
    );
  }

  /// `No default printer`
  String get msg_imp_err {
    return Intl.message(
      'No default printer',
      name: 'msg_imp_err',
      desc: '',
      args: [],
    );
  }

  /// `Treasury (ies)`
  String get tresorie_titre {
    return Intl.message(
      'Treasury (ies)',
      name: 'tresorie_titre',
      desc: '',
      args: [],
    );
  }

  /// `Please select a tier`
  String get msg_select_tier {
    return Intl.message(
      'Please select a tier',
      name: 'msg_select_tier',
      desc: '',
      args: [],
    );
  }

  /// `Select Tier`
  String get select_tier {
    return Intl.message(
      'Select Tier',
      name: 'select_tier',
      desc: '',
      args: [],
    );
  }

  /// `Apply to total credit`
  String get msg_credit_total {
    return Intl.message(
      'Apply to total credit',
      name: 'msg_credit_total',
      desc: '',
      args: [],
    );
  }

  /// `Object`
  String get objet {
    return Intl.message(
      'Object',
      name: 'objet',
      desc: '',
      args: [],
    );
  }

  /// `Modality`
  String get modalite {
    return Intl.message(
      'Modality',
      name: 'modalite',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get montant {
    return Intl.message(
      'Amount',
      name: 'montant',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get categorie {
    return Intl.message(
      'Category',
      name: 'categorie',
      desc: '',
      args: [],
    );
  }

  /// `Item (s)`
  String get article_titre {
    return Intl.message(
      'Item (s)',
      name: 'article_titre',
      desc: '',
      args: [],
    );
  }

  /// `Please enter designation`
  String get msg_designation {
    return Intl.message(
      'Please enter designation',
      name: 'msg_designation',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Enter designation`
  String get msg_entre_design {
    return Intl.message(
      'Enter designation',
      name: 'msg_entre_design',
      desc: '',
      args: [],
    );
  }

  /// `Designation`
  String get designation {
    return Intl.message(
      'Designation',
      name: 'designation',
      desc: '',
      args: [],
    );
  }

  /// `Reference`
  String get referance {
    return Intl.message(
      'Reference',
      name: 'referance',
      desc: '',
      args: [],
    );
  }

  /// `Double tap to scan barcode`
  String get msg_scan_barcode {
    return Intl.message(
      'Double tap to scan barcode',
      name: 'msg_scan_barcode',
      desc: '',
      args: [],
    );
  }

  /// `Buying price`
  String get prix_achat {
    return Intl.message(
      'Buying price',
      name: 'prix_achat',
      desc: '',
      args: [],
    );
  }

  /// `In Stock`
  String get stockable {
    return Intl.message(
      'In Stock',
      name: 'stockable',
      desc: '',
      args: [],
    );
  }

  /// `PMP`
  String get pmp {
    return Intl.message(
      'PMP',
      name: 'pmp',
      desc: '',
      args: [],
    );
  }

  /// `Init`
  String get init {
    return Intl.message(
      'Init',
      name: 'init',
      desc: '',
      args: [],
    );
  }

  /// `Quantity`
  String get quantit {
    return Intl.message(
      'Quantity',
      name: 'quantit',
      desc: '',
      args: [],
    );
  }

  /// `Init Stock`
  String get stock_init {
    return Intl.message(
      'Init Stock',
      name: 'stock_init',
      desc: '',
      args: [],
    );
  }

  /// `Stock min`
  String get stock_min {
    return Intl.message(
      'Stock min',
      name: 'stock_min',
      desc: '',
      args: [],
    );
  }

  /// `Qte in package`
  String get qte_colis {
    return Intl.message(
      'Qte in package',
      name: 'qte_colis',
      desc: '',
      args: [],
    );
  }

  /// `Package`
  String get colis {
    return Intl.message(
      'Package',
      name: 'colis',
      desc: '',
      args: [],
    );
  }

  /// `Price 1`
  String get prix_v1 {
    return Intl.message(
      'Price 1',
      name: 'prix_v1',
      desc: '',
      args: [],
    );
  }

  /// `Price 2`
  String get prix_v2 {
    return Intl.message(
      'Price 2',
      name: 'prix_v2',
      desc: '',
      args: [],
    );
  }

  /// `Price 3`
  String get prix_v3 {
    return Intl.message(
      'Price 3',
      name: 'prix_v3',
      desc: '',
      args: [],
    );
  }

  /// `Enter a description for item`
  String get msg_description {
    return Intl.message(
      'Enter a description for item',
      name: 'msg_description',
      desc: '',
      args: [],
    );
  }

  /// `Brand`
  String get marque {
    return Intl.message(
      'Brand',
      name: 'marque',
      desc: '',
      args: [],
    );
  }

  /// `Tva rate`
  String get taux_tva {
    return Intl.message(
      'Tva rate',
      name: 'taux_tva',
      desc: '',
      args: [],
    );
  }

  /// `Enter PinCode`
  String get msg_login_pin {
    return Intl.message(
      'Enter PinCode',
      name: 'msg_login_pin',
      desc: '',
      args: [],
    );
  }

  /// `Enter text`
  String get msg_search {
    return Intl.message(
      'Enter text',
      name: 'msg_search',
      desc: '',
      args: [],
    );
  }

  /// `Your blutoothe is OFF`
  String get blue_off {
    return Intl.message(
      'Your blutoothe is OFF',
      name: 'blue_off',
      desc: '',
      args: [],
    );
  }

  /// `No Printer is find`
  String get no_device {
    return Intl.message(
      'No Printer is find',
      name: 'no_device',
      desc: '',
      args: [],
    );
  }

  /// `Printer (s)`
  String get printer_titre {
    return Intl.message(
      'Printer (s)',
      name: 'printer_titre',
      desc: '',
      args: [],
    );
  }

  /// `Format 58Cm`
  String get format_58 {
    return Intl.message(
      'Format 58Cm',
      name: 'format_58',
      desc: '',
      args: [],
    );
  }

  /// `Format 80Cm`
  String get format_80 {
    return Intl.message(
      'Format 80Cm',
      name: 'format_80',
      desc: '',
      args: [],
    );
  }

  /// `By Reference`
  String get par_ref {
    return Intl.message(
      'By Reference',
      name: 'par_ref',
      desc: '',
      args: [],
    );
  }

  /// `By Designation`
  String get par_desgn {
    return Intl.message(
      'By Designation',
      name: 'par_desgn',
      desc: '',
      args: [],
    );
  }

  /// `Piece Preciew`
  String get preview_titre {
    return Intl.message(
      'Piece Preciew',
      name: 'preview_titre',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get prix {
    return Intl.message(
      'Price',
      name: 'prix',
      desc: '',
      args: [],
    );
  }

  /// `QTE`
  String get qte {
    return Intl.message(
      'QTE',
      name: 'qte',
      desc: '',
      args: [],
    );
  }

  /// `You can't transform a draft`
  String get msg_err_transfer {
    return Intl.message(
      'You can\'t transform a draft',
      name: 'msg_err_transfer',
      desc: '',
      args: [],
    );
  }

  /// `Attention you maybe add inassociate articles`
  String get msg_info_article {
    return Intl.message(
      'Attention you maybe add inassociate articles',
      name: 'msg_info_article',
      desc: '',
      args: [],
    );
  }

  /// `Species`
  String get espece {
    return Intl.message(
      'Species',
      name: 'espece',
      desc: '',
      args: [],
    );
  }

  /// `Bill Payment`
  String get reglement_piece {
    return Intl.message(
      'Bill Payment',
      name: 'reglement_piece',
      desc: '',
      args: [],
    );
  }

  /// `No Categorie`
  String get choisir {
    return Intl.message(
      'No Categorie',
      name: 'choisir',
      desc: '',
      args: [],
    );
  }

  /// `No Family`
  String get no_famille {
    return Intl.message(
      'No Family',
      name: 'no_famille',
      desc: '',
      args: [],
    );
  }

  /// `No Brand`
  String get no_marque {
    return Intl.message(
      'No Brand',
      name: 'no_marque',
      desc: '',
      args: [],
    );
  }

  /// `Disbursement`
  String get decaissement {
    return Intl.message(
      'Disbursement',
      name: 'decaissement',
      desc: '',
      args: [],
    );
  }

  /// `Customer Payment`
  String get reglemnt_client {
    return Intl.message(
      'Customer Payment',
      name: 'reglemnt_client',
      desc: '',
      args: [],
    );
  }

  /// `Provider Payment`
  String get reglement_fournisseur {
    return Intl.message(
      'Provider Payment',
      name: 'reglement_fournisseur',
      desc: '',
      args: [],
    );
  }

  /// `Bursement`
  String get encaissement {
    return Intl.message(
      'Bursement',
      name: 'encaissement',
      desc: '',
      args: [],
    );
  }

  /// `Fees`
  String get charge {
    return Intl.message(
      'Fees',
      name: 'charge',
      desc: '',
      args: [],
    );
  }

  /// `Customer Refund`
  String get rembourcement_client {
    return Intl.message(
      'Customer Refund',
      name: 'rembourcement_client',
      desc: '',
      args: [],
    );
  }

  /// `Provider Refund`
  String get rembourcement_four {
    return Intl.message(
      'Provider Refund',
      name: 'rembourcement_four',
      desc: '',
      args: [],
    );
  }

  /// `Not Treasury`
  String get sans_tresorie {
    return Intl.message(
      'Not Treasury',
      name: 'sans_tresorie',
      desc: '',
      args: [],
    );
  }

  /// `With Treasury`
  String get avec_tresorie {
    return Intl.message(
      'With Treasury',
      name: 'avec_tresorie',
      desc: '',
      args: [],
    );
  }

  /// `No treasurer is associate`
  String get msg_err_tresorie {
    return Intl.message(
      'No treasurer is associate',
      name: 'msg_err_tresorie',
      desc: '',
      args: [],
    );
  }

  /// `Qantité can't be less then 0`
  String get msg_qte_err {
    return Intl.message(
      'Qantité can\'t be less then 0',
      name: 'msg_qte_err',
      desc: '',
      args: [],
    );
  }

  /// `Price can't be less then 0`
  String get msg_prix_err {
    return Intl.message(
      'Price can\'t be less then 0',
      name: 'msg_prix_err',
      desc: '',
      args: [],
    );
  }

  /// `Please enter valid numbers`
  String get msg_num_err {
    return Intl.message(
      'Please enter valid numbers',
      name: 'msg_num_err',
      desc: '',
      args: [],
    );
  }

  /// `Forwad to `
  String get transferer {
    return Intl.message(
      'Forwad to ',
      name: 'transferer',
      desc: '',
      args: [],
    );
  }

  /// `To Order`
  String get to_commande {
    return Intl.message(
      'To Order',
      name: 'to_commande',
      desc: '',
      args: [],
    );
  }

  /// `To Receipt`
  String get to_bon {
    return Intl.message(
      'To Receipt',
      name: 'to_bon',
      desc: '',
      args: [],
    );
  }

  /// `To Invoice`
  String get to_facture {
    return Intl.message(
      'To Invoice',
      name: 'to_facture',
      desc: '',
      args: [],
    );
  }

  /// `To Feedback`
  String get to_retour {
    return Intl.message(
      'To Feedback',
      name: 'to_retour',
      desc: '',
      args: [],
    );
  }

  /// `this option is not avalaible`
  String get msg_no_dispo {
    return Intl.message(
      'this option is not avalaible',
      name: 'msg_no_dispo',
      desc: '',
      args: [],
    );
  }

  /// `Discount`
  String get remise {
    return Intl.message(
      'Discount',
      name: 'remise',
      desc: '',
      args: [],
    );
  }

  /// `Percentage`
  String get pourcentage {
    return Intl.message(
      'Percentage',
      name: 'pourcentage',
      desc: '',
      args: [],
    );
  }

  /// `Sheet`
  String get journaux {
    return Intl.message(
      'Sheet',
      name: 'journaux',
      desc: '',
      args: [],
    );
  }

  /// `General`
  String get generale {
    return Intl.message(
      'General',
      name: 'generale',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get langue {
    return Intl.message(
      'Language',
      name: 'langue',
      desc: '',
      args: [],
    );
  }

  /// `Choose a language`
  String get chois_lang {
    return Intl.message(
      'Choose a language',
      name: 'chois_lang',
      desc: '',
      args: [],
    );
  }

  /// `Real Quantity`
  String get qte_reel {
    return Intl.message(
      'Real Quantity',
      name: 'qte_reel',
      desc: '',
      args: [],
    );
  }

  /// `Available Quantity`
  String get qte_dispo {
    return Intl.message(
      'Available Quantity',
      name: 'qte_dispo',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get statut {
    return Intl.message(
      'Status',
      name: 'statut',
      desc: '',
      args: [],
    );
  }

  /// `Net-HT`
  String get net_ht {
    return Intl.message(
      'Net-HT',
      name: 'net_ht',
      desc: '',
      args: [],
    );
  }

  /// `Stamped`
  String get timbre {
    return Intl.message(
      'Stamped',
      name: 'timbre',
      desc: '',
      args: [],
    );
  }

  /// `Info Article`
  String get fiche_art {
    return Intl.message(
      'Info Article',
      name: 'fiche_art',
      desc: '',
      args: [],
    );
  }

  /// `Do You Want to Exit...`
  String get msg_quitter {
    return Intl.message(
      'Do You Want to Exit...',
      name: 'msg_quitter',
      desc: '',
      args: [],
    );
  }

  /// `Tap back again to exit`
  String get msg_quitter1 {
    return Intl.message(
      'Tap back again to exit',
      name: 'msg_quitter1',
      desc: '',
      args: [],
    );
  }

  /// `Veuillez remplir les champs obligatoire`
  String get msg_champs_obg {
    return Intl.message(
      'Veuillez remplir les champs obligatoire',
      name: 'msg_champs_obg',
      desc: '',
      args: [],
    );
  }

  /// `TVA`
  String get tva {
    return Intl.message(
      'TVA',
      name: 'tva',
      desc: '',
      args: [],
    );
  }

  /// `Merci pour votre visite`
  String get msg_visite {
    return Intl.message(
      'Merci pour votre visite',
      name: 'msg_visite',
      desc: '',
      args: [],
    );
  }

  /// `Compte`
  String get compte {
    return Intl.message(
      'Compte',
      name: 'compte',
      desc: '',
      args: [],
    );
  }

  /// `Restoration`
  String get restore_data {
    return Intl.message(
      'Restoration',
      name: 'restore_data',
      desc: '',
      args: [],
    );
  }

  /// `la restoration de votre data va ecrasser toutes les données non sauvgarder`
  String get restore_msg {
    return Intl.message(
      'la restoration de votre data va ecrasser toutes les données non sauvgarder',
      name: 'restore_msg',
      desc: '',
      args: [],
    );
  }

  /// `Succer, restoration a bien terminé`
  String get msg_succes_restoration {
    return Intl.message(
      'Succer, restoration a bien terminé',
      name: 'msg_succes_restoration',
      desc: '',
      args: [],
    );
  }

  /// `Ereure, à la restoration`
  String get msg_err_restoration {
    return Intl.message(
      'Ereure, à la restoration',
      name: 'msg_err_restoration',
      desc: '',
      args: [],
    );
  }

  /// `Mes Sauvegardes`
  String get backups {
    return Intl.message(
      'Mes Sauvegardes',
      name: 'backups',
      desc: '',
      args: [],
    );
  }

  /// `Indice`
  String get indice {
    return Intl.message(
      'Indice',
      name: 'indice',
      desc: '',
      args: [],
    );
  }

  /// `financiere`
  String get financiere {
    return Intl.message(
      'financiere',
      name: 'financiere',
      desc: '',
      args: [],
    );
  }

  /// `Repartition des charges`
  String get dash_charge_title {
    return Intl.message(
      'Repartition des charges',
      name: 'dash_charge_title',
      desc: '',
      args: [],
    );
  }

  /// `Mes Comptes`
  String get dash_compte_title {
    return Intl.message(
      'Mes Comptes',
      name: 'dash_compte_title',
      desc: '',
      args: [],
    );
  }

  /// `Classement des Ventes par article`
  String get dash_vente_art_title {
    return Intl.message(
      'Classement des Ventes par article',
      name: 'dash_vente_art_title',
      desc: '',
      args: [],
    );
  }

  /// `Classement des Ventes par client`
  String get dash_vente_cl_title {
    return Intl.message(
      'Classement des Ventes par client',
      name: 'dash_vente_cl_title',
      desc: '',
      args: [],
    );
  }

  /// `Classement des Ventes par famille`
  String get dash_vente_fam_title {
    return Intl.message(
      'Classement des Ventes par famille',
      name: 'dash_vente_fam_title',
      desc: '',
      args: [],
    );
  }

  /// `Classement des Achats par article`
  String get dash_achat_art_title {
    return Intl.message(
      'Classement des Achats par article',
      name: 'dash_achat_art_title',
      desc: '',
      args: [],
    );
  }

  /// `Classement des Achats par fournisseur`
  String get dash_achat_four_title {
    return Intl.message(
      'Classement des Achats par fournisseur',
      name: 'dash_achat_four_title',
      desc: '',
      args: [],
    );
  }

  /// `Pdf preview is available before Printing`
  String get msg_pdf_view {
    return Intl.message(
      'Pdf preview is available before Printing',
      name: 'msg_pdf_view',
      desc: '',
      args: [],
    );
  }

  /// `Format A4/A5`
  String get format_a45 {
    return Intl.message(
      'Format A4/A5',
      name: 'format_a45',
      desc: '',
      args: [],
    );
  }

  /// `Imprimante Bluetooth`
  String get blue_device {
    return Intl.message(
      'Imprimante Bluetooth',
      name: 'blue_device',
      desc: '',
      args: [],
    );
  }

  /// `Save Changes`
  String get param_save {
    return Intl.message(
      'Save Changes',
      name: 'param_save',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to save last changes ...`
  String get param_msg_save {
    return Intl.message(
      'Do you want to save last changes ...',
      name: 'param_msg_save',
      desc: '',
      args: [],
    );
  }

  /// `General`
  String get param_general {
    return Intl.message(
      'General',
      name: 'param_general',
      desc: '',
      args: [],
    );
  }

  /// `Langue`
  String get param_lang {
    return Intl.message(
      'Langue',
      name: 'param_lang',
      desc: '',
      args: [],
    );
  }

  /// `Choisir une langue`
  String get param_lang_title {
    return Intl.message(
      'Choisir une langue',
      name: 'param_lang_title',
      desc: '',
      args: [],
    );
  }

  /// `Choisir Tarification`
  String get param_lang_tarif_title {
    return Intl.message(
      'Choisir Tarification',
      name: 'param_lang_tarif_title',
      desc: '',
      args: [],
    );
  }

  /// `Activer Tva`
  String get param_tva {
    return Intl.message(
      'Activer Tva',
      name: 'param_tva',
      desc: '',
      args: [],
    );
  }

  /// `Activer timbre`
  String get param_timbre {
    return Intl.message(
      'Activer timbre',
      name: 'param_timbre',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get param_notif_title {
    return Intl.message(
      'Notifications',
      name: 'param_notif_title',
      desc: '',
      args: [],
    );
  }

  /// `Activer notification`
  String get param_notif {
    return Intl.message(
      'Activer notification',
      name: 'param_notif',
      desc: '',
      args: [],
    );
  }

  /// `Heure Notification`
  String get param_notif_time {
    return Intl.message(
      'Heure Notification',
      name: 'param_notif_time',
      desc: '',
      args: [],
    );
  }

  /// `Repeter Notification`
  String get param_notif_repeat {
    return Intl.message(
      'Repeter Notification',
      name: 'param_notif_repeat',
      desc: '',
      args: [],
    );
  }

  /// `Echeance`
  String get param_echeance {
    return Intl.message(
      'Echeance',
      name: 'param_echeance',
      desc: '',
      args: [],
    );
  }

  /// `Jour`
  String get day {
    return Intl.message(
      'Jour',
      name: 'day',
      desc: '',
      args: [],
    );
  }

  /// `Sauvgarde Restauration`
  String get param_back_title {
    return Intl.message(
      'Sauvgarde Restauration',
      name: 'param_back_title',
      desc: '',
      args: [],
    );
  }

  /// `Créer Sauvegarde`
  String get param_backup {
    return Intl.message(
      'Créer Sauvegarde',
      name: 'param_backup',
      desc: '',
      args: [],
    );
  }

  /// `Succer,Backup a bien été créer`
  String get msg_back_suce {
    return Intl.message(
      'Succer,Backup a bien été créer',
      name: 'msg_back_suce',
      desc: '',
      args: [],
    );
  }

  /// `Ereure,Backup n'a pas été créer`
  String get msg_back_err {
    return Intl.message(
      'Ereure,Backup n\'a pas été créer',
      name: 'msg_back_err',
      desc: '',
      args: [],
    );
  }

  /// `Restaurer Données`
  String get param_resto_data {
    return Intl.message(
      'Restaurer Données',
      name: 'param_resto_data',
      desc: '',
      args: [],
    );
  }

  /// `Chaque Jour`
  String get ev_day {
    return Intl.message(
      'Chaque Jour',
      name: 'ev_day',
      desc: '',
      args: [],
    );
  }

  /// `Chaque Dimanche`
  String get ev_sun {
    return Intl.message(
      'Chaque Dimanche',
      name: 'ev_sun',
      desc: '',
      args: [],
    );
  }

  /// `Chaque Lundi`
  String get ev_mon {
    return Intl.message(
      'Chaque Lundi',
      name: 'ev_mon',
      desc: '',
      args: [],
    );
  }

  /// `Chaque Mardi`
  String get ev_tue {
    return Intl.message(
      'Chaque Mardi',
      name: 'ev_tue',
      desc: '',
      args: [],
    );
  }

  /// `Chaque Mercredi`
  String get ev_wedn {
    return Intl.message(
      'Chaque Mercredi',
      name: 'ev_wedn',
      desc: '',
      args: [],
    );
  }

  /// `Chaque Jeudi`
  String get ev_thur {
    return Intl.message(
      'Chaque Jeudi',
      name: 'ev_thur',
      desc: '',
      args: [],
    );
  }

  /// `Chaque Vendredi`
  String get ev_fri {
    return Intl.message(
      'Chaque Vendredi',
      name: 'ev_fri',
      desc: '',
      args: [],
    );
  }

  /// `Chaque Samedi`
  String get ev_sat {
    return Intl.message(
      'Chaque Samedi',
      name: 'ev_sat',
      desc: '',
      args: [],
    );
  }

  /// `Paramétres ont bien été modifier`
  String get msg_upd_param {
    return Intl.message(
      'Paramétres ont bien été modifier',
      name: 'msg_upd_param',
      desc: '',
      args: [],
    );
  }

  /// `Ereure à la modifications des paramétres`
  String get msg_err_upd_param {
    return Intl.message(
      'Ereure à la modifications des paramétres',
      name: 'msg_err_upd_param',
      desc: '',
      args: [],
    );
  }

  /// `utiliser`
  String get use {
    return Intl.message(
      'utiliser',
      name: 'use',
      desc: '',
      args: [],
    );
  }

  /// `Détails`
  String get details {
    return Intl.message(
      'Détails',
      name: 'details',
      desc: '',
      args: [],
    );
  }

  /// `Marge`
  String get marge {
    return Intl.message(
      'Marge',
      name: 'marge',
      desc: '',
      args: [],
    );
  }

  /// `C'est une piece transformer`
  String get msg_piece_transfo {
    return Intl.message(
      'C\'est une piece transformer',
      name: 'msg_piece_transfo',
      desc: '',
      args: [],
    );
  }

  /// `C'est une piece d'origine`
  String get msg_piece_origin {
    return Intl.message(
      'C\'est une piece d\'origine',
      name: 'msg_piece_origin',
      desc: '',
      args: [],
    );
  }

  /// `Ventes`
  String get vente {
    return Intl.message(
      'Ventes',
      name: 'vente',
      desc: '',
      args: [],
    );
  }

  /// `Achats`
  String get achat {
    return Intl.message(
      'Achats',
      name: 'achat',
      desc: '',
      args: [],
    );
  }

  /// `Ref`
  String get ref {
    return Intl.message(
      'Ref',
      name: 'ref',
      desc: '',
      args: [],
    );
  }

  /// `N°`
  String get n {
    return Intl.message(
      'N°',
      name: 'n',
      desc: '',
      args: [],
    );
  }

  /// `Meilleur Cinq`
  String get best_5 {
    return Intl.message(
      'Meilleur Cinq',
      name: 'best_5',
      desc: '',
      args: [],
    );
  }

  /// `éléments`
  String get item {
    return Intl.message(
      'éléments',
      name: 'item',
      desc: '',
      args: [],
    );
  }

  /// `Cl/Four`
  String get cl_four {
    return Intl.message(
      'Cl/Four',
      name: 'cl_four',
      desc: '',
      args: [],
    );
  }

  /// `FP`
  String get fp {
    return Intl.message(
      'FP',
      name: 'fp',
      desc: '',
      args: [],
    );
  }

  /// `CC`
  String get cc {
    return Intl.message(
      'CC',
      name: 'cc',
      desc: '',
      args: [],
    );
  }

  /// `BL`
  String get bl {
    return Intl.message(
      'BL',
      name: 'bl',
      desc: '',
      args: [],
    );
  }

  /// `FC`
  String get fc {
    return Intl.message(
      'FC',
      name: 'fc',
      desc: '',
      args: [],
    );
  }

  /// `AC`
  String get ac {
    return Intl.message(
      'AC',
      name: 'ac',
      desc: '',
      args: [],
    );
  }

  /// `RC`
  String get rc {
    return Intl.message(
      'RC',
      name: 'rc',
      desc: '',
      args: [],
    );
  }

  /// `BC`
  String get bc {
    return Intl.message(
      'BC',
      name: 'bc',
      desc: '',
      args: [],
    );
  }

  /// `BR`
  String get br {
    return Intl.message(
      'BR',
      name: 'br',
      desc: '',
      args: [],
    );
  }

  /// `FF`
  String get ff {
    return Intl.message(
      'FF',
      name: 'ff',
      desc: '',
      args: [],
    );
  }

  /// `AF`
  String get af {
    return Intl.message(
      'AF',
      name: 'af',
      desc: '',
      args: [],
    );
  }

  /// `RF`
  String get rf {
    return Intl.message(
      'RF',
      name: 'rf',
      desc: '',
      args: [],
    );
  }

  /// `TR`
  String get tr {
    return Intl.message(
      'TR',
      name: 'tr',
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