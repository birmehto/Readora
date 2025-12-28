import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/favorites_controller.dart';
import '../widgets/favorites_list_item.dart';
import '../../home/widgets/home_widgets.dart';

class FavoritesPage extends GetView<FavoritesController> {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          const HomeBackground(),
          CustomScrollView(
            slivers: [
              SliverAppBar.medium(
                title: const Text('Favorites'),
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // Search Section
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: TextField(
                          onChanged: controller.onSearchChanged,
                          decoration: InputDecoration(
                            hintText: 'Search favorites...',
                            filled: true,
                            fillColor: theme.colorScheme.surface.withValues(
                              alpha: 0.8,
                            ),
                            prefixIcon: const Icon(Icons.search_rounded),
                            suffixIcon: Obx(() {
                              if (controller.searchQuery.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              return IconButton(
                                icon: const Icon(Icons.close_rounded),
                                onPressed: () {
                                  controller.clearSearch();
                                  FocusScope.of(context).unfocus();
                                },
                              );
                            }),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide(
                                color: theme.colorScheme.outlineVariant
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide(
                                color: theme.colorScheme.outlineVariant
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide(
                                color: theme.colorScheme.primary,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() {
                final list = controller.filteredFavorites;

                if (list.isEmpty) {
                  final isSearching = controller.searchQuery.isNotEmpty;
                  return SliverFillRemaining(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isSearching
                                  ? Icons.search_off_rounded
                                  : Icons.favorite_border_rounded,
                              size: 72,
                              color: theme.colorScheme.outline.withValues(
                                alpha: 0.3,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              isSearching
                                  ? 'No results for "${controller.searchQuery.value}"'
                                  : 'No favorite articles',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.outline,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (!isSearching) ...[
                              const SizedBox(height: 8),
                              const Text(
                                'Star your favorite articles to find them later',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
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
        ],
      ),
    );
  }
}
