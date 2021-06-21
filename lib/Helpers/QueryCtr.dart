import 'dart:async';
import 'dart:io';

import 'package:gestmob/Helpers/SqlLiteDatabaseHelper.dart';
import 'package:gestmob/Helpers/Statics.dart';
import "package:gestmob/Helpers/string_cap_extension.dart";
import 'package:gestmob/models/Article.dart';
import 'package:gestmob/models/ArticleFamille.dart';
import 'package:gestmob/models/ArticleMarque.dart';
import 'package:gestmob/models/ArticleTva.dart';
import 'package:gestmob/models/ChargeTresorie.dart';
import 'package:gestmob/models/CompteTresorie.dart';
import 'package:gestmob/models/DefaultPrinter.dart';
import 'package:gestmob/models/FormatPiece.dart';
import 'package:gestmob/models/MyParams.dart';
import 'package:gestmob/models/Piece.dart';
import 'package:gestmob/models/Profile.dart';
import 'package:gestmob/models/Tiers.dart';
import 'package:gestmob/models/TiersFamille.dart';
import 'package:gestmob/models/Transformer.dart';
import 'package:gestmob/models/Tresorie.dart';
import 'package:gestmob/models/TresorieCategories.dart';
import 'package:sqflite/sqflite.dart';

class QueryCtr {
  SqlLiteDatabaseHelper _databaseHelper = SqlLiteDatabaseHelper();

  //*****************************************************************************************************************************************************************
  //************************************************************************special backup&restore*****************************************************************************
  Future createBackup() async {
    var res = await _databaseHelper.generateBackup(isEncrypted: true);
    return res;
  }

  Future restoreBackup(File backup) async {
    var res = await _databaseHelper.restoreBackup(backup, isEncrypted: true);
    return res;
  }

  //*****************************************************************************************************************************************************************
  //*******************************************************************logique metier******************************************************************************
  Future<Profile> getProfileById(int id) async {
    Database dbClient = await _databaseHelper.db;
    var res = await dbClient.rawQuery(
        'SELECT * FROM ' + DbTablesNames.profile + ' where id like $id');
    Profile profile = new Profile.fromMap(res[0]);
    return profile;
  }

  Future<List<Article>> getAllArticles(
      {int offset,
      int limit,
      String searchTerm,
      Map<String, dynamic> filters}) async {
    String query = 'SELECT * FROM ' + DbTablesNames.articles;

    if (filters != null) {
      int marque = filters["Id_Marque"] != null ? filters["Id_Marque"] : -1;
      int famille = filters["Id_Famille"] != null ? filters["Id_Famille"] : -1;
      bool stock = filters["outStock"] != null ? filters["outStock"] : false;
      bool bloquer =
          filters["articleBloquer"] != null ? filters["articleBloquer"] : false;
      bool nonStockable =
          filters["nonStockable"] != null ? filters["nonStockable"] : false;

      String marqueFilter = marque > 0 ? " AND Id_Marque = $marque" : "";
      String familleFilter = famille > 0 ? " AND Id_Famille = $famille" : "";
      String stockFilter = stock ? " AND (Qte < 1 OR Qte < Qte_Min)" : "";
      String articleBloquerFilter =
          bloquer ? " AND Bloquer > 0" : " AND Bloquer = 0";
      String nonStockableFilter = nonStockable ? " AND Stockable < 1" : "";

      query +=
          " where (Designation like '%${searchTerm ?? ''}%' OR CodeBar like '%${searchTerm ?? ''}%' OR Ref like '%${searchTerm ?? ''}%')";

      query += marqueFilter;
      query += familleFilter;
      query += stockFilter;
      query += articleBloquerFilter;
      query += nonStockableFilter;
    }

    Database dbClient = await _databaseHelper.db;
    var res;

    query += ' ORDER BY id DESC';
    query += " LIMIT ${limit} OFFSET ${offset}";

    res = await dbClient.rawQuery(query);

    List<Article> list = new List<Article>();
    for (var i = 0, j = res.length; i < j; i++) {
      Article article = Article.fromMap(res[i]);
      list.add(article);
    }

    return list;
  }

  Future<List<Tiers>> getAllTiers(
      {int offset,
      int limit,
      String searchTerm,
      Map<String, dynamic> filters}) async {
    String query = 'SELECT * FROM ' + DbTablesNames.tiers;
    query +=
        " where (RaisonSociale like '%${searchTerm ?? ''}%' OR QRcode like '%${searchTerm ?? ''}%')";

    if (filters != null) {
      int clientFourn =
          filters["Clientfour"] != null ? filters["Clientfour"] : -1;
      int famille = filters["Id_Famille"] != null ? filters["Id_Famille"] : -1;
      bool hasCredit =
          filters["hasCredit"] != null ? filters["hasCredit"] : false;
      bool showBloquer =
          filters["tierBloquer"] != null ? filters["tierBloquer"] : false;

      String clientFournFilter = "";
      if (clientFourn > -1) {
        clientFournFilter =
            " AND (Clientfour = $clientFourn OR Clientfour = 1)";
      }
      String familleFilter = famille > 0 ? " AND Id_Famille = $famille" : "";

      String hasCreditFilter = hasCredit ? " AND Credit > 0 " : "";
      String showBloquerFilter =
          showBloquer ? " AND Bloquer > 0 " : " AND Bloquer = 0";

      query += clientFournFilter;
      query += familleFilter;
      query += hasCreditFilter;
      query += showBloquerFilter;
    }

    Database dbClient = await _databaseHelper.db;
    var res;

    query += ' ORDER BY id DESC';
    query += " LIMIT $limit OFFSET $offset";

    res = await dbClient.rawQuery(query);

    List<Tiers> list = new List<Tiers>();
    for (var i = 0, j = res.length; i < j; i++) {
      Tiers tier = Tiers.fromMap(res[i]);
      list.add(tier);
    }

    return list;
  }

  Future<Tiers> getTierById(int id) async {
    Database dbClient = await _databaseHelper.db;
    var res = await dbClient.rawQuery(
        'SELECT * FROM ' + DbTablesNames.tiers + ' where id like $id');
    Tiers tier = new Tiers.fromMap(res[0]);
    return tier;
  }

  Future<bool> checkTierItems(Tiers item) async {
    Database dbClient = await _databaseHelper.db;
    String tableName = DbTablesNames.pieces;
    String query = "SELECT COUNT(*) FROM $tableName WHERE Tier_id = ${item.id}";
    var res = await dbClient.rawQuery(query);

    if (res.first["COUNT(*)"] > 0) {
      return true;
    }

    tableName = DbTablesNames.tresorie;
    res = await dbClient.rawQuery(query);
    if (res.first["COUNT(*)"] > 0) {
      return true;
    }

    return false;
  }

