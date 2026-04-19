// ------------------------------------------------------------
// 🎨 Peticare UI Kit — AppTheme Configuration
// ------------------------------------------------------------
// This file defines the **global theming system** for the Peticare UI Kit.
//
// It manages both the **light** and **dark** modes using Flutter's `ThemeData`,
// ensuring visual consistency across all screens and widgets.
// The `AppTheme` class centralizes all theme logic, making it easier
// to maintain, extend, and adapt the UI style to different brands or apps.
//
// **Key Responsibilities:**
// - Define the **color schemes** for both light and dark modes.
// - Apply consistent **text styles**, **input decorations**, and **navigation bar styles**.
// - Customize Flutter’s Material 3 widgets such as Switches, Dropdowns, and TextFields.
// - Integrate global styles from:
//   - `AppPalette` → defines all color constants.
//   - `AppTextStyles` → defines global typography.
//
// **Usage Example:**
// ```dart
// GetMaterialApp(
//   title: 'Peticare',
//   theme: AppTheme.lightTheme(primaryColor),
//   darkTheme: AppTheme.darkTheme(primaryColor),
//   themeMode: ThemeMode.system,
// );
// ```
//
// **Customization:**
// You can modify the theming logic or replace `GetX` state management
// with your preferred solution — e.g., `Provider`, `Riverpod`, or `Bloc`.
// `GetX` is used here **for simplicity** and **demonstration purposes only**
// since this project is primarily a **UI Kit**, not a production-ready app.
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';

class AppTheme {
  static ThemeData lightTheme(Color primaryColor) => ThemeData(
    useMaterial3: true,
    colorScheme: _lightColorScheme(primaryColor),
    scaffoldBackgroundColor: AppPalette.lBackground,
    disabledColor: AppPalette.lDisabled,

    switchTheme: _getSwitchTheme(false),
    inputDecorationTheme: _getInputDecorationTheme(false, primaryColor),
    dropdownMenuTheme: _getDropdownMenuTheme(false, primaryColor),
    textTheme: _getTextTheme(),
    navigationBarTheme: _getNavigationBarTheme(false, primaryColor),
  );

  static ThemeData darkTheme(Color primaryColor) => ThemeData(
    useMaterial3: true,
    colorScheme: _darkColorScheme(primaryColor),
    scaffoldBackgroundColor: AppPalette.dBackground,
    disabledColor: AppPalette.dDisabled,

    switchTheme: _getSwitchTheme(true),
    inputDecorationTheme: _getInputDecorationTheme(true, primaryColor),
    dropdownMenuTheme: _getDropdownMenuTheme(true, primaryColor),
    textTheme: _getTextTheme(),
    navigationBarTheme: _getNavigationBarTheme(true, primaryColor),
  );

  static ColorScheme _lightColorScheme(Color primaryColor) => ColorScheme(
    brightness: Brightness.light,
    primary: primaryColor,
    onPrimary: Colors.white,
    primaryContainer: primaryColor.withValues(alpha: 0.2),

    secondary: AppPalette.lSecondary,
    onSecondary: Colors.white,
    secondaryContainer: AppPalette.lSecondary.withValues(alpha: 0.2),

    tertiary: AppPalette.lSuccess,
    onTertiary: Colors.white,
    tertiaryContainer: AppPalette.lSuccess.withValues(alpha: 0.2),

    error: AppPalette.lDanger,
    onError: Colors.white,
    errorContainer: AppPalette.lDanger.withValues(alpha: 0.1),

    surface: AppPalette.lBackground,
    onSurface: AppPalette.lPrimaryText,
    surfaceContainerHighest: AppPalette.lSurfaces,

    outline: AppPalette.lSurfaces,
    outlineVariant: AppPalette.lDisabled,
  );

  static ColorScheme _darkColorScheme(Color primaryColor) =>
      ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        primary: primaryColor,
        onPrimary: Colors.white,
        primaryContainer: primaryColor.withValues(alpha: 0.3),

