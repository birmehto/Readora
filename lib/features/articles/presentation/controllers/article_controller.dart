import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/app/app_constants.dart';
import '../../../../core/app/app_log.dart';
import '../../../../core/constants/reader_theme.dart';
import '../../../../core/services/clipboard_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/url_validator.dart';

class ArticleController extends GetxController {
  final ClipboardService _clipboardService = Get.find();
  final StorageService _storage = Get.find();

  // Article state
  final currentUrl = ''.obs;
  final originalUrl = ''.obs;
  final errorMessage = ''.obs;
  final isLoading = true.obs;
  final isInitialLoad = true.obs;
  final loadingProgress = 0.0.obs;
  final isAppBarVisible = true.obs;
  final scrollProgress = 0.0.obs;

  // Loading timeout
  Timer? _loadingTimer;

  // Reader preferences
  final fontSize = 16.0.obs;
  final isDarkMode = false.obs;
  final fontFamily = 'Inter'.obs;

  // Favorites
  final isFavorite = false.obs;

  @override
  void onInit() {
    super.onInit();
    fontSize.value = _storage.fontSize;
    isDarkMode.value = _storage.isDarkMode;
    fontFamily.value = _storage.fontFamily;

    final args = Get.arguments as Map<String, dynamic>?;

    final url = args?['url'] as String?;
    final original = args?['originalUrl'] as String?;

    if (url == null || !UrlValidator.isValidUrl(url)) {
      errorMessage.value = 'Invalid or missing article URL';
      isLoading.value = false;
      return;
    }

    _initialize(url, original);
    _setupWebViewListeners();
  }

  void _initialize(String url, String? original) {
    appLog('Initializing ArticleController with URL: $url');
    appLog('Original URL: $original');

    currentUrl.value = url;
    originalUrl.value = original ?? url;
    errorMessage.value = '';
    isLoading.value = true;
    isInitialLoad.value = true;
    loadingProgress.value = 0.0;
    _startLoadingTimer();

    // Check if article is in favorites
    isFavorite.value = _storage.isFavorite(originalUrl.value);

    appLog('Current URL set to: ${currentUrl.value}');
  }

  /// Called by WebView when page finished loading
  void onPageLoaded() {
    _cancelLoadingTimer();
    isLoading.value = false;
    isInitialLoad.value = false;
    loadingProgress.value = 1.0;
    _restoreScrollPosition();
  }

  Future<void> _restoreScrollPosition() async {
    final scrollData = _storage.getScrollPosition(originalUrl.value);
    if (scrollData != null && webViewController != null) {
      final int y = scrollData['y'] ?? 0;
      final double pct = scrollData['percentage'] ?? 0.0;
      scrollProgress.value = pct;
      if (y > 0) {
        appLog('Restoring scroll position to y: $y');
        await Future.delayed(const Duration(milliseconds: 350));
        await webViewController?.scrollTo(x: 0, y: y);
      }
    }
  }

  /// Handle server errors (502, 503, etc.)
  void handleServerError(int statusCode) {
    String errorMsg = 'Server error ($statusCode)';
    if (statusCode == 502) {
      errorMsg = 'Bad Gateway (502). Server unavailable.';
    }
    if (statusCode == 503) errorMsg = 'Service Unavailable (503).';
    onPageError(errorMsg);
  }

  /// Called by WebView when error occurs
  void onPageError(String message) {
    _cancelLoadingTimer();
    errorMessage.value = message;
    isLoading.value = false;
    isInitialLoad.value = false;
    loadingProgress.value = 0.0;
  }

  /// Called by WebView to update loading progress
  void updateProgress(double progress) {
    loadingProgress.value = progress / 100.0;
  }

  // Scroll handling for immersive mode
  int _lastScrollY = 0;
  Future<void> handleScroll(int y) async {
    // Threshold to prevent jitter
    const threshold = 50;

    if ((y - _lastScrollY).abs() > threshold) {
      if (y > _lastScrollY && y > 100) {
        // Scrolling down -> Hide AppBar
        isAppBarVisible.value = false;
      } else {
        // Scrolling up -> Show AppBar
        isAppBarVisible.value = true;
      }
      _lastScrollY = y;
    }

    // Calculate scroll percentage
    try {
      final percentage = await webViewController?.evaluateJavascript(source: '''
        (function() {
          var limit = document.documentElement.scrollHeight - document.documentElement.clientHeight;
          return limit > 0 ? (window.pageYOffset / limit) : 0;
        })();
      ''');
      if (percentage != null && percentage is num) {
        scrollProgress.value = percentage.toDouble().clamp(0.0, 1.0);
        await _storage.saveScrollPosition(originalUrl.value, y, scrollProgress.value);
      }
    } catch (e) {
      // Ignored
    }
  }

  Future<void> tryAlternativeEngine() async {
    final activeEngine = _storage.activeEngineUrl;
    final currentIndex = StorageService.availableEngines.indexWhere((e) => e['url'] == activeEngine);
    final nextIndex = (currentIndex + 1) % StorageService.availableEngines.length;
    final nextEngine = StorageService.availableEngines[nextIndex];

    _storage.activeEngineUrl = nextEngine['url']!;

    final newUrl = UrlValidator.convertToFreediumUrl(originalUrl.value);
    if (newUrl != null) {
      appLog('Switching engine to: ${nextEngine['name']} (${nextEngine['url']})');
      currentUrl.value = newUrl;
      requestRefresh();
    }
  }

