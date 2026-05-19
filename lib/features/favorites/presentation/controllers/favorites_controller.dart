import 'package:get/get.dart';

import '../../domain/entities/favorite_article.dart';
import '../../domain/usecases/get_favorites_usecase.dart';
import '../../domain/usecases/remove_favorite_usecase.dart';

class FavoritesController extends GetxController {
  FavoritesController(this._getFavoritesUseCase, this._removeFavoriteUseCase);
  final GetFavoritesUseCase _getFavoritesUseCase;
  final RemoveFavoriteUseCase _removeFavoriteUseCase;

  final favorites = <FavoriteArticle>[].obs;
  final searchQuery = ''.obs;

  List<FavoriteArticle> get filteredFavorites => favorites
      .where(
        (item) =>
            item.title.toLowerCase().contains(
              searchQuery.value.toLowerCase(),
            ) ||
            (item.author?.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ) ??
                false) ||
            (item.domain?.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ) ??
                false),
      )
      .toList();

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final list = await _getFavoritesUseCase.execute();
    favorites.value = list;
  }

  Future<void> removeFavorite(String url) async {
    await _removeFavoriteUseCase.execute(url);
    favorites.removeWhere((item) => item.url == url);
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }
}
