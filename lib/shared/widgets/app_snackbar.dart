import 'package:flutter/material.dart';

enum SnackbarType { success, error, warning, info }

class AppSnackbar {
  static void show(
    BuildContext context, {
    required String title,
    required String message,
    SnackbarType type = SnackbarType.info,
    Duration duration = const Duration(seconds: 3),
    Widget? mainButton,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final config = _mapType(type, scheme);

    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      duration: duration,
      margin: const EdgeInsets.all(16),
      backgroundColor: Colors.transparent,
      content: _SnackContent(
        title: title,
        message: message,
        icon: config.icon,
        foreground: config.foreground,
        background: config.background,
        mainButton: mainButton,
      ),
    );

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(snackBar);
  }

  static _Config _mapType(SnackbarType type, ColorScheme scheme) {
    switch (type) {
      case SnackbarType.success:
        return _Config(
          background: scheme.primaryContainer,
          foreground: scheme.onPrimaryContainer,
          icon: Icons.check_circle,
        );
      case SnackbarType.error:
        return _Config(
          background: scheme.errorContainer,
          foreground: scheme.onErrorContainer,
          icon: Icons.error,
        );
      case SnackbarType.warning:
        return _Config(
          background: scheme.tertiaryContainer,
          foreground: scheme.onTertiaryContainer,
          icon: Icons.warning,
        );
      case SnackbarType.info:
        return _Config(
          background: scheme.surfaceContainerHighest,
          foreground: scheme.onSurfaceVariant,
          icon: Icons.info,
        );
    }
  }
}

class _SnackContent extends StatelessWidget {
  const _SnackContent({
    required this.title,
    required this.message,
    required this.icon,
    required this.foreground,
    required this.background,
    this.mainButton,
  });
  final String title;
  final String message;
  final IconData icon;
  final Color foreground;
  final Color background;
  final Widget? mainButton;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: foreground),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: foreground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: TextStyle(color: foreground.withValues(alpha: 0.9)),
                  ),
                ],
              ),
            ),
            if (mainButton != null) ...[const SizedBox(width: 8), mainButton!],
          ],
        ),
      ),
    );
  }
}

class _Config {
  const _Config({
    required this.background,
    required this.foreground,
    required this.icon,
  });
  final Color background;
  final Color foreground;
  final IconData icon;
}
