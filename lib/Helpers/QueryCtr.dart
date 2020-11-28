import 'package:flutter/services.dart';
import 'package:gestmob/Helpers/SqlLiteDatabaseHelper.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/models/Article.dart';
import 'package:gestmob/models/ArticleFamille.dart';
import 'package:gestmob/models/ArticleMarque.dart';
import 'package:gestmob/models/ArticleTva.dart';
import 'package:gestmob/models/FormatPiece.dart';
import 'package:gestmob/models/Journaux.dart';
import 'package:gestmob/models/Piece.dart';
import 'package:gestmob/models/Profile.dart';
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

  Future<Profile> getProfileById(int id) async {
    Database dbClient = await _databaseHelper.db;
    var res = await dbClient.rawQuery('SELECT * FROM ' + DbTablesNames.profile + ' where id like $id');
    Profile profile = new Profile.fromMap(res[0]);
    return profile;
  }

  Future<Tiers> getTierById(int id) async {
    Database dbClient = await _databaseHelper.db;
    var res = await dbClient.rawQuery('SELECT * FROM ' + DbTablesNames.tiers + ' where id like $id');
    Tiers tier = new Tiers.fromMap(res[0]);
    return tier;
  }

  Future<List<Article>> getAllArticles({int offset, int limit, String searchTerm, Map<String, dynamic> filters}) async {
    String query = 'SELECT * FROM ' + DbTablesNames.articles;

    if(filters != null){
      int marque = filters["Id_Marque"] != null? filters["Id_Marque"] : -1;
      int famille = filters["Id_Famille"] != null? filters["Id_Famille"] : -1;
      bool stock = filters["inStock"] != null? filters["inStock"] : false;

      String marqueFilter = marque > 0 ? " AND Id_Marque = $marque" : "";
      String familleFilter = famille > 0 ? " AND Id_Famille = $famille" : "";
      String stockFilter = stock ? " AND Qte > 0 " : "";


      query += " where Designation like '%${searchTerm??''}%'";

      query += marqueFilter;
      query += familleFilter;
      query += stockFilter;
    }


    Database dbClient = await _databaseHelper.db;
    var res;

    query += ' ORDER BY id DESC';

    res = await dbClient.rawQuery(query);

    List<Article> list = new List<Article>();
    for (var i = 0, j = res.length; i < j; i++) {
      Article article = Article.fromMap(res[i]);
      list.add(article);
    }

    return list;
  }

  Future<List<Tiers>> getAllTiers({int offset, int limit, String searchTerm, Map<String, dynamic> filters}) async {
    String query = 'SELECT * FROM ' + DbTablesNames.tiers;
    query += " where RaisonSociale like '%${searchTerm??''}%'";

    if(filters != null){
      int clientFourn = filters["Clientfour"] != null? filters["Clientfour"] : -1;
      int famille = filters["Id_Famille"] != null? filters["Id_Famille"] : -1;
      bool hasCredit = filters["hasCredit"] != null? filters["hasCredit"] : false;

      String clientFournFilter = clientFourn > -1 ? " AND (Clientfour = $clientFourn OR Clientfour = 1)" : "";
      String familleFilter = famille > 0 ? " AND Id_Famille = $famille" : "";
      String hasCreditFilter = hasCredit ? " AND Credit > 0 " : "";

      query += clientFournFilter;
      query += familleFilter;
      query += hasCreditFilter;
    }

    Database dbClient = await _databaseHelper.db;
    var res;

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

  Future <List<Piece>> getPieceByNum(String num_piece) async{
    var dbClient = await _databaseHelper.db ;
    var res = await dbClient.query(DbTablesNames.pieces ,where: 'Num_piece LIKE ?', whereArgs: ['$num_piece']);

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

  Future<dynamic> addItemToTable(String tableName, item) async {
    var dbClient = await _databaseHelper.db;
    int res = await dbClient.insert(tableName, item.toMap());
    String query = 'SELECT last_insert_rowid();';
    var result = await dbClient.rawQuery(query);
    return res;
  }

  Future<int> updateItemInDb(String tableName, item) async {
    var dbClient = await _databaseHelper.db;
    int res = await dbClient.update(tableName, item.toMap(), where: "id=?", whereArgs: [item.id]);
    return res;
  }

  Future<int> removeItemFromTable(String tableName , item)async {
    var dbClient = await _databaseHelper.db ;
    int res = await dbClient.delete(tableName , where: "id=?" , whereArgs: [item.id]);
    return res ;
  }

  Future<List<FormatPiece>> getFormatPiece (String pieceType) async {
    var dbClient = await _databaseHelper.db ;
    var res = await dbClient.query(DbTablesNames.formatPiece ,where: 'Piece LIKE ?', whereArgs: ['$pieceType']);

    List<FormatPiece> list = new List<FormatPiece>();
    for(int i = 0 ; i<res.length ; i++){
      FormatPiece  formatPiece = FormatPiece.fromMap(res[i]);
      list.add(formatPiece);
    }

    return list ;
  }

  Future<List<Article>> getJournalPiece(Piece piece) async{
    var dbClient = await _databaseHelper.db ;
    String query = 'SELECT Journaux.*,Articles.Ref ,Articles.Designation ,Articles.BytesImageString'
        ' FROM Journaux JOIN Articles ON Journaux.Article_id = Articles.id AND Journaux.Piece_id='+piece.id.toString();
    var res = await dbClient.rawQuery(query);

    List<Article> list = new List<Article>();
    for(int i=0 ; i<res.length ; i++){
      Article article = Article.fromMapJournaux(res[i]);
      list.add(article);
    }
    return list ;
  }

  Future<int> updateJournaux(String tableName, item)async{
    var dbClient = await _databaseHelper.db ;
    var res = await dbClient.update(tableName, item.toMap(), where: "Piece_id = ? AND Article_id = ?" , whereArgs: [item.piece_id , item.article_id] );

    return res ;
  }

  Future<int> deleteJournaux(String tableName, item)async{
    var dbClient = await _databaseHelper.db ;
    var res = await dbClient.delete(tableName, where: "Piece_id=? AND Article_id=?" , whereArgs: [item.piece_id , item.article_id] );

    return res ;
  }

  Future<Article> getTestArticle() async {
    // var bytes = await rootBundle.load('assets/article.png');
    /*String tempPath = (await getTemporaryDirectory()).path;
    File imageFile = File('$tempPath/article.png');
    await imageFile.writeAsBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));*/

    Article article = new Article(null, "_designation", "_ref", "code bar here", "Description from test article", 1, 2, 3, 2, 3, 2, 3, 2, 1, 2, 3, 2, 1, 3, 2, 1, 29, false, true);
    // article.imageUint8List = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    return article;
  }

  Future<Tiers> getTestTier() async {
    Tiers tier = new Tiers(null, "Passagé", "qrcode", 0, 0, 1, "adresse", "ville", "telephone", "000000", "fax", "email", 0, 0, 0, false);
    return tier;
  }

  Future<Piece> getTestPiece() async {
    Piece piece = new Piece("FP", "05555", 0, 1, new DateTime.now(), 1, 1, 1, 10, 10, 10, 10, 0, 10, 15);
    return piece;
  }



}