  Future<List<Piece>> getAllPieces(int offset, int limit,
      {String searchTerm, Map<String, dynamic> filters}) async {
    String query =
        'SELECT Pieces.*,Tiers.RaisonSociale,Tiers.Mobile FROM Pieces JOIN Tiers ON Pieces.Tier_id = Tiers.id';

    String _piece = filters["Piece"];
    int _mov = filters["Mov"] != null ? filters["Mov"] : 0;
    int _tier_id = filters["Tierid"] != null ? filters["Tierid"] : null;
    int _startDate = filters["Start_date"] != null
        ? filters["Start_date"].millisecondsSinceEpoch
        : null;
    int _endDate = filters["End_date"] != null
        ? filters["End_date"].millisecondsSinceEpoch + 89940000
        : null;

    String _pieceFilter = (_piece != null && _piece != "TR")
        ? " AND Piece like '$_piece'"
        : " AND (Piece like 'BL' OR Piece like 'FC')";
    String _movFilter = " AND Mov >= $_mov";
    String _startDateFilter = ' AND Date >= $_startDate';
    String _endDateFilter = ' AND Date <= $_endDate';

    if (filters["Draft"]) {
      _movFilter = " AND Mov >= 2";
    }

    String _creditFilter = "";
    if (filters["Credit"]) {
      _creditFilter = " AND Reste > 0";
    }

    String _tierFilter = "";
    if (_tier_id != null) {
      _tierFilter = " AND Tier_id = $_tier_id";
      _creditFilter = " AND Reste > 0";
      _movFilter = " AND Mov = 1";
    }

    Database dbClient = await _databaseHelper.db;
    var res;

    query +=
        " where (Num_piece like '%${searchTerm ?? ''}%' OR Tiers.RaisonSociale like '%${searchTerm ?? ''}%')";

    query += _pieceFilter;
    query += _movFilter;
    if (_startDate != null) {
      query += _startDateFilter;
    }
    if (_endDate != null) {
      query += _endDateFilter;
    }
    query += _tierFilter;
    query += _creditFilter;

    query += ' ORDER BY Date DESC';
    query += " LIMIT ${limit} OFFSET ${offset}";

    res = await dbClient.rawQuery(query);

    List<Piece> list = new List<Piece>();
    for (var i = 0, j = res.length; i < j; i++) {
      Piece piece = Piece.fromMap(res[i]);
      list.add(piece);
    }

    if (_piece == null) {
      MyParams _params = await getAllParams();
      List<Piece> listcredit = new List<Piece>();
      for (int i = 0; i < list.length; i++) {
        if (list[i]
            .date
            .add(Duration(days: Statics.echeances[_params.echeance]))
            .isBefore(DateTime.now())) {
          listcredit.add(list[i]);
        }
      }
      return listcredit;
    }

    return list;
  }

  Future<List<Piece>> getAllPiecesByTierId(int tier_id) async {
    Database dbClient = await _databaseHelper.db;
    var res;

    res = await dbClient.query(DbTablesNames.pieces,
        where:
            "Reste > 0 AND Mov = 1 AND Piece != 'FP' Piece != 'CC' AND Tier_id = ?",
        whereArgs: [tier_id]);

    List<Piece> list = new List<Piece>();
    for (var i = 0, j = res.length; i < j; i++) {
      Piece piece = Piece.fromMap(res[i]);
      list.add(piece);
    }

    return list;
  }

  Future<List<Piece>> getPieceByNum(String num_piece, String type_piece) async {
    var dbClient = await _databaseHelper.db;
    var res = await dbClient.query(DbTablesNames.pieces,
        where: 'Num_piece LIKE ? AND Piece LIKE ?',
        whereArgs: ['$num_piece', '$type_piece']);

    List<Piece> list = new List<Piece>();
    for (var i = 0, j = res.length; i < j; i++) {
      Piece piece = Piece.fromMap(res[i]);
      list.add(piece);
    }
    return list;
  }

  Future<Piece> getPieceById(int id) async {
    var dbClient = await _databaseHelper.db;
    String query =
        'SELECT Pieces.*,Tiers.RaisonSociale FROM Pieces JOIN Tiers ON Pieces.Tier_id = Tiers.id AND Pieces.id = ${id}';
    var res = await dbClient.rawQuery(query);
    print(res.length);
    Piece piece = Piece.fromMap(res.first);

    return piece;
  }

  Future<bool> pieceHasCredit() async {
    var dbClient = await _databaseHelper.db;
    var res = await dbClient.query(DbTablesNames.pieces,
        where: "Reste > 0 AND (Piece LIKE 'BL' OR Piece LIKE 'FC') ");
    MyParams _params = await getAllParams();

    List<Piece> list = new List<Piece>();
    res.forEach((p) {
      Piece piece = Piece.fromMap(p);
      list.add(piece);
    });

    for (int i = 0; i < list.length; i++) {
      if (list[i]
          .date
          .add(Duration(days: Statics.echeances[_params.echeance]))
          .isBefore(DateTime.now())) {
        return true;
      }
    }

    return false;
  }

  Future<List<Article>> getJournalPiece(Piece piece,
      {bool local, String searchTerm, Map<String, dynamic> filters}) async {
    var dbClient = await _databaseHelper.db;
    String query =
        'SELECT Journaux.*, Articles.BytesImageString ,Articles.Designation , Articles.Ref ,Articles.CodeBar ,Articles.Id_Famille ,Articles.Id_Marque'
                ',Articles.Qte as qte_article , Articles.Cmd_client , Articles.PrixVente1 , Articles.PrixVente2 , Articles.PrixVente3 FROM Journaux JOIN Articles ON Journaux.Article_id = Articles.id AND Journaux.Mov <> -2 AND Journaux.Piece_id=' +
            piece.id.toString();

    if (local && filters != null) {
      int marque = filters["Id_Marque"] != null ? filters["Id_Marque"] : -1;
      int famille = filters["Id_Famille"] != null ? filters["Id_Famille"] : -1;
      int _startDate = filters["Start_date"] != null
          ? filters["Start_date"].millisecondsSinceEpoch
          : null;
      int _endDate = filters["End_date"] != null
          ? filters["End_date"].millisecondsSinceEpoch
          : null;

      String marqueFilter =
          marque > 0 ? " AND Articles.Id_Marque = $marque" : "";
      String familleFilter =
          famille > 0 ? " AND Articles.Id_Famille = $famille" : "";
      String _startDateFilter = ' AND Date >= $_startDate';
      String _endDateFilter = ' AND Date <= $_endDate';

      query +=
          " where (Designation like '%${searchTerm ?? ''}%' OR CodeBar like '%${searchTerm ?? ''}%' OR Ref like '%${searchTerm ?? ''}%')";
      query += marqueFilter;
      query += familleFilter;
      if (_startDate != null) {
        query += _startDateFilter;
      }
      if (_endDate != null) {
        query += _endDateFilter;
      }
    }

    var res = await dbClient.rawQuery(query);

    List<Article> list = new List<Article>();
    for (int i = 0; i < res.length; i++) {
      Article article = Article.fromMapJournaux(res[i]);
      if (local) {
        article.setquantite(article.selectedQuantite);
        article.selectedQuantite = -1;
        article.setQteMin(-1);
        article.cmdClient = 0;
      }
      list.add(article);
    }
    return list;
  }

