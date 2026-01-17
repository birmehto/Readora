import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../features/home/controllers/home_controller.dart';
import '../utils/url_validator.dart';

class ShareIntentService extends GetxService {
  static const _channel = MethodChannel('app.channel.shared.data');

  Future<ShareIntentService> init() async {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'handleSharedUrl') {
        _handleSharedText(call.arguments as String?);
      }
    });

    try {
      _handleSharedText(await _channel.invokeMethod<String>('getInitialUrl'));
    } catch (_) {
      // ignore
    }

    return this;
  }

  // ─────────────────────────────────────────────

  void _handleSharedText(String? text) {
    if (text == null || text.isEmpty) return;

    final url = UrlValidator.cleanTextiseUrl(
      UrlValidator.extractUrlFromText(text) ?? '',
    );

    if (url == null || url.isEmpty) return;
    _dispatchToHome(url);
  }

  void _dispatchToHome(String url) {
    if (Get.isRegistered<HomeController>()) {
      _openWithController(Get.find<HomeController>(), url);
      return;
    }

    // Retry once after frame + short delay (app cold start case)
    Future.microtask(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      if (Get.isRegistered<HomeController>()) {
        _openWithController(Get.find<HomeController>(), url);
      }
    });
  }

  void _openWithController(HomeController controller, String url) {
    controller.urlController.text = url;
    controller.openArticle();
  }
}
