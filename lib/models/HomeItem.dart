
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
const String drawerItemRetourClientId = "drawerItemRetourClientId";
const String drawerItemRetourFournisseurId = "drawerItemRetourFournisseurId";
const String drawerItemAvoirClientId = "drawerItemAvoirClientId";
const String drawerItemAvoirFournisseurId = "drawerItemAvoirFournisseurId";
const String drawerItemBonDeCommandeId = "drawerItemBonDeCommandeId";
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
    title: S.current.accueil,
    img: "assets/dashboard.png",
    active: true);

HomeItem homeItemTableauDeBord = new HomeItem(
    id: homeItemTableauDeBordId,
    title: S.current.tableau_bord,
    img: "assets/dashboard.png",
    active: true);

HomeItem homeItemArticles = new HomeItem(
    id: homeItemArticlesId,
    title: S.current.articles,
    img: "assets/article.png",
    active: true
);
HomeItem homeItemClients = new HomeItem(
    id: homeItemClientsId,
    title: S.current.client,
    img: "assets/client.png",
    active: true
);
HomeItem homeItemDevis = new HomeItem(
    id: homeItemDevisId,
    title: S.current.devis,
    img: "assets/devis.png",
    active: true
);
HomeItem homeItemCommandeClient = new HomeItem(
    id: homeItemCommandeClientId,
    title: S.current.commande_client,
    img: "assets/commandeClient.png",
    active: true
);
HomeItem homeItemBonDeLivraison = new HomeItem(
    id: homeItemBonDeLivraisonId,
    title: S.current.bon_livraison,
    img: "assets/bonLivraison.png",
    active: true
);
HomeItem homeItemFactureDeVente = new HomeItem(
    id: homeItemFactureDeVenteId,
    title: S.current.facture_vente,
    img: "assets/invoice.png",
    active: true
);
HomeItem homeItemFournisseurs = new HomeItem(
    id: homeItemFournisseursId,
    title: S.current.fournisseur,
    img: "assets/fournisseurs.png",
    active: true
);
HomeItem homeItemBonDeReception = new HomeItem(
    id: homeItemBonDeReceptionId,
    title: S.current.bon_reception,
    img: "assets/BonReception.png",
    active: true
);
HomeItem homeItemFactureDachat = new HomeItem(
    id: homeItemFactureDachatId,
    title: S.current.facture_achat,
    img: "assets/factureAchat.png",
    active: true
);

HomeItem homeItemTresorerie = new HomeItem(
    id: homeItemTresorerieId,
    title: S.current.tresories,
    img: "assets/Tresorerie.png",
    active: true
);

HomeItem homeItemRapports = new HomeItem(
    id: homeItemRapportsId,
    title: S.current.rapports,
    img: "assets/rapport.png",
    active: true
);


HomeItem homeItemParametres = new HomeItem(
    id: homeItemParametresId,
    title: S.current.settings,
    img: "assets/setting.png",
    active: true
);


HomeItem drawerItemRetourClient = new HomeItem(
    id: drawerItemRetourClientId,
    title:"Retour Client",
    img: "assets/setting.png",
    active: true
);

HomeItem drawerItemRetourFournisseur = new HomeItem(
    id: drawerItemRetourFournisseurId,
    title: "Retour Fournisseur",
    img: "assets/setting.png",
    active: true
);

HomeItem drawerItemAvoirClient = new HomeItem(
    id: drawerItemAvoirClientId,
    title: "Avoir Client",
    img: "assets/setting.png",
    active: true
);

HomeItem drawerItemAvoirFournisseur = new HomeItem(
    id: drawerItemAvoirFournisseurId,
    title: "Avoir Fournisseur",
    img: "assets/setting.png",
    active: true
);

HomeItem drawerItemBonDeCommande = new HomeItem(
    id: drawerItemBonDeCommandeId,
    title: "Bon de Commande",
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

    case drawerItemBonDeCommandeId:
      return Icon(AntDesign.solution1,size: iconSize,color: Colors.white,);
      break;

    case drawerItemRetourClientId:
      return Icon(Icons.assignment_return_outlined,size: iconSize,color: Colors.white,);
      break;

    case drawerItemRetourFournisseurId:
      return Icon(Icons.assignment_return_outlined,size: iconSize,color: Colors.white,);
      break;

    case drawerItemAvoirClientId:
      return Icon(Icons.assignment_returned_outlined,size: iconSize,color: Colors.white,);
      break;

    case drawerItemAvoirFournisseurId:
      return Icon(Icons.assignment_returned_outlined,size: iconSize,color: Colors.white,);
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

