import 'dart:async';
import 'dart:io' as io;
import 'dart:io';
import 'dart:typed_data';

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
    await createTresorieTable(db , version);
    await createFormatPieceTable(db ,version);
    await createMyParamTable(db , version);
    await createTriggersJournaux(db , version);
    await createTriggersPiece(db , version);
    await createTriggersTresorie (db,version);
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
        Colis Double, 
        Cmd_client Double Default 0,
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
        QRcode VARCHAR (255),
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
        Etat integer DEFAULT 0,
        Total_ht Double, 
        Net_ht Double,
        Total_tva Double, 
        Total_ttc Double, 
        Timbre Double,
        Net_a_payer Double, 
        Regler Double, 
        Reste Double,
        Marge Double,
        Remise Double
        
        )""");

    await db.execute("""CREATE TABLE IF NOT EXISTS Transformers (
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        Old_Mov integer, 
        Old_Piece_id integer REFERENCES Pieces (id) ON DELETE SET NULL ON UPDATE CASCADE, 
        New_Piece_id integer REFERENCES Pieces (id) ON DELETE SET NULL ON UPDATE CASCADE,
        Type_piece VARCHAR(5)
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
        Net_ht Double,
        Tva Double,
        Prix_revient Double,
        Marge Double
        )""");
  }

  //table tresorie
  Future<void> createTresorieTable (Database db , int version) async {
    //table des categories des tresories
    await db.execute("""CREATE TABLE IF NOT EXISTS TresorieCategories (
       
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        Libelle VARCHAR(20)

        )""");

    await db.execute("""
      CREATE TABLE Tresories (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          Num_tresorie VARCHAR(50),
          Tier_id ,
          Tier_rs VARCHAR (255),
          Piece_id INTEGER,
          Mov INTEGER ,
          Objet VARCHAR (255),
          Montant DOUBLE,
          Modalite VARCHAR (255),
          Categorie_id INTEGER REFERENCES TresorieCategories (id) ON DELETE SET NULL ON UPDATE CASCADE,
          Date integer
      )""");

    await db.execute("""
      CREATE TABLE ReglementTresorie (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          Tresorie_id INTEGER REFERENCES Tresories(id) ON DELETE SET NULL ON UPDATE CASCADE,
          Piece_id INTEGER REFERENCES Pieces (id) ON DELETE SET NULL ON UPDATE CASCADE,
          Regler DOUBLE
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
    await db.execute("""CREATE TABLE IF NOT EXISTS MyParams (
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        Tarification integer DEFAULT 1, 
        Tva integer DEFAULT 0
        )""");

    await db.execute('''CREATE TABLE IF NOT EXISTS FormatPrints (
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        Default_format VARCHAR(4),
        Default_display VARCHAR(25),
        Total_ht integer , 
        Total_tva integer , 
        Reste integer , 
        Credit integer  
        )''');

    await db.execute('''CREATE TABLE IF NOT EXISTS DefaultPrinters (
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        Adress VARCHAR(25),
        Name VARCHAR(25),
        Type integer
        )''');
  }

//**********************************************************************************************************************************************
//  ********************************************************************************************************************************************
//  ********************************************************************************************************************************************

