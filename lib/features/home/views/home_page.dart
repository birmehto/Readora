import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../shared/extensions/context_ext.dart';
import '../../../shared/widgets/app_animations.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_textfield.dart';
import '../../../shared/widgets/background_painter.dart';
import '../controllers/home_controller.dart';
import '../widgets/home_widgets.dart' hide ScaleIn;

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: MeshGradientBackground(
        child: CustomScrollView(
          slivers: [
            // ---------------- AppBar ----------------
            SliverAppBar.medium(
              title: Text(
                'Readora',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              centerTitle: true,
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
              padding: const EdgeInsets.symmetric(horizontal: 28),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 30),

                  // Header Icon
                  const ScaleIn(
                    delay: Duration(milliseconds: 100),
                    child: Center(
                      child: Hero(tag: 'article_icon', child: HomeHeaderIcon()),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Title
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 200),
                    child: Text(
                      'Read Freely',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1.5,
                        height: 1.0,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Subtitle
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 300),
                    child: Text(
                      'Unlock premium Medium content instantly.\nNo limits. No paywalls.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.7,
                        ),
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // URL Input (AppTextField)
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 400),
                    child: Obx(() {
                      final hasText = controller.urlText.isNotEmpty;

                      return AppTextField(
                        controller: controller.urlController,
                        hint: 'Paste Medium URL here...',
                        onChanged: controller.onUrlChanged,
                        onSubmitted: (_) => controller.openArticle(),
                        errorText: controller.errorMessage.value.isEmpty
                            ? null
                            : controller.errorMessage.value,
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

                  const SizedBox(height: 24),

                  // Read Button
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 500),
                    child: Obx(
                      () => TapScale(
                        child: AppButton(
                          size: AppButtonSize.large,
                          text: 'Unlock Article',
                          icon: Icons.bolt_rounded,
                          isLoading: controller.isLoading.value,
                          backgroundColor: theme.colorScheme.primary,
                          onPressed: () {
                            context.unfocus();
                            controller.openArticle();
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 64),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
