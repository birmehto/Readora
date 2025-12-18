import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../features/home/controllers/home_controller.dart';

class ShareIntentService extends GetxService {
  static const _channel = MethodChannel('app.channel.shared.data');

  Future<ShareIntentService> init() async {
    // Handle incoming intents when app is running
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'handleSharedUrl') {
        final String? url = call.arguments as String?;
        if (url != null && url.isNotEmpty) {
          _openArticle(url);
        }
      }
    });

    // Check for initial intent when app starts
    try {
      final String? initialUrl = await _channel.invokeMethod('getInitialUrl');
      if (initialUrl != null && initialUrl.isNotEmpty) {
        _openArticle(initialUrl);
      }
    } catch (e) {
      // Ignored
    }

    return this;
  }

  void _openArticle(String url) {
    if (Get.isRegistered<HomeController>()) {
      final homeController = Get.find<HomeController>();
      homeController.urlController.text = url;
      homeController.onUrlChanged(url);
      homeController.openArticle();
    } else {
      // If controller not ready/registered (e.g. app start), wait or navigate
      // Since this service inits before runApp generally, or in parallel,
      // safer to wait for UI to be ready via Get.

      // Post-frame callback or simple polling/routing.
      // Easiest is to navigate to Home with args if using GetX routing,
      // but HomeController openArticle logic is specific.

      // Let's assume Home is the first page.
      // We can use a slight delay or Get.offAllNamed if we want to ensure we are on Home.

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        // Wait for Home to be mounted
        // Actually, if we are at app start, Home might NOT be ready yet.
        // A simple delay loop or listener could work, but let's try pushing the route logic.

        // Assuming App is standard GetMaterialApp

        // Simple retry logic
        if (Get.isRegistered<HomeController>()) {
          final ctrl = Get.find<HomeController>();
          ctrl.urlController.text = url;
          ctrl.onUrlChanged(url);
          ctrl.openArticle();
        } else {
          // If not registered, maybe we are too early.
          // We can store it in a static variable handled by HomeController onInit,
          // or just retry.

          // Retry once after 1s
          await Future.delayed(const Duration(seconds: 1));
          if (Get.isRegistered<HomeController>()) {
            final ctrl = Get.find<HomeController>();
            ctrl.urlController.text = url;
            ctrl.onUrlChanged(url);
            ctrl.openArticle();
          }
        }
      });
    }
  }
}
