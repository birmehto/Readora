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
    final theme = Theme.of(context);

    return AppScaffold(
      appBar: AppAppBar(
        title: controller.articleTitle,

        // ✅ Correct PreferredSize usage
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Obx(() {
            if (!controller.isLoading.value || controller.isInitialLoad.value) {
              return const SizedBox.shrink();
            }

            return LinearProgressIndicator(
              value: controller.loadingProgress.value,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
            );
          }),
        ),

        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                controller.isFavorite.value
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: controller.isFavorite.value
                    ? theme.colorScheme.error
                    : null,
              ),
              tooltip: controller.isFavorite.value
                  ? 'Remove from Favorites'
                  : 'Add to Favorites',
              onPressed: controller.toggleFavorite,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.share_rounded),
            tooltip: 'Share',
            onPressed: controller.shareArticle,
          ),
        ],
      ),

      // ---------- BODY ----------
      body: Stack(
        children: [
          // WebView (never unmounts)
          Obx(() => ArticleWebView(url: controller.currentUrl.value)),

          // Error overlay
          Obx(() {
            if (controller.errorMessage.isEmpty) {
              return const SizedBox.shrink();
            }

            return _ErrorOverlay(
              message: controller.errorMessage.value,
              onRetry: controller.requestRefresh,
              onOpenBrowser: controller.openInBrowser,
            );
          }),

          // Initial loading overlay
          Obx(
            () => controller.isInitialLoad.value
                ? const Positioned.fill(child: AppLoading())
                : const SizedBox.shrink(),
          ),
        ],
      ),

      // ---------- BOTTOM BAR ----------
      bottomNavigationBar: _BottomBar(
        onSettings: () => _showReadingSettings(context),
        onRefresh: controller.requestRefresh,
        onCopy: controller.copyLink,
        onBrowser: controller.openInBrowser,
      ),
    );
  }

  void _showReadingSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const ReadingSettingsSheet(),
    );
  }
}

/// ---------- Error Overlay ----------
class _ErrorOverlay extends StatelessWidget {
  const _ErrorOverlay({
    required this.message,
    required this.onRetry,
    required this.onOpenBrowser,
  });
  final String message;
  final VoidCallback onRetry;
  final VoidCallback onOpenBrowser;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ArticleError(
          message: message,
          onRetry: onRetry,
          onOpenBrowser: onOpenBrowser,
        ),
      ),
    );
  }
}

/// ---------- Bottom Bar ----------
class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.onSettings,
    required this.onRefresh,
    required this.onCopy,
    required this.onBrowser,
  });
  final VoidCallback onSettings;
  final VoidCallback onRefresh;
  final VoidCallback onCopy;
  final VoidCallback onBrowser;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.settings_suggest_rounded),
            tooltip: 'Reading Settings',
            onPressed: onSettings,
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            onPressed: onRefresh,
          ),
          IconButton(
            icon: const Icon(Icons.copy_rounded),
            tooltip: 'Copy Link',
            onPressed: onCopy,
          ),
          IconButton(
            icon: const Icon(Icons.open_in_browser_rounded),
            tooltip: 'Open in Browser',
            onPressed: onBrowser,
          ),
        ],
      ),
    );
  }
}