  Future<List> getJournauxByTier(
      {int offset,
      int limit,
      String searchTerm,
      Map<String, dynamic> filters}) async {
    Database dbClient = await _databaseHelper.db;
    List<Piece> pieces = new List<Piece>();

    var res = await dbClient.query(DbTablesNames.pieces,
        where: "Tier_id = ?",
        whereArgs: [filters["idTier"].id],
        limit: limit,
        offset: offset);
    for (var i = 0, j = res.length; i < j; i++) {
      Piece piece = Piece.fromMap(res[i]);
      pieces.add(piece);
    }

    List articles = new List();
    var res1;

    for (int i = 0; i < pieces.length; i++) {
      if (pieces[i].piece == filters["pieceType"] && pieces[i].etat == 0) {
        res1 = await getJournalPiece(pieces[i],
            local: true, searchTerm: searchTerm, filters: filters);
        articles.addAll(res1);
      }
    }

    return articles;
  }

  Future<int> updateJournaux(String tableName, item) async {
    var dbClient = await _databaseHelper.db;
    var res = await dbClient.update(tableName, item.toMap(),
        where: "Piece_id = ? AND Article_id = ?",
        whereArgs: [item.piece_id, item.article_id]);

    return res;
  }

  Future getJournalByArticle(Article item) async {
    Database dbClient = await _databaseHelper.db;
    var res = await dbClient.query(DbTablesNames.journaux,
        where: "Article_id = ?", whereArgs: [item.id]);

    return res;
  }

  Future<List<Tresorie>> getAllTresories(int offset, int limit,
      {String searchTerm, Map<String, dynamic> filters}) async {
    String query = 'SELECT * FROM Tresories';

    query += " WHERE (Montant > 0 OR Montant < 0)";

    if (filters != null) {
      int categorie = filters["Categorie"] != null ? filters["Categorie"] : -1;
      String categorieFilter =
          categorie > 1 ? " AND Categorie_id = $categorie" : "";

      query +=
          " AND (Num_tresorie LIKE '%${searchTerm ?? ''}%' OR Tier_rs LIKE '%${searchTerm ?? ''}%' OR Objet LIKE '%${searchTerm ?? ''}%')";
      query += categorieFilter;
    }

    int _startDate = filters["Start_date"] != null
        ? filters["Start_date"].millisecondsSinceEpoch
        : null;
    int _endDate = filters["End_date"] != null
        ? filters["End_date"].millisecondsSinceEpoch + 89940000
        : null;

    String _startDateFilter = ' AND Date >= $_startDate';
    String _endDateFilter = ' AND Date <= $_endDate';

    if (_startDate != null) {
      query += _startDateFilter;
    }
    if (_endDate != null) {
      query += _endDateFilter;
    }

    query += ' ORDER BY id DESC';
    query += " LIMIT ${limit} OFFSET ${offset}";

    Database dbClient = await _databaseHelper.db;

    var res = await dbClient.rawQuery(query);

    print(query);

    List<Tresorie> list = new List<Tresorie>();
    for (var i = 0; i < res.length; i++) {
      Tresorie tresorie = new Tresorie.fromMap(res[i]);
      list.add(tresorie);
    }

    return list;
  }

  Future<List<Tresorie>> getTresorieByNum(String num) async {
    var dbClient = await _databaseHelper.db;

    var res = await dbClient.query(DbTablesNames.tresorie,
        where: "Num_tresorie LIKE ?", whereArgs: ['$num']);

    List<Tresorie> list = new List<Tresorie>();
    for (var i = 0; i < res.length; i++) {
      Tresorie tresorie = Tresorie.fromMap(res[i]);
      list.add(tresorie);
    }

    return list;
  }

  Future<double> getVerssementSolde(Tiers item) async {
    var dbClient = await _databaseHelper.db;

    var res = await dbClient
        .rawQuery('SELECT * FROM Tresories WHERE Tier_id = ${item.id}');
    List<Tresorie> list = new List<Tresorie>();
    for (var i = 0; i < res.length; i++) {
      Tresorie tresorie = new Tresorie.fromMap(res[i]);
      list.add(tresorie);
    }
    double sum = 0;
    for (int i = 0; i < list.length; i++) {
      var res1 = await dbClient.rawQuery(
          "Select Sum(Regler) From ReglementTresorie Where Tresorie_id = ${list[i].id}");
      sum = sum +
          ((res1.first["Sum(Regler)"] != null) ? res1.first["Sum(Regler)"] : 0);
    }
    return sum;
  }

  Future<List<ArticleMarque>> getAllArticleMarques() async {
    Database dbClient = await _databaseHelper.db;
    var res = await dbClient
        .rawQuery('SELECT * FROM ' + DbTablesNames.articlesMarques);

    List<ArticleMarque> list = new List<ArticleMarque>();
    for (var i = 0, j = res.length; i < j; i++) {
      ArticleMarque marque = ArticleMarque.fromMap(res[i]);
      list.add(marque);
    }

    return list;
  }

  Future<List<ArticleFamille>> getAllArticleFamilles() async {
    Database dbClient = await _databaseHelper.db;
    var res = await dbClient
        .rawQuery('SELECT * FROM ' + DbTablesNames.articlesFamilles);

    List<ArticleFamille> list = new List<ArticleFamille>();
    for (var i = 0, j = res.length; i < j; i++) {
      ArticleFamille famille = ArticleFamille.fromMap(res[i]);
      list.add(famille);
    }

    return list;
  }

