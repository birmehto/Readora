import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/app/app_log.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/clipboard_service.dart';
import '../../../core/utils/url_validator.dart';
import '../../../shared/widgets/app_snackbar.dart';

class HomeController extends GetxController {
  final ClipboardService _clipboardService = Get.find();

  final TextEditingController urlController = TextEditingController();
  final RxString urlText = ''.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    urlController.addListener(() {
      urlText.value = urlController.text;
    });
  }

  @override
  void onClose() {
    urlController.dispose();
    super.onClose();
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
      } else if (!UrlValidator.isMediumArticle(value)) {
        errorMessage.value = 'Please enter a valid Medium article URL';
      }
    }
  }

  Future<void> pasteFromClipboard() async {
    try {
      final clipboardText = await _clipboardService.getFromClipboard();
      if (clipboardText != null && clipboardText.isNotEmpty) {
        urlController.text = clipboardText;
        onUrlChanged(clipboardText);
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
