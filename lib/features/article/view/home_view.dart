import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:free/core/core.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/utils/share_helper.dart';
import '../../../widgets/widgets.dart';
import '../controller/article_controller.dart';

class HomeView extends GetView<ArticleController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final urlController = TextEditingController();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: Text(
              'Article Reader',
              style: AppTypography.headlineMedium(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.history_outlined),
                onPressed: () => Get.toNamed((AppRoutes.history)),
                tooltip: 'History',
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () => Get.toNamed(AppRoutes.settings),
                tooltip: 'Settings',
              ),
              const SizedBox(width: 8),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildUrlInputSection(context, urlController),
                  SizedBox(height: AppSpacing.xl),
                  _buildContentSection(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUrlInputSection(
    BuildContext context,
    TextEditingController urlController,
  ) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lock_open,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Read Article via Freedium',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Paste any Medium URL to access premium content',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: urlController,
              decoration: InputDecoration(
                hintText: 'https://medium.com/article-url',
                prefixIcon: const Icon(Icons.link),
                helperText: '🔓 Premium content will be unlocked via Freedium',
                helperStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 12,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.paste),
                  onPressed: () async {
                    final data = await Clipboard.getData(Clipboard.kTextPlain);
                    if (data?.text != null) {
                      urlController.text = data!.text!;
                      controller.setUrlInput(data.text!);
                    }
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
              onChanged: controller.setUrlInput,
              onSubmitted: (val) => controller.fetchArticle(val),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => controller.fetchArticle(urlController.text),
              icon: const Icon(Icons.lock_open),
              label: const Text('Unlock & Read via Freedium'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildContentSection(BuildContext context) {
    return Obx(() {
      if (controller.isLoading) {
        return const Center(
          child: ArticleLoadingAnimation(message: 'Fetching your article...'),
        );
      } else if (controller.error != null) {
        return EnhancedErrorWidget(
          error: controller.error!,
          onRetry: controller.retryLastFetch,
        );
      } else {
        return _buildEmptyState(context);
      }
    });
  }

  Widget _buildEmptyState(BuildContext context) {
    return Column(
      children: [
        EmptyStateWidget(
          title: 'Ready to Read',
          subtitle: 'Paste a URL to start reading',
          icon: Icons.article_outlined,
          iconSize: 64,
        ),
        SizedBox(height: AppSpacing.xl),
        _buildSampleArticles(context),
      ],
    );
  }

  Widget _buildSampleArticles(BuildContext context) {
    return Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.surfaceContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Try Deep Linking',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                Text(
                  'Share these sample URLs to test the deep linking feature:',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: AppSpacing.lg),
                _buildSampleUrlCard(
                  context,
                  'Medium Article',
                  'https://medium.com/@example/sample-article',
                  Icons.article,
                ),
                SizedBox(height: AppSpacing.sm),
                _buildSampleUrlCard(
                  context,
                  'Dev.to Post',
                  'https://dev.to/example/sample-post',
                  Icons.code,
                ),
                SizedBox(height: AppSpacing.sm),
                _buildSampleUrlCard(
                  context,
                  'Substack Newsletter',
                  'https://example.substack.com/p/sample-newsletter',
                  Icons.email,
                ),
                SizedBox(height: AppSpacing.lg),
                ElevatedButton.icon(
                  onPressed: _testHtmlParsing,
                  icon: const Icon(Icons.science),
                  label: const Text('Test Improved Parser'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Theme.of(context).colorScheme.onSecondary,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        .animate(delay: 300.ms)
        .fadeIn(duration: 600.ms)
        .slideY(begin: 0.1, end: 0);
  }

  Widget _buildSampleUrlCard(
    BuildContext context,
    String title,
    String url,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  url,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _shareUrl(url, title),
            icon: const Icon(Icons.share),
            tooltip: 'Share URL',
          ),
        ],
      ),
    );
  }

  void _shareUrl(String url, String title) async {
    await ShareHelper.shareUrl(url, title: title);
  }

  void _testHtmlParsing() async {
    try {
      Get.snackbar(
        'Testing Parser',
        'Testing improved HTML parsing...',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      // Show a dialog with test options
      Get.dialog(
        AlertDialog(
          title: const Text('Test Article Parser'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Choose a test option:'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                  controller.fetchArticle(
                    'https://medium.com/@workflow094093/the-code-i-stopped-writing-as-a-flutter-developer-and-what-i-use-instead-e3106cf4f8a0',
                  );
                },
                child: const Text('Test Medium Article (Freedium)'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                  controller.fetchArticle(
                    'https://medium.com/better-programming/advanced-flutter-techniques-for-production-apps-7b6c8c8c8c8c',
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Test Premium Medium Article'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                  controller.fetchArticle('https://dev.to/example/sample-post');
                },
                child: const Text('Test Dev.to Article'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                  _showUrlInputDialog();
                },
                child: const Text('Test Custom URL'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      );
    } catch (e) {
      Get.snackbar(
        'Test Error',
        'Error testing parser: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  void _showUrlInputDialog() {
    final urlController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Test Custom URL'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter an article URL to test:'),
            const SizedBox(height: 16),
            TextField(
              controller: urlController,
              decoration: const InputDecoration(
                hintText: 'https://example.com/article',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final url = urlController.text.trim();
              if (url.isNotEmpty) {
                Get.back();
                controller.fetchArticle(url);
              }
            },
            child: const Text('Test'),
          ),
        ],
      ),
    );
  }
}
