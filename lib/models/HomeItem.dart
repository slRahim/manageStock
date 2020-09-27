
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gestmob/generated/l10n.dart';

const String homeItemAccueilId = "homeItemAccueilId";
const String homeItemTableauDeBordId = "homeItemTableauDeBordId";
const String homeItemArticlesId = "homeItemArticlesId";
const String homeItemClientsId = "homeItemClientsId";
const String homeItemDevisId = "homeItemDevisId";
const String homeItemCommandeClientId = "homeItemCommandeClientId";
const String homeItemBonDeLivraisonId = "homeItemBonDeLivraisonId";
const String homeItemFactureDeVenteId = "homeItemFactureDeVenteId";
const String homeItemFournisseursId = "homeItemFournisseursId";
const String homeItemBonDeReceptionId = "homeItemBonDeReceptionId";
const String homeItemFactureDachatId = "homeItemFactureDachatId";
const String homeItemTresorerieId = "homeItemTresorerieId";
const String homeItemRapportsId = "homeItemRapportsId";
const String homeItemParametresId = "homeItemParametresId";
const String drawerItemHelpId = "drawerItemHelpId";
const String drawerItemExitId = "drawerItemExitId";

class HomeItem {
  String id;
  String title;
  String img;
  bool active;
  HomeItem({this.id, this.title, this.img,this.active});
}



HomeItem homeItemAccueil = new HomeItem(
    id: homeItemAccueilId,
    title: "Accueil",
    img: "assets/dashboard.png",
    active: true);

HomeItem homeItemTableauDeBord = new HomeItem(
    id: homeItemTableauDeBordId,
    title: "Tableau de bord",
    img: "assets/dashboard.png",
    active: true);

HomeItem homeItemArticles = new HomeItem(
    id: homeItemArticlesId,
    title: "Articles",
    img: "assets/article.png",
    active: true
);
HomeItem homeItemClients = new HomeItem(
    id: homeItemClientsId,
    title: "Clients",
    img: "assets/client.png",
    active: true
);
HomeItem homeItemDevis = new HomeItem(
    id: homeItemDevisId,
    title: "Devis",
    img: "assets/devis.png",
    active: true
);
HomeItem homeItemCommandeClient = new HomeItem(
    id: homeItemCommandeClientId,
    title: "Commande Client",
    img: "assets/commandeClient.png",
    active: true
);
HomeItem homeItemBonDeLivraison = new HomeItem(
    id: homeItemBonDeLivraisonId,
    title: "Bon de Livraison",
    img: "assets/bonLivraison.png",
    active: true
);
HomeItem homeItemFactureDeVente = new HomeItem(
    id: homeItemFactureDeVenteId,
    title: "Facture de Vente",
    img: "assets/invoice.png",
    active: true
);
HomeItem homeItemFournisseurs = new HomeItem(
    id: homeItemFournisseursId,
    title: "Fournisseurs",
    img: "assets/fournisseurs.png",
    active: true
);
HomeItem homeItemBonDeReception = new HomeItem(
    id: homeItemBonDeReceptionId,
    title: "Bon de Reception",
    img: "assets/BonReception.png",
    active: true
);
HomeItem homeItemFactureDachat = new HomeItem(
    id: homeItemFactureDachatId,
    title: "Facture d'achat",
    img: "assets/factureAchat.png",
    active: true
);

HomeItem homeItemTresorerie = new HomeItem(
    id: homeItemTresorerieId,
    title: "Trésorerie",
    img: "assets/Tresorerie.png",
    active: true
);

HomeItem homeItemRapports = new HomeItem(
    id: homeItemRapportsId,
    title: "Rapports",
    img: "assets/rapport.png",
    active: true
);


HomeItem homeItemParametres = new HomeItem(
    id: homeItemParametresId,
    title: "Paramètres",
    img: "assets/setting.png",
    active: true
);

HomeItem drawerItemHelp = new HomeItem(
    id: drawerItemHelpId,
    title: S.current.aide,
    img: "assets/setting.png",
    active: true
);

