import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peticare/core/commn/presentation/controllers/theme_controller.dart';

/// `AppPalette` provides a context-aware color scheme for light and dark modes.
///
/// Instead of static getters, use methods that take BuildContext to get current theme.
/// This ensures colors update when theme changes.

class AppPalette {
  // ==================== CONTEXT-AWARE METHODS ====================
  // Use these methods instead of static getters

  static Color get primary {
    ThemeController themeController = Get.find<ThemeController>();
    return themeController.primaryColor;
  }

  static Color secondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? dSecondary
        : lSecondary;
  }

  static Color success(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? dSuccess
        : lSuccess;
  }

  static Color warning(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? dWarning
        : lWarning;
  }

  static Color danger(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? dDanger : lDanger;
  }

  static Color background(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? dBackground
        : lBackground;
  }

  static Color surfaces(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? dSurfaces
        : lSurfaces;
  }

  static Color secondaryText(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? dSecondaryText
        : lSecondaryText;
  }

  static Color primaryText(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? dPrimaryText
        : lPrimaryText;
  }

  static Color textOnSecondaryBg(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? dTextOnSecondaryBg
        : lTextOnSecondaryBg;
  }

  static Color disabled(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? dDisabled
        : lDisabled;
  }

  // ==================== LIGHT MODE COLORS ====================
  static const Color lSecondary = Color(0xffFF9E5E);
  static const Color lSuccess = Color(0xff6BD9A7);
  static const Color lWarning = Color(0xffFFD166);
  static const Color lDanger = Color(0xffFF6B6B);
  static const Color lBackground = Color(0xffF8F9FA);
  static const Color lSurfaces = Color(0xffE9ECEF);
  static const Color lSecondaryText = Color(0xff6C757D);
  static const Color lPrimaryText = Color(0xff212529);
  static const Color lTextOnSecondaryBg = Color(0xFF1A365D);
  static const Color lDisabled = Color(0xffAFAFAF);

  // ==================== DARK MODE COLORS ====================
  static const Color dSecondary = Color(0xffFFB27D);
  static const Color dSuccess = Color(0xff64D1A2);
  static const Color dWarning = Color(0xffFFD860);
  static const Color dDanger = Color(0xffFF7F7F);
  static const Color dBackground = Color(0xff121417);
  static const Color dSurfaces = Color(0xff23272C);
  static const Color dSecondaryText = Color(0xffB0B3B8);
  static const Color dPrimaryText = Color(0xffF1F3F5);
  static const Color dTextOnSecondaryBg = Color(0xffA5A8AD);
  static const Color dDisabled = Color(0xff555A60);

  // ==================== STATIC BRAND COLORS ====================
  // These can remain static as they don't change with theme
  static const Color softBlue = Color(0xff4A8FE7);
  static const Color roseQuartz = Color(0xffE3B7C4);
  static const Color coralRose = Color(0xffFF7C70);
  static const Color lavenderMist = Color(0xffA88ED9);
  static const Color dunflowerGold = Color(0xffF6C343);
  static const Color aquaBreeze = Color(0xff30B2A3);
  static const Color blushPeach = Color(0xffFDAF9D);
  static const Color stormBlue = Color(0xff2E3A59);
}
