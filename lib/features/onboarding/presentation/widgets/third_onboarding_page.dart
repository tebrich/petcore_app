import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:peticare/core/commn/presentation/widgets/floating_aniamation.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:get/get.dart';

/// Builds the third onboarding page widget. 🩺
///
/// This page focuses on expert vet care and hygiene monitoring for pets.
/// It incorporates a pulse animation to highlight the veterinary check-up illustration.
/// The page includes descriptive text and visuals to inform the user about these features.
///
/// Args:
///   context (BuildContext): The context in which the widget is built, providing access to the current theme and resources.
///   screenSize (Size): The size of the screen, used for responsive layout adjustments.
Widget thirdOnBoardingPage(BuildContext context, Size screenSize) {
  return Column(
    children: [
      screenSize.height < 675 ? SizedBox() : Spacer(flex: 1),
      Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            'assets/illustrations/background_shape.svg',

            /// Background shape illustration.
            height: screenSize.height < 675 ? 320 : 350,
            colorFilter: ColorFilter.mode(
              AppPalette.surfaces(context),
              BlendMode.srcATop,
            ),
          ),
          FloatingAnimation(
            type: FloatingType.pulse,

            /// Animates the vet check icon with a pulse-like floating motion.
            duration: Duration(seconds: 5),
            floatStrength: 1.25,
            curve: Curves.linear,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                SvgPicture.asset(
                  'assets/illustrations/background_shape.svg',

                  /// Background shape illustration within the floating animation.
                  height: screenSize.height < 675 ? 245 : 275,
                  colorFilter: ColorFilter.mode(
                    AppPalette.primary.withValues(alpha: 0.5),
                    BlendMode.srcATop,
                  ),
                ),
                Positioned(
                  bottom: -12.5,
                  child: SvgPicture.asset(
                    /// Vet check illustration.
                    'assets/illustrations/vet_check.svg',
                    height: screenSize.height < 675 ? 195 : 225,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      VerticalSpacing.xl(context),

      /// Texts
      /// Padding applied to the text content for visual spacing.
      Padding(
        padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'onboarding_3_title'.tr,

                /// Styling for the heading text.
                style: AppTextStyles.headingLarge.copyWith(
                  color: AppPalette.primaryText(context),
                  fontSize: 35,
                ),
              ),

              TextSpan(
                text:
                    '\n${'onboarding_3_subtitle'.tr}',

                /// Styling for the body text.
                style: AppTextStyles.bodyRegular.copyWith(
                  color: AppPalette.secondaryText(context),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
      const Spacer(flex: 2),
    ],
  );
}
