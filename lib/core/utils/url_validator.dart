import '../constants/app_constants.dart';

class UrlValidator {
  static bool isValidMediumUrl(String url) {
    if (url.trim().isEmpty) return false;

    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && _isSupportedDomain(uri.host);
    } catch (e) {
      return false;
    }
  }

  static bool _isSupportedDomain(String host) {
    return AppConstants.supportedDomains.any(
      (domain) => host.contains(domain) || host.endsWith('.$domain'),
    );
  }

  static String? validateUrl(String url) {
    if (url.trim().isEmpty) {
      return 'Please enter a URL';
    }

    if (!isValidMediumUrl(url)) {
      return 'Please enter a valid Medium URL';
    }

    return null; // Valid URL
  }

  static String normalizeUrl(String url) {
    url = url.trim();

    // Add https if no scheme is provided
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }

    return url;
  }

  static String createFreediumUrl(String originalUrl) {
    return '${AppConstants.freediumBaseUrl}$originalUrl';
  }
}
