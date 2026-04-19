import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';

/// Builds a widget that displays the pet's overall health status. ❤️‍🩹
///
/// This widget is a key component of the "Health" tab in the `PetDetailsPage`.
/// It provides a quick, at-a-glance summary of the pet's general wellness,
/// indicated by a title, a status text (e.g., "Good"), and a decorative icon.
///
/// The widget is styled with a background color, rounded corners, and a subtle
/// box shadow to make it stand out on the page.
///
/// [Args]:
///   - `context`: The build context for accessing theme and other resources.
///   - `screenSize`: The dimensions of the screen, used for layout calculations.
Widget overallWelnessWidget(BuildContext context, Size screenSize) {
  return Container(
    width: screenSize.width * 0.9,
    padding: EdgeInsetsGeometry.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      color: AppPalette.background(context),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: .1),
          spreadRadius: 1.5,
          blurRadius: 3,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// The main title for the section.
        Text(
          'Estado de Salud',
          style: AppTextStyles.bodyRegular.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),

        /// Vertical spacing for visual separation.
        VerticalSpacing.sm(context),

        Row(
          children: [
            Container(
              /// A decorative circular container holding a paw icon.
              /// The color is set to `AppPalette.success` to visually indicate a positive status.
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                color: AppPalette.success(context),
                shape: BoxShape.circle,
              ),
              child: FaIcon(
                FontAwesomeIcons.paw,
                color: AppPalette.background(context).withValues(alpha: .9),
                size: 25,
              ),
            ),
            Expanded(
              /// A `Text.rich` widget is used to combine the "Overall Wellness" title
              /// with its "Good" status, allowing for different styling on each part.
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Bienestar general",
                      style: AppTextStyles.bodyRegular.copyWith(fontSize: 15),
                    ),

                    /// The status text (e.g., "Good"), styled with a secondary/disabled color.
                    TextSpan(
                      text: "\nBueno",
                      style: AppTextStyles.bodyRegular.copyWith(
                        fontSize: 14,
                        color: AppPalette.disabled(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
