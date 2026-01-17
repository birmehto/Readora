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
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Favorites',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: AppTextField(
              hint: 'Search your library...',
              onChanged: controller.onSearchChanged,
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 4.0),
                child: Icon(Icons.search_rounded),
              ),
            ),
          ),

          Expanded(
            child: Obx(() {
              final list = controller.filteredFavorites;
              final isSearching = controller.searchQuery.isNotEmpty;

              if (list.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer.withValues(
                            alpha: 0.2,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isSearching
                              ? Icons.search_off_rounded
                              : Icons.auto_awesome_rounded,
                          size: 80,
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        isSearching
                            ? 'No results for\n"${controller.searchQuery.value}"'
                            : 'Your library is empty',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        isSearching
                            ? 'Try a different keyword'
                            : 'Save articles to read them later',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                itemCount: list.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (_, index) {
                  final item = list[index];
                  return FavitesListItem(
                    item: item,
                    onDelete: () => controller.removeFavorite(item.url),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
