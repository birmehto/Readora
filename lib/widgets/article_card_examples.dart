import 'package:flutter/material.dart';
import '../features/article/model.dart';
import 'widgets.dart';

/// Example usage of different article card variants
class ArticleCardExamples extends StatelessWidget {
  final Article sampleArticle;

  const ArticleCardExamples({super.key, required this.sampleArticle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Article Card Examples')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Featured Article Card
            const Text(
              'Featured Article Card',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            FeaturedArticleCard(
              article: sampleArticle,
              onTap: () => _handleArticleTap(context, 'Featured'),
              onBookmark: () => _handleBookmark(context),
              onShare: () => _handleShare(context),
              isBookmarked: false,
            ),

            const SizedBox(height: 32),

            // Regular Article Card
            const Text(
              'Regular Article Card',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ArticleCard(
              article: sampleArticle,
              onTap: () => _handleArticleTap(context, 'Regular'),
              onBookmark: () => _handleBookmark(context),
              onShare: () => _handleShare(context),
              isBookmarked: true,
              showActions: true,
            ),

            const SizedBox(height: 32),

            // Compact Article Cards
            const Text(
              'Compact Article Cards',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...List.generate(
              3,
              (index) => CompactArticleCard(
                article: sampleArticle,
                onTap: () => _handleArticleTap(context, 'Compact $index'),
                onBookmark: () => _handleBookmark(context),
                isBookmarked: index == 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleArticleTap(BuildContext context, String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Tapped $type article: ${sampleArticle.title}')),
    );
  }

  void _handleBookmark(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Bookmark toggled')));
  }

  void _handleShare(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Article shared')));
  }
}

/// Sample article data for testing
Article get sampleArticle => const Article(
  title: 'I Tried Writing Modern C in 2025—Here\'s What Shocked Me',
  author: 'Tech Writer',
  content: 'This is a sample article content...',
  subtitle: 'Exploring the evolution of C programming in modern development',
  publishedDate: null,
  originalUrl: 'https://example.com/article',
  imageUrl: 'https://via.placeholder.com/800x400',
  authorImageUrl: 'https://via.placeholder.com/100x100',
  readingTime: 8,
  tags: ['Programming', 'C Language', 'Modern Development', 'Technology'],
);
