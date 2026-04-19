import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:peticare/core/commn/presentation/widgets/animated_icon_button.dart';
import 'package:peticare/core/commn/presentation/widgets/floating_aniamation.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';

/// Builds the initial welcome page for the vet appointment booking flow. 🏥
///
/// This widget serves as the very first screen presented to a user when they
/// initiate the process of scheduling a new vet appointment. Its primary purpose
/// is to provide a clear and friendly introduction to the flow.
///
/// The UI features a prominent, relevant illustration (`add_new_vet_appointment.svg`),
/// which is enhanced with a subtle `FloatingAnimation` to create a more dynamic
/// and engaging experience. The layout is designed to be responsive, adapting to
/// different screen heights, and includes a "close" button to allow the user to
/// exit the flow at any time.
///
/// [Args]:
///   - `screenSize`: The dimensions of the screen, used for responsive UI adjustments.
///
/// [Returns]: A `Widget` representing the welcome page.
Widget welcomingFirstPage(Size screenSize) {
  return LayoutBuilder(
    builder: (context, constraints) {
      return Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Flexible top spacing for better vertical centering on taller devices.
              const Spacer(flex: 1),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.05,
                ),

                /// The main heading for the page, with a responsive font size.
                child: Text(
                  "Programar una cita con el veterinario!",
                  style: AppTextStyles.headingLarge.copyWith(
                    color: AppPalette.textOnSecondaryBg(context),
                    fontSize: constraints.maxHeight > 580 ? 35 : 32,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              /// Space after the title.
              VerticalSpacing.lg(context),

              Stack(
                alignment: Alignment.center,
                children: [
                  /// The primary background shape, providing a surface for other elements.
                  SvgPicture.asset(
                    'assets/illustrations/background_shape.svg',
                    height: constraints.maxHeight <= 580
                        ? constraints.maxHeight * 0.55
                        : 350,
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
                          height: constraints.maxHeight <= 580
                              ? constraints.maxHeight * 0.45
                              : 275,
                          colorFilter: ColorFilter.mode(
                            AppPalette.primary.withValues(alpha: .5),
                            BlendMode.srcATop,
                          ),
                        ),

                        /// The main illustration for this page, depicting a vet appointment.
                        /// Its size is responsive to the screen height.
                        Padding(
                          padding: const EdgeInsets.only(top: 25),
                          child: SvgPicture.asset(
                            'assets/illustrations/add_new_vet_appointment.svg',
                            height: constraints.maxHeight <= 580
                                ? constraints.maxHeight * .3
                                : 200,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              VerticalSpacing.xl(context),

              /// The descriptive subheading that prompts the user for the next action.
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.05,
                ),
                child: Text(
                  "Elige el tipo de consulta y proporciona algunos datos rápidos para comenzar.",
                  style: AppTextStyles.bodyRegular.copyWith(
                    color: AppPalette.primaryText(context),
                    fontSize: constraints.maxHeight <= 580 ? 15 : 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              /// Flexible bottom spacing for better vertical centering.
              const Spacer(flex: 1),
            ],
          ),

          /// A "close" button positioned at the top left to allow the user to exit the flow.
          Positioned(
            top: constraints.maxHeight * 0.1,
            left: 8,
            child: AnimatedIconButton(
              iconData: Icons.close_rounded,
              foregroundColor: AppPalette.primaryText(context),
              onClick: Get.back,
            ),
          ),
        ],
      );
    },
  );
}
