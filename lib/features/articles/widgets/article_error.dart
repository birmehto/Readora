import 'package:flutter/material.dart';

class ArticleError extends StatelessWidget {
  const ArticleError({
    required this.message,
    super.key,
    this.onRetry,
    this.onOpenBrowser,
  });
  final String message;
  final VoidCallback? onRetry;
  final VoidCallback? onOpenBrowser;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),

            Text(
              'Failed to Load Article',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Action buttons
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                if (onRetry != null)
                  FilledButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),

                if (onOpenBrowser != null)
                  OutlinedButton.icon(
                    onPressed: onOpenBrowser,
                    icon: const Icon(Icons.open_in_browser),
                    label: const Text('Open in Browser'),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // Help text
            Text(
              'Try refreshing or opening the article in your browser',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
