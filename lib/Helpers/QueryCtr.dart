import 'package:flutter/services.dart';
import 'package:gestmob/Helpers/SqlLiteDatabaseHelper.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/models/Article.dart';
import 'package:gestmob/models/ArticleFamille.dart';
import 'package:gestmob/models/ArticleMarque.dart';
import 'package:gestmob/models/ArticleTva.dart';
import 'package:gestmob/models/Piece.dart';
import 'package:gestmob/models/Tiers.dart';
import 'package:gestmob/models/TiersFamille.dart';
import 'package:gestmob/ui/AddArticlePage.dart';
import 'package:sqflite/sqflite.dart';

import 'dart:async';
import 'dart:io' as io;
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'Helpers.dart';

class QueryCtr {
  SqlLiteDatabaseHelper _databaseHelper = SqlLiteDatabaseHelper();

  Future<List<Article>> getAllArticles(int offset, int limit, {String searchTerm, Map<String, dynamic> filters}) async {
    String query = 'SELECT * FROM ' + DbTablesNames.articles;

    int marque = filters["Id_Marque"] != null? filters["Id_Marque"] : -1;
    int famille = filters["Id_Famille"] != null? filters["Id_Famille"] : -1;
    bool stock = filters["inStock"] != null? filters["inStock"] : false;

    String marqueFilter = marque > 0 ? " AND Id_Marque = $marque" : "";
    String familleFilter = famille > 0 ? " AND Id_Famille = $famille" : "";
    String stockFilter = stock ? " AND Qte > 0 " : "";

    Database dbClient = await _databaseHelper.db;
    var res;

    query += " where Designation like '%${searchTerm??''}%'";

    query += marqueFilter;
    query += familleFilter;
    query += stockFilter;


    query += ' ORDER BY id DESC';

    res = await dbClient.rawQuery(query);

    List<Article> list = new List<Article>();
    for (var i = 0, j = res.length; i < j; i++) {
      Article article = Article.fromMap(res[i]);
      list.add(article);
    }

    return list;
  }

  Future<List<Tiers>> getAllTiers(int offset, int limit, {String searchTerm, Map<String, dynamic> filters}) async {
    String query = 'SELECT * FROM ' + DbTablesNames.tiers;

    int clientFourn = filters["Clientfour"] != null? filters["Clientfour"] : -1;
    int famille = filters["Id_Famille"] != null? filters["Id_Famille"] : -1;
    bool hasCredit = filters["hasCredit"] != null? filters["hasCredit"] : false;


    String clientFournFilter = clientFourn > -1 ? " AND (Clientfour = $clientFourn OR Clientfour = 1)" : "";
    String familleFilter = famille > 0 ? " AND Id_Famille = $famille" : "";
    String hasCreditFilter = hasCredit ? " AND Credit > 0 " : "";

    Database dbClient = await _databaseHelper.db;
    var res;

    query += " where RaisonSociale like '%${searchTerm??''}%'";

    query += clientFournFilter;
    query += familleFilter;
    query += hasCreditFilter;

    query += ' ORDER BY id DESC';

    res = await dbClient.rawQuery(query);

    List<Tiers> list = new List<Tiers>();
    for (var i = 0, j = res.length; i < j; i++) {
      Tiers tier = Tiers.fromMap(res[i]);
      list.add(tier);
    }

    return list;
  }

  Future<List<Piece>> getAllPieces(int offset, int limit, {String searchTerm, Map<String, dynamic> filters}) async {
    String query = 'SELECT Pieces.*,Tiers.RaisonSociale FROM Pieces JOIN Tiers ON Pieces.Tier_id = Tiers.id';

    String _piece = filters["Piece"];
    int _mov = filters["Mov"] != null? filters["Mov"] : 0;

    String _pieceFilter = _piece != null? " AND Piece like '$_piece'" : "";
    String _movFilter = " AND Mov >= $_mov";

    Database dbClient = await _databaseHelper.db;
    var res;

    query += " where Num_piece like '%${searchTerm??''}%'";

    query += _pieceFilter;
    query += _movFilter;

    query += ' ORDER BY id DESC';

    res = await dbClient.rawQuery(query);

    List<Piece> list = new List<Piece>();
    for (var i = 0, j = res.length; i < j; i++) {
      Piece piece = Piece.fromMap(res[i]);
      list.add(piece);
    }

    return list;
  }

