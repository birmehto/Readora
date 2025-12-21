import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/app/app_log.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/clipboard_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/url_validator.dart';
import '../../../shared/widgets/app_snackbar.dart';
import '../../history/models/history_item.dart';

class HomeController extends GetxController {
  final ClipboardService _clipboardService = Get.find();
  final StorageService _storageService = Get.find();

  final TextEditingController urlController = TextEditingController();
  final RxString urlText = ''.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isLoading = false.obs;

  final RxList<HistoryItem> recentHistory = <HistoryItem>[].obs;
  final RxList<HistoryItem> favorites = <HistoryItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    urlController.addListener(() {
      urlText.value = urlController.text;
    });
    loadRecentHistory();
    loadFavorites();
    _autoCheckClipboard();
  }

  @override
  void onReady() {
    super.onReady();
    // Reload history and favorites when returning to this page
    loadRecentHistory();
    loadFavorites();
  }

  @override
  void onClose() {
    urlController.dispose();
    super.onClose();
  }

  void loadRecentHistory() {
    final rawList = _storageService.history;
    recentHistory.value = rawList
        .take(5) // Take only top 5 for home page
        .map((e) => HistoryItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  void loadFavorites() {
    final rawList = _storageService.favorites;
    favorites.value = rawList
        .map((e) => HistoryItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> _autoCheckClipboard() async {
    try {
      final clipboardText = await _clipboardService.getFromClipboard();
      if (clipboardText != null &&
          UrlValidator.isValidUrl(clipboardText) &&
          UrlValidator.isMediumUrl(clipboardText)) {
        AppSnackbar.show(
          Get.context!,
          title: 'Link Detected',
          message: 'We found a Medium link in your clipboard.',
          duration: const Duration(seconds: 4),
          mainButton: TextButton(
            onPressed: () {
              urlController.text = clipboardText;
              onUrlChanged(clipboardText);
            },
            child: const Text(
              'PASTE',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      // Ignore clipboard errors
    }
  }

  bool get canOpenArticle {
    return urlText.isNotEmpty && errorMessage.isEmpty && !isLoading.value;
  }

  void onUrlChanged(String value) {
    errorMessage.value = '';

    if (value.isNotEmpty) {
      if (!UrlValidator.isValidUrl(value)) {
        errorMessage.value = 'Please enter a valid URL';
      } else if (!UrlValidator.isMediumUrl(value)) {
        errorMessage.value = 'Please enter a Medium article URL';
      } /* else if (!UrlValidator.isMediumArticle(value)) {
        errorMessage.value = 'Please enter a valid Medium article URL';
      } */
    }
  }

  Future<void> pasteFromClipboard() async {
    try {
      final clipboardText = await _clipboardService.getFromClipboard();
      if (clipboardText != null && clipboardText.isNotEmpty) {
        urlController.text = clipboardText;
        onUrlChanged(clipboardText);
      } else {
        AppSnackbar.show(
          Get.context!,
          title: 'Info',
          message: 'Clipboard is empty or contains no text.',
        );
      }
    } catch (e) {
      AppSnackbar.show(
        Get.context!,
        title: 'Error',
        message: 'Failed to paste from clipboard: $e',
        type: SnackbarType.error,
      );
    }
  }

  void clearUrl() {
    urlController.clear();
    errorMessage.value = '';
  }

  void setExampleUrl(String url) {
    urlController.text = url;
    onUrlChanged(url);
  }

  void openHistoryItem(HistoryItem item) {
    final url = item.url;
    final freediumUrl = UrlValidator.convertToFreediumUrl(url) ?? url;
    Get.toNamed(
      AppRoutes.article,
      arguments: {'url': freediumUrl, 'originalUrl': url},
    );
  }

  Future<void> openArticle() async {
    if (!canOpenArticle) return;

    final url = urlController.text.trim();
    final cleanedUrl = UrlValidator.cleanUrl(url);

    if (cleanedUrl == null) {
      errorMessage.value = 'Invalid URL format';
      return;
    }

    isLoading.value = true;

    try {
      // Convert to Freedium URL
      final freediumUrl = UrlValidator.convertToFreediumUrl(cleanedUrl);

      appLog('App Url => $cleanedUrl');

      if (freediumUrl != null) {
        // Navigate to webview with the Freedium URL
        await Get.toNamed(
          AppRoutes.article,
          arguments: {'url': freediumUrl, 'originalUrl': cleanedUrl},
        );

        // Refresh history when finding back
        Future.delayed(const Duration(seconds: 1), loadRecentHistory);
      } else {
        errorMessage.value = 'Failed to process the URL';
      }
    } catch (e) {
      errorMessage.value = 'Failed to open article: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }
}
