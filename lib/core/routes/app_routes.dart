import 'package:get/get.dart';

import '../../features/articles/bindings/article_binding.dart';
import '../../features/articles/views/article_page.dart';
import '../../features/history/bindings/history_binding.dart';
import '../../features/history/views/history_page.dart';
import '../../features/home/bindings/home_binding.dart';
import '../../features/home/views/home_page.dart';
import '../../features/settings/bindings/settings_binding.dart';
import '../../features/settings/views/settings_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String article = '/article';
  static const String history = '/history';
  static const String settings = '/settings';
}

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.article,
      page: () => const ArticlePage(),
      binding: ArticleBinding(),
    ),
    GetPage(
      name: AppRoutes.history,
      page: () => const HistoryPage(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsPage(),
      binding: SettingsBinding(),
    ),
  ];
}
