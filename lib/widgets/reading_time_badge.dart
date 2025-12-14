import 'package:flutter/material.dart';
import '../core/constants/app_spacing.dart';
import '../core/constants/app_typography.dart';

class ReadingTimeBadge extends StatelessWidget {
  final int readingTime;
  final Color? backgroundColor;
  final Color? textColor;

  const ReadingTimeBadge({
    super.key,
    required this.readingTime,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color:
            backgroundColor ?? Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$readingTime min read',
        style: AppTypography.bodySmall(context).copyWith(
          color: textColor ?? Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}
