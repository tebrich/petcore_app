import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:peticare/core/commn/presentation/widgets/floating_aniamation.dart';
import 'package:peticare/core/theme/app_pallete.dart';
import 'package:peticare/core/theme/app_textstyles.dart';
import 'package:peticare/core/utils/vertical_spacing.dart';
import 'package:get/get.dart';

/// A widget function that builds the first onboarding screen.
///
/// This page introduces the pet health tracking feature of the application.
/// It uses a stack of widgets to create a visually engaging layout with
/// animated elements.
///
/// Key UI elements include:
/// - A background shape (`background_shape.svg`) that provides a surface for the content.
/// - A central illustration (`pet_helth_care.svg`) that represents the pet health tracking feature.
/// - Animated floating elements, including a heart, energy icon, grooming tools,
///   and nails, to add visual interest.
/// - Text elements that describe the pet health tracking feature, including a title
///   and a subtitle.
///
/// The animated elements are implemented using the `FloatingAnimation` widget,
/// which provides a subtle motion effect. The layout adapts to different
/// screen heights.
///
/// The `screenSize` parameter is used to adjust the layout and font sizes
/// based on the device's screen dimensions. The function also uses
/// `AppPalette` and `AppTextStyles` for consistent styling.
///
/// The widget utilizes:
/// - [SvgPicture] for displaying SVG images.
/// - [FloatingAnimation] for creating floating animations.
/// - [Stack] for layering widgets.
/// - [Positioned] for absolute positioning of widgets within the stack.
/// - [Text.rich] for creating text with multiple styles.

Widget firstOnBoardingPage(BuildContext context, Size screenSize) {
  return Column(
    children: [
      if (screenSize.height >= 675) Spacer(flex: 1),
      Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            'assets/illustrations/background_shape.svg',
            height: screenSize.height < 675 ? 325 : 350,
            colorFilter: ColorFilter.mode(
              AppPalette.surfaces(context),
              BlendMode.srcATop,
            ),
          ),
          FloatingAnimation(
            type: FloatingType.wave,
            duration: Duration(seconds: 10),
            floatStrength: 1.25,
            curve: Curves.linear,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                SvgPicture.asset(
                  'assets/illustrations/background_shape.svg',
                  height: screenSize.height < 675 ? 250 : 275,
                  colorFilter: ColorFilter.mode(
                    AppPalette.primary.withValues(alpha: 0.5),
                    BlendMode.srcATop,
                  ),
                ),
                Positioned(
                  bottom: -15,
                  child: SvgPicture.asset(
                    'assets/illustrations/pet_helth_care.svg',
                    height: screenSize.height < 675 ? 200 : 225,
                  ),
                ),

                // Custom bouncing heart
                Positioned(
                  top: 45,
                  right: 50,
                  child: FloatingAnimation(
                    type: FloatingType.wave,
                    duration: Duration(seconds: 10),
                    floatStrength: 2.5,
                    curve: Curves.linear,
                    child: Transform.rotate(
                      angle: math.pi / 12,
                      child: SvgPicture.asset(
                        'assets/illustrations/heart.svg',
                        height: 60,
                      ),
                    ),
                  ),
                ),
                // Custom bouncing Energy
                Positioned(
                  bottom: 20,
                  right: 25,
                  child: FloatingAnimation(
                    type: FloatingType.wave,
                    duration: Duration(seconds: 8),
                    floatStrength: 3.5,
                    curve: Curves.linear,
                    child: Transform.rotate(
                      angle: math.pi / 2,
                      child: Opacity(
                        opacity: .75,
                        child: SvgPicture.asset(
                          'assets/illustrations/blue_energy.svg',
                          height: 30,
                        ),
                      ),
                    ),
                  ),
                ),

                // Custom bouncing Nails
                Positioned(
                  bottom: 60,
                  left: 20,
                  child: FloatingAnimation(
                    type: FloatingType.wave,
                    duration: Duration(seconds: 12),
                    floatStrength: 2.75,
                    curve: Curves.linear,
                    child: Transform.rotate(
                      angle: -math.pi / 12,
                      child: Transform.flip(
                        flipX: true,
                        child: SvgPicture.asset(
                          'assets/illustrations/nails.svg',
                          height: 45,
                        ),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 20,
                  left: 60,
                  child: FloatingAnimation(
                    type: FloatingType.wave,
                    duration: Duration(seconds: 7),
                    floatStrength: 3.0,
                    curve: Curves.linear,
                    child: Transform.rotate(
                      angle: -math.pi / 12,
                      child: Opacity(
                        opacity: .75,
                        child: SvgPicture.asset(
                          'assets/illustrations/grooming_tools.svg',
                          height: 45,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      //const Spacer(flex: 3),
      VerticalSpacing.xl(context),

      /// Texts
      Padding(
        padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'onboarding_1_title'.tr,
                style: AppTextStyles.headingLarge.copyWith(
                  color: AppPalette.primaryText(context),
                  fontSize: 35,
                ),
              ),

              TextSpan(
                text: '\n${'onboarding_1_subtitle'.tr}',
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
