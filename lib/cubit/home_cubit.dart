import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:gestmob/models/HomeItem.dart';
import 'package:gestmob/ui/ArticlesFragment.dart';
import 'package:gestmob/ui/ClientFourFragment.dart';
import 'package:gestmob/ui/GridHomeFragment.dart';
import 'package:gestmob/ui/PiecesFragment.dart';
import 'package:gestmob/ui/TresorieFragment.dart';
import 'package:gestmob/ui/dashboard_fragment.dart';
import 'package:gestmob/ui/familleMarqueFragment.dart';
import 'package:gestmob/ui/purchase_page.dart';
import 'package:gestmob/ui/rapport_fragment.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  Future<void> getHomeData(String homeItemId) async {
    emit(new HomeLoading());

    switch (homeItemId) {
      case homeItemAccueilId:
        emit(new HomeLoaded(GridHomeWidget()));
        break;

      case homeItemTableauDeBordId:
        emit(new FragmentLoaded(Dashboard()));
        break;

      case homeItemArticlesId:
        emit(new FragmentLoaded(ArticlesFragment()));
        break;

      case homeItemClientsId:
        emit(new FragmentLoaded(ClientFourFragment(
          clientFourn: 0,
        )));
        break;

      case homeItemFournisseursId:
        emit(new FragmentLoaded(ClientFourFragment(
          clientFourn: 2,
        )));
        break;

      case homeItemDevisId:
        emit(new FragmentLoaded(
            new PiecesFragment(clientFourn: 0, peaceType: 'FP')));
        break;

      case homeItemCommandeClientId:
        emit(new FragmentLoaded(
            PiecesFragment(clientFourn: 0, peaceType: 'CC')));
        break;

      case homeItemBonDeLivraisonId:
        emit(new FragmentLoaded(
            PiecesFragment(clientFourn: 0, peaceType: 'BL')));
        break;

      case homeItemBonDeReceptionId:
        emit(new FragmentLoaded(
            PiecesFragment(clientFourn: 2, peaceType: 'BR')));
        break;

      case homeItemFactureDachatId:
        emit(new FragmentLoaded(
            PiecesFragment(clientFourn: 2, peaceType: 'FF')));
        break;

      case homeItemFactureDeVenteId:
        emit(new FragmentLoaded(
            PiecesFragment(clientFourn: 0, peaceType: 'FC')));
        break;

      case drawerItemAvoirClientId:
        emit(new FragmentLoaded(
            PiecesFragment(clientFourn: 0, peaceType: 'AC')));
        break;

      case drawerItemAvoirFournisseurId:
        emit(new FragmentLoaded(
            PiecesFragment(clientFourn: 2, peaceType: 'AF')));
        break;

      case drawerItemBonDeCommandeId:
        emit(new FragmentLoaded(
            PiecesFragment(clientFourn: 2, peaceType: 'BC')));
        break;

      case drawerItemRetourClientId:
        emit(new FragmentLoaded(
            PiecesFragment(clientFourn: 0, peaceType: 'RC')));
        break;

      case drawerItemRetourFournisseurId:
        emit(new FragmentLoaded(
            PiecesFragment(clientFourn: 2, peaceType: 'RF')));
        break;

      case homeItemRapportsId:
        emit(new FragmentLoaded(Rapport()));
        break;

      case homeItemTresorerieId:
        emit(new FragmentLoaded(TresorieFragment()));
        break;

      case drawerItemPurchaseId:
        emit(new FragmentLoaded(PurchasePage()));
        break;

      case drawerItemFamilleMarqueId:
        emit(new FragmentLoaded(FamilleMarqueFragment()));
        break;
    }
  }
}
