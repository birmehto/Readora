import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as html;
import '../../../core/error/failures.dart';
import '../model.dart';

class ArticleParser {
  static Article parseFromHtml(String htmlContent, String originalUrl) {
    final document = html_parser.parse(htmlContent);

    final title = _extractTitle(document);
    final author = _extractAuthor(document);
    final subtitle = _extractSubtitle(document);
    final content = _extractContent(document);
    final publishedDate = _extractPublishDate(document);
    final imageUrl = _extractImageUrl(document);
    final authorImageUrl = _extractAuthorImageUrl(document);
    final readingTime = _extractReadingTime(document);
    final tags = _extractTags(document);

    if (title.isEmpty && content.isEmpty) {
      throw const ParsingFailure(
        'Could not extract article content. The article might be behind a paywall or the URL is invalid.',
      );
    }

    return Article(
      title: title,
      author: author,
      subtitle: subtitle,
      content: content,
      publishedDate: publishedDate,
      originalUrl: originalUrl,
      imageUrl: imageUrl,
      authorImageUrl: authorImageUrl,
      readingTime: readingTime,
      tags: tags,
    );
  }

  static String _extractTitle(html.Document document) {
    // Try meta tags first
    final metaSelectors = [
      'meta[property="og:title"]',
      'meta[property="twitter:title"]',
      'meta[name="title"]',
    ];

    for (final selector in metaSelectors) {
      final element = document.querySelector(selector);
      if (element != null) {
        final content = element.attributes['content'];
        if (content != null && content.trim().isNotEmpty) {
          return content.trim().split('|')[0].trim();
        }
      }
    }

    // Try HTML selectors
    final titleSelectors = [
      'h1[data-testid="storyTitle"]',
      'h1.pw-post-title',
      'h1',
    ];

    for (final selector in titleSelectors) {
      final element = document.querySelector(selector);
      if (element != null && element.text.trim().isNotEmpty) {
        return element.text.trim();
      }
    }

    return 'Untitled Article';
  }

  static String _extractAuthor(html.Document document) {
    // Try meta tags
    final metaSelectors = [
      'meta[name="author"]',
      'meta[property="article:author"]',
    ];

    for (final selector in metaSelectors) {
      final element = document.querySelector(selector);
      if (element != null) {
        final content = element.attributes['content'];
        if (content != null && content.trim().isNotEmpty) {
          return content.trim();
        }
      }
    }

    // Try HTML selectors
    final authorSelectors = [
      '[data-testid="authorName"]',
      'a[data-testid="authorName"]',
    ];

    for (final selector in authorSelectors) {
      final element = document.querySelector(selector);
      if (element != null && element.text.trim().isNotEmpty) {
        return element.text.trim();
      }
    }

    return 'Unknown Author';
  }

  static String? _extractSubtitle(html.Document document) {
    final metaSelectors = [
      'meta[property="og:description"]',
      'meta[name="description"]',
    ];

    for (final selector in metaSelectors) {
      final element = document.querySelector(selector);
      if (element != null) {
        final content = element.attributes['content'];
        if (content != null &&
            content.trim().isNotEmpty &&
            content.length > 20) {
          return content.trim();
        }
      }
    }

    return null;
  }

  static String _extractContent(html.Document document) {
    final contentSelectors = [
      'article section',
      'article',
      '.postArticle-content',
    ];

    for (final selector in contentSelectors) {
      final contentElement = document.querySelector(selector);
      if (contentElement != null) {
        _removeUnwantedElements(contentElement);
        final htmlContent = contentElement.innerHtml;
        if (htmlContent.isNotEmpty && htmlContent.length > 100) {
          return _cleanHtmlContent(htmlContent);
        }
      }
    }

    return 'Content could not be extracted.';
  }

  static DateTime? _extractPublishDate(html.Document document) {
    final metaSelectors = [
      'meta[property="article:published_time"]',
      'meta[name="publish_date"]',
    ];

    for (final selector in metaSelectors) {
      final element = document.querySelector(selector);
      if (element != null) {
        final content = element.attributes['content'];
        if (content != null) {
          return DateTime.tryParse(content);
        }
      }
    }

    final dateSelectors = [
      '[data-testid="storyPublishDate"]',
      'time[datetime]',
    ];

    for (final selector in dateSelectors) {
      final element = document.querySelector(selector);
      if (element != null) {
        final dateText = element.attributes['datetime'] ?? element.text.trim();
        if (dateText.isNotEmpty) {
          return DateTime.tryParse(dateText);
        }
      }
    }

    return null;
  }

  static String? _extractImageUrl(html.Document document) {
    final metaSelectors = [
      'meta[property="og:image"]',
      'meta[property="twitter:image"]',
    ];

    for (final selector in metaSelectors) {
      final element = document.querySelector(selector);
      if (element != null) {
        final content = element.attributes['content'];
        if (content != null && content.startsWith('http')) {
          return content;
        }
      }
    }

    return null;
  }

  static String? _extractAuthorImageUrl(html.Document document) {
    final authorImageSelectors = [
      '[data-testid="authorPhoto"] img',
      'img[data-testid="authorPhoto"]',
    ];

    for (final selector in authorImageSelectors) {
      final element = document.querySelector(selector);
      if (element != null) {
        final src = element.attributes['src'];
        if (src != null && src.startsWith('http')) {
          return src;
        }
      }
    }

    return null;
  }

  static int? _extractReadingTime(html.Document document) {
    final readingTimeSelectors = ['[data-testid="storyReadTime"]'];

    for (final selector in readingTimeSelectors) {
      final element = document.querySelector(selector);
      if (element != null) {
        final text = element.text.toLowerCase();
        final match = RegExp(r'(\d+)').firstMatch(text);
        if (match != null) {
          return int.tryParse(match.group(1)!);
        }
      }
    }

    return null;
  }

  static List<String> _extractTags(html.Document document) {
    final tags = <String>[];

    final tagSelectors = ['.tags a', '[data-testid="tag"]'];

    for (final selector in tagSelectors) {
      final elements = document.querySelectorAll(selector);
      for (final element in elements) {
        final tagText = element.text.trim();
        if (tagText.isNotEmpty && !tags.contains(tagText)) {
          tags.add(tagText);
        }
      }
    }

    return tags.take(5).toList();
  }

  static void _removeUnwantedElements(html.Element contentElement) {
    final unwantedSelectors = [
      '.follow-button',
      '.subscribe-button',
      '.clap-button',
      '.bookmark-button',
      'script',
      'style',
      '.advertisement',
    ];

    for (final selector in unwantedSelectors) {
      final elements = contentElement.querySelectorAll(selector);
      for (final element in elements) {
        element.remove();
      }
    }
  }

  static String _cleanHtmlContent(String htmlContent) {
    String cleaned = htmlContent;
    cleaned = cleaned.replaceAll(RegExp(r'<p[^>]*>\s*</p>'), '');
    cleaned = cleaned.replaceAll(RegExp(r'\s*style="[^"]*"'), '');
    cleaned = cleaned.replaceAll(RegExp(r'\s*class="[^"]*"'), '');
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ');
    return cleaned.trim();
  }
}
