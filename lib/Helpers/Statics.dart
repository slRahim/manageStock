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
    S.current.statut_sarl,
    S.current.statut_spa,
    S.current.statut_epic,
    S.current.statut_etp
  ];
  static List<int> tarificationItems = [1, 2, 3];
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
  static List<String> rapportItems = [
    S.current.vente,
    S.current.achat,
    "Stock",
    S.current.cl_four,
    S.current.generale
  ];
  static List<String> rapportAchatItems = [
    "Recap.des achats par article",
    "Recap.des commandes par article",
    "Journal des achats",
    "Journal des commandes"
  ];
  static List<String> rapportVenteItems = [
    "Recap.des ventes par article",
    "Recap.des commandes par article",
    "Journal des ventes",
    "Journal des commandes"
  ];
  static List<String> rapportStocktockItems = [
    "Inventaire",
    "Produit en repture",
    "Zakat"
  ];
  static List<String> rapportTierItems = ["Creance Client", "Creance fournisseur"];
  static List<String> rapportGeneralItems = [
    "Etat journalier",
    "Etat mensuel",
    "Etat annuel"
  ];
}

class Profiles {
  const Profiles();

  static Profile CurrentProfile;
}

class RoutesKeys {
  const RoutesKeys();

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

  static const formatPrint = "FormatPrints";

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
