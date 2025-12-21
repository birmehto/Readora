import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/article_controller.dart';

class ReadingSettingsSheet extends GetView<ArticleController> {
  const ReadingSettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          Text(
            'Reading Settings',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),

          // Dark mode toggle
          Obx(
            () => SwitchListTile(
              value: controller.isDarkMode.value,
              onChanged: (_) => controller.toggleDarkMode(),
              title: const Text('Dark Mode'),
              secondary: Icon(
                controller.isDarkMode.value
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),
            ),
          ),
          const Divider(),

          // Font Settings
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  'Font Size',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Obx(
                  () => Slider(
                    value: controller.fontSize.value,
                    min: 14,
                    max: 28,
                    divisions: 14,
                    label: '${controller.fontSize.value.round()}px',
                    onChanged: controller.updateFontSize,
                  ),
                ),

                const SizedBox(height: 16),
                Text(
                  'Font Family',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                Obx(
                  () => Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildFontChip(context, 'Inter', 'Sans'),
                      _buildFontChip(context, 'Roboto', 'Sans'),
                      _buildFontChip(context, 'Merriweather', 'Serif'),
                      _buildFontChip(context, 'Open Sans', 'Sans'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildFontChip(BuildContext context, String font, String label) {
    final isSelected = controller.fontFamily.value == font;
    return FilterChip(
      label: Text(font),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          controller.updateFontFamily(font);
        }
      },
      showCheckmark: false,
      avatar: isSelected ? const Icon(Icons.check, size: 16) : null,
    );
  }
}
