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

  /// `Purchases Invoice`
  String get facture_achat {
    return Intl.message(
      'Purchases Invoice',
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

  /// `Vendors`
  String get fournisseur {
    return Intl.message(
      'Vendors',
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

  /// `Delivery notes`
  String get bon_livraison {
    return Intl.message(
      'Delivery notes',
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

  /// `Dashboard`
  String get tableau_bord {
    return Intl.message(
      'Dashboard',
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

  /// `Customer returns`
  String get retour_client {
    return Intl.message(
      'Customer returns',
      name: 'retour_client',
      desc: '',
      args: [],
    );
  }

  /// `Vendor returns`
  String get retour_fournisseur {
    return Intl.message(
      'Vendor returns',
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

  /// `Vendor credit note`
  String get avoir_fournisseur {
    return Intl.message(
      'Vendor credit note',
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

  /// `Please enter a name/company name.`
  String get msg_entre_rs {
    return Intl.message(
      'Please enter a name/company name.',
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

  /// `Name/Company name`
  String get rs {
    return Intl.message(
      'Name/Company name',
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

  /// `Web address`
  String get adresse_web {
    return Intl.message(
      'Web address',
      name: 'adresse_web',
      desc: '',
      args: [],
    );
  }

  /// `CRN`
  String get n_rc {
    return Intl.message(
      'CRN',
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

  /// `Tax ID`
  String get nif {
    return Intl.message(
      'Tax ID',
      name: 'nif',
      desc: '',
      args: [],
    );
  }

  /// `Tax ID2`
  String get nis {
    return Intl.message(
      'Tax ID2',
      name: 'nis',
      desc: '',
      args: [],
    );
  }

  /// `Share capital`
  String get capitale_sociale {
    return Intl.message(
      'Share capital',
      name: 'capitale_sociale',
      desc: '',
      args: [],
    );
  }

  /// `Enable password`
  String get code_pin {
    return Intl.message(
      'Enable password',
      name: 'code_pin',
      desc: '',
      args: [],
    );
  }

  /// `You didn't set a password yet.`
  String get msg_no_pass {
    return Intl.message(
      'You didn\'t set a password yet.',
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

  /// `Tap edit to set your password.`
  String get msg_edit_pass {
    return Intl.message(
      'Tap edit to set your password.',
      name: 'msg_edit_pass',
      desc: '',
      args: [],
    );
  }

  /// `Tap edit to change your password.`
  String get msg_edit_pass1 {
    return Intl.message(
      'Tap edit to change your password.',
      name: 'msg_edit_pass1',
      desc: '',
      args: [],
    );
  }

  /// `Tap save to store your password.`
  String get msg_save_pass {
    return Intl.message(
      'Tap save to store your password.',
      name: 'msg_save_pass',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect password.`
  String get msg_pass_incorrecte {
    return Intl.message(
      'Incorrect password.',
      name: 'msg_pass_incorrecte',
      desc: '',
      args: [],
    );
  }

  /// `Choose a password.`
  String get msg_choix_pin {
    return Intl.message(
      'Choose a password.',
      name: 'msg_choix_pin',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password.`
  String get msg_confirm_pin {
    return Intl.message(
      'Confirm password.',
      name: 'msg_confirm_pin',
      desc: '',
      args: [],
    );
  }

  /// `Add a password to protect data.`
  String get msg_entre_pin {
    return Intl.message(
      'Add a password to protect data.',
      name: 'msg_entre_pin',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password to protect data`
  String get msg_confirm_pin1 {
    return Intl.message(
      'Confirm password to protect data',
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

  /// `Apply`
  String get filtrer_btn {
    return Intl.message(
      'Apply',
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

  /// `Customer`
  String get client_titre {
    return Intl.message(
      'Customer',
      name: 'client_titre',
      desc: '',
      args: [],
    );
  }

  /// `Vendor`
  String get fournisseur_titre {
    return Intl.message(
      'Vendor',
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

  /// `Blocked`
  String get aff_bloquer {
    return Intl.message(
      'Blocked',
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

  /// `Error : Unknown Error.`
  String get msg_ereure {
    return Intl.message(
      'Error : Unknown Error.',
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

  /// `Required Field.`
  String get msg_champ_oblg {
    return Intl.message(
      'Required Field.',
      name: 'msg_champ_oblg',
      desc: '',
      args: [],
    );
  }

  /// `Double tap to scan QR.`
  String get msg_scan_qr {
    return Intl.message(
      'Double tap to scan QR.',
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

  /// `Turnover`
  String get chifre_affaire {
    return Intl.message(
      'Turnover',
      name: 'chifre_affaire',
      desc: '',
      args: [],
    );
  }

  /// `Payment`
  String get regler_client {
    return Intl.message(
      'Payment',
      name: 'regler_client',
      desc: '',
      args: [],
    );
  }

  /// `Payment`
  String get regler_four {
    return Intl.message(
      'Payment',
      name: 'regler_four',
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

  /// `Customer/Vendor`
  String get client_four {
    return Intl.message(
      'Customer/Vendor',
      name: 'client_four',
      desc: '',
      args: [],
    );
  }

  /// `Blocked`
  String get bloquer {
    return Intl.message(
      'Blocked',
      name: 'bloquer',
      desc: '',
      args: [],
    );
  }

  /// `No Qr Code was associate.`
  String get msg_no_qr {
    return Intl.message(
      'No Qr Code was associate.',
      name: 'msg_no_qr',
      desc: '',
      args: [],
    );
  }

  /// `Please add at least a name and mobile number.`
  String get msg_gen_qr {
    return Intl.message(
      'Please add at least a name and mobile number.',
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

  /// `Price variants`
  String get tarification {
    return Intl.message(
      'Price variants',
      name: 'tarification',
      desc: '',
      args: [],
    );
  }

  /// `Familly added.`
  String get msg_fam_ajout {
    return Intl.message(
      'Familly added.',
      name: 'msg_fam_ajout',
      desc: '',
      args: [],
    );
  }

  /// `Element has been added successfully.`
  String get msg_ajout_item {
    return Intl.message(
      'Element has been added successfully.',
      name: 'msg_ajout_item',
      desc: '',
      args: [],
    );
  }

  /// `Element has been updated successfully.`
  String get msg_update_item {
    return Intl.message(
      'Element has been updated successfully.',
      name: 'msg_update_item',
      desc: '',
      args: [],
    );
  }

  /// `Error when adding an element to data base.`
  String get msg_ajout_err {
    return Intl.message(
      'Error when adding an element to data base.',
      name: 'msg_ajout_err',
      desc: '',
      args: [],
    );
  }

  /// `Error when updating an element.`
  String get msg_update_err {
    return Intl.message(
      'Error when updating an element.',
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

  /// `Do you wont to delete the element?`
  String get msg_supp {
    return Intl.message(
      'Do you wont to delete the element?',
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

  /// `You can't delete a default element.`
  String get msg_supp_err1 {
    return Intl.message(
      'You can\'t delete a default element.',
      name: 'msg_supp_err1',
      desc: '',
      args: [],
    );
  }

  /// `Element has been deleted successfully.`
  String get msg_supp_ok {
    return Intl.message(
      'Element has been deleted successfully.',
      name: 'msg_supp_ok',
      desc: '',
      args: [],
    );
  }

  /// `You can't delete an element when items are associated with it.`
  String get msg_supp_err2 {
    return Intl.message(
      'You can\'t delete an element when items are associated with it.',
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

  /// `Total (Tax excl.)`
  String get total_ht {
    return Intl.message(
      'Total (Tax excl.)',
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

  /// `Total Tax`
  String get total_tva {
    return Intl.message(
      'Total Tax',
      name: 'total_tva',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get net_payer {
    return Intl.message(
      'Total',
      name: 'net_payer',
      desc: '',
      args: [],
    );
  }

  /// `Please select at least one item.`
  String get msg_select_art {
    return Intl.message(
      'Please select at least one item.',
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

  /// `Total (VAT incl.)`
  String get total_ttc {
    return Intl.message(
      'Total (VAT incl.)',
      name: 'total_ttc',
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

  /// `Choose an Action`
  String get choisir_action {
    return Intl.message(
      'Choose an Action',
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

  /// `Number already exists!`
  String get msg_num_existe {
    return Intl.message(
      'Number already exists!',
      name: 'msg_num_existe',
      desc: '',
      args: [],
    );
  }

  /// `Document has been transferred.`
  String get msg_piece_transfere {
    return Intl.message(
      'Document has been transferred.',
      name: 'msg_piece_transfere',
      desc: '',
      args: [],
    );
  }

  /// `Error while transferring the document!`
  String get msg_transfere_err {
    return Intl.message(
      'Error while transferring the document!',
      name: 'msg_transfere_err',
      desc: '',
      args: [],
    );
  }

  /// `No default printer.`
  String get msg_imp_err {
    return Intl.message(
      'No default printer.',
      name: 'msg_imp_err',
      desc: '',
      args: [],
    );
  }

  /// `Treasury`
  String get tresorie_titre {
    return Intl.message(
      'Treasury',
      name: 'tresorie_titre',
      desc: '',
      args: [],
    );
  }

  /// `Please select a tier.`
  String get msg_select_tier {
    return Intl.message(
      'Please select a tier.',
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

  /// `Apply to total balance.`
  String get msg_credit_total {
    return Intl.message(
      'Apply to total balance.',
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

  /// `Check id`
  String get num_cheque {
    return Intl.message(
      'Check id',
      name: 'num_cheque',
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

  /// `Product`
  String get article_titre {
    return Intl.message(
      'Product',
      name: 'article_titre',
      desc: '',
      args: [],
    );
  }

  /// `Add a product`
  String get artcile_titre_ajouter {
    return Intl.message(
      'Add a product',
      name: 'artcile_titre_ajouter',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a designation.`
  String get msg_designation {
    return Intl.message(
      'Please enter a designation.',
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

  /// `Enter a designation.`
  String get msg_entre_design {
    return Intl.message(
      'Enter a designation.',
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

  /// `Double Tap to scan barcode.`
  String get msg_scan_barcode {
    return Intl.message(
      'Double Tap to scan barcode.',
      name: 'msg_scan_barcode',
      desc: '',
      args: [],
    );
  }

  /// `Buying price (excl. tax).`
  String get prix_achat {
    return Intl.message(
      'Buying price (excl. tax).',
      name: 'prix_achat',
      desc: '',
      args: [],
    );
  }

  /// `Storable`
  String get stockable {
    return Intl.message(
      'Storable',
      name: 'stockable',
      desc: '',
      args: [],
    );
  }

  /// `VWAP`
  String get pmp {
    return Intl.message(
      'VWAP',
      name: 'pmp',
      desc: '',
      args: [],
    );
  }

  /// `Initial`
  String get init {
    return Intl.message(
      'Initial',
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

  /// `Initial Quantity`
  String get stock_init {
    return Intl.message(
      'Initial Quantity',
      name: 'stock_init',
      desc: '',
      args: [],
    );
  }

  /// `Min Quantity`
  String get stock_min {
    return Intl.message(
      'Min Quantity',
      name: 'stock_min',
      desc: '',
      args: [],
    );
  }

  /// `Qte in a package`
  String get qte_colis {
    return Intl.message(
      'Qte in a package',
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

  /// `Price 1 (excl. tax)`
  String get prix_v1 {
    return Intl.message(
      'Price 1 (excl. tax)',
      name: 'prix_v1',
      desc: '',
      args: [],
    );
  }

  /// `Price 2 (excl. tax)`
  String get prix_v2 {
    return Intl.message(
      'Price 2 (excl. tax)',
      name: 'prix_v2',
      desc: '',
      args: [],
    );
  }

  /// `Price 3 (excl. tax)`
  String get prix_v3 {
    return Intl.message(
      'Price 3 (excl. tax)',
      name: 'prix_v3',
      desc: '',
      args: [],
    );
  }

  /// `Enter a description for item.`
  String get msg_description {
    return Intl.message(
      'Enter a description for item.',
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

  /// `VAT rate`
  String get taux_tva {
    return Intl.message(
      'VAT rate',
      name: 'taux_tva',
      desc: '',
      args: [],
    );
  }

  /// `Enter password.`
  String get msg_login_pin {
    return Intl.message(
      'Enter password.',
      name: 'msg_login_pin',
      desc: '',
      args: [],
    );
  }

  /// `Enter text.`
  String get msg_search {
    return Intl.message(
      'Enter text.',
      name: 'msg_search',
      desc: '',
      args: [],
    );
  }

  /// `Your bluetooth is OFF.`
  String get blue_off {
    return Intl.message(
      'Your bluetooth is OFF.',
      name: 'blue_off',
      desc: '',
      args: [],
    );
  }

  /// `No printer found`
  String get no_device {
    return Intl.message(
      'No printer found',
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

  /// `Format 58 mm`
  String get format_58 {
    return Intl.message(
      'Format 58 mm',
      name: 'format_58',
      desc: '',
      args: [],
    );
  }

  /// `Format 80 mm`
  String get format_80 {
    return Intl.message(
      'Format 80 mm',
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

  /// `Price (excl. tax)`
  String get prix {
    return Intl.message(
      'Price (excl. tax)',
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

  /// `You can't transform a draft.`
  String get msg_err_transfer {
    return Intl.message(
      'You can\'t transform a draft.',
      name: 'msg_err_transfer',
      desc: '',
      args: [],
    );
  }

  /// `you risk of adding an item with no previous movement!!`
  String get msg_info_article {
    return Intl.message(
      'you risk of adding an item with no previous movement!!',
      name: 'msg_info_article',
      desc: '',
      args: [],
    );
  }

  /// `Cash`
  String get espece {
    return Intl.message(
      'Cash',
      name: 'espece',
      desc: '',
      args: [],
    );
  }

  /// `Check`
  String get cheque {
    return Intl.message(
      'Check',
      name: 'cheque',
      desc: '',
      args: [],
    );
  }

  /// `Wire transfer`
  String get virement {
    return Intl.message(
      'Wire transfer',
      name: 'virement',
      desc: '',
      args: [],
    );
  }

  /// `Bank card`
  String get carte_bancaire {
    return Intl.message(
      'Bank card',
      name: 'carte_bancaire',
      desc: '',
      args: [],
    );
  }

  /// `Bank draft`
  String get traite_bancaire {
    return Intl.message(
      'Bank draft',
      name: 'traite_bancaire',
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

  /// `No Category`
  String get choisir {
    return Intl.message(
      'No Category',
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

  /// `Withdrawal`
  String get decaissement {
    return Intl.message(
      'Withdrawal',
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

  /// `Vendor Payment`
  String get reglement_fournisseur {
    return Intl.message(
      'Vendor Payment',
      name: 'reglement_fournisseur',
      desc: '',
      args: [],
    );
  }

  /// `Deposit`
  String get encaissement {
    return Intl.message(
      'Deposit',
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

  /// `Vendor Refund`
  String get rembourcement_four {
    return Intl.message(
      'Vendor Refund',
      name: 'rembourcement_four',
      desc: '',
      args: [],
    );
  }

  /// `Refund`
  String get rembourcement {
    return Intl.message(
      'Refund',
      name: 'rembourcement',
      desc: '',
      args: [],
    );
  }

  /// `Keep payment`
  String get sans_tresorie_client {
    return Intl.message(
      'Keep payment',
      name: 'sans_tresorie_client',
      desc: '',
      args: [],
    );
  }

  /// `Delete payment`
  String get avec_tresorie_client {
    return Intl.message(
      'Delete payment',
      name: 'avec_tresorie_client',
      desc: '',
      args: [],
    );
  }

  /// `Keep payment`
  String get sans_tresorie_four {
    return Intl.message(
      'Keep payment',
      name: 'sans_tresorie_four',
      desc: '',
      args: [],
    );
  }

  /// `Delete payment`
  String get avec_tresorie_four {
    return Intl.message(
      'Delete payment',
      name: 'avec_tresorie_four',
      desc: '',
      args: [],
    );
  }

  /// `No account is associated.`
  String get msg_err_tresorie {
    return Intl.message(
      'No account is associated.',
      name: 'msg_err_tresorie',
      desc: '',
      args: [],
    );
  }

  /// `Quantity can't be less then 0.`
  String get msg_qte_err {
    return Intl.message(
      'Quantity can\'t be less then 0.',
      name: 'msg_qte_err',
      desc: '',
      args: [],
    );
  }

  /// `Price can't be less then 0.`
  String get msg_prix_err {
    return Intl.message(
      'Price can\'t be less then 0.',
      name: 'msg_prix_err',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid numbers.`
  String get msg_num_err {
    return Intl.message(
      'Please enter a valid numbers.',
      name: 'msg_num_err',
      desc: '',
      args: [],
    );
  }

  /// `Forward to `
  String get transferer {
    return Intl.message(
      'Forward to ',
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

  /// `To credit note`
  String get to_retour {
    return Intl.message(
      'To credit note',
      name: 'to_retour',
      desc: '',
      args: [],
    );
  }

  /// `This option is not avalaible.`
  String get msg_no_dispo {
    return Intl.message(
      'This option is not avalaible.',
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

  /// `History`
  String get journaux {
    return Intl.message(
      'History',
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

  /// `Quantity`
  String get qte_reel {
    return Intl.message(
      'Quantity',
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

  /// `Net(excl. tax)`
  String get net_ht {
    return Intl.message(
      'Net(excl. tax)',
      name: 'net_ht',
      desc: '',
      args: [],
    );
  }

  /// `Fiscal Stamp`
  String get timbre {
    return Intl.message(
      'Fiscal Stamp',
      name: 'timbre',
      desc: '',
      args: [],
    );
  }

  /// `Item card`
  String get fiche_art {
    return Intl.message(
      'Item card',
      name: 'fiche_art',
      desc: '',
      args: [],
    );
  }

  /// `Do You Want to Exit?`
  String get msg_quitter {
    return Intl.message(
      'Do You Want to Exit?',
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

  /// `VAT`
  String get tva {
    return Intl.message(
      'VAT',
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

  /// `Restoring your data will remove all unsaved data.`
  String get restore_msg {
    return Intl.message(
      'Restoring your data will remove all unsaved data.',
      name: 'restore_msg',
      desc: '',
      args: [],
    );
  }

  /// `Success, restoration completed.`
  String get msg_succes_restoration {
    return Intl.message(
      'Success, restoration completed.',
      name: 'msg_succes_restoration',
      desc: '',
      args: [],
    );
  }

  /// `Error, in restore data.`
  String get msg_err_restoration {
    return Intl.message(
      'Error, in restore data.',
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

  /// `Financial`
  String get financiere {
    return Intl.message(
      'Financial',
      name: 'financiere',
      desc: '',
      args: [],
    );
  }

  /// `Fees distribution`
  String get dash_charge_title {
    return Intl.message(
      'Fees distribution',
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

  /// `Sales rankings by item`
  String get dash_vente_art_title {
    return Intl.message(
      'Sales rankings by item',
      name: 'dash_vente_art_title',
      desc: '',
      args: [],
    );
  }

  /// `Sales rankings by customer`
  String get dash_vente_cl_title {
    return Intl.message(
      'Sales rankings by customer',
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

  /// `Rankings of Purchases by item`
  String get dash_achat_art_title {
    return Intl.message(
      'Rankings of Purchases by item',
      name: 'dash_achat_art_title',
      desc: '',
      args: [],
    );
  }

  /// `Rankings of Purchases by vendor`
  String get dash_achat_four_title {
    return Intl.message(
      'Rankings of Purchases by vendor',
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

  /// `Do you want to save the last changes?`
  String get param_msg_save {
    return Intl.message(
      'Do you want to save the last changes?',
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

  /// `Enable VAT`
  String get param_tva {
    return Intl.message(
      'Enable VAT',
      name: 'param_tva',
      desc: '',
      args: [],
    );
  }

  /// `Enable fiscal stamp`
  String get param_timbre {
    return Intl.message(
      'Enable fiscal stamp',
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

  /// `Day`
  String get day {
    return Intl.message(
      'Day',
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

  /// `Success, Backup has been created.`
  String get msg_back_suce {
    return Intl.message(
      'Success, Backup has been created.',
      name: 'msg_back_suce',
      desc: '',
      args: [],
    );
  }

  /// `Error, Backup was not created.`
  String get msg_back_err {
    return Intl.message(
      'Error, Backup was not created.',
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

  /// `Settings have been updated,Successfully.`
  String get msg_upd_param {
    return Intl.message(
      'Settings have been updated,Successfully.',
      name: 'msg_upd_param',
      desc: '',
      args: [],
    );
  }

  /// `Error when modifying settings.`
  String get msg_err_upd_param {
    return Intl.message(
      'Error when modifying settings.',
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

  /// `Profits`
  String get marge {
    return Intl.message(
      'Profits',
      name: 'marge',
      desc: '',
      args: [],
    );
  }

  /// `Transformed.`
  String get msg_piece_transfo {
    return Intl.message(
      'Transformed.',
      name: 'msg_piece_transfo',
      desc: '',
      args: [],
    );
  }

  /// `Original.`
  String get msg_piece_origin {
    return Intl.message(
      'Original.',
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

  /// `DN`
  String get bl {
    return Intl.message(
      'DN',
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

  /// `CCN`
  String get ac {
    return Intl.message(
      'CCN',
      name: 'ac',
      desc: '',
      args: [],
    );
  }

  /// `CR`
  String get rc {
    return Intl.message(
      'CR',
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

  /// `VCN`
  String get af {
    return Intl.message(
      'VCN',
      name: 'af',
      desc: '',
      args: [],
    );
  }

  /// `VR`
  String get rf {
    return Intl.message(
      'VR',
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

  /// `Cust.pay`
  String get reg_cl {
    return Intl.message(
      'Cust.pay',
      name: 'reg_cl',
      desc: '',
      args: [],
    );
  }

  /// `Ven.pay`
  String get reg_four {
    return Intl.message(
      'Ven.pay',
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

  /// `Sales History`
  String get jour_vente {
    return Intl.message(
      'Sales History',
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

  /// `Purchasing History`
  String get jour_achat {
    return Intl.message(
      'Purchasing History',
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

  /// `Product out of stock`
  String get prod_repture {
    return Intl.message(
      'Product out of stock',
      name: 'prod_repture',
      desc: '',
      args: [],
    );
  }

  /// `Inventory by buying price`
  String get zakat {
    return Intl.message(
      'Inventory by buying price',
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

  /// `Report is empty.`
  String get msg_rapport_vide {
    return Intl.message(
      'Report is empty.',
      name: 'msg_rapport_vide',
      desc: '',
      args: [],
    );
  }

  /// `Report Date`
  String get demonstration {
    return Intl.message(
      'Report Date',
      name: 'demonstration',
      desc: '',
      args: [],
    );
  }

  /// `Report period (from / to)`
  String get rapport_date {
    return Intl.message(
      'Report period (from / to)',
      name: 'rapport_date',
      desc: '',
      args: [],
    );
  }

  /// `Customer debt`
  String get creance_cl {
    return Intl.message(
      'Customer debt',
      name: 'creance_cl',
      desc: '',
      args: [],
    );
  }

  /// `Vendor debt`
  String get creance_four {
    return Intl.message(
      'Vendor debt',
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

  /// `Receipt Format`
  String get format_ticket {
    return Intl.message(
      'Receipt Format',
      name: 'format_ticket',
      desc: '',
      args: [],
    );
  }

  /// `Show client debt`
  String get credit_tier {
    return Intl.message(
      'Show client debt',
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

  /// `Select a country`
  String get selec_pays {
    return Intl.message(
      'Select a country',
      name: 'selec_pays',
      desc: '',
      args: [],
    );
  }

  /// `I want to subscribe`
  String get abonnement {
    return Intl.message(
      'I want to subscribe',
      name: 'abonnement',
      desc: '',
      args: [],
    );
  }

  /// `This option is not avalaible for the demo version.`
  String get msg_demo_option {
    return Intl.message(
      'This option is not avalaible for the demo version.',
      name: 'msg_demo_option',
      desc: '',
      args: [],
    );
  }

  /// `Your demonstration licence has expired, Please subscribe to get the premium version.`
  String get msg_demo_exp {
    return Intl.message(
      'Your demonstration licence has expired, Please subscribe to get the premium version.',
      name: 'msg_demo_exp',
      desc: '',
      args: [],
    );
  }

  /// `Your premium subscription has expired, Please resubscribe to our service.`
  String get msg_premium_exp {
    return Intl.message(
      'Your premium subscription has expired, Please resubscribe to our service.',
      name: 'msg_premium_exp',
      desc: '',
      args: [],
    );
  }

  /// `T.O (Month)`
  String get ca_mois {
    return Intl.message(
      'T.O (Month)',
      name: 'ca_mois',
      desc: '',
      args: [],
    );
  }

  /// `Purchase (Month)`
  String get achat_mois {
    return Intl.message(
      'Purchase (Month)',
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

  /// `Please Select a Country`
  String get intro_select_region {
    return Intl.message(
      'Please Select a Country',
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

  /// `Start date`
  String get start_date {
    return Intl.message(
      'Start date',
      name: 'start_date',
      desc: '',
      args: [],
    );
  }

  /// `End date`
  String get end_date {
    return Intl.message(
      'End date',
      name: 'end_date',
      desc: '',
      args: [],
    );
  }

  /// `Choose a state`
  String get choix_province {
    return Intl.message(
      'Choose a state',
      name: 'choix_province',
      desc: '',
      args: [],
    );
  }

  /// `Choose a city`
  String get choix_city {
    return Intl.message(
      'Choose a city',
      name: 'choix_city',
      desc: '',
      args: [],
    );
  }

  /// `State`
  String get department {
    return Intl.message(
      'State',
      name: 'department',
      desc: '',
      args: [],
    );
  }

  /// `Subscription`
  String get abonnement_title {
    return Intl.message(
      'Subscription',
      name: 'abonnement_title',
      desc: '',
      args: [],
    );
  }

  /// `Unlimited`
  String get illimite {
    return Intl.message(
      'Unlimited',
      name: 'illimite',
      desc: '',
      args: [],
    );
  }

  /// `Number of itmes , invoices , customers , and vendors`
  String get illimite_desc {
    return Intl.message(
      'Number of itmes , invoices , customers , and vendors',
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

  /// `Your invoices in different formats 80mm , 55mm , A4 and A5`
  String get imprime_desc {
    return Intl.message(
      'Your invoices in different formats 80mm , 55mm , A4 and A5',
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

  /// `Upload data to your drive`
  String get save_rest_desc {
    return Intl.message(
      'Upload data to your drive',
      name: 'save_rest_desc',
      desc: '',
      args: [],
    );
  }

  /// `Tap on subscription to restore.`
  String get msg_get_abonnement {
    return Intl.message(
      'Tap on subscription to restore.',
      name: 'msg_get_abonnement',
      desc: '',
      args: [],
    );
  }

  /// `Transform item to`
  String get transformer_title {
    return Intl.message(
      'Transform item to',
      name: 'transformer_title',
      desc: '',
      args: [],
    );
  }

  /// `Select a Currency`
  String get select_devise {
    return Intl.message(
      'Select a Currency',
      name: 'select_devise',
      desc: '',
      args: [],
    );
  }

  /// `Currency`
  String get devise {
    return Intl.message(
      'Currency',
      name: 'devise',
      desc: '',
      args: [],
    );
  }

  /// `Add a discount`
  String get ajout_remise {
    return Intl.message(
      'Add a discount',
      name: 'ajout_remise',
      desc: '',
      args: [],
    );
  }

  /// `Tap here to add a discount on the total amount.`
  String get msg_ajout_remise {
    return Intl.message(
      'Tap here to add a discount on the total amount.',
      name: 'msg_ajout_remise',
      desc: '',
      args: [],
    );
  }

  /// `Add payment`
  String get ajout_verssement {
    return Intl.message(
      'Add payment',
      name: 'ajout_verssement',
      desc: '',
      args: [],
    );
  }

  /// `Tap here to add the amount paid.`
  String get msg_ajout_verssement {
    return Intl.message(
      'Tap here to add the amount paid.',
      name: 'msg_ajout_verssement',
      desc: '',
      args: [],
    );
  }

  /// `Swipe to top`
  String get swipe_top {
    return Intl.message(
      'Swipe to top',
      name: 'swipe_top',
      desc: '',
      args: [],
    );
  }

  /// `To view the calculation details.`
  String get msg_swipe_top {
    return Intl.message(
      'To view the calculation details.',
      name: 'msg_swipe_top',
      desc: '',
      args: [],
    );
  }

  /// `Transform`
  String get transformer {
    return Intl.message(
      'Transform',
      name: 'transformer',
      desc: '',
      args: [],
    );
  }

  /// `Tap here to transform the item into another.`
  String get msg_transformer {
    return Intl.message(
      'Tap here to transform the item into another.',
      name: 'msg_transformer',
      desc: '',
      args: [],
    );
  }

  /// `Swipe`
  String get swipe {
    return Intl.message(
      'Swipe',
      name: 'swipe',
      desc: '',
      args: [],
    );
  }

  /// `to the right and to the left for more options.`
  String get msg_swipe_lr {
    return Intl.message(
      'to the right and to the left for more options.',
      name: 'msg_swipe_lr',
      desc: '',
      args: [],
    );
  }

  /// `from left to delete the element.`
  String get msg_swipe_start {
    return Intl.message(
      'from left to delete the element.',
      name: 'msg_swipe_start',
      desc: '',
      args: [],
    );
  }

  /// `HoldPress`
  String get long_presse {
    return Intl.message(
      'HoldPress',
      name: 'long_presse',
      desc: '',
      args: [],
    );
  }

  /// `on the array element to modify, delete, or add a new one.`
  String get msg_long_presse {
    return Intl.message(
      'on the array element to modify, delete, or add a new one.',
      name: 'msg_long_presse',
      desc: '',
      args: [],
    );
  }

  /// `Demo Version`
  String get demo {
    return Intl.message(
      'Demo Version',
      name: 'demo',
      desc: '',
      args: [],
    );
  }

  /// `Premium Version`
  String get premium {
    return Intl.message(
      'Premium Version',
      name: 'premium',
      desc: '',
      args: [],
    );
  }

  /// `Test Version`
  String get beta {
    return Intl.message(
      'Test Version',
      name: 'beta',
      desc: '',
      args: [],
    );
  }

  /// `Until`
  String get until {
    return Intl.message(
      'Until',
      name: 'until',
      desc: '',
      args: [],
    );
  }

  /// `to deselect the element.`
  String get msg_long_press_select {
    return Intl.message(
      'to deselect the element.',
      name: 'msg_long_press_select',
      desc: '',
      args: [],
    );
  }

  /// `Tap`
  String get tap_element {
    return Intl.message(
      'Tap',
      name: 'tap_element',
      desc: '',
      args: [],
    );
  }

  /// `on the element to edit quantity.`
  String get msg_tap {
    return Intl.message(
      'on the element to edit quantity.',
      name: 'msg_tap',
      desc: '',
      args: [],
    );
  }

  /// `Support`
  String get support {
    return Intl.message(
      'Support',
      name: 'support',
      desc: '',
      args: [],
    );
  }

  /// `Our sales and customer services are at your disposal.`
  String get msg_support {
    return Intl.message(
      'Our sales and customer services are at your disposal.',
      name: 'msg_support',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get economiser {
    return Intl.message(
      'Save',
      name: 'economiser',
      desc: '',
      args: [],
    );
  }

  /// `Sales department`
  String get service_comercial {
    return Intl.message(
      'Sales department',
      name: 'service_comercial',
      desc: '',
      args: [],
    );
  }

  /// `Customer service`
  String get service_technique {
    return Intl.message(
      'Customer service',
      name: 'service_technique',
      desc: '',
      args: [],
    );
  }

  /// `Signaled / Book a ticket`
  String get service_ticket {
    return Intl.message(
      'Signaled / Book a ticket',
      name: 'service_ticket',
      desc: '',
      args: [],
    );
  }

  /// `Get a ticket`
  String get get_ticket {
    return Intl.message(
      'Get a ticket',
      name: 'get_ticket',
      desc: '',
      args: [],
    );
  }

  /// `No\nSubscription`
  String get no_abonnement {
    return Intl.message(
      'No\nSubscription',
      name: 'no_abonnement',
      desc: '',
      args: [],
    );
  }

  /// `No items found`
  String get no_element {
    return Intl.message(
      'No items found',
      name: 'no_element',
      desc: '',
      args: [],
    );
  }

  /// `The list is currently empty.`
  String get liste_vide {
    return Intl.message(
      'The list is currently empty.',
      name: 'liste_vide',
      desc: '',
      args: [],
    );
  }

  /// `< Min Qte`
  String get non_stocke {
    return Intl.message(
      '< Min Qte',
      name: 'non_stocke',
      desc: '',
      args: [],
    );
  }

  /// `Unable to delete an item that has movement.`
  String get msg_article_utilise {
    return Intl.message(
      'Unable to delete an item that has movement.',
      name: 'msg_article_utilise',
      desc: '',
      args: [],
    );
  }

  /// `T.O`
  String get ca {
    return Intl.message(
      'T.O',
      name: 'ca',
      desc: '',
      args: [],
    );
  }

  /// `The total is less than or equal to the amount already paid.`
  String get msg_versement_err {
    return Intl.message(
      'The total is less than or equal to the amount already paid.',
      name: 'msg_versement_err',
      desc: '',
      args: [],
    );
  }

  /// `Please note that the available quantity is equal to zero.`
  String get msg_qte_zero {
    return Intl.message(
      'Please note that the available quantity is equal to zero.',
      name: 'msg_qte_zero',
      desc: '',
      args: [],
    );
  }

  /// `Please note that the desired quantity is greater than the available quantity.`
  String get msg_qte_select_sup {
    return Intl.message(
      'Please note that the desired quantity is greater than the available quantity.',
      name: 'msg_qte_select_sup',
      desc: '',
      args: [],
    );
  }

  /// `You can't edit a transformed invoice.`
  String get msg_no_edit_transformer {
    return Intl.message(
      'You can\'t edit a transformed invoice.',
      name: 'msg_no_edit_transformer',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get tarif_s {
    return Intl.message(
      'Price',
      name: 'tarif_s',
      desc: '',
      args: [],
    );
  }

  /// `Number of prices to use:`
  String get titre_dialog_tarification {
    return Intl.message(
      'Number of prices to use:',
      name: 'titre_dialog_tarification',
      desc: '',
      args: [],
    );
  }

  /// `Item transform to`
  String get msg_piece_transformer_to {
    return Intl.message(
      'Item transform to',
      name: 'msg_piece_transformer_to',
      desc: '',
      args: [],
    );
  }

  /// `Item from`
  String get msg_piece_transformer_from {
    return Intl.message(
      'Item from',
      name: 'msg_piece_transformer_from',
      desc: '',
      args: [],
    );
  }

  /// `Print A4/A5`
  String get lan_print {
    return Intl.message(
      'Print A4/A5',
      name: 'lan_print',
      desc: '',
      args: [],
    );
  }

  /// `Export as pdf`
  String get export_pdf {
    return Intl.message(
      'Export as pdf',
      name: 'export_pdf',
      desc: '',
      args: [],
    );
  }

  /// `Centimes`
  String get centimes {
    return Intl.message(
      'Centimes',
      name: 'centimes',
      desc: '',
      args: [],
    );
  }

  /// `Centime`
  String get centime {
    return Intl.message(
      'Centime',
      name: 'centime',
      desc: '',
      args: [],
    );
  }

  /// `Cents`
  String get cents {
    return Intl.message(
      'Cents',
      name: 'cents',
      desc: '',
      args: [],
    );
  }

  /// `Cent`
  String get cent {
    return Intl.message(
      'Cent',
      name: 'cent',
      desc: '',
      args: [],
    );
  }

  /// `Millimes`
  String get millimes {
    return Intl.message(
      'Millimes',
      name: 'millimes',
      desc: '',
      args: [],
    );
  }

  /// `Millime`
  String get millime {
    return Intl.message(
      'Millime',
      name: 'millime',
      desc: '',
      args: [],
    );
  }

  /// `Algerian dinar`
  String get DZD_name {
    return Intl.message(
      'Algerian dinar',
      name: 'DZD_name',
      desc: '',
      args: [],
    );
  }

  /// `Afghan afghani`
  String get AFN_name {
    return Intl.message(
      'Afghan afghani',
      name: 'AFN_name',
      desc: '',
      args: [],
    );
  }

  /// `Euro`
  String get EUR_name {
    return Intl.message(
      'Euro',
      name: 'EUR_name',
      desc: '',
      args: [],
    );
  }

  /// `Albanian lek`
  String get ALL_name {
    return Intl.message(
      'Albanian lek',
      name: 'ALL_name',
      desc: '',
      args: [],
    );
  }

  /// `United State Dollar`
  String get USD_name {
    return Intl.message(
      'United State Dollar',
      name: 'USD_name',
      desc: '',
      args: [],
    );
  }

  /// `Angolan kwanza`
  String get AOA_name {
    return Intl.message(
      'Angolan kwanza',
      name: 'AOA_name',
      desc: '',
      args: [],
    );
  }

  /// `East Caribbean dollar`
  String get XCD_name {
    return Intl.message(
      'East Caribbean dollar',
      name: 'XCD_name',
      desc: '',
      args: [],
    );
  }

  /// `Australian dollar`
  String get AUD_name {
    return Intl.message(
      'Australian dollar',
      name: 'AUD_name',
      desc: '',
      args: [],
    );
  }

  /// `Argentine peso`
  String get ARS_name {
    return Intl.message(
      'Argentine peso',
      name: 'ARS_name',
      desc: '',
      args: [],
    );
  }

  /// `Armenian dram`
  String get AMD_name {
    return Intl.message(
      'Armenian dram',
      name: 'AMD_name',
      desc: '',
      args: [],
    );
  }

  /// `Aruban florin`
  String get AWG_name {
    return Intl.message(
      'Aruban florin',
      name: 'AWG_name',
      desc: '',
      args: [],
    );
  }

  /// `Azerbaijani manat`
  String get AZN_name {
    return Intl.message(
      'Azerbaijani manat',
      name: 'AZN_name',
      desc: '',
      args: [],
    );
  }

  /// `Bahamian dollar`
  String get BSD_name {
    return Intl.message(
      'Bahamian dollar',
      name: 'BSD_name',
      desc: '',
      args: [],
    );
  }

  /// `Bahraini dinar`
  String get BHD_name {
    return Intl.message(
      'Bahraini dinar',
      name: 'BHD_name',
      desc: '',
      args: [],
    );
  }

  /// `Bangladeshi taka`
  String get BDT_name {
    return Intl.message(
      'Bangladeshi taka',
      name: 'BDT_name',
      desc: '',
      args: [],
    );
  }

  /// `Barbadian dollar`
  String get BBD_name {
    return Intl.message(
      'Barbadian dollar',
      name: 'BBD_name',
      desc: '',
      args: [],
    );
  }

  /// `New Belarusian ruble`
  String get BYN_name {
    return Intl.message(
      'New Belarusian ruble',
      name: 'BYN_name',
      desc: '',
      args: [],
    );
  }

  /// `Belize dollar`
  String get BZD_name {
    return Intl.message(
      'Belize dollar',
      name: 'BZD_name',
      desc: '',
      args: [],
    );
  }

  /// `West African CFA franc`
  String get XOF_name {
    return Intl.message(
      'West African CFA franc',
      name: 'XOF_name',
      desc: '',
      args: [],
    );
  }

  /// `Bermudian dollar`
  String get BMD_name {
    return Intl.message(
      'Bermudian dollar',
      name: 'BMD_name',
      desc: '',
      args: [],
    );
  }

  /// `Bhutanese ngultrum`
  String get BTN_name {
    return Intl.message(
      'Bhutanese ngultrum',
      name: 'BTN_name',
      desc: '',
      args: [],
    );
  }

  /// `Bolivian boliviano`
  String get BOB_name {
    return Intl.message(
      'Bolivian boliviano',
      name: 'BOB_name',
      desc: '',
      args: [],
    );
  }

  /// `Bosnia and Herzegovina convertible mark`
  String get BAM_name {
    return Intl.message(
      'Bosnia and Herzegovina convertible mark',
      name: 'BAM_name',
      desc: '',
      args: [],
    );
  }

  /// `Botswana pula`
  String get BWP_name {
    return Intl.message(
      'Botswana pula',
      name: 'BWP_name',
      desc: '',
      args: [],
    );
  }

  /// `Norwegian krone`
  String get NOK_name {
    return Intl.message(
      'Norwegian krone',
      name: 'NOK_name',
      desc: '',
      args: [],
    );
  }

  /// `Brazilian real`
  String get BRL_name {
    return Intl.message(
      'Brazilian real',
      name: 'BRL_name',
      desc: '',
      args: [],
    );
  }

  /// `Brunei dollar`
  String get BND_name {
    return Intl.message(
      'Brunei dollar',
      name: 'BND_name',
      desc: '',
      args: [],
    );
  }

  /// `Bulgarian lev`
  String get BGN_name {
    return Intl.message(
      'Bulgarian lev',
      name: 'BGN_name',
      desc: '',
      args: [],
    );
  }

  /// `Burundian franc`
  String get BIF_name {
    return Intl.message(
      'Burundian franc',
      name: 'BIF_name',
      desc: '',
      args: [],
    );
  }

  /// `Cambodian riel`
  String get KHR_name {
    return Intl.message(
      'Cambodian riel',
      name: 'KHR_name',
      desc: '',
      args: [],
    );
  }

  /// `Canadian dollar`
  String get CAD_name {
    return Intl.message(
      'Canadian dollar',
      name: 'CAD_name',
      desc: '',
      args: [],
    );
  }

  /// `Cape Verdean escudo`
  String get CVE_name {
    return Intl.message(
      'Cape Verdean escudo',
      name: 'CVE_name',
      desc: '',
      args: [],
    );
  }

  /// `Cayman Islands dollar`
  String get KYD_name {
    return Intl.message(
      'Cayman Islands dollar',
      name: 'KYD_name',
      desc: '',
      args: [],
    );
  }

  /// `Chilean peso`
  String get CLP_name {
    return Intl.message(
      'Chilean peso',
      name: 'CLP_name',
      desc: '',
      args: [],
    );
  }

  /// `Chinese yuan`
  String get CNY_name {
    return Intl.message(
      'Chinese yuan',
      name: 'CNY_name',
      desc: '',
      args: [],
    );
  }

  /// `Colombian peso`
  String get COP_name {
    return Intl.message(
      'Colombian peso',
      name: 'COP_name',
      desc: '',
      args: [],
    );
  }

  /// `Comorian franc`
  String get KMF_name {
    return Intl.message(
      'Comorian franc',
      name: 'KMF_name',
      desc: '',
      args: [],
    );
  }

  /// `Congolese franc`
  String get CDF_name {
    return Intl.message(
      'Congolese franc',
      name: 'CDF_name',
      desc: '',
      args: [],
    );
  }

  /// `New Zealand dollar`
  String get NZD_name {
    return Intl.message(
      'New Zealand dollar',
      name: 'NZD_name',
      desc: '',
      args: [],
    );
  }

  /// `Costa Rican colón`
  String get CRC_name {
    return Intl.message(
      'Costa Rican colón',
      name: 'CRC_name',
      desc: '',
      args: [],
    );
  }

  /// `Croatian kuna`
  String get HRK_name {
    return Intl.message(
      'Croatian kuna',
      name: 'HRK_name',
      desc: '',
      args: [],
    );
  }

  /// `Cuban convertible peso`
  String get CUC_name {
    return Intl.message(
      'Cuban convertible peso',
      name: 'CUC_name',
      desc: '',
      args: [],
    );
  }

  /// `Netherlands Antillean guilder`
  String get ANG_name {
    return Intl.message(
      'Netherlands Antillean guilder',
      name: 'ANG_name',
      desc: '',
      args: [],
    );
  }

  /// `Czech koruna`
  String get CZK_name {
    return Intl.message(
      'Czech koruna',
      name: 'CZK_name',
      desc: '',
      args: [],
    );
  }

  /// `Danish krone`
  String get DKK_name {
    return Intl.message(
      'Danish krone',
      name: 'DKK_name',
      desc: '',
      args: [],
    );
  }

  /// `Djiboutian franc`
  String get DJF_name {
    return Intl.message(
      'Djiboutian franc',
      name: 'DJF_name',
      desc: '',
      args: [],
    );
  }

  /// `Dominican peso`
  String get DOP_name {
    return Intl.message(
      'Dominican peso',
      name: 'DOP_name',
      desc: '',
      args: [],
    );
  }

  /// `Egyptian pound`
  String get EGP_name {
    return Intl.message(
      'Egyptian pound',
      name: 'EGP_name',
      desc: '',
      args: [],
    );
  }

  /// `Eritrean nakfa`
  String get ERN_name {
    return Intl.message(
      'Eritrean nakfa',
      name: 'ERN_name',
      desc: '',
      args: [],
    );
  }

  /// `Ethiopian birr`
  String get ETB_name {
    return Intl.message(
      'Ethiopian birr',
      name: 'ETB_name',
      desc: '',
      args: [],
    );
  }

  /// `Falkland Islands pound`
  String get FKP_name {
    return Intl.message(
      'Falkland Islands pound',
      name: 'FKP_name',
      desc: '',
      args: [],
    );
  }

  /// `Fijian dollar`
  String get FJD_name {
    return Intl.message(
      'Fijian dollar',
      name: 'FJD_name',
      desc: '',
      args: [],
    );
  }

  /// `CFP franc`
  String get XPF_name {
    return Intl.message(
      'CFP franc',
      name: 'XPF_name',
      desc: '',
      args: [],
    );
  }

  /// `Gambian dalasi`
  String get GMD_name {
    return Intl.message(
      'Gambian dalasi',
      name: 'GMD_name',
      desc: '',
      args: [],
    );
  }

  /// `Georgian Lari`
  String get GEL_name {
    return Intl.message(
      'Georgian Lari',
      name: 'GEL_name',
      desc: '',
      args: [],
    );
  }

  /// `Ghanaian cedi`
  String get GHS_name {
    return Intl.message(
      'Ghanaian cedi',
      name: 'GHS_name',
      desc: '',
      args: [],
    );
  }

  /// `Gibraltar pound`
  String get GIP_name {
    return Intl.message(
      'Gibraltar pound',
      name: 'GIP_name',
      desc: '',
      args: [],
    );
  }

  /// `Guatemalan quetzal`
  String get GTQ_name {
    return Intl.message(
      'Guatemalan quetzal',
      name: 'GTQ_name',
      desc: '',
      args: [],
    );
  }

  /// `British pound`
  String get GBP_name {
    return Intl.message(
      'British pound',
      name: 'GBP_name',
      desc: '',
      args: [],
    );
  }

  /// `Guinean franc`
  String get GNF_name {
    return Intl.message(
      'Guinean franc',
      name: 'GNF_name',
      desc: '',
      args: [],
    );
  }

  /// `Guyanese dollar`
  String get GYD_name {
    return Intl.message(
      'Guyanese dollar',
      name: 'GYD_name',
      desc: '',
      args: [],
    );
  }

  /// `Haitian gourde`
  String get HTG_name {
    return Intl.message(
      'Haitian gourde',
      name: 'HTG_name',
      desc: '',
      args: [],
    );
  }

  /// `Honduran lempira`
  String get HNL_name {
    return Intl.message(
      'Honduran lempira',
      name: 'HNL_name',
      desc: '',
      args: [],
    );
  }

  /// `Hong Kong dollar`
  String get HKD_name {
    return Intl.message(
      'Hong Kong dollar',
      name: 'HKD_name',
      desc: '',
      args: [],
    );
  }

  /// `Hungarian forint`
  String get HUF_name {
    return Intl.message(
      'Hungarian forint',
      name: 'HUF_name',
      desc: '',
      args: [],
    );
  }

  /// `Icelandic króna`
  String get ISK_name {
    return Intl.message(
      'Icelandic króna',
      name: 'ISK_name',
      desc: '',
      args: [],
    );
  }

  /// `Indian rupee`
  String get INR_name {
    return Intl.message(
      'Indian rupee',
      name: 'INR_name',
      desc: '',
      args: [],
    );
  }

  /// `Indonesian rupiah`
  String get IDR_name {
    return Intl.message(
      'Indonesian rupiah',
      name: 'IDR_name',
      desc: '',
      args: [],
    );
  }

  /// `Iranian rial`
  String get IRR_name {
    return Intl.message(
      'Iranian rial',
      name: 'IRR_name',
      desc: '',
      args: [],
    );
  }

  /// `Iraqi dinar`
  String get IQD_name {
    return Intl.message(
      'Iraqi dinar',
      name: 'IQD_name',
      desc: '',
      args: [],
    );
  }

  /// `Jamaican dollar`
  String get JMD_name {
    return Intl.message(
      'Jamaican dollar',
      name: 'JMD_name',
      desc: '',
      args: [],
    );
  }

  /// `Japanese yen`
  String get JPY_name {
    return Intl.message(
      'Japanese yen',
      name: 'JPY_name',
      desc: '',
      args: [],
    );
  }

  /// `Jordanian dinar`
  String get JOD_name {
    return Intl.message(
      'Jordanian dinar',
      name: 'JOD_name',
      desc: '',
      args: [],
    );
  }

  /// `Kazakhstani tenge`
  String get KZT_name {
    return Intl.message(
      'Kazakhstani tenge',
      name: 'KZT_name',
      desc: '',
      args: [],
    );
  }

  /// `Kenyan shilling`
  String get KES_name {
    return Intl.message(
      'Kenyan shilling',
      name: 'KES_name',
      desc: '',
      args: [],
    );
  }

  /// `Kuwaiti dinar`
  String get KWD_name {
    return Intl.message(
      'Kuwaiti dinar',
      name: 'KWD_name',
      desc: '',
      args: [],
    );
  }

  /// `Kyrgyzstani som`
  String get KGS_name {
    return Intl.message(
      'Kyrgyzstani som',
      name: 'KGS_name',
      desc: '',
      args: [],
    );
  }

  /// `Lao kip`
  String get LAK_name {
    return Intl.message(
      'Lao kip',
      name: 'LAK_name',
      desc: '',
      args: [],
    );
  }

  /// `Lebanese pound`
  String get LBP_name {
    return Intl.message(
      'Lebanese pound',
      name: 'LBP_name',
      desc: '',
      args: [],
    );
  }

  /// `Lesotho loti`
  String get LSL_name {
    return Intl.message(
      'Lesotho loti',
      name: 'LSL_name',
      desc: '',
      args: [],
    );
  }

  /// `Liberian dollar`
  String get LRD_name {
    return Intl.message(
      'Liberian dollar',
      name: 'LRD_name',
      desc: '',
      args: [],
    );
  }

  /// `Libyan dinar`
  String get LYD_name {
    return Intl.message(
      'Libyan dinar',
      name: 'LYD_name',
      desc: '',
      args: [],
    );
  }

  /// `Swiss franc`
  String get CHF_name {
    return Intl.message(
      'Swiss franc',
      name: 'CHF_name',
      desc: '',
      args: [],
    );
  }

  /// `Macanese pataca`
  String get MOP_name {
    return Intl.message(
      'Macanese pataca',
      name: 'MOP_name',
      desc: '',
      args: [],
    );
  }

  /// `Macedonian denar`
  String get MKD_name {
    return Intl.message(
      'Macedonian denar',
      name: 'MKD_name',
      desc: '',
      args: [],
    );
  }

  /// `Malagasy ariary`
  String get MGA_name {
    return Intl.message(
      'Malagasy ariary',
      name: 'MGA_name',
      desc: '',
      args: [],
    );
  }

  /// `Malawian kwacha`
  String get MWK_name {
    return Intl.message(
      'Malawian kwacha',
      name: 'MWK_name',
      desc: '',
      args: [],
    );
  }

  /// `Malaysian ringgit`
  String get MYR_name {
    return Intl.message(
      'Malaysian ringgit',
      name: 'MYR_name',
      desc: '',
      args: [],
    );
  }

  /// `Maldivian rufiyaa`
  String get MVR_name {
    return Intl.message(
      'Maldivian rufiyaa',
      name: 'MVR_name',
      desc: '',
      args: [],
    );
  }

  /// `Mauritanian ouguiya`
  String get MRO_name {
    return Intl.message(
      'Mauritanian ouguiya',
      name: 'MRO_name',
      desc: '',
      args: [],
    );
  }

  /// `Mauritian rupee`
  String get MUR_name {
    return Intl.message(
      'Mauritian rupee',
      name: 'MUR_name',
      desc: '',
      args: [],
    );
  }

  /// `Mexican peso`
  String get MXN_name {
    return Intl.message(
      'Mexican peso',
      name: 'MXN_name',
      desc: '',
      args: [],
    );
  }

  /// `[D]`
  String get None_name {
    return Intl.message(
      '[D]',
      name: 'None_name',
      desc: '',
      args: [],
    );
  }

  /// `Moldovan leu`
  String get MDL_name {
    return Intl.message(
      'Moldovan leu',
      name: 'MDL_name',
      desc: '',
      args: [],
    );
  }

  /// `Mongolian tögrög`
  String get MNT_name {
    return Intl.message(
      'Mongolian tögrög',
      name: 'MNT_name',
      desc: '',
      args: [],
    );
  }

  /// `Moroccan dirham`
  String get MAD_name {
    return Intl.message(
      'Moroccan dirham',
      name: 'MAD_name',
      desc: '',
      args: [],
    );
  }

  /// `Mozambican metical`
  String get MZN_name {
    return Intl.message(
      'Mozambican metical',
      name: 'MZN_name',
      desc: '',
      args: [],
    );
  }

  /// `Burmese kyat`
  String get MMK_name {
    return Intl.message(
      'Burmese kyat',
      name: 'MMK_name',
      desc: '',
      args: [],
    );
  }

  /// `Namibian dollar`
  String get NAD_name {
    return Intl.message(
      'Namibian dollar',
      name: 'NAD_name',
      desc: '',
      args: [],
    );
  }

  /// `Nepalese rupee`
  String get NPR_name {
    return Intl.message(
      'Nepalese rupee',
      name: 'NPR_name',
      desc: '',
      args: [],
    );
  }

  /// `Nicaraguan córdoba`
  String get NIO_name {
    return Intl.message(
      'Nicaraguan córdoba',
      name: 'NIO_name',
      desc: '',
      args: [],
    );
  }

  /// `Nigerian naira`
  String get NGN_name {
    return Intl.message(
      'Nigerian naira',
      name: 'NGN_name',
      desc: '',
      args: [],
    );
  }

  /// `North Korean won`
  String get KPW_name {
    return Intl.message(
      'North Korean won',
      name: 'KPW_name',
      desc: '',
      args: [],
    );
  }

  /// `Omani rial`
  String get OMR_name {
    return Intl.message(
      'Omani rial',
      name: 'OMR_name',
      desc: '',
      args: [],
    );
  }

  /// `Pakistani rupee`
  String get PKR_name {
    return Intl.message(
      'Pakistani rupee',
      name: 'PKR_name',
      desc: '',
      args: [],
    );
  }

  /// `Israeli new sheqel`
  String get ILS_name {
    return Intl.message(
      'Israeli new sheqel',
      name: 'ILS_name',
      desc: '',
      args: [],
    );
  }

  /// `Panamanian balboa`
  String get PAB_name {
    return Intl.message(
      'Panamanian balboa',
      name: 'PAB_name',
      desc: '',
      args: [],
    );
  }

  /// `Papua New Guinean kina`
  String get PGK_name {
    return Intl.message(
      'Papua New Guinean kina',
      name: 'PGK_name',
      desc: '',
      args: [],
    );
  }

  /// `Paraguayan guaraní`
  String get PYG_name {
    return Intl.message(
      'Paraguayan guaraní',
      name: 'PYG_name',
      desc: '',
      args: [],
    );
  }

  /// `Peruvian sol`
  String get PEN_name {
    return Intl.message(
      'Peruvian sol',
      name: 'PEN_name',
      desc: '',
      args: [],
    );
  }

  /// `Philippine peso`
  String get PHP_name {
    return Intl.message(
      'Philippine peso',
      name: 'PHP_name',
      desc: '',
      args: [],
    );
  }

  /// `Polish złoty`
  String get PLN_name {
    return Intl.message(
      'Polish złoty',
      name: 'PLN_name',
      desc: '',
      args: [],
    );
  }

  /// `Qatari riyal`
  String get QAR_name {
    return Intl.message(
      'Qatari riyal',
      name: 'QAR_name',
      desc: '',
      args: [],
    );
  }

  /// `Romanian leu`
  String get RON_name {
    return Intl.message(
      'Romanian leu',
      name: 'RON_name',
      desc: '',
      args: [],
    );
  }

  /// `Russian ruble`
  String get RUB_name {
    return Intl.message(
      'Russian ruble',
      name: 'RUB_name',
      desc: '',
      args: [],
    );
  }

  /// `Rwandan franc`
  String get RWF_name {
    return Intl.message(
      'Rwandan franc',
      name: 'RWF_name',
      desc: '',
      args: [],
    );
  }

  /// `Saint Helena pound`
  String get SHP_name {
    return Intl.message(
      'Saint Helena pound',
      name: 'SHP_name',
      desc: '',
      args: [],
    );
  }

  /// `Samoan tālā`
  String get WST_name {
    return Intl.message(
      'Samoan tālā',
      name: 'WST_name',
      desc: '',
      args: [],
    );
  }

  /// `São Tomé and Príncipe dobra`
  String get STD_name {
    return Intl.message(
      'São Tomé and Príncipe dobra',
      name: 'STD_name',
      desc: '',
      args: [],
    );
  }

  /// `Saudi riyal`
  String get SAR_name {
    return Intl.message(
      'Saudi riyal',
      name: 'SAR_name',
      desc: '',
      args: [],
    );
  }

  /// `Serbian dinar`
  String get RSD_name {
    return Intl.message(
      'Serbian dinar',
      name: 'RSD_name',
      desc: '',
      args: [],
    );
  }

  /// `Seychellois rupee`
  String get SCR_name {
    return Intl.message(
      'Seychellois rupee',
      name: 'SCR_name',
      desc: '',
      args: [],
    );
  }

  /// `Sierra Leonean leone`
  String get SLL_name {
    return Intl.message(
      'Sierra Leonean leone',
      name: 'SLL_name',
      desc: '',
      args: [],
    );
  }

  /// `Singapore dollar`
  String get SGD_name {
    return Intl.message(
      'Singapore dollar',
      name: 'SGD_name',
      desc: '',
      args: [],
    );
  }

  /// `Solomon Islands dollar`
  String get SBD_name {
    return Intl.message(
      'Solomon Islands dollar',
      name: 'SBD_name',
      desc: '',
      args: [],
    );
  }

  /// `Somali shilling`
  String get SOS_name {
    return Intl.message(
      'Somali shilling',
      name: 'SOS_name',
      desc: '',
      args: [],
    );
  }

  /// `South African rand`
  String get ZAR_name {
    return Intl.message(
      'South African rand',
      name: 'ZAR_name',
      desc: '',
      args: [],
    );
  }

  /// `South Korean won`
  String get KRW_name {
    return Intl.message(
      'South Korean won',
      name: 'KRW_name',
      desc: '',
      args: [],
    );
  }

  /// `South Sudanese pound`
  String get SSP_name {
    return Intl.message(
      'South Sudanese pound',
      name: 'SSP_name',
      desc: '',
      args: [],
    );
  }

  /// `Sri Lankan rupee`
  String get LKR_name {
    return Intl.message(
      'Sri Lankan rupee',
      name: 'LKR_name',
      desc: '',
      args: [],
    );
  }

  /// `Sudanese pound`
  String get SDG_name {
    return Intl.message(
      'Sudanese pound',
      name: 'SDG_name',
      desc: '',
      args: [],
    );
  }

  /// `Surinamese dollar`
  String get SRD_name {
    return Intl.message(
      'Surinamese dollar',
      name: 'SRD_name',
      desc: '',
      args: [],
    );
  }

  /// `Swazi lilangeni`
  String get SZL_name {
    return Intl.message(
      'Swazi lilangeni',
      name: 'SZL_name',
      desc: '',
      args: [],
    );
  }

  /// `Swedish krona`
  String get SEK_name {
    return Intl.message(
      'Swedish krona',
      name: 'SEK_name',
      desc: '',
      args: [],
    );
  }

  /// `Syrian pound`
  String get SYP_name {
    return Intl.message(
      'Syrian pound',
      name: 'SYP_name',
      desc: '',
      args: [],
    );
  }

  /// `New Taiwan dollar`
  String get TWD_name {
    return Intl.message(
      'New Taiwan dollar',
      name: 'TWD_name',
      desc: '',
      args: [],
    );
  }

  /// `Tajikistani somoni`
  String get TJS_name {
    return Intl.message(
      'Tajikistani somoni',
      name: 'TJS_name',
      desc: '',
      args: [],
    );
  }

  /// `Tanzanian shilling`
  String get TZS_name {
    return Intl.message(
      'Tanzanian shilling',
      name: 'TZS_name',
      desc: '',
      args: [],
    );
  }

  /// `Thai baht`
  String get THB {
    return Intl.message(
      'Thai baht',
      name: 'THB',
      desc: '',
      args: [],
    );
  }

  /// `Tongan paʻanga`
  String get TOP_name {
    return Intl.message(
      'Tongan paʻanga',
      name: 'TOP_name',
      desc: '',
      args: [],
    );
  }

  /// `Trinidad and Tobago dollar`
  String get TTD_name {
    return Intl.message(
      'Trinidad and Tobago dollar',
      name: 'TTD_name',
      desc: '',
      args: [],
    );
  }

  /// `Tunisian dinar`
  String get TND_name {
    return Intl.message(
      'Tunisian dinar',
      name: 'TND_name',
      desc: '',
      args: [],
    );
  }

  /// `Turkish lira`
  String get TRY_name {
    return Intl.message(
      'Turkish lira',
      name: 'TRY_name',
      desc: '',
      args: [],
    );
  }

  /// `Turkmenistan manat`
  String get TMT_name {
    return Intl.message(
      'Turkmenistan manat',
      name: 'TMT_name',
      desc: '',
      args: [],
    );
  }

  /// `Ukrainian hryvnia`
  String get UAH_name {
    return Intl.message(
      'Ukrainian hryvnia',
      name: 'UAH_name',
      desc: '',
      args: [],
    );
  }

  /// `United Arab Emirates dirham`
  String get AED_name {
    return Intl.message(
      'United Arab Emirates dirham',
      name: 'AED_name',
      desc: '',
      args: [],
    );
  }

  /// `Uruguayan peso`
  String get UYU_name {
    return Intl.message(
      'Uruguayan peso',
      name: 'UYU_name',
      desc: '',
      args: [],
    );
  }

  /// `Uzbekistani so'm`
  String get UZS_name {
    return Intl.message(
      'Uzbekistani so\'m',
      name: 'UZS_name',
      desc: '',
      args: [],
    );
  }

  /// `Vanuatu vatu`
  String get VUV_name {
    return Intl.message(
      'Vanuatu vatu',
      name: 'VUV_name',
      desc: '',
      args: [],
    );
  }

  /// `Venezuelan bolívar`
  String get VEF_name {
    return Intl.message(
      'Venezuelan bolívar',
      name: 'VEF_name',
      desc: '',
      args: [],
    );
  }

  /// `Vietnamese đồng`
  String get VND_name {
    return Intl.message(
      'Vietnamese đồng',
      name: 'VND_name',
      desc: '',
      args: [],
    );
  }

  /// `Yemeni rial`
  String get YER_name {
    return Intl.message(
      'Yemeni rial',
      name: 'YER_name',
      desc: '',
      args: [],
    );
  }

  /// `Zambian kwacha`
  String get ZMW_name {
    return Intl.message(
      'Zambian kwacha',
      name: 'ZMW_name',
      desc: '',
      args: [],
    );
  }

  /// `Central African CFA franc`
  String get XAF_name {
    return Intl.message(
      'Central African CFA franc',
      name: 'XAF_name',
      desc: '',
      args: [],
    );
  }

  /// `Thai baht`
  String get THB_name {
    return Intl.message(
      'Thai baht',
      name: 'THB_name',
      desc: '',
      args: [],
    );
  }

  /// `Ugandan shilling`
  String get UGX_name {
    return Intl.message(
      'Ugandan shilling',
      name: 'UGX_name',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to change the price variants?`
  String get msg_change_tarif {
    return Intl.message(
      'Do you want to change the price variants?',
      name: 'msg_change_tarif',
      desc: '',
      args: [],
    );
  }

  /// `Loading`
  String get chargement {
    return Intl.message(
      'Loading',
      name: 'chargement',
      desc: '',
      args: [],
    );
  }

  /// `Service`
  String get service {
    return Intl.message(
      'Service',
      name: 'service',
      desc: '',
      args: [],
    );
  }

  /// `Not Storable`
  String get non_stockable {
    return Intl.message(
      'Not Storable',
      name: 'non_stockable',
      desc: '',
      args: [],
    );
  }

  /// `Tables`
  String get famille_marque {
    return Intl.message(
      'Tables',
      name: 'famille_marque',
      desc: '',
      args: [],
    );
  }

  /// `Item Families`
  String get famille_article {
    return Intl.message(
      'Item Families',
      name: 'famille_article',
      desc: '',
      args: [],
    );
  }

  /// `Item Brands`
  String get marque_article {
    return Intl.message(
      'Item Brands',
      name: 'marque_article',
      desc: '',
      args: [],
    );
  }

  /// `VAT Rate`
  String get tva_article {
    return Intl.message(
      'VAT Rate',
      name: 'tva_article',
      desc: '',
      args: [],
    );
  }

  /// `Families of third parties`
  String get famille_tiers {
    return Intl.message(
      'Families of third parties',
      name: 'famille_tiers',
      desc: '',
      args: [],
    );
  }

  /// `Fees categories`
  String get cat_charge {
    return Intl.message(
      'Fees categories',
      name: 'cat_charge',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to quit without saving the last changes?`
  String get msg_retour_no_save {
    return Intl.message(
      'Do you want to quit without saving the last changes?',
      name: 'msg_retour_no_save',
      desc: '',
      args: [],
    );
  }

  /// `Tap on the map to pick a position.`
  String get msg_map_add_position {
    return Intl.message(
      'Tap on the map to pick a position.',
      name: 'msg_map_add_position',
      desc: '',
      args: [],
    );
  }

  /// `Key`
  String get code_pin1 {
    return Intl.message(
      'Key',
      name: 'code_pin1',
      desc: '',
      args: [],
    );
  }

  /// `Item already exists.`
  String get msg_existe_deja {
    return Intl.message(
      'Item already exists.',
      name: 'msg_existe_deja',
      desc: '',
      args: [],
    );
  }

  /// `Accountes`
  String get caisse_titre {
    return Intl.message(
      'Accountes',
      name: 'caisse_titre',
      desc: '',
      args: [],
    );
  }

  /// `Downloading`
  String get telechargement {
    return Intl.message(
      'Downloading',
      name: 'telechargement',
      desc: '',
      args: [],
    );
  }

  /// `Average price`
  String get prix_moyen {
    return Intl.message(
      'Average price',
      name: 'prix_moyen',
      desc: '',
      args: [],
    );
  }

  /// `The value must be greater than zero.`
  String get msg_prix_supp_zero {
    return Intl.message(
      'The value must be greater than zero.',
      name: 'msg_prix_supp_zero',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid number.`
  String get msg_val_valide {
    return Intl.message(
      'Enter a valid number.',
      name: 'msg_val_valide',
      desc: '',
      args: [],
    );
  }

  /// `Amount (excl. tax)`
  String get montant_ht {
    return Intl.message(
      'Amount (excl. tax)',
      name: 'montant_ht',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Not defined`
  String get no_defenie {
    return Intl.message(
      'Not defined',
      name: 'no_defenie',
      desc: '',
      args: [],
    );
  }

  /// `Stop this document at the sum of:`
  String get msg_arret_somme {
    return Intl.message(
      'Stop this document at the sum of:',
      name: 'msg_arret_somme',
      desc: '',
      args: [],
    );
  }

  /// `Price variants`
  String get tarifs {
    return Intl.message(
      'Price variants',
      name: 'tarifs',
      desc: '',
      args: [],
    );
  }

  /// `Scan your fingerprint to authenticate.`
  String get msg_scaner_empreinte {
    return Intl.message(
      'Scan your fingerprint to authenticate.',
      name: 'msg_scaner_empreinte',
      desc: '',
      args: [],
    );
  }

  /// `Authentication`
  String get titre_auth_empreinte {
    return Intl.message(
      'Authentication',
      name: 'titre_auth_empreinte',
      desc: '',
      args: [],
    );
  }

  /// `Go to settings.`
  String get msg_config_auth {
    return Intl.message(
      'Go to settings.',
      name: 'msg_config_auth',
      desc: '',
      args: [],
    );
  }

  /// `Biometric authentication is disabled.`
  String get msg_aut_lockout {
    return Intl.message(
      'Biometric authentication is disabled.',
      name: 'msg_aut_lockout',
      desc: '',
      args: [],
    );
  }

  /// `Fingerprint has been recognized.`
  String get msg_auth_success {
    return Intl.message(
      'Fingerprint has been recognized.',
      name: 'msg_auth_success',
      desc: '',
      args: [],
    );
  }

  /// `Fingerprint not recognized, Try again!`
  String get msg_auth_fail {
    return Intl.message(
      'Fingerprint not recognized, Try again!',
      name: 'msg_auth_fail',
      desc: '',
      args: [],
    );
  }

  /// `Invoice always paid`
  String get auto_verssment {
    return Intl.message(
      'Invoice always paid',
      name: 'auto_verssment',
      desc: '',
      args: [],
    );
  }

  /// `P`
  String get colis_abr {
    return Intl.message(
      'P',
      name: 'colis_abr',
      desc: '',
      args: [],
    );
  }

  /// `unit`
  String get unite {
    return Intl.message(
      'unit',
      name: 'unite',
      desc: '',
      args: [],
    );
  }

  /// `Vendor`
  String get fournisseur_imp {
    return Intl.message(
      'Vendor',
      name: 'fournisseur_imp',
      desc: '',
      args: [],
    );
  }

  /// `Unit price`
  String get prix_unite {
    return Intl.message(
      'Unit price',
      name: 'prix_unite',
      desc: '',
      args: [],
    );
  }

  /// `Monthly subscription`
  String get mensuel {
    return Intl.message(
      'Monthly subscription',
      name: 'mensuel',
      desc: '',
      args: [],
    );
  }

  /// `Annual subscription`
  String get annuel {
    return Intl.message(
      'Annual subscription',
      name: 'annuel',
      desc: '',
      args: [],
    );
  }

  /// `For life`
  String get a_vie {
    return Intl.message(
      'For life',
      name: 'a_vie',
      desc: '',
      args: [],
    );
  }

  /// `Profits`
  String get marges {
    return Intl.message(
      'Profits',
      name: 'marges',
      desc: '',
      args: [],
    );
  }

  /// `NB: Please allow the application to always use your location to detect the printer.`
  String get msg_bl_localisation {
    return Intl.message(
      'NB: Please allow the application to always use your location to detect the printer.',
      name: 'msg_bl_localisation',
      desc: '',
      args: [],
    );
  }

  /// `Designation`
  String get compte_designation {
    return Intl.message(
      'Designation',
      name: 'compte_designation',
      desc: '',
      args: [],
    );
  }

  /// `Connect to printer from settings then refresh`
  String get imp_bl_android {
    return Intl.message(
      'Connect to printer from settings then refresh',
      name: 'imp_bl_android',
      desc: '',
      args: [],
    );
  }

  /// `Days`
  String get days {
    return Intl.message(
      'Days',
      name: 'days',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get montant_1 {
    return Intl.message(
      'Amount',
      name: 'montant_1',
      desc: '',
      args: [],
    );
  }

  /// `Has credit`
  String get a_credit_client {
    return Intl.message(
      'Has credit',
      name: 'a_credit_client',
      desc: '',
      args: [],
    );
  }

  /// `Has credit`
  String get a_credit_four {
    return Intl.message(
      'Has credit',
      name: 'a_credit_four',
      desc: '',
      args: [],
    );
  }

  /// `zero`
  String get zero {
    return Intl.message(
      'zero',
      name: 'zero',
      desc: '',
      args: [],
    );
  }

  /// `you can't change tier`
  String get msg_change_tier_err {
    return Intl.message(
      'you can\'t change tier',
      name: 'msg_change_tier_err',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get prix_ticket {
    return Intl.message(
      'Price',
      name: 'prix_ticket',
      desc: '',
      args: [],
    );
  }

  /// `Decimal unit of currency`
  String get param_decimal_unite_title {
    return Intl.message(
      'Decimal unit of currency',
      name: 'param_decimal_unite_title',
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