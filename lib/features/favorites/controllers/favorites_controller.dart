import 'package:get/get.dart';

import '../../../core/services/storage_service.dart';
import '../models/favorites_item.dart';

class FavoritesController extends GetxController {
  final StorageService _storage = Get.find();
  final favorites = <FavoriteItem>[].obs;
  final searchQuery = ''.obs;

  List<FavoriteItem> get filteredFavorites => favorites
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

  void loadFavorites() {
    final List<dynamic> rawList = _storage.favorites;
    favorites.value = rawList
        .map((e) => FavoriteItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> removeFavorite(String url) async {
    await _storage.removeFromFavorites(url);
    favorites.removeWhere((item) => item.url == url);
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

}
