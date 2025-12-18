class MediumConstants {
  static const String baseUrl = 'https://medium.com';
  static const String freediumUrl = 'https://freedium.cfd';
  static const String readMediumUrl = 'https://readmedium.com';

  // Medium URL patterns
  static const String mediumDomain = 'medium.com';
  static const String mediumSubdomainPattern = r'\.medium\.com$';

  // Article URL patterns
  static const String articlePathPattern = r'^/@[\w\.-]+/[\w\-]+';
  static const String publicationPathPattern = r'^/[\w\-]+/[\w\-]+';

  // API endpoints
  static const String apiVersion = 'v1';
  static const String articlesEndpoint = '/articles';

  // Cache settings
  static const Duration cacheExpiration = Duration(hours: 24);
  static const int maxCacheSize = 100;

  // Reader settings
  static const double defaultFontSize = 16.0;
  static const double minFontSize = 12.0;
  static const double maxFontSize = 24.0;

  // Timeouts
  static const Duration networkTimeout = Duration(seconds: 30);
  static const Duration webViewTimeout = Duration(seconds: 45);
}
