import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/constants/app_typography.dart';

class AuthorAvatar extends StatelessWidget {
  final String authorName;
  final String? authorImageUrl;
  final double radius;
  final TextStyle? textStyle;

  const AuthorAvatar({
    super.key,
    required this.authorName,
    this.authorImageUrl,
    this.radius = 20,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: authorImageUrl != null
          ? CachedNetworkImageProvider(authorImageUrl!)
          : null,
      backgroundColor: Theme.of(
        context,
      ).colorScheme.primary.withValues(alpha: 0.1),
      child: authorImageUrl == null
          ? Text(
              authorName.isNotEmpty ? authorName[0].toUpperCase() : 'A',
              style:
                  textStyle ??
                  TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: radius * 0.6,
                  ),
            )
          : null,
    );
  }
}

class AuthorInfo extends StatelessWidget {
  final String authorName;
  final String? authorImageUrl;
  final String? subtitle;
  final double avatarRadius;
  final Widget? trailing;

  const AuthorInfo({
    super.key,
    required this.authorName,
    this.authorImageUrl,
    this.subtitle,
    this.avatarRadius = 20,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AuthorAvatar(
          authorName: authorName,
          authorImageUrl: authorImageUrl,
          radius: avatarRadius,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                authorName,
                style: AppTypography.titleMedium(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: AppTypography.bodySmall(context).copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}
