import 'package:flutter/material.dart';
import '../features/article/model.dart';
import 'widgets.dart';

/// Simple demo showing how to use the article cards
class SimpleArticleCardDemo extends StatelessWidget {
  const SimpleArticleCardDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final sampleArticle = Article(
      title: 'I Tried Writing Modern C in 2025—Here\'s What Shocked Me',
      author: 'Tech Writer',
      content: 'This is a sample article content...',
      subtitle:
          'Exploring the evolution of C programming in modern development',
      publishedDate: DateTime.now().subtract(const Duration(days: 2)),
      originalUrl: 'https://example.com/article',
      imageUrl: null, // No image for simplicity
      authorImageUrl: null,
      readingTime: 8,
      tags: ['Programming', 'C Language', 'Technology'],
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Article Cards Demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Regular Article Card
            const Text(
              'Regular Article Card',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ArticleCard(
              article: sampleArticle,
              onTap: () => _showMessage(context, 'Article tapped'),
              onBookmark: () => _showMessage(context, 'Bookmark toggled'),
              onShare: () => _showMessage(context, 'Article shared'),
              isBookmarked: false,
              showActions: true,
            ),

            const SizedBox(height: 32),

            // Compact Article Card
            const Text(
              'Compact Article Card',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CompactArticleCard(
              article: sampleArticle,
              onTap: () => _showMessage(context, 'Compact article tapped'),
              onBookmark: () => _showMessage(context, 'Bookmark toggled'),
              isBookmarked: true,
            ),

            const SizedBox(height: 32),

            // Featured Article Card
            const Text(
              'Featured Article Card',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            FeaturedArticleCard(
              article: sampleArticle,
              onTap: () => _showMessage(context, 'Featured article tapped'),
              onBookmark: () => _showMessage(context, 'Bookmark toggled'),
              onShare: () => _showMessage(context, 'Article shared'),
              isBookmarked: false,
            ),
          ],
        ),
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }
}
