import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../shared/extensions/context_ext.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_textfield.dart';
import '../controllers/home_controller.dart';
import '../widgets/home_widgets.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Readora',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          children: [
            const SizedBox(height: 30),

            const Center(
              child: Hero(tag: 'article_icon', child: HomeHeaderIcon()),
            ),

            const SizedBox(height: 30),

            Text(
              'Read Freely',
              textAlign: TextAlign.center,
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: -1.5,
                height: 1.0,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              'Unlock premium Medium content instantly.\nNo limits. No paywalls.',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                height: 1.5,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.7,
                ),
              ),
            ),

            const SizedBox(height: 30),

            Obx(() {
              final hasText = controller.urlText.isNotEmpty;
              final error = controller.errorMessage.value.isEmpty
                  ? null
                  : controller.errorMessage.value;

              return AppTextField(
                controller: controller.urlController,
                hint: 'Paste Medium URL here...',
                onSubmitted: (_) => controller.openArticle(),
                errorText: error,
                suffixIcon: IconButton(
                  icon: Icon(
                    hasText ? Icons.clear_rounded : Icons.content_paste_rounded,
                    size: 20,
                  ),
                  onPressed: hasText
                      ? controller.clearUrl
                      : controller.pasteFromClipboard,
                ),
              );
            }),

            const SizedBox(height: 24),

            Obx(
              () => AppButton(
                size: AppButtonSize.large,
                text: 'Unlock Article',
                icon: Icons.bolt_rounded,
                isLoading: controller.isLoading.value,
                onPressed: () {
                  context.unfocus();
                  controller.openArticle();
                },
              ),
            ),

            const SizedBox(height: 64),
          ],
        ),
      ),
    );
  }
}
