import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../shared/extensions/context_ext.dart';
import '../../../shared/widgets/app_appbar.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../history/widgets/history_list_item.dart';
import '../controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppScaffold(
      appBar: AppAppBar(
        title: 'Readora',
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            onPressed: () => Get.toNamed(AppRoutes.history),
            tooltip: 'History',
          ),
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => Get.toNamed(AppRoutes.settings),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32),
            // Header Section
            Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(
                    alpha: 0.3,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.auto_stories_rounded,
                  size: 64,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Read Medium Articles',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Unlock premium content instantly. Just paste the URL below.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),

            // Input Section
            Obx(
              () => TextField(
                controller: controller.urlController,
                style: theme.textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'Paste article URL...',
                  hintStyle: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.7,
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.link_rounded,
                    color: theme.colorScheme.primary,
                  ),
                  suffixIcon: controller.urlText.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded),
                          onPressed: controller.clearUrl,
                        )
                      : IconButton(
                          icon: const Icon(Icons.content_paste_rounded),
                          onPressed: controller.pasteFromClipboard,
                          tooltip: 'Paste',
                        ),
                  errorText: controller.errorMessage.isNotEmpty
                      ? controller.errorMessage.value
                      : null,
                ),
                onChanged: controller.onUrlChanged,
                onSubmitted: (_) => controller.openArticle(),
              ),
            ),
            const SizedBox(height: 24),

            // Action Button
            Obx(
              () => AppButton(
                onPressed: () {
                  context.unfocus();
                  controller.openArticle();
                },
                size: AppButtonSize.large,
                isLoading: controller.isLoading.value,
                text: 'Read Article',
              ),
            ),

            // Recent History Section
            Obx(() {
              if (controller.recentHistory.isEmpty)
                return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 48),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      'Recent Articles',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...controller.recentHistory.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: HistoryListItem(item: item),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
