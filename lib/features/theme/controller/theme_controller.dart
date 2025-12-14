import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  static const String _themeKey = 'theme_mode';
  final GetStorage _storage = GetStorage();

  final _themeMode = ThemeMode.system.obs;

  ThemeMode get themeMode => _themeMode.value;

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromStorage();
  }

  void _loadThemeFromStorage() {
    try {
      final savedTheme = _storage.read(_themeKey);
      if (savedTheme != null) {
        final themeMode = ThemeMode.values.firstWhere(
          (mode) => mode.toString() == savedTheme,
          orElse: () => ThemeMode.system,
        );
        _themeMode.value = themeMode;
        Get.changeThemeMode(themeMode);
      }
    } catch (e) {
      // Handle error silently
    }
  }

  void setThemeMode(ThemeMode mode) {
    try {
      _themeMode.value = mode;
      Get.changeThemeMode(mode);
      _storage.write(_themeKey, mode.toString());
    } catch (e) {
      // Handle error silently
    }
  }

  void toggleTheme() {
    switch (_themeMode.value) {
      case ThemeMode.light:
        setThemeMode(ThemeMode.dark);
        break;
      case ThemeMode.dark:
        setThemeMode(ThemeMode.system);
        break;
      case ThemeMode.system:
        setThemeMode(ThemeMode.light);
        break;
    }
  }

  bool get isDarkMode {
    if (_themeMode.value == ThemeMode.system) {
      return Get.isPlatformDarkMode;
    }
    return _themeMode.value == ThemeMode.dark;
  }

  IconData get themeIcon {
    switch (_themeMode.value) {
      case ThemeMode.light:
        return Icons.light_mode_outlined;
      case ThemeMode.dark:
        return Icons.dark_mode_outlined;
      case ThemeMode.system:
        return Icons.brightness_auto_outlined;
    }
  }
}
