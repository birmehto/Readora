import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/core.dart';
import '../features/article/model.dart';
import 'author_avatar.dart';
import 'reading_time_badge.dart';
import 'tag_chip.dart';

class FeaturedArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback? onTap;
  final VoidCallback? onBookmark;
  final VoidCallback? onShare;
  final bool isBookmarked;

  const FeaturedArticleCard({
    super.key,
    required this.article,
    this.onTap,
    this.onBookmark,
    this.onShare,
    this.isBookmarked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Card(
        elevation: 4,
        shadowColor: Theme.of(
          context,
        ).colorScheme.shadow.withValues(alpha: 0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeroSection(context),
              _buildContentSection(context),
              _buildActionSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Stack(
      children: [
        // Hero image
        if (article.imageUrl != null)
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: CachedNetworkImage(
                imageUrl: article.imageUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Theme.of(context).colorScheme.primary,
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
          ),

        // Gradient overlay
        if (article.imageUrl != null)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
          ),

        // Featured badge
        Positioned(
          top: AppSpacing.lg,
          left: AppSpacing.lg,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, size: 16.sp, color: Colors.white),
                SizedBox(width: AppSpacing.xs),
                Text(
                  'Featured',
                  style: AppTypography.labelSmall(
                    context,
                  ).copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),

        // Reading time badge
        if (article.readingTime != null)
          Positioned(
            top: AppSpacing.lg,
            right: AppSpacing.lg,
            child: ReadingTimeBadge(
              readingTime: article.readingTime!,
              backgroundColor: Colors.black.withValues(alpha: 0.7),
              textColor: Colors.white,
            ),
          ),
      ],
    );
  }

  Widget _buildContentSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            article.title,
            style: AppTypography.headlineSmall(
              context,
            ).copyWith(fontWeight: FontWeight.w800, height: 1.2),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),

          // Subtitle
          if (article.subtitle != null) ...[
            SizedBox(height: AppSpacing.md),
            Text(
              article.subtitle!,
              style: AppTypography.bodyLarge(context).copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          SizedBox(height: AppSpacing.lg),

          // Author info
          Row(
            children: [
              AuthorAvatar(
                authorName: article.author,
                authorImageUrl: article.authorImageUrl,
                radius: 20,
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.author,
                      style: AppTypography.titleSmall(
                        context,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                    if (article.publishedDate != null)
                      Text(
                        DateFormatter.formatSimpleDate(article.publishedDate!),
                        style: AppTypography.bodySmall(context).copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          // Tags
          if (article.tags.isNotEmpty) ...[
            SizedBox(height: AppSpacing.lg),
            TagsWrap(
              tags: article.tags,
              maxTags: 4,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              textColor: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
          ),
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
      ),
      child: Row(
        children: [
          Expanded(
            child: FilledButton.icon(
              onPressed: onTap,
              icon: const Icon(Icons.auto_stories, size: 20),
              label: const Text('Read Featured Article'),
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.lg,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
          ),
          if (onBookmark != null) ...[
            SizedBox(width: AppSpacing.md),
            _buildActionButton(
              context,
              icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              onTap: onBookmark,
              isActive: isBookmarked,
            ),
          ],
          if (onShare != null) ...[
            SizedBox(width: AppSpacing.sm),
            _buildActionButton(
              context,
              icon: Icons.share_outlined,
              onTap: onShare,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    VoidCallback? onTap,
    bool isActive = false,
  }) {
    return Material(
      color: isActive
          ? Theme.of(context).colorScheme.primaryContainer
          : Theme.of(context).colorScheme.surfaceContainer,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          width: 52.w,
          height: 52.h,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r)),
          child: Icon(
            icon,
            size: 24.sp,
            color: isActive
                ? Theme.of(context).colorScheme.onPrimaryContainer
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