  /// UI triggers this → WebView listens and reloads
  void requestRefresh() {
    errorMessage.value = '';
    isLoading.value = true;
    loadingProgress.value = 0.0;
    _startLoadingTimer();

    webViewController?.reload();
  }

  // ---------- Actions ----------

  Future<void> shareArticle() async {
    if (originalUrl.isEmpty) return;
    SharePlus.instance.share(
      ShareParams(uri: Uri.parse(originalUrl.value), subject: articleTitle),
    );
  }

  Future<void> openInBrowser() async {
    if (originalUrl.isEmpty) return;

    final uri = Uri.tryParse(originalUrl.value);
    if (uri == null) {
      errorMessage.value = 'Invalid URL';
      return;
    }

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> copyLink() async {
    if (originalUrl.isEmpty) return;
    await _clipboardService.copyToClipboard(originalUrl.value);
  }

  // ---------- Favorites ----------

  Future<void> toggleFavorite() async {
    final url = originalUrl.value.isNotEmpty
        ? originalUrl.value
        : currentUrl.value;
    if (url.isEmpty) return;

    if (isFavorite.value) {
      await _storage.removeFromFavorites(url);
      isFavorite.value = false;
    } else {
      await _storage.addToFavorites({
        'title': articleTitle,
        'url': url,
        'visitedAt': DateTime.now().toIso8601String(),
        'domain': articleDomain,
        'author': articleAuthor,
      });
      isFavorite.value = true;
    }
  }

  // ---------- Reader Settings ----------

  void updateFontSize(double size) {
    fontSize.value = size.clamp(14, 28);
    _storage.fontSize = fontSize.value;
  }

  void updateFontFamily(String family) {
    fontFamily.value = family;
    _storage.fontFamily = family;
  }

  void toggleDarkMode() {
    isDarkMode.toggle();
    _storage.isDarkMode = isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  // ---------- Article Content Helpers ----------

  String get articleTitle {
    final uri = Uri.tryParse(currentUrl.value);
    if (uri != null && uri.pathSegments.isNotEmpty) {
      return uri.pathSegments.last
          .replaceAll('-', ' ')
          .split(' ')
          .map(
            (word) => word.isNotEmpty
                ? '${word[0].toUpperCase()}${word.substring(1)}'
                : word,
          )
          .join(' ');
    }
    return 'Article';
  }

  String? get articleDomain {
    final uri = Uri.tryParse(originalUrl.value);
    if (uri != null) {
      String host = uri.host;
      if (host.startsWith('www.')) host = host.substring(4);
      return host;
    }
    return null;
  }

  String? get articleAuthor {
    final uri = Uri.tryParse(originalUrl.value);
    if (uri != null && uri.pathSegments.isNotEmpty) {
      final firstSegment = uri.pathSegments.first;
      if (firstSegment.startsWith('@')) {
        return firstSegment
            .substring(1)
            .replaceAll('-', ' ')
            .split(' ')
            .map(
              (word) => word.isNotEmpty
                  ? '${word[0].toUpperCase()}${word.substring(1)}'
                  : word,
            )
            .join(' ');
      }
    }
    return null;
  }

  bool get isFreediumUrl => currentUrl.value.contains('freedium');

  String get displayUrl => isFreediumUrl ? originalUrl.value : currentUrl.value;

  // ---------- Loading Timer ----------

  void _startLoadingTimer() {
    _cancelLoadingTimer();
    _loadingTimer = Timer(MediumConstants.webViewTimeout, () {
      if (isLoading.value) {
        onPageError(
          'Loading timeout. Please check your connection and try again.',
        );
      }
    });
  }

  void _cancelLoadingTimer() {
    _loadingTimer?.cancel();
    _loadingTimer = null;
  }

  @override
  void onClose() {
    _cancelLoadingTimer();
    super.onClose();
  }

  // ---------- WebView Control ----------

  InAppWebViewController? webViewController;

  void setWebViewController(InAppWebViewController controller) {
    webViewController = controller;
  }

  void _setupWebViewListeners() {
    ever(fontSize, (_) => injectCustomCSS());
    ever(isDarkMode, (_) => injectCustomCSS());
    ever(fontFamily, (_) => injectCustomCSS());
  }

  Future<void> injectCustomCSS() async {
    if (webViewController == null) return;

    final css = ReaderTheme.getCss(
      fontSize: fontSize.value,
      isDarkMode: isDarkMode.value,
      fontFamily: fontFamily.value,
    );

    try {
      await webViewController?.evaluateJavascript(
        source:
            '''
        var existingStyle = document.getElementById('${ReaderTheme.customCssId}');
        if (existingStyle) {
          existingStyle.remove();
        }
        
        var style = document.createElement('style');
        style.id = '${ReaderTheme.customCssId}';
        style.innerHTML = `$css`;
        document.head.appendChild(style);
      ''',
      );
    } catch (e) {
      appLog('Error injecting CSS: $e');
    }
  }
}
