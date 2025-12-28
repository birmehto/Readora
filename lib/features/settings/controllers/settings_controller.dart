// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/services/storage_service.dart';

class SettingsController extends GetxController {
  final StorageService _storage = Get.find();

  final isDarkMode = false.obs;
  final fontSize = 16.0.obs;
  final fontFamily = 'Inter'.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = _storage.isDarkMode;
    fontSize.value = _storage.fontSize;
    fontFamily.value = _storage.fontFamily;
  }

  void toggleTheme(bool value) {
    isDarkMode.value = value;
    _storage.isDarkMode = value;
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }

  void updateFontSize(double value) {
    fontSize.value = value;
    _storage.fontSize = value;
  }

  void updateFontFamily(String value) {
    fontFamily.value = value;
    _storage.fontFamily = value;
  }

  Future<void> openPlayStore() async {
    // Replace with your actual app package name
    const packageName = 'com.example.artical';
    final playStoreUrl = Uri.parse(
      'https://play.google.com/store/apps/details?id=$packageName',
    );

    if (await canLaunchUrl(playStoreUrl)) {
      await launchUrl(playStoreUrl, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> shareApp() async {
    // Replace with your actual app package name
    const packageName = 'com.example.artical';
    const appName = 'Artical';
    const shareText =
        'Check out $appName - A great app for reading articles!\n'
        'https://play.google.com/store/apps/details?id=$packageName';

    await Share.share(shareText);
  }

  Future<void> openDonationLink() async {
    // Replace with your actual donation link (e.g., buymeacoffee, ko-fi, patreon, etc.)
    final donationUrl = Uri.parse('https://buymeacoffee.com/birmehto');

    if (await canLaunchUrl(donationUrl)) {
      await launchUrl(donationUrl, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> openPrivacyPolicy() async {
    // Replace with your actual Privacy Policy URL
    final url = Uri.parse(
      'https://www.freeprivacypolicy.com/live/your-privacy-policy-url',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> openTermsOfService() async {
    // Replace with your actual Terms of Service URL
    final url = Uri.parse('https://www.termsfeed.com/live/your-terms-url');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> sendFeedback() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@example.com',
      query: 'subject=Readora%20Feedback',
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    }
  }

  Future<void> rateApp() async {
    await openPlayStore();
  }
}
