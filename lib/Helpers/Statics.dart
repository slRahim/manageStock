import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/Profile.dart';

class Statics {
  static const RoutesKeys routes = const RoutesKeys();
  static List<String> statutItems = [
    S.current.statut_m,
    S.current.statut_mlle,
    S.current.statut_mme,
    S.current.statut_dr,
    S.current.statut_pr,
    S.current.statut_eurl,
  ];
  static List<int> tarificationItems = [1, 2, 3];
  static List<String> printDisplayItems = [S.current.referance , S.current.designation] ;
  static List<String> tiersItems = [
    S.current.client,
    S.current.cl_four,
    S.current.fournisseur
  ];

  static List<int> echeances = [1, 3, 7, 15, 21, 30];
  static List<String> repeateNotifications = [
    S.current.ev_day,
    S.current.ev_sun,
    S.current.ev_mon,
    S.current.ev_tue,
    S.current.ev_wedn,
    S.current.ev_thur,
    S.current.ev_fri,
    S.current.ev_sat
  ];
  static List<String> languages = [
    "English (ENG)",
    "French (FR)",
    "Arabic (AR)"
  ];
  static List<String> themeStyle = [
    S.current.light_theme,
    S.current.dark_them,
    S.current.sys_theme
  ];

  static List<String> rapportItems = [
    S.current.vente,
    S.current.achat,
    S.current.stock,
    S.current.cl_four,
    S.current.generale
  ];
  static List<String> rapportAchatItems = [
    S.current.recap_achat_article,
    S.current.recap_cmd_article,
    S.current.jour_achat,
    S.current.jour_cmd,
  ];
  static List<String> rapportVenteItems = [
    S.current.recap_vente_article,
    S.current.recap_cmd_article,
    S.current.jour_vente,
    S.current.jour_cmd,
  ];
  static List<String> rapportStocktockItems = [
    S.current.inventaire,
    S.current.prod_repture,
    S.current.zakat,
  ];
  static List<String> rapportTierItems = [
    S.current.creance_cl,
    S.current.creance_four
  ];
  static List<String> rapportGeneralItems = [
    S.current.etat_jour,
    S.current.etat_mensu,
    S.current.etat_annuel,
  ];
}

class Profiles {
  const Profiles();

  static Profile CurrentProfile;
}

class RoutesKeys {
  const RoutesKeys();
  static const introPage = '/intro' ;
  static const homePage = '/home_page';
  static const profilePage = '/profilePage';
  static const loginPage = '/loginPage';
  static const addArticle = '/add_article';
  static const addTier = '/add_tier';
  static const addPiece = '/add_piece';
  static const addTresorie = '/add_tresorie';
  static const allPieces = "/all_pieces";
  static const settingsPage = '/settingsPage';
  static const driveListing = '/drivePage';
  static const appPurchase = '/purchasePage';
  static const helpPage = '/helpPage';
}

class ItemsListTypes {
  const ItemsListTypes();

  static const articlesList = 'articlesList';
  static const journalList = "journalList";

  static const clientsList = 'clientsList';
  static const fournisseursList = 'fournisseursList';
  static const pieceList = 'pieceList';
  static const tresorieList = "tresorieList";
}

class DbTablesNames {
  const DbTablesNames();

  static const profile = 'Profile';
  static const articles = 'Articles';
  static const articlesMarques = 'ArticlesMarques';
  static const articlesFamilles = 'ArticlesFamilles';
  static const articlesTva = 'ArticlesTva';
  static const tiers = 'Tiers';
  static const pieces = 'Pieces';
  static const journaux = 'Journaux';
  static const tiersFamille = 'TiersFamilles';
  static const tresorie = 'Tresories';
  static const categorieTresorie = "TresorieCategories";
  static const reglementTresorie = "ReglementTresorie";
  static const compteTresorie = "CompteTresorie";
  static const chargeTresorie = "ChargeTresorie";
  static const transformer = "Transformers";
  static const formatPiece = "FormatPiece";
  static const myparams = "MyParams";
  static const defaultPrinter = "DefaultPrinters";
}

class PieceType {
  const PieceType();

  static const devis = 'FP';
  static const commandeClient = "CC";
  static const bonLivraison = "BL";
  static const factureClient = "FC";
  static const retourClient = "RC";
  static const avoirFournisseur = "AF";
  static const avoirClient = "AC";
  static const bonCommande = "BC";
  static const bonReception = "BR";
  static const factureFournisseur = "FF";
  static const retourFournisseur = "RF";
  static const tresorie = "TR";
}

class Prefs {
  const Prefs();

  static int PriceCount = 2;
}

class NumPieceFormat {
  const NumPieceFormat();

  static const format1 = "XXXX/YYYY";
  static const format2 = "XXXX/MM/YYYY";
}
