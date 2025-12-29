import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/settings_controller.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.medium(title: Text('Settings')),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSectionHeader(context, 'Appearance'),
                _buildCard(
                  context,
                  children: [
                    Obx(
                      () => SwitchListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        secondary: _iconBox(
                          theme,
                          controller.isDarkMode.value
                              ? Icons.dark_mode_rounded
                              : Icons.light_mode_rounded,
                          theme.colorScheme.secondaryContainer,
                        ),
                        title: const Text('Dark Mode'),
                        subtitle: const Text(
                          'Use dark theme for app and articles',
                        ),
                        value: controller.isDarkMode.value,
                        onChanged: controller.toggleTheme,
                      ),
                    ),
                  ],
                ),

                _buildSectionHeader(context, 'Support'),
                _buildCard(
                  context,
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: _iconBox(
                        theme,
                        Icons.coffee_rounded,
                        theme.colorScheme.secondaryContainer,
                      ),
                      title: const Text('Buy Me a Coffee'),
                      subtitle: const Text('Support the developer'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: controller.openDonationLink,
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      leading: const Icon(Icons.mail_outline_rounded),
                      title: const Text('Send Feedback'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: controller.sendFeedback,
                    ),
                  ],
                ),

                _buildSectionHeader(context, 'About'),
                _buildCard(
                  context,
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      leading: const Icon(Icons.info_outline_rounded),
                      title: const Text('Version'),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '1.0.1',
                          style: theme.textTheme.labelMedium,
                        ),
                      ),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      leading: const Icon(Icons.gavel_rounded),
                      title: const Text('Licenses & Credits'),
                      onTap: () => _showCreditsDialog(context),
                    ),
                  ],
                ),

                const SizedBox(height: 48),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Helpers ----------

  Widget _iconBox(ThemeData theme, IconData icon, Color bg) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: theme.colorScheme.onSecondaryContainer),
    );
  }

  Widget _buildCard(BuildContext context, {required List<Widget> children}) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 24, 8, 12),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  void _showCreditsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Licenses & Credits'),
        content: const Text(
          'Readora is not affiliated with Medium.\n\n'
          'All article content belongs to their respective authors.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Close')),
        ],
      ),
    );
  }
}
