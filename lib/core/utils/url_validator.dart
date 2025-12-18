import '../app/app_constants.dart';

class UrlValidator {
  static const String _urlPattern =
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$';
  static final RegExp _urlRegex = RegExp(_urlPattern);

  /// Validate if the string is a valid URL
  static bool isValidUrl(String url) {
    if (url.isEmpty) return false;
    return _urlRegex.hasMatch(url);
  }

  /// Check if URL is a Medium article
  static bool isMediumUrl(String url) {
    if (!isValidUrl(url)) return false;

    final uri = Uri.tryParse(url);
    if (uri == null) return false;

    // Check for medium.com domain
    if (uri.host == MediumConstants.mediumDomain) return true;

    // Check for medium subdomain (e.g., username.medium.com)
    final subdomainRegex = RegExp(MediumConstants.mediumSubdomainPattern);
    if (subdomainRegex.hasMatch(uri.host)) return true;

    return false;
  }

  /// Check if URL is a Medium article (not just profile or publication)
  static bool isMediumArticle(String url) {
    if (!isMediumUrl(url)) return false;

    final uri = Uri.tryParse(url);
    if (uri == null) return false;

    final path = uri.path;

    // Check for article path patterns
    final articleRegex = RegExp(MediumConstants.articlePathPattern);
    final publicationRegex = RegExp(MediumConstants.publicationPathPattern);

    return articleRegex.hasMatch(path) || publicationRegex.hasMatch(path);
  }

  /// Extract article ID from Medium URL
  static String? extractArticleId(String url) {
    if (!isMediumArticle(url)) return null;

    final uri = Uri.tryParse(url);
    if (uri == null) return null;

    // Extract the last part of the path as article ID
    final pathSegments = uri.pathSegments;
    if (pathSegments.isNotEmpty) {
      return pathSegments.last;
    }

    return null;
  }

  /// Convert Medium URL to Freedium URL
  static String? convertToFreediumUrl(String mediumUrl) {
    if (!isMediumArticle(mediumUrl)) return null;

    final uri = Uri.tryParse(mediumUrl);
    if (uri == null) return null;

    // Create Freedium URL
    return '${MediumConstants.freediumUrl}${uri.path}';
  }

  /// Validate and clean URL
  static String? cleanUrl(String input) {
    if (input.isEmpty) return null;

    String cleaned = input.trim();

    // Add https if no protocol
    if (!cleaned.startsWith('http://') && !cleaned.startsWith('https://')) {
      cleaned = 'https://$cleaned';
    }

    return isValidUrl(cleaned) ? cleaned : null;
  }

  /// Extract domain from URL
  static String? extractDomain(String url) {
    if (!isValidUrl(url)) return null;

    final uri = Uri.tryParse(url);
    return uri?.host;
  }
}
