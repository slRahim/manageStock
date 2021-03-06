import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/Tiers.dart';
import 'package:gestmob/services/cloud_backup_restore.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'Helpers.dart';

class SqlLiteDatabaseHelper {
  static final SqlLiteDatabaseHelper _instance = new SqlLiteDatabaseHelper.internal();
  factory SqlLiteDatabaseHelper() => _instance;
  SqlLiteDatabaseHelper.internal();

  static const SECRET_KEY = "2020_PRIVATES_KEYS_ENCRYPTS_2020";
  static const DATABASE_VERSION = 4;
  static Database _db;
  GoogleApi _googleApi = new GoogleApi();

  List<String> db_tables = [
    DbTablesNames.profile,
    DbTablesNames.articles,
    DbTablesNames.pieces,
    DbTablesNames.tiers,
    DbTablesNames.articlesFamilles,
    DbTablesNames.tiersFamille,
    DbTablesNames.articlesMarques,
    DbTablesNames.tresorie,
    DbTablesNames.categorieTresorie,
    DbTablesNames.reglementTresorie,
    DbTablesNames.formatPiece,
    DbTablesNames.journaux,
    DbTablesNames.transformer,
    DbTablesNames.defaultPrinter,
    DbTablesNames.articlesTva,
    DbTablesNames.myparams,
    DbTablesNames.compteTresorie,
    DbTablesNames.chargeTresorie,
  ];

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    String dbPath = await _databasePath();
    Database database = await openDatabase(dbPath,
        version: DATABASE_VERSION, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return database;
  }

  Future<String> _databasePath() async {
    String databasesPath = await getDatabasesPath();
    return join(databasesPath, 'gestmob.db');
  }

  void _onCreate(Database db, int version) async {

    await createProfileTable(db, version);
    await createArticlesTable(db, version);
    await createTiersTable(db, version);
    await createPiecesTable(db, version);
    await createJournauxTable(db, version);
    await createTresorieTable(db, version);
    await createFormatPieceTable(db, version);
    await createMyParamTable(db, version);

    await createTriggersGeneral(db, version);
    await createTriggersForForeignKey(db , version);
    await createTriggersJournaux(db, version);
    await createTriggersPiece(db, version);
    await createTriggersTresorie(db, version);

    await setInitialData(db, version);
  }

  FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    for (var migration = oldVersion; migration < newVersion; migration++) {
      this._onUpgrades["from_version_${migration}_to_version_${migration + 1}"](
          db);
    }
  }

  Map<String, Function> _onUpgrades = {
    'from_version_1_to_version_2': (Database db) async {
      await db.execute("""
          ALTER TABLE MyParams ADD COLUMN AutoVerssement INTEGER NOT NULL DEFAULT 1 ;
      """);
    },

    'from_version_2_to_version_3': (Database db) async {
      await db.execute("""
          DROP TRIGGER IF EXISTS update_articles_qte_onUpdate_fournisseur ;
      """);

      await db.execute("""
          DROP TRIGGER IF EXISTS update_articles_qte_onUpdate_retour ;
      """);

      await db.execute("""
          DROP TRIGGER IF EXISTS update_articles_qte_onUpdate_retour_four ;
      """);

      await db.execute("""
          DROP TRIGGER IF EXISTS update_piece_transformer ;
      """);

      await db.execute('''
        CREATE TRIGGER update_articles_qte_onUpdate_fournisseur
        AFTER UPDATE ON Journaux
        FOR EACH ROW
        WHEN NEW.Mov = 1 AND (NEW.Piece_type = 'BR' OR NEW.Piece_type = 'FF')
        BEGIN
            UPDATE Articles
             SET PMP = IFNULL(((Qte * PMP) - (OLD.Qte * OLD.Net_ht)) / (Qte -OLD.Qte) , 0), 
                 Qte = Qte - OLD.Qte
            WHERE id = New.Article_id;
        
            UPDATE Articles
               SET PMP = IFNULL(((Qte * PMP)+(NEW.Qte * NEW.Net_ht))/(Qte + NEW.Qte) , 0) , 
                   Qte = Qte + NEW.Qte,
                   Colis = IFNULL((Qte + NEW.Qte) / Qte_Colis , 0),
                   PrixAchat = NEW.Net_ht
             WHERE id = New.Article_id;
             
            Update Pieces
              Set Marge = IFNULL((Select SUM(Marge) from Journaux where Piece_id = NEW.Piece_id AND New.Mov <> -2),0)
            where id = New.Piece_id ;
        END;
        
     ''');

      await db.execute('''
        CREATE TRIGGER update_articles_qte_onUpdate_retour
        AFTER UPDATE ON Journaux
        FOR EACH ROW
        WHEN NEW.Mov = 1 AND (NEW.Piece_type = 'RC' OR NEW.Piece_type = 'AC')
        BEGIN
             UPDATE Articles
               SET PMP = IFNULL(((Qte * PMP)-((OLD.Qte*-1) * OLD.Prix_revient)) / (Qte - (OLD.Qte*-1)) , 0) , 
                   Qte = Qte - (OLD.Qte*-1)
             WHERE id = New.Article_id;
             
            UPDATE Articles
               SET PMP = IFNULL(((Qte * PMP)+((NEW.Qte*-1) * NEW.Prix_revient)) / (Qte + (NEW.Qte*-1)) , 0) , 
                   Qte = Qte + (NEW.Qte*-1),
                   Colis = IFNULL((Qte + (NEW.Qte*-1)) / Qte_Colis , 0)
             WHERE id = New.Article_id;
            
            Update Pieces
              Set Marge = IFNULL((Select SUM(Marge) from Journaux where Piece_id = NEW.Piece_id AND New.Mov <> -2),0) * -1 
            where id = New.Piece_id ;
        END;
     ''');

      await db.execute('''
        CREATE TRIGGER update_articles_qte_onUpdate_retour_four
        AFTER UPDATE ON Journaux
        FOR EACH ROW
        WHEN NEW.Mov = 1 AND (NEW.Piece_type = 'RF' OR NEW.Piece_type = 'AF')
        BEGIN
             UPDATE Articles
               SET PMP = IFNULL(((Qte * PMP)+((OLD.Qte*-1) * OLD.Net_ht))/(Qte + (OLD.Qte*-1)),0) ,
                   Qte = Qte + (OLD.Qte*-1)
             WHERE id = NEW.Article_id ;
             
            UPDATE Articles
               SET PMP = IFNULL(((Qte * PMP) - ((NEW.Qte*-1) * NEW.Net_ht))/(Qte - (NEW.Qte*-1)),0) ,
                   Qte = Qte - (NEW.Qte*-1),
                   Colis = IFNULL((Qte - (NEW.Qte*-1)) / Qte_Colis , 0)
             WHERE id = NEW.Article_id ;
             
        END;
     ''');

      await db.execute('''
        CREATE TRIGGER update_piece_transformer
        AFTER UPDATE ON Pieces
        FOR EACH ROW
        When  (Old.Etat <> New.Etat) AND New.Etat = 1
        BEGIN
            UPDATE Pieces
              SET Regler = IFNULL((SELECT SUM(Regler) FROM ReglementTresorie WHERE Piece_id = OLD.id ),0)
            WHERE id =  OLD.id ;

             UPDATE Pieces
               SET  Reste = Net_a_payer - Regler 
             WHERE id = OLD.id;
        END;
     ''');

      await db.execute('''CREATE TRIGGER update_tier_reglement_credit_4
        AFTER UPDATE ON Tresories
        FOR EACH ROW
        BEGIN
             UPDATE Tiers
               SET Chiffre_affaires = IFNULL((Select Sum(Net_a_payer) From Pieces where Tier_id = OLD.Tier_id AND Mov = 1 AND Piece <> "CC" AND Piece <> "FP" AND Piece <> "BC"),0)
             WHERE id = OLD.Tier_id;
            UPDATE Tiers
              SET Regler = IFNULL((SELECT SUM(Montant) FROM Tresories WHERE Tier_id = OLD.Tier_id AND Mov = 1),0)
            WHERE id = OLD.Tier_id ;
             UPDATE Tiers
               SET  Credit = (Solde_depart + Chiffre_affaires) - Regler
             WHERE id = OLD.Tier_id;

            UPDATE Tiers
               SET Chiffre_affaires = IFNULL((Select Sum(Net_a_payer) From Pieces where Tier_id = New.Tier_id AND Mov = 1 AND Piece <> "CC" AND Piece <> "FP" AND Piece <> "BC"),0)
             WHERE id = New.Tier_id;
            UPDATE Tiers
              SET Regler = IFNULL((SELECT SUM(Montant) FROM Tresories WHERE Tier_id = New.Tier_id AND Mov = 1),0)
            WHERE id = NEW.Tier_id ;
             UPDATE Tiers
               SET  Credit = (Solde_depart + Chiffre_affaires) - Regler
             WHERE id = New.Tier_id;

        END;
      ''');
    },

    'from_version_3_to_version_4': (Database db) async {
      await db.execute("""
          DROP TRIGGER IF EXISTS update_articles_qte_onUpdate_fournisseur ;
      """);

      await db.execute("""
          DROP TRIGGER IF EXISTS update_articles_qte_onUpdate_retour ;
      """);

      await db.execute("""
          DROP TRIGGER IF EXISTS update_articles_qte_onUpdate_retour_four ;
      """);

      await db.execute("""
          DROP TRIGGER IF EXISTS update_piece_transformer ;
      """);

      await db.execute("""
          DROP TRIGGER IF EXISTS update_tier_reglement_credit_4 ;
      """);

      await db.execute('''
        CREATE TRIGGER update_articles_qte_onUpdate_fournisseur
        AFTER UPDATE ON Journaux
        FOR EACH ROW
        WHEN NEW.Mov = 1 AND (NEW.Piece_type = 'BR' OR NEW.Piece_type = 'FF')
        BEGIN
            UPDATE Articles
             SET PMP = IFNULL(((Qte * PMP) - (OLD.Qte * OLD.Net_ht)) / (Qte -OLD.Qte) , 0), 
                 Qte = Qte - OLD.Qte
            WHERE id = New.Article_id;
        
            UPDATE Articles
               SET PMP = IFNULL(((Qte * PMP)+(NEW.Qte * NEW.Net_ht))/(Qte + NEW.Qte) , 0) , 
                   Qte = Qte + NEW.Qte,
                   Colis = IFNULL((Qte + NEW.Qte) / Qte_Colis , 0),
                   PrixAchat = NEW.Net_ht
             WHERE id = New.Article_id;
             
            Update Pieces
              Set Marge = IFNULL((Select SUM(Marge) from Journaux where Piece_id = NEW.Piece_id AND New.Mov <> -2),0)
            where id = New.Piece_id ;
        END;
        
     ''');

      await db.execute('''
        CREATE TRIGGER update_articles_qte_onUpdate_retour
        AFTER UPDATE ON Journaux
        FOR EACH ROW
        WHEN NEW.Mov = 1 AND (NEW.Piece_type = 'RC' OR NEW.Piece_type = 'AC')
        BEGIN
             UPDATE Articles
               SET PMP = IFNULL(((Qte * PMP)-((OLD.Qte*-1) * OLD.Prix_revient)) / (Qte - (OLD.Qte*-1)) , 0) , 
                   Qte = Qte - (OLD.Qte*-1)
             WHERE id = New.Article_id;
             
            UPDATE Articles
               SET PMP = IFNULL(((Qte * PMP)+((NEW.Qte*-1) * NEW.Prix_revient)) / (Qte + (NEW.Qte*-1)) , 0) , 
                   Qte = Qte + (NEW.Qte*-1),
                   Colis = IFNULL((Qte + (NEW.Qte*-1)) / Qte_Colis , 0)
             WHERE id = New.Article_id;
            
            Update Pieces
              Set Marge = IFNULL((Select SUM(Marge) from Journaux where Piece_id = NEW.Piece_id AND New.Mov <> -2),0) * -1 
            where id = New.Piece_id ;
        END;
     ''');

      await db.execute('''
        CREATE TRIGGER update_articles_qte_onUpdate_retour_four
        AFTER UPDATE ON Journaux
        FOR EACH ROW
        WHEN NEW.Mov = 1 AND (NEW.Piece_type = 'RF' OR NEW.Piece_type = 'AF')
        BEGIN
             UPDATE Articles
               SET PMP = IFNULL(((Qte * PMP)+((OLD.Qte*-1) * OLD.Net_ht))/(Qte + (OLD.Qte*-1)),0) ,
                   Qte = Qte + (OLD.Qte*-1)
             WHERE id = NEW.Article_id ;
             
            UPDATE Articles
               SET PMP = IFNULL(((Qte * PMP) - ((NEW.Qte*-1) * NEW.Net_ht))/(Qte - (NEW.Qte*-1)),0) ,
                   Qte = Qte - (NEW.Qte*-1),
                   Colis = IFNULL((Qte - (NEW.Qte*-1)) / Qte_Colis , 0)
             WHERE id = NEW.Article_id ;
             
        END;
     ''');

      await db.execute('''
        CREATE TRIGGER update_piece_transformer
        AFTER UPDATE ON Pieces
        FOR EACH ROW
        When  (Old.Etat <> New.Etat) AND New.Etat = 1
        BEGIN
            UPDATE Pieces
              SET Regler = IFNULL((SELECT SUM(Regler) FROM ReglementTresorie WHERE Piece_id = OLD.id ),0)
            WHERE id =  OLD.id ;

             UPDATE Pieces
               SET  Reste = Net_a_payer - Regler 
             WHERE id = OLD.id;
        END;
     ''');

      await db.execute('''CREATE TRIGGER update_tier_reglement_credit_4
        AFTER UPDATE ON Tresories
        FOR EACH ROW
        BEGIN
             UPDATE Tiers
               SET Chiffre_affaires = IFNULL((Select Sum(Net_a_payer) From Pieces where Tier_id = OLD.Tier_id AND Mov = 1 AND Piece <> "CC" AND Piece <> "FP" AND Piece <> "BC"),0)
             WHERE id = OLD.Tier_id;
            UPDATE Tiers
              SET Regler = IFNULL((SELECT SUM(Montant) FROM Tresories WHERE Tier_id = OLD.Tier_id AND Mov = 1),0)
            WHERE id = OLD.Tier_id ;
             UPDATE Tiers
               SET  Credit = (Solde_depart + Chiffre_affaires) - Regler
             WHERE id = OLD.Tier_id;

            UPDATE Tiers
               SET Chiffre_affaires = IFNULL((Select Sum(Net_a_payer) From Pieces where Tier_id = New.Tier_id AND Mov = 1 AND Piece <> "CC" AND Piece <> "FP" AND Piece <> "BC"),0)
             WHERE id = New.Tier_id;
            UPDATE Tiers
              SET Regler = IFNULL((SELECT SUM(Montant) FROM Tresories WHERE Tier_id = New.Tier_id AND Mov = 1),0)
            WHERE id = NEW.Tier_id ;
             UPDATE Tiers
               SET  Credit = (Solde_depart + Chiffre_affaires) - Regler
             WHERE id = New.Tier_id;

        END;
      ''');
    },
  };

  Future deleteDB() async {
    String path = await _databasePath();
    await deleteDatabase(path);
  }

  Future clearAllTables(batch) async {
    try {
      for (String table in db_tables) {
        await batch.delete(table);
      }
    } catch (e) {}
  }

  Future generateBackup({bool isEncrypted = true}) async {
    var dbs = await this.db;
    List data = [];
    List<Map<String, dynamic>> listMaps = [];

    for (var i = 0; i < db_tables.length; i++) {
      listMaps = await dbs.query(db_tables[i]);
      data.add(listMaps);
    }

    List backups = [db_tables, data];
    String json = convert.jsonEncode(backups);
    if (isEncrypted) {
      final key = encrypt.Key.fromUtf8(SECRET_KEY);
      final iv = encrypt.IV.fromLength(16);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final encrypted = encrypter.encrypt(json, iv: iv);
      json = encrypted.base64;
    }
    //file upload
    final directory = await getApplicationDocumentsDirectory();
    File file = new File(
        '${directory.path}/gestmob_Backup${DateTime.now().toString()}.bkp');
    file.writeAsString(json);
    var res = await _googleApi.upload(file);

    return res;
  }

  Future restoreBackup(File backupFile, {bool isEncrypted = true}) async {
    var dbs = await this.db;
    Batch batch = dbs.batch();
    String backup = await backupFile.readAsString();

    await clearAllTables(batch);

    final key = encrypt.Key.fromUtf8(SECRET_KEY);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    List json = convert
        .jsonDecode(isEncrypted ? encrypter.decrypt64(backup, iv: iv) : backup);
    for (var i = 0; i < json[0].length; i++) {
      for (var k = 0; k < json[1][i].length; k++) {
        batch.insert(json[0][i], json[1][i][k]);
      }
    }

    var res = await batch.commit(continueOnError: false, noResult: false);
    return res;
  }

