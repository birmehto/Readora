import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/core.dart';
import '../features/article/model.dart';
import 'author_avatar.dart';
import 'tag_chip.dart';

class ArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback? onTap;
  final VoidCallback? onBookmark;
  final VoidCallback? onShare;
  final bool isBookmarked;
  final bool showActions;
  final EdgeInsets? margin;

  const ArticleCard({
    super.key,
    required this.article,
    this.onTap,
    this.onBookmark,
    this.onShare,
    this.isBookmarked = false,
    this.showActions = true,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Card(
        elevation: 2,
        shadowColor: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (article.imageUrl != null) _buildHeroImage(context),
              _buildContent(context),
              if (showActions) _buildActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroImage(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: CachedNetworkImage(
          imageUrl: article.imageUrl!,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    'Loading image...',
                    style: AppTypography.bodySmall(context),
                  ),
                ],
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_not_supported_outlined,
                  size: 48.sp,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  'Image not available',
                  style: AppTypography.bodySmall(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status indicator
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: AppColors.success.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 14.sp,
                  color: AppColors.success,
                ),
                SizedBox(width: AppSpacing.xs),
                Text(
                  'Ready to read',
                  style: AppTypography.labelSmall(context).copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: AppSpacing.md),

          // Title
          Text(
            article.title,
            style: AppTypography.titleLarge(
              context,
            ).copyWith(fontWeight: FontWeight.w700, height: 1.3),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),

          // Subtitle
          if (article.subtitle != null) ...[
            SizedBox(height: AppSpacing.sm),
            Text(
              article.subtitle!,
              style: AppTypography.bodyMedium(context).copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          SizedBox(height: AppSpacing.lg),

          // Author and metadata
          Row(
            children: [
              AuthorAvatar(
                authorName: article.author,
                authorImageUrl: article.authorImageUrl,
                radius: 18,
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.author,
                      style: AppTypography.labelLarge(
                        context,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                    Row(
                      children: [
                        if (article.publishedDate != null) ...[
                          Text(
                            DateFormatter.formatSimpleDate(
                              article.publishedDate!,
                            ),
                            style: AppTypography.bodySmall(context).copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          if (article.readingTime != null) ...[
                            Text(
                              ' • ',
                              style: AppTypography.bodySmall(context).copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              '${article.readingTime} min read',
                              style: AppTypography.bodySmall(context).copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ] else if (article.readingTime != null) ...[
                          Text(
                            '${article.readingTime} min read',
                            style: AppTypography.bodySmall(context).copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Tags
          if (article.tags.isNotEmpty) ...[
            SizedBox(height: AppSpacing.md),
            TagsWrap(
              tags: article.tags,
              maxTags: 3,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              textColor: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor.withOpacity(0.5),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: FilledButton.icon(
              onPressed: onTap,
              icon: const Icon(Icons.auto_stories, size: 18),
              label: const Text('Read Article'),
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ),
          if (onBookmark != null) ...[
            SizedBox(width: AppSpacing.sm),
            _buildActionIcon(
              context,
              icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              onTap: onBookmark,
              isActive: isBookmarked,
            ),
          ],
          if (onShare != null) ...[
            SizedBox(width: AppSpacing.xs),
            _buildActionIcon(
              context,
              icon: Icons.share_outlined,
              onTap: onShare,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionIcon(
    BuildContext context, {
    required IconData icon,
    VoidCallback? onTap,
    bool isActive = false,
  }) {
    return Material(
      color: isActive
          ? Theme.of(context).colorScheme.primaryContainer
          : Theme.of(context).colorScheme.surfaceContainer,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          width: 44.w,
          height: 44.h,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
          child: Icon(
            icon,
            size: 20.sp,
            color: isActive
                ? Theme.of(context).colorScheme.onPrimaryContainer
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
