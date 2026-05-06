import 'package:flutter/material.dart';
import 'package:lowgos_app/theme/app_colors.dart';
import 'package:lowgos_app/theme/app_fonts.dart';

ThemeData getLightTheme() {
  return ThemeData(
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),
    useMaterial3: true,
    unselectedWidgetColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.scaffoldBackground,
    primarySwatch: Colors.blue,
    brightness: Brightness.light,
    fontFamily: AppFonts.cairo,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryColor,
      brightness: Brightness.light,
    ),
    textTheme: const TextTheme(
      // Headline styles
      // headlineLarge: AppTextStyles.font25Bold.copyWith(color: AppColors.white),
      // headlineMedium:
      //     AppTextStyles.font14Regular.copyWith(color: AppColors.white),
      // headlineSmall:
      //     AppTextStyles.font14Regular.copyWith(color: AppColors.white),

      // // Title styles
      // titleLarge: AppTextStyles.font20Bold.copyWith(color: AppColors.white),
      // titleMedium: AppTextStyles.font16Bold.copyWith(color: AppColors.white),
      // titleSmall: AppTextStyles.font14Bold.copyWith(color: AppColors.white),

      // // Body styles
      // bodyLarge: AppTextStyles.font16Regular.copyWith(color: AppColors.white),
      // bodyMedium: AppTextStyles.font14Regular.copyWith(color: AppColors.white),
      // bodySmall: AppTextStyles.font12Regular.copyWith(color: AppColors.white),

      // // Display styles
      // displayLarge: AppTextStyles.font32Bold.copyWith(color: AppColors.white),
      // displayMedium: AppTextStyles.font28Regular.copyWith(color: AppColors.white),
      // displaySmall: AppTextStyles.font24Regular.copyWith(color: AppColors.white),

      // // Label styles
      // labelLarge: AppTextStyles.font14Medium.copyWith(color: AppColors.white),
      // labelMedium: AppTextStyles.font12Medium.copyWith(color: AppColors.white),
      // labelSmall: AppTextStyles.font10Medium.copyWith(color: AppColors.white),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      showSelectedLabels: true,
      showUnselectedLabels: true,
      backgroundColor: Colors.white,
      elevation: 0.0,
      unselectedItemColor: AppColors.black,
      selectedItemColor: AppColors.primaryColor,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(
        fontSize: 14,
        fontFamily: AppFonts.cairo,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 14,
        fontFamily: AppFonts.cairo,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
