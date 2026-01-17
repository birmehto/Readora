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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Obx(() {
            final show =
                controller.isLoading.value && !controller.isInitialLoad.value;
            return show
                ? LinearProgressIndicator(
                    value: controller.loadingProgress.value,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation(
                      theme.colorScheme.primary,
                    ),
                  )
                : const SizedBox.shrink();
          }),
        ),
        actions: [
          Obx(() {
            final isFav = controller.isFavorite.value;
            return IconButton(
              icon: Icon(
                isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: isFav ? theme.colorScheme.error : null,
              ),
              tooltip: isFav ? 'Remove from Favorites' : 'Add to Favorites',
              onPressed: controller.toggleFavorite,
            );
          }),
          IconButton(
            icon: const Icon(Icons.share_rounded),
            tooltip: 'Share',
            onPressed: controller.shareArticle,
          ),
        ],
      ),

      body: Stack(
        children: [
          Obx(() => ArticleWebView(url: controller.currentUrl.value)),

          Obx(() {
            final msg = controller.errorMessage.value;
            return msg.isEmpty
                ? const SizedBox.shrink()
                : Positioned.fill(
                    child: Material(
                      color: theme.scaffoldBackgroundColor,
                      child: ArticleError(
                        message: msg,
                        onRetry: controller.requestRefresh,
                        onOpenBrowser: controller.openInBrowser,
                      ),
                    ),
                  );
          }),

          Obx(
            () => controller.isInitialLoad.value
                ? const Positioned.fill(child: AppLoading())
                : const SizedBox.shrink(),
          ),
        ],
      ),

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
      useSafeArea: true,
      isScrollControlled: true,
      builder: (_) => const ReadingSettingsSheet(),
    );
  }
}

// ─────────────────────────────────────────────

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
          _btn(Icons.settings_suggest_rounded, 'Reading Settings', onSettings),
          _btn(Icons.refresh_rounded, 'Refresh', onRefresh),
          _btn(Icons.copy_rounded, 'Copy Link', onCopy),
          _btn(Icons.open_in_browser_rounded, 'Open in Browser', onBrowser),
        ],
      ),
    );
  }

  Widget _btn(IconData icon, String tip, VoidCallback onTap) {
    return IconButton(icon: Icon(icon), tooltip: tip, onPressed: onTap);
  }
}
