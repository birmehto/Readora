// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/core.dart';
import '../../../widgets/widgets.dart';
import '../controller/article_controller.dart';

class ArticleView extends GetView<ArticleController> {
  const ArticleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final article = controller.article;
        if (article == null) {
          return const Center(child: Text('No article to display'));
        }

        return CustomScrollView(
          slivers: [
            _buildAppBar(context, article),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildArticleTitle(context, article),
                  _buildArticleHeader(context, article),
                  _buildArticleContent(context, article),
                  SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildAppBar(BuildContext context, article) {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      foregroundColor: Theme.of(context).colorScheme.onSurface,
      actions: [
        IconButton(
          icon: Obx(
            () => Icon(
              controller.isBookmarked()
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: controller.isBookmarked() ? Colors.red : null,
            ),
          ),
          onPressed: controller.bookmarkArticle,
          tooltip: 'Add to favorites',
        ),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: controller.shareArticleNative,
          tooltip: 'Share article',
        ),
        IconButton(
          icon: const Icon(Icons.open_in_browser),
          onPressed: () => launchUrl(Uri.parse(article.originalUrl)),
          tooltip: 'Open in browser',
        ),
        SizedBox(width: AppSpacing.sm),
      ],
    );
  }

  Widget _buildArticleTitle(BuildContext context, article) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            article.title,
            style: AppTypography.articleTitle(context),
          ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0),
          if (article.subtitle != null) ...[
            SizedBox(height: AppSpacing.md),
            Text(
                  article.subtitle!,
                  style: AppTypography.articleSubtitle(context),
                )
                .animate(delay: 200.ms)
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.3, end: 0),
          ],
          if (article.imageUrl != null) ...[
            SizedBox(height: AppSpacing.lg),
            _buildHeroImage(context, article),
          ],
        ],
      ),
    );
  }

  Widget _buildHeroImage(BuildContext context, article) {
    return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              article.imageUrl!,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    size: 48,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                );
              },
            ),
          ),
        )
        .animate(delay: 400.ms)
        .fadeIn(duration: 800.ms)
        .scale(begin: const Offset(0.8, 0.8));
  }

  Widget _buildArticleHeader(BuildContext context, article) {
    return Container(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AuthorAvatar(
                    authorName: article.author,
                    authorImageUrl: article.authorImageUrl,
                    radius: 24,
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.author,
                          style: AppTypography.articleAuthor(context),
                        ),
                        if (article.publishedDate != null)
                          Text(
                            DateFormatter.formatRelativeDate(
                              article.publishedDate!,
                            ),
                            style: AppTypography.articleMeta(context),
                          ),
                      ],
                    ),
                  ),
                  if (article.readingTime != null)
                    ReadingTimeBadge(readingTime: article.readingTime!),
                ],
              ),
              if (article.tags.isNotEmpty) ...[
                SizedBox(height: AppSpacing.md),
                TagsWrap(
                  tags: article.tags,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primaryContainer,
                  textColor: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ],
            ],
          ),
        )
        .animate(delay: 300.ms)
        .fadeIn(duration: 600.ms)
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildArticleContent(BuildContext context, article) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Html(
        data: _processContent(article.content),
        style: _getHtmlStyles(context),
        onLinkTap: (url, _, _) {
          if (url != null) {
            launchUrl(Uri.parse(url));
          }
        },
      ),
    ).animate(delay: 500.ms).fadeIn(duration: 800.ms);
  }

  String _processContent(String content) {
    // Wrap content in proper HTML structure for better rendering
    return '''
    <div class="article-content">
      $content
    </div>
    ''';
  }

  Map<String, Style> _getHtmlStyles(BuildContext context) {
    return {
      "body": Style(
        margin: Margins.zero,
        padding: HtmlPaddings.zero,
        fontSize: FontSize(18),
        lineHeight: const LineHeight(1.8),
        color: Theme.of(context).colorScheme.onSurface,
        fontFamily: 'Source Serif Pro',
      ),

      // Headings
      "h1": Style(
        fontSize: FontSize(28),
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.onSurface,
        margin: Margins.only(top: 32, bottom: 16),
        fontFamily: 'Poppins',
      ),
      "h2": Style(
        fontSize: FontSize(24),
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
        margin: Margins.only(top: 28, bottom: 14),
        fontFamily: 'Poppins',
      ),
      "h3": Style(
        fontSize: FontSize(20),
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
        margin: Margins.only(top: 24, bottom: 12),
        fontFamily: 'Poppins',
      ),
      "h4, h5, h6": Style(
        fontSize: FontSize(18),
        fontWeight: FontWeight.w500,
        color: Theme.of(context).colorScheme.onSurface,
        margin: Margins.only(top: 20, bottom: 10),
        fontFamily: 'Poppins',
      ),

      // Paragraphs
      "p": Style(
        fontSize: FontSize(18),
        lineHeight: const LineHeight(1.8),
        margin: Margins.only(bottom: 20),
        color: Theme.of(context).colorScheme.onSurface,
        fontFamily: 'Source Serif Pro',
      ),

      // Links
      "a": Style(
        color: Theme.of(context).colorScheme.primary,
        textDecoration: TextDecoration.underline,
        textDecorationColor: Theme.of(
          context,
        ).colorScheme.primary.withValues(alpha: 0.5),
      ),

      // Blockquotes
      "blockquote": Style(
        border: Border(
          left: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 4,
          ),
        ),
        padding: HtmlPaddings.only(left: 20, top: 16, bottom: 16, right: 16),
        margin: Margins.symmetric(vertical: 24),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        fontSize: FontSize(18),
        fontStyle: FontStyle.italic,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontFamily: 'Source Serif Pro',
      ),

      // Code blocks
      "pre": Style(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        padding: HtmlPaddings.all(16),
        margin: Margins.symmetric(vertical: 16),
        fontSize: FontSize(14),
        fontFamily: 'JetBrains Mono',
        color: Theme.of(context).colorScheme.onSurface,
      ),
      "code": Style(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        padding: HtmlPaddings.symmetric(horizontal: 6, vertical: 2),
        fontSize: FontSize(16),
        fontFamily: 'JetBrains Mono',
        color: Theme.of(context).colorScheme.primary,
      ),

      // Lists
      "ul, ol": Style(
        margin: Margins.only(bottom: 16, left: 20),
        padding: HtmlPaddings.zero,
      ),
      "li": Style(
        margin: Margins.only(bottom: 8),
        fontSize: FontSize(18),
        lineHeight: const LineHeight(1.6),
        fontFamily: 'Source Serif Pro',
      ),

      // Images
      "img": Style(margin: Margins.symmetric(vertical: 16)),

      // Tables
      "table": Style(
        margin: Margins.symmetric(vertical: 16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      "th": Style(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        padding: HtmlPaddings.all(12),
        fontWeight: FontWeight.w600,
        fontSize: FontSize(16),
        fontFamily: 'Inter',
      ),
      "td": Style(
        padding: HtmlPaddings.all(12),
        fontSize: FontSize(16),
        fontFamily: 'Inter',
      ),

      // Emphasis
      "strong, b": Style(fontWeight: FontWeight.w700),
      "em, i": Style(fontStyle: FontStyle.italic),

      // Horizontal rule
      "hr": Style(
        margin: Margins.symmetric(vertical: 32),
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
    };
  }
}