  Future<List<ArticleTva>> getAllArticleTva() async {
    Database dbClient = await _databaseHelper.db;
    var res = await dbClient.rawQuery(
        'SELECT * FROM ${DbTablesNames.articlesTva} ORDER BY Tva ASC');

    List<ArticleTva> list = new List<ArticleTva>();
    for (var i = 0, j = res.length; i < j; i++) {
      ArticleTva tva = ArticleTva.fromMap(res[i]);
      list.add(tva);
    }

    return list;
  }

  Future<List<TiersFamille>> getAllTierFamilles() async {
    Database dbClient = await _databaseHelper.db;
    var res =
        await dbClient.rawQuery('SELECT * FROM ' + DbTablesNames.tiersFamille);

    List<TiersFamille> list = new List<TiersFamille>();
    for (var i = 0, j = res.length; i < j; i++) {
      TiersFamille famille = TiersFamille.fromMap(res[i]);
      list.add(famille);
    }

    return list;
  }

  Future<List<TresorieCategories>> getAllTresorieCategorie() async {
    Database dbClient = await _databaseHelper.db;
    var res = await dbClient
        .rawQuery('SELECT * FROM ' + DbTablesNames.categorieTresorie);

    List<TresorieCategories> list = new List<TresorieCategories>();
    for (var i = 0, j = res.length; i < j; i++) {
      TresorieCategories categories = TresorieCategories.fromMap(res[i]);
      list.add(categories);
    }

    return list;
  }

  Future<List<CompteTresorie>> getAllCompteTresorie() async {
    Database dbClient = await _databaseHelper.db;
    var res = await dbClient.query(DbTablesNames.compteTresorie);

    List<CompteTresorie> list = new List<CompteTresorie>();
    for (var i = 0, j = res.length; i < j; i++) {
      CompteTresorie compteTresorie = CompteTresorie.fromMap(res[i]);
      list.add(compteTresorie);
    }

    return list;
  }

  Future<List<ChargeTresorie>> getAllChargeTresorie() async {
    Database dbClient = await _databaseHelper.db;
    var res = await dbClient.query(DbTablesNames.chargeTresorie);

    List<ChargeTresorie> list = new List<ChargeTresorie>();
    for (var i = 0, j = res.length; i < j; i++) {
      ChargeTresorie chargeTresorie = ChargeTresorie.fromMap(res[i]);
      list.add(chargeTresorie);
    }

    return list;
  }

  Future<MyParams> getAllParams() async {
    Database dbClient = await _databaseHelper.db;
    var res = await dbClient.query(DbTablesNames.myparams);

    return new MyParams.frommMap(res[0]);
  }

  Future<DefaultPrinter> getPrinter() async {
    Database dbClient = await _databaseHelper.db;
    var res = await dbClient.query(DbTablesNames.defaultPrinter);

    if (res.isNotEmpty) {
      return new DefaultPrinter.fromMap(res.last);
    }

    return null;
  }

  Future<Transformer> getTransformer(item, String column) async {
    Database dbClient = await _databaseHelper.db;
    var res;
    if (column == "old") {
      res = await dbClient.query(DbTablesNames.transformer,
          where: "Old_Piece_id = ?", whereArgs: [item.id]);
    } else {
      res = await dbClient.query(DbTablesNames.transformer,
          where: "New_Piece_id = ?", whereArgs: [item.id]);
    }

    Transformer transformer = new Transformer.fromMap(res.first);

    return transformer;
  }

  Future<dynamic> addItemToTable(String tableName, item) async {
    var dbClient = await _databaseHelper.db;
    int res = await dbClient.insert(tableName, item.toMap());

    return res;
  }

  Future<int> updateItemInDb(String tableName, item) async {
    var dbClient = await _databaseHelper.db;
    int res = await dbClient
        .update(tableName, item.toMap(), where: "id=?", whereArgs: [item.id]);
    return res;
  }

  Future<int> updateItemByForeignKey(
      String tableName, item, value, String column, key) async {
    var dbClient = await _databaseHelper.db;
    int res = await dbClient.rawUpdate('''
      UPDATE $tableName
        SET $item = $value
      WHERE $column = $key ;
    ''');
    return res;
  }

  Future<int> removeItemFromTable(String tableName, item) async {
    var dbClient = await _databaseHelper.db;
    int res =
        await dbClient.delete(tableName, where: "id = ?", whereArgs: [item.id]);

    return res;
  }

  Future<int> removeItemWithForeignKey(
      String tableName, item, String column) async {
    var dbClient = await _databaseHelper.db;
    int res = await dbClient
        .delete(tableName, where: "$column = ?", whereArgs: [item]);

    return res;
  }

  Future<int> getLastId(String tableName) async {
    var dbClient = await _databaseHelper.db;
    String query = "Select Max(id) From $tableName ;";

    var res = await dbClient.rawQuery(query);

    return res.first["Max(id)"];
  }

  Future<List<FormatPiece>> getFormatPiece(String pieceType) async {
    var dbClient = await _databaseHelper.db;
    var res = await dbClient.query(DbTablesNames.formatPiece,
        where: 'Piece LIKE ?', whereArgs: ['$pieceType']);

    List<FormatPiece> list = new List<FormatPiece>();
    for (int i = 0; i < res.length; i++) {
      FormatPiece formatPiece = FormatPiece.fromMap(res[i]);
      list.add(formatPiece);
    }

    return list;
  }

  Future<List<FormatPiece>> getAllFormatPiece() async {
    var dbClient = await _databaseHelper.db;
    var res = await dbClient.query(DbTablesNames.formatPiece);

    List<FormatPiece> list = new List<FormatPiece>();
    for (int i = 0; i < res.length; i++) {
      FormatPiece formatPiece = FormatPiece.fromMap(res[i]);
      list.add(formatPiece);
    }

    return list;
  }

  //***************************************************************************************************************************************************************************
  //************************************************************************special fragment tableau****************************************************************************
  Future<List<ArticleFamille>> getArticleFamilles(int offset, int limit,
      {String searchTerm}) async {
    Database dbClient = await _databaseHelper.db;
    String query =
        "SELECT * FROM ${DbTablesNames.articlesFamilles} Where Libelle like '%${searchTerm ?? ''}%'";
    query += ' ORDER BY id DESC';
    query += " LIMIT $limit OFFSET $offset";

    var res = await dbClient.rawQuery(query);

    List<ArticleFamille> list = new List<ArticleFamille>();
    for (var i = 0, j = res.length; i < j; i++) {
      ArticleFamille famille = ArticleFamille.fromMap(res[i]);
      if (famille.id != 1) {
        list.add(famille);
      }
    }

    return list;
  }

