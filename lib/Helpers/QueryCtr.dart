import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gestmob/Helpers/SqlLiteDatabaseHelper.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/models/Article.dart';
import 'package:gestmob/models/ArticleFamille.dart';
import 'package:gestmob/models/ArticleMarque.dart';
import 'package:gestmob/models/ArticleTva.dart';
import 'package:gestmob/models/ChargeTresorie.dart';
import 'package:gestmob/models/CompteTresorie.dart';
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

  //*****************************************************************************************************************************************************************
  //************************************************************************special backup&restore*****************************************************************************
  Future createBackup()async{
    var res = await _databaseHelper.generateBackup(isEncrypted: true);
    return res ;
  }

  Future restoreBackup(File backup)async{
    var res = await _databaseHelper.restoreBackup(backup,isEncrypted: true);
    return res ;
  }

  //*****************************************************************************************************************************************************************
  //*******************************************************************logique metier******************************************************************************
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

      String clientFournFilter = "";
      if(clientFourn > -1){
        clientFournFilter = " AND (Clientfour = $clientFourn OR Clientfour = 1)" ;
      }
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
    String query = 'SELECT Pieces.*,Tiers.RaisonSociale,Tiers.Mobile FROM Pieces JOIN Tiers ON Pieces.Tier_id = Tiers.id';

    String _piece = filters["Piece"];
    int _mov = filters["Mov"] != null? filters["Mov"] : 0;
    int _tier_id = filters["Tierid"] != null ? filters["Tierid"] : null ;

    String _pieceFilter = _piece != null? " AND Piece like '$_piece'" : " AND (Piece like 'BL' OR Piece like 'FC')";
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
      _movFilter = " AND Mov = 1";
    }


    Database dbClient = await _databaseHelper.db;
    var res;

    query += " where (Num_piece like '%${searchTerm??''}%' OR Tiers.RaisonSociale like '%${searchTerm??''}%')";


    query += _pieceFilter;
    query += _movFilter;
    query+=_tierFilter ;
    query += _creditFilter ;

    query += ' ORDER BY id DESC';


    res = await dbClient.rawQuery(query);

    List<Piece> list = new List<Piece>();
    for (var i = 0, j = res.length; i < j; i++) {
      Piece piece = Piece.fromMap(res[i]);
      list.add(piece);
    }

    if(filters["Piece"] == null){
      MyParams _params = await getAllParams();
      List<Piece> listcredit = new List<Piece>();
      for(int i=0 ; i<list.length;i++){
        if(list[i].date.add(Duration(days: Statics.echeances[_params.echeance])).isBefore(DateTime.now())){
          listcredit.add(list[i]);
        }
      }
      return listcredit ;
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
    String query = 'SELECT Pieces.*,Tiers.RaisonSociale FROM Pieces JOIN Tiers ON Pieces.Tier_id = Tiers.id AND Pieces.id = ${id}';
    var res = await dbClient.rawQuery(query);
    print(res.length);
    Piece piece = Piece.fromMap(res.first);

    return piece;
  }

  Future<bool> pieceHasCredit () async{
    var dbClient = await _databaseHelper.db ;
    var res = await dbClient.query(DbTablesNames.pieces , where: "Reste > 0 AND (Piece LIKE 'BL' OR Piece LIKE 'FC') ");
    MyParams _params = await getAllParams();
    
    List<Piece> list = new List<Piece>();
    res.forEach((p) {
      Piece piece = Piece.fromMap(p);
      list.add(piece);
    });

    for(int i = 0 ; i<list.length ; i++){
      if(list[i].date.add(Duration(days: Statics.echeances[_params.echeance])).isBefore(DateTime.now())){
        return true ;
      }
    }

    return false ;
  }

  Future<List<Article>> getJournalPiece(Piece piece , {bool local,String searchTerm,Map<String, dynamic> filters}) async{
    var dbClient = await _databaseHelper.db ;
    String query = 'SELECT Journaux.*,Articles.*'
        ' FROM Journaux JOIN Articles ON Journaux.Article_id = Articles.id AND Journaux.Mov <> -2 AND Journaux.Piece_id='+piece.id.toString();

    if(local && filters != null){
      int marque = filters["Id_Marque"] != null? filters["Id_Marque"] : -1;
      int famille = filters["Id_Famille"] != null? filters["Id_Famille"] : -1;

      String marqueFilter = marque > 0 ? " AND Articles.Id_Marque = $marque" : "";
      String familleFilter = famille > 0 ? " AND Articles.Id_Famille = $famille" : "";

      query += marqueFilter;
      query += familleFilter;

      query += " where (Designation like '%${searchTerm??''}%' OR CodeBar like '%${searchTerm??''}%' OR Ref like '%${searchTerm??''}%')";
    }

    var res = await dbClient.rawQuery(query);

    List<Article> list = new List<Article>();
    for(int i=0 ; i<res.length ; i++){
      Article article = Article.fromMapJournaux(res[i]);
      if(local){
        article.setquantite(article.selectedQuantite ) ;
        article.selectedQuantite = -1 ;
        article.setQteMin(-1);
        article.cmdClient = 0 ;
      }
      list.add(article);
    }
    return list ;
  }

  Future<List> getJournauxByTier({int offset, int limit, String searchTerm, Map<String, dynamic> filters})async{
     Database dbClient = await _databaseHelper.db;
     List<Piece> pieces = new List<Piece>();

     var res = await dbClient.query(DbTablesNames.pieces , where: "Tier_id = ?" , whereArgs: [filters["idTier"].id]);
     for (var i = 0, j = res.length; i < j; i++) {
       Piece piece = Piece.fromMap(res[i]);
       pieces.add(piece);
     }

     List articles = new List ();
     var res1 ;

     for(int i= 0 ; i<pieces.length ; i++){
       if(pieces[i].piece == filters["pieceType"] && pieces[i].etat == 0){
         res1 =  await getJournalPiece(pieces[i],local: true , searchTerm: searchTerm ,filters: filters);
         articles.addAll(res1);
       }
     }

    return articles ;
  }

  Future<int> updateJournaux(String tableName, item)async{
    var dbClient = await _databaseHelper.db ;
    var res = await dbClient.update(tableName, item.toMap(), where: "Piece_id = ? AND Article_id = ?" , whereArgs: [item.piece_id , item.article_id] );

    return res ;
  }

  Future<List<Tresorie>> getAllTresories(int offset, int limit, {String searchTerm, Map<String, dynamic> filters}) async {
    String query = 'SELECT * FROM Tresories';

    query += " WHERE (Montant > 0 OR Montant < 0)";

    if(filters != null){
      int categorie = filters["Categorie"] != null? filters["Categorie"] : -1;
      String categorieFilter = categorie > 1 ? " AND Categorie_id = $categorie" : "";

      query += " AND (Num_tresorie LIKE '%${searchTerm??''}%' OR Tier_rs LIKE '%${searchTerm??''}%' OR Objet LIKE '%${searchTerm??''}%')";
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

  Future<double> getVerssementSolde(Tiers item)async{
    var dbClient = await _databaseHelper.db ;

    var res = await dbClient.rawQuery('SELECT * FROM Tresories WHERE Tier_id = ${item.id}');
    List<Tresorie> list = new List<Tresorie>();
    for (var i = 0; i<res.length; i++) {
      Tresorie tresorie = new Tresorie.fromMap(res[i]);
      list.add(tresorie);
    }
    double sum = 0 ;
    for(int i = 0 ; i<list.length ; i++){
      var res1 = await dbClient.rawQuery("Select Sum(Regler) From ReglementTresorie Where Tresorie_id = ${list[i].id}");
      sum = sum + ((res1.first["Sum(Regler)"] != null)? res1.first["Sum(Regler)"] :0 );
    }
    return sum ;
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

  Future<int> updateItemByForeignKey (String tableName , item ,value, String column , key) async {
    var dbClient = await _databaseHelper.db ;
    int res = await dbClient.rawUpdate('''
      UPDATE ${tableName}
        SET ${item} = ${value}
      WHERE ${column} = ${key} ;
    ''');
    return res ;
  }

  Future<int> removeItemFromTable(String tableName , item)async {
    var dbClient = await _databaseHelper.db ;
    int res = await dbClient.delete(tableName , where: "id=?" , whereArgs: [item.id]);

    return res ;
  }

  Future<int> removeItemWithForeignKey (String tableName , item , String column) async {
    var dbClient = await _databaseHelper.db ;
    int res = await dbClient.delete(tableName , where: "${column} = ?" , whereArgs: [item]);

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

  //*****************************************************************************************************************************************************************
  //************************************************************************special statistique**********************************************************************
  Future<Map<int , dynamic>> statIndiceFinanciere() async{
    var dbClient = await _databaseHelper.db;
    Map<int , dynamic> result = new Map<int , dynamic>();
    String query1="Select Sum(Chiffre_affaires) From Tiers Where Clientfour = 0 ;";
    String query2="Select Sum(Regler) From Tiers Where Clientfour = 0 ;";
    String query3="Select Sum(Regler) From Tiers Where Clientfour = 2 ;";
    String query4="Select Sum(Net_a_payer) From Pieces Where Mov=1 AND (Piece LIKE 'BR' OR Piece LIKE 'FF') ;";
    String query5="Select Sum(Marge) From Pieces Where Mov=1 AND (Piece LIKE 'BL' OR Piece LIKE 'FC') ;";

    var res1 = await dbClient.rawQuery(query1);
    var res2 = await dbClient.rawQuery(query2);
    var res3 = await dbClient.rawQuery(query3);
    var res4 = await dbClient.rawQuery(query4);
    var res5 = await dbClient.rawQuery(query5);

    result={
      0 :  res1.first["Sum(Chiffre_affaires)"],
      1 :  res2.first["Sum(Regler)"],
      2 :  res3.first["Sum(Regler)"],
      3 :  res4.first["Sum(Net_a_payer)"],
      4 :  res5.first["Sum(Marge)"],
    };

    return result ;
  }

  Future<List<CompteTresorie>> statSoldeCompte()async{
     var dbClient = await _databaseHelper.db;
     var res = await dbClient.query(DbTablesNames.compteTresorie);

     List<CompteTresorie> list = new List<CompteTresorie>();
     for(int i =0 ; i<res.length ; i++){
       CompteTresorie item = new CompteTresorie.fromMap(res[i]);
       list.add(item);
     }

     return list ;
  }

  Future statCharge() async{
    var dbClient = await _databaseHelper.db;
    String query = "Select Tresories.Charge_id ,ChargeTresorie.* ,Sum(Montant) From Tresories JOIN ChargeTresorie ON Tresories.Charge_id = ChargeTresorie.id "+
        "Where Mov=1 AND Categorie_id=5 Group BY Charge_id ORDER BY Sum(Montant) DESC LIMIT 5 ;";

    var res = await dbClient.rawQuery(query);

    return res ;
  }

  Future statVenteArticle()async{
    var dbClient = await _databaseHelper.db;
    String query = "Select Journaux.Article_id ,Articles.Ref, Articles.Designation ,Articles.BytesImageString, Sum(Journaux.Qte*Journaux.Net_ht) From Journaux JOIN Articles ON Journaux.Article_id = Articles.id "+
        "Where Mov = 1 AND (Piece_type LIKE 'BL' OR Piece_type LIKE 'FC') Group BY Article_id ORDER BY Sum(Journaux.Qte*Journaux.Net_ht) DESC LIMIT 5 ;";

    var res = await dbClient.rawQuery(query);

    return(res);
  }

  Future<List> statVenteClient() async{
    var dbClient = await _databaseHelper.db;
    String query="Select * From Tiers Where Clientfour = 0 ORDER BY Chiffre_affaires DESC LIMIT 5 ;";

    var res = await dbClient.rawQuery(query);

    List<Tiers> list = new List<Tiers>();
    for(int i =0 ; i<res.length ; i++){
      Tiers item = new Tiers.fromMap(res[i]);
      list.add(item);
    }

    return list ;
  }

  Future statVenteFamille()async{
    var dbClient = await _databaseHelper.db;
    String query = "Select ArticlesFamilles.*, Sum(Journaux.Qte*Journaux.Net_ht) From Journaux "+
      "LEFT JOIN Articles ON Journaux.Article_id = Articles.id "+
      "LEFT JOIN ArticlesFamilles ON Articles.Id_Famille+1 = ArticlesFamilles.id "+
      "Where Mov = 1 AND (Piece_type LIKE 'BL' OR Piece_type LIKE 'FC')  "+
      "Group BY ArticlesFamilles.id "+
      "ORDER BY Sum(Journaux.Qte*Journaux.Net_ht) DESC LIMIT 5 ;";


    var res = await dbClient.rawQuery(query);

    print(res);
    return(res);
  }

  Future statAchatArticle()async{
    var dbClient = await _databaseHelper.db;
    String query = "Select Journaux.Article_id , Articles.Ref , Articles.Designation,Articles.BytesImageString, Sum(Journaux.Qte*Journaux.Net_ht) From Journaux JOIN Articles ON Journaux.Article_id = Articles.id "+
        "Where Mov = 1 AND (Piece_type LIKE 'BR' OR Piece_type LIKE 'FF') Group BY Article_id ORDER BY Sum(Journaux.Qte*Journaux.Net_ht) DESC LIMIT 5 ;";

    var res = await dbClient.rawQuery(query);

    return(res);
  }

  Future<List<Tiers>> statAchatFournisseur()async{
    var dbClient = await _databaseHelper.db;
    String query="Select * From Tiers Where Clientfour = 2 ORDER BY Chiffre_affaires DESC LIMIT 5 ;";

    var res = await dbClient.rawQuery(query);

    List<Tiers> list = new List<Tiers>();
    for(int i =0 ; i<res.length ; i++){
      Tiers item = new Tiers.fromMap(res[i]);
      list.add(item);
    }

    return list ;
  }

//**********************************************************************************************************************************************************************************
//************************************************************************special statistique****************************************************************************************
  Future rapportVente(int rapport , DateTime start , DateTime end ) async {
    var dbClient = await _databaseHelper.db;
     String query="" ;
     int dateStart = start.millisecondsSinceEpoch ;
     int dateEnd = end.millisecondsSinceEpoch ;
     switch(rapport){
       case 0 :
         query = """
         Select Articles.Ref , Articles.Designation , Sum(Journaux.Qte) as qte , 
                Sum(Journaux.Marge*Journaux.Qte)/Sum(Journaux.Qte) as Marge_u ,
                (Sum(Journaux.Marge*Journaux.Qte)/Sum(Journaux.Qte)*Sum(Journaux.Qte)) as Marge_total
         From Journaux 
         Join Articles ON Journaux.Article_id = Articles.id 
         Where Journaux.Mov = 1 AND (Piece_type like 'BL' OR Piece_type like 'FC') AND  Journaux.Date Between ${dateStart} AND ${dateEnd}
         Group By Articles.Ref 
         order by Articles.Ref
         """;
         break;
       case 1 :
         query = """
         Select Articles.Ref , Articles.Designation , Sum(Journaux.Qte) as qte , 
                Sum(Journaux.Prix_ht*Journaux.Qte)/Sum(Journaux.Qte) as Prix_ht,
                (Sum(Journaux.Prix_ht*Journaux.Qte)/Sum(Journaux.Qte)*Sum(Journaux.Qte)) as Montant
         From Journaux 
         Join Articles ON Journaux.Article_id = Articles.id 
         Where Journaux.Mov = 1 AND Piece_type like 'CC'  AND  Journaux.Date Between ${dateStart} AND ${dateEnd}
         Group By Articles.Ref 
         order by Articles.Ref
         """;
         break;
       case 2 :
         query = """
         Select Journaux.Piece_type ,Pieces.Num_piece ,Pieces.Date ,Articles.Ref ,Articles.Designation ,Tiers.RaisonSociale as Client ,
                Journaux.Qte ,Journaux.Prix_ht , (Journaux.Prix_ht * Journaux.Qte) as Montant
         From Journaux 
         Left Join Pieces ON Journaux.Piece_id = Pieces.id 
         Left Join Tiers ON Pieces.Tier_id = Tiers.id 
         Left Join Articles ON Journaux.Article_id = Articles.id 
         Where Journaux.Mov = 1 AND (Piece_type like 'BL' OR Piece_type like 'FC')  AND  Journaux.Date Between ${dateStart} AND ${dateEnd}
         order by Pieces.Num_piece
         """;
         break;
       case 3 :
         query = """
         Select Journaux.Piece_type ,Pieces.Num_piece ,Pieces.Date ,Articles.Ref ,Articles.Designation ,Tiers.RaisonSociale as Client ,
                Journaux.Qte ,Journaux.Prix_ht , (Journaux.Prix_ht * Journaux.Qte) as Montant
         From Journaux 
         Left Join Pieces ON Journaux.Piece_id = Pieces.id 
         Left Join Tiers ON Pieces.Tier_id = Tiers.id 
         Left Join Articles ON Journaux.Article_id = Articles.id 
         Where Journaux.Mov = 1 AND Piece_type like 'CC'   AND  Journaux.Date Between ${dateStart} AND ${dateEnd}
         order by Pieces.Num_piece
         """;
         break;
     }

     var res = await dbClient.rawQuery(query);
     return res ;
  }

  Future rapportAchat(int rapport , DateTime start , DateTime end ) async {
    var dbClient = await _databaseHelper.db;
    String query="" ;
    int dateStart = start.millisecondsSinceEpoch ;
    int dateEnd = end.millisecondsSinceEpoch ;
    switch(rapport){
      case 0 :
        query = """
         Select Articles.Ref , Articles.Designation , Sum(Journaux.Qte) as qte , 
                Sum(Journaux.Marge*Journaux.Qte)/Sum(Journaux.Qte) as Marge_u ,
                (Sum(Journaux.Marge*Journaux.Qte)/Sum(Journaux.Qte)*Sum(Journaux.Qte)) as Marge_total
         From Journaux 
         Join Articles ON Journaux.Article_id = Articles.id 
         Where Journaux.Mov = 1 AND (Piece_type like 'BR' OR Piece_type like 'FF') AND  Journaux.Date Between ${dateStart} AND ${dateEnd}
         Group By Articles.Ref 
         order by Articles.Ref
         """;
        break;
      case 1 :
        query = """
         Select Articles.Ref , Articles.Designation , Sum(Journaux.Qte) as qte , 
                Sum(Journaux.Prix_ht*Journaux.Qte)/Sum(Journaux.Qte) as Prix_ht,
                (Sum(Journaux.Prix_ht*Journaux.Qte)/Sum(Journaux.Qte)*Sum(Journaux.Qte)) as Montant
         From Journaux 
         Join Articles ON Journaux.Article_id = Articles.id 
         Where Journaux.Mov = 0 AND Piece_type like 'BC'  AND  Journaux.Date Between ${dateStart} AND ${dateEnd}
         Group By Articles.Ref 
         order by Articles.Ref
         """;
        break;
      case 2 :
        query = """
         Select Journaux.Piece_type ,Pieces.Num_piece ,Pieces.Date ,Articles.Ref ,Articles.Designation ,Tiers.RaisonSociale as Client ,
                Journaux.Qte ,Journaux.Prix_ht , (Journaux.Prix_ht * Journaux.Qte) as Montant
         From Journaux 
         Left Join Pieces ON Journaux.Piece_id = Pieces.id 
         Left Join Tiers ON Pieces.Tier_id = Tiers.id 
         Left Join Articles ON Journaux.Article_id = Articles.id 
         Where Journaux.Mov = 1 AND (Piece_type like 'BR' OR Piece_type like 'FF')  AND  Journaux.Date Between ${dateStart} AND ${dateEnd}
         order by Pieces.Num_piece
         """;
        break;
      case 3 :
        query = """
         Select Journaux.Piece_type ,Pieces.Num_piece ,Pieces.Date ,Articles.Ref ,Articles.Designation ,Tiers.RaisonSociale as Client ,
                Journaux.Qte ,Journaux.Prix_ht , (Journaux.Prix_ht * Journaux.Qte) as Montant
         From Journaux 
         Left Join Pieces ON Journaux.Piece_id = Pieces.id 
         Left Join Tiers ON Pieces.Tier_id = Tiers.id 
         Left Join Articles ON Journaux.Article_id = Articles.id 
         Where Journaux.Mov = 0 AND Piece_type like 'BC'   AND  Journaux.Date Between ${dateStart} AND ${dateEnd}
         order by Pieces.Num_piece
         """;
        break;
    }

    var res = await dbClient.rawQuery(query);
    return res ;
  }

  Future rapportStock(int rapport) async {
    var dbClient = await _databaseHelper.db;
    String query="" ;

    switch(rapport){
      case 0 :
        query = """
        Select Ref ,Designation , Qte , PMP , (Qte*PMP) as Valeur_Stock
        From Articles where Qte > 0
        """;
        break;
      case 1 :
        query = """
        Select Ref ,Designation , Qte , Qte_Min, PMP , (Qte*PMP) as Valeur_Stock
        From Articles where Qte < 1 OR Qte < Qte_Min
        """;
        break;
      case 2 :
        query = """
        Select Ref ,Designation , Qte , PrixVente1, (Qte*PrixVente1) as chifre_affaire
        From Articles where Qte > 0
        """;
        break;
    }

    var res = await dbClient.rawQuery(query);
    return res ;
  }

  Future rapportTier(int rapport) async {
    var dbClient = await _databaseHelper.db;
    String query="" ;

    switch(rapport){
      case 0 :
        query = """
        Select RaisonSociale , Mobile , Chiffre_affaires , Regler , Credit 
        From Tiers where Clientfour = 0 
        """;
        break;
      case 1 :
        query = """
        Select RaisonSociale , Mobile , Chiffre_affaires , Regler , Credit 
        From Tiers where Clientfour = 2 
        """;
        break;
    }

    var res = await dbClient.rawQuery(query);
    return res ;
  }

  Future rapportGeneral(int rapport , DateTime start , DateTime end ) async {
    var dbClient = await _databaseHelper.db;
    String query="" ;
    int dateStart = start.millisecondsSinceEpoch ;
    int dateEnd = end.millisecondsSinceEpoch ;
    switch(rapport){
      case 0 :
        query = """
        """;
        break;
      case 1 :
        query = "";
        break;
      case 2 :
        query = "";
        break;
    }

    var res = await dbClient.rawQuery(query);
    return res ;
  }

}