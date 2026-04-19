// ------------------------------------------------------------
// 🔤 Peticare UI Kit — AppTextStyles Configuration
// ------------------------------------------------------------
// This file defines the **global text styles** used throughout the Peticare UI Kit.
//
// The `AppTextStyles` class centralizes all typography definitions,
// ensuring **visual harmony**, **readability**, and **brand consistency** across
// all screens, widgets, and themes (light/dark).
//
// **Purpose:**
// - Maintain consistent font weights, sizes, and hierarchies.
// - Simplify text styling by providing reusable constants.
// - Ensure all text adheres to the same typographic scale and tone.
//
// **Usage Example:**
// ```dart
// Text(
//   'Welcome Back!',
//   style: AppTextStyles.headingMedium,
// );
// ```
//
// **Customization:**
// You can easily modify font families, weights, or sizes
// to align with your own brand or app identity.
// If your app uses Google Fonts or custom fonts, you can integrate them here
// to automatically propagate typography changes across the entire project.
//
// **Includes (Common Structure):**
// - Headings (Large, Medium, Small)
// - Body Text (Regular, Medium, Bold)
// - CTA (Call-to-Action) Styles
// - Caption / Label Text
//
// **Note:**
// This file does not handle dynamic color changes —
// colors are managed in the `AppPalette` file and applied through `AppTheme`.
//
// ------------------------------------------------------------

import 'package:flutter/material.dart';

class AppTextStyles {
  // Poppins (Headings, Bold CTAs)
  static TextStyle headingLarge = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 32,
    fontWeight: FontWeight.w600, // SemiBold
  );

  static TextStyle headingMedium = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  static TextStyle ctaBold = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16,
    fontWeight: FontWeight.bold, // Bold
  );

  // Inter (Body, Subtle Text)
  static TextStyle bodyRegular = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w400, // Regular
  );

  static TextStyle bodyMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    fontWeight: FontWeight.w500, // Medium
  );

  static TextStyle buttonText = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w600, // SemiBold
    color: Colors.white, // Typically white for buttons
  );

  // Quicksand (Playful Accents)
  static TextStyle petName = TextStyle(
    fontFamily: 'Quicksand',
    fontSize: 16,
    fontWeight: FontWeight.w500, // Medium
  );

  static TextStyle playfulTag = TextStyle(
    fontFamily: 'Quicksand',
    fontSize: 14,
    fontWeight: FontWeight.w700, // Bold
  );

  // Optional: Add dark mode variants
  static TextStyle darkModeText = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.white, // Adjust for dark mode
  );
}
