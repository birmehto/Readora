import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../features/history/controller/reading_history_controller.dart';
import '../../features/settings/controller/settings_controller.dart';
import '../network/network_info.dart';
import '../../features/article/controller/article_controller.dart';
import '../../features/article/services/freedium_api_service.dart';
import '../../features/theme/controller/theme_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // External
    Get.lazyPut(() => Dio());
    Get.lazyPut(() => Connectivity());

    // Core
    Get.lazyPut<NetworkInfo>(() => NetworkInfoImpl(Get.find()));

    // Services
    Get.lazyPut(() => FreediumApiService(Get.find()));

    // Controllers
    Get.lazyPut(() => ThemeController(), fenix: true);
    Get.lazyPut(() => ReadingHistoryController(), fenix: true);
    Get.lazyPut(() => SettingsController(), fenix: true);
    Get.lazyPut(
      () => ArticleController(apiService: Get.find(), networkInfo: Get.find()),
      fenix: true,
    );
  }
}
