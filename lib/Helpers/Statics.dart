
import 'package:gestmob/models/Profile.dart';

class Statics {
  static const RoutesKeys routes = const RoutesKeys();
  static const addArticle = '/add_article';

  static List<String> statutItems = [
    "M.",
    "Mlle.",
    "Mme.",
    "Dr.",
    "Pr.",
    "EURL.",
    "SARL.",
    "SPA.",
    "EPIC.",
    "ETP."
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
  static const settingsPage = '/settingsPage';
  static const helpPage = '/helpPage';
}

class ItemsListTypes {
  const ItemsListTypes();
  static const articlesList = 'articlesList';
  static const clientsList = 'clientsList';
  static const fournisseursList = 'fournisseursList';
  static const devisList = 'devisList';
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
  static const tiersFamille = 'TiersFamilles';
}

class Prefs {
  const Prefs();
  static int PriceCount = 3;
}


