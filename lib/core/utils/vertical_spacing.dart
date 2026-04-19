// ---------------------------------------------------------------------------
// File: vertical_spacing.dart
// Description:
// Provides responsive vertical spacing utilities for consistent layout design.
//
// This file defines:
// - [ResponsiveSpacing]: A helper class that dynamically scales spacing
//   values based on the current device’s screen height.
// - [VerticalSpacing]: A simple widget for adding vertical gaps between UI
//   elements with responsive named constructors for cleaner layout code.
//
// This approach helps maintain visual balance across devices — from small
// phones to large tablets — ensuring proper spacing without hardcoding
// pixel values.
//
// ---------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:peticare/core/theme/app_spacing.dart';

// A utility class for calculating responsive spacing values based on
// the device’s screen height.
//
// The scaling logic ensures spacing feels consistent across different
// screen sizes — smaller on compact devices and larger on tablets or
// foldables.
class ResponsiveSpacing {
  // Returns a responsive vertical spacing value.
  //
  // The [baseSpacing] is adjusted proportionally to the screen height:
  // - `< 600`: Small screens → 60% of base spacing.
  // - `< 800`: Medium screens → 80% of base spacing.
  // - `< 1000`: Large screens → Normal spacing.
  // - `≥ 1000`: Extra large screens → 120% of base spacing.
  static double vertical(BuildContext context, double baseSpacing) {
    final screenHeight = MediaQuery.of(context).size.height;

    if (screenHeight < 600) {
      return baseSpacing * 0.6;
    } else if (screenHeight < 800) {
      return baseSpacing * 0.8;
    } else if (screenHeight < 1000) {
      return baseSpacing;
    } else {
      return baseSpacing * 1.2;
    }
  }

  // Returns a responsive height for illustrations based on the
  // screen height.
  //
  // Used mainly for welcome screens, onboarding, or empty states
  // to ensure images maintain visual balance.
  static double illustration(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    if (screenHeight < 600) {
      return screenHeight * 0.15;
    } else if (screenHeight < 800) {
      return screenHeight * 0.20;
    } else {
      return screenHeight * 0.25;
    }
  }
}

// A simple widget that adds vertical space between UI elements.
//
// It automatically scales spacing according to screen size using
// [ResponsiveSpacing]. This improves visual consistency across
// various devices.
//
// Example usage:
// ```dart
// Column(
//   children: [
//     Text('Title'),
//     VerticalSpacing.md(context),
//     Text('Subtitle'),
//   ],
// )
// ```
class VerticalSpacing extends StatelessWidget {
  // The final spacing height in logical pixels.
  final double spacing;

  const VerticalSpacing(this.spacing, {super.key});

  // Named constructors for common spacing values (responsive).
  VerticalSpacing.sm(BuildContext context, {super.key})
    : spacing = ResponsiveSpacing.vertical(context, AppSpacing.sm);

  VerticalSpacing.md(BuildContext context, {super.key})
    : spacing = ResponsiveSpacing.vertical(context, AppSpacing.md);

  VerticalSpacing.lg(BuildContext context, {super.key})
    : spacing = ResponsiveSpacing.vertical(context, AppSpacing.lg);

  VerticalSpacing.xl(BuildContext context, {super.key})
    : spacing = ResponsiveSpacing.vertical(context, AppSpacing.xl);

  VerticalSpacing.xxl(BuildContext context, {super.key})
    : spacing = ResponsiveSpacing.vertical(context, AppSpacing.xxl);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: spacing);
  }
}
