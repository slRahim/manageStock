import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:line_icons/line_icons.dart';
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
const String drawerItemExitId = "drawerItemExitId";
const String drawerItemPurchaseId = "drawerItemPurchaseId";
const String drawerItemVenteId = "drawerItemVenteId";
const String drawerItemAchatId = "drawerItemAchatId";
const String drawerItemFamilleMarqueId = "drawerItemFamilleMarqueId";
const String drawerItemBackupId = 'drawerItemBackupId';

class HomeItem {
  String id;
  String title;
  String img;
  bool active;

  HomeItem({this.id, this.title, this.img, this.active});
}

HomeItem homeItemAccueil = new HomeItem(
    id: homeItemAccueilId,
    title: S.current.accueil,
    active: true);
HomeItem homeItemTableauDeBord = new HomeItem(
    id: homeItemTableauDeBordId,
    title: S.current.tableau_bord,
    active: true);
HomeItem homeItemArticles = new HomeItem(
    id: homeItemArticlesId,
    title: S.current.articles,
    active: true);
HomeItem homeItemClients = new HomeItem(
    id: homeItemClientsId,
    title: S.current.client,
    active: true);
HomeItem homeItemDevis = new HomeItem(
    id: homeItemDevisId,
    title: S.current.devis,
    active: true);
HomeItem homeItemCommandeClient = new HomeItem(
    id: homeItemCommandeClientId,
    title: S.current.commande_client,
    active: true);
HomeItem homeItemBonDeLivraison = new HomeItem(
    id: homeItemBonDeLivraisonId,
    title: S.current.bon_livraison,
    active: true);
HomeItem homeItemFactureDeVente = new HomeItem(
    id: homeItemFactureDeVenteId,
    title: S.current.facture_vente,
    active: true);
HomeItem homeItemFournisseurs = new HomeItem(
    id: homeItemFournisseursId,
    title: S.current.fournisseur,
    active: true);
HomeItem homeItemBonDeReception = new HomeItem(
    id: homeItemBonDeReceptionId,
    title: S.current.bon_reception,
    active: true);
HomeItem homeItemFactureDachat = new HomeItem(
    id: homeItemFactureDachatId,
    title: S.current.facture_achat,
    active: true);
HomeItem homeItemTresorerie = new HomeItem(
    id: homeItemTresorerieId,
    title: S.current.tresories,
    active: true);
HomeItem homeItemRapports = new HomeItem(
    id: homeItemRapportsId,
    title: S.current.rapports,
    active: true);
HomeItem homeItemParametres = new HomeItem(
    id: homeItemParametresId,
    title: S.current.settings,
    active: true);
HomeItem drawerItemRetourClient = new HomeItem(
    id: drawerItemRetourClientId,
    title: S.current.retour_client,
    active: true);
HomeItem drawerItemRetourFournisseur = new HomeItem(
    id: drawerItemRetourFournisseurId,
    title: S.current.retour_fournisseur,
    active: true);
HomeItem drawerItemAvoirClient = new HomeItem(
    id: drawerItemAvoirClientId,
    title: S.current.avoir_client,
    active: true);
HomeItem drawerItemAvoirFournisseur = new HomeItem(
    id: drawerItemAvoirFournisseurId,
    title: S.current.avoir_fournisseur,
    active: true);
HomeItem drawerItemBonDeCommande = new HomeItem(
    id: drawerItemBonDeCommandeId,
    title: S.current.bon_commande,
    active: true);
HomeItem drawerItemExit = new HomeItem(
    id: drawerItemExitId,
    title: S.current.quitter,
    active: true);
HomeItem drawerItemPurchase = new HomeItem(
    id: drawerItemPurchaseId,
    title: S.current.abonnement,
    active: true);
HomeItem drawerItemVente = new HomeItem(
    id: drawerItemVenteId,
    title: S.current.vente,
    active: true);
HomeItem drawerItemAchat = new HomeItem(
    id: drawerItemAchatId,
    title: S.current.achat,
    active: true);
HomeItem drawerItemFamilleMarque = new HomeItem(
    id: drawerItemFamilleMarqueId,
    title: S.current.famille_marque,
    active: true);
HomeItem drawerItemBackup = new HomeItem(
    id: drawerItemBackupId,
    title: S.current.param_backup,
    active: true);

