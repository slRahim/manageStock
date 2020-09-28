import 'dart:async';
import 'dart:io' as io;
import 'dart:io';

import 'package:path/path.dart';
import 'package:gestmob/models/Article.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'Helpers.dart';

class SqlLiteDatabaseHelper {
  static final SqlLiteDatabaseHelper _instance =
      new SqlLiteDatabaseHelper.internal();
  factory SqlLiteDatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  SqlLiteDatabaseHelper.internal();

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'gestmob.db');

    Database database = await openDatabase(dbPath, version: 1, onCreate: _onCreate);
    return database;
  }

  void _onCreate(Database db, int version) async {


    await createProfileTable(db, version);
    await createArticlesTable(db, version);
    await createTiersTable(db, version);
    await createPiecesTable(db, version);
    await createJournauxTable(db, version);

    await setInitialData(db, version);

  }

  Future<void> createProfileTable(Database db, int version) async {
    await db.execute("""CREATE TABLE IF NOT EXISTS Profile (
        
        id INTEGER PRIMARY KEY,
        BytesImageString TEXT,
        Raison VARCHAR(100),
        CodePin VARCHAR(4),
        CodePinEnabled integer,
        Statut integer,
        Adresse VARCHAR(100),
        AdresseWeb VARCHAR(100),
        Ville VARCHAR(25),
        Departement VARCHAR(25),
        Pays VARCHAR(25),
        Cp VARCHAR(5),
        Telephone VARCHAR(25),
        Telephone2 VARCHAR(25),
        Fax VARCHAR(25),
        Mobile VARCHAR(25),
        Mobile2 VARCHAR(25),
        Mail VARCHAR(65),
        Site VARCHAR(65),
        Rc VARCHAR(25),
        Nif VARCHAR(25),
        Ai VARCHAR(25),
        Capital Double,
        Activite TEXT,
        Nis VARCHAR(25),
        Codedouane VARCHAR(15),
        Maposition VARCHAR(20)
        
        )""");

  }

  Future<void> createArticlesTable(Database db, int version) async {
    await db.execute("""CREATE TABLE IF NOT EXISTS Articles (
        
        id INTEGER PRIMARY KEY,
        Ref VARCHAR(20),
        BytesImageString TEXT,
        Designation VARCHAR(100),
        CodeBar VARCHAR(40),
        Id_Famille integer,
        Id_Marque integer,
        Qte_init Double,
        Qte Double,
        Qte_Min Double,
        Qte_Colis Double,
        Colis Integer,
        PrixAchat Double,
        PMP_init Double,
        PMP Double,
        TVA Float,
        PrixVente1 Double,
        PrixVente2 Double,
        PrixVente3 Double,
        PrixVente1TTC Double,
        PrixVente2TTC Double,
        PrixVente3TTC Double,
        Bloquer integer,
        Description TEXT,
        Stockable integer

        )""");


    await db.execute("""CREATE TABLE IF NOT EXISTS ArticlesMarques (
        
        id INTEGER PRIMARY KEY,
        Libelle VARCHAR(20),
        BytesImageString TEXT

        )""");


    await db.execute("""CREATE TABLE IF NOT EXISTS ArticlesFamilles (
        
        id INTEGER PRIMARY KEY,
        Libelle VARCHAR(20),
        BytesImageString TEXT

        )""");


    await db.execute("""CREATE TABLE IF NOT EXISTS ArticlesTva (
        
        id INTEGER PRIMARY KEY,
        Tva Double

        )""");
  }

  Future<void> createTiersTable(Database db, int version) async {
    await db.execute("""CREATE TABLE IF NOT EXISTS Tiers (
        
        id INTEGER PRIMARY KEY,
        BytesImageString TEXT,
        Clientfour integer,
        RaisonSociale VARCHAR(20),
        Latitude Double,
        Longitude Double,
        Id_Famille integer,
        Statut integer,
        Tarification integer,
        Adresse VARCHAR(255),
        Ville VARCHAR(20),
        Telephone VARCHAR(20),
        Mobile VARCHAR(20),
        Fax VARCHAR(20),
        Email VARCHAR(100),
        Solde_depart Double,
        Chiffre_affaires Double,
        Regler Double,
        Credit Double,
        Bloquer integer

        )""");


    await db.execute("""CREATE TABLE IF NOT EXISTS TiersFamilles (
        
        id INTEGER PRIMARY KEY,
        Libelle VARCHAR(20)

        )""");
  }

  Future<void> createPiecesTable(Database db, int version) async {
    await db.execute("""CREATE TABLE IF NOT EXISTS Pieces (
        
        id INTEGER PRIMARY KEY,
        Mov integer DEFAULT 1,
        Transformer integer DEFAULT 1,
        Piece VARCHAR(3),
        Num_piece VARCHAR(15),
        Date integer,
        Tier_id integer,
        Tarification integer,
        Total_ht Double,
        Total_tva Double,
        Total_ttc Double,
        Timbre Double,
        Net_a_payer Double,
        Regler Double,
        Reste Double

        )""");
  }

  Future<void> createJournauxTable(Database db, int version) async {
    await db.execute("""CREATE TABLE IF NOT EXISTS Journaux (
        
        id INTEGER PRIMARY KEY,
        Mov integer DEFAULT 1,
        Date VARCHAR(50),
        Piece_id integer,
        Article_id integer,
        Qte Double,
        Prix_ht Double,
        Tva Double

        )""");
  }

  Future<void> setInitialData(Database db, int version) async {
    Batch batch = db.batch();

    batch.rawInsert('INSERT INTO Profile(BytesImageString, Raison, CodePin, CodePinEnabled, Statut, Adresse, AdresseWeb, Ville, Departement, Pays, Cp, Telephone, Telephone2, Fax, Mobile, Mobile2,'
        'Mail, Site, Rc, Nif, Ai, Capital, Activite, Nis, Codedouane, Maposition) '
        'VALUES("", "Raison", "", 0, 1, "Adresse", "AdresseWeb", "Ville", "Departement", "Pays", "Cp", "Telephone", "Telephone2", "Fax", "Mobile", "Mobile2",'
        '"Mail", "Site", "Rc", "Nif", "Ai", "25", "Activite", "Nis", "Codedouane", "Maposition")');

    batch.rawInsert('INSERT INTO ArticlesMarques(Libelle, BytesImageString) VALUES("Marque", "")');
    batch.rawInsert('INSERT INTO ArticlesMarques(Libelle, BytesImageString) VALUES("Marque 1", "")');
    batch.rawInsert('INSERT INTO ArticlesMarques(Libelle, BytesImageString) VALUES("Marque 2", "")');
    batch.rawInsert('INSERT INTO ArticlesMarques(Libelle, BytesImageString) VALUES("Marque 3", "")');
    batch.rawInsert('INSERT INTO ArticlesMarques(Libelle, BytesImageString) VALUES("Marque 4", "")');

    batch.rawInsert('INSERT INTO ArticlesFamilles(Libelle, BytesImageString) VALUES("Famille", "")');
    batch.rawInsert('INSERT INTO ArticlesFamilles(Libelle, BytesImageString) VALUES("Famille 1", "")');
    batch.rawInsert('INSERT INTO ArticlesFamilles(Libelle, BytesImageString) VALUES("Famille 2", "")');
    batch.rawInsert('INSERT INTO ArticlesFamilles(Libelle, BytesImageString) VALUES("Famille 3", "")');
    batch.rawInsert('INSERT INTO ArticlesFamilles(Libelle, BytesImageString) VALUES("Famille 4", "")');

    batch.rawInsert('INSERT INTO TiersFamilles(Libelle) VALUES("Famille")');
    batch.rawInsert('INSERT INTO TiersFamilles(Libelle) VALUES("Famille 1")');
    batch.rawInsert('INSERT INTO TiersFamilles(Libelle) VALUES("Famille 2")');
    batch.rawInsert('INSERT INTO TiersFamilles(Libelle) VALUES("Famille 3")');
    batch.rawInsert('INSERT INTO TiersFamilles(Libelle) VALUES("Famille 4")');

    batch.rawInsert('INSERT INTO ArticlesTva(Tva) VALUES(0)');
    batch.rawInsert('INSERT INTO ArticlesTva(Tva) VALUES(10)');
    batch.rawInsert('INSERT INTO ArticlesTva(Tva) VALUES(19)');
    batch.rawInsert('INSERT INTO ArticlesTva(Tva) VALUES(29)');

    await batch.commit();

  }




}
