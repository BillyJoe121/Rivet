import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Tema global de Material 3 configurado con los tokens de Rivet.
abstract final class AppTheme {
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.brand700,
      onPrimary: Colors.white,
      secondary: AppColors.clay600,
      onSecondary: Colors.white,
      error: AppColors.danger700,
      onError: Colors.white,
      surface: AppColors.surface0,
      onSurface: AppColors.ink900,
      outline: AppColors.line300,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.paper100,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.paper100,
        foregroundColor: AppColors.ink900,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.sectionTitle,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: const IconThemeData(color: AppColors.ink900),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface0,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.roundedMd,
          side: const BorderSide(color: AppColors.line300, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface0,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: 14,
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.ink500),
        labelStyle: AppTypography.bodyMedium.copyWith(color: AppColors.ink700),
        border: OutlineInputBorder(
          borderRadius: AppSpacing.roundedSm,
          borderSide: const BorderSide(color: AppColors.line300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.roundedSm,
          borderSide: const BorderSide(color: AppColors.line300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSpacing.roundedSm,
          borderSide: const BorderSide(color: AppColors.brand700, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.roundedSm,
          borderSide: const BorderSide(color: AppColors.danger700),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.roundedSm,
          borderSide: const BorderSide(color: AppColors.danger700, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brand700,
          foregroundColor: Colors.white,
          minimumSize: const Size(48, AppSpacing.minTouchTarget),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          shape: RoundedRectangleBorder(borderRadius: AppSpacing.roundedSm),
          textStyle: AppTypography.buttonText,
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.ink900,
          minimumSize: const Size(48, AppSpacing.minTouchTarget),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          side: const BorderSide(color: AppColors.line300),
          shape: RoundedRectangleBorder(borderRadius: AppSpacing.roundedSm),
          textStyle: AppTypography.buttonText,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.brand700,
          textStyle: AppTypography.buttonText,
          shape: RoundedRectangleBorder(borderRadius: AppSpacing.roundedSm),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.line300,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