HomeItem drawerItemExit = new HomeItem(
    id: drawerItemExitId,
    title: S.current.quitter,
    img: "assets/setting.png",
    active: true
);



Widget iconsSet(String itemId, double iconSize){
  switch (itemId) {
    case homeItemParametresId:
      return Icon(Icons.settings,size: iconSize,color: Colors.white,);
      break;

    case homeItemRapportsId:
      return Icon(Icons.library_books,size: iconSize,color: Colors.white,);
      break;

    case homeItemTresorerieId:
      return Icon(Icons.monetization_on,size: iconSize,color: Colors.white,);
      break;

    case homeItemFactureDachatId:
      return Icon(Icons.shopping_cart,size: iconSize,color: Colors.white,);
      break;

    case homeItemBonDeReceptionId:
      return Icon(Feather.file_minus,size: iconSize,color: Colors.white,);
      break;

    case homeItemTableauDeBordId:
      return Icon(Icons.developer_board,size: iconSize,color: Colors.white,);
      break;

      case homeItemAccueilId:
      return Icon(Icons.developer_board,size: iconSize,color: Colors.white,);
      break;

    case homeItemArticlesId:
      return Icon(Icons.list,size: iconSize,color: Colors.white,);
      break;

    case homeItemClientsId:
      return Icon(Icons.people,size: iconSize,color: Colors.white,);
      break;

    case homeItemDevisId:
      return Icon(AntDesign.calculator,size: iconSize,color: Colors.white,);
      break;

    case homeItemCommandeClientId:
      return Icon(AntDesign.solution1,size: iconSize,color: Colors.white,);
      break;

    case homeItemBonDeLivraisonId:
      return Icon(Icons.assignment,size: iconSize,color: Colors.white,);
      break;

    case homeItemFactureDeVenteId:
      return Icon(AntDesign.filetext1,size: iconSize,color: Colors.white,);
      break;

    case homeItemFournisseursId:
      return Icon(Foundation.torso_business,size: iconSize,color: Colors.white,);
      break;

    case drawerItemHelpId:
      return Icon(Icons.help,size: iconSize,color: Colors.white,);
      break;

    case drawerItemExitId:
      return Icon(Icons.exit_to_app,size: iconSize,color: Colors.red,);
      break;

    default:
      return Icon(Icons.assignment,size: iconSize,color: Colors.white,);
      break;
  }
}


dynamic colorSet(String itemId){
  switch (itemId) {
    case homeItemParametresId:
      return Color.fromRGBO(142, 68, 173,1.0);
      break;

    case homeItemRapportsId:
      return Color.fromRGBO(241, 196, 15,1.0);
      break;

    case homeItemTresorerieId:
      return Color.fromRGBO(26, 188, 156,1.0);
      break;

    case homeItemFactureDachatId:
      return Color.fromRGBO(231, 76, 60,1.0);
      break;

    case homeItemBonDeReceptionId:
      return Color.fromRGBO(243, 156, 18,1.0);
      break;

    case homeItemTableauDeBordId:
      return Color.fromRGBO(230, 126, 34,1.0);
      break;

    case homeItemAccueilId:
      return Color.fromRGBO(211, 84, 0,1.0);
      break;

    case homeItemArticlesId:
      return Color.fromRGBO(41, 128, 185,1.0);
      break;

    case homeItemClientsId:
      return Color.fromRGBO(22, 160, 133,1.0);
      break;

    case homeItemDevisId:
      return Color.fromRGBO(149, 165, 166,1.0);
      break;

    case homeItemCommandeClientId:
      return Color.fromRGBO(127, 140, 141,1.0);
      break;

    case homeItemBonDeLivraisonId:
      return Color.fromRGBO(46, 204, 113,1.0);
      break;

    case homeItemFactureDeVenteId:
      return Color.fromRGBO(52, 152, 219,1.0);
      break;

    case homeItemFournisseursId:
      return Color.fromRGBO(44, 62, 80,1.0);
      break;

    default:
      return Color.fromRGBO(39, 174, 96,1.0);
      break;
  }
}