//*********************************************************************************************************************************************
//**********************************************creation des tables***************************************************************************

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
        Rc VARCHAR (25), 
        Nif VARCHAR (25), 
        Nis VARCHAR (25), 
        Ai VARCHAR (25), 
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
  Future<void> createTresorieTable(Database db, int version) async {
    //table des categories des tresories
    await db.execute("""CREATE TABLE IF NOT EXISTS TresorieCategories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        Libelle VARCHAR(20)

        )""");

    await db.execute("""CREATE TABLE IF NOT EXISTS CompteTresorie (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        Num_compte VARCHAR(20),
        Nom_compte VARCHAR(20),
        Code_compte VARCHAR(20),
        Solde_depart Double,
        Solde Double
        )""");

    await db.execute("""CREATE TABLE IF NOT EXISTS ChargeTresorie (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        Libelle VARCHAR(50)
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
          Modalite INTEGER,
          Num_cheque VARCHAR (255),
          Categorie_id INTEGER REFERENCES TresorieCategories (id) ON DELETE SET NULL ON UPDATE CASCADE,
          Compte_id INTEGER REFERENCES CompteTresorie (id) ON DELETE SET NULL ON UPDATE CASCADE,
          Charge_id integer,
          Date integer
      )""");

    await db.execute("""
      CREATE TABLE ReglementTresorie (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          Tresorie_id INTEGER REFERENCES Tresories(id) ON DELETE SET NULL ON UPDATE CASCADE,
          Piece_id,
          Regler DOUBLE
      )""");
  }

  // table des format et current index pour piece
  Future<void> createFormatPieceTable(Database db, int version) async {
    await db.execute("""CREATE TABLE IF NOT EXISTS FormatPiece (
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        Format VARCHAR (20), 
        Piece VARCHAR (4), 
        Current_index integer,
        Year VARCHAR (20) 
        )""");
  }

  //table speciale pour les param??ter de l'app
  Future<void> createMyParamTable(Database db, int version) async {
    await db.execute("""CREATE TABLE IF NOT EXISTS MyParams (
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        Tarification integer DEFAULT 1, 
        Tva integer DEFAULT 0,
        Timbre integer DEFAULT 0,
        Print_display integer ,
        Credit_tier integer,
        Default_format_print Varchar(5),
        Notifications integer DEFAULT 1,
        Notification_time Varchar(10),
        Notification_day integer,
        Echeance integer,
        Pays varchar(255),
        Devise varchar(255),
        Verssion_type varchar(255),
        Start_date integer ,
        Code_abonnement varchar(255),
        AutoVerssement INTEGER NOT NULL DEFAULT 1 
        )""");

    await db.execute('''CREATE TABLE IF NOT EXISTS DefaultPrinters (
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        Adress VARCHAR(25),
        Name VARCHAR(25),
        Type integer
        )''');
  }

