import '../../domain/entities/favorite_article.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_local_datasource.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl(this._localDataSource);
  final FavoritesLocalDataSource _localDataSource;

  @override
  Future<List<FavoriteArticle>> getFavorites() {
    return _localDataSource.getFavorites();
  }

  @override
  Future<void> removeFavorite(String url) {
    return _localDataSource.removeFavorite(url);
  }
}