  Future<List<ArticleMarque>> getArticleMarques(int offset, int limit,
      {String searchTerm}) async {
    Database dbClient = await _databaseHelper.db;
    String query =
        "SELECT * FROM ${DbTablesNames.articlesMarques} Where Libelle like '%${searchTerm ?? ''}%'";
    query += ' ORDER BY id DESC';
    query += " LIMIT ${limit} OFFSET ${offset}";

    var res = await dbClient.rawQuery(query);

    List<ArticleMarque> list = new List<ArticleMarque>();
    for (var i = 0, j = res.length; i < j; i++) {
      ArticleMarque marque = ArticleMarque.fromMap(res[i]);
      if (marque.id != 1) {
        list.add(marque);
      }
    }

    return list;
  }

  Future<List<ArticleTva>> getArticleTva(int offset, int limit,
      {String searchTerm}) async {
    Database dbClient = await _databaseHelper.db;
    String query = "SELECT * FROM ${DbTablesNames.articlesTva}";

    if (searchTerm != null &&
        searchTerm != '' &&
        searchTerm.isNumericUsingRegularExpression) {
      query += " Where Tva = ${double.parse(searchTerm)}";
    }
    query += ' ORDER BY id DESC';
    query += " LIMIT $limit OFFSET $offset";

    var res = await dbClient.rawQuery(query);

    List<ArticleTva> list = new List<ArticleTva>();
    for (var i = 0, j = res.length; i < j; i++) {
      ArticleTva tva = ArticleTva.fromMap(res[i]);
      list.add(tva);
    }

    return list;
  }

  Future<List<TiersFamille>> getTiersFamille(int offset, int limit,
      {String searchTerm}) async {
    Database dbClient = await _databaseHelper.db;
    String query =
        "SELECT * FROM ${DbTablesNames.tiersFamille} Where Libelle like '%${searchTerm ?? ''}%'";
    query += ' ORDER BY id DESC';
    query += " LIMIT $limit OFFSET $offset";

    var res = await dbClient.rawQuery(query);

    List<TiersFamille> list = new List<TiersFamille>();
    for (var i = 0, j = res.length; i < j; i++) {
      TiersFamille famille = TiersFamille.fromMap(res[i]);
      if (famille.id != 1) {
        list.add(famille);
      }
    }

    return list;
  }

  Future<List<ChargeTresorie>> getChargeTresorie(int offset, int limit,
      {String searchTerm}) async {
    Database dbClient = await _databaseHelper.db;
    String query = "SELECT * FROM " +
        DbTablesNames.chargeTresorie +
        " Where Libelle like '%${searchTerm ?? ''}%'";
    query += ' ORDER BY id DESC';
    query += " LIMIT ${limit} OFFSET ${offset}";

    var res = await dbClient.rawQuery(query);

    List<ChargeTresorie> list = new List<ChargeTresorie>();
    for (var i = 0, j = res.length; i < j; i++) {
      ChargeTresorie charge = ChargeTresorie.fromMap(res[i]);
      if (charge.id != 1) {
        list.add(charge);
      }
    }

    return list;
  }

  //*****************************************************************************************************************************************************************
  //************************************************************************special statistique**********************************************************************

  Future<Map<int, dynamic>> statHomePage() async {
    var dbClient = await _databaseHelper.db;
    int startDate = DateTime(DateTime.now().year, DateTime.now().month, 1)
        .millisecondsSinceEpoch;
    int endDate = DateTime.now().millisecondsSinceEpoch;
    Map<int, dynamic> result = new Map<int, dynamic>();
    String query1 =
        "Select Sum(Net_a_payer) as chf From Pieces Where Mov=1 AND (Piece LIKE 'BL' OR Piece LIKE 'FC' OR Piece LIKE 'RC' OR Piece LIKE 'AC') AND Date Between $startDate AND $endDate ";
    String query2 =
        "Select Sum(Net_a_payer) as achat From Pieces Where Mov=1 AND (Piece LIKE 'BR' OR Piece LIKE 'FF' OR Piece LIKE 'RF' OR Piece LIKE 'AF') AND Date Between $startDate AND $endDate ";
    var res1 = await dbClient.rawQuery(query1);
    var res2 = await dbClient.rawQuery(query2);
    result = {
      0: res1.first["chf"],
      1: res2.first["achat"],
    };

    return result;
  }

  Future<Map<int, dynamic>> statIndiceFinanciere() async {
    var dbClient = await _databaseHelper.db;
    Map<int, dynamic> result = new Map<int, dynamic>();
    String query1 =
        "Select Sum(Chiffre_affaires) From Tiers Where Clientfour = 0 ;";
    String query2 = "Select Sum(Regler) From Tiers Where Clientfour = 0 ;";
    String query3 = "Select Sum(Regler) From Tiers Where Clientfour = 2 ;";
    String query4 =
        "Select Sum(Net_a_payer) From Pieces Where Mov=1 AND (Piece LIKE 'BR' OR Piece LIKE 'FF' OR Piece LIKE 'RF' OR Piece LIKE 'AF') ;";
    String query5 =
        "Select Sum(Marge) From Pieces Where Mov=1 AND (Piece LIKE 'BL' OR Piece LIKE 'FC' OR Piece LIKE 'RC' OR Piece LIKE 'AC') ;";

    var res1 = await dbClient.rawQuery(query1);
    var res2 = await dbClient.rawQuery(query2);
    var res3 = await dbClient.rawQuery(query3);
    var res4 = await dbClient.rawQuery(query4);
    var res5 = await dbClient.rawQuery(query5);

    result = {
      0: res1.first["Sum(Chiffre_affaires)"],
      1: res2.first["Sum(Regler)"],
      2: res3.first["Sum(Regler)"],
      3: res4.first["Sum(Net_a_payer)"],
      4: res5.first["Sum(Marge)"],
    };

    return result;
  }

  Future<List<CompteTresorie>> statSoldeCompte() async {
    var dbClient = await _databaseHelper.db;
    var res = await dbClient.query(DbTablesNames.compteTresorie);

    List<CompteTresorie> list = new List<CompteTresorie>();
    for (int i = 0; i < res.length; i++) {
      CompteTresorie item = new CompteTresorie.fromMap(res[i]);
      list.add(item);
    }

    return list;
  }

