import 'package:share_plus/share_plus.dart';
import '../services/deep_link_service.dart';
import '../../features/article/model.dart';

class ShareHelper {
  /// Share an article using native sharing with deep link support
  static Future<void> shareArticle(Article article) async {
    try {
      await DeepLinkService.shareArticle(article.originalUrl, article.title);
    } catch (e) {
      // Fallback to regular sharing
      final shareText = _buildShareText(article);
      await Share.share(shareText);
    }
  }

  /// Share a URL with title using native sharing
  static Future<void> shareUrl(String url, {String? title}) async {
    try {
      await DeepLinkService.shareArticle(
        url,
        title ?? 'Check out this article',
      );
    } catch (e) {
      // Fallback to regular sharing
      final shareText = title != null ? '$title\n\n$url' : url;
      await Share.share(shareText);
    }
  }

  /// Build formatted share text for an article
  static String _buildShareText(Article article) {
    final buffer = StringBuffer();

    buffer.writeln(article.title);

    if (article.subtitle != null && article.subtitle!.isNotEmpty) {
      buffer.writeln(article.subtitle);
    }

    buffer.writeln();
    buffer.writeln('By ${article.author}');

    if (article.readingTime != null) {
      buffer.writeln('${article.readingTime} min read');
    }

    buffer.writeln();
    buffer.writeln(article.originalUrl);

    return buffer.toString();
  }
}
