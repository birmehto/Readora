import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../history/controller/reading_history_controller.dart';
import '../../theme/controller/theme_controller.dart';

class SettingsController extends GetxController {
  late final ThemeController themeController;
  late final ReadingHistoryController historyController;

  @override
  void onInit() {
    super.onInit();
    themeController = Get.find<ThemeController>();
    historyController = Get.find<ReadingHistoryController>();
  }

  void changeTheme(ThemeMode mode) {
    themeController.setThemeMode(mode);
  }

  void clearHistory() {
    historyController.clearHistory();
    Get.snackbar('Success', 'History cleared successfully');
  }

  void showAbout() {
    // This will be handled by the view
  }
}
