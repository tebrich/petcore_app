import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:peticare/core/commn/presentation/widgets/floating_aniamation.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:get/get.dart';

/// Builds the fourth onboarding page widget. 🐶
///
/// This page emphasizes the notification features for pet care tasks.
/// It utilizes a floating animation to draw attention to the notification icon.
/// The page includes a descriptive illustration and associated text to inform the user.
///
/// Args:
///   context (BuildContext): The context in which the widget is built, providing access to the current theme and resources.
///   screenSize (Size): The size of the screen, used for responsive layout adjustments.
Widget fourthOnBoardingPage(BuildContext context, Size screenSize) {
  return Column(
    children: [
      screenSize.height < 675 ? SizedBox() : Spacer(flex: 1),
      Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            'assets/illustrations/background_shape.svg',

            /// Background shape illustration.
            height: screenSize.height < 675 ? 325 : 350,
            colorFilter: ColorFilter.mode(
              AppPalette.surfaces(context),
              BlendMode.srcATop,
            ),
          ),
          FloatingAnimation(
            type: FloatingType.wave,

            /// Animates the notification icon with a wave-like floating motion.
            duration: Duration(seconds: 9),
            floatStrength: 3,
            curve: Curves.linear,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                SvgPicture.asset(
                  'assets/illustrations/background_shape.svg',

                  /// Background shape illustration within the floating animation.
                  height: screenSize.height < 675 ? 250 : 275,
                  colorFilter: ColorFilter.mode(
                    AppPalette.primary.withValues(alpha: 0.5),
                    BlendMode.srcATop,
                  ),
                ),
                SvgPicture.asset(
                  'assets/illustrations/notifications.svg',

                  /// Notification icon illustration.
                  height: screenSize.height < 675 ? 200 : 225,
                ),
              ],
            ),
          ),
        ],
      ),
      VerticalSpacing.xl(context),

      /// Texts
      Padding(
        /// Padding applied to the text content for visual spacing.
        padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'onboarding_4_title'.tr,
                style: AppTextStyles.headingLarge.copyWith(
                  /// Styling for the heading text.
                  color: AppPalette.primaryText(context),
                  fontSize: 35,
                ),
              ),

              TextSpan(
                text:
                    '\n${'onboarding_4_subtitle'.tr}',
                style: AppTextStyles.bodyRegular.copyWith(
                  /// Styling for the body text.
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
