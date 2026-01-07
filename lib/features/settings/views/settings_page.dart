import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/background_painter.dart';
import '../controllers/settings_controller.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: MeshGradientBackground(
        child: CustomScrollView(
          slivers: [
            SliverAppBar.medium(
              title: Text(
                'Settings',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              centerTitle: true,
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 12),
                  _sectionHeader(context, 'Appearance'),
                  _card(
                    context,
                    children: [
                      Obx(
                        () => SwitchListTile.adaptive(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          secondary: _iconBox(
                            theme,
                            controller.isDarkMode.value
                                ? Icons.dark_mode_rounded
                                : Icons.light_mode_rounded,
                            theme.colorScheme.primaryContainer,
                          ),
                          title: Text(
                            'Dark Mode',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          subtitle: const Text(
                            'Comfortable reading in low light',
                          ),
                          value: controller.isDarkMode.value,
                          onChanged: controller.toggleTheme,
                        ),
                      ),
                    ],
                  ),
                  _sectionHeader(context, 'About'),
                  _card(
                    context,
                    children: [
                      _tile(
                        context,
                        icon: Icons.mail_outline_rounded,
                        bg: theme.colorScheme.tertiaryContainer,
                        title: 'Send Feedback',
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: controller.sendFeedback,
                      ),
                      const _Divider(),
                      _versionTile(context),
                      const _Divider(),
                      _tile(
                        context,
                        icon: Icons.gavel_rounded,
                        bg: theme.colorScheme.secondaryContainer,
                        title: 'Licenses & Credits',
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
      ),
    );
  }

  // ───────────────────────── UI Helpers ─────────────────────────

  Widget _iconBox(ThemeData theme, IconData icon, Color bg) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bg.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        icon,
        size: 22,
        color: theme.colorScheme.onSecondaryContainer,
      ),
    );
  }

  Widget _card(BuildContext context, {required List<Widget> children}) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.25),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 28, 12, 12),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: 1.4,
          color: theme.colorScheme.primary.withValues(alpha: 0.85),
        ),
      ),
    );
  }

  Widget _tile(
    BuildContext context, {
    required IconData icon,
    required Color bg,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: _iconBox(theme, icon, bg),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _versionTile(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: _iconBox(
        theme,
        Icons.info_outline_rounded,
        theme.colorScheme.secondaryContainer,
      ),
      title: const Text('Version'),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: Text(
          '1.0.0',
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }

  void _showCreditsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: const Text('Licenses & Credits'),
        content: const Text(
          'Readora is not affiliated with Medium.\n\n'
          'All article content belongs to their respective authors.',
        ),
        actions: [TextButton(onPressed: Get.back, child: const Text('Close'))],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Divider(
      height: 1,
      indent: 20,
      endIndent: 20,
      color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
    );
  }
}
