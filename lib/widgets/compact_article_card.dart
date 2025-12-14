import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/core.dart';
import '../features/article/model.dart';
import 'author_avatar.dart';

class CompactArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback? onTap;
  final VoidCallback? onBookmark;
  final bool isBookmarked;
  final EdgeInsets? margin;

  const CompactArticleCard({
    super.key,
    required this.article,
    this.onTap,
    this.onBookmark,
    this.isBookmarked = false,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Card(
        elevation: 1,
        shadowColor: Theme.of(
          context,
        ).colorScheme.shadow.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Article image or placeholder
                _buildThumbnail(context),
                SizedBox(width: AppSpacing.md),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        article.title,
                        style: AppTypography.titleMedium(
                          context,
                        ).copyWith(fontWeight: FontWeight.w600, height: 1.3),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: AppSpacing.xs),

                      // Author and metadata
                      Row(
                        children: [
                          AuthorAvatar(
                            authorName: article.author,
                            authorImageUrl: article.authorImageUrl,
                            radius: 12,
                          ),
                          SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: Text(
                              article.author,
                              style: AppTypography.bodySmall(context).copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (article.readingTime != null) ...[
                            SizedBox(width: AppSpacing.xs),
                            Text(
                              '${article.readingTime}m',
                              style: AppTypography.bodySmall(context).copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),

                      if (article.publishedDate != null) ...[
                        SizedBox(height: AppSpacing.xs),
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
                      ],
                    ],
                  ),
                ),

                // Bookmark button
                if (onBookmark != null)
                  IconButton(
                    onPressed: onBookmark,
                    icon: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      size: 20.sp,
                    ),
                    color: isBookmarked
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    style: IconButton.styleFrom(
                      minimumSize: Size(32.w, 32.h),
                      padding: EdgeInsets.zero,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context) {
    return Container(
      width: 60.w,
      height: 60.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Theme.of(context).colorScheme.surfaceContainer,
      ),
      child: article.imageUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                article.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholder(context);
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildPlaceholder(context);
                },
              ),
            )
          : _buildPlaceholder(context),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Theme.of(context).colorScheme.surfaceContainer,
      ),
      child: Icon(
        Icons.article_outlined,
        size: 24.sp,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
