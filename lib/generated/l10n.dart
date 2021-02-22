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

  /// `GESTMOB`
  String get app_name {
    return Intl.message(
      'GESTMOB',
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

  /// `Company.`
  String get statut_eurl {
    return Intl.message(
      'Company.',
      name: 'statut_eurl',
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

  /// `Credit`
  String get credit {
    return Intl.message(
      'Credit',
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

  /// `Preview`
  String get preview_titre {
    return Intl.message(
      'Preview',
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

  /// `Reserved Quantity`
  String get qte_cmd {
    return Intl.message(
      'Reserved Quantity',
      name: 'qte_cmd',
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

  /// `Feedback`
  String get to_retour {
    return Intl.message(
      'Feedback',
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

  /// `Please fill in the required fields`
  String get msg_champs_obg {
    return Intl.message(
      'Please fill in the required fields',
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

  /// `Thank you for your visit`
  String get msg_visite {
    return Intl.message(
      'Thank you for your visit',
      name: 'msg_visite',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get compte {
    return Intl.message(
      'Account',
      name: 'compte',
      desc: '',
      args: [],
    );
  }

  /// `Restore`
  String get restore_data {
    return Intl.message(
      'Restore',
      name: 'restore_data',
      desc: '',
      args: [],
    );
  }

  /// `restoring your data will remove all unsaved data`
  String get restore_msg {
    return Intl.message(
      'restoring your data will remove all unsaved data',
      name: 'restore_msg',
      desc: '',
      args: [],
    );
  }

  /// `Success, restoration completed`
  String get msg_succes_restoration {
    return Intl.message(
      'Success, restoration completed',
      name: 'msg_succes_restoration',
      desc: '',
      args: [],
    );
  }

  /// `Error, in restore data`
  String get msg_err_restoration {
    return Intl.message(
      'Error, in restore data',
      name: 'msg_err_restoration',
      desc: '',
      args: [],
    );
  }

  /// `Backups`
  String get backups {
    return Intl.message(
      'Backups',
      name: 'backups',
      desc: '',
      args: [],
    );
  }

  /// `Index`
  String get indice {
    return Intl.message(
      'Index',
      name: 'indice',
      desc: '',
      args: [],
    );
  }

  /// `financial`
  String get financiere {
    return Intl.message(
      'financial',
      name: 'financiere',
      desc: '',
      args: [],
    );
  }

  /// `Charges distribution`
  String get dash_charge_title {
    return Intl.message(
      'Charges distribution',
      name: 'dash_charge_title',
      desc: '',
      args: [],
    );
  }

  /// `My Accounts`
  String get dash_compte_title {
    return Intl.message(
      'My Accounts',
      name: 'dash_compte_title',
      desc: '',
      args: [],
    );
  }

  /// `Sales ranking by item`
  String get dash_vente_art_title {
    return Intl.message(
      'Sales ranking by item',
      name: 'dash_vente_art_title',
      desc: '',
      args: [],
    );
  }

  /// `Sales ranking by customer`
  String get dash_vente_cl_title {
    return Intl.message(
      'Sales ranking by customer',
      name: 'dash_vente_cl_title',
      desc: '',
      args: [],
    );
  }

  /// `Sales classification by family`
  String get dash_vente_fam_title {
    return Intl.message(
      'Sales classification by family',
      name: 'dash_vente_fam_title',
      desc: '',
      args: [],
    );
  }

  /// `Ranking of Purchases by item`
  String get dash_achat_art_title {
    return Intl.message(
      'Ranking of Purchases by item',
      name: 'dash_achat_art_title',
      desc: '',
      args: [],
    );
  }

  /// `Ranking of Purchases by supplier`
  String get dash_achat_four_title {
    return Intl.message(
      'Ranking of Purchases by supplier',
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

  /// `Bluetooth Printers`
  String get blue_device {
    return Intl.message(
      'Bluetooth Printers',
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

  /// `Language`
  String get param_lang {
    return Intl.message(
      'Language',
      name: 'param_lang',
      desc: '',
      args: [],
    );
  }

  /// `Choose a language`
  String get param_lang_title {
    return Intl.message(
      'Choose a language',
      name: 'param_lang_title',
      desc: '',
      args: [],
    );
  }

  /// `Choose Pricing`
  String get param_lang_tarif_title {
    return Intl.message(
      'Choose Pricing',
      name: 'param_lang_tarif_title',
      desc: '',
      args: [],
    );
  }

  /// `Enable Tva`
  String get param_tva {
    return Intl.message(
      'Enable Tva',
      name: 'param_tva',
      desc: '',
      args: [],
    );
  }

  /// `Enable stamped`
  String get param_timbre {
    return Intl.message(
      'Enable stamped',
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

  /// `Enable notifications`
  String get param_notif {
    return Intl.message(
      'Enable notifications',
      name: 'param_notif',
      desc: '',
      args: [],
    );
  }

  /// `Notification time`
  String get param_notif_time {
    return Intl.message(
      'Notification time',
      name: 'param_notif_time',
      desc: '',
      args: [],
    );
  }

  /// `Repeat notification`
  String get param_notif_repeat {
    return Intl.message(
      'Repeat notification',
      name: 'param_notif_repeat',
      desc: '',
      args: [],
    );
  }

  /// `Deadline`
  String get param_echeance {
    return Intl.message(
      'Deadline',
      name: 'param_echeance',
      desc: '',
      args: [],
    );
  }

  /// `day`
  String get day {
    return Intl.message(
      'day',
      name: 'day',
      desc: '',
      args: [],
    );
  }

  /// `Backup & Restore`
  String get param_back_title {
    return Intl.message(
      'Backup & Restore',
      name: 'param_back_title',
      desc: '',
      args: [],
    );
  }

  /// `Create Backup`
  String get param_backup {
    return Intl.message(
      'Create Backup',
      name: 'param_backup',
      desc: '',
      args: [],
    );
  }

  /// `Success, Backup has been created`
  String get msg_back_suce {
    return Intl.message(
      'Success, Backup has been created',
      name: 'msg_back_suce',
      desc: '',
      args: [],
    );
  }

  /// `Error, Backup was not created`
  String get msg_back_err {
    return Intl.message(
      'Error, Backup was not created',
      name: 'msg_back_err',
      desc: '',
      args: [],
    );
  }

  /// `Restore Data `
  String get param_resto_data {
    return Intl.message(
      'Restore Data ',
      name: 'param_resto_data',
      desc: '',
      args: [],
    );
  }

  /// `Daily`
  String get ev_day {
    return Intl.message(
      'Daily',
      name: 'ev_day',
      desc: '',
      args: [],
    );
  }

  /// `Every Sunday`
  String get ev_sun {
    return Intl.message(
      'Every Sunday',
      name: 'ev_sun',
      desc: '',
      args: [],
    );
  }

  /// `Every Monday`
  String get ev_mon {
    return Intl.message(
      'Every Monday',
      name: 'ev_mon',
      desc: '',
      args: [],
    );
  }

  /// `Every Tuesday`
  String get ev_tue {
    return Intl.message(
      'Every Tuesday',
      name: 'ev_tue',
      desc: '',
      args: [],
    );
  }

  /// `Every Wednesday`
  String get ev_wedn {
    return Intl.message(
      'Every Wednesday',
      name: 'ev_wedn',
      desc: '',
      args: [],
    );
  }

  /// `Every Thursday`
  String get ev_thur {
    return Intl.message(
      'Every Thursday',
      name: 'ev_thur',
      desc: '',
      args: [],
    );
  }

  /// `Every Friday`
  String get ev_fri {
    return Intl.message(
      'Every Friday',
      name: 'ev_fri',
      desc: '',
      args: [],
    );
  }

  /// `Every Saturday`
  String get ev_sat {
    return Intl.message(
      'Every Saturday',
      name: 'ev_sat',
      desc: '',
      args: [],
    );
  }

  /// `Settings have been modified,Successfully`
  String get msg_upd_param {
    return Intl.message(
      'Settings have been modified,Successfully',
      name: 'msg_upd_param',
      desc: '',
      args: [],
    );
  }

  /// `Error when modifying settings`
  String get msg_err_upd_param {
    return Intl.message(
      'Error when modifying settings',
      name: 'msg_err_upd_param',
      desc: '',
      args: [],
    );
  }

  /// `Use`
  String get use {
    return Intl.message(
      'Use',
      name: 'use',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get details {
    return Intl.message(
      'Details',
      name: 'details',
      desc: '',
      args: [],
    );
  }

  /// `Profit`
  String get marge {
    return Intl.message(
      'Profit',
      name: 'marge',
      desc: '',
      args: [],
    );
  }

  /// `It's a transforming item`
  String get msg_piece_transfo {
    return Intl.message(
      'It\'s a transforming item',
      name: 'msg_piece_transfo',
      desc: '',
      args: [],
    );
  }

  /// `it's original item`
  String get msg_piece_origin {
    return Intl.message(
      'it\'s original item',
      name: 'msg_piece_origin',
      desc: '',
      args: [],
    );
  }

  /// `Sales`
  String get vente {
    return Intl.message(
      'Sales',
      name: 'vente',
      desc: '',
      args: [],
    );
  }

  /// `Purchases`
  String get achat {
    return Intl.message(
      'Purchases',
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

  /// `Best five`
  String get best_5 {
    return Intl.message(
      'Best five',
      name: 'best_5',
      desc: '',
      args: [],
    );
  }

  /// `items`
  String get item {
    return Intl.message(
      'items',
      name: 'item',
      desc: '',
      args: [],
    );
  }

  /// `Cus/Prov`
  String get cl_four {
    return Intl.message(
      'Cus/Prov',
      name: 'cl_four',
      desc: '',
      args: [],
    );
  }

  /// `QT`
  String get fp {
    return Intl.message(
      'QT',
      name: 'fp',
      desc: '',
      args: [],
    );
  }

  /// `CO`
  String get cc {
    return Intl.message(
      'CO',
      name: 'cc',
      desc: '',
      args: [],
    );
  }

  /// `DF`
  String get bl {
    return Intl.message(
      'DF',
      name: 'bl',
      desc: '',
      args: [],
    );
  }

  /// `SI`
  String get fc {
    return Intl.message(
      'SI',
      name: 'fc',
      desc: '',
      args: [],
    );
  }

  /// `CIF`
  String get ac {
    return Intl.message(
      'CIF',
      name: 'ac',
      desc: '',
      args: [],
    );
  }

  /// `CF`
  String get rc {
    return Intl.message(
      'CF',
      name: 'rc',
      desc: '',
      args: [],
    );
  }

  /// `PO`
  String get bc {
    return Intl.message(
      'PO',
      name: 'bc',
      desc: '',
      args: [],
    );
  }

  /// `RE`
  String get br {
    return Intl.message(
      'RE',
      name: 'br',
      desc: '',
      args: [],
    );
  }

  /// `PI`
  String get ff {
    return Intl.message(
      'PI',
      name: 'ff',
      desc: '',
      args: [],
    );
  }

  /// `PIF`
  String get af {
    return Intl.message(
      'PIF',
      name: 'af',
      desc: '',
      args: [],
    );
  }

  /// `PF`
  String get rf {
    return Intl.message(
      'PF',
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

  /// `Pay.Cust`
  String get reg_cl {
    return Intl.message(
      'Pay.Cust',
      name: 'reg_cl',
      desc: '',
      args: [],
    );
  }

  /// `Pay.Prov`
  String get reg_four {
    return Intl.message(
      'Pay.Prov',
      name: 'reg_four',
      desc: '',
      args: [],
    );
  }

  /// `Debts`
  String get dette {
    return Intl.message(
      'Debts',
      name: 'dette',
      desc: '',
      args: [],
    );
  }

  /// `Min Qte`
  String get qte_min {
    return Intl.message(
      'Min Qte',
      name: 'qte_min',
      desc: '',
      args: [],
    );
  }

  /// `Stock`
  String get stock {
    return Intl.message(
      'Stock',
      name: 'stock',
      desc: '',
      args: [],
    );
  }

  /// `Summary of sales by product`
  String get recap_vente_article {
    return Intl.message(
      'Summary of sales by product',
      name: 'recap_vente_article',
      desc: '',
      args: [],
    );
  }

  /// `Summary of orders by product`
  String get recap_cmd_article {
    return Intl.message(
      'Summary of orders by product',
      name: 'recap_cmd_article',
      desc: '',
      args: [],
    );
  }

  /// `Sales Journal`
  String get jour_vente {
    return Intl.message(
      'Sales Journal',
      name: 'jour_vente',
      desc: '',
      args: [],
    );
  }

  /// `Orders log`
  String get jour_cmd {
    return Intl.message(
      'Orders log',
      name: 'jour_cmd',
      desc: '',
      args: [],
    );
  }

  /// `Summary of purchases by product`
  String get recap_achat_article {
    return Intl.message(
      'Summary of purchases by product',
      name: 'recap_achat_article',
      desc: '',
      args: [],
    );
  }

  /// `Purchasing Journal`
  String get jour_achat {
    return Intl.message(
      'Purchasing Journal',
      name: 'jour_achat',
      desc: '',
      args: [],
    );
  }

  /// `Inventory`
  String get inventaire {
    return Intl.message(
      'Inventory',
      name: 'inventaire',
      desc: '',
      args: [],
    );
  }

  /// `Out of stock product`
  String get prod_repture {
    return Intl.message(
      'Out of stock product',
      name: 'prod_repture',
      desc: '',
      args: [],
    );
  }

  /// `Zakat`
  String get zakat {
    return Intl.message(
      'Zakat',
      name: 'zakat',
      desc: '',
      args: [],
    );
  }

  /// `Daily Status`
  String get etat_jour {
    return Intl.message(
      'Daily Status',
      name: 'etat_jour',
      desc: '',
      args: [],
    );
  }

  /// `Monthly Status`
  String get etat_mensu {
    return Intl.message(
      'Monthly Status',
      name: 'etat_mensu',
      desc: '',
      args: [],
    );
  }

  /// `Annual Status`
  String get etat_annuel {
    return Intl.message(
      'Annual Status',
      name: 'etat_annuel',
      desc: '',
      args: [],
    );
  }

  /// `Report Category :`
  String get cat_rapport {
    return Intl.message(
      'Report Category :',
      name: 'cat_rapport',
      desc: '',
      args: [],
    );
  }

  /// `Report Type :`
  String get type_rapport {
    return Intl.message(
      'Report Type :',
      name: 'type_rapport',
      desc: '',
      args: [],
    );
  }

  /// `Year :`
  String get annee {
    return Intl.message(
      'Year :',
      name: 'annee',
      desc: '',
      args: [],
    );
  }

  /// `Date (Start / End :)`
  String get date_d_f {
    return Intl.message(
      'Date (Start / End :)',
      name: 'date_d_f',
      desc: '',
      args: [],
    );
  }

  /// `Report is empty`
  String get msg_rapport_vide {
    return Intl.message(
      'Report is empty',
      name: 'msg_rapport_vide',
      desc: '',
      args: [],
    );
  }

  /// `Edit on`
  String get demonstration {
    return Intl.message(
      'Edit on',
      name: 'demonstration',
      desc: '',
      args: [],
    );
  }

  /// `Report Date`
  String get rapport_date {
    return Intl.message(
      'Report Date',
      name: 'rapport_date',
      desc: '',
      args: [],
    );
  }

  /// `Customer fee`
  String get creance_cl {
    return Intl.message(
      'Customer fee',
      name: 'creance_cl',
      desc: '',
      args: [],
    );
  }

  /// `Supplier debt`
  String get creance_four {
    return Intl.message(
      'Supplier debt',
      name: 'creance_four',
      desc: '',
      args: [],
    );
  }

  /// `Print`
  String get impression_titre {
    return Intl.message(
      'Print',
      name: 'impression_titre',
      desc: '',
      args: [],
    );
  }

  /// `Display by`
  String get imp_affichage {
    return Intl.message(
      'Display by',
      name: 'imp_affichage',
      desc: '',
      args: [],
    );
  }

  /// `Ticket Format`
  String get format_ticket {
    return Intl.message(
      'Ticket Format',
      name: 'format_ticket',
      desc: '',
      args: [],
    );
  }

  /// `Show client credit`
  String get credit_tier {
    return Intl.message(
      'Show client credit',
      name: 'credit_tier',
      desc: '',
      args: [],
    );
  }

  /// `Theme Style`
  String get app_theme {
    return Intl.message(
      'Theme Style',
      name: 'app_theme',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get light_theme {
    return Intl.message(
      'Light',
      name: 'light_theme',
      desc: '',
      args: [],
    );
  }

  /// `Dark`
  String get dark_them {
    return Intl.message(
      'Dark',
      name: 'dark_them',
      desc: '',
      args: [],
    );
  }

  /// `System`
  String get sys_theme {
    return Intl.message(
      'System',
      name: 'sys_theme',
      desc: '',
      args: [],
    );
  }

  /// `Select country`
  String get selec_pays {
    return Intl.message(
      'Select country',
      name: 'selec_pays',
      desc: '',
      args: [],
    );
  }

  /// `Abonnement`
  String get abonnement {
    return Intl.message(
      'Abonnement',
      name: 'abonnement',
      desc: '',
      args: [],
    );
  }

  /// `Cette option n'est pas disponible pour la verssion évaluation`
  String get msg_demo_option {
    return Intl.message(
      'Cette option n\'est pas disponible pour la verssion évaluation',
      name: 'msg_demo_option',
      desc: '',
      args: [],
    );
  }

  /// `Votre licence d'éssaie a été éxpirer, Abonnez vous pour continuer`
  String get msg_demo_exp {
    return Intl.message(
      'Votre licence d\'éssaie a été éxpirer, Abonnez vous pour continuer',
      name: 'msg_demo_exp',
      desc: '',
      args: [],
    );
  }

  /// `Votre licence commercial a été éxpirer, Abonnez vous pour continuer`
  String get msg_premium_exp {
    return Intl.message(
      'Votre licence commercial a été éxpirer, Abonnez vous pour continuer',
      name: 'msg_premium_exp',
      desc: '',
      args: [],
    );
  }

  /// `C.A (Mois)`
  String get ca_mois {
    return Intl.message(
      'C.A (Mois)',
      name: 'ca_mois',
      desc: '',
      args: [],
    );
  }

  /// `Achat (Mois)`
  String get achat_mois {
    return Intl.message(
      'Achat (Mois)',
      name: 'achat_mois',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get start {
    return Intl.message(
      'Start',
      name: 'start',
      desc: '',
      args: [],
    );
  }

  /// `Please Select Your Language`
  String get intro_select_lang {
    return Intl.message(
      'Please Select Your Language',
      name: 'intro_select_lang',
      desc: '',
      args: [],
    );
  }

  /// `Please Select Country`
  String get intro_select_region {
    return Intl.message(
      'Please Select Country',
      name: 'intro_select_region',
      desc: '',
      args: [],
    );
  }

  /// `Your Informations`
  String get intro_infor {
    return Intl.message(
      'Your Informations',
      name: 'intro_infor',
      desc: '',
      args: [],
    );
  }

  /// `Date du début`
  String get start_date {
    return Intl.message(
      'Date du début',
      name: 'start_date',
      desc: '',
      args: [],
    );
  }

  /// `Date de fin`
  String get end_date {
    return Intl.message(
      'Date de fin',
      name: 'end_date',
      desc: '',
      args: [],
    );
  }

  /// `Choose City`
  String get choix_province {
    return Intl.message(
      'Choose City',
      name: 'choix_province',
      desc: '',
      args: [],
    );
  }

  /// `Choose Department`
  String get choix_city {
    return Intl.message(
      'Choose Department',
      name: 'choix_city',
      desc: '',
      args: [],
    );
  }

  /// `Departement`
  String get department {
    return Intl.message(
      'Departement',
      name: 'department',
      desc: '',
      args: [],
    );
  }

  /// `Upgrade to Premium`
  String get abonnement_title {
    return Intl.message(
      'Upgrade to Premium',
      name: 'abonnement_title',
      desc: '',
      args: [],
    );
  }

  /// `Illimit`
  String get illimite {
    return Intl.message(
      'Illimit',
      name: 'illimite',
      desc: '',
      args: [],
    );
  }

  /// `numbrer of products , invoices , customers , and providers`
  String get illimite_desc {
    return Intl.message(
      'numbrer of products , invoices , customers , and providers',
      name: 'illimite_desc',
      desc: '',
      args: [],
    );
  }

  /// `Print`
  String get imprime {
    return Intl.message(
      'Print',
      name: 'imprime',
      desc: '',
      args: [],
    );
  }

  /// `Your invoices in different formats 80cm , 55cm , A4 et A5`
  String get imprime_desc {
    return Intl.message(
      'Your invoices in different formats 80cm , 55cm , A4 et A5',
      name: 'imprime_desc',
      desc: '',
      args: [],
    );
  }

  /// `Export`
  String get exporte {
    return Intl.message(
      'Export',
      name: 'exporte',
      desc: '',
      args: [],
    );
  }

  /// `Your invoices and QrCodes as pdf file`
  String get exporte_desc {
    return Intl.message(
      'Your invoices and QrCodes as pdf file',
      name: 'exporte_desc',
      desc: '',
      args: [],
    );
  }

  /// `Backup & Restore`
  String get save_rest {
    return Intl.message(
      'Backup & Restore',
      name: 'save_rest',
      desc: '',
      args: [],
    );
  }

  /// `Persist your data to your drive`
  String get save_rest_desc {
    return Intl.message(
      'Persist your data to your drive',
      name: 'save_rest_desc',
      desc: '',
      args: [],
    );
  }

  /// `Tap on subscription to restore`
  String get msg_get_abonnement {
    return Intl.message(
      'Tap on subscription to restore',
      name: 'msg_get_abonnement',
      desc: '',
      args: [],
    );
  }

  /// `Transformer item to`
  String get transformer_title {
    return Intl.message(
      'Transformer item to',
      name: 'transformer_title',
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