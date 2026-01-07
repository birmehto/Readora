import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/services/storage_service.dart';

class SettingsController extends GetxController {
  final StorageService _storage = Get.find();

  final isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = _storage.isDarkMode;
  }

  void toggleTheme(bool value) {
    isDarkMode.value = value;
    _storage.isDarkMode = value;
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> sendFeedback() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'birmehto@gmail.com',
      queryParameters: {'subject': 'Readora Feedback'},
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    }
  }
}