  Future<List<ArticleMarque>> getAllArticleMarques() async {
    Database dbClient = await _databaseHelper.db;
    var res = await dbClient.rawQuery('SELECT * FROM ' + DbTablesNames.articlesMarques);

    List<ArticleMarque> list = new List<ArticleMarque>();
    for (var i = 0, j = res.length; i < j; i++) {
      ArticleMarque marque = ArticleMarque.fromMap(res[i]);
      list.add(marque);
    }

    return list;
  }

  Future<List<ArticleFamille>> getAllArticleFamilles() async {
    Database dbClient = await _databaseHelper.db;
    var res = await dbClient.rawQuery('SELECT * FROM ' + DbTablesNames.articlesFamilles);

    List<ArticleFamille> list = new List<ArticleFamille>();
    for (var i = 0, j = res.length; i < j; i++) {
      ArticleFamille famille = ArticleFamille.fromMap(res[i]);
      list.add(famille);
    }

    return list;
  }

  Future<List<ArticleTva>> getAllArticleTva() async {
    Database dbClient = await _databaseHelper.db;
    var res = await dbClient.rawQuery('SELECT * FROM ${DbTablesNames.articlesTva} ORDER BY Tva ASC');

    List<ArticleTva> list = new List<ArticleTva>();
    for (var i = 0, j = res.length; i < j; i++) {
      ArticleTva tva = ArticleTva.fromMap(res[i]);
      list.add(tva);
    }

    return list;
  }

  Future<List<TiersFamille>> getAllTierFamilles() async {
    Database dbClient = await _databaseHelper.db;
    var res = await dbClient.rawQuery('SELECT * FROM ' + DbTablesNames.tiersFamille);

    List<TiersFamille> list = new List<TiersFamille>();
    for (var i = 0, j = res.length; i < j; i++) {
      TiersFamille famille = TiersFamille.fromMap(res[i]);
      list.add(famille);
    }

    return list;
  }

  Future<int> addItemToTable(String tableName, item) async {
    var dbClient = await _databaseHelper.db;
    int res = await dbClient.insert(tableName, item.toMap());

    return res;
  }

  Future<int> updateItemInDb(String tableName, item) async {
    var dbClient = await _databaseHelper.db;
    int res = await dbClient.update(tableName, item.toMap(), where: "id=?", whereArgs: [item.id]);
    return res;
  }

  Future<Article> getTestArticle() async {
    // var bytes = await rootBundle.load('assets/article.png');
    /*String tempPath = (await getTemporaryDirectory()).path;
    File imageFile = File('$tempPath/article.png');
    await imageFile.writeAsBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));*/

    Article article = new Article(null, "_designation", "_ref", "code bar here", "Description from test article", 1, 2, 3, 2, 1, 2, 3, 2, 1, 2, 3, 2, 1, 3, 2, 1, 29, false, true);
    // article.imageUint8List = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    return article;
  }

  Future<Tiers> getTestTier() async {
    Tiers tier = new Tiers(null, "reasonSociale", "qrcode", 0, 0, 0, "adresse", "ville", "telephone", "0658228909", "fax", "email", 10, 15, 3, false);
    return tier;
  }

  Future<Piece> getTestPiece() async {
    Piece piece = new Piece("FP", "05555", 0, 1, new DateTime.now(), 1, 1, 10, 10, 10, 10, 10, 10, 15);
    return piece;
  }



}