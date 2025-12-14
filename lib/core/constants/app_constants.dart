class AppConstants {
  // App information
  static const String appName = 'Article Reader';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Read Medium articles without paywalls';

  // API endpoints
  static const String freediumBaseUrl = 'https://freedium.cfd/';

  // Storage keys
  static const String themeKey = 'theme_mode';
  static const String lastUrlKey = 'last_url';
  static const String readingHistoryKey = 'reading_history';

  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Limits
  static const int maxHistoryItems = 50;
  static const int maxRetryAttempts = 3;
  static const int minContentLength = 100;

  // Supported domains
  static const List<String> supportedDomains = [
    'medium.com',
    'towardsdatascience.com',
    'hackernoon.com',
    'uxdesign.cc',
    'levelup.gitconnected.com',
    'betterprogramming.pub',
    'javascript.plainenglish.io',
    'python.plainenglish.io',
    'blog.devgenius.io',
    'itnext.io',
    'codeburst.io',
    'medium.engineering',
    'netflixtechblog.com',
    'engineering.fb.com',
  ];

  // Error messages
  static const String networkError = 'No internet connection available';
  static const String invalidUrlError = 'Please enter a valid Medium URL';
  static const String paywallError = 'This article might be behind a paywall';
  static const String notFoundError = 'Article not found';
  static const String timeoutError = 'Request timed out';
  static const String genericError = 'An unexpected error occurred';

  // Success messages
  static const String articleLoadedSuccess = 'Article loaded successfully';
  static const String themeChangedSuccess = 'Theme changed successfully';
}
