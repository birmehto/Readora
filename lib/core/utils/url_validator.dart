import '../app/app_constants.dart';

class UrlValidator {
  const UrlValidator._();

  static final RegExp _urlRegex = RegExp(
    r'^https?:\/\/[^\s/$.?#].[^\s]*$',
    caseSensitive: false,
  );

  static const _mediumDomains = {
    'medium.com',
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
  };

  static const _excludedPaths = {
    'about',
    'me',
    'settings',
    'membership',
    'creators',
    'search',
    'tag',
    'topic',
    'plans',
    'verified-authors',
  };

  // ─────────────────────────────────────────────

  static Uri? _parse(String input) {
    if (input.isEmpty) return null;
    final url = input.startsWith('http')
        ? input.trim()
        : 'https://${input.trim()}';
    if (!_urlRegex.hasMatch(url)) return null;
    return Uri.tryParse(url);
  }

  static bool isValidUrl(String url) => _parse(url) != null;

  static bool isMediumUrl(String url) {
    final uri = _parse(url);
    if (uri == null) return false;

    final host = uri.host.replaceFirst('www.', '');
    return host == MediumConstants.mediumDomain ||
        host.endsWith('.medium.com') ||
        _mediumDomains.contains(host);
  }

  static bool isMediumArticle(String url) {
    final uri = _parse(url);
    if (uri == null) return false;

    if (!isMediumUrl(url)) return false;

    final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    if (segments.isEmpty) return false;

    final first = segments.first;
    if (first.startsWith('@')) return segments.length > 1;
    if (_excludedPaths.contains(first)) return false;

    return true;
  }

  static String? extractUrlFromText(String text) => RegExp(
    r'https?:\/\/[^\s]+',
    caseSensitive: false,
  ).firstMatch(text)?.group(0)?.replaceAll(RegExp(r'[.,!?;:]+$'), '');

  static String? cleanTextiseUrl(String url) =>
      Uri.tryParse(url)?.queryParameters['strURL'] ?? url;

  static String? convertToFreediumUrl(String url) {
    final uri = _parse(url);
    if (uri == null) return null;

    final stripped = _stripBypassPrefixes(uri.toString());
    return '${MediumConstants.freediumUrl}/$stripped';
  }

  // ─────────────────────────────────────────────

  static String _stripBypassPrefixes(String url) {
    const prefixes = {'https://freedium.cfd/', 'https://freedium-mirror.cfd/'};

    for (final p in prefixes) {
      if (url.startsWith(p)) {
        return url.substring(p.length);
      }
    }
    return url;
  }
}
