import '../repositories/favorites_repository.dart';

class RemoveFavoriteUseCase {
  RemoveFavoriteUseCase(this._repository);
  final FavoritesRepository _repository;

  Future<void> execute(String url) {
    return _repository.removeFavorite(url);
  }
}
