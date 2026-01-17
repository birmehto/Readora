import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/app/app_log.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/clipboard_service.dart';
import '../../../core/utils/url_validator.dart';
import '../../../shared/widgets/app_snackbar.dart';

class HomeController extends GetxController {
  HomeController(this._clipboardService);

  final ClipboardService _clipboardService;

  final urlController = TextEditingController();

  final urlText = ''.obs;
  final errorMessage = ''.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    urlController.addListener(_onTextChanged);
  }

  @override
  void onClose() {
    urlController.dispose();
    super.onClose();
  }

  bool get canOpenArticle =>
      urlText.isNotEmpty && errorMessage.isEmpty && !isLoading.value;

  // ─────────────────────────────────────────────

  void _onTextChanged() {
    final text = urlController.text;
    urlText.value = text;
    _validate(text);
  }

  void _validate(String value) {
    errorMessage.value = '';

    if (value.isEmpty) return;
    if (!UrlValidator.isValidUrl(value)) {
      errorMessage.value = 'Please enter a valid URL';
    } else if (!UrlValidator.isMediumUrl(value)) {
      errorMessage.value = 'Please enter a Medium article URL';
    } else if (!UrlValidator.isMediumArticle(value)) {
      errorMessage.value = 'Please enter a valid Medium article URL';
    }
  }

  // ─────────────────────────────────────────────

  Future<void> pasteFromClipboard() async {
    try {
      final text = await _clipboardService.getFromClipboard();
      if (text?.isNotEmpty ?? false) {
        urlController.text = text!;
      }
    } catch (e) {
      AppSnackbar.show(
        Get.context!,
        title: 'Error',
        message: 'Failed to paste from clipboard',
        type: SnackbarType.error,
      );
    }
  }

  void clearUrl() {
    urlController.clear();
    errorMessage.value = '';
  }

  // ─────────────────────────────────────────────

  Future<void> openArticle() async {
    if (!canOpenArticle) return;

    final cleaned = UrlValidator.cleanTextiseUrl(urlController.text);
    if (cleaned == null) {
      errorMessage.value = 'Invalid URL format';
      return;
    }

    isLoading.value = true;
    try {
      final freediumUrl = UrlValidator.convertToFreediumUrl(cleaned);
      if (freediumUrl == null) {
        errorMessage.value = 'Failed to process the URL';
        return;
      }

      appLog('App Url => $cleaned');

      await Get.toNamed(
        AppRoutes.article,
        arguments: {'url': freediumUrl, 'originalUrl': cleaned},
      );
    } catch (e) {
      errorMessage.value = 'Failed to open article';
    } finally {
      isLoading.value = false;
    }
  }
}
