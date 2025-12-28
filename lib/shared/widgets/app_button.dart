import 'package:flutter/material.dart';

enum AppButtonVariant { filled, outlined, text, elevated }

enum AppButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  const AppButton({
    required this.text,
    required this.onPressed,
    super.key,
    this.variant = AppButtonVariant.filled,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isDisabled = false,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
  });

  final String text;
  final VoidCallback onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isDisabled;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? width;

  bool get _disabled => isDisabled || isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final sizeCfg = _sizeConfig;
    final colors = _colors(scheme);

    final child = _buildContent(theme, colors.foregroundColor, sizeCfg);

    final VoidCallback? action = _disabled ? null : onPressed;

    Widget button = switch (variant) {
      AppButtonVariant.filled => FilledButton(
        onPressed: action,
        style: FilledButton.styleFrom(
          backgroundColor: colors.backgroundColor,
          foregroundColor: colors.foregroundColor,
          minimumSize: Size(width ?? sizeCfg.minWidth, sizeCfg.height),
          padding: sizeCfg.padding,
          disabledBackgroundColor: scheme.onSurface.withValues(alpha: 0.12),
          disabledForegroundColor: scheme.onSurface.withValues(alpha: 0.38),
        ),
        child: child,
      ),
      AppButtonVariant.outlined => OutlinedButton(
        onPressed: action,
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.foregroundColor,
          side: BorderSide(color: colors.borderColor),
          minimumSize: Size(width ?? sizeCfg.minWidth, sizeCfg.height),
          padding: sizeCfg.padding,
        ),
        child: child,
      ),
      AppButtonVariant.text => TextButton(
        onPressed: action,
        style: TextButton.styleFrom(
          foregroundColor: colors.foregroundColor,
          minimumSize: Size(width ?? sizeCfg.minWidth, sizeCfg.height),
          padding: sizeCfg.padding,
        ),
        child: child,
      ),
      AppButtonVariant.elevated => ElevatedButton(
        onPressed: action,
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.backgroundColor,
          foregroundColor: colors.foregroundColor,
          minimumSize: Size(width ?? sizeCfg.minWidth, sizeCfg.height),
          padding: sizeCfg.padding,
        ),
        child: child,
      ),
    };

    if (width != null) {
      button = SizedBox(width: width, child: button);
    }

    return button;
  }

  // ---------- Content ----------

  Widget _buildContent(
    ThemeData theme,
    Color foreground,
    _ButtonSizeConfig size,
  ) {
    if (isLoading) {
      return SizedBox(
        width: size.iconSize,
        height: size.iconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(foreground),
        ),
      );
    }

    if (icon == null) {
      return Text(text, style: size.textStyle);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: size.iconSize),
        const SizedBox(width: 8),
        Text(text, style: size.textStyle),
      ],
    );
  }

  // ---------- Size ----------

  _ButtonSizeConfig get _sizeConfig {
    return switch (size) {
      AppButtonSize.small => const _ButtonSizeConfig(
        height: 32,
        minWidth: 64,
        padding: EdgeInsets.symmetric(horizontal: 12),
        iconSize: 16,
        textStyle: TextStyle(fontSize: 12),
      ),
      AppButtonSize.medium => const _ButtonSizeConfig(
        height: 40,
        minWidth: 80,
        padding: EdgeInsets.symmetric(horizontal: 16),
        iconSize: 18,
        textStyle: TextStyle(fontSize: 14),
      ),
      AppButtonSize.large => const _ButtonSizeConfig(
        height: 48,
        minWidth: 96,
        padding: EdgeInsets.symmetric(horizontal: 20),
        iconSize: 20,
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    };
  }

  // ---------- Colors ----------

  _ButtonColors _colors(ColorScheme c) {
    final base = switch (variant) {
      AppButtonVariant.filled => _ButtonColors(
        backgroundColor: c.primary,
        foregroundColor: c.onPrimary,
        borderColor: c.primary,
      ),
      AppButtonVariant.outlined => _ButtonColors(
        backgroundColor: Colors.transparent,
        foregroundColor: c.primary,
        borderColor: c.outlineVariant,
      ),
      AppButtonVariant.text => _ButtonColors(
        backgroundColor: Colors.transparent,
        foregroundColor: c.primary,
        borderColor: Colors.transparent,
      ),
      AppButtonVariant.elevated => _ButtonColors(
        backgroundColor: c.surfaceContainerHighest,
        foregroundColor: c.primary,
        borderColor: Colors.transparent,
      ),
    };

    return _ButtonColors(
      backgroundColor: backgroundColor ?? base.backgroundColor,
      foregroundColor: foregroundColor ?? base.foregroundColor,
      borderColor: base.borderColor,
    );
  }
}

// ---------- Internals ----------

class _ButtonSizeConfig {
  const _ButtonSizeConfig({
    required this.height,
    required this.minWidth,
    required this.padding,
    required this.iconSize,
    required this.textStyle,
  });

  final double height;
  final double minWidth;
  final EdgeInsets padding;
  final double iconSize;
  final TextStyle textStyle;
}

class _ButtonColors {
  const _ButtonColors({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
  });

  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;
}