//**********************************************************************************************************************************************
//  ********************************************************************************************************************************************
//  ******************************************************** creation des triggers ************************************************************************************

  createTriggersGeneral(Database db, int version) async {
    await db.execute('''
        CREATE TRIGGER update_index_onstart
        AFTER UPDATE ON FormatPiece
        FOR EACH ROW
        WHEN  OLD.Year Not Like NEW.Year 
        BEGIN
           UPDATE FormatPiece
             Set Year = NEW.Year ;
            
           UPDATE FormatPiece
            SET Current_index = IFNULL((Select Max((Cast(Substr (Num_piece,0,INSTR(Num_piece , '/' )) as interger))) From Pieces Where Substr(Num_piece,INSTR(Num_piece , '/' )+1) Like NEW.Year And Piece like 'FP'),0)
           Where Piece = 'FP' ; 
            
           UPDATE FormatPiece
            SET Current_index = IFNULL((Select Max((Cast(Substr (Num_piece,0,INSTR(Num_piece , '/' )) as interger))) From Pieces Where  Substr(Num_piece,INSTR(Num_piece , '/' )+1) like NEW.Year And Piece like 'CC'),0)
           Where Piece = 'CC' ;
           
           UPDATE FormatPiece
            SET Current_index = IFNULL((Select Max((Cast(Substr (Num_piece,0,INSTR(Num_piece , '/' )) as interger))) From Pieces Where  Substr(Num_piece,INSTR(Num_piece , '/' )+1) like NEW.Year And Piece like 'BL'),0)
           Where Piece = 'BL' ;
           
           UPDATE FormatPiece
            SET Current_index = IFNULL((Select Max((Cast(Substr (Num_piece,0,INSTR(Num_piece , '/' )) as interger))) From Pieces Where  Substr(Num_piece,INSTR(Num_piece , '/' )+1) like NEW.Year And Piece like 'FC'),0)
           Where Piece = 'FC' ;
           
           UPDATE FormatPiece
            SET Current_index = IFNULL((Select Max((Cast(Substr (Num_piece,0,INSTR(Num_piece , '/' )) as interger))) From Pieces Where  Substr(Num_piece,INSTR(Num_piece , '/' )+1) like NEW.Year And Piece like 'RC'),0)
           Where Piece = 'RC' ;
           
           UPDATE FormatPiece
            SET Current_index = IFNULL((Select Max((Cast(Substr (Num_piece,0,INSTR(Num_piece , '/' )) as interger))) From Pieces Where  Substr(Num_piece,INSTR(Num_piece , '/' )+1) like NEW.Year And Piece like 'AF'),0)
           Where Piece = 'AF' ;
           
           UPDATE FormatPiece
            SET Current_index = IFNULL((Select Max((Cast(Substr (Num_piece,0,INSTR(Num_piece , '/' )) as interger))) From Pieces Where  Substr(Num_piece,INSTR(Num_piece , '/' )+1) like NEW.Year And Piece like 'BC'),0)
           Where Piece = 'BC' ;
           
           UPDATE FormatPiece
            SET Current_index = IFNULL((Select Max((Cast(Substr (Num_piece,0,INSTR(Num_piece , '/' )) as interger))) From Pieces Where  Substr(Num_piece,INSTR(Num_piece , '/' )+1) like NEW.Year And Piece like 'BR'),0)
           Where Piece = 'BR' ;
           
           UPDATE FormatPiece
            SET Current_index = IFNULL((Select Max((Cast(Substr (Num_piece,0,INSTR(Num_piece , '/' )) as interger))) From Pieces Where  Substr(Num_piece,INSTR(Num_piece , '/' )+1) like NEW.Year And Piece like 'FF'),0)
           Where Piece = 'FF' ;
           
           UPDATE FormatPiece
            SET Current_index = IFNULL((Select Max((Cast(Substr (Num_piece,0,INSTR(Num_piece , '/' )) as interger))) From Pieces Where  Substr(Num_piece,INSTR(Num_piece , '/' )+1) like NEW.Year And Piece like 'RF'),0)
           Where Piece = 'RF' ;
           
           UPDATE FormatPiece
            SET Current_index = IFNULL((Select Max((Cast(Substr (Num_piece,0,INSTR(Num_piece , '/' )) as interger))) From Pieces Where  Substr(Num_piece,INSTR(Num_piece , '/' )+1) like NEW.Year And Piece like 'AC'),0)
           Where Piece = 'AC' ;
           
           UPDATE FormatPiece
            SET Current_index = IFNULL((Select Max((Cast(Substr (Num_tresorie,0,INSTR(Num_tresorie , '/' )) as interger))) From Tresories Where Substr(Num_tresorie,INSTR(Num_tresorie , '/' )+1) like NEW.Year),0)
           Where Piece = 'TR' ;
  
        END;
     ''');
  }

  createTriggersForForeignKey(Database db, int version) async {
    await db.execute('''
        CREATE TRIGGER update_id_ondeletemarque
        Before Delete ON ArticlesMarques
        FOR EACH ROW
        BEGIN
          Update Articles
            Set id_Marque = 1 
          Where id_Marque = old.id ;
        END ;
     ''');
    await db.execute('''
        CREATE TRIGGER update_id_ondeletefamille
        Before Delete ON ArticlesFamilles
        FOR EACH ROW
        BEGIN
          Update Articles
            Set id_Famille = 1 
          Where id_Famille = old.id ;
        END ;
     ''');
    await db.execute('''
        CREATE TRIGGER update_id_ondeletefamilletier
        Before Delete ON ArticlesFamilles
        FOR EACH ROW
        BEGIN
          Update Tiers
            Set id_Famille = 1 
          Where id_Famille = old.id ;
        END ;
     ''');
    await db.execute('''
        CREATE TRIGGER update_tva_onupdatetva
        After Update ON ArticlesTva
        FOR EACH ROW
        BEGIN
          Update Articles
            Set TVA = NEW.Tva , 
                PrixVente1TTC = PrixVente1 + (PrixVente1*(New.Tva/100)),
                PrixVente2TTC = PrixVente2 + (PrixVente2*(New.Tva/100)),
                PrixVente3TTC = PrixVente3 + (PrixVente3*(New.Tva/100))
          Where TVA = old.Tva  ;
        END ;
     ''');
    await db.execute('''
        CREATE TRIGGER update_tva_ondeletetva
        Before Delete ON ArticlesTva
        FOR EACH ROW
        BEGIN
          Update Articles
            Set TVA = 0.0 ,
                PrixVente1TTC = PrixVente1 ,
                PrixVente2TTC = PrixVente2 ,
                PrixVente3TTC = PrixVente3 
          Where TVA = old.Tva  ;
        END ;
     ''');
    await db.execute('''
        CREATE TRIGGER update_id_ondeletecharge
        Before Delete ON ChargeTresorie
        FOR EACH ROW
        BEGIN
          Update Tresories
            Set Charge_id = 1 
          Where Charge_id = old.id ;
        END ;
     ''');
    await db.execute('''
        CREATE TRIGGER update_id_ondeletecompte
        Before Delete ON CompteTresorie
        FOR EACH ROW
        BEGIN
          Update Tresories
            Set Compte_id = 1 
          Where Compte_id = old.id ;
        END ;
     ''');

  }

  //fonction speciale pour la creation des triggers de bd table article
  createTriggersJournaux(Database db, int version) async {
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
              Set Marge = IFNULL((Select SUM(Marge) from Journaux where Piece_id = NEW.Piece_id AND New.Mov <> -2),0)
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
              Set Marge = IFNULL((Select SUM(Marge) from Journaux where Piece_id = NEW.Piece_id AND New.Mov <> -2),0)
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
              Set Marge = IFNULL((Select SUM(Marge) from Journaux where Piece_id = NEW.Piece_id AND New.Mov <> -2),0)
            where id = New.Piece_id ;
        END;
     ''');

    await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_articles_cmd_onUpdate_mov
        AFTER UPDATE ON Journaux
        FOR EACH ROW
        WHEN (OLD.Mov <> NEW.Mov)  AND (NEW.Mov = 0 OR NEW.Mov = 2 OR NEW.Mov = -1 OR NEW.Mov = -2)  AND Old.Mov = 1
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
                   Colis = (Qte - NEW.Qte) / Qte_Colis
             WHERE id = New.Article_id;
             
            Update Pieces
              Set Marge = IFNULL((Select SUM(Marge) from Journaux where Piece_id = NEW.Piece_id AND New.Mov <> -2),0)
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
               Colis = IFNULL((Qte - (NEW.Qte - OLD.Qte)) / Qte_Colis , 0)
             WHERE id = NEW.Article_id ;
             
            Update Pieces
              Set Marge = IFNULL((Select SUM(Marge) from Journaux where Piece_id = NEW.Piece_id AND New.Mov <> -2),0)
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
               Colis = IFNULL((Qte - NEW.Qte) / Qte_Colis , 0)
             WHERE id = NEW.Article_id ;
             
            Update Pieces
              Set Marge = IFNULL((Select SUM(Marge) from Journaux where Piece_id = NEW.Piece_id AND New.Mov <> -2),0)
            where id = New.Piece_id ;
        END;
     ''');

    await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_articles_qte_onUpdate_client_mov
        AFTER UPDATE ON Journaux
        FOR EACH ROW
        WHEN (OLD.Mov <> NEW.Mov)  AND (NEW.Mov = 0 OR NEW.Mov = 2 OR NEW.Mov = -1 OR NEW.Mov = -2) AND Old.Mov = 1
              AND (NEW.Piece_type = 'BL' OR NEW.Piece_type = 'FC')      
        BEGIN
            UPDATE Articles
               SET Qte = Qte + OLD.Qte ,
                   Colis = IFNULL((Qte + OLD.Qte) / Qte_Colis , 0)
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
               SET PMP = IFNULL(((Qte * PMP)+(NEW.Qte * NEW.Net_ht))/(Qte + NEW.Qte) , 0), 
                   Qte = Qte + NEW.Qte,
                   Colis = IFNULL((Qte + NEW.Qte) / Qte_Colis , 0),
                   PrixAchat = NEW.Net_ht
            WHERE id = New.Article_id;
             
            Update Pieces
              Set Marge = IFNULL((Select SUM(Marge) from Journaux where Piece_id = NEW.Piece_id AND New.Mov <> -2),0)
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
             SET PMP = IFNULL(((Qte * PMP) - (OLD.Qte * OLD.Net_ht)) / (Qte -OLD.Qte) , 0), 
                 Qte = Qte - OLD.Qte
            WHERE id = New.Article_id;
        
            UPDATE Articles
               SET PMP = IFNULL(((Qte * PMP)+(NEW.Qte * NEW.Net_ht))/(Qte + NEW.Qte) , 0) , 
                   Qte = Qte + NEW.Qte,
                   Colis = IFNULL((Qte + NEW.Qte) / Qte_Colis , 0),
                   PrixAchat = NEW.Net_ht
             WHERE id = New.Article_id;
             
            Update Pieces
              Set Marge = IFNULL((Select SUM(Marge) from Journaux where Piece_id = NEW.Piece_id AND New.Mov <> -2),0)
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
               SET PMP = IFNULL(((Qte * PMP)+(NEW.Qte * NEW.Net_ht))/(Qte + NEW.Qte) , 0) , 
                   Qte = Qte + NEW.Qte,
                   Colis = IFNULL((Qte + NEW.Qte) / Qte_Colis , 0),
                   PrixAchat = NEW.Net_ht
             WHERE id = New.Article_id;
             
            Update Pieces
              Set Marge = IFNULL((Select SUM(Marge) from Journaux where Piece_id = NEW.Piece_id AND New.Mov <> -2),0)
            where id = New.Piece_id ;
        END;
     ''');

    // ?? reviser
    await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_articles_qte_onUpdate_fournisseur_mov
        AFTER UPDATE ON Journaux
        FOR EACH ROW
        WHEN  (OLD.Mov <> NEW.Mov) AND (NEW.Mov = 0 OR NEW.Mov = 2 OR NEW.Mov = -1 OR NEW.Mov = -2)  AND Old.Mov = 1
              AND (NEW.Piece_type = 'BR' OR NEW.Piece_type = 'FF') 
        BEGIN
            UPDATE Articles
               SET PMP = IFNULL(((Qte * PMP)-(OLD.Qte * OLD.Net_ht)) / (Qte - OLD.Qte),Old.Prix_revient) , 
                   Qte = Qte - OLD.Qte,
                   Colis = IFNULL((Qte - OLD.Qte) / Qte_Colis , 0)
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
               SET PMP = IFNULL(((Qte * PMP)+((NEW.Qte*-1) * NEW.Prix_revient))/(Qte + (NEW.Qte*-1)),0) , 
                   Qte = Qte + (NEW.Qte*-1),
                   Colis = IFNULL((Qte + (NEW.Qte*-1)) / Qte_Colis , 0)
             WHERE id = New.Article_id;
             
            Update Pieces
              Set Marge = IFNULL((Select SUM(Marge) from Journaux where Piece_id = NEW.Piece_id AND New.Mov <> -2),0) * -1 
            where id = New.Piece_id ;
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
               SET PMP = IFNULL(((Qte * PMP)-((OLD.Qte*-1) * OLD.Prix_revient)) / (Qte - (OLD.Qte*-1)) , 0) , 
                   Qte = Qte - (OLD.Qte*-1)
             WHERE id = New.Article_id;
             
            UPDATE Articles
               SET PMP = IFNULL(((Qte * PMP)+((NEW.Qte*-1) * NEW.Prix_revient)) / (Qte + (NEW.Qte*-1)) , 0) , 
                   Qte = Qte + (NEW.Qte*-1),
                   Colis = IFNULL((Qte + (NEW.Qte*-1)) / Qte_Colis , 0)
             WHERE id = New.Article_id;
            
            Update Pieces
              Set Marge = IFNULL((Select SUM(Marge) from Journaux where Piece_id = NEW.Piece_id AND New.Mov <> -2),0) * -1 
            where id = New.Piece_id ;
        END;
     ''');

    await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_articles_qte_onUpdate_retour_mov1
        AFTER UPDATE ON Journaux
        FOR EACH ROW
        WHEN (OLD.Mov <> NEW.Mov) AND NEW.Mov = 1 AND (NEW.Piece_type = 'RC' OR NEW.Piece_type = 'AC')
        BEGIN
           UPDATE Articles
               SET PMP = IFNULL(((Qte * PMP)+((NEW.Qte*-1) * NEW.Prix_revient))/(Qte + (NEW.Qte*-1)) , 0), 
                   Qte = Qte + (NEW.Qte*-1),
                   Colis = IFNULL((Qte + (NEW.Qte*-1)) / Qte_Colis , 0)
             WHERE id = New.Article_id;

           Update Pieces
              Set Marge = IFNULL((Select SUM(Marge) from Journaux where Piece_id = NEW.Piece_id AND New.Mov <> -2),0) * -1 
            where id = New.Piece_id ;
        END;
     ''');

    await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_articles_qte_onUpdate_retour_mov
        AFTER UPDATE ON Journaux
        FOR EACH ROW
        WHEN  (OLD.Mov <> NEW.Mov) AND (NEW.Mov = 0 OR NEW.Mov = 2 OR NEW.Mov = -1 OR NEW.Mov = -2)  AND Old.Mov = 1
              AND (NEW.Piece_type = 'RC' OR NEW.Piece_type = 'AC') 
        BEGIN
            UPDATE Articles
               SET PMP = IFNULL(((Qte * PMP)-((OLD.Qte*-1) * OLD.Prix_revient))/(Qte - (OLD.Qte*-1)),0) , 
                   Qte = Qte - (OLD.Qte*-1),
                   Colis = IFNULL((Qte - (OLD.Qte*-1)) / Qte_Colis , 0)
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
               SET PMP = IFNULL(((Qte * PMP)-((NEW.Qte*-1) * NEW.Net_ht))/(Qte - (NEW.Qte*-1)) , 0) ,
                   Qte = Qte - (NEW.Qte*-1),
                   Colis = IFNULL((Qte - (NEW.Qte*-1)) / Qte_Colis , 0)
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
               SET PMP = IFNULL(((Qte * PMP)+((OLD.Qte*-1) * OLD.Net_ht))/(Qte + (OLD.Qte*-1)),0) ,
                   Qte = Qte + (OLD.Qte*-1)
             WHERE id = NEW.Article_id ;
             
            UPDATE Articles
               SET PMP = IFNULL(((Qte * PMP) - ((NEW.Qte*-1) * NEW.Net_ht))/(Qte - (NEW.Qte*-1)),0) ,
                   Qte = Qte - (NEW.Qte*-1),
                   Colis = IFNULL((Qte - (NEW.Qte*-1)) / Qte_Colis , 0)
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
               SET PMP = IFNULL(((Qte * PMP)-((NEW.Qte*-1) * NEW.Net_ht))/(Qte - (NEW.Qte*-1)) , 0) ,
                   Qte = Qte - (NEW.Qte*-1) ,
                   Colis = IFNULL((Qte - (NEW.Qte*-1)) / Qte_Colis , 0)
             WHERE id = NEW.Article_id ;
             
        END;
     ''');

    await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_articles_qte_onUpdate_retour_four_mov
        AFTER UPDATE ON Journaux
        FOR EACH ROW
        WHEN (OLD.Mov <> NEW.Mov)  AND (NEW.Mov = 0 OR NEW.Mov = 2 OR NEW.Mov = -1 OR NEW.Mov = -2)  AND Old.Mov = 1
              AND (NEW.Piece_type = 'RF' OR NEW.Piece_type = 'AF')      
        BEGIN
            UPDATE Articles
               SET PMP = IFNULL(((Qte * PMP)+((OLD.Qte*-1) * OLD.Net_ht))/(Qte + (OLD.Qte*-1)) , 0) ,
                   Qte = Qte + (OLD.Qte*-1) ,
                   Colis = IFNULL((Qte + (OLD.Qte*-1)) / Qte_Colis , 0),
                   PrixAchat = OLD.Prix_ht
             WHERE id = New.Article_id;
            
        END;
     ''');
  }

  //fonction speciale pour la creation des triggers de bd table piece et format
  createTriggersPiece(Database db, int version) async {
    // update_current_index
    await db.execute('''CREATE TRIGGER update_current_index 
        AFTER INSERT ON Pieces 
        FOR EACH ROW 
        When ( (Cast(Substr (NEW.Num_piece,0,INSTR(NEW.Num_piece , '/' )) as interger)) > (Select Current_index From FormatPiece where FormatPiece.Piece LIKE NEW.Piece) )
        BEGIN 
            UPDATE FormatPiece
               SET Current_index = ( Cast(Substr (NEW.Num_piece,0,INSTR(NEW.Num_piece , '/' )) as interger) )
            WHERE FormatPiece.Piece LIKE NEW.Piece ; 
        END;
      ''');

    await db.execute('''CREATE TRIGGER update_current_index_after_update
        AFTER Update ON Pieces 
        FOR EACH ROW 
        WHEN New.Num_piece <> Old.Num_piece 
            AND ( (Cast(Substr (NEW.Num_piece,0,INSTR(NEW.Num_piece , '/' )) as interger)) > (Select Current_index From FormatPiece Where FormatPiece.Piece LIKE NEW.Piece) )
        BEGIN 
            UPDATE FormatPiece
               SET Current_index = ( Cast(Substr (NEW.Num_piece,0,INSTR(NEW.Num_piece , '/' )) as interger) )
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
               SET Chiffre_affaires = IFNULL((Select Sum(Net_a_payer) From Pieces where Tier_id = New.Tier_id AND Mov = 1 AND Piece <> "CC" AND Piece <> "FP" AND Piece <> "BC"),0)
             WHERE id = New.Tier_id; 
             
             UPDATE Tiers
                SET Regler = IFNULL((SELECT SUM(Montant) FROM Tresories WHERE Tier_id = New.Tier_id AND Mov = 1),0)
             WHERE id = NEW.Tier_id ;
             
             UPDATE Tiers
               SET  Credit = (Solde_depart + Chiffre_affaires) - Regler 
             WHERE id = New.Tier_id;
        END;
     ''');

    //*****************************************************************************************************************************
    //***************************************************edit piece****************************************************************
    await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_tresorie_on_update_piece
        AFTER UPDATE ON Pieces
        FOR EACH ROW
        WHEN (OLD.Tier_id <> NEW.Tier_id) 
        BEGIN
             UPDATE Tresories
               SET Tier_id = New.Tier_id ,
                   Tier_rs = (Select RaisonSociale From Tiers Where id = New.Tier_id)
             WHERE Piece_id = NEW.id ;
             
             UPDATE Pieces
               SET Tier_id = New.Tier_id
             WHERE id = (Select Old_Piece_id From Transformers Where New_Piece_id = OLD.id);
        END;
     ''');

    await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_tiers_chiffre_affaires2
        AFTER UPDATE ON Pieces
        FOR EACH ROW
        WHEN NEW.Mov = 1 AND NEW.Piece <> "CC"
        BEGIN
             UPDATE Tiers
               SET Chiffre_affaires = IFNULL((Select Sum(Net_a_payer) From Pieces where Tier_id = OLD.Tier_id AND Mov = 1 AND Piece <> "CC" AND Piece <> "FP" AND Piece <> "BC"),0)
             WHERE id = OLD.Tier_id;
             UPDATE Tiers
                SET Regler = IFNULL((SELECT SUM(Montant) FROM Tresories WHERE Tier_id = New.Tier_id AND Mov = 1),0)
             WHERE id = OLD.Tier_id ;
             UPDATE Tiers
               SET  Credit = (Solde_depart + Chiffre_affaires) - Regler 
             WHERE id = OLD.Tier_id;
             
             UPDATE Tiers
               SET Chiffre_affaires = IFNULL((Select Sum(Net_a_payer) From Pieces where Tier_id = NEW.Tier_id AND Mov = 1 AND Piece <> "CC" AND Piece <> "FP" AND Piece <> "BC"),0)
             WHERE id = NEW.Tier_id;
             UPDATE Tiers
                SET Regler = IFNULL((SELECT SUM(Montant) FROM Tresories WHERE Tier_id = New.Tier_id AND Mov = 1),0)
             WHERE id = NEW.Tier_id ;
             UPDATE Tiers
               SET  Credit = (Solde_depart + Chiffre_affaires) - Regler 
             WHERE id = NEW.Tier_id;
             
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
               SET Chiffre_affaires = IFNULL((Select Sum(Net_a_payer) From Pieces where Tier_id = OLD.Tier_id AND Mov = 1 AND Piece <> "CC" AND Piece <> "FP" AND Piece <> "BC"),0)
             WHERE id = OLD.Tier_id;
             UPDATE Tiers
                SET Regler = IFNULL((SELECT SUM(Montant) FROM Tresories WHERE Tier_id = New.Tier_id AND Mov = 1),0)
             WHERE id = OLD.Tier_id ;
             UPDATE Tiers
               SET  Credit = (Solde_depart + Chiffre_affaires) - Regler 
             WHERE id = OLD.Tier_id;
             
             UPDATE Tiers
               SET Chiffre_affaires = IFNULL((Select Sum(Net_a_payer) From Pieces where Tier_id = NEW.Tier_id AND Mov = 1 AND Piece <> "CC" AND Piece <> "FP" AND Piece <> "BC"),0)
             WHERE id = NEW.Tier_id;
             UPDATE Tiers
                SET Regler = IFNULL((SELECT SUM(Montant) FROM Tresories WHERE Tier_id = New.Tier_id AND Mov = 1),0)
             WHERE id = NEW.Tier_id ;
             UPDATE Tiers
               SET  Credit = (Solde_depart + Chiffre_affaires) - Regler 
             WHERE id = NEW.Tier_id;
        END;
     ''');

    await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_tiers_chiffre_affaires4
        AFTER UPDATE ON Pieces
        FOR EACH ROW
        WHEN (OLD.Mov <> NEW.Mov)  AND (NEW.Mov = 1) AND NEW.Piece <> "CC"
        BEGIN
             UPDATE Tiers
               SET Chiffre_affaires = IFNULL((Select Sum(Net_a_payer) From Pieces where Tier_id = OLD.Tier_id AND Mov = 1 AND Piece <> "CC" AND Piece <> "FP" AND Piece <> "BC"),0)
             WHERE id = OLD.Tier_id;
             UPDATE Tiers
                SET Regler = IFNULL((SELECT SUM(Montant) FROM Tresories WHERE Tier_id = New.Tier_id AND Mov = 1),0)
             WHERE id = OLD.Tier_id ;
             UPDATE Tiers
               SET  Credit = (Solde_depart + Chiffre_affaires) - Regler 
             WHERE id = OLD.Tier_id;
             
             UPDATE Tiers
               SET Chiffre_affaires = IFNULL((Select Sum(Net_a_payer) From Pieces where Tier_id = NEW.Tier_id AND Mov = 1 AND Piece <> "CC" AND Piece <> "FP" AND Piece <> "BC"),0)
             WHERE id = NEW.Tier_id;
             UPDATE Tiers
                SET Regler = IFNULL((SELECT SUM(Montant) FROM Tresories WHERE Tier_id = New.Tier_id AND Mov = 1),0)
             WHERE id = NEW.Tier_id ;
             UPDATE Tiers
               SET  Credit = (Solde_depart + Chiffre_affaires) - Regler 
             WHERE id = NEW.Tier_id;
        END;
     ''');

    await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_piece_transformer
        AFTER UPDATE ON Pieces
        FOR EACH ROW
        When  (Old.Etat <> New.Etat) AND New.Etat = 1
        BEGIN
            UPDATE Pieces
              SET Regler = IFNULL((SELECT SUM(Regler) FROM ReglementTresorie WHERE Piece_id = OLD.id ),0)
            WHERE id =  OLD.id ;

             UPDATE Pieces
               SET  Reste = Net_a_payer - Regler 
             WHERE id = OLD.id;
        END;
     ''');

    //*******************************************************************************************************************************
    //***************************************************dell piece***********************************************************

    await db.execute('''
        CREATE TRIGGER IF NOT EXISTS reset_current_index
        BEFORE DELETE ON Pieces
        FOR EACH ROW
        WHEN  Cast(Substr (OLD.Num_piece,0,INSTR(OLD.Num_piece , '/' )) as interger)  = (Select Current_index From FormatPiece Where Piece like OLD.Piece)
        BEGIN
           UPDATE FormatPiece
               SET Current_index = IFNULL((Select Max(Cast(Substr (Num_piece,0,INSTR(Num_piece , '/' )) as interger)) From Pieces where Piece like OLD.Piece And Num_piece <> Old.Num_piece),0)
            WHERE  FormatPiece.Piece LIKE OLD.Piece;
        END;
     ''');

    await db.execute('''
        CREATE TRIGGER IF NOT EXISTS delete_journaux
        BEFORE DELETE ON Pieces
        FOR EACH ROW
        BEGIN
           Update Journaux 
              Set Mov = -2
           WHERE Piece_id = Old.id;
           
           Update Tresories 
             set Piece_id = null 
           where Piece_id = Old.id ;
        END;
     ''');


    await db.execute('''
        CREATE TRIGGER IF NOT EXISTS delete_tresorie
        BEFORE DELETE ON Pieces
        FOR EACH ROW
        WHEN (OLD.Mov = 1 AND OLD.Piece <> "CC")
        BEGIN
             UPDATE Tiers
               SET Chiffre_affaires = IFNULL((Select (Sum(Net_a_payer)-Old.Net_a_payer) From Pieces where Tier_id = OLD.Tier_id AND Mov = 1 AND Piece <> "CC" AND Piece <> "FP" AND Piece <> "BC"),0)
             WHERE id = OLD.Tier_id;
             UPDATE Tiers
                SET Regler = IFNULL((SELECT SUM(Montant) FROM Tresories WHERE Tier_id = OLD.Tier_id AND Mov = 1) , 0)
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

  // NB : pour l'etat de la tresorie on doit l'ajouter le mov ?? la condition de calcul (regler) de tier
  createTriggersTresorie(Database db, int version) async {
    await db.execute('''CREATE TRIGGER update_current_index_tr 
        AFTER INSERT ON Tresories 
        FOR EACH ROW 
        When ( (Cast(Substr (NEW.Num_tresorie,0,INSTR(NEW.Num_tresorie , '/' )) as interger)) > (Select Current_index From FormatPiece where FormatPiece.Piece LIKE 'TR') )
        BEGIN 
            UPDATE FormatPiece
               SET Current_index =( Cast(Substr (NEW.Num_tresorie,0,INSTR(NEW.Num_tresorie , '/' )) as interger) )
            WHERE  FormatPiece.Piece LIKE "TR" ; 
            
        END;
      ''');

    await db.execute('''CREATE TRIGGER update_current_index_tr_after_update
        AFTER Update ON Tresories 
        FOR EACH ROW 
        When New.Num_tresorie <> Old.Num_tresorie 
            AND  ( (Cast(Substr (NEW.Num_tresorie,0,INSTR(NEW.Num_tresorie , '/' )) as interger)) > (Select Current_index From FormatPiece where FormatPiece.Piece LIKE 'TR') )
        BEGIN 
            UPDATE FormatPiece
               SET Current_index =( Cast(Substr (NEW.Num_tresorie,0,INSTR(NEW.Num_tresorie , '/' )) as interger) )
            WHERE  FormatPiece.Piece LIKE "TR" ; 
            
        END;
      ''');

    //****************************************************************************************************************************
    //***********************************************compte Tresorerie***********************************************************
    await db.execute('''CREATE TRIGGER update_compte_solde_afterupdate
        AFTER Update ON CompteTresorie 
        FOR EACH ROW 
        When Old.Solde_depart <> New.Solde_depart
        BEGIN     
            UPDATE CompteTresorie
              SET  Solde = New.Solde_depart + IFNULL((Select Sum(Montant) From Tresories 
                                            Where Compte_id = New.id AND 
                                                  (Categorie_id = 2 OR Categorie_id = 4 OR Categorie_id = 6)
                                             ),0)
                                          + IFNULL((Select  -1 * Sum(Montant) From Tresories 
                                            Where Compte_id = New.id AND 
                                                  (Categorie_id = 3 OR Categorie_id = 5 OR Categorie_id = 7 OR Categorie_id = 8)
                                            ),0)
            WHERE id = New.id;  
            
        END;
      ''');
    // ***************************************************************************************************************
    //**********************************************add tresorie*******************************************************

    await db.execute('''CREATE TRIGGER update_compte_solde 
        AFTER INSERT ON Tresories 
        FOR EACH ROW 
        BEGIN     
            UPDATE CompteTresorie
              SET  Solde = Solde_depart + IFNULL((Select Sum(Montant) From Tresories 
                                            Where Compte_id = New.Compte_id AND 
                                                  (Categorie_id = 2 OR Categorie_id = 4 OR Categorie_id = 6)
                                             ),0)
            WHERE id = New.Compte_id; 
           
            UPDATE CompteTresorie
              SET  Solde = Solde + IFNULL((Select  -1 * Sum(Montant) From Tresories 
                                            Where Compte_id = New.Compte_id AND 
                                                  (Categorie_id = 3 OR Categorie_id = 5 OR Categorie_id = 7 OR Categorie_id = 8)
                                            ),0)
            WHERE id = New.Compte_id; 
            
        END;
      ''');

    await db.execute('''CREATE TRIGGER update_tier_reglement_credit 
        AFTER INSERT ON Tresories 
        FOR EACH ROW 
        when (New.Categorie_id = 2 OR New.Categorie_id = 3 OR New.Categorie_id = 6 OR New.Categorie_id = 7)
        BEGIN             
             UPDATE Tiers
               SET Chiffre_affaires = IFNULL((Select Sum(Net_a_payer) From Pieces where Tier_id = New.Tier_id AND Mov = 1 AND Piece <> "CC" AND Piece <> "FP" AND Piece <> "BC"),0)
             WHERE id = New.Tier_id; 
           
            UPDATE Tiers
              SET Regler = IFNULL((SELECT SUM(Montant) FROM Tresories WHERE Tier_id = New.Tier_id AND Mov = 1),0)
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
              SET Regler = IFNULL((SELECT SUM(Regler) FROM ReglementTresorie WHERE Piece_id = New.Piece_id),0)
            WHERE id =  New.Piece_id ;

             UPDATE Pieces
               SET  Reste = Net_a_payer - Regler 
             WHERE id = New.Piece_id;

        END;
      ''');

    // ***************************************************************************************************************
    //**********************************************update tresorie*******************************************************
    await db.execute('''CREATE TRIGGER update_compte_solde_onupdate
        AFTER UPDATE ON Tresories 
        FOR EACH ROW 
        BEGIN     
            UPDATE CompteTresorie
              SET  Solde = Solde_depart + IFNULL((Select Sum(Montant) From Tresories 
                                            Where Compte_id = New.Compte_id AND 
                                                  (Categorie_id = 2 OR Categorie_id = 4 OR Categorie_id = 6)
                                             ),0)
            WHERE id = New.Compte_id; 
            
            UPDATE CompteTresorie
              SET  Solde = Solde + IFNULL((Select  -1 * Sum(Montant) From Tresories 
                                            Where Compte_id = New.Compte_id AND 
                                                  (Categorie_id = 3 OR Categorie_id = 5 OR Categorie_id = 7 OR Categorie_id = 8)
                                            ),0)
            WHERE id = New.Compte_id; 
           
            UPDATE CompteTresorie
              SET  Solde = Solde_depart + IFNULL((Select Sum(Montant) From Tresories 
                                            Where Compte_id = OLD.Compte_id AND 
                                                  (Categorie_id = 2 OR Categorie_id = 4 OR Categorie_id = 6)
                                             ),0)
            WHERE id = OLD.Compte_id; 
            
            UPDATE CompteTresorie
              SET  Solde = Solde + IFNULL((Select  -1 * Sum(Montant) From Tresories 
                                            Where Compte_id = OLD.Compte_id AND 
                                                  (Categorie_id = 3 OR Categorie_id = 5 OR Categorie_id = 7 OR Categorie_id = 8)
                                            ),0)
            WHERE id = OLD.Compte_id; 
        END;
      ''');

    await db.execute('''CREATE TRIGGER update_tier_reglement_credit3
        AFTER UPDATE ON Tresories 
        FOR EACH ROW 
        when (New.Categorie_id = 2 OR New.Categorie_id = 3 OR New.Categorie_id = 6 OR New.Categorie_id = 7)
             AND (OLD.Mov <> New.Mov) AND NEW.Mov = 1
        BEGIN        
             UPDATE Tiers
               SET Chiffre_affaires = IFNULL((Select Sum(Net_a_payer) From Pieces where Tier_id = OLD.Tier_id AND Mov = 1 AND Piece <> "CC" AND Piece <> "FP" AND Piece <> "BC"),0)
             WHERE id = OLD.Tier_id; 
            UPDATE Tiers
              SET Regler = IFNULL((SELECT SUM(Montant) FROM Tresories WHERE Tier_id = OLD.Tier_id AND Mov = 1),0)
            WHERE id = OLD.Tier_id ;
             UPDATE Tiers
               SET  Credit = (Solde_depart + Chiffre_affaires) - Regler 
             WHERE id = OLD.Tier_id;
                 
            UPDATE Tiers
               SET Chiffre_affaires = IFNULL((Select Sum(Net_a_payer) From Pieces where Tier_id = New.Tier_id AND Mov = 1 AND Piece <> "CC" AND Piece <> "FP" AND Piece <> "BC"),0)
             WHERE id = New.Tier_id; 
            UPDATE Tiers
              SET Regler = IFNULL((SELECT SUM(Montant) FROM Tresories WHERE Tier_id = New.Tier_id AND Mov = 1),0)
            WHERE id = NEW.Tier_id ;
             UPDATE Tiers
               SET  Credit = (Solde_depart + Chiffre_affaires) - Regler 
             WHERE id = New.Tier_id;
             
        END;
      ''');

    await db.execute('''CREATE TRIGGER update_tier_reglement_credit_4
        AFTER UPDATE ON Tresories
        FOR EACH ROW
        BEGIN
             UPDATE Tiers
               SET Chiffre_affaires = IFNULL((Select Sum(Net_a_payer) From Pieces where Tier_id = OLD.Tier_id AND Mov = 1 AND Piece <> "CC" AND Piece <> "FP" AND Piece <> "BC"),0)
             WHERE id = OLD.Tier_id;
            UPDATE Tiers
              SET Regler = IFNULL((SELECT SUM(Montant) FROM Tresories WHERE Tier_id = OLD.Tier_id AND Mov = 1),0)
            WHERE id = OLD.Tier_id ;
             UPDATE Tiers
               SET  Credit = (Solde_depart + Chiffre_affaires) - Regler
             WHERE id = OLD.Tier_id;

            UPDATE Tiers
               SET Chiffre_affaires = IFNULL((Select Sum(Net_a_payer) From Pieces where Tier_id = New.Tier_id AND Mov = 1 AND Piece <> "CC" AND Piece <> "FP" AND Piece <> "BC"),0)
             WHERE id = New.Tier_id;
            UPDATE Tiers
              SET Regler = IFNULL((SELECT SUM(Montant) FROM Tresories WHERE Tier_id = New.Tier_id AND Mov = 1),0)
            WHERE id = NEW.Tier_id ;
             UPDATE Tiers
               SET  Credit = (Solde_depart + Chiffre_affaires) - Regler
             WHERE id = New.Tier_id;

        END;
      ''');

    // ***************************************************************************************************************
    //**********************************************dell tresorie*******************************************************
    await db.execute('''
        CREATE TRIGGER IF NOT EXISTS reset_current_index_tresorie
        BEFORE DELETE ON Tresories
        FOR EACH ROW
        WHEN Cast(Substr (OLD.Num_tresorie,0,INSTR(OLD.Num_tresorie , '/' )) as interger) = (Select Current_index from FormatPiece where Piece like 'TR')
        BEGIN
           UPDATE FormatPiece
               SET Current_index = IFNULL((Select Max(Cast(Substr (Num_tresorie,0,INSTR(Num_tresorie , '/' )) as interger) ) From Tresories Where Num_tresorie <> Old.Num_tresorie ),0)
            WHERE  FormatPiece.Piece LIKE 'TR' ;
        END;
     ''');

    await db.execute('''CREATE TRIGGER dell_tresorie 
        BEFORE DELETE ON Tresories 
        FOR EACH ROW 
        BEGIN 
          DELETE FROM ReglementTresorie WHERE Tresorie_id = OLD.id ;
           
          UPDATE Tiers
             SET Chiffre_affaires = IFNULL((Select Sum(Net_a_payer) From Pieces where Tier_id = OLD.Tier_id AND Mov = 1 AND Piece <> "CC" AND Piece <> "FP" AND Piece <> "BC"),0)
          WHERE id = OLD.Tier_id; 
           
          UPDATE Tiers
              SET Regler = IFNULL((SELECT SUM(Montant)-OLD.Montant FROM Tresories WHERE Tier_id = OLD.Tier_id AND Mov = 1),0)
          WHERE id = OLD.Tier_id ; 
    
           UPDATE Tiers
             SET  Credit = (Solde_depart + Chiffre_affaires) - Regler 
           WHERE id = OLD.Tier_id;
       
        END;
      ''');

    await db.execute('''CREATE TRIGGER dell_regelement_tresorie 
        BEFORE DELETE ON ReglementTresorie 
        FOR EACH ROW 
        BEGIN 
            UPDATE Pieces
              SET Regler = IFNULL((SELECT SUM(Regler)-OLD.Regler FROM ReglementTresorie WHERE Piece_id = OLD.Piece_id ),0)
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
           WHERE Piece_id = OLD.Old_Piece_id AND Mov <> -2;
           
           UPDATE Tresories 
              SET Piece_id = OLD.Old_Piece_id 
           WHERE Piece_id = OLD.New_Piece_id ;
           
           UPDATE ReglementTresorie 
              SET Piece_id = OLD.Old_Piece_id 
           WHERE Piece_id = OLD.New_Piece_id ;
              
           UPDATE Pieces 
              SET Regler = IFNULL((SELECT SUM(Regler) FROM ReglementTresorie WHERE Piece_id = OLD.Old_Piece_id),0)
           WHERE id = OLD.Old_Piece_id ;

           UPDATE Pieces
              SET  Reste = Net_a_payer - Regler 
           WHERE id = OLD.Old_Piece_id ;
        END;
      ''');

  }

