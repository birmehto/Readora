import '../entities/favorite_article.dart';
import '../repositories/favorites_repository.dart';

class GetFavoritesUseCase {
  GetFavoritesUseCase(this._repository);
  final FavoritesRepository _repository;

  Future<List<FavoriteArticle>> execute() {
    return _repository.getFavorites();
  }
}
