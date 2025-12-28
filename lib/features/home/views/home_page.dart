import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../shared/extensions/context_ext.dart';
import '../../../shared/widgets/app_animations.dart';
import '../../../shared/widgets/app_button.dart';
import '../controllers/home_controller.dart';
import '../widgets/home_widgets.dart' hide ScaleIn;

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          const HomeBackground(),
          CustomScrollView(
            slivers: [
              // Material 3 Expressive Medium AppBar
              SliverAppBar.medium(
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                stretch: true,
                title: const Text('Readora'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.favorite_rounded),
                    onPressed: () => Get.toNamed(AppRoutes.favorites),
                    tooltip: 'Favorites',
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings_rounded),
                    onPressed: () => Get.toNamed(AppRoutes.settings),
                    tooltip: 'Settings',
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              // Main Content
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 16),
                    // Header Section with animations
                    const ScaleIn(
                      delay: Duration(milliseconds: 100),
                      child: Center(
                        child: Hero(
                          tag: 'article_icon',
                          child: HomeHeaderIcon(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 200),
                      child: Text(
                        'Read Medium\nArticles',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1.0,
                          color: theme.colorScheme.onSurface,
                          height: 1.1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 12),
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 300),
                      child: Text(
                        'Unlock premium content instantly.\nJust paste the URL below.',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.8,
                          ),
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Input Section
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 400),
                      child: Obx(
                        () => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: controller.urlText.isNotEmpty
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.outlineVariant.withValues(
                                      alpha: 0.5,
                                    ),
                              width: 1.5,
                            ),
                          ),
                          child: TextField(
                            controller: controller.urlController,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Paste article URL...',
                              filled: true,
                              fillColor: theme.colorScheme.surface.withValues(
                                alpha: 0.8,
                              ),
                              hintStyle: TextStyle(
                                color: theme.colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.5),
                              ),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(left: 4.0),
                                child: Icon(Icons.link_rounded, size: 24),
                              ),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: controller.urlText.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(
                                          Icons.clear_rounded,
                                          size: 20,
                                        ),
                                        onPressed: controller.clearUrl,
                                      )
                                    : IconButton(
                                        icon: const Icon(
                                          Icons.content_paste_rounded,
                                          size: 20,
                                        ),
                                        onPressed:
                                            controller.pasteFromClipboard,
                                        tooltip: 'Paste',
                                      ),
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              errorText: controller.errorMessage.isNotEmpty
                                  ? controller.errorMessage.value
                                  : null,
                            ),
                            onChanged: controller.onUrlChanged,
                            onSubmitted: (_) => controller.openArticle(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Action Button
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 500),
                      child: Obx(
                        () => AppButton(
                          onPressed: () {
                            context.unfocus();
                            controller.openArticle();
                          },
                          size: AppButtonSize.medium,
                          isLoading: controller.isLoading.value,
                          text: 'Read Now',
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                  ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
