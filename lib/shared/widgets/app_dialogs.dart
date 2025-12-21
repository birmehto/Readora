import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDialogs {
  /// Shows a standard Material 3 confirmation dialog
  static Future<void> showConfirmDialog({
    required String title,
    required String message,
    required String confirmText,
    required VoidCallback onConfirm,
    String cancelText = 'Cancel',
    bool isDestructive = false,
  }) {
    return Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text(cancelText)),
          FilledButton(
            onPressed: onConfirm,
            style: isDestructive
                ? FilledButton.styleFrom(
                    backgroundColor: Get.theme.colorScheme.error,
                    foregroundColor: Get.theme.colorScheme.onError,
                  )
                : null,
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  /// Shows a simple informational dialog
  static Future<void> showInfoDialog({
    required String title,
    required String message,
    String buttonText = 'OK',
  }) {
    return Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text(buttonText)),
        ],
      ),
    );
  }
}
