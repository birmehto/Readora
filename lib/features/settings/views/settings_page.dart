import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/app_appbar.dart';
import '../../../shared/widgets/app_dialogs.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../controllers/settings_controller.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: const AppAppBar(title: 'Settings'),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        children: [
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
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      controller.isDarkMode.value
                          ? Icons.dark_mode_rounded
                          : Icons.light_mode_rounded,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                  title: const Text('Dark Mode'),
                  subtitle: const Text('Use dark theme for app and articles'),
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
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.text_fields_rounded,
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Font Size',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => Row(
                        children: [
                          const Text('A', style: TextStyle(fontSize: 14)),
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
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.font_download_rounded,
                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                  ),
                ),
                title: const Text('Font Family'),
                trailing: Obx(
                  () => DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: controller.fontFamily.value,
                      items: const [
                        DropdownMenuItem(value: 'Inter', child: Text('Inter')),
                        DropdownMenuItem(
                          value: 'Merriweather',
                          child: Text('Serif'),
                        ),
                        DropdownMenuItem(
                          value: 'Roboto',
                          child: Text('Roboto'),
                        ),
                        DropdownMenuItem(value: 'Lora', child: Text('Lora')),
                      ],
                      onChanged: (val) {
                        if (val != null) controller.updateFontFamily(val);
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

          _buildSectionHeader(context, 'Legal'),
          _buildCard(
            context,
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                leading: const Icon(Icons.privacy_tip_outlined),
                title: const Text('Privacy Policy'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: controller.openPrivacyPolicy,
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                leading: const Icon(Icons.description_outlined),
                title: const Text('Terms of Service'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: controller.openTermsOfService,
              ),
            ],
          ),

          _buildSectionHeader(context, 'Storage'),
          _buildCard(
            context,
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                title: const Text('Clear History'),
                subtitle: const Text('Remove all reading history'),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.delete_forever_rounded,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
                onTap: () => _confirmClearHistory(context),
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
                    color: Theme.of(context).colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '1.0.0',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                leading: const Icon(Icons.code_rounded),
                title: const Text('Developer'),
                subtitle: const Text('Made with ❤️ in Flutter'),
                onTap:
                    controller.openDonationLink, // Linking to donation/social
              ),
            ],
          ),

          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required List<Widget> children}) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Theme.of(
        context,
      ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: Theme.of(
            context,
          ).colorScheme.outlineVariant.withValues(alpha: 0.2),
        ),
      ),
      child: Column(children: children),
    );
  }

  void _confirmClearHistory(BuildContext context) {
    AppDialogs.showConfirmDialog(
      title: 'Clear History',
      message:
          'Are you sure you want to delete all reading history? This action cannot be undone.',
      confirmText: 'Clear All',
      isDestructive: true,
      onConfirm: () {
        controller.clearHistory();
        Get.back();
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 24, 8, 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
