import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../shared/widgets/app_snackbar.dart';

class ClipboardService extends GetxService {
  static ClipboardService get to => Get.find();

  /// Copy text to clipboard
  Future<void> copyToClipboard(String text) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
    } catch (e) {
      AppSnackbar.show(
        Get.context!,
        title: 'Error',
        message: 'Failed to copy to clipboard: $e',
        type: SnackbarType.error,
      );
    }
  }

  /// Get text from clipboard
  Future<String?> getFromClipboard() async {
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      return clipboardData?.text;
    } catch (e) {
      return null;
    }
  }

  /// Check if clipboard has text
  Future<bool> hasText() async {
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      return clipboardData?.text?.isNotEmpty ?? false;
    } catch (e) {
      return false;
    }
  }
}