        secondary: AppPalette.dSecondary,
        onSecondary: Colors.black,
        secondaryContainer: AppPalette.dSecondary.withValues(alpha: 0.3),

        tertiary: AppPalette.dSuccess,
        onTertiary: Colors.black,
        tertiaryContainer: AppPalette.dSuccess.withValues(alpha: 0.3),

        error: AppPalette.dDanger,
        onError: Colors.white,
        errorContainer: AppPalette.dDanger.withValues(alpha: 0.2),

        surface: AppPalette.dBackground,
        onSurface: Colors.white.withValues(alpha: 0.87),
        surfaceContainerHighest: AppPalette.dSurfaces,

        outline: AppPalette.dSurfaces,
        outlineVariant: AppPalette.dDisabled,
      );

  static SwitchThemeData _getSwitchTheme(bool isDark) {
    return SwitchThemeData(
      thumbColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return isDark ? AppPalette.dBackground : AppPalette.lBackground;
        } else {
          return AppPalette.lBackground;
        }
      }),
    );
  }

  static InputDecorationTheme _getInputDecorationTheme(
    bool isDark,
    Color primaryColor,
  ) {
    final borderColor = isDark ? AppPalette.lDisabled : AppPalette.dDisabled;
    final labelColor = isDark
        ? AppPalette.dSecondaryText
        : AppPalette.lSecondaryText;
    final hintColor = isDark
        ? AppPalette.dSecondaryText
        : AppPalette.lSecondaryText;
    final errorBorderColor = isDark ? AppPalette.dDanger : AppPalette.lDanger;

    return InputDecorationTheme(
      focusColor: primaryColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),

      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: borderColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(width: 1.5, color: primaryColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(width: 1.5, color: errorBorderColor),
      ),
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: borderColor, width: 1),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: borderColor, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: errorBorderColor, strokeAlign: 0.5),
      ),

      labelStyle: AppTextStyles.ctaBold.copyWith(
        color: labelColor,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      floatingLabelStyle: AppTextStyles.ctaBold.copyWith(
        color: primaryColor,
        fontSize: 13,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: AppTextStyles.bodyRegular.copyWith(
        color: hintColor,
        fontSize: 13,
      ),

      isDense: true,
      prefixIconConstraints: const BoxConstraints(
        minWidth: 30,
        maxWidth: 35,
        minHeight: 30,
        maxHeight: 50,
      ),
      prefixIconColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.focused)) {
          return primaryColor;
        } else {
          return borderColor;
        }
      }),
    );
  }

  static DropdownMenuThemeData _getDropdownMenuTheme(
    bool isDark,
    Color primaryColor,
  ) {
    return DropdownMenuThemeData(
      inputDecorationTheme: _getInputDecorationTheme(
        isDark,
        primaryColor,
      ).copyWith(constraints: BoxConstraints.tight(const Size.fromHeight(45))),
    );
  }

  static TextTheme _getTextTheme() {
    return TextTheme(
      headlineLarge: AppTextStyles.headingLarge,
      headlineMedium: AppTextStyles.headingMedium,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodyRegular,
    );
  }

  static NavigationBarThemeData _getNavigationBarTheme(
    bool isDark,
    Color primaryColor,
  ) {
    final backgroundColor = isDark
        ? AppPalette.dBackground
        : AppPalette.lBackground;
    final textColor = isDark
        ? AppPalette.dPrimaryText
        : AppPalette.lPrimaryText;
    final surfaceColor = isDark ? AppPalette.dSurfaces : AppPalette.lSurfaces;
    final disabledColor = isDark ? AppPalette.dDisabled : AppPalette.lDisabled;
    return NavigationBarThemeData(
      height: 65,
      backgroundColor: backgroundColor,
      indicatorColor: primaryColor,
      shadowColor: disabledColor,
      elevation: 10,
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        return IconThemeData(
          size: states.contains(WidgetState.selected) ? 25 : 20,
          color: states.contains(WidgetState.selected)
              ? surfaceColor
              : textColor,
        );
      }),
    );
  }
}
