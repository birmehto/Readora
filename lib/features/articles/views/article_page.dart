import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/app_appbar.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../controllers/article_controller.dart';
import '../widgets/article_error.dart';
import '../widgets/article_webview.dart';
import '../widgets/loading.dart';
import '../widgets/reading_settings_sheet.dart';

class ArticlePage extends GetView<ArticleController> {
  const ArticlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppScaffold(
        appBar: AppAppBar(
          title: controller.articleTitle,
          bottom: controller.isLoading.value && !controller.isInitialLoad.value
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(4),
                  child: LinearProgressIndicator(
                    value: controller.loadingProgress.value,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                )
              : null,
          actions: [
            IconButton(
              icon: Icon(
                controller.isFavorite.value
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: controller.isFavorite.value
                    ? Theme.of(context).colorScheme.error
                    : null,
              ),
              tooltip: controller.isFavorite.value
                  ? 'Remove from Favorites'
                  : 'Add to Favorites',
              onPressed: controller.toggleFavorite,
            ),
            IconButton(
              icon: const Icon(Icons.share_rounded),
              tooltip: 'Share',
              onPressed: controller.shareArticle,
            ),
          ],
        ),
        body: Stack(
          children: [
            // WebView (stable, always mounted)
            ArticleWebView(url: controller.currentUrl.value),

            // State overlays
            if (controller.errorMessage.isNotEmpty)
              Positioned.fill(
                child: Material(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: ArticleError(
                    message: controller.errorMessage.value,
                    onRetry: controller.requestRefresh,
                    onOpenBrowser: controller.openInBrowser,
                  ),
                ),
              ),

            if (controller.isInitialLoad.value)
              const Positioned.fill(child: AppLoading()),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.settings_suggest_rounded),
                onPressed: () => _showReadingSettings(context),
                tooltip: 'Reading Settings',
              ),
              IconButton(
                icon: const Icon(Icons.refresh_rounded),
                onPressed: controller.requestRefresh,
                tooltip: 'Refresh',
              ),
              IconButton(
                icon: const Icon(Icons.copy_rounded),
                onPressed: controller.copyLink,
                tooltip: 'Copy Link',
              ),
              IconButton(
                icon: const Icon(Icons.open_in_browser_rounded),
                onPressed: controller.openInBrowser,
                tooltip: 'Open in Browser',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReadingSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ReadingSettingsSheet(),
    );
  }
}