  Future statCharge() async {
    var dbClient = await _databaseHelper.db;
    String query =
        "Select Tresories.Charge_id ,ChargeTresorie.* ,Sum(Montant) From Tresories JOIN ChargeTresorie ON Tresories.Charge_id = ChargeTresorie.id " +
            "Where Mov=1 AND Categorie_id=5 Group BY Charge_id ORDER BY Sum(Montant) DESC LIMIT 5 ;";

    var res = await dbClient.rawQuery(query);

    return res;
  }

  Future statVenteArticle() async {
    var dbClient = await _databaseHelper.db;
    String query = "Select Journaux.Article_id ,Articles.Ref, Articles.Designation ,Articles.BytesImageString, Sum(Journaux.Qte*Journaux.Net_ht) "
            "From Journaux JOIN Articles ON Journaux.Article_id = Articles.id " +
        "Where Mov = 1 AND (Piece_type LIKE 'BL' OR Piece_type LIKE 'FC' OR Piece_type LIKE 'RC' OR Piece_type LIKE 'AC') "
            "Group BY Article_id ORDER BY Sum(Journaux.Qte*Journaux.Net_ht) DESC LIMIT 5 ;";

    var res = await dbClient.rawQuery(query);

    return (res);
  }

  Future<List> statVenteClient() async {
    var dbClient = await _databaseHelper.db;
    String query =
        "Select * From Tiers Where Clientfour = 0 ORDER BY Chiffre_affaires DESC LIMIT 5 ;";

    var res = await dbClient.rawQuery(query);

    List<Tiers> list = new List<Tiers>();
    for (int i = 0; i < res.length; i++) {
      Tiers item = new Tiers.fromMap(res[i]);
      list.add(item);
    }

    return list;
  }

  Future statVenteFamille() async {
    var dbClient = await _databaseHelper.db;
    String query =
        "Select ArticlesFamilles.*, Sum(Journaux.Qte*Journaux.Net_ht) From Journaux " +
            "LEFT JOIN Articles ON Journaux.Article_id = Articles.id " +
            "LEFT JOIN ArticlesFamilles ON Articles.Id_Famille+1 = ArticlesFamilles.id " +
            "Where Mov = 1 AND (Piece_type LIKE 'BL' OR Piece_type LIKE 'FC' OR Piece_type LIKE 'RC' OR Piece_type LIKE 'AC')  " +
            "Group BY ArticlesFamilles.id " +
            "ORDER BY Sum(Journaux.Qte*Journaux.Net_ht) DESC LIMIT 5 ;";

    var res = await dbClient.rawQuery(query);

    print(res);
    return (res);
  }

  Future statAchatArticle() async {
    var dbClient = await _databaseHelper.db;
    String query = "Select Journaux.Article_id , Articles.Ref , Articles.Designation,Articles.BytesImageString, Sum(Journaux.Qte*Journaux.Net_ht) "
            "From Journaux JOIN Articles ON Journaux.Article_id = Articles.id " +
        "Where Mov = 1 AND (Piece_type LIKE 'BR' OR Piece_type LIKE 'FF' OR Piece_type LIKE 'RF' OR Piece_type LIKE 'AF') "
            "Group BY Article_id ORDER BY Sum(Journaux.Qte*Journaux.Net_ht) DESC LIMIT 5 ;";

    var res = await dbClient.rawQuery(query);

    return (res);
  }

  Future<List<Tiers>> statAchatFournisseur() async {
    var dbClient = await _databaseHelper.db;
    String query =
        "Select * From Tiers Where Clientfour = 2 ORDER BY Chiffre_affaires DESC LIMIT 5 ;";

    var res = await dbClient.rawQuery(query);

    List<Tiers> list = new List<Tiers>();
    for (int i = 0; i < res.length; i++) {
      Tiers item = new Tiers.fromMap(res[i]);
      list.add(item);
    }

    return list;
  }

//**********************************************************************************************************************************************************************************
//************************************************************************special statistique****************************************************************************************

  Future rapportVente(int rapport, DateTime start, DateTime end) async {
    var dbClient = await _databaseHelper.db;
    String query = "";
    int dateStart = start.millisecondsSinceEpoch;
    int dateEnd = end.millisecondsSinceEpoch + 89940000;

    switch (rapport) {
      case 0:
        query = """
         Select designation,  referance , qte ,  marge , total
         From
           (Select Articles.id , Articles.Designation as designation, Articles.Ref as referance , Sum(Journaux.Qte) as qte , 
                  Sum(Journaux.Marge*Journaux.Qte)/Sum(Journaux.Qte) as marge ,
                  (Sum(Journaux.Marge*Journaux.Qte)/Sum(Journaux.Qte)*Sum(Journaux.Qte)) as total
           From Journaux 
           Join Articles ON Journaux.Article_id = Articles.id 
           Where Journaux.Mov = 1 AND (Piece_type like 'BL' OR Piece_type like 'FC'  OR Piece_type like 'RC'  OR Piece_type like 'AC') 
                  AND  Journaux.Date Between ${dateStart} AND ${dateEnd}
           Group By Articles.id 
           order by Articles.Designation) ;
         """;
        break;
      case 1:
        query = """
         Select designation, referance, qte , prix, montant
         From
           (Select Articles.id , Articles.Designation as designation, Articles.Ref as referance, Sum(Journaux.Qte) as qte , 
                  Sum(Journaux.Net_ht*Journaux.Qte)/Sum(Journaux.Qte) as prix,
                  (Sum(Journaux.Net_ht*Journaux.Qte)/Sum(Journaux.Qte)*Sum(Journaux.Qte)) as montant
           From Journaux 
           Join Articles ON Journaux.Article_id = Articles.id 
           Where Journaux.Mov = 1 AND Piece_type like 'CC'  AND  Journaux.Date Between $dateStart AND $dateEnd
           Group By Articles.id 
           order by Articles.Designation);
         """;
        break;
      case 2:
        query = """
         Select Journaux.Piece_type as piece_titre ,Pieces.Num_piece as n,
                strftime('%d-%m-%Y', datetime(Pieces.Date/1000, 'unixepoch')) as date ,
                Articles.Ref as referance ,Articles.Designation designation ,Tiers.RaisonSociale as client ,
                Journaux.Qte as qte ,Journaux.Net_ht as prix, (Journaux.Net_ht * Journaux.Qte) as montant
         From Journaux 
         Left Join Pieces ON Journaux.Piece_id = Pieces.id 
         Left Join Tiers ON Pieces.Tier_id = Tiers.id 
         Left Join Articles ON Journaux.Article_id = Articles.id 
         Where Journaux.Mov = 1 AND (Piece_type like 'BL' OR Piece_type like 'FC' OR Piece_type like 'RC'  OR Piece_type like 'AC') 
               AND  Journaux.Date Between ${dateStart} AND ${dateEnd}
         Order by Pieces.Num_piece
         """;
        break;
      case 3:
        query = """
         Select Journaux.Piece_type as piece_titre ,Pieces.Num_piece as n ,Pieces.Date as date ,
                Articles.Ref as  referance ,Articles.Designation as designation,Tiers.RaisonSociale as client ,
                Journaux.Qte as qte ,Journaux.Net_ht as prix , (Journaux.Net_ht * Journaux.Qte) as montant
         From Journaux 
         Left Join Pieces ON Journaux.Piece_id = Pieces.id 
         Left Join Tiers ON Pieces.Tier_id = Tiers.id 
         Left Join Articles ON Journaux.Article_id = Articles.id 
         Where Journaux.Mov = 1 AND Piece_type like 'CC'   AND  Journaux.Date Between $dateStart AND $dateEnd
         order by Pieces.Num_piece
         """;
        break;
    }

    var res = await dbClient.rawQuery(query);
    return res;
  }

