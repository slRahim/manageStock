import 'dart:async';
import 'dart:io' as io;
import 'dart:io';

import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/models/Tiers.dart';
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

    Database database = await openDatabase(dbPath, version: 2, onCreate: _onCreate);
    return database;
  }

  void _onCreate(Database db, int version) async {

    await createProfileTable(db, version);
    await createArticlesTable(db, version);
    await createTiersTable(db, version);
    await createPiecesTable(db, version);
    await createJournauxTable(db, version);
    await createFormatPieceTable(db ,version);
    await createMyParamTable(db , version);
    await createTriggers(db , version);
    await setInitialData(db, version);

  }

  // les informations de la societe
  Future<void> createProfileTable(Database db, int version) async {
    await db.execute("""CREATE TABLE IF NOT EXISTS Profile (
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        BytesImageString TEXT, 
        Raison VARCHAR (100), 
        CodePin VARCHAR (4), 
        CodePinEnabled integer, 
        Statut integer, 
        Adresse VARCHAR (100), 
        AdresseWeb VARCHAR (100), 
        Ville VARCHAR (25), 
        Departement VARCHAR (25), 
        Pays VARCHAR (25), 
        Cp VARCHAR (5), 
        Telephone VARCHAR (25), 
        Telephone2 VARCHAR (25), 
        Fax VARCHAR (25), 
        Mobile VARCHAR (25), 
        Mobile2 VARCHAR (25), 
        Mail VARCHAR (65), 
        Site VARCHAR (65), 
        Rc VARCHAR (25), 
        Nif VARCHAR (25), 
        Ai VARCHAR (25), 
        Capital Double, 
        Activite TEXT, 
        Nis VARCHAR (25), 
        Codedouane VARCHAR (15), 
        Maposition VARCHAR (20)
        )""");

  }

  // table des artciles
  Future<void> createArticlesTable(Database db, int version) async {
    //table des marques des articles
    await db.execute("""CREATE TABLE IF NOT EXISTS ArticlesMarques (
        
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        Libelle VARCHAR(20),
        BytesImageString TEXT

        )""");

    // table famille des articles
    await db.execute("""CREATE TABLE IF NOT EXISTS ArticlesFamilles (
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        Libelle VARCHAR (20), 
        BytesImageString TEXT
        )""");

    //table des tva de l'article
    await db.execute("""CREATE TABLE IF NOT EXISTS ArticlesTva (
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        Tva Double
        )""");

    await db.execute("""CREATE TABLE IF NOT EXISTS Articles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        Ref VARCHAR (20), 
        BytesImageString TEXT, 
        Designation VARCHAR (100), 
        CodeBar VARCHAR (40), 
        Id_Famille integer REFERENCES ArticlesFamilles (id) ON DELETE SET NULL ON UPDATE CASCADE, 
        Id_Marque integer REFERENCES ArticlesMarques (id) ON DELETE SET NULL ON UPDATE CASCADE, 
        Qte_init Double, 
        Qte Double, 
        Qte_Min Double, 
        Qte_Colis Double, 
        Colis Integer, 
        PrixAchat Double, 
        PMP_init Double, 
        PMP Double, TVA Float, 
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

  }

  //table des client et des fournisseur  ( Clientfour : 0=>cliant , 1=>client/fournisseur , 2=>fournisseur)
  Future<void> createTiersTable(Database db, int version) async {
    // table famille de client ou fournisseur
    await db.execute("""CREATE TABLE IF NOT EXISTS TiersFamilles (
    
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        Libelle VARCHAR (20)
        
        )""");

    await db.execute("""CREATE TABLE IF NOT EXISTS Tiers (
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        BytesImageString TEXT, 
        Clientfour integer, 
        RaisonSociale VARCHAR (20), 
        Latitude Double, 
        Longitude Double, 
        Id_Famille integer REFERENCES TiersFamilles (id) ON DELETE SET NULL ON UPDATE CASCADE, 
        Statut integer, 
        Tarification integer, 
        Adresse VARCHAR (255), 
        Ville VARCHAR (20), 
        Telephone VARCHAR (20), 
        Mobile VARCHAR (20), 
        Fax VARCHAR (20), 
        Email VARCHAR (100), 
        Solde_depart Double, 
        Chiffre_affaires Double, 
        Regler Double, 
        Credit Double, 
        Bloquer integer
        )""");

  }

  //table des factures
  Future<void> createPiecesTable(Database db, int version) async {
    await db.execute("""CREATE TABLE IF NOT EXISTS Pieces (
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        Mov integer DEFAULT 1, 
        Transformer integer DEFAULT 0, 
        Piece VARCHAR (3), 
        Num_piece VARCHAR (15), 
        Date integer, 
        Tier_id integer REFERENCES Tiers (id) ON DELETE SET NULL ON UPDATE CASCADE, 
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

  //table des articles ds une facture
  Future<void> createJournauxTable(Database db, int version) async {
    await db.execute("""CREATE TABLE IF NOT EXISTS Journaux (
    
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        Mov integer DEFAULT 1, 
        Date VARCHAR (50), 
        Piece_id integer REFERENCES Pieces (id) ON DELETE SET NULL ON UPDATE CASCADE, 
        Piece_type VARCHAR (4), 
        Article_id integer REFERENCES Articles (id) ON DELETE SET NULL ON UPDATE CASCADE, 
        Qte Double, 
        Prix_ht Double, 
        Tva Double
        
        )""");
  }

  // table des format et current index pour piece
  Future<void> createFormatPieceTable(Database db , int version) async {
    await db.execute("""CREATE TABLE IF NOT EXISTS FormatPiece (
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        Format VARCHAR (20), 
        Piece VARCHAR (4), 
        Current_index integer
        )""");
  }

  //table speciale pour les paraméter de l'app
  Future<void> createMyParamTable (Database db , int version ) async{

  }

  //fonction speciale pour la creation des triggers de bd
  createTriggers(Database db, int version) async {
    // update_current_index
     await db.execute('''CREATE TRIGGER update_current_index 
        AFTER INSERT ON Pieces 
        FOR EACH ROW 
        BEGIN 
        UPDATE FormatPiece
           SET Current_index = Current_index+1
        WHERE  FormatPiece.Piece LIKE NEW.Piece ; 
        END;
      ''');

     //----------------------------------------------------------------------------------------------------------------------------------------

     //update_articles_qte_insert on insert bon client ======== ok
     await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_articles_qte_onInsert_client
        AFTER INSERT ON Journaux
        FOR EACH ROW
        WHEN  NEW.Mov = 1 AND (NEW.Piece_type = 'BL' OR NEW.Piece_type = 'FC')
        BEGIN
            UPDATE Articles
               SET Qte = Qte - NEW.Qte,
                   Colis = Qte / Qte_Colis
             WHERE id = New.Article_id;
        END;
     ''');


     //update_articles_qte_update on update bon client ====== ok
     await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_articles_qte_onUpdate_client
        AFTER UPDATE ON Journaux
        FOR EACH ROW
        WHEN NEW.Mov = 1 AND (NEW.Piece_type = 'BL' OR NEW.Piece_type = 'FC')
        BEGIN
            UPDATE Articles
               SET Qte = Qte - (NEW.Qte - OLD.Qte) ,
               Colis = Qte / Qte_Colis
             WHERE id = NEW.Article_id ;
        END;
     ''');

     //update_articles_qte_update on update bon client from mov 0/-1/2 to 1
     await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_articles_qte_onUpdate_client_mov1
        AFTER UPDATE ON Journaux
        FOR EACH ROW
        WHEN (OLD.Mov <> NEW.Mov) AND NEW.Mov = 1 AND (NEW.Piece_type = 'BL' OR NEW.Piece_type = 'FC')
        BEGIN
            UPDATE Articles
               SET Qte = Qte - NEW.Qte ,
               Colis = Qte / Qte_Colis
             WHERE id = NEW.Article_id ;
        END;
     ''');

     //update_articles_qte_update on update le mov  bon client
     await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_articles_qte_onUpdate_client_mov
        AFTER UPDATE ON Journaux
        FOR EACH ROW
        WHEN (OLD.Mov <> NEW.Mov) AND (OLD.Mov = 1) AND (NEW.Mov = 0 OR NEW.Mov = 2 OR NEW.Mov = -1 OR NEW.Mov = -2)
              AND (NEW.Piece_type = 'BL' OR NEW.Piece_type = 'FC')      
        BEGIN
            UPDATE Articles
               SET Qte = Qte + OLD.Qte ,
                   Colis = Qte / Qte_Colis
             WHERE id = New.Article_id;
        END;
     ''');

     //update_articles_qte_delete on delete piece client
     await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_articles_qte_onDelete_client
        AFTER DELETE ON Journaux
        FOR EACH ROW
        WHEN (OLD.Piece_type = 'BL' OR OLD.Piece_type = 'FC') AND OLD.Mov = 1
        BEGIN
            UPDATE Articles
               SET Qte = Qte + OLD.Qte,
                   Colis = Qte / Qte_Colis
             WHERE id = OLD.Article.id;
        END;
     ''');

     //-----------------------------------------------------------------------------------------------------------------------------

     //update_articles_qte_insert on insert bon fournisseur
     await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_articles_qte_onInsert_fournisseur
        AFTER INSERT ON Journaux
        FOR EACH ROW
        WHEN NEW.Mov = 1 AND (NEW.Piece_type = 'BR' OR NEW.Piece_type = 'FF')
        BEGIN
            UPDATE Articles
               SET PMP = ((Qte * PMP)+(NEW.Qte * NEW.Prix_ht))/(Qte + NEW.Qte) , 
                   Qte = Qte + NEW.Qte,
                   Colis = Qte / Qte_Colis,
                   PrixAchat = NEW.Prix_ht
             WHERE id = New.Article_id;
        END;
     ''');

     //update_articles_qte_update on update bon fournisseur
     await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_articles_qte_onUpdate_fournisseur
        AFTER UPDATE ON Journaux
        FOR EACH ROW
        WHEN NEW.Mov = 1 AND (NEW.Piece_type = 'BR' OR NEW.Piece_type = 'FF')
        BEGIN
            UPDATE Articles
               SET Qte = Qte + (NEW.Qte-OLD.Qte),
                   Colis = Qte / Qte_Colis
             WHERE id = New.Article_id;
        END;
     ''');

     //update_articles_qte_update on update bon fournisseur from -1/0/2 to 1
     await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_articles_qte_onUpdate_fournisseur_mov1
        AFTER UPDATE ON Journaux
        FOR EACH ROW
        WHEN (OLD.Mov <> NEW.Mov) AND NEW.Mov = 1 AND (NEW.Piece_type = 'BR' OR NEW.Piece_type = 'FF')
        BEGIN
            UPDATE Articles
               SET Qte = Qte + NEW.Qte,
                   Colis = Qte / Qte_Colis
             WHERE id = New.Article_id;
        END;
     ''');

     //update_articles_qte_update on update le mov bon fournisseur
     await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_articles_qte_onUpdate_fournisseur_mov
        AFTER UPDATE ON Journaux
        FOR EACH ROW
        WHEN  (OLD.Mov <> NEW.Mov) AND (OLD.Mov = 1) AND (NEW.Mov = 0 OR NEW.Mov = 2 OR NEW.Mov = -1 OR NEW.Mov = -2)
              AND (NEW.Piece_type = 'BR' OR NEW.Piece_type = 'FF') 
        BEGIN
            UPDATE Articles
               SET Qte = Qte - OLD.Qte,
                   Colis = Qte / Qte_Colis
             WHERE id = New.Article_id;
        END;
     ''');

     //update_articles_qte_delete on delete piece fournisseur
     await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_articles_qte_onDelete_fournisseur
        AFTER DELETE ON Journaux
        FOR EACH ROW
        WHEN (NEW.Piece_type = 'BR' OR NEW.Piece_type = 'FF') AND OLD.Mov = 1
        BEGIN
            UPDATE Articles
               SET Qte = Qte - OLD.Qte,
                   Colis = Qte / Qte_Colis
             WHERE id = OLD.Article.id;
        END;
     ''');

     //supp journale de la piece avant supp piece
     await db.execute('''
        CREATE TRIGGER IF NOT EXISTS delete_journaux
        BEFORE DELETE ON Pieces
        FOR EACH ROW
        BEGIN
            DELETE FROM Journaux
                  WHERE Piece_id = OLD.id;
        END;
     ''');

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

    batch.rawInsert('INSERT INTO FormatPiece(Format , Piece , Current_index) VALUES("XXXX/YYYY"  , "FP" , 0)');
    batch.rawInsert('INSERT INTO FormatPiece(Format , Piece , Current_index) VALUES("XXXX/YYYY"  , "CC" , 0)');
    batch.rawInsert('INSERT INTO FormatPiece(Format , Piece , Current_index) VALUES("XXXX/YYYY"  , "BL" , 0)');
    batch.rawInsert('INSERT INTO FormatPiece(Format , Piece , Current_index) VALUES("XXXX/YYYY"  , "FC" , 0)');
    batch.rawInsert('INSERT INTO FormatPiece(Format , Piece , Current_index) VALUES("XXXX/YYYY"  , "RC" , 0)');
    batch.rawInsert('INSERT INTO FormatPiece(Format , Piece , Current_index) VALUES("XXXX/YYYY"  , "AF" , 0)');
    batch.rawInsert('INSERT INTO FormatPiece(Format , Piece , Current_index) VALUES("XXXX/YYYY"  , "BC" , 0)');
    batch.rawInsert('INSERT INTO FormatPiece(Format , Piece , Current_index) VALUES("XXXX/YYYY"  , "BR" , 0)');
    batch.rawInsert('INSERT INTO FormatPiece(Format , Piece , Current_index) VALUES("XXXX/YYYY"  , "FF" , 0)');
    batch.rawInsert('INSERT INTO FormatPiece(Format , Piece , Current_index) VALUES("XXXX/YYYY"  , "RF" , 0)');
    batch.rawInsert('INSERT INTO FormatPiece(Format , Piece , Current_index) VALUES("XXXX/YYYY"  , "AC" , 0)');

    Tiers tier0 = new Tiers(null, "Passagé", "qrcode", 0, 0, 1, "adresse", "ville", "telephone", "000000", "fax", "email", 0, 0, 0, false);
    tier0.clientFour = 0 ;
    batch.insert(DbTablesNames.tiers, tier0.toMap());

    Tiers tier2 = new Tiers(null, "Passagé", "qrcode", 0, 0, 1, "adresse", "ville", "telephone", "000000", "fax", "email", 0, 0, 0, false);
    tier2.clientFour = 2 ;
    batch.insert(DbTablesNames.tiers, tier2.toMap());

    await batch.commit();


  }






}