Widget iconsSet(String itemId, double iconSize) {
  switch (itemId) {
    case homeItemParametresId:
      return Icon(
        LineIcons.cog,
        size: iconSize,
        color: Colors.white,
      );
      break;

    case homeItemRapportsId:
      return Icon(
        LineIcons.excelFile,
        size: iconSize,
        color: Colors.white,
      );
      break;

    case homeItemTresorerieId:
      return Icon(
        LineIcons.cashRegister,
        size: iconSize,
        color: Colors.white,
      );
      break;

    case homeItemFactureDachatId:
      return Icon(
        LineIcons.shoppingCart,
        size: iconSize,
        color: Colors.white,
      );
      break;

    case homeItemBonDeReceptionId:
      return Icon(
        LineIcons.fileInvoiceWithUsDollar,
        size: iconSize,
        color: Colors.white,
      );
      break;

    case homeItemTableauDeBordId:
      return Icon(
        LineIcons.barChartAlt,
        size: iconSize,
        color: Colors.white,
      );
      break;

    case homeItemAccueilId:
      return Icon(
        LineIcons.home,
        size: iconSize,
        color: Colors.white,
      );
      break;

    case homeItemArticlesId:
      return Icon(
        LineIcons.list,
        size: iconSize,
        color: Colors.white,
      );
      break;

    case homeItemClientsId:
      return Icon(
        LineIcons.users,
        size: iconSize,
        color: Colors.white,
      );
      break;

    case homeItemDevisId:
      return Icon(
        LineIcons.calculator,
        size: iconSize,
        color: Colors.white,
      );
      break;

    case homeItemCommandeClientId:
      return Icon(
        AntDesign.solution1,
        size: iconSize,
        color: Colors.white,
      );
      break;

    case homeItemBonDeLivraisonId:
      return Icon(
        Icons.assignment_outlined,
        size: iconSize,
        color: Colors.white,
      );
      break;

    case homeItemFactureDeVenteId:
      return Icon(
        LineIcons.fileInvoice,
        size: iconSize,
        color: Colors.white,
      );
      break;

    case homeItemFournisseursId:
      return Icon(
        Foundation.torso_business,
        size: iconSize,
        color: Colors.white,
      );
      break;

    case drawerItemBonDeCommandeId:
      return Icon(
        AntDesign.solution1,
        size: iconSize,
        color: Colors.white,
      );
      break;

    case drawerItemRetourClientId:
      return Icon(
        Icons.assignment_return_outlined,
        size: iconSize,
        color: Colors.white,
      );
      break;

    case drawerItemRetourFournisseurId:
      return Icon(
        Icons.assignment_return_outlined,
        size: iconSize,
        color: Colors.white,
      );
      break;

    case drawerItemAvoirClientId:
      return Icon(
        Icons.assignment_returned_outlined,
        size: iconSize,
        color: Colors.white,
      );
      break;

    case drawerItemAvoirFournisseurId:
      return Icon(
        Icons.assignment_returned_outlined,
        size: iconSize,
        color: Colors.white,
      );
      break;

    case drawerItemExitId:
      return Icon(
        LineIcons.doorOpen,
        size: iconSize,
        color: Colors.red,
      );
      break;

    case drawerItemPurchaseId:
      return Icon(
        Icons.star_purple500_outlined,
        size: 30,
        color: Colors.yellow[700],
      );

    case drawerItemVenteId:
      return Icon(
        MdiIcons.basketUnfill,
        size: iconSize,
        color: Colors.white,
      );
      break;

    case drawerItemAchatId:
      return Icon(
        MdiIcons.basketFill,
        size: iconSize,
        color: Colors.white,
      );
      break;

    case drawerItemFamilleMarqueId:
      return Icon(
        Icons.category,
        size: iconSize,
        color: Colors.white,
      );
      break;

    case drawerItemBackupId:
      return Icon(
        Icons.backup_outlined,
        size: iconSize,
        color: Colors.white,
      );
      break;

    default:
      return Icon(
        Icons.assignment,
        size: iconSize,
        color: Colors.white,
      );
      break;
  }
}

dynamic colorSet(String itemId) {
  switch (itemId) {
    case homeItemRapportsId:
      return Colors.yellow[900];
      break;

    case homeItemTresorerieId:
      return Colors.green[700];
      break;

    case homeItemFactureDachatId:
      return Colors.red[700];
      break;

    case homeItemBonDeReceptionId:
      return Colors.pink[700];
      break;

    case homeItemTableauDeBordId:
      return Colors.orange[900];
      break;

    case homeItemArticlesId:
      return Colors.teal[700];
      break;

    case homeItemClientsId:
      return Colors.blue[800];
      break;

    case homeItemDevisId:
      return Colors.blueGrey[700];
      break;

    case homeItemCommandeClientId:
      return Colors.indigo[700];
      break;

    case homeItemBonDeLivraisonId:
      return Colors.lightGreen[800];
      break;

    case homeItemFactureDeVenteId:
      return Colors.blue[900];
      break;

    case homeItemFournisseursId:
      return Colors.blueGrey[900];
      break;
  }
}