  Future rapportAchat(int rapport, DateTime start, DateTime end) async {
    var dbClient = await _databaseHelper.db;
    String query = "";
    int dateStart = start.millisecondsSinceEpoch;
    int dateEnd = end.millisecondsSinceEpoch + 89940000;

    switch (rapport) {
      case 0:
        query = """
         Select designation,referance, qte , marge, total
         From 
           (Select Aricles.id, Articles.Designation as designation, Articles.Ref as referance, Sum(Journaux.Qte) as qte , 
                  Sum(Journaux.Marge*Journaux.Qte)/Sum(Journaux.Qte) as  marge,
                  (Sum(Journaux.Marge*Journaux.Qte)/Sum(Journaux.Qte)*Sum(Journaux.Qte)) as total
           From Journaux 
           Join Articles ON Journaux.Article_id = Articles.id 
           Where Journaux.Mov = 1 AND (Piece_type like 'BR' OR Piece_type like 'FF' OR Piece_type like 'RF'  OR Piece_type like 'AF')
               AND  Journaux.Date Between $dateStart AND $dateEnd
           Group By Articles.id 
           order by Articles.Designation) ;
         """;
        break;
      case 1:
        query = """
         Select designation, referance, qte , prix, montant
         From 
           (Select Articles.id, Articles.Designation as designation, Articles.Ref as referance, Sum(Journaux.Qte) as qte , 
                  Sum(Journaux.Net_ht*Journaux.Qte)/Sum(Journaux.Qte) as prix,
                  (Sum(Journaux.Net_ht*Journaux.Qte)/Sum(Journaux.Qte)*Sum(Journaux.Qte)) as montant
           From Journaux 
           Join Articles ON Journaux.Article_id = Articles.id 
           Where Journaux.Mov = 0 AND Piece_type like 'BC'  AND  Journaux.Date Between ${dateStart} AND ${dateEnd}
           Group By Articles.id 
           order by Articles.Designation);
         """;
        break;
      case 2:
        query = """
         Select Journaux.Piece_type  as piece_titre,Pieces.Num_piece as n,Pieces.Date as date,
                Articles.Ref as referance,
                Articles.Designation as designation,Tiers.RaisonSociale as fournisseur ,
                Journaux.Qte as qte,Journaux.Net_ht as prix, 
                (Journaux.Net_ht * Journaux.Qte) as montant
         From Journaux 
         Left Join Pieces ON Journaux.Piece_id = Pieces.id 
         Left Join Tiers ON Pieces.Tier_id = Tiers.id 
         Left Join Articles ON Journaux.Article_id = Articles.id 
         Where Journaux.Mov = 1 AND (Piece_type like 'BR' OR Piece_type like 'FF' OR Piece_type like 'RF'  OR Piece_type like 'AF')  
              AND  Journaux.Date Between ${dateStart} AND ${dateEnd}
         order by Pieces.Num_piece
         """;
        break;
      case 3:
        query = """
         Select Journaux.Piece_type as piece_titre ,Pieces.Num_piece as n,Pieces.Date as date,
                Articles.Ref as referance,Articles.Designation as designation,
                Tiers.RaisonSociale as fournisseur ,
                Journaux.Qte as qte,Journaux.Net_ht as prix, (Journaux.Net_ht * Journaux.Qte) as montant
         From Journaux 
         Left Join Pieces ON Journaux.Piece_id = Pieces.id 
         Left Join Tiers ON Pieces.Tier_id = Tiers.id 
         Left Join Articles ON Journaux.Article_id = Articles.id 
         Where Journaux.Mov = 0 AND Piece_type like 'BC'   AND  Journaux.Date Between $dateStart AND $dateEnd
         order by Pieces.Num_piece
         """;
        break;
    }

    var res = await dbClient.rawQuery(query);
    return res;
  }

  Future rapportStock(int rapport) async {
    var dbClient = await _databaseHelper.db;
    String query = "";

    switch (rapport) {
      case 0:
        query = """
        Select Designation as designation, Ref as referance , Qte as qte, 
                PMP as pmp, (Qte*PMP) as montant
        From Articles where Qte > 0
        """;
        break;
      case 1:
        query = """
        Select Designation as designation, Ref as referance , Qte as qte, Qte_Min as qte_min, PMP as pmp, 
              (Qte*PMP) as montant
        From Articles where Qte < 1 OR Qte < Qte_Min
        """;
        break;
      case 2:
        query = """
        Select Designation as designation, Ref as referance, Qte as qte, 
              PrixVente1 as prix, (Qte*PrixVente1) as chifre_affaire
        From Articles where Qte > 0
        """;
        break;
    }

    var res = await dbClient.rawQuery(query);
    return res;
  }

  Future rapportTier(int rapport) async {
    var dbClient = await _databaseHelper.db;
    String query = "";

    switch (rapport) {
      case 0:
        query = """
        Select RaisonSociale as rs, Mobile as mobile, Chiffre_affaires as chifre_affaire, 
              Regler as regler, Credit as credit
        From Tiers where Clientfour = 0 
        """;
        break;
      case 1:
        query = """
        Select RaisonSociale as rs , Mobile as mobile, Chiffre_affaires  as chifre_affaire, 
              Regler as regler, Credit as credit 
        From Tiers where Clientfour = 2 
        """;
        break;
    }

    var res = await dbClient.rawQuery(query);
    return res;
  }

