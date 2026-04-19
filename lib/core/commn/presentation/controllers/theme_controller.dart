import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:peticare/core/theme/app_pallete.dart';

/// A [GetxController] for managing the application's theme.
///
/// This controller handles the state for the app's visual appearance, including
/// switching between light and dark modes and changing the primary accent color.
/// As part of a UI kit, this allows for easy demonstration and customization of
/// the app's branding.
///
/// > 💡 **Note**: In a production app, you would typically persist the user's
/// theme preference to local storage (e.g., using `shared_preferences`) and
/// load it when the app starts.
class ThemeController extends GetxController {
  /// The current theme mode of the application (e.g., light or dark).
  /// Defaults to [ThemeMode.light].
  ThemeMode _themeMode = ThemeMode.light;

  /// The primary accent color used throughout the app.
  /// Defaults to [AppPalette.softBlue].
  Color _primaryColor = AppPalette.softBlue;

  /// Gets the current [ThemeMode].
  ThemeMode get themeMode => _themeMode;

  /// Gets the current primary [Color].
  Color get primaryColor => _primaryColor;

  /// Sets the application's theme mode and notifies listeners to rebuild.
  void setTheme(ThemeMode themeMode) {
    _themeMode = themeMode;
    update();
  }

  /// Sets the primary accent color and notifies listeners to rebuild.
  void setPrimaryColor(Color primaryColor) {
    _primaryColor = primaryColor;
    update();
  }
}
