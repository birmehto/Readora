import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../../features/article/controller/article_controller.dart';

class DeepLinkService extends GetxService {
  static const platform = MethodChannel('app.channel.shared.data');

  StreamSubscription<String>? _linkSubscription;

  @override
  void onInit() {
    super.onInit();
    _initDeepLinkListener();
    _handleInitialLink();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    // Handle any pending deep links after all controllers are ready
    await _handleInitialLink();
  }

  @override
  void onClose() {
    _linkSubscription?.cancel();
    super.onClose();
  }

  void _initDeepLinkListener() {
    // Listen for incoming links when app is already running
    try {
      platform.setMethodCallHandler(_handleMethodCall);
    } catch (e) {
      print('Error setting up deep link listener: $e');
    }
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    if (call.method == 'handleSharedUrl') {
      final String? url = call.arguments as String?;
      if (url != null) {
        await _handleIncomingLink(url);
      }
    }
  }

  Future<void> _handleInitialLink() async {
    try {
      // Check if app was opened with a shared URL
      final String? initialUrl = await platform.invokeMethod('getInitialUrl');
      if (initialUrl != null && initialUrl.isNotEmpty) {
        await _handleIncomingLink(initialUrl);
      }
    } catch (e) {
      print('Error getting initial link: $e');
    }
  }

  Future<void> _handleIncomingLink(String url) async {
    print('Handling incoming link: $url');

    // Validate if it's a supported URL (Medium, Substack, etc.)
    if (_isSupportedUrl(url)) {
      try {
        // Get the article controller
        final articleController = Get.find<ArticleController>();

        // Navigate to home first if not already there
        if (Get.currentRoute != AppRoutes.home) {
          Get.offAllNamed(AppRoutes.home);
        }

        // Wait a bit for navigation to complete
        await Future.delayed(const Duration(milliseconds: 300));

        // Fetch and display the article
        await articleController.fetchArticle(url);
      } catch (e) {
        print('Error handling shared URL: $e');
        // Show error message to user
        Get.snackbar(
          'Error',
          'Failed to open shared article: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      // Show message for unsupported URLs
      Get.snackbar(
        'Unsupported URL',
        'This URL is not supported. Please share a Medium, Substack, or similar article URL.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  bool _isSupportedUrl(String url) {
    final supportedDomains = [
      'medium.com',
      'substack.com',
      'dev.to',
      'hashnode.com',
      'blog.',
      'news.',
      'article',
      'post',
    ];

    final lowerUrl = url.toLowerCase();
    return supportedDomains.any((domain) => lowerUrl.contains(domain)) ||
        lowerUrl.startsWith('http');
  }

  // Method to handle sharing from within the app
  static Future<void> shareArticle(String url, String title) async {
    try {
      await platform.invokeMethod('shareUrl', {'url': url, 'title': title});
    } catch (e) {
      print('Error sharing article: $e');
    }
  }
}
