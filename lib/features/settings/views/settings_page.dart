import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/settings_controller.dart';
import '../../home/widgets/home_widgets.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          const HomeBackground(),
          CustomScrollView(
            slivers: [
              const SliverAppBar.medium(
                title: Text('Settings'),
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
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
                            secondary: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.secondaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                controller.isDarkMode.value
                                    ? Icons.dark_mode_rounded
                                    : Icons.light_mode_rounded,
                                color: theme.colorScheme.onSecondaryContainer,
                              ),
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

                    _buildSectionHeader(context, 'Reading Preferences'),
                    _buildCard(
                      context,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primaryContainer,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.text_fields_rounded,
                                      color:
                                          theme.colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    'Font Size',
                                    style: theme.textTheme.titleMedium,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Obx(
                                () => Row(
                                  children: [
                                    const Text(
                                      'A',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Expanded(
                                      child: Slider(
                                        value: controller.fontSize.value,
                                        min: 14.0,
                                        max: 24.0,
                                        divisions: 10,
                                        label: controller.fontSize.value
                                            .round()
                                            .toString(),
                                        onChanged: controller.updateFontSize,
                                      ),
                                    ),
                                    const Text(
                                      'A',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.tertiaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.font_download_rounded,
                              color: theme.colorScheme.onTertiaryContainer,
                            ),
                          ),
                          title: const Text('Font Family'),
                          trailing: Obx(
                            () => DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: controller.fontFamily.value,
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Inter',
                                    child: Text('Inter'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Merriweather',
                                    child: Text('Serif'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Roboto',
                                    child: Text('Roboto'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Lora',
                                    child: Text('Lora'),
                                  ),
                                ],
                                onChanged: (val) {
                                  if (val != null)
                                    controller.updateFontFamily(val);
                                },
                              ),
                            ),
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
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.coffee_rounded,
                              color: Colors.amber.shade800,
                            ),
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
                          leading: const Icon(Icons.star_rate_rounded),
                          title: const Text('Rate App'),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: controller.rateApp,
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
                              '1.0.0',
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
        ],
      ),
    );
  }

  void _showCreditsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Licenses & Credits'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Readora is an unofficial application not affiliated with A Medium Corporation.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text('• "Medium" is a trademark of A Medium Corporation.'),
              const SizedBox(height: 8),
              const Text(
                '• This app uses third-party services like Freedium and ReadMedium to provide content.',
              ),
              const SizedBox(height: 8),
              const Text(
                '• This software is provided "as is" under the MIT License.',
              ),
              const SizedBox(height: 16),
              Text(
                'All article content remains the property of their respective authors and publishers.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required List<Widget> children}) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: theme.colorScheme.surface,
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
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w900,
          letterSpacing: 2.0,
        ),
      ),
    );
  }
}
