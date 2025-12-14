import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSpacing {
  // Base spacing values
  static double get xs => 4.w;
  static double get sm => 8.w;
  static double get md => 12.w;
  static double get lg => 16.w;
  static double get xl => 20.w;
  static double get xxl => 24.w;
  static double get xxxl => 32.w;

  // Screen padding
  static double get screenPadding => 16.w;
  static double get screenPaddingHorizontal => 16.w;
  static double get screenPaddingVertical => 20.h;

  // Card spacing
  static double get cardPadding => 16.w;
  static double get cardMargin => 8.w;
  static double get cardSpacing => 12.w;

  // Button spacing
  static double get buttonPadding => 16.w;
  static double get buttonHeight => 48.h;
  static double get buttonRadius => 12.r;

  // Input spacing
  static double get inputPadding => 16.w;
  static double get inputHeight => 56.h;
  static double get inputRadius => 12.r;

  // List spacing
  static double get listItemPadding => 16.w;
  static double get listItemSpacing => 8.h;
  static double get listSectionSpacing => 24.h;

  // Icon spacing
  static double get iconSize => 24.w;
  static double get iconSizeSmall => 16.w;
  static double get iconSizeLarge => 32.w;

  // Border radius
  static double get radiusSmall => 8.r;
  static double get radiusMedium => 12.r;
  static double get radiusLarge => 16.r;
  static double get radiusXLarge => 20.r;

  // Elevation
  static double get elevationLow => 2;
  static double get elevationMedium => 4;
  static double get elevationHigh => 8;

  // Animation durations (in milliseconds)
  static const int animationFast = 200;
  static const int animationMedium = 300;
  static const int animationSlow = 500;

  // Reading content styles
  static double get readingMaxWidth => 600.w;
  static double get readingPadding => 20.w;
}