//*****************************************************************************************************************************************
//*****************************************************************************************************************************************
//******************************************************** initi data *********************************************************************************
  Future<void> setInitialData(Database db, int version) async {
    Batch batch = db.batch();

    Uint8List image01 = await Helpers.getDefaultImageUint8List(from: "profile");

    batch.rawInsert(
        'INSERT INTO Profile(BytesImageString, Raison, CodePin, CodePinEnabled, Statut, Adresse, AdresseWeb, Ville, Departement, Pays, Cp, Telephone, Telephone2, Fax, Mobile, Mobile2,'
        'Mail, Site, Rc, Nif, Ai, Capital, Activite, Nis, Codedouane, Maposition) '
        'VALUES("${Helpers.getEncodedByteStringFromUint8List(image01)}", "Raison", "", 0, 1, "Adresse", "AdresseWeb", "Ville", "Departement", "Pays", "Cp", "Telephone", "Telephone2", "Fax", "Mobile", "Mobile2",'
        '"Mail", "Site", "Rc", "Nif", "Ai", "25", "Activite", "Nis", "Codedouane", "Maposition")');

    batch.rawInsert(
        'INSERT INTO ArticlesMarques(Libelle, BytesImageString) VALUES("No Marque", "")');
    batch.rawInsert(
        'INSERT INTO ArticlesFamilles(Libelle, BytesImageString) VALUES("No Famille", "")');
    batch.rawInsert('INSERT INTO TiersFamilles(Libelle) VALUES("No Famille")');

    batch.rawInsert(
        'INSERT INTO TresorieCategories(Libelle) VALUES("No Categorie")');
    batch.rawInsert(
        'INSERT INTO TresorieCategories(Libelle) VALUES("Reglement Client")');
    batch.rawInsert(
        'INSERT INTO TresorieCategories(Libelle) VALUES("Reglement Fournisseur")');
    batch.rawInsert(
        'INSERT INTO TresorieCategories(Libelle) VALUES("Encaissement")');
    batch.rawInsert('INSERT INTO TresorieCategories(Libelle) VALUES("Charge")');
    batch.rawInsert(
        'INSERT INTO TresorieCategories(Libelle) VALUES("Remboursement Client")');
    batch.rawInsert(
        'INSERT INTO TresorieCategories(Libelle) VALUES("Remboursement Fournisseur")');
    batch.rawInsert(
        'INSERT INTO TresorieCategories(Libelle) VALUES("Decaissement")');

    batch.rawInsert(
        'INSERT INTO ChargeTresorie(Libelle) VALUES("No Categorie")');

    batch.rawInsert(
        'INSERT INTO FormatPiece(Format , Piece , Current_index,Year) VALUES("XXXX/YYYY"  , "FP" , 0 , ${DateTime.now().year.toString()})');
    batch.rawInsert(
        'INSERT INTO FormatPiece(Format , Piece , Current_index,Year) VALUES("XXXX/YYYY"  , "CC" , 0 , ${DateTime.now().year.toString()})');
    batch.rawInsert(
        'INSERT INTO FormatPiece(Format , Piece , Current_index,Year) VALUES("XXXX/YYYY"  , "BL" , 0 , ${DateTime.now().year.toString()})');
    batch.rawInsert(
        'INSERT INTO FormatPiece(Format , Piece , Current_index,Year) VALUES("XXXX/YYYY"  , "FC" , 0 , ${DateTime.now().year.toString()})');
    batch.rawInsert(
        'INSERT INTO FormatPiece(Format , Piece , Current_index,Year) VALUES("XXXX/YYYY"  , "RC" , 0 , ${DateTime.now().year.toString()})');
    batch.rawInsert(
        'INSERT INTO FormatPiece(Format , Piece , Current_index,Year) VALUES("XXXX/YYYY"  , "AF" , 0 , ${DateTime.now().year.toString()})');
    batch.rawInsert(
        'INSERT INTO FormatPiece(Format , Piece , Current_index,Year) VALUES("XXXX/YYYY"  , "BC" , 0 , ${DateTime.now().year.toString()})');
    batch.rawInsert(
        'INSERT INTO FormatPiece(Format , Piece , Current_index,Year) VALUES("XXXX/YYYY"  , "BR" , 0 , ${DateTime.now().year.toString()})');
    batch.rawInsert(
        'INSERT INTO FormatPiece(Format , Piece , Current_index,Year) VALUES("XXXX/YYYY"  , "FF" , 0 , ${DateTime.now().year.toString()})');
    batch.rawInsert(
        'INSERT INTO FormatPiece(Format , Piece , Current_index,Year) VALUES("XXXX/YYYY"  , "RF" , 0 , ${DateTime.now().year.toString()})');
    batch.rawInsert(
        'INSERT INTO FormatPiece(Format , Piece , Current_index,Year) VALUES("XXXX/YYYY"  , "AC" , 0 , ${DateTime.now().year.toString()})');
    batch.rawInsert(
        'INSERT INTO FormatPiece(Format , Piece , Current_index,Year) VALUES("XXXX/YYYY"  , "TR" , 0 , ${DateTime.now().year.toString()})');

    batch.rawInsert(
        "INSERT INTO MyParams VALUES(1,2,0,0,1,1,'80',1,'9:01',0,0,'United States of America','USD' , 'demo' , 0 , 'mensuel' , 1)");

    await batch.commit();
  }



}
