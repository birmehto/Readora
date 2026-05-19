import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_button.dart';

class ArticleError extends StatelessWidget {
  const ArticleError({
    required this.message,
    super.key,
    this.onRetry,
    this.onOpenBrowser,
    this.onSwitchEngine,
  });

  final String message;
  final VoidCallback? onRetry;
  final VoidCallback? onOpenBrowser;
  final VoidCallback? onSwitchEngine;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 64, color: c.error),
            const SizedBox(height: 20),

            Text(
              'Failed to Load Article',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: c.error,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: c.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            if (onRetry != null)
              AppButton(
                text: 'Retry',
                size: AppButtonSize.large,
                icon: Icons.refresh_rounded,
                onPressed: onRetry!,
              ),

            if (onSwitchEngine != null) ...[
              const SizedBox(height: 12),
              AppButton(
                text: 'Try Alternative Engine',
                size: AppButtonSize.large,
                icon: Icons.swap_horizontal_circle_rounded,
                variant: AppButtonVariant.elevated,
                onPressed: onSwitchEngine!,
              ),
            ],

            const SizedBox(height: 12),

            if (onOpenBrowser != null)
              AppButton(
                text: 'Open in Browser',
                size: AppButtonSize.large,
                icon: Icons.open_in_browser_rounded,
                variant: AppButtonVariant.outlined,
                onPressed: onOpenBrowser!,
              ),

            const SizedBox(height: 20),

            Text(
              'Try refreshing, switching reading engines, or opening the article in your browser.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: c.onSurfaceVariant.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
