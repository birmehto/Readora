import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  // Base text theme using Google Fonts
  static TextTheme get textTheme => GoogleFonts.interTextTheme();
  static TextTheme get headingTextTheme => GoogleFonts.poppinsTextTheme();
  static TextTheme get readingTextTheme => GoogleFonts.sourceSerif4TextTheme();
  static TextTheme get codeTextTheme => GoogleFonts.jetBrainsMonoTextTheme();
  // Display styles - Using Poppins for impact
  static TextStyle displayLarge(BuildContext context) => GoogleFonts.poppins(
    fontSize: 32.sp,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: AppColors.textPrimary(context),
    letterSpacing: -0.5,
  );

  static TextStyle displayMedium(BuildContext context) => GoogleFonts.poppins(
    fontSize: 28.sp,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.textPrimary(context),
    letterSpacing: -0.25,
  );

  static TextStyle displaySmall(BuildContext context) => GoogleFonts.poppins(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.textPrimary(context),
  );

  // Headline styles - Using Poppins for headings
  static TextStyle headlineLarge(BuildContext context) => GoogleFonts.poppins(
    fontSize: 22.sp,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textPrimary(context),
  );

  static TextStyle headlineMedium(BuildContext context) => GoogleFonts.poppins(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textPrimary(context),
  );

  static TextStyle headlineSmall(BuildContext context) => GoogleFonts.poppins(
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.textPrimary(context),
  );

  // Title styles - Using Inter for UI elements
  static TextStyle titleLarge(BuildContext context) => GoogleFonts.inter(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textPrimary(context),
  );

  static TextStyle titleMedium(BuildContext context) => GoogleFonts.inter(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.textPrimary(context),
  );

  static TextStyle titleSmall(BuildContext context) => GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.textPrimary(context),
  );

  // Body styles - Using Inter for UI text
  static TextStyle bodyLarge(BuildContext context) => GoogleFonts.inter(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: AppColors.textPrimary(context),
  );

  static TextStyle bodyMedium(BuildContext context) => GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textSecondary(context),
  );

  static TextStyle bodySmall(BuildContext context) => GoogleFonts.inter(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.textTertiary(context),
  );

  // Label styles - Using Inter for labels
  static TextStyle labelLarge(BuildContext context) => GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.textPrimary(context),
    letterSpacing: 0.1,
  );

  static TextStyle labelMedium(BuildContext context) => GoogleFonts.inter(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    height: 1.3,
    color: AppColors.textSecondary(context),
    letterSpacing: 0.5,
  );

  static TextStyle labelSmall(BuildContext context) => GoogleFonts.inter(
    fontSize: 11.sp,
    fontWeight: FontWeight.w500,
    height: 1.3,
    color: AppColors.textTertiary(context),
    letterSpacing: 0.5,
  );

  // Special styles - Using Inter
  static TextStyle caption(BuildContext context) => GoogleFonts.inter(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    height: 1.3,
    color: AppColors.textTertiary(context),
  );

  static TextStyle overline(BuildContext context) => GoogleFonts.inter(
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
    height: 1.6,
    color: AppColors.textTertiary(context),
    letterSpacing: 1.5,
  );

  // Reading content styles - Using Source Serif Pro for better readability
  static TextStyle articleTitle(BuildContext context) => GoogleFonts.poppins(
    fontSize: 28.sp,
    fontWeight: FontWeight.w700,
    height: 1.3,
    color: AppColors.textPrimary(context),
    letterSpacing: -0.5,
  );

  static TextStyle articleSubtitle(BuildContext context) =>
      GoogleFonts.sourceSerif4(
        fontSize: 20.sp,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: AppColors.textSecondary(context),
        letterSpacing: -0.25,
      );

  static TextStyle articleBody(BuildContext context) =>
      GoogleFonts.sourceSerif4(
        fontSize: 18.sp,
        fontWeight: FontWeight.w400,
        height: 1.8,
        color: AppColors.textPrimary(context),
        letterSpacing: 0.1,
      );

  static TextStyle articleAuthor(BuildContext context) => GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.textSecondary(context),
  );

  static TextStyle articleMeta(BuildContext context) => GoogleFonts.inter(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    height: 1.3,
    color: AppColors.textTertiary(context),
  );

  static TextStyle articleQuote(BuildContext context) =>
      GoogleFonts.sourceSerif4(
        fontSize: 18.sp,
        fontWeight: FontWeight.w400,
        height: 1.7,
        fontStyle: FontStyle.italic,
        color: AppColors.textSecondary(context),
        letterSpacing: 0.1,
      );

  // Code styles - Using JetBrains Mono for code blocks
  static TextStyle code(BuildContext context) => GoogleFonts.jetBrainsMono(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textPrimary(context),
    letterSpacing: 0.0,
  );

  static TextStyle codeBlock(BuildContext context) => GoogleFonts.jetBrainsMono(
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: AppColors.textPrimary(context),
    letterSpacing: 0.0,
  );

  // Button styles
  static TextStyle button(BuildContext context) => GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.1,
  );

  static TextStyle buttonLarge(BuildContext context) => GoogleFonts.inter(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.1,
  );

  // Navigation styles
  static TextStyle navigation(BuildContext context) => GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    height: 1.3,
    color: AppColors.textSecondary(context),
  );

  // Badge styles
  static TextStyle badge(BuildContext context) => GoogleFonts.inter(
    fontSize: 11.sp,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.5,
  );
}
