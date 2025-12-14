import 'package:flutter/material.dart';
import '../core/constants/app_spacing.dart';
import '../core/constants/app_typography.dart';
import '../core/utils/date_formatter.dart';
import '../features/article/model.dart';
import 'author_avatar.dart';
import 'reading_time_badge.dart';
import 'tag_chip.dart';

class HistoryArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback? onTap;
  final Function(String)? onMenuAction;
  final bool isFavorite;
  final bool showFavoriteAction;
  final bool showRemoveAction;

  const HistoryArticleCard({
    super.key,
    required this.article,
    this.onTap,
    this.onMenuAction,
    this.isFavorite = false,
    this.showFavoriteAction = true,
    this.showRemoveAction = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              SizedBox(height: AppSpacing.sm),
              _buildAuthorSection(context),
              if (article.subtitle != null) ...[
                SizedBox(height: AppSpacing.sm),
                _buildSubtitle(context),
              ],
              if (article.tags.isNotEmpty) ...[
                SizedBox(height: AppSpacing.sm),
                TagsWrap(tags: article.tags),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            article.title,
            style: AppTypography.titleMedium(context),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (onMenuAction != null) _buildPopupMenu(context),
      ],
    );
  }

  Widget _buildAuthorSection(BuildContext context) {
    return Row(
      children: [
        AuthorAvatar(
          authorName: article.author,
          authorImageUrl: article.authorImageUrl,
          radius: 16,
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(article.author, style: AppTypography.bodyMedium(context)),
              if (article.publishedDate != null)
                Text(
                  DateFormatter.formatRelativeDate(article.publishedDate!),
                  style: AppTypography.bodySmall(context).copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
        if (article.readingTime != null)
          ReadingTimeBadge(readingTime: article.readingTime!),
      ],
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    return Text(
      article.subtitle!,
      style: AppTypography.bodyMedium(
        context,
      ).copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPopupMenu(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onMenuAction,
      itemBuilder: (context) => [
        if (showFavoriteAction)
          PopupMenuItem(
            value: 'favorite',
            child: Row(
              children: [
                Icon(
                  isFavorite ? Icons.favorite_border : Icons.favorite,
                  color: isFavorite ? null : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(isFavorite ? 'Remove from Favorites' : 'Add to Favorites'),
              ],
            ),
          ),
        if (showRemoveAction)
          const PopupMenuItem(
            value: 'remove',
            child: Row(
              children: [
                Icon(Icons.delete_outline, color: Colors.red),
                SizedBox(width: 8),
                Text('Remove from History'),
              ],
            ),
          ),
      ],
    );
  }
}
