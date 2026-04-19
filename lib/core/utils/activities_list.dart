import 'package:flutter/material.dart';
import 'package:peticare/core/theme/app_pallete.dart';

/// Returns a map of pet activity types with their corresponding
/// theme color and icon asset.
///
/// Used across the app to display consistent visuals for different
/// pet care activities such as feeding, walking, playing, or bathing.
///
Map<String, Map<String, dynamic>> activitiesList(BuildContext context) {
  return {
    "Medocs": {
      'Color': AppPalette.danger(context),
      'Icon': 'assets/illustrations/medecines2.svg',
    },
    "Food": {
      'Color': AppPalette.lavenderMist,
      'Icon': 'assets/illustrations/food_bowl.svg',
    },
    "Walk": {
      'Color': AppPalette.primary,
      'Icon': 'assets/illustrations/colar.svg',
    },
    "Play": {
      'Color': AppPalette.secondary(context),
      'Icon': 'assets/illustrations/ball_toy.svg',
    },
    "Bath": {
      'Color': AppPalette.success(context),
      'Icon': 'assets/illustrations/bathtub.svg',
    },
    "Clean-Cage": {
      'Color': AppPalette.warning(context),
      'Icon': 'assets/illustrations/cage.svg',
    },
    "Sleep": {
      'Color': AppPalette.primary,
      'Icon': 'assets/illustrations/sleep.svg',
    },
  };
}
