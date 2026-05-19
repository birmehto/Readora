import '../../../../core/services/storage_service.dart';
import '../models/favorite_article_model.dart';

abstract class FavoritesLocalDataSource {
  Future<List<FavoriteArticleModel>> getFavorites();
  Future<void> removeFavorite(String url);
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  FavoritesLocalDataSourceImpl(this._storage);
  final StorageService _storage;

  @override
  Future<List<FavoriteArticleModel>> getFavorites() async {
    final List<dynamic> rawList = _storage.favorites;
    return rawList
        .map((e) => FavoriteArticleModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<void> removeFavorite(String url) async {
    await _storage.removeFromFavorites(url);
  }
}
