
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SliverListDataSource extends PagedDataSource<int, Object> {

  var filterMap;
  final String listType;

  SliverListDataSource(this.listType, this.filterMap) : super(0);


  static const _pageSize = 12;
  Object _activeCallbackIdentity;

  QueryCtr _queryCtr = QueryCtr();

  QueryCtr get queryCtr => _queryCtr;
  String _searchTerm;

  @override
  void fetchItems(int pageKey) {
    final callbackIdentity = Object();
    _activeCallbackIdentity = callbackIdentity;

    getList(pageKey, _pageSize, searchTerm: _searchTerm, filters: filterMap)
        .then((newItems) {
      if (callbackIdentity == _activeCallbackIdentity) {
        final hasFinished = newItems.length < _pageSize;
        final nextPageKey = hasFinished ? null : pageKey + newItems.length;
        notifyNewPage(newItems, nextPageKey);
      }
    }).catchError((error) {
      if (callbackIdentity == _activeCallbackIdentity) {
        notifyError(error);
      }
    });
  }

  Future<List<Object>> getList(int offset, int limit, {String searchTerm, Map<String, dynamic> filters}){
    switch (listType){
      case ItemsListTypes.articlesList:
        return _queryCtr.getAllArticles(offset : offset ,limit: _pageSize, searchTerm: _searchTerm, filters: filterMap);
        break;
      case ItemsListTypes.journalList:
        return _queryCtr.getJournauxByTier(offset : offset ,limit: _pageSize, searchTerm: _searchTerm, filters: filterMap);
        break;
      case ItemsListTypes.clientsList:
        return _queryCtr.getAllTiers(offset: offset, limit:_pageSize, searchTerm: _searchTerm, filters: filterMap);
        break;
      case ItemsListTypes.fournisseursList:
        return _queryCtr.getAllTiers(offset: offset, limit:_pageSize, searchTerm: _searchTerm, filters: filterMap);
        break;
      case ItemsListTypes.pieceList:
        return _queryCtr.getAllPieces(offset, _pageSize, searchTerm: _searchTerm, filters: filterMap);
        break;
      case ItemsListTypes.tresorieList:
        return _queryCtr.getAllTresories(offset, _pageSize, searchTerm: _searchTerm, filters: filterMap);
        break;
      case ItemsListTypes.familleArticleList:
        return _queryCtr.getArticleFamilles(offset, _pageSize, searchTerm: _searchTerm);
        break;
      case ItemsListTypes.marqueArticleList:
        return _queryCtr.getArticleMarques(offset, _pageSize, searchTerm: _searchTerm);
        break;
      case ItemsListTypes.tvaArticleList:
        return _queryCtr.getArticleTva(offset, _pageSize, searchTerm: _searchTerm);
        break;
      case ItemsListTypes.familleTiersList:
        return _queryCtr.getTiersFamille(offset, _pageSize, searchTerm: _searchTerm);
        break;
      case ItemsListTypes.chargeList:
        return _queryCtr.getChargeTresorie(offset, _pageSize, searchTerm: _searchTerm);
        break;
      case ItemsListTypes.caisseList:
        return _queryCtr.getCaisseList(offset, _pageSize, searchTerm: _searchTerm);
        break;
      default:
        return null;
    }
  }

  void updateSearchAndFilters(String searchTerm, Map<String, dynamic> _filterMap) {
    _searchTerm = searchTerm;
    filterMap = _filterMap;
    refresh();
  }

  void updateSearchTerm(String searchTerm) {
    _searchTerm = searchTerm;
    refresh();
  }

  void updateFilters(Map<String, dynamic> _filterMap) {
    filterMap = _filterMap;
    refresh();
  }

  @override
  void dispose() {
    _activeCallbackIdentity = null;
    super.dispose();
  }
}