//fonction speciale pour la creation des triggers de bd table article
  createTriggersJournaux(Database db , int version) async {
    //*********************************************************************************************************************************************
    //************************************************* journal commande client********************************************************************
    await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_articles_cmd_onInsert
        AFTER INSERT ON Journaux
        FOR EACH ROW
        WHEN  NEW.Mov = 1 AND (NEW.Piece_type = 'CC' )
        BEGIN
            UPDATE Articles
               SET Cmd_client =Cmd_client + NEW.Qte
             WHERE id = New.Article_id;
             
            Update Pieces
              Set Marge = (Select SUM(Marge) from Journaux where Piece_id = NEW.Piece_id AND New.Mov <> -2)
            where id = New.Piece_id ;
        END;
     ''');

    await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_articles_cmd_onUpdate
        AFTER UPDATE ON Journaux
        FOR EACH ROW
        WHEN NEW.Mov = 1 AND (NEW.Piece_type = 'CC')
        BEGIN
            UPDATE Articles
               SET Cmd_client = Cmd_client + (NEW.Qte - OLD.Qte)
             WHERE id = NEW.Article_id ;
             
            Update Pieces
              Set Marge = (Select SUM(Marge) from Journaux where Piece_id = NEW.Piece_id AND New.Mov <> -2)
            where id = New.Piece_id ;
        END;
     ''');

    await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_articles_cmd_onUpdate_mov1
        AFTER UPDATE ON Journaux
        FOR EACH ROW
        WHEN (OLD.Mov <> NEW.Mov) AND NEW.Mov = 1 AND (NEW.Piece_type = 'CC')
        BEGIN
            UPDATE Articles
               SET Cmd_client = Cmd_client + NEW.Qte
             WHERE id = NEW.Article_id ;
             
            Update Pieces
              Set Marge = (Select SUM(Marge) from Journaux where Piece_id = NEW.Piece_id AND New.Mov <> -2)
            where id = New.Piece_id ;
        END;
     ''');

    await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_articles_cmd_onUpdate_mov
        AFTER UPDATE ON Journaux
        FOR EACH ROW
        WHEN (OLD.Mov <> NEW.Mov)  AND (NEW.Mov = 0 OR NEW.Mov = 2 OR NEW.Mov = -1 OR NEW.Mov = -2)
              AND (NEW.Piece_type = 'CC')      
        BEGIN
            UPDATE Articles
               SET Cmd_client = Cmd_client - OLD.Qte
             WHERE id = New.Article_id;
            
        END;
     ''');

    //  **********************************************************************************************************************************************
    //  ************************************************ journal des bons de client*************************************************************************
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
             
            Update Pieces
              Set Marge = (Select SUM(Marge) from Journaux where Piece_id = NEW.Piece_id AND New.Mov <> -2)
            where id = New.Piece_id ;
        END;
     ''');

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
             
            Update Pieces
              Set Marge = (Select SUM(Marge) from Journaux where Piece_id = NEW.Piece_id AND New.Mov <> -2)
            where id = New.Piece_id ;
        END;
     ''');

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
             
            Update Pieces
              Set Marge = (Select SUM(Marge) from Journaux where Piece_id = NEW.Piece_id AND New.Mov <> -2)
            where id = New.Piece_id ;
        END;
     ''');

    await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_articles_qte_onUpdate_client_mov
        AFTER UPDATE ON Journaux
        FOR EACH ROW
        WHEN (OLD.Mov <> NEW.Mov)  AND (NEW.Mov = 0 OR NEW.Mov = 2 OR NEW.Mov = -1 OR NEW.Mov = -2)
              AND (NEW.Piece_type = 'BL' OR NEW.Piece_type = 'FC')      
        BEGIN
            UPDATE Articles
               SET Qte = Qte + OLD.Qte ,
                   Colis = Qte / Qte_Colis
             WHERE id = New.Article_id;
            
        END;
     ''');

    //  **********************************************************************************************************************************************
    //  ************************************************ journal des bons de fournisseur*************************************************************************

    //update_articles_qte_insert on insert bon fournisseur
    await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_articles_qte_onInsert_fournisseur
        AFTER INSERT ON Journaux
        FOR EACH ROW
        WHEN NEW.Mov = 1 AND (NEW.Piece_type = 'BR' OR NEW.Piece_type = 'FF')
        BEGIN
            UPDATE Articles
               SET PMP = ((Qte * PMP)+(NEW.Qte * NEW.Net_ht))/(Qte + NEW.Qte) , 
                   Qte = Qte + NEW.Qte,
                   Colis = Qte / Qte_Colis,
                   PrixAchat = NEW.Net_ht
             WHERE id = New.Article_id;
             
            Update Pieces
              Set Marge = (Select SUM(Marge) from Journaux where Piece_id = NEW.Piece_id AND New.Mov <> -2)
            where id = New.Piece_id ;
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
               SET PMP = ((Qte * PMP)+((NEW.Qte-OLD.Qte) * NEW.Net_ht))/(Qte + (NEW.Qte-OLD.Qte)) , 
                   Qte = Qte + (NEW.Qte-OLD.Qte),
                   Colis = Qte / Qte_Colis
             WHERE id = New.Article_id;
             
            Update Pieces
              Set Marge = (Select SUM(Marge) from Journaux where Piece_id = NEW.Piece_id AND New.Mov <> -2)
            where id = New.Piece_id ;
        END;
     ''');


    await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_articles_qte_onUpdate_fournisseur_mov1
        AFTER UPDATE ON Journaux
        FOR EACH ROW
        WHEN (OLD.Mov <> NEW.Mov) AND NEW.Mov = 1 AND (NEW.Piece_type = 'BR' OR NEW.Piece_type = 'FF')
        BEGIN
           UPDATE Articles
               SET PMP = ((Qte * PMP)+(NEW.Qte * NEW.Net_ht))/(Qte + NEW.Qte) , 
                   Qte = Qte + NEW.Qte,
                   Colis = Qte / Qte_Colis,
                   PrixAchat = NEW.Net_ht
             WHERE id = New.Article_id;
             
            Update Pieces
              Set Marge = (Select SUM(Marge) from Journaux where Piece_id = NEW.Piece_id AND New.Mov <> -2)
            where id = New.Piece_id ;
        END;
     ''');

    // à reviser
    await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_articles_qte_onUpdate_fournisseur_mov
        AFTER UPDATE ON Journaux
        FOR EACH ROW
        WHEN  (OLD.Mov <> NEW.Mov) AND (NEW.Mov = 0 OR NEW.Mov = 2 OR NEW.Mov = -1 OR NEW.Mov = -2)
              AND (NEW.Piece_type = 'BR' OR NEW.Piece_type = 'FF') 
        BEGIN
            UPDATE Articles
               SET PMP = ((Qte * PMP)-(OLD.Qte * OLD.Net_ht))/(Qte - OLD.Qte) , 
                   Qte = Qte - OLD.Qte,
                   Colis = Qte / Qte_Colis
             WHERE id = New.Article_id;
            
        END;
     ''');

  //  **********************************************************************************************************************************************
  //  ************************************************ journal des retours client*************************************************************************

    await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_articles_qte_from_retour
        AFTER INSERT ON Journaux
        FOR EACH ROW
        WHEN NEW.Mov = 1 AND (NEW.Piece_type = 'RC' OR NEW.Piece_type = 'AC')
        BEGIN
            UPDATE Articles
               SET PMP = ((Qte * PMP)+(NEW.Qte * NEW.Prix_revient))/(Qte + NEW.Qte) , 
                   Qte = Qte + NEW.Qte,
                   Colis = Qte / Qte_Colis
             WHERE id = New.Article_id;
             
        END;
     ''');


    //update_articles_qte_update on update bon fournisseur
    await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_articles_qte_onUpdate_retour
        AFTER UPDATE ON Journaux
        FOR EACH ROW
        WHEN NEW.Mov = 1 AND (NEW.Piece_type = 'RC' OR NEW.Piece_type = 'AC')
        BEGIN
            UPDATE Articles
               SET PMP = ((Qte * PMP)+((NEW.Qte-OLD.Qte) * NEW.Prix_revient))/(Qte + (NEW.Qte-OLD.Qte)) , 
                   Qte = Qte + (NEW.Qte-OLD.Qte),
                   Colis = Qte / Qte_Colis
             WHERE id = New.Article_id;
            
        END;
     ''');


    await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_articles_qte_onUpdate_retour_mov1
        AFTER UPDATE ON Journaux
        FOR EACH ROW
        WHEN (OLD.Mov <> NEW.Mov) AND NEW.Mov = 1 AND (NEW.Piece_type = 'RC' OR NEW.Piece_type = 'AC')
        BEGIN
           UPDATE Articles
               SET PMP = ((Qte * PMP)+(NEW.Qte * NEW.Prix_revient))/(Qte + NEW.Qte) , 
                   Qte = Qte + NEW.Qte,
                   Colis = Qte / Qte_Colis
             WHERE id = New.Article_id;

        END;
     ''');

    // à reviser
    await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_articles_qte_onUpdate_retour_mov
        AFTER UPDATE ON Journaux
        FOR EACH ROW
        WHEN  (OLD.Mov <> NEW.Mov) AND (NEW.Mov = 0 OR NEW.Mov = 2 OR NEW.Mov = -1 OR NEW.Mov = -2)
              AND (NEW.Piece_type = 'RC' OR NEW.Piece_type = 'AC') 
        BEGIN
            UPDATE Articles
               SET PMP = ((Qte * PMP)-(OLD.Qte * OLD.Prix_revient))/(Qte - OLD.Qte) , 
                   Qte = Qte - OLD.Qte,
                   Colis = Qte / Qte_Colis
             WHERE id = New.Article_id;
        
        END;
     ''');

    //  **********************************************************************************************************************************************
    //  ************************************************ journal des retours fournisseur*************************************************************************

    await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_articles_qte_onInsert_retour_four
        AFTER INSERT ON Journaux
        FOR EACH ROW
        WHEN  NEW.Mov = 1 AND (NEW.Piece_type = 'RF' OR NEW.Piece_type = 'AF')
        BEGIN
            UPDATE Articles
               SET PMP = ((Qte * PMP)-(NEW.Qte * NEW.Prix_revient))/(Qte - NEW.Qte) ,
                   Qte = Qte - NEW.Qte,
                   Colis = Qte / Qte_Colis
             WHERE id = New.Article_id;
             
        END;
     ''');


    await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_articles_qte_onUpdate_retour_four
        AFTER UPDATE ON Journaux
        FOR EACH ROW
        WHEN NEW.Mov = 1 AND (NEW.Piece_type = 'RF' OR NEW.Piece_type = 'AF')
        BEGIN
            UPDATE Articles
               SET PMP = ((Qte * PMP)-((NEW.Qte - OLD.Qte) * NEW.Prix_revient))/(Qte - (NEW.Qte - OLD.Qte)) ,
                   Qte = Qte - (NEW.Qte - OLD.Qte) ,
                   Colis = Qte / Qte_Colis
             WHERE id = NEW.Article_id ;
             
        END;
     ''');

    await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_articles_qte_onUpdate_retour_four_mov1
        AFTER UPDATE ON Journaux
        FOR EACH ROW
        WHEN (OLD.Mov <> NEW.Mov) AND NEW.Mov = 1 AND (NEW.Piece_type = 'RF' OR NEW.Piece_type = 'AF')
        BEGIN
            UPDATE Articles
               SET PMP = ((Qte * PMP)-(NEW.Qte * NEW.Prix_revient))/(Qte - NEW.Qte) ,
                   Qte = Qte - NEW.Qte ,
                   Colis = Qte / Qte_Colis
             WHERE id = NEW.Article_id ;
             
        END;
     ''');

    await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_articles_qte_onUpdate_retour_four_mov
        AFTER UPDATE ON Journaux
        FOR EACH ROW
        WHEN (OLD.Mov <> NEW.Mov)  AND (NEW.Mov = 0 OR NEW.Mov = 2 OR NEW.Mov = -1 OR NEW.Mov = -2)
              AND (NEW.Piece_type = 'RF' OR NEW.Piece_type = 'AF')      
        BEGIN
            UPDATE Articles
               SET PMP = ((Qte * PMP)+(OLD.Qte * OLD.Prix_revient))/(Qte + OLD.Qte) ,
                   Qte = Qte + OLD.Qte ,
                   Colis = Qte / Qte_Colis,
                   PrixAchat = OLD.Prix_ht
             WHERE id = New.Article_id;
            
        END;
     ''');

  }


  //fonction speciale pour la creation des triggers de bd table piece et format
  // NB : pour l'etat de la tresorie on doit l'ajouter le mov à la condition de calcul (regler) de tier
  createTriggersPiece(Database db, int version) async {
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

     //*******************************************************************************************************************************
     //***************************************************add piece*******************************************************************
     await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_tiers_chiffre_affaires1
        AFTER INSERT ON Pieces
        FOR EACH ROW
        WHEN NEW.Mov = 1 AND NEW.Piece <> "CC" 
        BEGIN
             UPDATE Tiers
               SET Chiffre_affaires = Chiffre_affaires + NEW.Net_a_payer
             WHERE id = New.Tier_id; 
             
             UPDATE Tiers
                SET Regler = (SELECT SUM(Montant) FROM Tresories WHERE Tier_id = New.Tier_id AND Mov = 1)
             WHERE id = NEW.Tier_id ;
             
             UPDATE Tiers
               SET  Credit = (Solde_depart + Chiffre_affaires) - Regler 
             WHERE id = New.Tier_id;
        END;
     ''');

     //*****************************************************************************************************************************
     //***************************************************edit piece****************************************************************
     await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_tiers_chiffre_affaires2
        AFTER UPDATE ON Pieces
        FOR EACH ROW
        WHEN NEW.Mov = 1 AND NEW.Piece <> "CC"
        BEGIN
             UPDATE Tiers
               SET Chiffre_affaires = Chiffre_affaires + (NEW.Net_a_payer-OLD.Net_a_payer)
             WHERE id = OLD.Tier_id;
           
             UPDATE Tiers
                SET Regler = (SELECT SUM(Montant) FROM Tresories WHERE Tier_id = New.Tier_id AND Mov = 1)
             WHERE id = NEW.Tier_id ;
             
             UPDATE Tiers
               SET  Credit = (Solde_depart + Chiffre_affaires) - Regler 
             WHERE id = New.Tier_id;
        END;
     ''');

     await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_tiers_chiffre_affaires3
        AFTER UPDATE ON Pieces
        FOR EACH ROW
        WHEN (OLD.Mov <> NEW.Mov)  AND (NEW.Mov = 0 OR NEW.Mov = 2 OR NEW.Mov = -1 OR NEW.Mov = -2) 
            AND NEW.Piece <> "CC"
        BEGIN
             UPDATE Tiers
               SET Chiffre_affaires = Chiffre_affaires - OLD.Net_a_payer
             WHERE id = OLD.Tier_id;
           
             UPDATE Tiers
                SET Regler = (SELECT SUM(Montant) FROM Tresories WHERE Tier_id = New.Tier_id AND Mov = 1)
             WHERE id = NEW.Tier_id ;
             
             UPDATE Tiers
               SET  Credit = (Solde_depart + Chiffre_affaires) - Regler 
             WHERE id = New.Tier_id;
        END;
     ''');

     await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_tiers_chiffre_affaires4
        AFTER UPDATE ON Pieces
        FOR EACH ROW
        WHEN (OLD.Mov <> NEW.Mov)  AND (NEW.Mov = 1) AND NEW.Piece <> "CC"
        BEGIN
             UPDATE Tiers
               SET Chiffre_affaires = Chiffre_affaires + NEW.Net_a_payer
             WHERE id = OLD.Tier_id;
           
             UPDATE Tiers
                SET Regler = (SELECT SUM(Montant) FROM Tresories WHERE Tier_id = New.Tier_id AND Mov = 1)
             WHERE id = NEW.Tier_id ;
             
             UPDATE Tiers
               SET  Credit = (Solde_depart + Chiffre_affaires) - Regler 
             WHERE id = New.Tier_id;
        END;
     ''');

     //*******************************************************************************************************************************
     //***************************************************dell piece***********************************************************

     await db.execute('''
        CREATE TRIGGER IF NOT EXISTS delete_journaux
        BEFORE DELETE ON Pieces
        FOR EACH ROW
        BEGIN
           Update Journaux 
              Set Mov = -2
           WHERE Piece_id = Old.id;
        END;
     ''');

     await db.execute('''
        CREATE TRIGGER IF NOT EXISTS delete_tresorie
        BEFORE DELETE ON Pieces
        FOR EACH ROW
        WHEN (OLD.Mov = 1 AND OLD.Piece <> "CC")
        BEGIN
            UPDATE Tiers
               SET Chiffre_affaires = Chiffre_affaires - OLD.Net_a_payer
            WHERE id = OLD.Tier_id;
            
            UPDATE Tiers
               SET Regler = (SELECT SUM(Montant) FROM Tresories WHERE Tier_id = OLD.Tier_id AND Mov = 1)
            WHERE id = OLD.Tier_id ;
             
            UPDATE Tiers
              SET  Credit = (Solde_depart + Chiffre_affaires) - Regler 
            WHERE id = OLD.Tier_id;
            
        END;
     ''');

     await db.execute('''
        CREATE TRIGGER IF NOT EXISTS delete_piece_transformer
        BEFORE DELETE ON Pieces
        FOR EACH ROW
        WHEN (OLD.Mov = 1 AND OLD.Transformer = 1)
        BEGIN    
                    
           DELETE FROM Transformers WHERE New_Piece_id = OLD.id;
        END;
     ''');


  }


  // NB : pour l'etat de la tresorie on doit l'ajouter le mov à la condition de calcul (regler) de tier
  createTriggersTresorie(Database db, int version) async {
    await db.execute('''CREATE TRIGGER update_current_index_tr 
        AFTER INSERT ON Tresories 
        FOR EACH ROW 
        BEGIN 
            UPDATE FormatPiece
               SET Current_index = Current_index+1
            WHERE  FormatPiece.Piece LIKE "TR" ; 
        END;
      ''');
    // ***************************************************************************************************************
    //**********************************************add tresorie*******************************************************

    await db.execute('''CREATE TRIGGER update_tier_reglement_credit 
        AFTER INSERT ON Tresories 
        FOR EACH ROW 
        when (New.Categorie_id = 2 OR New.Categorie_id = 3 OR New.Categorie_id = 6 OR New.Categorie_id = 7)
        BEGIN             
            UPDATE Tiers
              SET Regler = (SELECT SUM(Montant) FROM Tresories WHERE Tier_id = New.Tier_id AND Mov = 1)
            WHERE id = NEW.Tier_id ;
             
             UPDATE Tiers
               SET  Credit = (Solde_depart + Chiffre_affaires) - Regler 
             WHERE id = New.Tier_id;
           
        END;
      ''');

    await db.execute('''CREATE TRIGGER update_piece_verssement
        AFTER INSERT ON ReglementTresorie
        FOR EACH ROW
        BEGIN
            UPDATE Pieces
              SET Regler = (SELECT SUM(Regler) FROM ReglementTresorie WHERE Piece_id = New.Piece_id)
            WHERE id =  New.Piece_id ;

             UPDATE Pieces
               SET  Reste = Net_a_payer - Regler 
             WHERE id = New.Piece_id;

        END;
      ''');

    // ***************************************************************************************************************
    //**********************************************update tresorie*******************************************************
    await db.execute('''CREATE TRIGGER update_tier_reglement_credit3
        AFTER UPDATE ON Tresories 
        FOR EACH ROW 
        when (New.Categorie_id = 2 OR New.Categorie_id = 3 OR New.Categorie_id = 6 OR New.Categorie_id = 7)
             AND (OLD.Mov <> New.Mov) AND NEW.Mov = 1
        BEGIN             
            UPDATE Tiers
              SET Regler = (SELECT SUM(Montant) FROM Tresories WHERE Tier_id = New.Tier_id AND Mov = 1)
            WHERE id = NEW.Tier_id ;
             
             UPDATE Tiers
               SET  Credit = (Solde_depart + Chiffre_affaires) - Regler 
             WHERE id = New.Tier_id;  
        END;
      ''');

    // le delete est spaecial pour add tresorie page on update tresorie montant
    await db.execute('''CREATE TRIGGER update_tier_reglement_credit2
        AFTER UPDATE ON Tresories 
        FOR EACH ROW 
        when (New.Categorie_id = 2 OR New.Categorie_id = 3 OR New.Categorie_id = 6 OR New.Categorie_id = 7) 
              AND OLD.Mov = NEW.Mov  AND OLD.Piece_id = NEW.Piece_id
        BEGIN         
            UPDATE Tiers
              SET Regler = (SELECT SUM(Montant) FROM Tresories WHERE Tier_id = New.Tier_id AND Mov = 1)
            WHERE id = NEW.Tier_id ;
              
             UPDATE Tiers
               SET  Credit = (Solde_depart + Chiffre_affaires) - Regler 
             WHERE id = New.Tier_id;   
             
            DELETE FROM ReglementTresorie WHERE Tresorie_id = Old.id ;
        END;
      ''');


    // ***************************************************************************************************************
    //**********************************************dell tresorie*******************************************************

    await db.execute('''CREATE TRIGGER dell_tresorie 
        BEFORE DELETE ON Tresories 
        FOR EACH ROW 
        BEGIN 
           UPDATE Tiers
             SET Regler = (SELECT (SUM(Montant)-OLD.Montant) FROM Tresories WHERE Tier_id = OLD.Tier_id AND Mov = 1)
           WHERE id = OLD.Tier_id ;
             
           UPDATE Tiers
             SET  Credit = (Solde_depart + Chiffre_affaires) - Regler 
           WHERE id = OLD.Tier_id;
           
           DELETE FROM ReglementTresorie WHERE Tresorie_id = OLD.id ;
        END;
      ''');

    await db.execute('''CREATE TRIGGER dell_regelement_tresorie 
        BEFORE DELETE ON ReglementTresorie 
        FOR EACH ROW 
        BEGIN 
            UPDATE Pieces
              SET Regler = (SELECT SUM(Regler-OLD.Regler) FROM ReglementTresorie WHERE Piece_id = OLD.Piece_id )
            WHERE id =  OLD.Piece_id ;

             UPDATE Pieces
               SET  Reste = Net_a_payer - Regler 
             WHERE id = OLD.Piece_id;
        END;
      ''');

    //***********************************************************************************************************************************
    //*********************************special transformation*****************************************************************************
    await db.execute('''CREATE TRIGGER update_reglemntTresorie_tresorie 
        AFTER INSERT ON Transformers 
        FOR EACH ROW 
        WHEN (NEW.Type_piece <> 'AC' AND NEW.Type_piece <> 'RC' AND NEW.Type_piece <> 'AF' AND NEW.Type_piece <> 'RF' AND NEW.Old_Mov = 1)
        BEGIN 
           UPDATE Tresories 
              SET Piece_id = NEW.New_Piece_id 
           WHERE Piece_id = NEW.Old_Piece_id ;
           
           UPDATE ReglementTresorie 
              SET Piece_id = NEW.New_Piece_id 
           WHERE Piece_id = NEW.Old_Piece_id ;
        END;
      ''');

    await db.execute('''CREATE TRIGGER update_piece_dell_transformation
        BEFORE DELETE ON Transformers 
        FOR EACH ROW 
        BEGIN 
           UPDATE Pieces 
           SET Mov = OLD.Old_Mov,
               Etat = 0
           WHERE id = OLD.Old_Piece_id ;
           
           UPDATE Journaux
              SET Mov = OLD.Old_Mov 
           WHERE Piece_id = OLD.Old_Piece_id ;
           
        END;
      ''');

    await db.execute('''CREATE TRIGGER update_reglemntTresorie_tresorie1 
        BEFORE DELETE ON Transformers 
        FOR EACH ROW 
        WHEN (OLD.Type_piece <> 'AC' AND OLD.Type_piece <> 'RC' AND OLD.Type_piece <> 'AF' AND OLD.Type_piece <> 'RF')
        BEGIN 
           UPDATE Tresories 
              SET Piece_id = OLD.Old_Piece_id 
           WHERE Piece_id = OLD.New_Piece_id ;
           
           UPDATE ReglementTresorie 
              SET Piece_id = OLD.Old_Piece_id 
           WHERE Piece_id = OLD.New_Piece_id ;
                   
        END;
      ''');


  }

  //*****************************************************************************************************************************************
  //*****************************************************************************************************************************************
  //*****************************************************************************************************************************************
  Future<void> setInitialData(Database db, int version) async {
    Batch batch = db.batch();

    batch.rawInsert('INSERT INTO Profile(BytesImageString, Raison, CodePin, CodePinEnabled, Statut, Adresse, AdresseWeb, Ville, Departement, Pays, Cp, Telephone, Telephone2, Fax, Mobile, Mobile2,'
        'Mail, Site, Rc, Nif, Ai, Capital, Activite, Nis, Codedouane, Maposition) '
        'VALUES("", "Raison", "", 0, 1, "Adresse", "AdresseWeb", "Ville", "Departement", "Pays", "Cp", "Telephone", "Telephone2", "Fax", "Mobile", "Mobile2",'
        '"Mail", "Site", "Rc", "Nif", "Ai", "25", "Activite", "Nis", "Codedouane", "Maposition")');

    batch.rawInsert('INSERT INTO ArticlesMarques(Libelle, BytesImageString) VALUES("Marque", "")');
    batch.rawInsert('INSERT INTO ArticlesMarques(Libelle, BytesImageString) VALUES("Marque 1", "")');

    batch.rawInsert('INSERT INTO ArticlesFamilles(Libelle, BytesImageString) VALUES("Famille", "")');
    batch.rawInsert('INSERT INTO ArticlesFamilles(Libelle, BytesImageString) VALUES("Famille 1", "")');

    batch.rawInsert('INSERT INTO TiersFamilles(Libelle) VALUES("Famille")');
    batch.rawInsert('INSERT INTO TiersFamilles(Libelle) VALUES("Famille 1")');

    batch.rawInsert('INSERT INTO ArticlesTva(Tva) VALUES(0)');
    batch.rawInsert('INSERT INTO ArticlesTva(Tva) VALUES(10)');
    batch.rawInsert('INSERT INTO ArticlesTva(Tva) VALUES(19)');
    batch.rawInsert('INSERT INTO ArticlesTva(Tva) VALUES(29)');

    batch.rawInsert('INSERT INTO TresorieCategories(Libelle) VALUES("Decaissement")');
    batch.rawInsert('INSERT INTO TresorieCategories(Libelle) VALUES("Reglement Client")');
    batch.rawInsert('INSERT INTO TresorieCategories(Libelle) VALUES("Reglement Fournisseur")');
    batch.rawInsert('INSERT INTO TresorieCategories(Libelle) VALUES("Encaissement")');
    batch.rawInsert('INSERT INTO TresorieCategories(Libelle) VALUES("Charge")');
    batch.rawInsert('INSERT INTO TresorieCategories(Libelle) VALUES("Remboursement Client")');
    batch.rawInsert('INSERT INTO TresorieCategories(Libelle) VALUES("Remboursement Fournisseur")');

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
    batch.rawInsert('INSERT INTO FormatPiece(Format , Piece , Current_index) VALUES("XXXX/YYYY"  , "TR" , 0)');

    batch.rawInsert("INSERT INTO MyParams(Tarification , Tva) VALUES(2,0)");

    Uint8List image = await Helpers.getDefaultImageUint8List();
    Tiers tier0 = new Tiers(image ,"Client Passagé", null, 0, 0, 0, "adresse", "ville", "telephone", "000000", "fax", "email", 0, 0, 0, false);
    tier0.clientFour = 0 ;
    batch.insert(DbTablesNames.tiers, tier0.toMap());

    Tiers tier2 = new Tiers(image,"Fournisseur Passagé", null, 0, 0, 0, "adresse", "ville", "telephone", "000000", "fax", "email", 0, 0, 0, false);
    tier2.clientFour = 2 ;
    batch.insert(DbTablesNames.tiers, tier2.toMap());

    await batch.commit();


  }






}
