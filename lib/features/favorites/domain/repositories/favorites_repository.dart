import '../entities/favorite_article.dart';

abstract class FavoritesRepository {
  Future<List<FavoriteArticle>> getFavorites();
  Future<void> removeFavorite(String url);
}
