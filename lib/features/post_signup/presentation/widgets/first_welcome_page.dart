import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:peticare/core/commn/presentation/widgets/floating_aniamation.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';

/// Builds the initial welcome page for the post-signup user flow. 🎉
///
/// This widget serves as the very first screen presented to a user immediately
/// after they have successfully created an account. Its primary purpose is to
/// provide a warm welcome and guide the user toward the next step: adding their
/// first pet's details.
///
/// The UI features a prominent, friendly illustration of a happy pet, which is
/// enhanced with a subtle `FloatingAnimation` to create a more dynamic and
/// engaging experience. The layout is designed to be responsive, adapting to
/// different screen heights.
///
/// [Args]:
///   - `context` (BuildContext): The build context for accessing theme and other resources.
///   - `screenSize` (Size): The dimensions of the screen, used for responsive UI adjustments.
Widget firstWelcomePage(BuildContext context, Size screenSize) {
  return SafeArea(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /// Adds flexible top spacing on taller devices for better vertical centering.
        if (screenSize.height >= 675) const Spacer(flex: 2),
        Stack(
          alignment: Alignment.center,
          children: [
            /// The primary background shape, providing a surface for other elements.
            SvgPicture.asset(
              'assets/illustrations/background_shape.svg',
              height: screenSize.height < 675 ? 350 : 375,
              colorFilter: ColorFilter.mode(
                AppPalette.surfaces(context),
                BlendMode.srcATop,
              ),
            ),

            /// Applies a gentle wave-like motion to the central illustration stack.
            FloatingAnimation(
              type: FloatingType.wave,
              duration: Duration(seconds: 8),
              floatStrength: 2.5,
              curve: Curves.linear,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  /// A secondary, colored background shape within the animation.
                  SvgPicture.asset(
                    'assets/illustrations/background_shape.svg',
                    height: screenSize.height < 675 ? 275 : 300,
                    colorFilter: ColorFilter.mode(
                      AppPalette.primary.withValues(alpha: 0.5),
                      BlendMode.srcATop,
                    ),
                  ),

                  /// The main welcoming illustration featuring a happy dog.
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: SvgPicture.asset(
                      'assets/illustrations/happy_dog_heart.svg',
                      height: screenSize.height < 675 ? 250 : 275,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Space after illustration
        VerticalSpacing.xl(context),

        /// The main text block containing the heading and subheading.
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
          child: Text.rich(
            TextSpan(
              children: [
                /// The primary "Welcome!" heading.
                TextSpan(
                  text: "Bienenido!",
                  style: AppTextStyles.headingLarge.copyWith(
                    color: AppPalette.textOnSecondaryBg(context),
                    fontSize: 35,
                  ),
                ),

                /// The descriptive subheading that prompts the user for the next action.
                TextSpan(
                  text:
                      "\nIngresa los datos de tu mascota para una experiencia personalizada.",
                  style: AppTextStyles.bodyRegular.copyWith(
                    color: AppPalette.disabled(context),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),

        /// Provides flexible bottom spacing on taller devices to ensure content remains centered.
        (screenSize.hashCode >= 675)
            ? const Spacer(flex: 3)
            : VerticalSpacing.lg(context),
      ],
    ),
  );
}
