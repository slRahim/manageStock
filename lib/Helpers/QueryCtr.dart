import 'package:flutter/services.dart';
import 'package:gestmob/Helpers/SqlLiteDatabaseHelper.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/models/Article.dart';
import 'package:gestmob/models/ArticleFamille.dart';
import 'package:gestmob/models/ArticleMarque.dart';
import 'package:gestmob/models/ArticleTva.dart';
import 'package:gestmob/models/DefaultPrinter.dart';
import 'package:gestmob/models/FormatPiece.dart';
import 'package:gestmob/models/FormatPrint.dart';
import 'package:gestmob/models/Journaux.dart';
import 'package:gestmob/models/MyParams.dart';
import 'package:gestmob/models/Piece.dart';
import 'package:gestmob/models/Profile.dart';
import 'package:gestmob/models/Tiers.dart';
import 'package:gestmob/models/TiersFamille.dart';
import 'package:gestmob/models/Tresorie.dart';
import 'package:gestmob/models/TresorieCategories.dart';
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


  Future<List<Article>> getAllArticles({int offset, int limit, String searchTerm, Map<String, dynamic> filters}) async {
    String query = 'SELECT * FROM ' + DbTablesNames.articles;

    if(filters != null){
      int marque = filters["Id_Marque"] != null? filters["Id_Marque"] : -1;
      int famille = filters["Id_Famille"] != null? filters["Id_Famille"] : -1;
      bool stock = filters["inStock"] != null? filters["inStock"] : false;

      String marqueFilter = marque > 0 ? " AND Id_Marque = $marque" : "";
      String familleFilter = famille > 0 ? " AND Id_Famille = $famille" : "";
      String stockFilter = stock ? " AND Qte > 0 " : "";


      query += " where (Designation like '%${searchTerm??''}%' OR CodeBar like '%${searchTerm??''}%' OR Ref like '%${searchTerm??''}%')";

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
    query += " where (RaisonSociale like '%${searchTerm??''}%' OR QRcode like '%${searchTerm??''}%')";

    if(filters != null){
      int clientFourn = filters["Clientfour"] != null? filters["Clientfour"] : -1;
      int famille = filters["Id_Famille"] != null? filters["Id_Famille"] : -1;
      bool hasCredit = filters["hasCredit"] != null? filters["hasCredit"] : false;
      bool showBloquer = filters["tierBloquer"] != null? filters["tierBloquer"] : false;

      String clientFournFilter = clientFourn > -1 ? " AND (Clientfour = $clientFourn OR Clientfour = 1)" : "";
      String familleFilter = famille > 0 ? " AND Id_Famille = $famille" : "";
      String hasCreditFilter = hasCredit ? " AND Credit > 0 " : "";
      String showBloquerFilter = showBloquer ? " AND Bloquer > 0 " : "AND Bloquer = 0";

      query += clientFournFilter;
      query += familleFilter;
      query += hasCreditFilter;
      query += showBloquerFilter ;
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

  Future<Tiers> getTierById(int id) async {
    Database dbClient = await _databaseHelper.db;
    var res = await dbClient.rawQuery('SELECT * FROM ' + DbTablesNames.tiers + ' where id like $id');
    Tiers tier = new Tiers.fromMap(res[0]);
    return tier;
  }

  Future<bool> checkTierItems (Tiers item)async{
    Database dbClient = await _databaseHelper.db;
    String tableName = DbTablesNames.pieces;
    String query = "SELECT COUNT(*) FROM $tableName WHERE Tier_id = ${item.id}" ;
    var res = await dbClient.rawQuery(query);

    if(res.first["COUNT(*)"] > 0){
      return true ;
    }

    tableName = DbTablesNames.tresorie;
    res = await dbClient.rawQuery(query);
    if(res.first["COUNT(*)"]>0){
      return true ;
    }

    return false ;
  }

  Future<List<Piece>> getAllPieces(int offset, int limit, {String searchTerm, Map<String, dynamic> filters}) async {
    String query = 'SELECT Pieces.*,Tiers.RaisonSociale FROM Pieces JOIN Tiers ON Pieces.Tier_id = Tiers.id';

    String _piece = filters["Piece"];
    int _mov = filters["Mov"] != null? filters["Mov"] : 0;
    int _tier_id = filters["Tierid"] != null ? filters["Tierid"] : null ;

    String _pieceFilter = _piece != null? " AND Piece like '$_piece'" : "";
    String _movFilter = " AND Mov >= $_mov";


    if(filters["Draft"]){
      _movFilter = " AND Mov >= 2";
    }


    String _creditFilter =""  ;
    if(filters["Credit"]){
      _creditFilter =" AND Reste > 0"  ;
    }

    String _tierFilter= "" ;
    if(_tier_id != null){
      _tierFilter= " AND Tier_id = $_tier_id";
      _creditFilter =" AND Reste > 0"  ;
    }


    Database dbClient = await _databaseHelper.db;
    var res;

    query += " where Num_piece like '%${searchTerm??''}%'";

    query += _pieceFilter;
    query += _movFilter;
    query+=_tierFilter ;
    query += _creditFilter ;


    query += ' ORDER BY id DESC';

    print(query);

    res = await dbClient.rawQuery(query);

    List<Piece> list = new List<Piece>();
    for (var i = 0, j = res.length; i < j; i++) {
      Piece piece = Piece.fromMap(res[i]);
      list.add(piece);
    }

    return list;
  }

  Future<List<Piece>> getAllPiecesByTierId(int tier_id) async{
    Database dbClient = await _databaseHelper.db;
    var res;

    res = await dbClient.query(DbTablesNames.pieces , where: "Reste > 0 AND Tier_id = ?" , whereArgs: [tier_id]);

    List<Piece> list = new List<Piece>();
    for (var i = 0, j = res.length; i < j; i++) {
      Piece piece = Piece.fromMap(res[i]);
      list.add(piece);
    }

    return list ;
  }

  Future <List<Piece>> getPieceByNum(String num_piece , String type_piece) async{
    var dbClient = await _databaseHelper.db ;
    var res = await dbClient.query(DbTablesNames.pieces ,where: 'Num_piece LIKE ? AND Piece LIKE ?', whereArgs: ['$num_piece','$type_piece']);

    List<Piece> list = new List<Piece>();
    for (var i = 0, j = res.length; i < j; i++) {
      Piece piece = Piece.fromMap(res[i]);
      list.add(piece);
    }
    return list;
  }

  Future<Piece> getPieceById(int id) async{
    var dbClient = await _databaseHelper.db ;
    var res = await dbClient.query(DbTablesNames.pieces ,where: 'id = ?', whereArgs: [id]);

    Piece piece = Piece.fromMap(res.first);

    return piece;
  }

  Future<List<Article>> getJournalPiece(Piece piece) async{
    var dbClient = await _databaseHelper.db ;
    String query = 'SELECT Journaux.*,Articles.Ref ,Articles.Designation ,Articles.BytesImageString'
        ' FROM Journaux JOIN Articles ON Journaux.Article_id = Articles.id AND Journaux.Mov <> -2 AND Journaux.Piece_id='+piece.id.toString();
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


  Future<List<Tresorie>> getAllTresories(int offset, int limit, {String searchTerm, Map<String, dynamic> filters}) async {
    String query = 'SELECT * FROM Tresories';

    if(filters != null){
      int categorie = filters["Categorie"] != null? filters["Categorie"] : -1;
      String categorieFilter = categorie > 0 ? " AND Categorie_id = $categorie" : "";

      query += " WHERE Num_tresorie LIKE '%${searchTerm??''}%'";
      query += categorieFilter;
    }
    query += ' ORDER BY id DESC';

    Database dbClient = await _databaseHelper.db;

    var res = await dbClient.rawQuery(query);

    print(query);

    List<Tresorie> list = new List<Tresorie>();
    for (var i = 0; i<res.length; i++) {
      Tresorie tresorie = new Tresorie.fromMap(res[i]);
      list.add(tresorie);
    }

    return list;
  }

  Future<List<Tresorie>> getTresorieByNum(String num) async {
      var dbClient = await _databaseHelper.db ;

      var res =  await dbClient.query(DbTablesNames.tresorie , where: "Num_tresorie LIKE ?" , whereArgs: ['$num']);

      List<Tresorie> list = new List<Tresorie>();
      for (var i = 0; i<res.length; i++) {
        Tresorie tresorie = Tresorie.fromMap(res[i]);
        list.add(tresorie);
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

  Future<List<TresorieCategories>> getAllTresorieCategorie() async {
    Database dbClient = await _databaseHelper.db;
    var res = await dbClient.rawQuery('SELECT * FROM ' + DbTablesNames.categorieTresorie);

    List<TresorieCategories> list = new List<TresorieCategories>();
    for (var i = 0, j = res.length; i < j; i++) {
      TresorieCategories categories = TresorieCategories.fromMap(res[i]);
      list.add(categories);
    }

    return list;
  }

  Future<MyParams> getAllParams() async {
    Database dbClient = await _databaseHelper.db;
    var res = await dbClient.query(DbTablesNames.myparams);

    return new MyParams.frommMap(res[0]);
  }

  Future<DefaultPrinter> getPrinter () async {
    Database dbClient = await _databaseHelper.db;
    var res = await dbClient.query(DbTablesNames.defaultPrinter);

    if(res.isNotEmpty){
      return new DefaultPrinter.fromMap(res.last);
    }

    return null ;
  }

  Future<FormatPrint> getFormatPrint() async {
    Database dbClient = await _databaseHelper.db;
    var res = await dbClient.query(DbTablesNames.formatPrint);

    return new FormatPrint.fromMap(res.last);
  }


  Future<dynamic> addItemToTable(String tableName, item) async {
    var dbClient = await _databaseHelper.db;
    int res = await dbClient.insert(tableName, item.toMap());

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

  Future<int> getLastId(String tableName)async{
    var dbClient = await _databaseHelper.db ;
    String query = "Select Max(id) From $tableName ;" ;

    var res = await dbClient.rawQuery(query);

    return res.first["Max(id)"] ;
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
    Tiers tier = new Tiers(null,"Passagé", "qrcode", 0, 0, 1, "adresse", "ville", "telephone", "000000", "fax", "email", 0, 0, 0, false);
    return tier;
  }

  // Future<Piece> getTestPiece() async {
  //   Piece piece = new Piece("FP", "05555", 0, 1, new DateTime.now(), 1, 1, 1, 10, 10, 10, 10, 0, 10, 15);
  //   return piece;
  // }





}