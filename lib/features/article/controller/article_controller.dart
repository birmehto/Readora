import 'package:flutter/material.dart';
import 'package:free/core/routes/app_routes.dart';
import 'package:get/get.dart';

import '../../../core/utils/error_handler.dart';
import '../../../core/utils/url_validator.dart';
import '../../../core/utils/share_helper.dart';
import '../../../core/network/network_info.dart';
import '../../../core/error/failures.dart';
import '../../history/controller/reading_history_controller.dart';
import '../model.dart';
import '../services/freedium_api_service.dart';

class ArticleController extends GetxController {
  final FreediumApiService _apiService;
  final NetworkInfo networkInfo;

  ArticleController({
    required FreediumApiService apiService,
    required this.networkInfo,
  }) : _apiService = apiService;

  final _isLoading = false.obs;
  final _article = Rxn<Article>();
  final _error = RxnString();
  final _urlInput = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Check if there's a URL parameter in the route
    final urlParam = Get.parameters['url'];
    if (urlParam != null && urlParam.isNotEmpty) {
      // Decode the URL parameter
      final decodedUrl = Uri.decodeComponent(urlParam);
      fetchArticle(decodedUrl);
    }
  }

  bool get isLoading => _isLoading.value;
  Article? get article => _article.value;
  String? get error => _error.value;
  String get urlInput => _urlInput.value;

  void setUrlInput(String url) {
    _urlInput.value = url;
    if (_error.value != null) {
      _error.value = null;
    }
  }

  Future<void> fetchArticle(String url) async {
    final validationError = UrlValidator.validateUrl(url);
    if (validationError != null) {
      _error.value = validationError;
      return;
    }

    _isLoading.value = true;
    _error.value = null;

    try {
      if (await networkInfo.isConnected) {
        final article = await _apiService.fetchArticle(url);
        _article.value = article;
        ErrorHandler.logInfo(
          'ArticleController',
          'Successfully loaded: ${article.title}',
        );

        // Navigate directly to article view after successful fetch
        Get.toNamed(AppRoutes.article);
      } else {
        _error.value =
            'No internet connection. Please check your network and try again.';
      }
    } catch (e) {
      final errorStr = e.toString().toLowerCase();
      String errorMessage;

      if (e is Failure) {
        errorMessage = e.message;
      } else {
        if (errorStr.contains('network restrictions') ||
            errorStr.contains('dns blocking')) {
          errorMessage = e
              .toString(); // Use the detailed message from FreediumApiService
        } else if (errorStr.contains('freedium') &&
            errorStr.contains('host lookup')) {
          errorMessage =
              'Freedium service is not accessible from your network. Try using a VPN or check your network settings.';
        } else if (errorStr.contains('freedium')) {
          errorMessage =
              'Freedium premium access failed. The service may be temporarily down.';
        } else if (errorStr.contains('paywall')) {
          errorMessage =
              'This article is behind a paywall. Premium content access failed.';
        } else if (errorStr.contains('timeout') ||
            errorStr.contains('connection')) {
          errorMessage =
              'Connection timeout. Please check your internet connection and try again.';
        } else if (errorStr.contains('404') || errorStr.contains('not found')) {
          errorMessage =
              'Article not found. Please check the URL and try again.';
        } else {
          errorMessage =
              'Failed to access premium content. Please try again or check if the URL is correct.';
        }
      }

      _error.value = errorMessage;
      ErrorHandler.logError('ArticleController', 'Error: $errorMessage');

      // Show helpful message for network issues
      if (errorStr.contains('network restrictions') ||
          errorStr.contains('dns blocking')) {
        Get.snackbar(
          'Network Issue',
          'Freedium is not accessible. Try using a VPN or mobile data.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.withValues(alpha: 0.9),
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
      }
    }

    _isLoading.value = false;
  }

  void retryLastFetch() {
    if (_urlInput.value.isNotEmpty) {
      fetchArticle(_urlInput.value);
    }
  }

  void reset() {
    _article.value = null;
    _error.value = null;
    _urlInput.value = '';
  }

  void bookmarkArticle() {
    if (_article.value != null) {
      try {
        final historyController = Get.find<ReadingHistoryController>();
        historyController.toggleFavorite(_article.value!);
      } catch (_) {}
    }
  }

  bool isBookmarked() {
    if (_article.value != null) {
      try {
        final historyController = Get.find<ReadingHistoryController>();
        return historyController.isFavorite(_article.value!);
      } catch (_) {
        return false;
      }
    }
    return false;
  }

  void setArticle(Article article) {
    _article.value = article;
    _error.value = null;
    try {
      final historyController = Get.find<ReadingHistoryController>();
      historyController.addToHistory(article);
    } catch (_) {}
  }

  // Helper method to navigate to article with URL
  static void openArticleFromUrl(String url) {
    final encodedUrl = Uri.encodeComponent(url);
    Get.toNamed('${AppRoutes.article}/$encodedUrl');
  }

  // Helper method to share article with native sharing
  Future<void> shareArticleNative() async {
    if (_article.value != null) {
      await ShareHelper.shareArticle(_article.value!);
    }
  }
}
