import 'package:flutter/material.dart';
import '../core/constants/app_spacing.dart';
import '../core/constants/app_typography.dart';

class TagChip extends StatelessWidget {
  final String tag;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onTap;

  const TagChip({
    super.key,
    required this.tag,
    this.backgroundColor,
    this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final widget = Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color:
            backgroundColor ?? Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        tag,
        style: AppTypography.bodySmall(context).copyWith(
          color: textColor ?? Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: widget,
      );
    }

    return widget;
  }
}

class TagsWrap extends StatelessWidget {
  final List<String> tags;
  final int maxTags;
  final Color? backgroundColor;
  final Color? textColor;
  final Function(String)? onTagTap;

  const TagsWrap({
    super.key,
    required this.tags,
    this.maxTags = 3,
    this.backgroundColor,
    this.textColor,
    this.onTagTap,
  });

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: tags.take(maxTags).map((tag) {
        return TagChip(
          tag: tag,
          backgroundColor: backgroundColor,
          textColor: textColor,
          onTap: onTagTap != null ? () => onTagTap!(tag) : null,
        );
      }).toList(),
    );
  }
}
