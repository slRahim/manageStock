
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
  static List<String> tiersItems = ["Clients","Cl/Fourr" ,"Fournisseurs"];
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
  static const settingsPage = '/settingsPage';
  static const helpPage = '/helpPage';
}

class ItemsListTypes {
  const ItemsListTypes();
  static const articlesList = 'articlesList';
  static const journalList = "journalList" ;
  static const clientsList = 'clientsList';
  static const fournisseursList = 'fournisseursList';
  static const pieceList = 'pieceList';
  static const tresorieList ="tresorieList";
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
  static const tresorie='Tresories';
  static const categorieTresorie = "TresorieCategories";
  static const reglementTresorie = "ReglementTresorie";
  static const transformer = "Transformers";
  static const formatPiece = "FormatPiece" ;
  static const myparams = "MyParams" ;
  static const formatPrint = "FormatPrints" ;
  static const defaultPrinter = "DefaultPrinters";
}

class PieceType {
  const PieceType();
  static const devis = 'FP';
  static const commandeClient= "CC";
  static const bonLivraison = "BL";
  static const factureClient="FC";
  static const retourClient = "RC";
  static const avoirFournisseur="AF";
  static const avoirClient="AC";
  static const bonCommande = "BC";
  static const bonReception = "BR";
  static const factureFournisseur="FF";
  static const retourFournisseur= "RF";
  static const tresorie = "TR" ;
}

class Prefs {
  const Prefs();
  static int PriceCount = 2;
}

class NumPieceFormat {
  const NumPieceFormat() ;
  static const format1 = "XXXX/YYYY";
  static const format2 = "XXXX/MM/YYYY";
}


