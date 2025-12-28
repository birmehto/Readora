import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../shared/extensions/context_ext.dart';
import '../../../shared/widgets/app_animations.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_textfield.dart';
import '../controllers/home_controller.dart';
import '../widgets/home_widgets.dart' hide ScaleIn;

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          // ---------------- AppBar ----------------
          SliverAppBar.medium(
            title: const Text('Readora'),
            actions: [
              IconButton(
                icon: const Icon(Icons.favorite_rounded),
                onPressed: () => Get.toNamed(AppRoutes.favorites),
              ),
              IconButton(
                icon: const Icon(Icons.settings_rounded),
                onPressed: () => Get.toNamed(AppRoutes.settings),
              ),
              const SizedBox(width: 8),
            ],
          ),

          // ---------------- Content ----------------
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 20),

                // Header Icon
                const ScaleIn(
                  delay: Duration(milliseconds: 100),
                  child: Center(
                    child: Hero(tag: 'article_icon', child: HomeHeaderIcon()),
                  ),
                ),

                const SizedBox(height: 24),

                // Title
                FadeSlideIn(
                  delay: const Duration(milliseconds: 200),
                  child: Text(
                    'Read Freely',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: -1,
                      height: 1.1,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Subtitle
                FadeSlideIn(
                  delay: const Duration(milliseconds: 300),
                  child: Text(
                    'Unlock premium content instantly.\nJust paste the URL below.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.8,
                      ),
                      height: 1.4,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // URL Input (AppTextField)
                FadeSlideIn(
                  delay: const Duration(milliseconds: 400),
                  child: Obx(() {
                    final hasText = controller.urlText.isNotEmpty;

                    return AppTextField(
                      controller: controller.urlController,
                      hint: 'Paste article URL...',
                      onChanged: controller.onUrlChanged,
                      onSubmitted: (_) => controller.openArticle(),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: IconButton(
                          icon: Icon(
                            hasText
                                ? Icons.clear_rounded
                                : Icons.content_paste_rounded,
                            size: 20,
                          ),
                          onPressed: hasText
                              ? controller.clearUrl
                              : controller.pasteFromClipboard,
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 20),

                // Read Button
                FadeSlideIn(
                  delay: const Duration(milliseconds: 500),
                  child: Obx(
                    () => AppButton(
                      size: AppButtonSize.large,
                      text: 'Read Now',
                      isLoading: controller.isLoading.value,
                      backgroundColor: theme.colorScheme.primary,
                      onPressed: () {
                        context.unfocus();
                        controller.openArticle();
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 48),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
