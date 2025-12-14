import 'package:flutter/material.dart';
import 'package:free/core/core.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../article/model.dart';
import '../../article/controller/article_controller.dart';
import '../controller/reading_history_controller.dart';
import '../../../widgets/widgets.dart';

class HistoryView extends GetView<ReadingHistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: CustomScrollView(
          slivers: [
            SliverAppBar.medium(
              title: Text(
                'History',
                style: AppTypography.headlineMedium(context),
              ),
              bottom: TabBar(
                tabs: const [
                  Tab(text: 'Recent', icon: Icon(Icons.history)),
                  Tab(text: 'Favorites', icon: Icon(Icons.favorite)),
                ],
                labelStyle: AppTypography.titleSmall(context),
              ),
              actions: [
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'clear_history') {
                      _showClearHistoryDialog(context);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'clear_history',
                      child: Row(
                        children: [
                          Icon(Icons.clear_all),
                          SizedBox(width: 8),
                          Text('Clear History'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SliverFillRemaining(
              child: TabBarView(
                children: [
                  _buildHistoryTab(context),
                  _buildFavoritesTab(context),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Get.offAllNamed('/'),
          icon: const Icon(Icons.add),
          label: const Text('Read Article'),
        ),
      ),
    );
  }

  Widget _buildHistoryTab(BuildContext context) {
    return Obx(() {
      if (controller.history.isEmpty) {
        return EmptyStateWidget(
          title: 'No articles read yet',
          subtitle: 'Articles you read will appear here',
          icon: Icons.history_outlined,
        );
      }

      return CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildStatsSection(context)),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final article = controller.history[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child:
                    HistoryArticleCard(
                          article: article,
                          onTap: () => _openArticle(article),
                          onMenuAction: (action) =>
                              _handleMenuAction(action, article),
                          isFavorite: controller.isFavorite(article),
                          showRemoveAction: true,
                        )
                        .animate(delay: (index * 100).ms)
                        .fadeIn(duration: 500.ms)
                        .slideX(begin: 0.3, end: 0),
              );
            }, childCount: controller.history.length),
          ),
        ],
      );
    });
  }

  Widget _buildFavoritesTab(BuildContext context) {
    return Obx(() {
      if (controller.favorites.isEmpty) {
        return EmptyStateWidget(
          title: 'No favorites yet',
          subtitle: 'Tap the heart icon on articles to save them here',
          icon: Icons.favorite_outline,
        );
      }

      return ListView.builder(
        padding: EdgeInsets.all(AppSpacing.lg),
        itemCount: controller.favorites.length,
        itemBuilder: (context, index) {
          final article = controller.favorites[index];
          return HistoryArticleCard(
                article: article,
                onTap: () => _openArticle(article),
                onMenuAction: (action) => _handleMenuAction(action, article),
                isFavorite: true,
                showRemoveAction: false,
              )
              .animate(delay: (index * 100).ms)
              .fadeIn(duration: 500.ms)
              .slideX(begin: 0.3, end: 0);
        },
      );
    });
  }

  void _openArticle(Article article) {
    final articleController = Get.find<ArticleController>();
    articleController.setArticle(article);
    Get.toNamed('/article');
  }

  void _handleMenuAction(String action, Article article) {
    switch (action) {
      case 'favorite':
        controller.toggleFavorite(article);
        break;
      case 'remove':
        controller.removeFromHistory(article);
        Get.snackbar(
          'Removed',
          'Article removed from history',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        break;
    }
  }

  void _showClearHistoryDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Clear History'),
        content: const Text(
          'Are you sure you want to clear all reading history? This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              controller.clearHistory();
              Get.back();
              Get.snackbar(
                'Cleared',
                'Reading history cleared',
                snackPosition: SnackPosition.BOTTOM,
                duration: const Duration(seconds: 2),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.analytics_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Text(
                    'Reading Stats',
                    style: AppTypography.titleMedium(context),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.md),
              StatsRow(
                stats: [
                  StatItem(
                    label: 'Articles Read',
                    value: controller.totalArticlesRead.toString(),
                    icon: Icons.article_outlined,
                  ),
                  StatItem(
                    label: 'Favorites',
                    value: controller.totalFavorites.toString(),
                    icon: Icons.favorite_outline,
                  ),
                  StatItem(
                    label: 'Reading Time',
                    value: '${controller.totalReadingTime} min',
                    icon: Icons.schedule_outlined,
                  ),
                ],
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0),
    );
  }
}
