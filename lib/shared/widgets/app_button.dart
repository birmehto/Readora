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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Size configurations
    final sizeConfig = _getSizeConfig();

    // Color configurations
    final colors = _getColors(colorScheme);

    final Widget buttonChild = _buildButtonContent(theme);

    Widget button = switch (variant) {
      AppButtonVariant.filled => FilledButton(
        onPressed: _getOnPressed(),
        style: FilledButton.styleFrom(
          backgroundColor: colors.backgroundColor,
          foregroundColor: colors.foregroundColor,
          minimumSize: Size(width ?? sizeConfig.minWidth, sizeConfig.height),
          padding: sizeConfig.padding,
        ),
        child: buttonChild,
      ),
      AppButtonVariant.outlined => OutlinedButton(
        onPressed: _getOnPressed(),
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.foregroundColor,
          side: BorderSide(color: colors.borderColor),
          minimumSize: Size(width ?? sizeConfig.minWidth, sizeConfig.height),
          padding: sizeConfig.padding,
        ),
        child: buttonChild,
      ),
      AppButtonVariant.text => TextButton(
        onPressed: _getOnPressed(),
        style: TextButton.styleFrom(
          foregroundColor: colors.foregroundColor,
          minimumSize: Size(width ?? sizeConfig.minWidth, sizeConfig.height),
          padding: sizeConfig.padding,
        ),
        child: buttonChild,
      ),
      AppButtonVariant.elevated => ElevatedButton(
        onPressed: _getOnPressed(),
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.backgroundColor,
          foregroundColor: colors.foregroundColor,
          minimumSize: Size(width ?? sizeConfig.minWidth, sizeConfig.height),
          padding: sizeConfig.padding,
        ),
        child: buttonChild,
      ),
    };

    if (width != null) {
      button = SizedBox(width: width, child: button);
    }

    return button;
  }

  VoidCallback? _getOnPressed() {
    if (isDisabled || isLoading) return null;
    return onPressed;
  }

  Widget _buildButtonContent(ThemeData theme) {
    if (isLoading) {
      return SizedBox(
        height: _getSizeConfig().iconSize,
        width: _getSizeConfig().iconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            foregroundColor ?? theme.colorScheme.onPrimary,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: _getSizeConfig().iconSize),
          const SizedBox(width: 8),
          Text(text, style: _getSizeConfig().textStyle),
        ],
      );
    }

    return Text(text, style: _getSizeConfig().textStyle);
  }

  _ButtonSizeConfig _getSizeConfig() {
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
        textStyle: TextStyle(fontSize: 16),
      ),
    };
  }

  _ButtonColors _getColors(ColorScheme colorScheme) {
    final defaultColors = switch (variant) {
      AppButtonVariant.filled => _ButtonColors(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        borderColor: colorScheme.primary,
      ),
      AppButtonVariant.outlined => _ButtonColors(
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.primary,
        borderColor: colorScheme.outline,
      ),
      AppButtonVariant.text => _ButtonColors(
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.primary,
        borderColor: Colors.transparent,
      ),
      AppButtonVariant.elevated => _ButtonColors(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.primary,
        borderColor: Colors.transparent,
      ),
    };

    return _ButtonColors(
      backgroundColor: backgroundColor ?? defaultColors.backgroundColor,
      foregroundColor: foregroundColor ?? defaultColors.foregroundColor,
      borderColor: defaultColors.borderColor,
    );
  }
}

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