  Future rapportGeneral(int rapport, DateTime start, DateTime end) async {
    var dbClient = await _databaseHelper.db;
    String query = "";
    int dateStart = start.millisecondsSinceEpoch;
    int dateEnd = end.millisecondsSinceEpoch + 89940000;

    switch (rapport) {
      case 0:
        query = """
        Select date , Sum(vente) as vente , Sum(Reg_cl) as reg_cl , Sum(Creance) as credit , 
              Sum(Achat) as achat , Sum(Reg_four) as reg_four , Sum(dette)  as dette , 
              Sum(charge) as charge ,Sum(marge) as marge ,(Sum(marge)-Sum(charge)) as total
        from (
            Select  strftime('%d-%m-%Y', datetime(Date/1000, 'unixepoch')) date , Sum(Net_a_payer) as vente , Sum(Regler) as Reg_cl ,Sum(Reste) as Creance ,
                   0 as Achat , 0 as Reg_four , 0 as dette , 
                   0 as charge , Sum(Marge) as marge
            from Pieces 
            where Pieces.Mov = 1 And (Pieces.Piece Like 'BL' Or  Pieces.Piece Like 'FC' Or  Pieces.Piece Like 'RC' Or  Pieces.Piece Like 'AC') And Date Between $dateStart And $dateEnd
            Group by Date
            
            Union
            
            Select  strftime('%d-%m-%Y', datetime(Date/1000, 'unixepoch')) date , 0 as vente ,0 as Reg_cl ,0 as Creance  ,
                    Sum(Net_a_payer) as achat , Sum(Regler) as Reg_four ,Sum(Reste) as dette ,
                    0 as charge , 0 as marge
            from Pieces
            where Pieces.Mov = 1 And (Pieces.Piece Like 'BR' Or  Pieces.Piece Like 'FF' Or  Pieces.Piece Like 'RF' Or  Pieces.Piece Like 'AF') And Date Between $dateStart And $dateEnd
            Group by Date 
            
            Union
            
            Select  strftime('%d-%m-%Y', datetime(Date/1000, 'unixepoch')) date , 0 as vente ,0 as Reg_cl ,0 as Creance  ,
                    0 achat , 0 as Reg_four ,0 as dette , 
                    Sum(Tresories.Montant) as charge , 0 as marge
            from Tresories
            where Mov = 1 And Categorie_id = 5 And Date Between $dateStart And $dateEnd
            Group by Date ) a 
            
        Group by date
        """;
        break;
      case 1:
        query = """
        Select date , Sum(vente) as vente , Sum(Reg_cl) as reg_cl , Sum(Creance) as credit , 
              Sum(Achat) as achat , Sum(Reg_four) as reg_four , Sum(dette)  as dette , 
              Sum(charge) as charge ,Sum(marge) as marge ,(Sum(marge)-Sum(charge)) as total
        from (
            Select  strftime('%m-%Y', datetime(Date/1000, 'unixepoch')) date , Sum(Net_a_payer) as vente , Sum(Regler) as Reg_cl ,Sum(Reste) as Creance ,
                   0 as Achat , 0 as Reg_four , 0 as dette , 
                   0 as charge , Sum(Marge) as marge
            from Pieces 
            where Pieces.Mov = 1 And (Pieces.Piece Like 'BL' Or  Pieces.Piece Like 'FC' Or  Pieces.Piece Like 'RC' Or  Pieces.Piece Like 'AC') And Date Between $dateStart And $dateEnd
            Group by Date
            
            Union
            
            Select  strftime('%m-%Y', datetime(Date/1000, 'unixepoch')) date , 0 as vente ,0 as Reg_cl ,0 as Creance  ,
                    Sum(Net_a_payer) as achat , Sum(Regler) as Reg_four ,Sum(Reste) as dette ,
                    0 as charge , 0 as marge
            from Pieces
            where Pieces.Mov = 1 And (Pieces.Piece Like 'BR' Or  Pieces.Piece Like 'FF' Or  Pieces.Piece Like 'RF' Or  Pieces.Piece Like 'AF') And Date Between $dateStart And $dateEnd
            Group by Date 
            
            Union
            
            Select  strftime('%m-%Y', datetime(Date/1000, 'unixepoch')) date , 0 as vente ,0 as Reg_cl ,0 as Creance  ,
                    0 achat , 0 as Reg_four ,0 as dette , 
                    Sum(Tresories.Montant) as charge , 0 as marge
            from Tresories
            where Mov = 1 And Categorie_id = 5 And Date Between $dateStart And $dateEnd
            Group by Date ) a 
            
        Group by date
        """;
        break;
      case 2:
        query = """
        Select date , Sum(vente) as vente , Sum(Reg_cl) as reg_cl , Sum(Creance) as credit , 
              Sum(Achat) as achat , Sum(Reg_four) as reg_four , Sum(dette)  as dette , 
              Sum(charge) as charge ,Sum(marge) as marge ,(Sum(marge)-Sum(charge)) as total
        from (
            Select  strftime('%Y', datetime(Date/1000, 'unixepoch')) date , Sum(Net_a_payer) as vente , Sum(Regler) as Reg_cl ,Sum(Reste) as Creance ,
                   0 as Achat , 0 as Reg_four , 0 as dette , 
                   0 as charge , Sum(Marge) as marge
            from Pieces 
            where Pieces.Mov = 1 And (Pieces.Piece Like 'BL' Or  Pieces.Piece Like 'FC' Or  Pieces.Piece Like 'RC' Or  Pieces.Piece Like 'AC') 
            Group by Date
            
            Union
            
            Select  strftime('%Y', datetime(Date/1000, 'unixepoch')) date , 0 as vente ,0 as Reg_cl ,0 as Creance  ,
                    Sum(Net_a_payer) as achat , Sum(Regler) as Reg_four ,Sum(Reste) as dette ,
                    0 as charge , 0 as marge
            from Pieces
            where Pieces.Mov = 1 And (Pieces.Piece Like 'BR' Or  Pieces.Piece Like 'FF' Or  Pieces.Piece Like 'RF' Or  Pieces.Piece Like 'AF') 
            Group by Date 
            
            Union
            
            Select  strftime('%Y', datetime(Date/1000, 'unixepoch')) date , 0 as vente ,0 as Reg_cl ,0 as Creance  ,
                    0 achat , 0 as Reg_four ,0 as dette , 
                    Sum(Tresories.Montant) as charge , 0 as marge
            from Tresories
            where Mov = 1 And Categorie_id = 5 
            Group by Date ) a 
            
        Group by date
        """;
        break;
    }

    var res = await dbClient.rawQuery(query);
    return res;
  }
}
