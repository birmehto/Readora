import '../app/app_constants.dart';

class UrlValidator {
  static const String _urlPattern =
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$';
  static final RegExp _urlRegex = RegExp(_urlPattern);

  /// Known Medium custom domain publications
  /// These are popular Medium publications that use custom domains
  static const List<String> _knownMediumCustomDomains = [
    'towardsdatascience.com',
    'betterhumans.pub',
    'betterprogramming.pub',
    'eand.co',
    'arcdigital.media',
    'blog.prototypr.io',
    'uxdesign.cc',
    'levelup.gitconnected.com',
    'javascript.plainenglish.io',
    'python.plainenglish.io',
    'aws.plainenglish.io',
    'blog.devgenius.io',
    'entrepreneurshandbook.co',
    'bettermarketing.pub',
    'writingcooperative.com',
    'psiloveyou.xyz',
    'codeburst.io',
    'itnext.io',
    'blog.bitsrc.io',
    'netflixtechblog.com',
    'engineering.atspotify.com',
    'slack.engineering',
    'blog.usejournal.com',
    'uxplanet.org',
    'thebolditalic.com',
    'hackernoon.com',
  ];

  /// Validate if the string is a valid URL
  static bool isValidUrl(String url) {
    if (url.isEmpty) return false;
    return _urlRegex.hasMatch(url);
  }

  /// Check if URL is a Medium article or can be handled by Freedium
  /// This includes:
  /// 1. medium.com/* - Main Medium domain
  /// 2. *.medium.com/* - Subdomain based Medium profiles
  /// 3. Known custom domain Medium publications
  /// 4. Any other URL (Freedium can handle most Medium-hosted content)
  static bool isMediumUrl(String url) {
    if (!isValidUrl(url)) return false;

    final uri = Uri.tryParse(url);
    if (uri == null) return false;

    final host = uri.host.toLowerCase();

    // Check for medium.com domain (with or without www)
    if (host == MediumConstants.mediumDomain ||
        host == 'www.${MediumConstants.mediumDomain}') {
      return true;
    }

    // Check for medium subdomain (e.g., username.medium.com)
    if (host.endsWith('.medium.com')) {
      return true;
    }

    // Check for known Medium custom domains
    for (final domain in _knownMediumCustomDomains) {
      if (host == domain || host == 'www.$domain') {
        return true;
      }
    }

    // For any other valid URL, we'll allow it and let Freedium handle it
    // This enables support for custom domain Medium publications
    // Even if it's not a Medium link, Freedium will show an appropriate error
    return true;
  }

  /// Check if URL looks like it could be an article
  /// This is a more lenient check that looks for common article URL patterns
  static bool isMediumArticle(String url) {
    if (!isValidUrl(url)) return false;

    final uri = Uri.tryParse(url);
    if (uri == null) return false;

    final host = uri.host.toLowerCase();
    final path = uri.path;

    // If it's a known Medium domain, check for article patterns
    if (host == MediumConstants.mediumDomain ||
        host == 'www.${MediumConstants.mediumDomain}' ||
        host.endsWith('.medium.com')) {
      // Any medium.com path with at least one segment that isn't a search/topic/etc.
      final segments = uri.pathSegments;
      if (segments.isEmpty) return false;

      final firstSegment = segments[0];
      // Skip known non-article pages
      if ([
        'search',
        'topic',
        'membership',
        'creators',
        'about',
        'plans',
      ].contains(firstSegment)) {
        return false;
      }
      return true;
    }

    // For custom domains and other URLs, just check if there's a path
    return path.length > 1 && path != '/';
  }

  /// Extract any URL found in the text and clean it
  static String? extractUrlFromText(String text) {
    if (text.isEmpty) return null;

    // Regex to find http or https URLs
    final RegExp urlFinder = RegExp(
      r'(https?:\/\/[^\s]+)',
      caseSensitive: false,
    );

    final match = urlFinder.firstMatch(text);
    if (match == null) return null;

    String url = match.group(0)!;

    // Remove trailing punctuation that might be part of the shared text but not the URL
    // e.g., "Check this: https://medium.com/abc. It's good!" -> match is "https://medium.com/abc."
    while (url.isNotEmpty &&
        (url.endsWith('.') ||
            url.endsWith(',') ||
            url.endsWith('!') ||
            url.endsWith('?') ||
            url.endsWith(';') ||
            url.endsWith(':'))) {
      url = url.substring(0, url.length - 1);
    }

    return url;
  }

  /// Convert any URL to Freedium URL for reading
  /// We always prepend the Freedium base URL to the full article URL
  /// as this is the most reliable way Freedium handles both standard and custom domains.
  static String? convertToFreediumUrl(String articleUrl) {
    if (!isValidUrl(articleUrl)) return null;

    String targetUrl = cleanUrl(articleUrl) ?? articleUrl;

    // Strip existing Freedium or ReadMedium prefixes to prevent double-prefixing
    // and to fix any already corrupted URLs in history
    final prefixes = [
      '${MediumConstants.freediumUrl}/',
      'https://freedium.cfd/',
      'https://readmedium.com/',
      '${MediumConstants.readMediumUrl}/',
    ];

    bool stripped = true;
    while (stripped) {
      stripped = false;
      for (final prefix in prefixes) {
        if (targetUrl.startsWith(prefix)) {
          targetUrl = targetUrl.substring(prefix.length);
          stripped = true;
        }
      }
    }

    // Now targetUrl is stripped of bypass prefixes.
    // Prepend the primary Freedium URL.
    return '${MediumConstants.freediumUrl}/$targetUrl';
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

  /// Cleans Textise URLs to extract the actual target URL
  static String? cleanTextiseUrl(String url) {
    if (url.isEmpty) return null;

    if (url.contains('textise.org')) {
      final uri = Uri.tryParse(url);
      if (uri != null && uri.queryParameters.containsKey('strURL')) {
        return uri.queryParameters['strURL'];
      }
    }
    return url;
  }
}
