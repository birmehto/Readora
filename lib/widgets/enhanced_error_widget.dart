import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/constants/app_spacing.dart';
import '../core/constants/app_typography.dart';

class EnhancedErrorWidget extends StatelessWidget {
  final String error;
  final VoidCallback? onRetry;
  final String? retryButtonText;
  final IconData? errorIcon;

  const EnhancedErrorWidget({
    super.key,
    required this.error,
    this.onRetry,
    this.retryButtonText,
    this.errorIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Theme.of(context).colorScheme.error.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Error icon with animation
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.error.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    errorIcon ?? Icons.error_outline,
                    size: 40.sp,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              );
            },
          ),

          SizedBox(height: AppSpacing.lg),

          // Error title
          Text(
            'Oops! Something went wrong',
            style: AppTypography.titleLarge(
              context,
            ).copyWith(color: Theme.of(context).colorScheme.error),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: AppSpacing.md),

          // Error message
          Text(
            error,
            style: AppTypography.bodyMedium(context).copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),

          if (onRetry != null) ...[
            SizedBox(height: AppSpacing.xl),

            // Retry button
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(retryButtonText ?? 'Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ],

          SizedBox(height: AppSpacing.md),

          // Help text
          Container(
            padding: EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: 16.sp,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: AppSpacing.xs),
                Text(
                  'Make sure the URL is a valid Medium article',
                  style: AppTypography.bodySmall(
                    context,
                  ).copyWith(color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NetworkErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const NetworkErrorWidget({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return EnhancedErrorWidget(
      error:
          'No internet connection available. Please check your network settings and try again.',
      errorIcon: Icons.wifi_off,
      onRetry: onRetry,
      retryButtonText: 'Check Connection',
    );
  }
}

class PaywallErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const PaywallErrorWidget({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return EnhancedErrorWidget(
      error:
          'This article appears to be behind a paywall that cannot be bypassed. Try a different article.',
      errorIcon: Icons.lock_outline,
      onRetry: onRetry,
      retryButtonText: 'Try Different Article',
    );
  }
}
