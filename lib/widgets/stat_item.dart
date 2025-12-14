import 'package:flutter/material.dart';
import '../core/constants/app_spacing.dart';
import '../core/constants/app_typography.dart';

class StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;

  const StatItem({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color:
                backgroundColor ??
                Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color:
                iconColor ?? Theme.of(context).colorScheme.onPrimaryContainer,
            size: 20,
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        Text(
          value,
          style: AppTypography.titleMedium(
            context,
          ).copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: AppTypography.bodySmall(
            context,
          ).copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class StatsRow extends StatelessWidget {
  final List<StatItem> stats;

  const StatsRow({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Row(children: stats.map((stat) => Expanded(child: stat)).toList());
  }
}
