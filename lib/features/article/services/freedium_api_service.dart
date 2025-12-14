import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/error/failures.dart';
import '../../../core/utils/error_handler.dart';
import '../model.dart';
import '../parsers/article_parser.dart';

class FreediumApiService {
  final Dio _dio;

  FreediumApiService(this._dio);

  Future<Article> fetchArticle(String url) async {
    // Try multiple Freedium domains
    final freediumDomains = [
      'freedium.cfd',
      'freedium.cf',
      'freedium.tk',
      'freedium.ml',
    ];

    String? lastError;

    for (final domain in freediumDomains) {
      try {
        final freediumUrl = _createFreediumUrl(url, domain);
        ErrorHandler.logInfo('FreediumApiService', 'Trying: $freediumUrl');

        final response = await _dio.get(
          freediumUrl,
          options: Options(
            receiveTimeout: const Duration(seconds: 15),
            headers: {
              'User-Agent':
                  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
              'Accept':
                  'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
              'Accept-Language': 'en-US,en;q=0.5',
              'Accept-Encoding': 'gzip, deflate, br',
              'DNT': '1',
              'Connection': 'keep-alive',
              'Upgrade-Insecure-Requests': '1',
            },
          ),
        );

        if (response.statusCode == 200) {
          final article = ArticleParser.parseFromHtml(
            response.data.toString(),
            url,
          );
          ErrorHandler.logInfo(
            'FreediumApiService',
            'Successfully parsed via $domain: ${article.title}',
          );

          // Show success message that Freedium was used
          Get.snackbar(
            '🔓 Premium Access',
            'Article unlocked via Freedium ($domain)',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green.withValues(alpha: 0.9),
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
            icon: const Icon(Icons.lock_open, color: Colors.white),
          );

          return article;
        } else {
          lastError = 'HTTP ${response.statusCode} from $domain';
          continue;
        }
      } catch (e) {
        lastError = e.toString();
        ErrorHandler.logInfo('FreediumApiService', 'Failed with $domain: $e');
        continue;
      }
    }

    // If all domains failed, show helpful error
    ErrorHandler.logError(
      'FreediumApiService',
      'All Freedium domains failed: $lastError',
    );

    if (lastError?.contains('host lookup') == true) {
      throw ServerFailure(
        'Freedium service is not accessible from your network. This might be due to:\n'
        '• Network restrictions or firewall\n'
        '• DNS blocking\n'
        '• Service temporarily down\n\n'
        'Try using a VPN or check your network settings.',
      );
    } else {
      throw ServerFailure('Freedium service error: $lastError');
    }
  }

  String _createFreediumUrl(String url, [String domain = 'freedium.cfd']) {
    if (url.contains('freedium')) return url;

    // Clean the URL for Freedium
    String cleanUrl = url.trim();
    cleanUrl = cleanUrl.replaceFirst(RegExp(r'^https?://'), '');
    cleanUrl = cleanUrl.replaceAll(RegExp(r'[#?].*$'), '');

    return 'https://$domain/$cleanUrl';
  }
}
