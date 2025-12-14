import 'package:get/get.dart';
import '../../features/article/view/home_view.dart';
import '../../features/article/view/article_view.dart';
import '../../features/settings/view/settings_view.dart';
import '../../features/history/view/history_view.dart';

class AppRoutes {
  static const String home = '/';
  static const String article = '/article';
  static const String articleWithUrl = '/article/:url';
  static const String settings = '/settings';
  static const String history = '/history';

  static List<GetPage> routes = [
    GetPage(
      name: home,
      page: () => const HomeView(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: article,
      page: () => const ArticleView(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: articleWithUrl,
      page: () => const ArticleView(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: settings,
      page: () => const SettingsView(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: history,
      page: () => const HistoryView(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}
