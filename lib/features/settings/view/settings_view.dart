import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/settings_controller.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), elevation: 0),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.lg),
        children: [
          _buildSection(context, 'Appearance', [_buildThemeSelector(context)]),
          SizedBox(height: AppSpacing.xl),
          _buildSection(context, 'Data', [_buildClearHistoryTile(context)]),
          SizedBox(height: AppSpacing.xl),
          _buildSection(context, 'About', [_buildAboutTile(context)]),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: AppSpacing.md, bottom: AppSpacing.sm),
          child: Text(
            title,
            style: AppTypography.titleMedium(
              context,
            ).copyWith(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Theme.of(context).dividerColor),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildThemeSelector(BuildContext context) {
    return Obx(
      () => ListTile(
        leading: Icon(controller.themeController.themeIcon),
        title: const Text('Theme'),
        subtitle: Text(_getThemeName(controller.themeController.themeMode)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showThemeDialog(context),
      ),
    );
  }

  Widget _buildClearHistoryTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.delete_outline),
      title: const Text('Clear History'),
      subtitle: const Text('Remove all reading history'),
      onTap: () => _showClearHistoryDialog(context),
    );
  }

  Widget _buildAboutTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.info_outline),
      title: const Text('About'),
      subtitle: const Text('App information'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showAboutDialog(context),
    );
  }

  String _getThemeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThemeOption(context, 'Light', ThemeMode.light),
            _buildThemeOption(context, 'Dark', ThemeMode.dark),
            _buildThemeOption(context, 'System', ThemeMode.system),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        ],
      ),
    );
  }

  Widget _buildThemeOption(BuildContext context, String title, ThemeMode mode) {
    return Obx(
      () => ListTile(
        title: Text(title),
        leading: Icon(
          controller.themeController.themeMode == mode
              ? Icons.radio_button_checked
              : Icons.radio_button_unchecked,
          color: controller.themeController.themeMode == mode
              ? Theme.of(context).colorScheme.primary
              : null,
        ),
        onTap: () {
          controller.changeTheme(mode);
          Get.back();
        },
      ),
    );
  }

  void _showClearHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text(
          'Are you sure you want to clear all reading history? This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              controller.clearHistory();
              Get.back();
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Article Reader',
      applicationVersion: '1.0.0',
      applicationIcon: Icon(
        Icons.article_outlined,
        size: 48,
        color: Theme.of(context).colorScheme.primary,
      ),
      children: const [
        Text('A simple and elegant article reader app.'),
        SizedBox(height: 16),
        Text('Powered by Freedium for bypassing Medium paywalls.'),
      ],
    );
  }
}
