import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/app_textfield.dart';
import '../controllers/favorites_controller.dart';
import '../widgets/favorites_list_item.dart';

class FavoritesPage extends GetView<FavoritesController> {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.medium(title: Text('Favorites')),

          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: AppTextField(
                hint: 'Search favorites...',
                onChanged: controller.onSearchChanged,
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 4.0),
                  child: Icon(Icons.search_rounded),
                ),
              ),
            ),
          ),

          // List / Empty state
          Obx(() {
            final list = controller.filteredFavorites;
            final isSearching = controller.searchQuery.isNotEmpty;

            if (list.isEmpty) {
              return SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isSearching
                            ? Icons.search_off_rounded
                            : Icons.favorite_border_rounded,
                        size: 72,
                        color: theme.colorScheme.outline.withValues(alpha: 0.4),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        isSearching
                            ? 'No results for "${controller.searchQuery.value}"'
                            : 'No favorite articles',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (!isSearching) ...[
                        const SizedBox(height: 8),
                        const Text(
                          'Star articles to save them here',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }

            return SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final item = list[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: FavoritesListItem(
                      item: item,
                      onDelete: () => controller.removeFavorite(item.url),
                    ),
                  );
                }, childCount: list.length),
              ),
            );
          }),
        ],
      ),
    );
  }
}
