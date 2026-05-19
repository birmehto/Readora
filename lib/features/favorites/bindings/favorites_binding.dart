import 'package:get/get.dart';

import '../../../core/services/storage_service.dart';
import '../data/datasources/favorites_local_datasource.dart';
import '../data/repositories/favorites_repository_impl.dart';
import '../domain/repositories/favorites_repository.dart';
import '../domain/usecases/get_favorites_usecase.dart';
import '../domain/usecases/remove_favorite_usecase.dart';
import '../presentation/controllers/favorites_controller.dart';

class FavoritesBinding extends Bindings {
  @override
  void dependencies() {
    // Data Source
    Get.lazyPut<FavoritesLocalDataSource>(
      () => FavoritesLocalDataSourceImpl(Get.find<StorageService>()),
    );

    // Repository
    Get.lazyPut<FavoritesRepository>(
      () => FavoritesRepositoryImpl(Get.find<FavoritesLocalDataSource>()),
    );

    // Use Cases
    Get.lazyPut<GetFavoritesUseCase>(
      () => GetFavoritesUseCase(Get.find<FavoritesRepository>()),
    );
    Get.lazyPut<RemoveFavoriteUseCase>(
      () => RemoveFavoriteUseCase(Get.find<FavoritesRepository>()),
    );

    // Controller
    Get.lazyPut<FavoritesController>(
      () => FavoritesController(
        Get.find<GetFavoritesUseCase>(),
        Get.find<RemoveFavoriteUseCase>(),
      ),
    );
  }
}
